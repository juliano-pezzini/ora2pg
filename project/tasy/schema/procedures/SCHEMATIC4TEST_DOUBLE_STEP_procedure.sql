-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE schematic4test_double_step (NR_SEQUENCIA_STEP_P bigint, TIPO_STEP_P bigint, NM_USUARIO_P text) AS $body$
DECLARE

NR_SEQUENCIA_W bigint;
NR_SEQ_EXECUTION_W bigint;
NR_SEQ_ACTION_W bigint;
NR_SEQ_SCRIPT_W bigint;
NEWSEQUENCESTEP bigint;
NEWSEQUENCESTEP2 bigint;
NEWSEQUENCEVAL bigint;
DS_VALUE_W varchar(1000);
NR_SEQ_VARIABLE_W bigint;
NR_SEQ_SERVICE_W bigint;
NR_SEQUENCIA_STEP_W bigint;
NR_SEQ_SNIPPET_W bigint;
QTD_W smallint;
NR_SEQ_ACTION_W2 bigint;
NR_SEQ_SCRIPT_W2 bigint;
NR_SEQ_AGRUPADOR_W bigint;
NR_SEQ_AGRUPADOR_W2 bigint;
DS_VERSION_W varchar(255);
DS_VERSION_W2 varchar(255);
DS_VERSION_W3 varchar(255);

C01 CURSOR FOR  --Loop values
      SELECT DISTINCT VALUE1.DS_VALUE DS_VALUE, VALUE1.NR_SEQ_VARIABLE NR_SEQ_VARIABLE, VALUE1.NR_SEQ_SERVICE NR_SEQ_SERVICE, VALUE1.DS_VERSION
          INTO STRICT DS_VALUE_W, NR_SEQ_VARIABLE_W, NR_SEQ_SERVICE_W, DS_VERSION_W
      FROM SCHEM_TEST_VALUES VALUE1
      INNER JOIN SCHEM_TEST_VARIABLE VARIABLE1 ON (VALUE1.NR_SEQ_VARIABLE = VARIABLE1.NR_SEQUENCIA) 
      INNER JOIN SCHEM_TEST_STEP STEP ON (STEP.NR_SEQUENCIA = VALUE1.NR_SEQ_STEP) 
      WHERE STEP.NR_SEQUENCIA = NR_SEQUENCIA_W
      ORDER BY VALUE1.NR_SEQ_SERVICE, VALUE1.NR_SEQ_VARIABLE ASC;

C02 CURSOR FOR  --loop actions
  SELECT DISTINCT NR_SEQ_ACTION, NR_SEQ_SCRIPT, DS_VERSION
      INTO STRICT NR_SEQ_ACTION_W2, NR_SEQ_SCRIPT_W2, DS_VERSION_W3
  FROM SCHEM_TEST_STEP
  WHERE NR_SEQ_ACTION = NR_SEQ_ACTION_W
  AND NR_SEQ_SNIPPET = NR_SEQ_SNIPPET_W
  AND (NR_SEQ_SCRIPT IS NOT NULL AND NR_SEQ_SCRIPT::text <> '');


