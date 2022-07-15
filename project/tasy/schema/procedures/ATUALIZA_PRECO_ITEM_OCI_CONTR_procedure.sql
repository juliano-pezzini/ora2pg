-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE atualiza_preco_item_oci_contr ( nr_ordem_compra_p bigint, nr_item_oci_p bigint, vl_contrato_p bigint default 0, cd_estabelecimento_p bigint DEFAULT NULL, nm_usuario_p text DEFAULT NULL, ds_retorno_p INOUT text DEFAULT NULL) AS $body$
DECLARE


cd_cgc_fornecedor_w		varchar(14);
cd_pessoa_fisica_w		varchar(10);
vl_contrato_w			double precision;
vl_unitario_material_w		double precision;
cd_material_w			bigint;
ds_retorno_w			varchar(255);
						

BEGIN

ds_retorno_w := '';

select	coalesce(cd_cgc_fornecedor,'0'),
	coalesce(cd_pessoa_fisica,'0')
into STRICT	cd_cgc_fornecedor_w,
	cd_pessoa_fisica_w
from	ordem_compra
where	nr_ordem_compra = nr_ordem_compra_p;

select	coalesce(max(cd_material),0),
	max(vl_unitario_material)
into STRICT	cd_material_w,
	vl_unitario_material_w
from	ordem_compra_item
where	nr_ordem_compra = nr_ordem_compra_p
and	nr_item_oci = nr_item_oci_p;

if (cd_material_w > 0) then

	vl_contrato_w := coalesce(vl_contrato_p, 0);
	
	if (vl_contrato_w = 0) then

		select	coalesce(min(b.vl_pagto),0)
		into STRICT	vl_contrato_w
		from	contrato a,
			contrato_regra_nf b
		where	a.nr_sequencia = b.nr_seq_contrato
		and coalesce(b.vl_pagto,0) > 0
		and	a.ie_situacao = 'A'
		and	a.cd_estabelecimento = cd_estabelecimento_p
		and	((cd_cgc_fornecedor_w = '0')  or
			((cd_cgc_fornecedor_w <> '0') and (obter_se_contrato_do_cnpj(a.nr_Sequencia, cd_cgc_fornecedor_w,'OC') = 'S')))
		and	((cd_pessoa_fisica_w = '0')  or
			((cd_pessoa_fisica_w <> '0') and (obter_se_contrato_pessoa(a.nr_Sequencia, cd_pessoa_fisica_w,'OC') = 'S')))
		and (trunc(clock_timestamp()) between trunc(dt_inicio) and trunc(coalesce(dt_fim,clock_timestamp())))
		and	b.cd_material = cd_material_w
		and	((coalesce(dt_inicio_vigencia::text, '') = '') or (coalesce(dt_fim_vigencia::text, '') = '') or (clock_timestamp() between dt_inicio_vigencia and fim_dia(dt_fim_vigencia)))
        and (coalesce(b.ie_situacao::text, '') = '' or b.ie_situacao = 'A');
	end if;	
	
	if (vl_contrato_w > 0) then
		
		update	ordem_compra_item
		set	vl_unitario_material = vl_contrato_w,
			vl_total_item = round((qt_material * vl_contrato_w)::numeric,4)
		where	nr_ordem_compra = nr_ordem_compra_p
		and	nr_item_oci = nr_item_oci_p;
				
		CALL inserir_historico_ordem_compra(
				nr_ordem_compra_p,
				null,
				WHEB_MENSAGEM_PCK.get_texto(297536),
				substr(WHEB_MENSAGEM_PCK.get_texto(297539,'CD_MATERIAL_W=' || cd_material_w || ';' || 'VL_UNITARIO_MATERIAL_W=' || campo_mascara_virgula(vl_unitario_material_w) || ';' ||
								'VL_CONTRATO_W=' || vl_contrato_w),1,4000),
				nm_usuario_p);
	else
		ds_retorno_w := WHEB_MENSAGEM_PCK.get_texto(297540);
	end if;
end if;

ds_retorno_p := ds_retorno_w;

commit;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE atualiza_preco_item_oci_contr ( nr_ordem_compra_p bigint, nr_item_oci_p bigint, vl_contrato_p bigint default 0, cd_estabelecimento_p bigint DEFAULT NULL, nm_usuario_p text DEFAULT NULL, ds_retorno_p INOUT text DEFAULT NULL) FROM PUBLIC;

