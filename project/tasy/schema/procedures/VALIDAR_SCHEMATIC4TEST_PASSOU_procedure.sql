-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE validar_schematic4test_passou (NR_SEQ_SCHEDULE_P bigint, NR_SEQ_SCRIPT_P bigint, NM_USUARIO_P text) AS $body$
DECLARE


NR_SEQUENCIAW bigint;
IE_MANUALW varchar(2);
NR_SEQ_PACKAGEW bigint;


BEGIN
  --procedure that set valid on script  
  INSERT INTO SCHEM_TEST_BEHOLDER(nr_sequencia, nm_usuario, dt_atualizacao, nm_usuario_nrec, dt_atualizacao_nrec, ds_interaction, ds_param_a, ds_param_b)
	VALUES (nextval('schem_test_beholder_seq'), NM_USUARIO_P, clock_timestamp(), 'Robot', clock_timestamp(), 'VALIDAR_SCHEMATIC4TEST_PASSOU', 
	'NR_SEQ_SCHEDULE_P as '||NR_SEQ_SCHEDULE_P, 
	'NR_SEQ_SCRIPT_P as '||NR_SEQ_SCRIPT_P);

  SELECT IE_MANUAL 
    INTO STRICT IE_MANUALW
  FROM SCHEM_TEST_LOG WHERE NR_SEQ_SCHEDULE = NR_SEQ_SCHEDULE_P AND NR_SEQ_SCRIPT = NR_SEQ_SCRIPT_P AND IE_STATUS = '4' AND (IE_MANUAL IS NOT NULL AND IE_MANUAL::text <> '');

  IF (IE_MANUALW IS NOT NULL AND IE_MANUALW::text <> '') THEN
    UPDATE SCHEM_TEST_LOG SET NM_USUARIO = NM_USUARIO_P, IE_MANUAL  = NULL, DT_ATUALIZACAO = clock_timestamp(), IE_STATUS = '2' WHERE NR_SEQ_SCHEDULE = NR_SEQ_SCHEDULE_P AND NR_SEQ_SCRIPT = NR_SEQ_SCRIPT_P AND IE_STATUS = '4';
    commit;
  END IF;

  SELECT COUNT(NR_SEQUENCIA)
    INTO STRICT NR_SEQUENCIAW 
  FROM SCHEM_TEST_LOG WHERE NR_SEQ_SCHEDULE = NR_SEQ_SCHEDULE_P AND IE_STATUS = '4';

  IF (NR_SEQUENCIAW <> 0) THEN
     UPDATE SCHEM_TEST_SCHEDULE SET IE_STATUS = '3' WHERE NR_SEQUENCIA = NR_SEQ_SCHEDULE_P;
     commit;
  END IF;

 SELECT COUNT(NR_SEQUENCIA)
  INTO STRICT NR_SEQUENCIAW
  FROM SCHEM_TEST_SCHEDULE 
  WHERE NR_SEQUENCIA = NR_SEQ_SCHEDULE_P 
  AND IE_STATUS = '3' 
  AND (NR_SEQ_PACKAGE IS NOT NULL AND NR_SEQ_PACKAGE::text <> '')
  AND IE_JOBS NOT IN ('1','2');

  IF (NR_SEQUENCIAW <> 0) THEN
    SELECT NR_SEQ_PACKAGE
    INTO STRICT NR_SEQ_PACKAGEW
    FROM SCHEM_TEST_SCHEDULE WHERE NR_SEQUENCIA = NR_SEQ_SCHEDULE_P;

      UPDATE SCHEM_TEST_PACKAGE_SCHED SET IE_STATUS = '3' WHERE NR_SEQUENCIA = NR_SEQ_PACKAGEW;
      commit;
  END IF;

  CALL SCHEMATIC4TEST_SETSCHEDSTATUS(NR_SEQ_SCHEDULE_P);

  EXCEPTION
  WHEN no_data_found THEN
    RAISE NOTICE 'Erro: Data not found';
END;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE validar_schematic4test_passou (NR_SEQ_SCHEDULE_P bigint, NR_SEQ_SCRIPT_P bigint, NM_USUARIO_P text) FROM PUBLIC;
