-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';




CREATE OR REPLACE PROCEDURE pls_regra_partic_imp_pck.processa_partic_duplic_prest ( dados_val_partic_p pls_ocor_imp_pck.dados_val_partic, nr_id_transacao_p pls_oc_cta_selecao_imp.nr_id_transacao%type, nm_usuario_p usuario.nm_usuario%type) AS $body$
BEGIN

if (dados_val_partic_p.ie_incidencia = 'GP') then
	CALL CALL pls_regra_partic_imp_pck.partic_duplic_prest_proc_imp( dados_val_partic_p, nr_id_transacao_p, nm_usuario_p);
else
	-- busca pela guia entre outros
	CALL CALL pls_regra_partic_imp_pck.partic_duplic_prest_guia_imp( dados_val_partic_p, nr_id_transacao_p, nm_usuario_p);
end if;

END;

$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE pls_regra_partic_imp_pck.processa_partic_duplic_prest ( dados_val_partic_p pls_ocor_imp_pck.dados_val_partic, nr_id_transacao_p pls_oc_cta_selecao_imp.nr_id_transacao%type, nm_usuario_p usuario.nm_usuario%type) FROM PUBLIC;
