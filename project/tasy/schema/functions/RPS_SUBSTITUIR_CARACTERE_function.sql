-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION rps_substituir_caractere (ds_conteudo_p text) RETURNS varchar AS $body$
BEGIN

return	substr(replace(replace(replace(replace(replace(ds_conteudo_p,'&',chr(38)||'amp;'),'<',chr(38)||'lt;'),'>',chr(38)||'gt;'),chr(39),chr(38)||'apos;'),chr(34),chr(38)||'quot;'),1,255);

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION rps_substituir_caractere (ds_conteudo_p text) FROM PUBLIC;
