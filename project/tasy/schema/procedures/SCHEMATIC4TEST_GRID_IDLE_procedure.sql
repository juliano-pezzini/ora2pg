-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE schematic4test_grid_idle (STATUS_P bigint) AS $body$
DECLARE

QTD_IDLE_W bigint;


BEGIN
	--procedure that set machine to idle or occupied
	SELECT COUNT(NR_SEQUENCIA) QTD_IDLE
		INTO STRICT QTD_IDLE_W
	FROM SCHEM_TEST_SCHEDULE sche WHERE sche.IE_STATUS = '2';

	IF (QTD_IDLE_W = 0) THEN
		UPDATE SCHEM_TEST_GRID SET IE_STATUS = to_char(STATUS_P);
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
-- REVOKE ALL ON PROCEDURE schematic4test_grid_idle (STATUS_P bigint) FROM PUBLIC;
