-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_dados_email_solic_transf (nr_ordem_compra_p bigint, nr_documento_p bigint, nr_seq_regra_p bigint, ie_tipo_retorno_p text) RETURNS varchar AS $body$
DECLARE


dt_ordem_compra_w		timestamp;
ie_documento_w			varchar(1);
nr_documento_w			bigint;
nm_usuario_w			varchar(15) := '';
ds_titulo_w			varchar(255) := '';
ds_comunicacao_w			varchar(2000) := '';
qt_regra_comunic_w		integer;
ds_item_ww			varchar(2000);
ds_item_w			varchar(2000);
ds_motivo_w			varchar(50);
ds_observacao_w			varchar(255);
cd_estabelecimento_w		integer;
dt_baixa_w			timestamp;
dt_aprovacao_w			timestamp;
dt_liberacao_w			timestamp;
dt_liberacao_hist_w			timestamp;
dt_entrega_www			timestamp;
dt_entrega_w			varchar(2000);
ds_motivo_baixa_w			varchar(255);
ds_motivo_cancelamento_w		varchar(100);
dt_entrega_ww			varchar(2000);
nm_pessoa_solic_w			varchar(100);
nm_pessoa_solicitante_w		varchar(100);
ds_estabelecimento_w		varchar(100);
ds_estab_transf_w			varchar(100);
dt_liberacao_ordem_w		timestamp;
cd_centro_custo_w			integer;
ds_centro_custo_w			varchar(80);
ds_local_estoque_w		varchar(100);
ds_local_transf_w			varchar(100);
cd_material_w			integer;
ds_material_w			varchar(255);
qt_material_w			double precision;
qt_atendido_w			double precision;
ds_status_item_w			varchar(150);
cd_unidade_medida_w		varchar(30);
ds_itens_w			varchar(1000);
nr_nota_fiscal_w			varchar(255);
cd_serie_nf_w			nota_fiscal.cd_serie_nf%type;
ie_tipo_mensagem_w		bigint;

C01 CURSOR FOR
SELECT	cd_material,
	substr(obter_desc_material(cd_material),1,255),
	qt_item_nf,
	cd_unidade_medida_compra
from	nota_fiscal_item
where	nr_ordem_compra = nr_ordem_compra_p
and	nr_sequencia = nr_documento_p;


BEGIN
select	substr(obter_nome_pessoa_fisica(cd_pessoa_solicitante,null),1,100),
	substr(obter_nome_estabelecimento_rel(cd_estabelecimento),1,100),
	substr(obter_nome_estabelecimento_rel(cd_estab_transf),1,100),
	substr(obter_desc_local_estoque(cd_local_entrega),1,100),
	substr(obter_desc_local_estoque(cd_local_transf),1,100),
	substr(obter_desc_centro_custo(cd_centro_custo),1,80),
	dt_ordem_compra,
	dt_entrega,
	dt_liberacao,
	dt_aprovacao,
	dt_baixa,
	cd_estabelecimento
into STRICT	nm_pessoa_solicitante_w,
	ds_estabelecimento_w,
	ds_estab_transf_w,
	ds_local_estoque_w,
	ds_local_transf_w,
	ds_centro_custo_w,
	dt_ordem_compra_w,
	dt_entrega_www,
	dt_liberacao_w,
	dt_aprovacao_w,
	dt_baixa_w,
	cd_estabelecimento_w
from	ordem_compra
where	nr_ordem_compra = nr_ordem_compra_p;

select	a.ds_assunto,
	a.ds_mensagem_padrao,
	a.ie_tipo_mensagem
into STRICT	ds_titulo_w,
	ds_comunicacao_w,
	ie_tipo_mensagem_w
from	regra_envio_email_compra a
where	a.nr_sequencia = nr_seq_regra_p;

