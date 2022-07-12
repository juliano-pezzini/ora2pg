-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';




CREATE OR REPLACE FUNCTION pls_util_pck.concatena_string ( ds_string_atual_p text, ds_string_concat_p text, ds_separador text default ', ', qt_tamanho_max_p integer default 4000) RETURNS varchar AS $body$
DECLARE


ds_retorno_w	varchar(4000);


BEGIN

if (coalesce(ds_string_atual_p::text, '') = '') then
	ds_retorno_w := substr(ds_string_concat_p, 1, qt_tamanho_max_p);
else
	ds_retorno_w := substr(ds_string_atual_p || ds_separador || ds_string_concat_p, 1, qt_tamanho_max_p);
end if;

return ds_retorno_w;

END;

$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON FUNCTION pls_util_pck.concatena_string ( ds_string_atual_p text, ds_string_concat_p text, ds_separador text default ', ', qt_tamanho_max_p integer default 4000) FROM PUBLIC;