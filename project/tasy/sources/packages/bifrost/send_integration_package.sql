-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';


--
-- dblink wrapper to call function bifrost.send_integration() as an autonomous transaction
--
CREATE EXTENSION IF NOT EXISTS dblink;

CREATE OR REPLACE FUNCTION bifrost.send_integration ( nm_event text, nm_javaclass text, ds_arguments text, nm_user text default null, ie_tasy_backend char default null, json_headers text default null) RETURNS text AS $body$
DECLARE
	-- Change this to reflect the dblink connection string
	v_conn_str  text := format('port=%s dbname=%s user=%s', current_setting('port'), current_database(), current_user);
	v_query     text;

	v_ret	text;
BEGIN
	v_query := 'SELECT * FROM bifrost.send_integration_atx ( ' || quote_nullable(nm_event) || ',' || quote_nullable(nm_javaclass) || ',' || quote_nullable(ds_arguments) || ',' || quote_nullable(nm_user) || ',' || quote_nullable(ie_tasy_backend) || ',' || quote_nullable(json_headers) || ' )';
	SELECT * INTO v_ret FROM dblink(v_conn_str, v_query) AS p (ret text);
	RETURN v_ret;

END;
$body$ LANGUAGE plpgsql SECURITY DEFINER;




CREATE OR REPLACE FUNCTION bifrost.send_integration_atx ( nm_event text, nm_javaclass text, ds_arguments text, nm_user text default null, ie_tasy_backend char default null, json_headers text default null) RETURNS text AS $body$
BEGIN
	--BIFROST INTEGRATIONS FROM PL/SQL MUST BE ASYNC. KEEP THE 'false' VALUE IN THE 'synchronous' PARAMETER.
    return bifrost.sendintegration(false, nm_event, nm_javaclass, ds_arguments, 'false', nm_user, ie_tasy_backend, json_headers);
END;

$body$
LANGUAGE PLPGSQL
;
-- REVOKE ALL ON FUNCTION bifrost.send_integration ( nm_event text, nm_javaclass text, ds_arguments text, nm_user text default null, ie_tasy_backend char default null, json_headers text default null) FROM PUBLIC; -- REVOKE ALL ON FUNCTION bifrost.send_integration_atx ( nm_event text, nm_javaclass text, ds_arguments text, nm_user text default null, ie_tasy_backend char default null, json_headers text default null) FROM PUBLIC;