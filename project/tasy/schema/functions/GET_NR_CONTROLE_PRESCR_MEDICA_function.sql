-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';



--
-- dblink wrapper to call function get_nr_controle_prescr_medica as an autonomous transaction
--
CREATE EXTENSION IF NOT EXISTS dblink;

CREATE OR REPLACE FUNCTION get_nr_controle_prescr_medica (nr_prescricao_p bigint) RETURNS bigint AS $body$
DECLARE
	-- Change this to reflect the dblink connection string
	v_conn_str  text := format('port=%s dbname=%s user=%s', current_setting('port'), current_database(), current_user);
	v_query     text;

	v_ret	bigint;
BEGIN
	v_query := 'SELECT * FROM get_nr_controle_prescr_medica_atx ( ' || quote_nullable(nr_prescricao_p) || ' )';
	SELECT * INTO v_ret FROM dblink(v_conn_str, v_query) AS p (ret bigint);
	RETURN v_ret;

END;
$body$ LANGUAGE plpgsql SECURITY DEFINER;




CREATE OR REPLACE FUNCTION get_nr_controle_prescr_medica_atx (nr_prescricao_p bigint) RETURNS bigint AS $body$
DECLARE


nr_controle_w prescr_medica.nr_controle%type;
BEGIN

select nr_controle
into STRICT nr_controle_w
from prescr_medica
where nr_prescricao = nr_prescricao_p;

return nr_controle_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION get_nr_controle_prescr_medica (nr_prescricao_p bigint) FROM PUBLIC; -- REVOKE ALL ON FUNCTION get_nr_controle_prescr_medica_atx (nr_prescricao_p bigint) FROM PUBLIC;

