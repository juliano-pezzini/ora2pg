-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION gerar_arquivo_dmed_oppas () RETURNS varchar AS $body$
DECLARE

ds_oppas	varchar(20);

BEGIN

ds_oppas := 'OPPAS' || '|';

return	ds_oppas;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION gerar_arquivo_dmed_oppas () FROM PUBLIC;

