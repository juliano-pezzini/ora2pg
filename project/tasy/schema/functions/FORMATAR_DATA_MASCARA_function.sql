-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION formatar_data_mascara (data_p timestamp, tipo_mascara_p text) RETURNS varchar AS $body$
DECLARE

data_w	varchar(30);


BEGIN

if (Data_p IS NOT NULL AND Data_p::text <> '') then
	data_w:= to_char(data_p,tipo_mascara_p);
end if;

return data_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION formatar_data_mascara (data_p timestamp, tipo_mascara_p text) FROM PUBLIC;
