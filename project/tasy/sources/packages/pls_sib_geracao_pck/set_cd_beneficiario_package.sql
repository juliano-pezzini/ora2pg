-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';


--CD Beneficiario



CREATE OR REPLACE PROCEDURE pls_sib_geracao_pck.set_cd_beneficiario ( cd_beneficiario_p pls_sib_segurado.cd_beneficiario%type, cd_beneficiario_ant_p pls_sib_segurado.cd_beneficiario%type, ie_alteracao_p INOUT text) AS $body$
BEGIN
if (pls_sib_geracao_pck.consultar_sib_regra_opcional(8) = 'S') then
	current_setting('pls_sib_geracao_pck.tb_cd_beneficiario_w')::pls_util_cta_pck.t_varchar2_table_50(current_setting('pls_sib_geracao_pck.indice_w')::bigint) := coalesce(cd_beneficiario_p,pls_sib_dados_benef_pck.cd_beneficiario);
	current_setting('pls_sib_geracao_pck.tb_cd_beneficiario_ant_w')::pls_util_cta_pck.t_varchar2_table_50(current_setting('pls_sib_geracao_pck.indice_w')::bigint) := cd_beneficiario_ant_p;
	ie_alteracao_p	:= 'S';
end if;
END;

$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE pls_sib_geracao_pck.set_cd_beneficiario ( cd_beneficiario_p pls_sib_segurado.cd_beneficiario%type, cd_beneficiario_ant_p pls_sib_segurado.cd_beneficiario%type, ie_alteracao_p INOUT text) FROM PUBLIC;
