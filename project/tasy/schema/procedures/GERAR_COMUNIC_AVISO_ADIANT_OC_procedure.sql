-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE gerar_comunic_aviso_adiant_oc ( nr_ordem_compra_p bigint, nm_usuario_p text) AS $body$
DECLARE

 
 
ds_titulo_w		varchar(80);
ds_comunicado_w		varchar(4000);
nr_adiantamento_w		bigint;
cd_cgc_fornecedor_w	varchar(14);
ds_fornecedor_w		varchar(100);
nm_comprador_w		comprador.nm_guerra%type;
dt_adiantamento_w		varchar(15);
vl_adiantamento_w		varchar(30);
vl_vinculado_w		varchar(30);
nr_seq_regra_w		bigint;
cd_perfil_w		varchar(10);
cd_estabelecimento_w	smallint;
nr_seq_classif_w		bigint;
nr_sequencia_w		bigint;
nm_usuarios_adic_w	varchar(255);
qt_existe_w		bigint;
ie_ci_lida_w		varchar(1);
nr_titulo_original_w		bigint;
/* Se tiver setor na regra, envia CI para os setores */
ds_setor_adicional_w       varchar(2000) := '';
/* Campos da regra Usuário da Regra */
cd_setor_regra_usuario_w	integer;
	
c01 CURSOR FOR 
SELECT	nr_adiantamento 
from	ordem_compra_adiant_pago 
where	nr_ordem_compra = nr_ordem_compra_p;

c05 CURSOR FOR 
SELECT	coalesce(a.cd_setor_atendimento,0) cd_setor_atendimento 
from	regra_envio_comunic_usu a 
where	a.nr_seq_evento = nr_seq_regra_w;


BEGIN 
 
select	count(*) 
into STRICT	qt_existe_w 
from	ordem_compra_adiant_pago 
where	nr_ordem_compra = nr_ordem_compra_p;
 
if (qt_existe_w > 0) then 
	select	cd_estabelecimento 
	into STRICT	cd_estabelecimento_w 
	from	ordem_compra 
	where	nr_ordem_compra = nr_ordem_compra_p;
 
	select	coalesce(max(b.nr_sequencia), 0), 
		max(cd_perfil), 
		max(nm_usuarios_adic) 
	into STRICT	nr_seq_regra_w, 
		cd_perfil_w, 
		nm_usuarios_adic_w 
	from	regra_envio_comunic_compra a, 
		regra_envio_comunic_evento b 
	where	a.nr_sequencia = b.nr_seq_regra 
	and	a.cd_funcao = 917 
	and	b.cd_evento = 25 
	and	b.ie_situacao = 'A' 
	and	cd_estabelecimento = cd_estabelecimento_w 
	and	substr(obter_se_envia_ci_regra_compra(b.nr_sequencia,nr_ordem_compra_p,'OC',obter_perfil_ativo,nm_usuario_p,null),1,1) = 'S';
end if;
 
if (cd_perfil_w IS NOT NULL AND cd_perfil_w::text <> '') then 
	cd_perfil_w := cd_perfil_w ||',';
