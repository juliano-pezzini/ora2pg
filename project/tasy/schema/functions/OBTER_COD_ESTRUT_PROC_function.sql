-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_cod_estrut_proc (cd_area_proced_p bigint, cd_especial_proced_p bigint, cd_grupo_proced_p bigint, cd_procedimento_p bigint, ie_origem_proced_p bigint) RETURNS bigint AS $body$
DECLARE


cd_retorno_w		numeric(20);


BEGIN
if (cd_procedimento_p IS NOT NULL AND cd_procedimento_p::text <> '') then
	cd_retorno_w		:= cd_procedimento_p;
elsif (cd_grupo_proced_p IS NOT NULL AND cd_grupo_proced_p::text <> '') then
	cd_retorno_w		:= cd_grupo_proced_p;
elsif (cd_especial_proced_p IS NOT NULL AND cd_especial_proced_p::text <> '') then
	cd_retorno_w		:= cd_especial_proced_p;
elsif (cd_area_proced_p IS NOT NULL AND cd_area_proced_p::text <> '') then
	cd_retorno_w		:= cd_area_proced_p;
end if;

RETURN cd_retorno_w;
END;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_cod_estrut_proc (cd_area_proced_p bigint, cd_especial_proced_p bigint, cd_grupo_proced_p bigint, cd_procedimento_p bigint, ie_origem_proced_p bigint) FROM PUBLIC;

