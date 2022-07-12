-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION nicu_get_med_administration (NR_SEQ_ATENDIMENTO_P bigint) RETURNS varchar AS $body$
DECLARE


  RETORNO_W      varchar(20);
  NR_SEQUENCIA_P bigint;


BEGIN

  SELECT MAX(NR_SEQUENCIA)
    INTO STRICT NR_SEQUENCIA_P
    FROM NICU_MED_ADMINISTRATION
   WHERE NR_SEQ_PATIENT = NR_SEQ_ATENDIMENTO_P
     AND (DT_END_ADMINISTRATION IS NOT NULL AND DT_END_ADMINISTRATION::text <> '')
   ORDER BY NR_SEQUENCIA;

  IF (NR_SEQUENCIA_P IS NOT NULL AND NR_SEQUENCIA_P::text <> '') THEN
    RETORNO_W := 'Medication Off';
  ELSE
    RETORNO_W := 'Medication On';
  END IF;

  RETURN RETORNO_W;

END;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION nicu_get_med_administration (NR_SEQ_ATENDIMENTO_P bigint) FROM PUBLIC;

