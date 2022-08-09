-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE reg_autorizacao_clinica_ws ( nm_usuario_p text, nr_internacao_p bigint) AS $body$
BEGIN
	update	solicitacao_tasy_aghos
	set	ie_situacao = 'AC',
	ds_motivo_situacao = 'Solicitação autorizada clinicamente no Aghos'
	where	nr_internacao = nr_internacao_p;
commit;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE reg_autorizacao_clinica_ws ( nm_usuario_p text, nr_internacao_p bigint) FROM PUBLIC;
