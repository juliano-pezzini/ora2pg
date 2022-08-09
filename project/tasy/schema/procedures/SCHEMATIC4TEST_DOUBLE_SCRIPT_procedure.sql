-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE schematic4test_double_script (NR_SEQUENCIA_P bigint, NM_USUARIO_P text) AS $body$
DECLARE

NR_SEQUENCIA_W	bigint;
NM_SCRIPT_W		varchar(255);
NM_SCRIPT_W2 varchar(255);
DS_DESCRICAO_W varchar(1000);
DS_SCRIPT_W text;
NR_SEQ_PRESET_W		bigint;
NR_SEQ_EXECUTION_W bigint;
NR_SEQ_ACTION_W bigint;
NM_VARIABLE_W varchar(255);
DS_ACTION_W varchar(255);
DS_VALUE_W varchar(1000);
IE_AREA_W		varchar(255);
NR_SEQUENCIA_STEP_W bigint;
DS_VERSION_W varchar(255);
NM_SERVICE_W varchar(255);
NR_SEQ_VARIABLE_W bigint;
NEWSEQUENCESCRIPT bigint;
NEWSEQUENCESTEP bigint;
NEWSEQUENCEVAL bigint;
NR_SEQ_SERVICE_W bigint;
IE_SWITCH_W varchar(255);
IE_JOBS_W varchar(255);
DS_VERSION_W2 varchar(255);
NR_SEQ_SNIPPET_W bigint;
CD_FUNCAO_W bigint;
IE_TYPE_SCRIPTW varchar(255);
DS_VER_SCRIPTW varchar(255);

C01 CURSOR FOR  --Loop steps
  SELECT DISTINCT STEP2.NR_SEQ_EXECUTION NR_SEQ_EXECUTION, ACTION.DS_ACTION DS_ACTION, STEP2.NR_SEQ_ACTION NR_SEQ_ACTION, STEP2.NR_SEQUENCIA NR_SEQUENCIA_STEP, STEP2.DS_VERSION DS_VERSION, STEP2.IE_SWITCH, STEP2.IE_JOBS, STEP2.NR_SEQ_SNIPPET NR_SEQ_SNIPPET
      INTO STRICT NR_SEQ_EXECUTION_W, DS_ACTION_W, NR_SEQ_ACTION_W, NR_SEQUENCIA_STEP_W, DS_VERSION_W, IE_SWITCH_W, IE_JOBS_W, NR_SEQ_SNIPPET_W
  FROM SCHEM_TEST_ACTION ACTION
  INNER JOIN SCHEM_TEST_STEP STEP2 ON (STEP2.NR_SEQ_ACTION = ACTION.NR_SEQUENCIA)
  INNER JOIN SCHEM_TEST_SCRIPT SCRIPT2 ON (SCRIPT2.NR_SEQUENCIA = STEP2.NR_SEQ_SCRIPT)
  WHERE SCRIPT2.NR_SEQUENCIA = NR_SEQUENCIA_W
  ORDER BY STEP2.NR_SEQ_EXECUTION ASC;

C02 CURSOR FOR  --Loop values
  SELECT VARIABLE1.NM_VARIABLE NM_VARIABLE,VALUE1.DS_VALUE DS_VALUE, VALUE1.NR_SEQ_VARIABLE NR_SEQ_VARIABLE, VALUE1.NR_SEQ_SERVICE NR_SEQ_SERVICE, VALUE1.DS_VERSION DS_VERSION2
       INTO STRICT NM_VARIABLE_W, DS_VALUE_W, NR_SEQ_VARIABLE_W, NR_SEQ_SERVICE_W, DS_VERSION_W2
   FROM SCHEM_TEST_VALUES VALUE1
   INNER JOIN SCHEM_TEST_VARIABLE VARIABLE1 ON (VALUE1.NR_SEQ_VARIABLE = VARIABLE1.NR_SEQUENCIA) 
   INNER JOIN SCHEM_TEST_STEP STEP ON (STEP.NR_SEQUENCIA = VALUE1.NR_SEQ_STEP) 
   WHERE STEP.NR_SEQ_SCRIPT = NR_SEQUENCIA_W
   AND STEP.NR_SEQUENCIA = NR_SEQUENCIA_STEP_W
   ORDER BY VALUE1.NR_SEQ_SERVICE, VALUE1.NR_SEQ_VARIABLE ASC;
	

BEGIN    
  --procedure to duplicate script  
	INSERT INTO SCHEM_TEST_BEHOLDER(nr_sequencia, nm_usuario, dt_atualizacao, nm_usuario_nrec, dt_atualizacao_nrec, ds_interaction, ds_param_a)
	VALUES (nextval('schem_test_beholder_seq'), NM_USUARIO_P, clock_timestamp(), 'Robot', clock_timestamp(), 'SCHEMATIC4TEST_DOUBLE_SCRIPT', 
	'NR_SEQUENCIA_P as '||NR_SEQUENCIA_P);

  SELECT SCRIPT.NR_SEQUENCIA, SCRIPT.NM_SCRIPT, SCRIPT.DS_DESCRICAO, SCRIPT.DS_SCRIPT_CLOB, SCRIPT.NR_SEQ_PRESET, SCRIPT.IE_AREA, SCRIPT.CD_FUNCAO, SCRIPT.IE_TYPE_SCRIPT, SCRIPT.DS_VERSION
      INTO STRICT NR_SEQUENCIA_W, NM_SCRIPT_W, DS_DESCRICAO_W, DS_SCRIPT_W, NR_SEQ_PRESET_W, IE_AREA_W, CD_FUNCAO_W, IE_TYPE_SCRIPTW, DS_VER_SCRIPTW
  FROM SCHEM_TEST_SCRIPT SCRIPT 
  WHERE SCRIPT.NR_SEQUENCIA = NR_SEQUENCIA_P;
			
  IF (NR_SEQUENCIA_W IS NOT NULL AND NR_SEQUENCIA_W::text <> '') THEN
    NM_SCRIPT_W2 := 'COPY OF ' || NM_SCRIPT_W;
 
    SELECT nextval('schem_test_script_seq') SEQUENCIA 
        INTO STRICT NEWSEQUENCESCRIPT
