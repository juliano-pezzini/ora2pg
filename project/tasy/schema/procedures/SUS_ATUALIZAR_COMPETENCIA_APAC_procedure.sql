-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE sus_atualizar_competencia_apac (nm_usuario_p text) AS $body$
DECLARE


dt_competencia_w	timestamp;


BEGIN

update	sus_parametros_apac
set 	dt_competencia_apac = trunc(clock_timestamp(),'month'),
	nm_usuario	= nm_usuario_p,
	dt_atualizacao	= clock_timestamp()
where	trunc(dt_competencia_apac,'month') < trunc(clock_timestamp(),'month');

commit;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE sus_atualizar_competencia_apac (nm_usuario_p text) FROM PUBLIC;

