-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';




CREATE OR REPLACE PROCEDURE pls_cta_alt_valor_pck.pls_aceitar_vl_apres_proc ( nr_seq_conta_p pls_conta_v.nr_sequencia%type, nr_seq_conta_proc_p pls_conta_proc_v.nr_sequencia%type, cd_acao_analise_p pls_acao_analise.cd_acao%type, nm_usuario_p usuario.nm_usuario%type) AS $body$
DECLARE


ie_tipo_conta_w   pls_conta_v.ie_tipo_conta%type;
ie_tipo_liberacao_w  pls_conta_proc_v.ie_tipo_liberacao%type;
dados_retorno_w    dados_vl_tx_libe;
vl_unitario_w    pls_conta_proc.vl_unitario%type;

C01 CURSOR(nr_seq_conta_proc_p    pls_conta_proc_v.nr_sequencia%type) FOR
  SELECT  a.nr_sequencia,
    a.vl_procedimento_imp,
    a.qt_procedimento_imp,
    a.vl_unitario_imp,
    a.vl_co_ptu_imp,
    a.vl_procedimento_ptu_imp,
    a.vl_material_ptu_imp,
    a.vl_taxa_co_imp,
    a.vl_taxa_servico_imp,
    a.vl_taxa_material_imp,
    a.tx_intercambio,
    a.tx_intercambio_imp
  from  pls_conta_proc a
  where  a.nr_sequencia  = nr_seq_conta_proc_p;

BEGIN
-- obt?m o tipo de conta
ie_tipo_conta_w := pls_util_cta_pck.pls_obter_tipo_conta(nr_seq_conta_p);
ie_tipo_liberacao_w := 'A';

