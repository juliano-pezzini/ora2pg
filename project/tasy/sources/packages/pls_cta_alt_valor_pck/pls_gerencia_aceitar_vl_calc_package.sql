-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';




CREATE OR REPLACE PROCEDURE pls_cta_alt_valor_pck.pls_gerencia_aceitar_vl_calc ( nr_seq_conta_p pls_conta_v.nr_sequencia%type, nr_seq_conta_proc_p pls_conta_proc_v.nr_sequencia%type, nr_seq_conta_mat_p pls_conta_mat_v.nr_sequencia%type, cd_acao_analise_p pls_acao_analise.cd_acao%type, nm_usuario_p usuario.nm_usuario%type) AS $body$
DECLARE

ie_tipo_item_w    varchar(1);

BEGIN

ie_tipo_item_w  := pls_util_cta_pck.pls_obter_tipo_item_atend(nr_seq_conta_p, nr_seq_conta_proc_p, nr_seq_conta_mat_p, null);

case ie_tipo_item_w
  -- conta
  when 'C' then
    -- n?o implementado
    wheb_mensagem_pck.exibir_mensagem_abort(251500);
  -- procedimento
  when 'P' then
    pls_cta_alt_valor_pck.pls_aceitar_vl_calc_proc(nr_seq_conta_p, nr_seq_conta_proc_p, cd_acao_analise_p, nm_usuario_p);
    -- atualiza a tabela pls_proc_participante com os novos valores
    CALL CALL pls_cta_alt_valor_pck.pls_atualiza_proc_participante(  nr_seq_conta_proc_p, nm_usuario_p);
    -- atualiza dados complementares dos procedimentos
    CALL CALL pls_cta_alt_valor_pck.pls_atualiza_dados_comp_proc(nr_seq_conta_proc_p, nm_usuario_p);
  -- material
  when 'M' then
    pls_cta_alt_valor_pck.pls_aceitar_vl_calc_mat(nr_seq_conta_p, nr_seq_conta_mat_p, cd_acao_analise_p, nm_usuario_p);
  -- participante
  when 'R' then
    -- n?o implementado
    wheb_mensagem_pck.exibir_mensagem_abort(251501);
end case;


END;

$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE pls_cta_alt_valor_pck.pls_gerencia_aceitar_vl_calc ( nr_seq_conta_p pls_conta_v.nr_sequencia%type, nr_seq_conta_proc_p pls_conta_proc_v.nr_sequencia%type, nr_seq_conta_mat_p pls_conta_mat_v.nr_sequencia%type, cd_acao_analise_p pls_acao_analise.cd_acao%type, nm_usuario_p usuario.nm_usuario%type) FROM PUBLIC;
