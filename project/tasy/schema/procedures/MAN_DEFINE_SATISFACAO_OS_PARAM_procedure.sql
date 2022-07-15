-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE man_define_satisfacao_os_param ( ie_grau_satisfacao_p text, qt_dias_p bigint) AS $body$
BEGIN

update	man_ordem_servico
set	ie_grau_satisfacao	= ie_grau_satisfacao_p
where	trunc(dt_fim_real,'dd') < trunc(clock_timestamp(),'dd') - qt_dias_p
and	coalesce(ie_grau_satisfacao::text, '') = ''
and	ie_status_ordem		= '3';

commit;

END;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE man_define_satisfacao_os_param ( ie_grau_satisfacao_p text, qt_dias_p bigint) FROM PUBLIC;

