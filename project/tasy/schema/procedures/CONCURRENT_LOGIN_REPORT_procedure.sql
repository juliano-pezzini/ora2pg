-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE concurrent_login_report (dt_fromDate_p timestamp, dt_toDate_P timestamp) AS $body$
BEGIN
  CALL PKG_LOGIN_REPORT.DO_LOGIN_REPORT_FULL(dt_fromDate_p, dt_toDate_P);
END;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE concurrent_login_report (dt_fromDate_p timestamp, dt_toDate_P timestamp) FROM PUBLIC;
