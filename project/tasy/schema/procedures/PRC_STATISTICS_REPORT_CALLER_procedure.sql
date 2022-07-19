-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE prc_statistics_report_caller ( dtinicio_p timestamp, dtfim_p timestamp, estabelecimento_p bigint, setor_p bigint) AS $body$
BEGIN
  --
  CALL PKG_STATISTICS_REPORT.RUN(dtinicio_p, dtfim_p, coalesce(estabelecimento_p, 0), coalesce(setor_p, 0));
  --
END;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE prc_statistics_report_caller ( dtinicio_p timestamp, dtfim_p timestamp, estabelecimento_p bigint, setor_p bigint) FROM PUBLIC;

