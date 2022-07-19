-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE schematic4test_setupdatenight (IE_SWITCH_P bigint) AS $body$
BEGIN
    --procedure that update night building
    IF (IE_SWITCH_P IS NOT NULL AND IE_SWITCH_P::text <> '') THEN
        UPDATE SCHEM_TEST_SWITCH SET IE_SWITCH = to_char(IE_SWITCH_P), DT_ATUALIZACAO = clock_timestamp(), NM_USUARIO = 'Auto Robot' WHERE NR_INDEX = 130;

        IF (IE_SWITCH_P = 0) THEN
            UPDATE SCHEM_TEST_SWITCH SET DS_VALUE = 'http://srv-jks-vv-01.whebdc.com.br/generic-webhook-trigger/invoke?token=devtec', DT_ATUALIZACAO = clock_timestamp(), NM_USUARIO = 'Auto Robot' WHERE NR_INDEX = 140;
            UPDATE SCHEM_TEST_SWITCH SET DS_VALUE = 'C:\Tasy', DT_ATUALIZACAO = clock_timestamp(), NM_USUARIO = 'Auto Robot' WHERE NR_INDEX = 150;
            UPDATE SCHEM_TEST_SWITCH SET DS_VALUE = '\\srv-app-vv.whebdc.com.br\webapps_devTec', DT_ATUALIZACAO = clock_timestamp(), NM_USUARIO = 'Auto Robot' WHERE NR_INDEX = 160;
        ELSE
            UPDATE SCHEM_TEST_SWITCH SET DS_VALUE  = NULL, DT_ATUALIZACAO = clock_timestamp(), NM_USUARIO = 'Auto Robot' WHERE NR_INDEX = 140;
			UPDATE SCHEM_TEST_SWITCH SET DS_VALUE  = NULL, DT_ATUALIZACAO = clock_timestamp(), NM_USUARIO = 'Auto Robot' WHERE NR_INDEX = 150;
			UPDATE SCHEM_TEST_SWITCH SET DS_VALUE  = NULL, DT_ATUALIZACAO = clock_timestamp(), NM_USUARIO = 'Auto Robot' WHERE NR_INDEX = 160;
        END IF;

        COMMIT;
    END IF;
    EXCEPTION
    WHEN no_data_found THEN
        RAISE NOTICE 'Erro: Data not found';
end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE schematic4test_setupdatenight (IE_SWITCH_P bigint) FROM PUBLIC;

