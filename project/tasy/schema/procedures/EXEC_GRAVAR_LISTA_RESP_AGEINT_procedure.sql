-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE exec_gravar_lista_resp_ageint ( nr_seq_captacao_p mprev_captacao.nr_sequencia%type, nr_seq_partic_ciclo_item_p mprev_partic_ciclo_item.nr_sequencia%type, cd_estabelecimento_p estabelecimento.cd_estabelecimento%type, cd_pf_usuario_logado_p pessoa_fisica.cd_pessoa_fisica%type, nm_usuario_p usuario.nm_usuario%type) AS $body$
BEGIN
      CALL hdm_agendamento_ageint_pkg.gravar_lista_resp_ageint(
          nr_seq_captacao_p,
          nr_seq_partic_ciclo_item_p,
          cd_estabelecimento_p,
          cd_pf_usuario_logado_p,
          nm_usuario_p);
end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE exec_gravar_lista_resp_ageint ( nr_seq_captacao_p mprev_captacao.nr_sequencia%type, nr_seq_partic_ciclo_item_p mprev_partic_ciclo_item.nr_sequencia%type, cd_estabelecimento_p estabelecimento.cd_estabelecimento%type, cd_pf_usuario_logado_p pessoa_fisica.cd_pessoa_fisica%type, nm_usuario_p usuario.nm_usuario%type) FROM PUBLIC;
