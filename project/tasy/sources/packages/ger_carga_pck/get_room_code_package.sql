-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';




CREATE OR REPLACE FUNCTION ger_carga_pck.get_room_code (bed_p text) RETURNS varchar AS $body$
DECLARE


room_w	varchar(8);


BEGIN

if (position('_' in bed_p) > 0) then
	select	replace(substr(bed_p,1,position('_' in bed_p)-1),'B','Z')
	into STRICT	room_w
	;
else
	select	replace(bed_p,'B','Z')
	into STRICT	room_w
	;
end if;

return room_w;

END;

$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION ger_carga_pck.get_room_code (bed_p text) FROM PUBLIC;