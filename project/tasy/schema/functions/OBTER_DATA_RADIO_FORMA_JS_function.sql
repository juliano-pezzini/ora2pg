-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_data_radio_forma_js (data_p timestamp) RETURNS varchar AS $body$
DECLARE

data_w	varchar(10);


BEGIN

select	substr(to_char(data_p,'dd/mm/yyyy'),1,10)
into STRICT	data_w
;


return	data_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_data_radio_forma_js (data_p timestamp) FROM PUBLIC;

