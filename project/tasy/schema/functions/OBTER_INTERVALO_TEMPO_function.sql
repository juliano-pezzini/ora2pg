-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_intervalo_tempo (DT_MENOR text, DT_MAIOR text, IE_TIPO_RETORNO bigint) RETURNS bigint AS $body$
DECLARE


 V_DIAS    bigint;
 V_HORAS   bigint;
 V_MINUTOS bigint;
 V_MESES   bigint;
 V_ANOS    bigint;
 V_SEMANAS bigint;
 V_RETORNO bigint;


BEGIN

  SELECT ROUND(TO_DATE(DT_MAIOR,'DD/MM/YYYY HH24:MI')-TO_DATE(DT_MENOR,'DD/MM/YYYY HH24:MI')) AS DIAS,
         ROUND((TO_DATE(DT_MAIOR,'DD/MM/YYYY HH24:MI')-TO_DATE(DT_MENOR,'DD/MM/YYYY HH24:MI'))*24,2) AS HORAS,
         (TO_DATE(DT_MAIOR,'DD/MM/YYYY HH24:MI')-TO_DATE(DT_MENOR,'DD/MM/YYYY HH24:MI'))::numeric *24*60 AS MINUTOS,
         ROUND(MONTHS_BETWEEN(TO_DATE(DT_MAIOR,'DD/MM/YYYY HH24:MI'),TO_DATE(DT_MENOR,'DD/MM/YYYY HH24:MI'))) AS MESES,
         ROUND(ROUND(MONTHS_BETWEEN(TO_DATE(DT_MAIOR,'DD/MM/YYYY HH24:MI:SS'),TO_DATE(DT_MENOR,'DD/MM/YYYY HH24:MI')))/12) AS ANOS,
         ROUND((TO_DATE(DT_MAIOR,'DD/MM/YYYY HH24:MI')-TO_DATE(DT_MENOR,'DD/MM/YYYY HH24:MI'))::numeric /7) AS SEMANAS
    INTO STRICT V_DIAS, V_HORAS, V_MINUTOS, V_MESES, V_ANOS, V_SEMANAS
;

  CASE IE_TIPO_RETORNO
      WHEN 1 THEN
        V_RETORNO := V_DIAS;
      WHEN 5 THEN
        V_RETORNO := V_HORAS;
      WHEN 6 THEN
        V_RETORNO := V_MINUTOS;
      WHEN 3 THEN
        V_RETORNO := V_MESES;
      WHEN 4 THEN
        V_RETORNO := V_ANOS;
      WHEN 2 THEN
        V_RETORNO := V_SEMANAS;
      ELSE
        V_RETORNO := 0;
  END CASE;

  RETURN(V_RETORNO);

EXCEPTION
  WHEN OTHERS THEN
     RETURN(0);

END;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_intervalo_tempo (DT_MENOR text, DT_MAIOR text, IE_TIPO_RETORNO bigint) FROM PUBLIC;

