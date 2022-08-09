-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE mims_update_status ( version_number_p bigint, return_value_p INOUT text) AS $body$
DECLARE


v_return_value bigint;


BEGIN
return_value_p := 'N';
select	GET_FILE_TYPE(version_number_p)
into STRICT 	v_return_value
;

IF v_return_value = 18 OR v_return_value = 0 THEN
   update MIMS_VERSION set IE_STATUS = 1 where NR_SEQUENCIA = version_number_p;
   commit;
   return_value_p := 'S';
END IF;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE mims_update_status ( version_number_p bigint, return_value_p INOUT text) FROM PUBLIC;
