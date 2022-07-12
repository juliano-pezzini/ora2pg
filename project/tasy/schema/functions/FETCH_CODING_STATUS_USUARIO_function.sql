-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION fetch_coding_status_usuario ( nr_encounter_p bigint) RETURNS varchar AS $body$
DECLARE

	nm_usuario_w varchar(20);

BEGIN
	select  nm_usuario
		into STRICT nm_usuario_w
		from patient_coding
		where coalesce(dt_inactive::text, '') = ''
		and nr_encounter   = nr_encounter_p
		and ie_status      = 'S';
	return nm_usuario_w;
end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION fetch_coding_status_usuario ( nr_encounter_p bigint) FROM PUBLIC;

