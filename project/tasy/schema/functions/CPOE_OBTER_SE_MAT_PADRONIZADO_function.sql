-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION cpoe_obter_se_mat_padronizado ( cd_estabelecimento_p bigint, cd_material_p bigint, ie_medicacao_paciente_p text) RETURNS varchar AS $body$
DECLARE


ds_retorno_w	varchar(1) := 'S';


BEGIN

if (ie_medicacao_paciente_p = 'N') then
	ds_retorno_w := obter_se_material_padronizado(cd_estabelecimento_p, cd_material_p);
end if;

return ds_retorno_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION cpoe_obter_se_mat_padronizado ( cd_estabelecimento_p bigint, cd_material_p bigint, ie_medicacao_paciente_p text) FROM PUBLIC;