;
    
		INSERT INTO SCHEM_TEST_SCRIPT(NR_SEQUENCIA, NM_SCRIPT, NM_OWNER, DT_ATUALIZACAO, DT_ATUALIZACAO_NREC, NM_USUARIO, NM_USUARIO_NREC, DS_DESCRICAO, DS_SCRIPT_CLOB, IE_START, NR_SEQ_PRESET, IE_SOURCE, IE_AREA, CD_FUNCAO, IE_TYPE_SCRIPT, DS_VERSION) 
        VALUES (NEWSEQUENCESCRIPT, NM_SCRIPT_W2 , NM_USUARIO_P, clock_timestamp(), clock_timestamp(), NM_USUARIO_P, NM_USUARIO_P, DS_DESCRICAO_W, DS_SCRIPT_W, '0', NR_SEQ_PRESET_W , '0', IE_AREA_W, CD_FUNCAO_W, IE_TYPE_SCRIPTW, DS_VER_SCRIPTW);
    COMMIT;
  END IF;

  OPEN C01;
  LOOP
    FETCH C01 INTO	
      NR_SEQ_EXECUTION_W,
      DS_ACTION_W,
      NR_SEQ_ACTION_W, 
      NR_SEQUENCIA_STEP_W, 
      DS_VERSION_W,
      IE_SWITCH_W,
      IE_JOBS_W,
      NR_SEQ_SNIPPET_W;
    EXIT WHEN NOT FOUND; /* apply on C01 */
    BEGIN	
      SELECT nextval('schem_test_step_seq') STEP
        INTO STRICT NEWSEQUENCESTEP
;
    
        INSERT INTO SCHEM_TEST_STEP(NR_SEQUENCIA, NR_SEQ_EXECUTION, NM_USUARIO_NREC, NM_USUARIO, NR_SEQ_ACTION, DS_VERSION, IE_SWITCH, IE_JOBS, NR_SEQ_SCRIPT, DT_ATUALIZACAO_NREC, DT_ATUALIZACAO, NR_SEQ_SNIPPET) 
              VALUES (NEWSEQUENCESTEP, NR_SEQ_EXECUTION_W , NM_USUARIO_P, NM_USUARIO_P, NR_SEQ_ACTION_W, DS_VERSION_W , IE_SWITCH_W, IE_JOBS_W, NEWSEQUENCESCRIPT, clock_timestamp(), clock_timestamp(), NR_SEQ_SNIPPET_W);
        COMMIT;
         
        OPEN C02;
        LOOP
          FETCH C02 INTO	
            NM_VARIABLE_W,
            DS_VALUE_W, 
            NR_SEQ_VARIABLE_W, 
            NR_SEQ_SERVICE_W,
            DS_VERSION_W2;
        EXIT WHEN NOT FOUND; /* apply on C02 */
        BEGIN	
          SELECT nextval('schem_test_values_seq')
            INTO STRICT NEWSEQUENCEVAL
;
          
          delete from schem_test_values	where nr_seq_step = NEWSEQUENCESTEP and NR_SEQ_VARIABLE = NR_SEQ_VARIABLE_W and coalesce(NR_SEQ_SERVICE::text, '') = '' and coalesce(DS_VALUE::text, '') = '';
          COMMIT;
    
          INSERT INTO SCHEM_TEST_VALUES(NR_SEQUENCIA, DT_ATUALIZACAO, DT_ATUALIZACAO_NREC, NM_USUARIO, NM_USUARIO_NREC, NR_SEQ_STEP, NR_SEQ_VARIABLE, DS_VALUE, NR_SEQ_SERVICE, DS_VERSION) 
                VALUES (NEWSEQUENCEVAL, clock_timestamp(), clock_timestamp(), NM_USUARIO_P, NM_USUARIO_P, NEWSEQUENCESTEP, NR_SEQ_VARIABLE_W, replace(replace(replace(replace(replace(DS_VALUE_W,chr(38)||'amp;','&'),chr(38)||'lt;','<'),chr(38)||'gt;','>'),chr(38)||'apos;', chr(39)),chr(38)||'quot;',chr(34)), NR_SEQ_SERVICE_W, DS_VERSION_W2);
          COMMIT;
        END;
      END LOOP;
      CLOSE C02;
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
-- REVOKE ALL ON PROCEDURE schematic4test_double_script (NR_SEQUENCIA_P bigint, NM_USUARIO_P text) FROM PUBLIC;
