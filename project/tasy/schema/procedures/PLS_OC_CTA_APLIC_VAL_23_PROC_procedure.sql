-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE pls_oc_cta_aplic_val_23_proc ( dados_regra_p pls_tipos_ocor_pck.dados_regra, dados_validacao_p pls_tipos_ocor_pck.dados_regra_val_util_item, nr_id_transacao_p pls_oc_cta_selecao_ocor_v.nr_id_transacao%type, nm_usuario_p usuario.nm_usuario%type ) AS $body$
BEGIN
-- descontinuada
null;
end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE pls_oc_cta_aplic_val_23_proc ( dados_regra_p pls_tipos_ocor_pck.dados_regra, dados_validacao_p pls_tipos_ocor_pck.dados_regra_val_util_item, nr_id_transacao_p pls_oc_cta_selecao_ocor_v.nr_id_transacao%type, nm_usuario_p usuario.nm_usuario%type ) FROM PUBLIC;
