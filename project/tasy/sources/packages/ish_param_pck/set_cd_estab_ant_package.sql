-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';




CREATE OR REPLACE PROCEDURE ish_param_pck.set_cd_estab_ant (cd_estabelecimento_p bigint) AS $body$
BEGIN

if (cd_estabelecimento_p IS NOT NULL AND cd_estabelecimento_p::text <> '') then
	PERFORM set_config('ish_param_pck.cd_estabelecimento_ant_w', cd_estabelecimento_p, false);
end if;

END;

$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE ish_param_pck.set_cd_estab_ant (cd_estabelecimento_p bigint) FROM PUBLIC;