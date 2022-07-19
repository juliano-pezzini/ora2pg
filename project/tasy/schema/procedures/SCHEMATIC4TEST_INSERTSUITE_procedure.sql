-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE schematic4test_insertsuite (NR_SEQUENCIA_P bigint, NR_SEQ_SUITE_P bigint, NR_SEQ_ROBOT_P bigint, NR_SEQ_GRID_P bigint, NM_USUARIO_P text) AS $body$
DECLARE

QTD_W bigint;
QTD_W2 bigint;
NR_SEQ_EXECUTION_W bigint;


BEGIN
  --procedure that insert suite  
  INSERT INTO SCHEM_TEST_BEHOLDER(nr_sequencia, nm_usuario, dt_atualizacao, nm_usuario_nrec, dt_atualizacao_nrec, ds_interaction, ds_param_a, ds_param_b, ds_param_c, ds_param_d)
	VALUES (nextval('schem_test_beholder_seq'), NM_USUARIO_P, clock_timestamp(), 'Robot', clock_timestamp(), 'SCHEMATIC4TEST_INSERTSUITE', 
	'NR_SEQUENCIA_P as '||NR_SEQUENCIA_P, 
	'NR_SEQ_SUITE_P as '||NR_SEQ_SUITE_P, 
	'NR_SEQ_ROBOT_P as '||NR_SEQ_ROBOT_P, 
	'NR_SEQ_GRID_P as '||NR_SEQ_GRID_P);

  IF (NR_SEQUENCIA_P IS NOT NULL AND NR_SEQUENCIA_P::text <> '') THEN  
      SELECT COUNT(NR_SEQUENCIA) QTD 
          INTO STRICT QTD_W
      FROM SCHEM_TEST_SUITE
      WHERE NR_SEQUENCIA = NR_SEQ_SUITE_P;
 
      IF (QTD_W <> 0) THEN  
        SELECT COUNT(NR_SEQUENCIA) QTD 
            INTO STRICT QTD_W2
        FROM SCHEM_TEST_TEST
        WHERE NR_SEQ_SUITE = NR_SEQ_SUITE_P
        AND NR_SEQ_SCRIPT = NR_SEQUENCIA_P;

        SELECT MAX(NR_SEQ_EXECUTION) NR_SEQ_EXECUTION 
           INTO STRICT NR_SEQ_EXECUTION_W
        FROM SCHEM_TEST_TEST
        WHERE NR_SEQ_SUITE = NR_SEQ_SUITE_P;

        IF (coalesce(NR_SEQ_EXECUTION_W::text, '') = '') THEN
           NR_SEQ_EXECUTION_W := 0;
        END IF;

        IF (QTD_W <> 0) THEN    
           INSERT INTO SCHEM_TEST_TEST(NR_SEQUENCIA, NR_SEQ_EXECUTION, NR_SEQ_SCRIPT, NR_SEQ_SUITE, NR_SEQ_ROBOT, NR_SEQ_GRID, DT_ATUALIZACAO, DT_ATUALIZACAO_NREC, NM_USUARIO_NREC, NM_USUARIO, IE_JOBS, IE_SWITCH)
              VALUES (nextval('schem_test_test_seq'), NR_SEQ_EXECUTION_W+2, NR_SEQUENCIA_P, NR_SEQ_SUITE_P, NR_SEQ_ROBOT_P, NR_SEQ_GRID_P, clock_timestamp(), clock_timestamp(), NM_USUARIO_P, NM_USUARIO_P, '0', '1');
            COMMIT;
        END IF;
      END IF;
  END IF;
  EXCEPTION
  WHEN no_data_found THEN
    RAISE NOTICE 'Erro: Data not found';
END;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE schematic4test_insertsuite (NR_SEQUENCIA_P bigint, NR_SEQ_SUITE_P bigint, NR_SEQ_ROBOT_P bigint, NR_SEQ_GRID_P bigint, NM_USUARIO_P text) FROM PUBLIC;

