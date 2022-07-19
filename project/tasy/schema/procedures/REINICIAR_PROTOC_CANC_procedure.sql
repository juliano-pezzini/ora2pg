-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE reiniciar_protoc_canc () AS $body$
BEGIN
	EXECUTE
		'DROP SEQUENCE AGENDA_PROTOC_CANC_PROT_SEQ';

	EXECUTE
		'CREATE SEQUENCE AGENDA_PROTOC_CANC_PROT_SEQ
			INCREMENT BY 1
			START WITH 1
			MAXVALUE  9999999999
			CYCLE
			NoCache';

commit;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE reiniciar_protoc_canc () FROM PUBLIC;

