-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';


--CCO



CREATE OR REPLACE PROCEDURE pls_sib_geracao_pck.set_cd_cco (cd_cco_p text) AS $body$
BEGIN
if (pls_sib_geracao_pck.consultar_sib_regra_opcional(30) = 'S') then
	if (cd_cco_p IS NOT NULL AND cd_cco_p::text <> '') then
		current_setting('pls_sib_geracao_pck.tb_cd_cco_w')::pls_util_cta_pck.t_varchar2_table_15(current_setting('pls_sib_geracao_pck.indice_w')::bigint) := cd_cco_p;
	else
		current_setting('pls_sib_geracao_pck.tb_cd_cco_w')::pls_util_cta_pck.t_varchar2_table_15(current_setting('pls_sib_geracao_pck.indice_w')::bigint) := pls_sib_dados_benef_pck.cd_cco;
	end if;
end if;
END;

$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE pls_sib_geracao_pck.set_cd_cco (cd_cco_p text) FROM PUBLIC;