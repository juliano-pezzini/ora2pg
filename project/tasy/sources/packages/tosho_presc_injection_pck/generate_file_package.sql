-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';




CREATE OR REPLACE PROCEDURE tosho_presc_injection_pck.generate_file (EVENT_CODE_P bigint, FILE_NAME_P text, FILE_DATA_P text) AS $body$
DECLARE


		    QT_MAXIMUM_SIZE_W	bigint	:= 32767;
			IE_WINDOWS_LINUX_W	varchar(2)	:= 'W';

			
BEGIN

		        PERFORM set_config('tosho_presc_injection_pck.ds_local_w', NULL, false);
				current_setting('tosho_presc_injection_pck.ds_local_w')::varchar(50) := PLS_UTL_FILE_PCK.NOVO_ARQUIVO(EVENT_CODE_P, FILE_NAME_P, 'S', QT_MAXIMUM_SIZE_W, current_setting('tosho_presc_injection_pck.ds_local_w')::varchar(50), IE_WINDOWS_LINUX_W); -- CREATE THE FILE
				CALL PLS_UTL_FILE_PCK.ESCREVER(FILE_DATA_P); --WRITE THE LINE IN THE FILE
				CALL PLS_UTL_FILE_PCK.FECHAR_ARQUIVO(); --CLOSE THE FILE AND SAVE			
			END;

$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE tosho_presc_injection_pck.generate_file (EVENT_CODE_P bigint, FILE_NAME_P text, FILE_DATA_P text) FROM PUBLIC;
