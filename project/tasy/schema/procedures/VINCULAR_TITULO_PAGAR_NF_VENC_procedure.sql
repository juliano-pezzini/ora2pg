-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE vincular_titulo_pagar_nf_venc ( nr_sequencia_p bigint, nr_titulo_p bigint, dt_vencimento_p timestamp, nm_usuario_p text) AS $body$
DECLARE

 
qt_existe_w		integer;
vl_titulo_w		double precision;
vl_saldo_titulo_w		double precision;
vl_vencimento_w		double precision;
nr_nota_fiscal_w		varchar(20);
dt_venc_titulo_w		timestamp;
ds_observacao_w		varchar(255);
nr_seq_alt_venc_w		bigint;
cd_darf_w		varchar(10);
cd_tributo_w		bigint;
vl_base_adic_w		double precision;
vl_base_calculo_w		double precision;
vl_base_nao_retido_w	double precision;
vl_reducao_w		double precision;
vl_desc_base_w		double precision;
vl_trib_adic_w		double precision;
vl_nao_retido_w		double precision;
vl_imposto_w		double precision;
ie_gerar_tributos_w	varchar(1);
cd_estabelecimento_w	smallint;

c01 CURSOR FOR 
SELECT	a.cd_darf, 
	a.cd_tributo, 
	a.vl_base_adic, 
	a.vl_base_calculo, 
	a.vl_base_nao_retido, 
	a.vl_reducao, 
	a.vl_desc_base, 
	a.vl_trib_adic, 
	a.vl_trib_nao_retido, 
	a.vl_tributo 
from	nota_fiscal_venc_trib a 
where	a.nr_sequencia	= nr_sequencia_p 
and	a.dt_vencimento	= dt_vencimento_p;


BEGIN 
 
select	count(*) 
into STRICT	qt_existe_w 
from	nota_fiscal_venc 
where	dt_vencimento 	= dt_vencimento 
and	nr_sequencia	= nr_sequencia_p 
and	coalesce(nr_titulo_pagar::text, '') = '';
 
if (qt_existe_w = 0) then 
	CALL wheb_mensagem_pck.exibir_mensagem_abort(265456,'');
	--Mensagem: O vencimento selecionado já possui título gerado para esta nota. 
end if;
 
select	count(*) 
into STRICT	qt_existe_w 
from	titulo_pagar 
where	nr_titulo = nr_titulo_p;
 
if (qt_existe_w = 0) then 
	CALL wheb_mensagem_pck.exibir_mensagem_abort(265458,'');
	--Mensagem: O título selecionado não existe. 
end if;
 
select	vl_titulo, 
	vl_saldo_titulo, 
	cd_estabelecimento 
into STRICT	vl_titulo_w, 
	vl_saldo_titulo_w, 
	cd_estabelecimento_w 
from	titulo_pagar 
where	nr_titulo = nr_titulo_p;
 
select	vl_vencimento 
into STRICT	vl_vencimento_w 
from	nota_fiscal_venc 
where	dt_vencimento = dt_vencimento_p 
and	nr_sequencia = nr_sequencia_p;
 
if (coalesce(vl_vencimento_w,0) <> coalesce(vl_titulo_w,0)) then 
	CALL wheb_mensagem_pck.exibir_mensagem_abort(265461,'');
	--Mensagem: O valor do vencimento não bate com o valor do título a ser vinculado. 
end if;
 
select	substr(nr_nota_fiscal,1,20) 
into STRICT	nr_nota_fiscal_w 
from	nota_fiscal 
where	nr_sequencia 		= nr_sequencia_p;
 
ie_gerar_tributos_w := obter_param_usuario(40, 141, obter_perfil_ativo, nm_usuario_p, cd_estabelecimento_w, ie_gerar_tributos_w);
 
