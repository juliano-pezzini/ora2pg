-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE schematic4test_startpackage () AS $body$
DECLARE

NR_SEQ_EXECUTION_W bigint;
NR_SEQ_SUITE_W bigint;
NR_SEQ_URL_W bigint;
NR_SEQ_BROWSER_W bigint;
NR_SEQ_SERVICE_W bigint;
NR_SEQUENCIA_W bigint;
NR_SEQ_PACKAGE_W bigint;
DS_INFO_W varchar(255);
DS_VERSION_W varchar(255);
NM_USUARIO_NREC_W varchar(15);
DT_SCHEDULE_W timestamp;
QTD_W bigint;
QTD_ENV_URL_W bigint;
QTD_Agendamento bigint;
QTD_PACOTE_W bigint;
QTD_SCHEDULE_W bigint;
QTD_PACKAGE_W bigint;
QTD_SCRIPT_W bigint;
QTD_INSERT_W bigint;
QTD_AGENDAMENTO_W bigint;

--loop packages
C01 CURSOR FOR
  SELECT packsched.NR_SEQUENCIA NR_SEQUENCIA, packsched.NR_SEQ_PACKAGE NR_SEQ_PACKAGE, packsched.DT_SCHEDULE DT_SCHEDULE, packsched.DS_INFO DS_INFO, packsched.NM_USUARIO_NREC, packsched.DS_VERSION
       INTO STRICT NR_SEQUENCIA_W, NR_SEQ_PACKAGE_W, DT_SCHEDULE_W, DS_INFO_W, NM_USUARIO_NREC_W, DS_VERSION_W
     FROM SCHEM_TEST_PACKAGE_SCHED packsched
     WHERE packsched.DT_SCHEDULE < clock_timestamp() AND coalesce(packsched.DT_EXECUTION::text, '') = '' AND packsched.IE_STATUS = '1'
     GROUP BY packsched.NR_SEQUENCIA, packsched.NR_SEQ_PACKAGE, packsched.DT_SCHEDULE, packsched.DS_INFO, packsched.NM_USUARIO_NREC, packsched.DS_VERSION
     ORDER BY packsched.DT_SCHEDULE asc;

--loop suites in packages
C02 CURSOR FOR
    SELECT DISTINCT packitem.NR_SEQ_EXECUTION NR_SEQ_EXECUTION, packitem.NR_SEQ_SUITE NR_SEQ_SUITE, packitem.NR_SEQ_URL NR_SEQ_URL, packitem.NR_SEQ_BROWSER NR_SEQ_BROWSER, packitem.NR_SEQ_SERVICE NR_SEQ_SERVICE 
       INTO STRICT NR_SEQ_EXECUTION_W, NR_SEQ_SUITE_W, NR_SEQ_URL_W, NR_SEQ_BROWSER_W, NR_SEQ_SERVICE_W
    FROM SCHEM_TEST_PACKAGE_ITEM packitem
    WHERE packitem.NR_SEQ_PACKAGE = NR_SEQ_PACKAGE_W
    AND packitem.NR_SEQ_SUITE IN (SELECT NR_SEQ_SUITE FROM SCHEM_TEST_TEST GROUP BY NR_SEQ_SUITE HAVING COUNT(*) > 0)
    ORDER BY packitem.NR_SEQ_EXECUTION asc;
	

