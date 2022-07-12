-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';




CREATE OR REPLACE PROCEDURE pls_regra_partic_pck.processa_grau_duplic_part_dif (dados_val_partic_p pls_tipos_ocor_pck.dados_val_partic, nr_id_transacao_p pls_oc_cta_selecao_ocor_v.nr_id_transacao%type, dados_regra_p pls_tipos_ocor_pck.dados_regra, nm_usuario_p usuario.nm_usuario%type) AS $body$
BEGIN

-- se for para buscar o grau duplicado dentro do registro do procedimento (pls_conta_proc->nr_sequencia)

if (dados_val_partic_p.ie_incidencia = 'GP') then
	CALL CALL pls_regra_partic_pck.proces_grau_dupl_part_dif_proc(	nr_id_transacao_p,
					nm_usuario_p, 
					dados_val_partic_p);
else
	-- busca pela guia entre outros

	CALL CALL pls_regra_partic_pck.proces_grau_dupl_part_dif_guia(	dados_val_partic_p,
					nr_id_transacao_p,
					nm_usuario_p);
						
end if;

END;

$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE pls_regra_partic_pck.processa_grau_duplic_part_dif (dados_val_partic_p pls_tipos_ocor_pck.dados_val_partic, nr_id_transacao_p pls_oc_cta_selecao_ocor_v.nr_id_transacao%type, dados_regra_p pls_tipos_ocor_pck.dados_regra, nm_usuario_p usuario.nm_usuario%type) FROM PUBLIC;