if (ie_gerar_tributos_w = 'S') then 
	open c01;
	loop 
	fetch c01 into	 
		cd_darf_w, 
		cd_tributo_w, 
		vl_base_adic_w, 
		vl_base_calculo_w, 
		vl_base_nao_retido_w, 
		vl_reducao_w, 
		vl_desc_base_w, 
		vl_trib_adic_w, 
		vl_nao_retido_w, 
		vl_imposto_w;
	EXIT WHEN NOT FOUND; /* apply on c01 */
 
		insert into titulo_pagar_imposto( 
			cd_darf, 
			cd_tributo, 
			dt_atualizacao, 
			dt_imposto, 
			ie_pago_prev, 
			ie_vencimento, 
			nm_usuario, 
			nr_sequencia, 
			nr_titulo, 
			vl_base_adic, 
			vl_base_calculo, 
			vl_base_nao_retido, 
			vl_reducao, 
			vl_desc_base, 
			vl_trib_adic, 
			vl_nao_retido, 
			vl_imposto) 
		values ( 
			cd_darf_w, 
			cd_tributo_w, 
			clock_timestamp(), 
			clock_timestamp(), 
			'V', 
			'V', 
			nm_usuario_p, 
			nextval('titulo_pagar_imposto_seq'), 
			nr_titulo_p, 
			vl_base_adic_w, 
			vl_base_calculo_w, 
			vl_base_nao_retido_w, 
			vl_reducao_w, 
			vl_desc_base_w, 
			vl_trib_adic_w, 
			vl_nao_retido_w, 
			vl_imposto_w);
 
	end loop;
	close c01;
 
end if;
 
update	titulo_pagar 
set	dt_atualizacao		= clock_timestamp(), 
	nm_usuario		= nm_usuario_p, 
	nr_seq_nota_fiscal		= nr_sequencia_p, 
	nr_documento		= nr_nota_fiscal_w 
where	nr_titulo			= nr_titulo_p;
 
select	count(*) 
into STRICT	qt_existe_w 
from	titulo_pagar_imposto 
where	nr_titulo = nr_titulo_p;
 
if (qt_existe_w <> 0) then 
	update	titulo_pagar 
	set	nr_documento		= nr_nota_fiscal_w, 
		dt_atualizacao		= clock_timestamp(), 
		nm_usuario		= nm_usuario_p 
	where	nr_titulo_original		= nr_titulo_p;
end if;
 
update	nota_fiscal 
set	ds_observacao = substr(WHEB_MENSAGEM_PCK.get_texto(457444,'nr_titulo_p='|| nr_titulo_p ||';dt_vencimento_p='|| dt_vencimento_p ||';ds_observacao='|| ds_observacao),1,4000) 
where	nr_sequencia = nr_sequencia_p;
 
CALL gerar_historico_nota_fiscal(nr_sequencia_p, nm_usuario_p, '5', WHEB_MENSAGEM_PCK.get_texto(457449,'nr_titulo_p='|| nr_titulo_p ||';dt_vencimento_p='|| dt_vencimento_p));
 
select	dt_vencimento_atual 
into STRICT	dt_venc_titulo_w 
from	titulo_pagar 
where	nr_titulo = nr_titulo_p;
 
update	nota_fiscal_venc 
set	nr_titulo_pagar	= nr_titulo_p, 
    nr_titulo_vinc = nr_titulo_p 
where	nr_sequencia	= nr_sequencia_p 
and	dt_vencimento	= dt_vencimento_p;
 
if (dt_vencimento_p <> dt_venc_titulo_w) then 
	begin 
	ds_observacao_w := OBTER_DESC_EXPRESSAO(345019)||' ' || nr_sequencia_p;
 
	CALL alterar_venc_titulo(	nr_titulo_p, 
				dt_vencimento_p, 
				'CP', 
				null, 
				null, 
				null, 
				null, 
				null, 
				null, 
				nm_usuario_p, 
				ds_observacao_w);
 
	select	max(nr_sequencia) 
	into STRICT	nr_seq_alt_venc_w 
	from	titulo_pagar_alt_venc 
	where	nr_titulo	= nr_titulo_p;
 
	CALL atualizar_venc_titulo_imposto(nr_titulo_p, 
				nr_seq_alt_venc_w, 
				nm_usuario_p);
	end;
end if;
 
CALL VINCULAR_TIT_TRIB_REPASSE_NF(nr_sequencia_p, nm_usuario_p);
 
commit;
 
end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE vincular_titulo_pagar_nf_venc ( nr_sequencia_p bigint, nr_titulo_p bigint, dt_vencimento_p timestamp, nm_usuario_p text) FROM PUBLIC;
