-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';




CREATE OR REPLACE FUNCTION wheb_log_pck.get_nr_seq_log_tasy () RETURNS bigint AS $body$
BEGIN
	return current_setting('wheb_log_pck.nr_seq_log_w')::bigint;
	end;


$body$
LANGUAGE PLPGSQL
 STABLE;
-- REVOKE ALL ON FUNCTION wheb_log_pck.get_nr_seq_log_tasy () FROM PUBLIC;