for r_C01_w in C01(nr_seq_conta_proc_p) loop

  -- se for interc?mbio
  if (ie_tipo_conta_w = 'I') then
    -- Passar os valores que ser?o liberados para o mesmo tipo dos campos liberados com arredondamento de valor
    -- Calcular a diferen?a entre os liberados e apresentados, para diminuir qualquer diferen?a
    dados_retorno_w  :=  pls_cta_alt_valor_pck.pls_calc_vl_lib_vl_calc(  r_C01_w.vl_procedimento_ptu_imp,  r_C01_w.vl_material_ptu_imp,
                  r_C01_w.vl_co_ptu_imp, r_C01_w.vl_taxa_servico_imp,
                  r_C01_w.vl_taxa_material_imp, r_C01_w.vl_taxa_co_imp,
                  r_C01_w.vl_procedimento_ptu_imp, r_C01_w.vl_material_ptu_imp,
                  r_C01_w.vl_co_ptu_imp, r_C01_w.vl_taxa_servico_imp,
                  r_C01_w.vl_taxa_material_imp, r_C01_w.vl_taxa_co_imp,
                  r_c01_w.tx_intercambio_imp, r_c01_w.tx_intercambio);

    vl_unitario_w := round((dividir_sem_round(r_C01_w.vl_procedimento_imp, r_C01_w.qt_procedimento_imp))::numeric, 2);

    -- processo de Atualizar pagamento e cobran?a (OPS - Processos de contas m?dicas)
    if (cd_acao_analise_p = 7) then

      update   pls_conta_proc set
        vl_liberado_co    = dados_retorno_w.vl_liberado_co,
        vl_liberado_hi    = dados_retorno_w.vl_liberado_hi,
        vl_liberado_material  = dados_retorno_w.vl_liberado_mat,
        vl_lib_taxa_co    = dados_retorno_w.vl_lib_taxa_co,
        vl_lib_taxa_servico  = dados_retorno_w.vl_lib_taxa_hi,
        vl_lib_taxa_material  = dados_retorno_w.vl_lib_taxa_mat,
        vl_glosa_co    = 0,
        vl_glosa_hi    = 0,
        vl_glosa_material  = 0,
        vl_glosa_taxa_co  = 0,
        vl_glosa_taxa_servico  = 0,
        vl_glosa_taxa_material  = 0,
        vl_liberado     = r_C01_w.vl_procedimento_imp,
        qt_procedimento    = r_C01_w.qt_procedimento_imp,
        vl_unitario    = vl_unitario_w,
        vl_glosa    = 0,
        nm_usuario    = nm_usuario_p,
        dt_atualizacao    = clock_timestamp()
      where  nr_sequencia    = r_C01_w.nr_sequencia;
    else
      -- processo default
      update   pls_conta_proc set
        vl_liberado_co    = dados_retorno_w.vl_liberado_co,
        vl_liberado_hi    = dados_retorno_w.vl_liberado_hi,
        vl_liberado_material  = dados_retorno_w.vl_liberado_mat,
        vl_lib_taxa_co    = dados_retorno_w.vl_lib_taxa_co,
        vl_lib_taxa_servico  = dados_retorno_w.vl_lib_taxa_hi,
        vl_lib_taxa_material  = dados_retorno_w.vl_lib_taxa_mat,
        vl_glosa_co    = 0,
        vl_glosa_hi    = 0,
        vl_glosa_material  = 0,
        vl_glosa_taxa_co  = 0,
        vl_glosa_taxa_servico  = 0,
        vl_glosa_taxa_material  = 0,
        vl_liberado     = r_C01_w.vl_procedimento_imp,
        qt_procedimento    = r_C01_w.qt_procedimento_imp,
        ie_tipo_liberacao   = ie_tipo_liberacao_w,
        vl_unitario    = vl_unitario_w,
        vl_glosa    = 0,
        ie_status_pagamento  = pls_obter_stat_pag_item(ie_glosa, r_C01_w.vl_procedimento_imp, 0),
        nm_usuario    = nm_usuario_p,
        dt_atualizacao    = clock_timestamp(),
        ie_status    = 'L'
      where  nr_sequencia    = r_C01_w.nr_sequencia;
    end if;

  -- para qualquer coisa faz o trabalho somente nos valores totais liberados
  else

    vl_unitario_w := round((dividir_sem_round(r_C01_w.vl_procedimento_imp, r_C01_w.qt_procedimento_imp))::numeric, 2);

    -- processo de Atualizar pagamento e cobran?a (OPS - Processos de contas m?dicas)
    if (cd_acao_analise_p = 7) then

      update   pls_conta_proc set
        vl_liberado     = r_C01_w.vl_procedimento_imp,
        qt_procedimento   = r_C01_w.qt_procedimento_imp,
        vl_unitario    = r_C01_w.vl_unitario_imp,
        vl_glosa    = 0,
        nm_usuario    = nm_usuario_p,
        dt_atualizacao    = clock_timestamp(),
        -- os campos abaixo s?o apenas informativos (zeramos por seguran?a)
        vl_liberado_co    = 0,
        vl_liberado_hi    = 0,
        vl_liberado_material  = 0,
        vl_lib_taxa_co    = 0,
        vl_lib_taxa_servico  = 0,
        vl_lib_taxa_material  = 0,
        vl_glosa_co    = 0,
        vl_glosa_hi    = 0,
        vl_glosa_material  = 0,
        vl_glosa_taxa_co  = 0,
        vl_glosa_taxa_servico  = 0,
        vl_glosa_taxa_material  = 0
      where  nr_sequencia    = r_C01_w.nr_sequencia;

    else

      update   pls_conta_proc set
        vl_liberado     = r_C01_w.vl_procedimento_imp,
        qt_procedimento   = r_C01_w.qt_procedimento_imp,
        ie_tipo_liberacao   = ie_tipo_liberacao_w,
        vl_unitario    = vl_unitario_w,
        vl_glosa    = 0,
        ie_status_pagamento  = pls_obter_stat_pag_item(ie_glosa, r_C01_w.vl_procedimento_imp, 0),
        nm_usuario    = nm_usuario_p,
        dt_atualizacao    = clock_timestamp(),
        -- os campos abaixo s?o apenas informativos (zeramos por seguran?a)
        vl_liberado_co    = 0,
        vl_liberado_hi    = 0,
        vl_liberado_material  = 0,
        vl_lib_taxa_co    = 0,
        vl_lib_taxa_servico  = 0,
        vl_lib_taxa_material  = 0,
        vl_glosa_co    = 0,
        vl_glosa_hi    = 0,
        vl_glosa_material  = 0,
        vl_glosa_taxa_co  = 0,
        vl_glosa_taxa_servico  = 0,
        vl_glosa_taxa_material  = 0,
        ie_status    = 'L'
      where  nr_sequencia    = r_C01_w.nr_sequencia;
    end if;
  end if;

end loop;

END;

$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE pls_cta_alt_valor_pck.pls_aceitar_vl_apres_proc ( nr_seq_conta_p pls_conta_v.nr_sequencia%type, nr_seq_conta_proc_p pls_conta_proc_v.nr_sequencia%type, cd_acao_analise_p pls_acao_analise.cd_acao%type, nm_usuario_p usuario.nm_usuario%type) FROM PUBLIC;