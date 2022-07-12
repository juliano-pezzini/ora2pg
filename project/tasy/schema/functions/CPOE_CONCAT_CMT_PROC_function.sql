-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION cpoe_concat_cmt_proc (ds_comment_p text, ds_additional_matter_p text, ds_add_text_p text) RETURNS varchar AS $body$
DECLARE


ds_return_w varchar(32767);


BEGIN

ds_return_w := ds_comment_p;

if (ds_additional_matter_p IS NOT NULL AND ds_additional_matter_p::text <> '') then
	ds_return_w := ds_return_w || ' - '|| ds_additional_matter_p || ': ' || ds_add_text_p;
end if;

return ds_return_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION cpoe_concat_cmt_proc (ds_comment_p text, ds_additional_matter_p text, ds_add_text_p text) FROM PUBLIC;
