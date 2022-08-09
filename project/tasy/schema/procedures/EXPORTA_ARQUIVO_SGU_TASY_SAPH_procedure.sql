-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE exporta_arquivo_sgu_tasy_saph ( nm_usuario_p text) AS $body$
BEGIN
	UPDATE eme_contrato
	SET 	dt_envio   = clock_timestamp(),
		nm_usuario = nm_usuario_p;
commit;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE exporta_arquivo_sgu_tasy_saph ( nm_usuario_p text) FROM PUBLIC;
