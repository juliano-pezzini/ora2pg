-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE rop_gerar_itens_nf (nr_seq_nf_p bigint, nr_item_nf_p bigint, cd_operacao_p bigint, cd_local_p bigint, nm_usuario_p text, cd_empresa_p bigint, cd_estabelecimento_p bigint, nr_seq_lote_movto_p INOUT bigint, ds_erro_p INOUT text) AS $body$
DECLARE

 
 
nr_seq_lote_roupa_w		bigint;
nr_seq_roupa_w			bigint;
qt_roupa_w			double precision;
qt_roupa_ww			double precision := 0;
ds_material_w			varchar(255);
ds_historico_w			varchar(4000);
ds_erro_w			varchar(255) := '';
cd_material_w			integer;
qt_roupa_nf_w			double precision;
cd_estabelecimento_w		integer;
nr_seq_lote_movto_w		bigint;
nr_nota_fiscal_w		varchar(255);
cd_operacao_w			bigint;


BEGIN 
 
nr_seq_lote_movto_w 	:= coalesce(nr_seq_lote_movto_p,0);
cd_operacao_w		:= coalesce(cd_operacao_p,0);
 
 
select	nr_nota_fiscal, 
	cd_material, 
	qt_item_estoque 
into STRICT	nr_nota_fiscal_w, 
	cd_material_w, 
	qt_roupa_nf_w 
from	nota_fiscal_item 
where	nr_sequencia = nr_seq_nf_p 
and	nr_item_nf = nr_item_nf_p;
 
select	cd_estabelecimento 
into STRICT	cd_estabelecimento_w 
from	nota_fiscal 
where	nr_sequencia = nr_seq_nf_p;
 
select	substr(ds_material,1,255) 
into STRICT	ds_material_w 
from	material 
where	cd_material = cd_material_w;
 
select	coalesce(max(nr_sequencia),0) 
into STRICT	nr_seq_lote_roupa_w 
from	rop_lote_roupa 
where	cd_material = cd_material_w 
and	cd_estabelecimento = cd_estabelecimento_w;
 
if (nr_seq_lote_roupa_w = 0) then 
 
	ds_erro_w	:= substr(WHEB_MENSAGEM_PCK.get_texto(281583) || cd_material_w || ' - ' || ds_material_w || '.',1,255);
