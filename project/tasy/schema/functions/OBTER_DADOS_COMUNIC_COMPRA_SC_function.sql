-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_dados_comunic_compra_sc ( nr_solic_compra_p bigint, cd_evento_p bigint, nr_seq_regra_evento_p bigint, ie_tipo_retorno_p text) RETURNS varchar AS $body$
DECLARE

 
nm_usuario_w			varchar(15) := '';
ds_titulo_w			varchar(80) := '';
ds_comunicacao_w			varchar(2000) := '';
qt_regra_comunic_w		integer;
ds_item_ww			varchar(2000);
ds_item_w			varchar(2000);
ds_observacao_w			solic_compra.ds_observacao%type;
cd_estabelecimento_w		integer;
dt_entrega_w			varchar(2000);
nm_pessoa_solic_w			varchar(100);

c01 CURSOR FOR 
SELECT	substr(a.cd_material || ' - ' || obter_desc_material(a.cd_material),1,2000) ds_material 
from	solic_compra_item a, 
	estrutura_material_v e 
where	a.cd_material = e.cd_material 
and	a.nr_solic_compra = nr_solic_compra_p;


BEGIN 
 
select	b.cd_estabelecimento, 
	substr(obter_nome_pf_pj(b.cd_pessoa_solicitante,null),1,100) nm_pessoa_solic, 
	b.nm_usuario, 
	b.ds_observacao 
into STRICT	cd_estabelecimento_w, 
	nm_pessoa_solic_w, 
	nm_usuario_w, 
	ds_observacao_w 
from	solic_compra b 
where	b.nr_solic_compra = nr_solic_compra_p;
 
select	count(*) 
into STRICT	qt_regra_comunic_w 
from	regra_envio_comunic_compra a, 
	regra_envio_comunic_evento b 
where	a.nr_sequencia = b.nr_seq_regra 
and	a.cd_funcao = 267 
and	b.cd_evento = cd_evento_p 
and	b.ie_situacao = 'A' 
and	a.cd_estabelecimento = cd_estabelecimento_w;
	 
open c01;
loop 
fetch c01 into 
	ds_item_w;
EXIT WHEN NOT FOUND; /* apply on c01 */
	ds_item_ww	:= substr(ds_item_ww || ds_item_w || chr(13),1,2000);
end loop;
close c01;
 
select	max(b.ds_titulo), 
	max(b.ds_comunicacao) ds_comunicacao 
into STRICT	ds_titulo_w, 
	ds_comunicacao_w 
from	regra_envio_comunic_compra a, 
	regra_envio_comunic_evento b 
where	a.nr_sequencia = b.nr_seq_regra 
and	b.cd_evento = cd_evento_p 
and	a.cd_estabelecimento = cd_estabelecimento_w 
and	b.nr_sequencia = nr_seq_regra_evento_p;
 
ds_comunicacao_w := substr(replace_macro(ds_comunicacao_w, '@usuario', nm_usuario_w), 1, 2000);
ds_comunicacao_w := substr(replace_macro(ds_comunicacao_w, '@nr_solic_compra',nr_solic_compra_p), 1, 2000);
ds_comunicacao_w := substr(replace_macro(ds_comunicacao_w, '@nm_solicitante', nm_pessoa_solic_w), 1, 2000);
ds_comunicacao_w := substr(replace_macro(ds_comunicacao_w, '@data', clock_timestamp()), 1, 2000);
ds_comunicacao_w := substr(replace_macro(ds_comunicacao_w, '@itens', ds_item_ww), 1, 2000);
ds_comunicacao_w := substr(replace_macro(ds_comunicacao_w, '@motivo', ''), 1, 2000);
ds_comunicacao_w := substr(replace_macro(ds_comunicacao_w, '@observacao', ds_observacao_w), 1, 2000);
 
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
-- REVOKE ALL ON FUNCTION obter_dados_comunic_compra_sc ( nr_solic_compra_p bigint, cd_evento_p bigint, nr_seq_regra_evento_p bigint, ie_tipo_retorno_p text) FROM PUBLIC;
