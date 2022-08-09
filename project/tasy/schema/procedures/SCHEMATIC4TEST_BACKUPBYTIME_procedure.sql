-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE schematic4test_backupbytime () AS $body$
DECLARE

NR_SEQUENCIA_W bigint;

--loop scripts that need do backup
C01 CURSOR FOR
    SELECT script.NR_SEQUENCIA NR_SEQUENCIA
        INTO STRICT NR_SEQUENCIA_W
    FROM SCHEM_TEST_SCRIPT script
    INNER JOIN SCHEM_TEST_STEP step ON (step.NR_SEQ_SCRIPT = script.NR_SEQUENCIA) 
    INNER JOIN SCHEM_TEST_VALUES val ON (val.NR_SEQ_STEP = step.NR_SEQUENCIA) 
    WHERE (script.DT_ATUALIZACAO > (clock_timestamp() - interval '1 days') OR step.DT_ATUALIZACAO > (clock_timestamp() - interval '1 days') 
    OR val.DT_ATUALIZACAO > (clock_timestamp() - interval '1 days'))
    GROUP BY script.NR_SEQUENCIA;


BEGIN
    --procedure that set ie_start to do backup
    OPEN C01;
    LOOP
    FETCH C01 INTO
        NR_SEQUENCIA_W;
    EXIT WHEN NOT FOUND; /* apply on C01 */
    BEGIN
        UPDATE SCHEM_TEST_SCRIPT SET IE_START = '5' WHERE NR_SEQUENCIA = NR_SEQUENCIA_W;
    END;
    END LOOP;
    CLOSE C01; 			
  EXCEPTION
  WHEN no_data_found THEN
    RAISE NOTICE 'Erro: Data not found';
END;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE schematic4test_backupbytime () FROM PUBLIC;