ds_titulo_w := substr(replace_macro(ds_titulo_w, '@nr_solic_transf', nr_ordem_compra_p), 1, 255);
ds_titulo_w := substr(replace_macro(ds_titulo_w, '@solicitante', nm_pessoa_solicitante_w), 1, 255);
ds_titulo_w := substr(replace_macro(ds_titulo_w, '@estab_solic', ds_estabelecimento_w), 1, 255);
ds_titulo_w := substr(replace_macro(ds_titulo_w, '@estab_atende', ds_estab_transf_w), 1, 255);
ds_titulo_w := substr(replace_macro(ds_titulo_w, '@local_entrega', ds_local_estoque_w), 1, 255);
ds_titulo_w := substr(replace_macro(ds_titulo_w, '@local_atende', ds_local_transf_w), 1, 255);
ds_titulo_w := substr(replace_macro(ds_titulo_w, '@centro_custo', ds_centro_custo_w), 1, 255);
ds_titulo_w := substr(replace_macro(ds_titulo_w, '@dt_ordem', PKG_DATE_FORMATERS.TO_VARCHAR(dt_ordem_compra_w, 'shortDate', cd_estabelecimento_w, nm_usuario_w)), 1, 255);
ds_titulo_w := substr(replace_macro(ds_titulo_w, '@dt_liberação', PKG_DATE_FORMATERS.TO_VARCHAR(dt_liberacao_w, 'timestamp', cd_estabelecimento_w, nm_usuario_w)), 1, 255);
ds_titulo_w := substr(replace_macro(ds_titulo_w, '@dt_aprovação', PKG_DATE_FORMATERS.TO_VARCHAR(dt_aprovacao_w, 'timestamp', cd_estabelecimento_w, nm_usuario_w)), 1, 255);
ds_titulo_w := substr(replace_macro(ds_titulo_w, '@dt_baixa', PKG_DATE_FORMATERS.TO_VARCHAR(dt_baixa_w, 'timestamp', cd_estabelecimento_w, nm_usuario_w)), 1, 255);
ds_titulo_w := substr(replace_macro(ds_titulo_w, '@dt_entrega', PKG_DATE_FORMATERS.TO_VARCHAR(dt_entrega_www, 'shortDate', cd_estabelecimento_w, nm_usuario_w)), 1, 255);

ds_comunicacao_w := substr(replace_macro(ds_comunicacao_w, '@nr_solic_transf', nr_ordem_compra_p), 1, 2000);
ds_comunicacao_w := substr(replace_macro(ds_comunicacao_w, '@solicitante', nm_pessoa_solicitante_w), 1, 2000);
ds_comunicacao_w := substr(replace_macro(ds_comunicacao_w, '@estab_solic', ds_estabelecimento_w), 1, 2000);
ds_comunicacao_w := substr(replace_macro(ds_comunicacao_w, '@estab_atende', ds_estab_transf_w), 1, 2000);
ds_comunicacao_w := substr(replace_macro(ds_comunicacao_w, '@local_entrega', ds_local_estoque_w), 1, 2000);
ds_comunicacao_w := substr(replace_macro(ds_comunicacao_w, '@local_atende', ds_local_transf_w), 1, 2000);
ds_comunicacao_w := substr(replace_macro(ds_comunicacao_w, '@centro_custo', ds_centro_custo_w), 1, 2000);
ds_comunicacao_w := substr(replace_macro(ds_comunicacao_w, '@dt_ordem', PKG_DATE_FORMATERS.TO_VARCHAR(dt_ordem_compra_w, 'shortDate', cd_estabelecimento_w, nm_usuario_w)), 1, 2000);
ds_comunicacao_w := substr(replace_macro(ds_comunicacao_w, '@dt_liberação', PKG_DATE_FORMATERS.TO_VARCHAR(dt_liberacao_w, 'timestamp', cd_estabelecimento_w, nm_usuario_w)), 1, 2000);
ds_comunicacao_w := substr(replace_macro(ds_comunicacao_w, '@dt_aprovação', PKG_DATE_FORMATERS.TO_VARCHAR(dt_aprovacao_w, 'timestamp', cd_estabelecimento_w, nm_usuario_w)), 1, 2000);
ds_comunicacao_w := substr(replace_macro(ds_comunicacao_w, '@dt_baixa', PKG_DATE_FORMATERS.TO_VARCHAR(dt_baixa_w, 'timestamp', cd_estabelecimento_w, nm_usuario_w)), 1, 2000);
ds_comunicacao_w := substr(replace_macro(ds_comunicacao_w, '@dt_entrega', PKG_DATE_FORMATERS.TO_VARCHAR(dt_entrega_www, 'shortDate', cd_estabelecimento_w, nm_usuario_w)), 1, 2000);

