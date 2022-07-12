-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';

  --
CREATE OR REPLACE FUNCTION pkg_vap_report.get_refactory_patient_name (NM_PATIENTE_P text) RETURNS varchar AS $body$
DECLARE


    RET varchar(255) := NULL;


BEGIN

    IF (NM_PATIENTE_P IS NOT NULL AND NM_PATIENTE_P::text <> '') THEN
      SELECT CASE WHEN position(',' in T.NM)=0 THEN                     CASE WHEN INSTR(T.NM, ' ', -1)=0 THEN                            T.NM  ELSE SUBSTR(T.NM, INSTR(T.NM, ' ', -1) + 1) || ', ' ||                           SUBSTR(T.NM, 1, INSTR(T.NM, ' ', -1) - 1) END   ELSE T.NM END 
        INTO STRICT RET
        FROM (SELECT trim(both NM_PATIENTE_P) NM ) T;
    END IF;

    RETURN RET;

  END;

$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON FUNCTION pkg_vap_report.get_refactory_patient_name (NM_PATIENTE_P text) FROM PUBLIC;
