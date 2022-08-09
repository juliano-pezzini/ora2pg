-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE schematic4test_setupdate_url () AS $body$
DECLARE

QTD_W bigint;
NR_SEQ_URL_W bigint;
NR_SEQ_SCHED_W bigint;
NM_USUARIO_NREC_W varchar(15);


BEGIN
  --procedure that set status url in cd ci
  SELECT COUNT(packsched.NR_SEQUENCIA) QTD
       INTO STRICT QTD_W
  FROM SCHEM_TEST_PACKAGE_SCHED packsched, SCHEM_TEST_URL url1
  WHERE url1.IE_STATUS = '0'
  AND packsched.IE_STATUS = '10'
  AND packsched.NM_USUARIO_NREC LIKE 'Dev-NightBuild';

  IF (QTD_W <> 0) THEN
    SELECT packscheditem.NR_SEQ_URL NR_SEQ_URL, packsched.NR_SEQUENCIA NR_SEQ_SCHED, packsched.NM_USUARIO_NREC
       INTO STRICT NR_SEQ_URL_W, NR_SEQ_SCHED_W, NM_USUARIO_NREC_W
    FROM SCHEM_TEST_PACKAGE_SCHED packsched, SCHEM_TEST_PACKAGE_ITEM packscheditem,  SCHEM_TEST_URL url1
    WHERE packsched.NR_SEQ_PACKAGE = packscheditem.NR_SEQ_PACKAGE
    AND url1.IE_STATUS = '0'
    AND packsched.IE_STATUS = '10'
    AND packsched.NM_USUARIO_NREC LIKE 'Dev-NightBuild'
    GROUP BY packscheditem.NR_SEQ_URL, packsched.NR_SEQUENCIA, packsched.NM_USUARIO_NREC;

    IF (NM_USUARIO_NREC_W LIKE 'Dev-NightBuild') THEN
      UPDATE SCHEM_TEST_URL SET IE_STATUS = '1', NM_USUARIO = 'Dev-NightBuild', DT_ATUALIZACAO = clock_timestamp() WHERE NR_SEQUENCIA = NR_SEQ_URL_W;
	  COMMIT;
    END IF;

    UPDATE SCHEM_TEST_PACKAGE_SCHED SET IE_STATUS = '1', NM_USUARIO = 'Dev-NightBuild', DT_ATUALIZACAO = clock_timestamp() WHERE NR_SEQUENCIA = NR_SEQ_SCHED_W;
    COMMIT;
  END IF;
  EXCEPTION
  WHEN no_data_found THEN
    RAISE NOTICE 'Erro: Data not found';
END;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE schematic4test_setupdate_url () FROM PUBLIC;
