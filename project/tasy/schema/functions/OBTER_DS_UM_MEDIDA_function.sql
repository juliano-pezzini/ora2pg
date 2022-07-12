-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_ds_um_medida (cd_unidade_medida_p text) RETURNS varchar AS $body$
DECLARE


cd_unidade_medida_w	varchar(255) := '';

BEGIN

if (cd_unidade_medida_p IS NOT NULL AND cd_unidade_medida_p::text <> '') then
	begin

	select substr(DS_UNIDADE_MEDIDA,1,255)
	into STRICT cd_unidade_medida_w
	from unidade_medida
	where cd_unidade_medida = cd_unidade_medida_p;

	end;
end if;


return	cd_unidade_medida_w;
end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_ds_um_medida (cd_unidade_medida_p text) FROM PUBLIC;

