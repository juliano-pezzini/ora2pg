-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';

  --
CREATE OR REPLACE FUNCTION pkg_report_data.get_disease (IE_DOENCA_REL_P CID_DOENCA.IE_DOENCA_REL%TYPE, CD_DOENCA_CID_P CID_DOENCA.CD_DOENCA_CID%TYPE DEFAULT NULL) RETURNS CID_DOENCA.CD_DOENCA_CID%TYPE AS $body$
DECLARE

    
    CD_DOENCA_CID_W CID_DOENCA.CD_DOENCA_CID%TYPE;

  
BEGIN
  
    CD_DOENCA_CID_W := NULL;

    IF (IE_DOENCA_REL_P IS NOT NULL AND IE_DOENCA_REL_P::text <> '') THEN
    
      IF coalesce(CD_DOENCA_CID_P::text, '') = '' THEN
      
        SELECT MAX(CD_DOENCA_CID)
          INTO STRICT CD_DOENCA_CID_W
          FROM CID_DOENCA D
         WHERE D.IE_DOENCA_REL = IE_DOENCA_REL_P
           AND D.IE_SITUACAO = 'A';

      ELSE
      
        SELECT MAX(CD_DOENCA_CID)
          INTO STRICT CD_DOENCA_CID_W
          FROM CID_DOENCA D
         WHERE D.IE_DOENCA_REL = IE_DOENCA_REL_P
           AND D.CD_DOENCA_CID = CD_DOENCA_CID_P
           AND D.IE_SITUACAO = 'A';
      
      END IF;

    END IF;

    RETURN CD_DOENCA_CID_W;

  END;

$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON FUNCTION pkg_report_data.get_disease (IE_DOENCA_REL_P CID_DOENCA.IE_DOENCA_REL%TYPE, CD_DOENCA_CID_P CID_DOENCA.CD_DOENCA_CID%TYPE DEFAULT NULL) FROM PUBLIC;
