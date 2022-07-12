-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';




CREATE OR REPLACE FUNCTION ish_param_pck.get_cd_estab_ant () RETURNS bigint AS $body$
BEGIN
if (current_setting('ish_param_pck.cd_estabelecimento_ant_w')::estabelecimento.cd_estabelecimento%coalesce(type::text, '') = '') then
	CALL ish_param_pck.set_cd_estab_ant(obter_estabelecimento_ativo);
end if;

return current_setting('ish_param_pck.cd_estabelecimento_ant_w')::estabelecimento.cd_estabelecimento%type;
END;

$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON FUNCTION ish_param_pck.get_cd_estab_ant () FROM PUBLIC;