BEGIN
      --procedure that duplicate step	  
		INSERT INTO SCHEM_TEST_BEHOLDER(nr_sequencia, nm_usuario, dt_atualizacao, nm_usuario_nrec, dt_atualizacao_nrec, ds_interaction, ds_param_a, ds_param_b)
		VALUES (nextval('schem_test_beholder_seq'), NM_USUARIO_P, clock_timestamp(), 'Robot', clock_timestamp(), 'SCHEMATIC4TEST_DOUBLE_STEP', 
		'NR_SEQUENCIA_STEP_P as '||NR_SEQUENCIA_STEP_P, 
		'TIPO_STEP_P as '||TIPO_STEP_P);
	
      SELECT step.NR_SEQUENCIA NR_SEQUENCIA, step.NR_SEQ_EXECUTION NR_SEQ_EXECUTION, step.NR_SEQ_ACTION NR_SEQ_ACTION, step.NR_SEQ_SCRIPT NR_SEQ_SCRIPT, step.NR_SEQ_SNIPPET NR_SEQ_SNIPPET, step.NR_SEQ_AGRUPADOR NR_SEQ_AGRUPADOR, step.DS_VERSION
          INTO STRICT NR_SEQUENCIA_W, NR_SEQ_EXECUTION_W, NR_SEQ_ACTION_W,  NR_SEQ_SCRIPT_W, NR_SEQ_SNIPPET_W, NR_SEQ_AGRUPADOR_W, DS_VERSION_W2
      FROM SCHEM_TEST_STEP step 
      WHERE step.NR_SEQUENCIA = NR_SEQUENCIA_STEP_P;

      SELECT nextval('schem_test_step_seq') SEQUENCIA 
        INTO STRICT NEWSEQUENCESTEP
;
      
      IF (TIPO_STEP_P = 1) THEN
        UPDATE SCHEM_TEST_SCRIPT SET DT_ATUALIZACAO = clock_timestamp(), NM_USUARIO = NM_USUARIO_P WHERE NR_SEQUENCIA = NR_SEQ_SCRIPT_W;

        INSERT INTO SCHEM_TEST_STEP(nr_sequencia, nr_seq_execution, nr_seq_action, nr_seq_script, dt_atualizacao, nm_usuario, dt_atualizacao_nrec, nm_usuario_nrec, ie_jobs, ie_switch, nr_seq_snippet, nr_seq_agrupador, ds_version) 
             VALUES (NEWSEQUENCESTEP, NR_SEQ_EXECUTION_W+2, NR_SEQ_ACTION_W, NR_SEQ_SCRIPT_W, clock_timestamp(), NM_USUARIO_P, clock_timestamp(), NM_USUARIO_P, '0', '0', null, null, DS_VERSION_W2);
      ELSE
        IF (TIPO_STEP_P = 2) THEN
            UPDATE SCHEM_TEST_SNIPPET SET DT_ATUALIZACAO = clock_timestamp(), NM_USUARIO = NM_USUARIO_P WHERE NR_SEQUENCIA = NR_SEQ_SNIPPET_W;
    
            SELECT COUNT(NR_SEQUENCIA) NR_SEQUENCIA 
                INTO STRICT QTD_W
            FROM SCHEM_TEST_SNIPPET WHERE NR_SEQUENCIA = NR_SEQ_SNIPPET_W AND IE_UPDATE = '1';

                    
            INSERT INTO SCHEM_TEST_STEP(nr_sequencia, nr_seq_execution, nr_seq_action, nr_seq_script, dt_atualizacao, nm_usuario, dt_atualizacao_nrec, nm_usuario_nrec, ie_jobs, ie_switch, nr_seq_snippet, nr_seq_agrupador, ds_version) 
                    VALUES (NEWSEQUENCESTEP, NR_SEQ_EXECUTION_W+2, NR_SEQ_ACTION_W, null, clock_timestamp(), NM_USUARIO_P, clock_timestamp(), NM_USUARIO_P, '0', '0', NR_SEQ_SNIPPET_W, null, DS_VERSION_W2);

            IF (QTD_W <> 0) THEN
                UPDATE SCHEM_TEST_SNIPPET SET DT_ATUALIZACAO = clock_timestamp(), NM_USUARIO = NM_USUARIO_P WHERE NR_SEQUENCIA = NR_SEQ_SNIPPET_W;
                
                OPEN C02;
                LOOP
                FETCH C02 INTO	
                  NR_SEQ_ACTION_W2,
                  NR_SEQ_SCRIPT_W2,
                  DS_VERSION_W3;
                EXIT WHEN NOT FOUND; /* apply on C02 */
                BEGIN	
                   UPDATE SCHEM_TEST_SCRIPT SET DT_ATUALIZACAO = clock_timestamp(), NM_USUARIO = NM_USUARIO_P WHERE NR_SEQUENCIA = NR_SEQ_SCRIPT_W2;
                   
                    SELECT nextval('schem_test_step_seq') SEQUENCIA 
                      INTO STRICT NEWSEQUENCESTEP2
