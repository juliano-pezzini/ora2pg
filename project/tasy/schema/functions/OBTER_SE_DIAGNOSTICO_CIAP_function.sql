-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_se_diagnostico_ciap ( cd_diagnostico_p text, cd_ciap_p text) RETURNS varchar AS $body$
DECLARE


ds_retorno_w 	varchar(1) := 'S';


BEGIN
if (cd_ciap_p IS NOT NULL AND cd_ciap_p::text <> '') then
	begin
	SELECT	coalesce(MAX('S'),'N')
	INTO STRICT	ds_retorno_w
	FROM	DIAGNOSTICO_CIAP a,
		PROBLEMA_CIAP b
	WHERE	a.nr_seq_problema = b.nr_sequencia
	AND	a.CD_DOENCA_CID = cd_diagnostico_p
	AND	b.cd_ciap = cd_ciap_p;
	end;
end if;
return	ds_retorno_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_se_diagnostico_ciap ( cd_diagnostico_p text, cd_ciap_p text) FROM PUBLIC;
