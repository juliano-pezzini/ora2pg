-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';




CREATE OR REPLACE FUNCTION pls_sib_geracao_pck.obter_se_alteracao_varchar ( ds_valor_ant_p text, ds_valor_novo_p text) RETURNS varchar AS $body$
BEGIN
if (upper(trim(both coalesce(ds_valor_ant_p,'X'))) <> upper(trim(both coalesce(ds_valor_novo_p,'X')))) then
	return 'S';
end if;
return 'N';
END;

$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON FUNCTION pls_sib_geracao_pck.obter_se_alteracao_varchar ( ds_valor_ant_p text, ds_valor_novo_p text) FROM PUBLIC;