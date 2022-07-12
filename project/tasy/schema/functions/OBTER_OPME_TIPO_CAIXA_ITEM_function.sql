-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_opme_tipo_caixa_item (cd_material_p bigint, nr_seq_marca_p bigint, ie_opcao_p text) RETURNS varchar AS $body$
DECLARE

/*ie_opcao
SM - Sequencia da Marca do Material
RA - Registro anvisa
VA - Validade Anvisa
IV - Vigente Anvisa
*/
nr_seq_marca_w		material_marca.nr_sequencia%type;
nr_registro_anvisa_w 	material_marca.nr_registro_anvisa%type;
dt_validade_anvisa_w	material_marca.dt_validade_reg_anvisa%type;
ie_vigente_anvisa_w		material_marca.ie_vigente_anvisa%type;

retorno_w	varchar(255);


BEGIN
SELECT  MAX(x.nr_sequencia) nr_sequencia,
	MAX(x.nr_registro_anvisa) nr_registro_anvisa,
	MAX(x.dt_validade_reg_anvisa) dt_validade_reg_anvisa,
	MAX(x.ie_vigente_anvisa) ie_vigente_anvisa
into STRICT	nr_seq_marca_w,
	nr_registro_anvisa_w,
	dt_validade_anvisa_w,
	ie_vigente_anvisa_w
FROM	material_marca x
WHERE x.cd_material = cd_material_p
and (coalesce(nr_seq_marca_p::text, '') = '' or x.nr_sequencia = nr_seq_marca_p)
AND coalesce(x.cd_estabelecimento, 0) = obter_estabelecimento_ativo
ORDER BY x.nr_sequencia;

if (ie_opcao_p = 'SM') then
	retorno_w := nr_seq_marca_w;
elsif (ie_opcao_p = 'RA') then
	retorno_w := nr_registro_anvisa_w;
elsif (ie_opcao_p = 'IV') then
	retorno_w := ie_vigente_anvisa_w;
else
	retorno_w := to_char(dt_validade_anvisa_w,'dd/mm/yyyy');
end if;

return	retorno_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_opme_tipo_caixa_item (cd_material_p bigint, nr_seq_marca_p bigint, ie_opcao_p text) FROM PUBLIC;

