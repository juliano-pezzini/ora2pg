-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';

  -- 
CREATE OR REPLACE PROCEDURE pkg_ventilator_days.run (P_START_DATE timestamp DEFAULT clock_timestamp(), P_END_DATE timestamp DEFAULT clock_timestamp(), P_CD_ESTAB bigint DEFAULT 0, P_CD_SETOR bigint DEFAULT 0, P_YEAR bigint DEFAULT NULL, P_QUARTER bigint DEFAULT 1, P_TYPE bigint DEFAULT 1, P_PATIENT text DEFAULT NULL) AS $body$
BEGIN
    CALL CALL CALL CALL CALL CALL pkg_ventilator_days.table_cleaning();
    CALL CALL CALL CALL CALL CALL pkg_ventilator_days.pre_process(P_START_DATE, LEAST(P_END_DATE, TRUNC(clock_timestamp(), 'DD')), P_CD_ESTAB, P_CD_SETOR, P_YEAR, P_QUARTER, P_TYPE, P_PATIENT);
  END;

$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE pkg_ventilator_days.run (P_START_DATE timestamp DEFAULT clock_timestamp(), P_END_DATE timestamp DEFAULT clock_timestamp(), P_CD_ESTAB bigint DEFAULT 0, P_CD_SETOR bigint DEFAULT 0, P_YEAR bigint DEFAULT NULL, P_QUARTER bigint DEFAULT 1, P_TYPE bigint DEFAULT 1, P_PATIENT text DEFAULT NULL) FROM PUBLIC;
