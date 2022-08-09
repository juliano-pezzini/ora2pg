-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE schematic4test_setupdateos (NR_SEQ_PACK_SCHED_P bigint, NR_SEQ_SCHEDULE_P bigint, NR_SEQ_SCRIPT_P bigint, NR_OS_P bigint, DS_OS_P text, DS_SEVERIDADE_P text, NM_USUARIO_P text) AS $body$
DECLARE

NR_SEQ_SCHEDULE_W bigint;
COUNTERPW bigint;

BEGIN
     --procedure that insert SO
	INSERT INTO SCHEM_TEST_BEHOLDER(nr_sequencia, nm_usuario, dt_atualizacao, nm_usuario_nrec, dt_atualizacao_nrec, ds_interaction, ds_param_a, ds_param_b, ds_param_c, ds_param_d, ds_param_e)
	VALUES (nextval('schem_test_beholder_seq'), NM_USUARIO_P, clock_timestamp(), 'Robot', clock_timestamp(), 'SCHEMATIC4TEST_SETUPDATEOS',
	'NR_SEQ_PACK_SCHED_P as '||NR_SEQ_PACK_SCHED_P, 
	'NR_SEQ_SCHEDULE_P as '||NR_SEQ_SCHEDULE_P, 
	'NR_OS_P as '||NR_OS_P, 
	'DS_OS_P as '||DS_OS_P, 
	'DS_SEVERIDADE_P as '||DS_SEVERIDADE_P);

    IF (NR_SEQ_SCRIPT_P IS NOT NULL AND NR_SEQ_SCRIPT_P::text <> '') THEN
        INSERT INTO SCHEM_TEST_OS(NR_SEQUENCIA, NR_OS, NR_SEQ_SCRIPT, NR_SEQ_PACK_SCHED, NR_SEQ_SCHEDULE, DS_OS, IE_SITUACAO, DS_SEVERIDADE, DT_ATUALIZACAO, NM_USUARIO, DT_ATUALIZACAO_NREC, NM_USUARIO_NREC)
            VALUES (nextval('schem_test_os_seq'), NR_OS_P, NR_SEQ_SCRIPT_P, NR_SEQ_PACK_SCHED_P, NR_SEQ_SCHEDULE_P, DS_OS_P, 'A', DS_SEVERIDADE_P, clock_timestamp(), NM_USUARIO_P, clock_timestamp(), NM_USUARIO_P);
        COMMIT;

      SELECT count(NR_SEQUENCIA) NR_SEQUENCIA
        INTO STRICT COUNTERPW
      FROM SCHEM_TEST_SCHEDULE 
      WHERE NR_SEQ_PACKAGE = NR_SEQ_PACK_SCHED_P
      AND IE_STATUS IN ('3','4');

      IF (COUNTERPW <> 0) THEN
          SELECT MAX(NR_SEQUENCIA) NR_SEQUENCIA
            INTO STRICT NR_SEQ_SCHEDULE_W
          FROM SCHEM_TEST_SCHEDULE 
          WHERE NR_SEQ_PACKAGE = NR_SEQ_PACK_SCHED_P
          AND IE_STATUS IN ('3','4');

          CALL SCHEMATIC4TEST_SETSCHEDSTATUS(NR_SEQ_SCHEDULE_W);
      END IF;

      UPDATE SCHEM_TEST_LOG SET IE_OS = 'S' WHERE NR_SEQ_SCHEDULE = NR_SEQ_SCHEDULE_P AND NR_SEQ_SCRIPT = NR_SEQ_SCRIPT_P;
    END IF;

    EXCEPTION
    WHEN no_data_found THEN
        RAISE NOTICE 'Erro: Data not found';
end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE schematic4test_setupdateos (NR_SEQ_PACK_SCHED_P bigint, NR_SEQ_SCHEDULE_P bigint, NR_SEQ_SCRIPT_P bigint, NR_OS_P bigint, DS_OS_P text, DS_SEVERIDADE_P text, NM_USUARIO_P text) FROM PUBLIC;
