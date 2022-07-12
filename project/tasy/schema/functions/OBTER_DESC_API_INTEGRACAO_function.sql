-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_desc_api_integracao (cd_api_p alerta_api.cd_api%type) RETURNS varchar AS $body$
BEGIN

	return substr(obter_nome_api_lexicomp(obter_sigla_api_lexicomp(cd_api_p)),1,2000);

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_desc_api_integracao (cd_api_p alerta_api.cd_api%type) FROM PUBLIC;

