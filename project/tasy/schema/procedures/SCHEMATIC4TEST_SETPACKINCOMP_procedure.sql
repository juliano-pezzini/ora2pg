-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE schematic4test_setpackincomp (NR_SEQ_PACKAGE_P bigint, NM_USUARIO_P text) AS $body$
BEGIN
  --procedure that set incomplete  
  INSERT INTO SCHEM_TEST_BEHOLDER(nr_sequencia, nm_usuario, dt_atualizacao, nm_usuario_nrec, dt_atualizacao_nrec, ds_interaction, ds_param_a)
	VALUES (nextval('schem_test_beholder_seq'), NM_USUARIO_P, clock_timestamp(), 'Robot', clock_timestamp(), 'SCHEMATIC4TEST_SETPACKINCOMP',
	'NR_SEQ_PACKAGE_P as '||NR_SEQ_PACKAGE_P);

  UPDATE SCHEM_TEST_SCHEDULE SET IE_STATUS = '5', DT_ATUALIZACAO = clock_timestamp(), NM_USUARIO = NM_USUARIO_P WHERE NR_SEQUENCIA IN (SELECT sche.NR_SEQUENCIA FROM SCHEM_TEST_PACKAGE_SCHED sched,  SCHEM_TEST_SCHEDULE sche WHERE sched.NR_SEQUENCIA = sche.NR_SEQ_PACKAGE AND sched.NR_SEQUENCIA = NR_SEQ_PACKAGE_P);
  UPDATE SCHEM_TEST_PACKAGE_SCHED SET IE_STATUS = '5', DT_ATUALIZACAO = clock_timestamp(), NM_USUARIO = NM_USUARIO_P, IE_ESTAG_EXEC = '4' WHERE NR_SEQUENCIA = NR_SEQ_PACKAGE_P;
  COMMIT;
  EXCEPTION
  WHEN no_data_found THEN
    RAISE NOTICE 'Erro: Data not found';
END;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE schematic4test_setpackincomp (NR_SEQ_PACKAGE_P bigint, NM_USUARIO_P text) FROM PUBLIC;
