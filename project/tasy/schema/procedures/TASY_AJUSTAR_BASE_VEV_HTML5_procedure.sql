-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE tasy_ajustar_base_vev_html5 (NM_USUARIO_P text) AS $body$
DECLARE

 QT_REGISTRO_W               bigint;
 DT_VERSAO_ATUAL_CLIENTE_W   timestamp;

BEGIN
/*FAVOR COLOCAR OS NOVOS AJUSTES SEMPRE NO FINAL DA PROCEDURE.*/

  CALL ABORTAR_SE_BASE_WHEB();
  DT_VERSAO_ATUAL_CLIENTE_W := coalesce(TO_DATE(TO_CHAR(OBTER_DATA_GERACAO_VERSAO-1,'dd/mm/yyyy') ||' 23:59:59','dd/mm/yyyy hh24:mi:ss'),clock_timestamp() - interval '90 days');

  IF (DT_VERSAO_ATUAL_CLIENTE_W < TO_DATE('24/05/2016','dd/mm/yyyy')) THEN
    SELECT COUNT(*)
      INTO STRICT QT_REGISTRO_W
      FROM USER_INDEXES
     WHERE INDEX_NAME = 'SCTETES_SCTEBRO_FK_I';

    IF (QT_REGISTRO_W > 0) THEN
      CALL EXEC_SQL_DINAMICO('rasantos','DROP INDEX SCTETES_SCTEBRO_FK_I');
    END IF;
    --------
    SELECT COUNT(*)
      INTO STRICT QT_REGISTRO_W
      FROM USER_CONS_COLUMNS
     WHERE CONSTRAINT_NAME = 'SCTETES_SCTEBRO_FK';

    IF (QT_REGISTRO_W > 0) THEN
      CALL EXEC_SQL_DINAMICO('rasantos','ALTER TABLE SCHEM_TEST_TEST DROP CONSTRAINT SCTETES_SCTEBRO_FK');
    END IF;
    --------
    SELECT COUNT(*)
      INTO STRICT QT_REGISTRO_W
      FROM USER_TAB_COLUMNS
     WHERE COLUMN_NAME = 'NR_SEQ_BROWSER'
       AND TABLE_NAME  = 'SCHEM_TEST_TEST';

    IF (QT_REGISTRO_W > 0) THEN
      CALL EXEC_SQL_DINAMICO('rasantos','ALTER TABLE SCHEM_TEST_TEST DROP COLUMN NR_SEQ_BROWSER');
    END IF;
  END IF;

  IF (DT_VERSAO_ATUAL_CLIENTE_W < TO_DATE('24/05/2016','dd/mm/yyyy')) THEN
    SELECT COUNT(*)
      INTO STRICT QT_REGISTRO_W
      FROM USER_INDEXES
     WHERE INDEX_NAME = 'SCTESUI_SCTEURL_FK_I';

    IF (QT_REGISTRO_W > 0) THEN
      CALL EXEC_SQL_DINAMICO('rasantos','DROP INDEX SCTESUI_SCTEURL_FK_I');
    END IF;
    --------
    SELECT COUNT(*)
      INTO STRICT QT_REGISTRO_W
      FROM USER_CONS_COLUMNS
     WHERE CONSTRAINT_NAME = 'SCTESUI_SCTEURL_FK';

    IF (QT_REGISTRO_W > 0) THEN
      CALL EXEC_SQL_DINAMICO('rasantos','ALTER TABLE SCHEM_TEST_SUITE DROP CONSTRAINT SCTESUI_SCTEURL_FK');
    END IF;
    --------
    SELECT COUNT(*)
      INTO STRICT QT_REGISTRO_W
      FROM USER_TAB_COLUMNS
     WHERE COLUMN_NAME = 'NR_SEQ_URL'
       AND TABLE_NAME  = 'SCHEM_TEST_SUITE';

    IF (QT_REGISTRO_W > 0) THEN
      CALL EXEC_SQL_DINAMICO('rasantos','ALTER TABLE SCHEM_TEST_SUITE DROP COLUMN NR_SEQ_URL');
    END IF;
  END IF;

  IF (DT_VERSAO_ATUAL_CLIENTE_W < TO_DATE('24/05/2016','dd/mm/yyyy')) THEN
    SELECT COUNT(*)
      INTO STRICT QT_REGISTRO_W
      FROM USER_INDEXES
     WHERE INDEX_NAME = 'SCTESUI_SCTESER_FK_I';

    IF (QT_REGISTRO_W > 0) THEN
      CALL EXEC_SQL_DINAMICO('rasantos','DROP INDEX SCTESUI_SCTESER_FK_I');
    END IF;
    --------
    SELECT COUNT(*)
      INTO STRICT QT_REGISTRO_W
      FROM USER_CONS_COLUMNS
     WHERE CONSTRAINT_NAME = 'SCTESUI_SCTESER_FK';

    IF (QT_REGISTRO_W > 0) THEN
      CALL EXEC_SQL_DINAMICO('rasantos','ALTER TABLE SCHEM_TEST_SUITE DROP CONSTRAINT SCTESUI_SCTESER_FK');
    END IF;
    --------
    SELECT COUNT(*)
      INTO STRICT QT_REGISTRO_W
      FROM USER_TAB_COLUMNS
     WHERE COLUMN_NAME = 'NR_SEQ_SERVICE'
       AND TABLE_NAME  = 'SCHEM_TEST_SUITE';

    IF (QT_REGISTRO_W > 0) THEN
      CALL EXEC_SQL_DINAMICO('rasantos','ALTER TABLE SCHEM_TEST_SUITE DROP COLUMN NR_SEQ_SERVICE');
    END IF;
  END IF;

  IF (DT_VERSAO_ATUAL_CLIENTE_W < TO_DATE('24/05/2016','dd/mm/yyyy')) THEN
    SELECT COUNT(*)
      INTO STRICT QT_REGISTRO_W
      FROM USER_TAB_COLUMNS
     WHERE COLUMN_NAME = 'DS_ACTION'
       AND TABLE_NAME  = 'SCHEM_TEST_LOG';

    IF (QT_REGISTRO_W > 0) THEN
      CALL EXEC_SQL_DINAMICO('rasantos','ALTER TABLE SCHEM_TEST_LOG DROP COLUMN DS_ACTION');
    END IF;
    --------
    SELECT COUNT(*)
      INTO STRICT QT_REGISTRO_W
      FROM USER_TAB_COLUMNS
     WHERE COLUMN_NAME = 'NR_TIIME_RUN'
       AND TABLE_NAME  = 'SCHEM_TEST_LOG';

    IF (QT_REGISTRO_W > 0) THEN
      CALL EXEC_SQL_DINAMICO('rasantos','ALTER TABLE SCHEM_TEST_LOG DROP COLUMN NR_TIIME_RUN');
    END IF;
  END IF;

END;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE tasy_ajustar_base_vev_html5 (NM_USUARIO_P text) FROM PUBLIC;

