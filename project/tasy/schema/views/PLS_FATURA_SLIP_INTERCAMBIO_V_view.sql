-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';

CREATE OR REPLACE VIEW pls_fatura_slip_intercambio_v (cd_operadora_empresa, dt_mesano_referencia, cd_usuario_plano, cd_familia, nr_seq_pagador, nr_seq_prestador, cd_guia, dt_procedimento, dt_inicio_proc, qt_item, cd_doenca, vl_beneficiario, vl_sem_taxa, cd_medico_executor, nr_crm_exec, cd_cpf_cgc, nr_seq_fatura, nr_seq_segurado, dt_mes_competencia, cd_pf_segurado, nr_seq_titular, nr_seq_intercambio, nr_seq_conta, nm_prestador, cd_cid, nm_profissional_prestador, cd_especialidade, nr_cons_prof_prest, nr_cgc_cpf) AS select	substr(k.cd_operadora_empresa,1,20) cd_operadora_empresa,
	x.dt_mesano_referencia, 
	pls_obter_mascara_cart_emissor(n.cd_usuario_plano) cd_usuario_plano, 
	pls_obter_mascara_cart_emissor(substr(n.cd_usuario_plano, 1, 14)) cd_familia, 
	a.nr_seq_pagador, 
	h.nr_sequencia nr_seq_prestador, 
	d.cd_guia, 
	f.dt_procedimento, 
	f.dt_inicio_proc, 
	coalesce(e.qt_item,1) qt_item, 
	g.cd_doenca, 
	coalesce(e.vl_calculado,0) vl_beneficiario, 
	coalesce(CASE WHEN(coalesce(e.vl_medico,0) + coalesce(e.vl_custo_operacional,0) + coalesce(e.vl_materiais,0))=0 THEN (coalesce(e.vl_beneficiario,0) - coalesce(e.vl_administracao,0)) END , 
										(coalesce(e.vl_medico,0) + coalesce(e.vl_custo_operacional,0) + coalesce(e.vl_materiais,0))) vl_sem_taxa, 
	d.cd_medico_executor, 
	d.nr_crm_exec, 
	substr(CASE WHEN h.cd_pessoa_fisica IS NULL THEN  h.cd_cgc  ELSE pls_obter_dados_prestador(h.nr_sequencia, 'CPF') END ,1, 255) cd_cpf_cgc, 
	a.nr_sequencia nr_seq_fatura, 
	k.nr_sequencia nr_seq_segurado, 
	i.dt_mes_competencia, 
	k.cd_pessoa_fisica cd_pf_segurado, 
	CASE WHEN k.nr_seq_titular IS NULL THEN  k.nr_sequencia  ELSE k.nr_seq_titular END  nr_seq_titular, 
	k.nr_seq_intercambio, 
	d.nr_sequencia nr_seq_conta, 
	lpad(w.cd_unimed_prestador,3,'0') ||' - '|| substr(upper(elimina_acentos(pls_obter_dados_coop_codigo(cd_unimed_prestador,'NF'))),1,80) nm_prestador, 
	z.cd_cid, 
	w.nm_profissional_prestador, 
	w.cd_especialidade, 
	w.nr_cons_prof_prest, 
	w.nr_cgc_cpf 
FROM ptu_nota_cobranca z, pls_lote_faturamento x, ptu_nota_servico w, ptu_fatura r, pls_segurado_carteira n, pls_contrato_pagador m, pls_tipo_atendimento l, pls_segurado k, pls_intercambio j, pls_protocolo_conta i, pls_conta_pos_estabelecido e, pls_fatura_conta c, pls_fatura_evento b, pls_fatura a, pls_conta_proc f
LEFT OUTER JOIN pls_diagnostico_conta g ON (f.nr_sequencia = g.nr_seq_conta)
, pls_conta d
LEFT OUTER JOIN pls_prestador h ON (d.nr_seq_prestador_exec = h.nr_sequencia)
WHERE x.nr_sequencia			= a.nr_seq_lote and a.nr_sequencia 			= b.nr_seq_fatura and b.nr_sequencia 			= c.nr_seq_fatura_evento and d.nr_sequencia 			= c.nr_seq_conta and d.nr_sequencia 			= e.nr_seq_conta and f.nr_sequencia 			= e.nr_seq_conta_proc and a.nr_seq_lote 			= e.nr_seq_lote_fat   and i.nr_sequencia 			= d.nr_seq_protocolo and l.nr_sequencia 			= d.nr_seq_tipo_atendimento and j.nr_sequencia			= k.nr_seq_intercambio and m.nr_sequencia			= a.nr_seq_pagador and k.nr_sequencia 			= c.nr_seq_segurado and k.nr_sequencia			= n.nr_seq_segurado and f.nr_sequencia			= w.nr_seq_conta_proc and z.nr_sequencia			= w.nr_seq_nota_cobr and r.nr_sequencia			= z.nr_seq_fatura and r.nr_seq_pls_fatura is null and d.ie_origem_conta		= 'A' and (d.ie_tipo_guia = '3' 		or i.ie_tipo_guia = '3');

