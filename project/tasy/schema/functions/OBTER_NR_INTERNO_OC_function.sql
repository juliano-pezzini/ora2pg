-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';



--
-- dblink wrapper to call function obter_nr_interno_oc as an autonomous transaction
--
CREATE EXTENSION IF NOT EXISTS dblink;

CREATE OR REPLACE FUNCTION obter_nr_interno_oc () RETURNS bigint AS $body$
DECLARE
	-- Change this to reflect the dblink connection string
	v_conn_str  text := format('port=%s dbname=%s user=%s', current_setting('port'), current_database(), current_user);
	v_query     text;

	v_ret	bigint;
BEGIN
	v_query := 'SELECT * FROM obter_nr_interno_oc_atx ()';
	SELECT * INTO v_ret FROM dblink(v_conn_str, v_query) AS p (ret bigint);
	RETURN v_ret;

END;
$body$ LANGUAGE plpgsql SECURITY DEFINER;




CREATE OR REPLACE FUNCTION obter_nr_interno_oc_atx () RETURNS bigint AS $body$
DECLARE


nr_seq_interno_w	bigint;
BEGIN

select	coalesce(max(nr_seq_interno),0) +1
into STRICT	nr_seq_interno_w
from	ordem_compra
where	(nr_seq_interno IS NOT NULL AND nr_seq_interno::text <> '');

return	nr_seq_interno_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_nr_interno_oc () FROM PUBLIC; -- REVOKE ALL ON FUNCTION obter_nr_interno_oc_atx () FROM PUBLIC;

