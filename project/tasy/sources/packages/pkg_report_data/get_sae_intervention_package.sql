-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';

  --
CREATE OR REPLACE FUNCTION pkg_report_data.get_sae_intervention (NR_SEQ_RESULT_P PE_PRESCR_ITEM_RESULT.NR_SEQ_RESULT%TYPE) RETURNS CP_INTERVENTION.IE_INTERV_SAE_REL%TYPE AS $body$
DECLARE


    IE_REL_W CP_INTERVENTION.IE_INTERV_SAE_REL%TYPE;

  
BEGIN
  
    IE_REL_W := NULL;

    IF (NR_SEQ_RESULT_P IS NOT NULL AND NR_SEQ_RESULT_P::text <> '') THEN
      BEGIN
        SELECT MAX(C.IE_INTERV_SAE_REL) 
          INTO STRICT IE_REL_W
          FROM PE_ITEM_RESULT_PROC P,
               CP_INTERVENTION C
         WHERE (C.IE_INTERV_SAE_REL IS NOT NULL AND C.IE_INTERV_SAE_REL::text <> '')
           AND C.IE_SITUACAO = 'A'
           AND P.NR_SEQ_RESULT = NR_SEQ_RESULT_P
           AND P.NR_SEQ_PROC = C.NR_SEQ_PE_PROCEDIMENTO;
      EXCEPTION WHEN no_data_found THEN
        IE_REL_W := NULL;
      END;
    END IF;

    RETURN IE_REL_W;

  END;

$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON FUNCTION pkg_report_data.get_sae_intervention (NR_SEQ_RESULT_P PE_PRESCR_ITEM_RESULT.NR_SEQ_RESULT%TYPE) FROM PUBLIC;