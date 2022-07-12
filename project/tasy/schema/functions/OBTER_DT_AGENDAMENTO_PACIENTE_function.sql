-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_dt_agendamento_paciente (nr_sequencia_p bigint) RETURNS timestamp AS $body$
DECLARE


  dt_agendamento_w timestamp;


BEGIN

  IF (coalesce(nr_sequencia_p,0) > 0) THEN
    SELECT MAX(dt_agendamento)
    INTO STRICT dt_agendamento_w
    FROM agenda_paciente
    WHERE nr_sequencia = nr_sequencia_p;
  END IF;

RETURN dt_agendamento_w;

END;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_dt_agendamento_paciente (nr_sequencia_p bigint) FROM PUBLIC;