;
                
                    INSERT INTO SCHEM_TEST_STEP(nr_sequencia, nr_seq_execution, nr_seq_action, nr_seq_script, dt_atualizacao, nm_usuario, dt_atualizacao_nrec, nm_usuario_nrec, ie_jobs, ie_switch, nr_seq_snippet, nr_seq_agrupador, DS_VERSION) 
                        VALUES (NEWSEQUENCESTEP2, NR_SEQ_EXECUTION_W+2, NR_SEQ_ACTION_W2, NR_SEQ_SCRIPT_W2, clock_timestamp(), NM_USUARIO_P, clock_timestamp(), NM_USUARIO_P, '0', '0', NR_SEQ_SNIPPET_W, NEWSEQUENCESTEP, DS_VERSION_W3);
                        
                END;
              END LOOP;
              CLOSE C02;
            END IF;
              UPDATE SCHEM_TEST_SNIPPET SET DT_LAST_UPDATE = clock_timestamp() WHERE NR_SEQUENCIA = NR_SEQ_SNIPPET_W;
              COMMIT;
          END IF;
      END IF;

      OPEN C01;
      LOOP
        FETCH C01 INTO	
          DS_VALUE_W,
          NR_SEQ_VARIABLE_W,           
          NR_SEQ_SERVICE_W,
          DS_VERSION_W;
      EXIT WHEN NOT FOUND; /* apply on C01 */
      BEGIN	
        --pega nova sequencia
        SELECT nextval('schem_test_values_seq')
          INTO STRICT NEWSEQUENCEVAL
;
         
         delete from schem_test_values	where nr_seq_step = NEWSEQUENCESTEP and NR_SEQ_VARIABLE = NR_SEQ_VARIABLE_W and coalesce(NR_SEQ_SERVICE::text, '') = '' and coalesce(DS_VALUE::text, '') = '';
         COMMIT;

         --se for cache, seta nulo.
        IF (NR_SEQ_VARIABLE_W = 1) THEN
            DS_VALUE_W := null;
        END IF;

        INSERT INTO SCHEM_TEST_VALUES(NR_SEQUENCIA, DT_ATUALIZACAO, DT_ATUALIZACAO_NREC, NM_USUARIO, NM_USUARIO_NREC, NR_SEQ_STEP, NR_SEQ_VARIABLE, DS_VALUE, NR_SEQ_SERVICE, DS_VERSION) 
              VALUES (NEWSEQUENCEVAL, clock_timestamp(), clock_timestamp(), NM_USUARIO_P, NM_USUARIO_P, NEWSEQUENCESTEP, NR_SEQ_VARIABLE_W, replace(replace(replace(replace(replace(DS_VALUE_W,chr(38)||'amp;','&'),chr(38)||'lt;','<'),chr(38)||'gt;','>'),chr(38)||'apos;', chr(39)),chr(38)||'quot;',chr(34)), NR_SEQ_SERVICE_W, DS_VERSION_W);

        COMMIT;
        
        IF (TIPO_STEP_P = 2) THEN
          UPDATE SCHEM_TEST_SNIPPET SET DT_LAST_UPDATE = clock_timestamp() WHERE NR_SEQUENCIA = NR_SEQ_SNIPPET_W;
          COMMIT;
        END IF;
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
-- REVOKE ALL ON PROCEDURE schematic4test_double_step (NR_SEQUENCIA_STEP_P bigint, TIPO_STEP_P bigint, NM_USUARIO_P text) FROM PUBLIC;
