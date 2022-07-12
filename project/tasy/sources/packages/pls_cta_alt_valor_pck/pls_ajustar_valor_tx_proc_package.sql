-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';




CREATE OR REPLACE PROCEDURE pls_cta_alt_valor_pck.pls_ajustar_valor_tx_proc ( nr_seq_conta_p pls_conta_v.nr_sequencia%type, nr_seq_conta_proc_p pls_conta_proc_v.nr_sequencia%type, qt_liberada_p pls_conta_proc_v.qt_procedimento%type, vl_liberado_hi_p pls_conta_proc_v.vl_liberado_hi%type, vl_liberado_mat_p pls_conta_proc_v.vl_liberado_material%type, vl_liberado_co_p pls_conta_proc_v.vl_liberado_co%type, vl_lib_taxa_hi_p pls_conta_proc_v.vl_lib_taxa_servico%type, vl_lib_taxa_mat_p pls_conta_proc_v.vl_lib_taxa_material%type, vl_lib_taxa_co_p pls_conta_proc_v.vl_taxa_co%type, nm_usuario_p usuario.nm_usuario%type) AS $body$
DECLARE


ie_tipo_liberacao_w    pls_conta_proc_v.ie_tipo_liberacao%type;
vl_glosa_w      pls_conta_proc_v.vl_glosa%type;
vl_glosa_co_w      pls_conta_proc_v.vl_glosa_co%type;
vl_glosa_hi_w      pls_conta_proc_v.vl_glosa_hi%type;
vl_glosa_material_w    pls_conta_proc_v.vl_glosa_material%type;
vl_glosa_taxa_co_w    pls_conta_proc_v.vl_glosa_taxa_co%type;
vl_glosa_taxa_hi_w    pls_conta_proc_v.vl_glosa_taxa_servico%type;
vl_glosa_taxa_material_w  pls_conta_proc_v.vl_glosa_taxa_material%type;
vl_liberado_w      pls_conta_proc_v.vl_liberado%type;
vl_unitario_w      pls_conta_proc_v.vl_unitario%type;

C01 CURSOR(nr_seq_conta_proc_p    pls_conta_proc_v.nr_sequencia%type) FOR
  SELECT  a.nr_sequencia,
    a.vl_procedimento_imp,
    a.vl_co_ptu_imp,
    a.vl_procedimento_ptu_imp,
    a.vl_material_ptu_imp,
    a.vl_taxa_co_imp,
    a.vl_taxa_servico_imp,
    a.vl_taxa_material_imp,
    a.vl_lib_taxa_co,
    a.vl_lib_taxa_material,
    a.vl_lib_taxa_servico
  from  pls_conta_proc_v a
  where  a.nr_sequencia  = nr_seq_conta_proc_p;

BEGIN

ie_tipo_liberacao_w := 'P';

for r_C01_w in C01(nr_seq_conta_proc_p) loop
  --Verifica a diferen?a entra a taxa antiga liberada do item e a nova taxa liberada
  --nos casos de procedimento o valor liberado ? a soma dos valores individuais liberados
  vl_liberado_w  :=   vl_liberado_co_p + vl_liberado_hi_p + vl_liberado_mat_p +
           vl_lib_taxa_co_p + vl_lib_taxa_hi_p + vl_lib_taxa_mat_p;
  vl_unitario_w  := dividir(vl_liberado_w,qt_liberada_p);
  -- c?lculo das glosas
  -- se der valor negativo, a glosa ? sempre zero
  vl_glosa_co_w       := pls_util_cta_pck.pls_obter_vl_glosa(vl_liberado_co_p, r_C01_w.vl_co_ptu_imp);
  vl_glosa_hi_w       := pls_util_cta_pck.pls_obter_vl_glosa(vl_liberado_hi_p, r_C01_w.vl_procedimento_ptu_imp);
  vl_glosa_material_w     := pls_util_cta_pck.pls_obter_vl_glosa(vl_liberado_mat_p, r_C01_w.vl_material_ptu_imp);
  vl_glosa_taxa_co_w     := pls_util_cta_pck.pls_obter_vl_glosa(vl_lib_taxa_co_p, r_C01_w.vl_taxa_co_imp);
  vl_glosa_taxa_hi_w     := pls_util_cta_pck.pls_obter_vl_glosa(vl_lib_taxa_hi_p, r_C01_w.vl_taxa_servico_imp);
  vl_glosa_taxa_material_w   := pls_util_cta_pck.pls_obter_vl_glosa(vl_lib_taxa_mat_p, r_C01_w.vl_taxa_material_imp);
  -- soma tudo
  vl_glosa_w := (  vl_glosa_co_w + vl_glosa_hi_w + vl_glosa_material_w + vl_glosa_taxa_co_w + vl_glosa_taxa_hi_w +
      vl_glosa_taxa_material_w);

  update   pls_conta_proc set
    vl_liberado_co    = vl_liberado_co_p,
    vl_liberado_hi    = vl_liberado_hi_p,
    vl_liberado_material  = vl_liberado_mat_p,
    vl_lib_taxa_co    = vl_lib_taxa_co_p,
    vl_lib_taxa_servico  = vl_lib_taxa_hi_p,
    vl_lib_taxa_material  = vl_lib_taxa_mat_p,
    vl_glosa_co    = vl_glosa_co_w,
    vl_glosa_hi    = vl_glosa_hi_w,
    vl_glosa_material  = vl_glosa_material_w,
    vl_glosa_taxa_co  = vl_glosa_taxa_co_w,
    vl_glosa_taxa_servico  = vl_glosa_taxa_hi_w,
    vl_glosa_taxa_material  = vl_glosa_taxa_material_w,
    vl_liberado     = vl_liberado_w,
    qt_procedimento    = qt_liberada_p,
    ie_tipo_liberacao   = ie_tipo_liberacao_w,
    vl_unitario    = vl_unitario_w,
    vl_glosa    = vl_glosa_w,
    ie_status_pagamento  = pls_obter_stat_pag_item(ie_glosa, vl_liberado_w, vl_glosa_w),
    nm_usuario    = nm_usuario_p,
    dt_atualizacao    = clock_timestamp(),
    ie_status    = 'L'
  where  nr_sequencia    = r_C01_w.nr_sequencia;

end loop;

END;

$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE pls_cta_alt_valor_pck.pls_ajustar_valor_tx_proc ( nr_seq_conta_p pls_conta_v.nr_sequencia%type, nr_seq_conta_proc_p pls_conta_proc_v.nr_sequencia%type, qt_liberada_p pls_conta_proc_v.qt_procedimento%type, vl_liberado_hi_p pls_conta_proc_v.vl_liberado_hi%type, vl_liberado_mat_p pls_conta_proc_v.vl_liberado_material%type, vl_liberado_co_p pls_conta_proc_v.vl_liberado_co%type, vl_lib_taxa_hi_p pls_conta_proc_v.vl_lib_taxa_servico%type, vl_lib_taxa_mat_p pls_conta_proc_v.vl_lib_taxa_material%type, vl_lib_taxa_co_p pls_conta_proc_v.vl_taxa_co%type, nm_usuario_p usuario.nm_usuario%type) FROM PUBLIC;
