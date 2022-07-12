-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';




CREATE OR REPLACE PROCEDURE tiss_convenio_pck.set_gravar_log_inconsist (ie_gravar_log_inconsist_p text) AS $body$
BEGIN
PERFORM set_config('tiss_convenio_pck.ie_gravar_log_inconsist_w', ie_gravar_log_inconsist_p, false);

end;


$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE tiss_convenio_pck.set_gravar_log_inconsist (ie_gravar_log_inconsist_p text) FROM PUBLIC;
