-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE chama_get_ep_add_log_msg_xdok (nr_episodios_p text, tras_diagnose_p bigint) AS $body$
BEGIN

CALL XDOK_JSON_PCK.get_episodios_add_log_msg_xdok(nr_episodios_p);
commit;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE chama_get_ep_add_log_msg_xdok (nr_episodios_p text, tras_diagnose_p bigint) FROM PUBLIC;

