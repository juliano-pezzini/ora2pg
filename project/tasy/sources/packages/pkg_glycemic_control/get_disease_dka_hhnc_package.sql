-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';

  --
CREATE OR REPLACE FUNCTION pkg_glycemic_control.get_disease_dka_hhnc (P_CD_DOENCA CID_DOENCA.CD_DOENCA_CID%TYPE) RETURNS bigint AS $body$
DECLARE


    NR smallint;

  
BEGIN
    
    NR := 0;

    IF (P_CD_DOENCA IS NOT NULL AND P_CD_DOENCA::text <> '') THEN
      SELECT COUNT(1)
        INTO STRICT NR
        FROM CID_DOENCA D
       WHERE D.CD_DOENCA_CID = P_CD_DOENCA
         AND D.IE_SITUACAO = 'A'
         AND D.IE_DOENCA_REL in (9, 11);
    END IF;

    RETURN NR;

  END;

$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON FUNCTION pkg_glycemic_control.get_disease_dka_hhnc (P_CD_DOENCA CID_DOENCA.CD_DOENCA_CID%TYPE) FROM PUBLIC;