if (ie_tipo_mensagem_w = 42) and (coalesce(nr_documento_p,0) > 0) and (ie_tipo_retorno_p = 'M') then
	begin
	select	cd_material,
		substr(obter_desc_material(cd_material),1,255),
		qt_material,
		obter_qt_oci_trans_nota(nr_ordem_compra,nr_item_oci,'S'),
		substr(obter_status_item_transf(nr_ordem_compra,nr_item_oci),1,150)
	into STRICT	cd_material_w,
		ds_material_w,
		qt_material_w,
		qt_atendido_w,
		ds_status_item_w
	from	ordem_compra_item
	where	nr_ordem_compra = nr_ordem_compra_p
	and	nr_item_oci = nr_documento_p;

		ds_comunicacao_w := substr(replace_macro(ds_comunicacao_w, '@cd_material', cd_material_w),1,2000);
		ds_comunicacao_w := substr(replace_macro(ds_comunicacao_w, '@ds_material', ds_material_w),1,2000);
		ds_comunicacao_w := substr(replace_macro(ds_comunicacao_w, '@qt_material', qt_material_w),1,2000);
		ds_comunicacao_w := substr(replace_macro(ds_comunicacao_w, '@qt_atendido', qt_atendido_w),1,2000);
		ds_comunicacao_w := substr(replace_macro(ds_comunicacao_w, '@ds_status_item', ds_status_item_w),1,2000);
	end;
elsif (ie_tipo_mensagem_w in (43,44)) and (coalesce(nr_documento_p,0) > 0) and (ie_tipo_retorno_p = 'M') then
	begin
	select	nr_nota_fiscal,
		cd_serie_nf
	into STRICT	nr_nota_fiscal_w,
		cd_serie_nf_w
	from	nota_fiscal
	where	nr_sequencia = nr_documento_p;

	open C01;
	loop
	fetch C01 into
		cd_material_w,
		ds_material_w,
		qt_material_w,
		cd_unidade_medida_w;
	EXIT WHEN NOT FOUND; /* apply on C01 */
		ds_itens_w := 	substr(ds_item_w ||
				'['||cd_material_w||']'||substr(ds_material_w,1,100)||
				' , ' || OBTER_DESC_EXPRESSAO(607194) || ' '||qt_material_w||' '||cd_unidade_medida_w||chr(13)||chr(10),1,1000);				-- 607194: 'Qtde:'
	end loop;
	close C01;
		ds_comunicacao_w := substr(replace_macro(ds_comunicacao_w, '@nr_nota_fiscal', nr_nota_fiscal_w), 1, 2000);
		ds_comunicacao_w := substr(replace_macro(ds_comunicacao_w, '@cd_serie_nf', cd_serie_nf_w), 1, 2000);
		ds_comunicacao_w := substr(replace_macro(ds_comunicacao_w, '@itens', ds_itens_w), 1, 2000);
	end;
end if;

if (ie_tipo_retorno_p = 'M') then
	return ds_comunicacao_w;
elsif (ie_tipo_retorno_p = 'T') then
	return ds_titulo_w;
end if;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_dados_email_solic_transf (nr_ordem_compra_p bigint, nr_documento_p bigint, nr_seq_regra_p bigint, ie_tipo_retorno_p text) FROM PUBLIC;

