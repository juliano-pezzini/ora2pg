-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE schematic4test_transteptonot (NR_SEQ_SCRIPT_P bigint, NOTATION_P text) AS $body$
DECLARE

QTD_W bigint;
note_W text;


BEGIN
  --procedure that translate to field to import backup of scripts
  SELECT COUNT(NR_SEQUENCIA) NR_SEQUENCIA
      INTO STRICT QTD_W
  FROM SCHEM_TEST_SCRIPT 
  WHERE NR_SEQUENCIA = NR_SEQ_SCRIPT_P;
  
  IF (QTD_W <> 0) THEN
    SELECT DS_SCRIPT_CLOB 
        INTO STRICT note_W
    FROM SCHEM_TEST_SCRIPT 
    WHERE NR_SEQUENCIA = NR_SEQ_SCRIPT_P;
    
    BEGIN
		note_W := note_W || NOTATION_P;

		UPDATE SCHEM_TEST_SCRIPT SET DS_SCRIPT_CLOB = note_W WHERE NR_SEQUENCIA = NR_SEQ_SCRIPT_P;
		COMMIT;
    END;
  END IF;

  EXCEPTION
  WHEN no_data_found THEN
    RAISE NOTICE 'Erro: Data not found';
END;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE schematic4test_transteptonot (NR_SEQ_SCRIPT_P bigint, NOTATION_P text) FROM PUBLIC;
