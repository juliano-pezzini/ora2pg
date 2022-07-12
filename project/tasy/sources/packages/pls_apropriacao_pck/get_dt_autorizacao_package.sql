-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';




CREATE OR REPLACE FUNCTION pls_apropriacao_pck.get_dt_autorizacao () RETURNS timestamp AS $body$
BEGIN
	if (current_setting('pls_apropriacao_pck.pls_parametros_w')::pls_parametros%rowtype.ie_data_base_coparticipacao = 'I') then
		return pls_apropriacao_pck.get_dt_item();
	else
		return pls_apropriacao_pck.get_dt_competencia_conta();
	end if;
END;

$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON FUNCTION pls_apropriacao_pck.get_dt_autorizacao () FROM PUBLIC;
