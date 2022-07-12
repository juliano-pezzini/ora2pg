-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION get_version () RETURNS varchar AS $body$
DECLARE

    version_w aplicacao_tasy.cd_versao_atual%type;

BEGIN
    select cd_versao_atual into STRICT version_w
      from aplicacao_tasy 
     where cd_aplicacao_tasy = 'Tasy';
return version_w;
end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION get_version () FROM PUBLIC;