else 
	select	coalesce(max(nr_sequencia),0) 
	into STRICT	nr_seq_roupa_w 
	from	rop_roupa 
	where	nr_seq_lote_roupa = nr_seq_lote_roupa_w 
	and	coalesce(dt_baixa::text, '') = '';
 
	if (nr_seq_roupa_w = 0) then 
 
		select	nextval('rop_roupa_seq') 
		into STRICT	nr_seq_roupa_w 
		;
 
		insert into rop_roupa( 
			nr_sequencia, 
			dt_atualizacao, 
			nm_usuario, 
			dt_atualizacao_nrec, 
			nm_usuario_nrec, 
			ie_situacao, 
			cd_empresa, 
			nr_seq_lote_roupa, 
			qt_roupa, 
			nr_seq_nota, 
			nr_seq_item_nf) 
		values (	nr_seq_roupa_w, 
			clock_timestamp(), 
			nm_usuario_p, 
			clock_timestamp(), 
			nm_usuario_p, 
			'A', 
			cd_empresa_p, 
			nr_seq_lote_roupa_w, 
			qt_roupa_nf_w, 
			nr_seq_nf_p, 
			nr_item_nf_p);
 
		ds_historico_w	:= 	substr(	WHEB_MENSAGEM_PCK.get_texto(281584) || qt_roupa_nf_w,1,4000);
 
		insert into rop_roupa_hist( 
			nr_sequencia, 
			dt_atualizacao, 
			nm_usuario, 
			dt_atualizacao_nrec, 
			nm_usuario_nrec, 
			nr_seq_roupa, 
			dt_historico, 
			ds_titulo, 
			ds_historico, 
			ie_tipo, 
			dt_liberacao, 
			nm_usuario_lib) 
		values (	nextval('rop_roupa_hist_seq'), 
			clock_timestamp(), 
			nm_usuario_p, 
			clock_timestamp(), 
			nm_usuario_p, 
			nr_seq_roupa_w, 
			clock_timestamp(), 
			WHEB_MENSAGEM_PCK.get_texto(281585), 
			ds_historico_w, 
			'S', 
			clock_timestamp(), 
			nm_usuario_p);
	else 
 
		select	coalesce(qt_roupa,0) 
		into STRICT	qt_roupa_w 
		from	rop_roupa 
		where	nr_sequencia = nr_seq_roupa_w;
 
		qt_roupa_ww	:= qt_roupa_w + qt_roupa_nf_w;
 
		update	rop_roupa 
		set	qt_roupa = qt_roupa_ww, 
			nr_seq_nota = nr_seq_nf_p, 
			nr_seq_item_nf = nr_item_nf_p 
		where	nr_sequencia = nr_seq_roupa_w;
 
		ds_historico_w	:= 	substr(	WHEB_MENSAGEM_PCK.get_texto(281586) || chr(13) || chr(10) || 
						WHEB_MENSAGEM_PCK.get_texto(281587) || coalesce(qt_roupa_w,0)	|| chr(13) || chr(10) || 
						WHEB_MENSAGEM_PCK.get_texto(281588) || qt_roupa_ww ,1,4000);
 
		insert into rop_roupa_hist( 
			nr_sequencia, 
			dt_atualizacao, 
			nm_usuario, 
			dt_atualizacao_nrec, 
			nm_usuario_nrec, 
			nr_seq_roupa, 
			dt_historico, 
			ds_titulo, 
			ds_historico, 
			ie_tipo, 
			dt_liberacao, 
			nm_usuario_lib 
			) 
		values (	nextval('rop_roupa_hist_seq'), 
			clock_timestamp(), 
			nm_usuario_p, 
			clock_timestamp(), 
			nm_usuario_p, 
			nr_seq_roupa_w, 
			clock_timestamp(), 
			WHEB_MENSAGEM_PCK.get_texto(281589), 
			ds_historico_w, 
			'S', 
			clock_timestamp(), 
			nm_usuario_p);
	end if;
 
	if (cd_operacao_w > 0) then 
 
		if (nr_seq_lote_movto_w = 0) then 
 
			select	nextval('rop_lote_movto_seq') 
			into STRICT	nr_seq_lote_movto_w 
			;
 
			insert into rop_lote_movto( 
				nr_sequencia, 
				cd_estabelecimento, 
				dt_atualizacao, 
				nm_usuario, 
				dt_atualizacao_nrec, 
				nm_usuario_nrec, 
				dt_registro, 
				nr_seq_operacao, 
				cd_pessoa_fisica, 
				nr_seq_local, 
				dt_liberacao, 
				ds_observacao) 
			values (	nr_seq_lote_movto_w, 
				cd_estabelecimento_p, 
				clock_timestamp(), 
				nm_usuario_p, 
				clock_timestamp(), 
				nm_usuario_p, 
				trunc(clock_timestamp(),'dd'), 
				cd_operacao_p, 
				obter_pessoa_fisica_usuario(nm_usuario_p,'C'), 
				cd_local_p, 
				null, 
				WHEB_MENSAGEM_PCK.get_texto(281590) || nr_nota_fiscal_w || '.');
		end if;
 
		insert into rop_movto_roupa( 
			nr_sequencia, 
			nr_seq_lote, 
			dt_atualizacao, 
			nm_usuario, 
			dt_atualizacao_nrec, 
			nm_usuario_nrec, 
			nr_seq_roupa, 
			dt_origem, 
			cd_estabelecimento, 
			ie_oper_correta, 
			qt_roupa) 
		values (	nextval('rop_movto_roupa_seq'), 
			nr_seq_lote_movto_w, 
			clock_timestamp(), 
			nm_usuario_p, 
			clock_timestamp(), 
			nm_usuario_p, 
			nr_seq_roupa_w, 
			trunc(clock_timestamp(),'dd'), 
			cd_estabelecimento_w, 
			'S', 
			qt_roupa_nf_w);
 
	end if;
end if;
 
ds_erro_p 		:= ds_erro_w;
nr_seq_lote_movto_p	:= nr_seq_lote_movto_w;
 
commit;
 
end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE rop_gerar_itens_nf (nr_seq_nf_p bigint, nr_item_nf_p bigint, cd_operacao_p bigint, cd_local_p bigint, nm_usuario_p text, cd_empresa_p bigint, cd_estabelecimento_p bigint, nr_seq_lote_movto_p INOUT bigint, ds_erro_p INOUT text) FROM PUBLIC;

