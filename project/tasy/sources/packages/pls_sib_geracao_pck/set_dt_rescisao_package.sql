-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';


--Data de rescisao



CREATE OR REPLACE PROCEDURE pls_sib_geracao_pck.set_dt_rescisao ( dt_rescisao_p timestamp, dt_rescisao_ant_p pls_sib_segurado.dt_cancelamento%type, ie_alteracao_p INOUT text) AS $body$
BEGIN
if (pls_sib_geracao_pck.consultar_sib_regra_opcional(31) = 'S') then
	current_setting('pls_sib_geracao_pck.tb_dt_rescisao_w')::pls_util_cta_pck.t_date_table(current_setting('pls_sib_geracao_pck.indice_w')::bigint) := dt_rescisao_p;
	current_setting('pls_sib_geracao_pck.tb_dt_rescisao_ant_w')::pls_util_cta_pck.t_date_table(current_setting('pls_sib_geracao_pck.indice_w')::bigint) := dt_rescisao_ant_p;
	ie_alteracao_p	:= 'S';
end if;
END;

$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE pls_sib_geracao_pck.set_dt_rescisao ( dt_rescisao_p timestamp, dt_rescisao_ant_p pls_sib_segurado.dt_cancelamento%type, ie_alteracao_p INOUT text) FROM PUBLIC;