end if;	
 
 
if (qt_existe_w > 0) and (nr_seq_regra_w > 0) then	 
	 
	open C01;
	loop 
	fetch C01 into	 
		nr_adiantamento_w;
	EXIT WHEN NOT FOUND; /* apply on C01 */
		begin	 
	 
		select	cd_cgc_fornecedor, 
			substr(obter_nome_pf_pj(null,cd_cgc_fornecedor),1,100), 
			substr(sup_obter_nome_comprador(cd_estabelecimento, cd_comprador),1,80) 
		into STRICT	cd_cgc_fornecedor_w, 
			ds_fornecedor_w, 
			nm_comprador_w 
		from	ordem_compra 
		where	nr_ordem_compra = nr_ordem_compra_p;
		 
		select	PKG_DATE_FORMATERS.TO_VARCHAR(dt_adiantamento, 'shortDate', cd_estabelecimento_w, nm_usuario_p), 
			campo_mascara_virgula_casas(vl_adiantamento,4), 
			nr_titulo_original 
		into STRICT	dt_adiantamento_w, 
			vl_adiantamento_w, 
			nr_titulo_original_w 
		from	adiantamento_pago 
		where	nr_adiantamento = nr_adiantamento_w;
		 
		select	campo_mascara_virgula_casas(vl_vinculado,4) 
		into STRICT	vl_vinculado_w 
		from	ordem_compra_adiant_pago 
		where	nr_ordem_compra = nr_ordem_compra_p 
		and	nr_adiantamento = nr_adiantamento_w;
 
		open C05;
		loop 
		fetch C05 into	 
			cd_setor_regra_usuario_w;
		EXIT WHEN NOT FOUND; /* apply on C05 */
			begin 
			if (cd_setor_regra_usuario_w <> 0) and (obter_se_contido_char(cd_setor_regra_usuario_w, ds_setor_adicional_w) = 'N') then 
				ds_setor_adicional_w := substr(ds_setor_adicional_w || cd_setor_regra_usuario_w || ',',1,2000);
			end if;
			end;
		end loop;
		close C05;
 
		select	max(substr(ds_titulo, 1, 80)), 
			max(substr(ds_comunicacao, 1, 4000)) ds_comunicacao 
		into STRICT	ds_titulo_w, 
			ds_comunicado_w 
		from	regra_envio_comunic_evento 
		where	nr_sequencia = nr_seq_regra_w;
 
		ds_comunicado_w	:= substr(replace_macro(ds_comunicado_w, '@nr_adiantamento', nr_adiantamento_w), 1, 4000);
		ds_comunicado_w	:= substr(replace_macro(ds_comunicado_w, '@cnpj', cd_cgc_fornecedor_w), 1, 4000);
		ds_comunicado_w	:= substr(replace_macro(ds_comunicado_w, '@razao', ds_fornecedor_w), 1, 4000);
		ds_comunicado_w	:= substr(replace_macro(ds_comunicado_w, '@valor_adiant', vl_adiantamento_w), 1, 4000);
		ds_comunicado_w	:= substr(replace_macro(ds_comunicado_w, '@valor_vinc', vl_vinculado_w), 1, 4000);
		ds_comunicado_w	:= substr(replace_macro(ds_comunicado_w, '@data', dt_adiantamento_w), 1, 4000);
		ds_comunicado_w	:= substr(replace_macro(ds_comunicado_w, '@ordem', nr_ordem_compra_p), 1, 4000);
		ds_comunicado_w	:= substr(replace_macro(ds_comunicado_w, '@nr_titulo', nr_titulo_original_w), 1, 4000);
		ds_comunicado_w	:= substr(replace_macro(ds_comunicado_w, '@comprador', nm_comprador_w), 1, 4000);
		ds_comunicado_w	:= substr(ds_comunicado_w, 1, 4000);
 
		select	coalesce(ie_ci_lida,'N') 
		into STRICT	ie_ci_lida_w 
		from 	regra_envio_comunic_evento 
		where 	nr_sequencia = nr_seq_regra_w;
 
		select	obter_classif_comunic('F') 
		into STRICT	nr_seq_classif_w 
		;
			 
		select	nextval('comunic_interna_seq') 
		into STRICT	nr_sequencia_w 
		;			
				 
		insert into comunic_interna( 
			dt_comunicado, 
			ds_titulo, 
			ds_comunicado, 
			nm_usuario, 
			dt_atualizacao, 
			ie_geral, 
			nm_usuario_destino, 
			nr_sequencia, 
			ie_gerencial, 
			nr_seq_classif, 
			dt_liberacao, 
			ds_perfil_adicional, 
			ds_setor_adicional) 
		values (	clock_timestamp(), 
			ds_titulo_w, 
			ds_comunicado_w, 
			nm_usuario_p, 
			clock_timestamp(), 
			'N', 
			nm_usuarios_adic_w, 
			nr_sequencia_w, 
			'N', 
			nr_seq_classif_w, 
			clock_timestamp(), 
			cd_perfil_w, 
			ds_setor_adicional_w);
 
		/*Para que a comunicação seja gerada como lida ao próprio usuário */
 
		if (ie_ci_lida_w = 'S') then 
			insert into comunic_interna_lida(nr_sequencia,nm_usuario,dt_atualizacao)values (nr_sequencia_w,nm_usuario_p,clock_timestamp());
		end if;	
 
		end;
	end loop;
	close C01;
end if;
 
end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE gerar_comunic_aviso_adiant_oc ( nr_ordem_compra_p bigint, nm_usuario_p text) FROM PUBLIC;
