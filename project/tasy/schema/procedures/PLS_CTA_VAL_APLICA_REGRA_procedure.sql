-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE pls_cta_val_aplica_regra ( nr_id_transacao_p pls_rp_cta_selecao.nr_id_transacao%type, dados_regra_p pls_tipos_cta_val_pck.dados_regra, cd_estabelecimento_p estabelecimento.cd_estabelecimento%type, nm_usuario_p usuario.nm_usuario%type) AS $body$
BEGIN
-- essa procedure não existe mais e no lugar dela foi criada a pls_tipos_cta_val_pck.pls_cta_val_aplica_regra
null;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE pls_cta_val_aplica_regra ( nr_id_transacao_p pls_rp_cta_selecao.nr_id_transacao%type, dados_regra_p pls_tipos_cta_val_pck.dados_regra, cd_estabelecimento_p estabelecimento.cd_estabelecimento%type, nm_usuario_p usuario.nm_usuario%type) FROM PUBLIC;
