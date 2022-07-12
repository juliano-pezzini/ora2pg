-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';




CREATE OR REPLACE PROCEDURE pls_regra_partic_imp_pck.processa_regra_partic ( dados_val_partic_p pls_ocor_imp_pck.dados_val_partic, nr_id_transacao_p pls_oc_cta_selecao_imp.nr_id_transacao%type, nm_usuario_p usuario.nm_usuario%type) AS $body$
BEGIN

	if (dados_val_partic_p.ie_incidencia = 'GPDH') then
		-- busca pela regra dentro do segurado, guia, procedimento, data e hora do item
		CALL CALL pls_regra_partic_imp_pck.regra_partic_guia_dth_imp(	dados_val_partic_p, nr_id_transacao_p, nm_usuario_p);

	elsif (dados_val_partic_p.ie_incidencia = 'GPD') then
		-- busca pela regra dentro do segurado, guia, procedimento e data
		CALL CALL pls_regra_partic_imp_pck.regra_partic_guia_dt_imp(	dados_val_partic_p, nr_id_transacao_p, nm_usuario_p);
	else
		-- buscar pela regra dentro do procedimento
		CALL CALL pls_regra_partic_imp_pck.regra_partic_proc_imp(	dados_val_partic_p, nr_id_transacao_p, nm_usuario_p);
	end if;

END;

$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE pls_regra_partic_imp_pck.processa_regra_partic ( dados_val_partic_p pls_ocor_imp_pck.dados_val_partic, nr_id_transacao_p pls_oc_cta_selecao_imp.nr_id_transacao%type, nm_usuario_p usuario.nm_usuario%type) FROM PUBLIC;
