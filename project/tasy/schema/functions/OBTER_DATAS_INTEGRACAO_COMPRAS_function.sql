-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_datas_integracao_compras ( nr_solic_compra_p bigint, nr_cot_compra_p bigint, cd_material_p bigint, cd_cnpj_p text, ie_opcao_retorno_p text) RETURNS timestamp AS $body$
DECLARE


/*ie_opcao_retorno_p
1 - dt_documento
2 - dt_retorno_prev
*/
dt_retorno_w			timestamp;
dt_documento_w			timestamp;
dt_retorno_prev_w			timestamp;


BEGIN

if (nr_solic_compra_p > 0) then

	select	dt_solicitacao_compra
	into STRICT	dt_documento_w
	from	solic_compra
	where	nr_solic_compra = nr_solic_compra_p;

elsif (nr_cot_compra_p > 0) then

	select	dt_cot_compra,
		dt_retorno_prev
	into STRICT	dt_documento_w,
		dt_retorno_prev_w
	from	cot_compra
	where	nr_cot_compra = nr_cot_compra_p;

elsif (cd_material_p > 0) then

	select	dt_integracao
	into STRICT	dt_documento_w
	from	material
	where	cd_material = cd_material_p;

elsif (cd_cnpj_p IS NOT NULL AND cd_cnpj_p::text <> '') then

	select	dt_integracao
	into STRICT	dt_documento_w
	from	pessoa_juridica
	where	cd_cgc = cd_cnpj_p;

end if;

if (ie_opcao_retorno_p = 1) then
	dt_retorno_w := dt_documento_w;
elsif (ie_opcao_retorno_p = 2) then
	dt_retorno_w := dt_retorno_prev_w;
end if;



return	dt_retorno_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_datas_integracao_compras ( nr_solic_compra_p bigint, nr_cot_compra_p bigint, cd_material_p bigint, cd_cnpj_p text, ie_opcao_retorno_p text) FROM PUBLIC;

