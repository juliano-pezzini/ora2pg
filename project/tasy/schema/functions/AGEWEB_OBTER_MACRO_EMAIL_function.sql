-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION ageweb_obter_macro_email () RETURNS varchar AS $body$
DECLARE


ds_retorno_w	varchar(4000);


BEGIN

ds_retorno_w	:= 	obter_desc_expressao(495621)||CHR(10)||
			' '||CHR(10)||
			obter_desc_expressao(349611)||CHR(10)||
			obter_desc_expressao(349614)||CHR(10)||
			obter_desc_expressao(349615)||CHR(10)||
			' '||CHR(10)||
			obter_desc_expressao(499561)||CHR(10)||
			' '||CHR(10)||
			obter_desc_expressao(349611)||CHR(10)||
			obter_desc_expressao(349617)||CHR(10)||
			obter_desc_expressao(349618)||CHR(10)||
			obter_desc_expressao(349619)||CHR(10)||
			obter_desc_expressao(349620)||CHR(10)||
			obter_desc_expressao(349621)||CHR(10)||
			obter_desc_expressao(349622)||CHR(10)||
			obter_desc_expressao(349623)||CHR(10)||
			obter_desc_expressao(349624)||CHR(10)||
			' '||CHR(10)||
			obter_desc_expressao(499562)||CHR(10)||
			' '||CHR(10)||
			obter_desc_expressao(349611)||CHR(10)||
			obter_desc_expressao(349617)||CHR(10)||
			obter_desc_expressao(349618)||CHR(10)||
			obter_desc_expressao(349619)||CHR(10)||
			obter_desc_expressao(349622)||CHR(10)||
			obter_desc_expressao(349623)||CHR(10)||
			obter_desc_expressao(349627)||CHR(10)||
			obter_desc_expressao(349634)||CHR(10)||
			' '||CHR(10)||
			obter_desc_expressao(349628)||CHR(10)||
			' '||CHR(10)||
			obter_desc_expressao(349611)||CHR(10)||
			obter_desc_expressao(349614)||CHR(10)||
			obter_desc_expressao(349615);

return	ds_retorno_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION ageweb_obter_macro_email () FROM PUBLIC;