BEGIN
  --procedure that create schedule by package
  SELECT COUNT(packsched.NR_SEQ_PACKAGE) QTD_AGENDAMENTO
    INTO STRICT QTD_AGENDAMENTO
  FROM SCHEM_TEST_PACKAGE_SCHED packsched
  WHERE packsched.DT_SCHEDULE < clock_timestamp() AND coalesce(packsched.DT_EXECUTION::text, '') = '' AND packsched.IE_STATUS = '1';

  IF (QTD_AGENDAMENTO_W <> 0) THEN
    SELECT packsched.NR_SEQ_PACKAGE NR_SEQ_PACKAGE
      INTO STRICT NR_SEQ_PACKAGE_W
    FROM SCHEM_TEST_PACKAGE_SCHED packsched 
    WHERE packsched.DT_SCHEDULE < clock_timestamp() AND coalesce(packsched.DT_EXECUTION::text, '') = '' AND packsched.IE_STATUS = '1';

    CALL SCHEMATIC4TEST_CONFIGPACKAGE(NR_SEQ_PACKAGE_W, 'Auto Robot');
  END IF;

  OPEN C01;
    LOOP
    FETCH C01 INTO	
      NR_SEQUENCIA_W,
      NR_SEQ_PACKAGE_W, 
      DT_SCHEDULE_W,
      DS_INFO_W,
      NM_USUARIO_NREC_W,
      DS_VERSION_W;
    EXIT WHEN NOT FOUND; /* apply on C01 */
    BEGIN
      SELECT COUNT(DISTINCT snap.NR_SEQ_URL)
          INTO STRICT QTD_ENV_URL_W
      FROM SCHEM_TEST_SNAPSHOT snap, SCHEM_TEST_PACKAGE_ITEM packitem, SCHEM_TEST_PACKAGE_SCHED packsche
      WHERE snap.NR_SEQ_URL = packitem.NR_SEQ_URL
      AND packitem.NR_SEQ_PACKAGE = NR_SEQ_PACKAGE_W
      AND packsche.NR_SEQ_PACKAGE = packitem.NR_SEQ_PACKAGE
      AND snap.IE_STATUS <> '0'
      AND snap.NR_SEQ_URL IN (SELECT NR_SEQ_URL FROM SCHEM_TEST_SCHEDULE WHERE IE_STATUS NOT IN ('3','4','5'));

      SELECT COUNT(url1.IE_STATUS) QTD
          INTO STRICT QTD_W
      FROM SCHEM_TEST_URL url1, SCHEM_TEST_PACKAGE_ITEM packitem 
      WHERE url1.NR_SEQUENCIA = packitem.NR_SEQ_URL
      AND packitem.NR_SEQ_PACKAGE = NR_SEQ_PACKAGE_W
      AND url1.IE_STATUS = '1';

      IF (QTD_W <> 0 AND QTD_ENV_URL_W < 1) THEN 
          UPDATE SCHEM_TEST_PACKAGE_SCHED SET IE_STATUS = '1' WHERE NR_SEQUENCIA = NR_SEQUENCIA_W;
          COMMIT;	

          OPEN C02;
          LOOP
          FETCH C02 INTO	
            NR_SEQ_EXECUTION_W,
            NR_SEQ_SUITE_W, 
            NR_SEQ_URL_W, 
            NR_SEQ_BROWSER_W, 
            NR_SEQ_SERVICE_W;
          EXIT WHEN NOT FOUND; /* apply on C02 */
          BEGIN	  	
           SELECT COUNT(NR_SEQUENCIA) 
                INTO STRICT QTD_SCHEDULE_W
            FROM SCHEM_TEST_SCHEDULE 
            WHERE NR_SEQ_PACKAGE = NR_SEQUENCIA_W;

            SELECT COUNT(item.NR_SEQUENCIA) 
                INTO STRICT QTD_PACOTE_W 
            FROM SCHEM_TEST_PACKAGE_ITEM item
            INNER JOIN SCHEM_TEST_PACKAGE pack ON (item.NR_SEQ_PACKAGE = pack.NR_SEQUENCIA)
            WHERE item.NR_SEQ_PACKAGE = NR_SEQ_PACKAGE_W
            AND item.NR_SEQ_SUITE IN (SELECT NR_SEQ_SUITE FROM SCHEM_TEST_TEST GROUP BY NR_SEQ_SUITE HAVING COUNT(*) > 0);

            IF (QTD_SCHEDULE_W < QTD_PACOTE_W) THEN    
              SELECT COUNT(NR_SEQUENCIA) QTD_INSERT
                INTO QTD_INSERT_W
              FROM SCHEM_TEST_SCHEDULE 
              WHERE NR_SEQ_PACKAGE = NR_SEQUENCIA_W
              AND NR_SEQ_SUITE = NR_SEQ_SUITE_W
			  AND NR_SEQ_URL = NR_SEQ_URL_W;
              
              IF (QTD_INSERT_W = 0) THEN            
                  INSERT INTO SCHEM_TEST_SCHEDULE(nr_sequencia, dt_schedule, ie_status, nm_owner, nr_seq_suite, dt_atualizacao, nm_usuario, dt_atualizacao_nrec, nm_usuario_nrec, nr_seq_url, nr_seq_service, nr_seq_browser, ie_jobs, nr_seq_package, ds_info, ds_version)
                        VALUES (nextval('schem_test_schedule_seq'), clock_timestamp(), '1', NM_USUARIO_NREC_W, NR_SEQ_SUITE_W, clock_timestamp(), NM_USUARIO_NREC_W, clock_timestamp(), NM_USUARIO_NREC_W, NR_SEQ_URL_W, NR_SEQ_SERVICE_W, NR_SEQ_BROWSER_W, '0', NR_SEQUENCIA_W, DS_INFO_W, DS_VERSION_W);
                  COMMIT;
              END IF;
           END IF;
          END;
          END LOOP;
          CLOSE C02;
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
-- REVOKE ALL ON PROCEDURE schematic4test_startpackage () FROM PUBLIC;
