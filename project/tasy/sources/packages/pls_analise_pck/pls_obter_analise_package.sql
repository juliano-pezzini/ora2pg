-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';




CREATE OR REPLACE FUNCTION pls_analise_pck.pls_obter_analise ( nm_usuario_p text, nr_seq_grupo_atual_p bigint, nr_seq_analise_p bigint, ie_fluxo_com_glosa_p text, ie_somente_minha_analise_p text ) RETURNS SETOF VETOR AS $body$
DECLARE
	
	 
	
  rw RECORD;

BEGIN
	 
	FOR rw IN (	 
			SELECT	ie_ordem, 
				ie_ordem_titulo, 
				nr_sequencia, 
				nr_seq_conta, 
				nr_seq_item, 
				ds_item_despesa, 
				coalesce(cd_material, cd_item) cd_item, 
				ds_tipo_despesa, 
				ds_via_aces, 
				nr_seq_prestador_exec, 
				nm_prestador_exec, 
				dt_item, 
				ds_grau_part, 
				ie_origem_proced, 
				nr_seq_grau_partic, 
				tx_item, 
				qt_apresentado, 
				qt_liberado, 
				vl_unitario, 
				vl_total, 
				vl_unitario_apres, 
				vl_total_apres, 
				vl_calculado, 
				ds_guia, 
				nr_seq_conta_referencia, 
				nr_guia, 
				nr_seq_apres, 
				ie_status_item, 
				ie_situacao, 
				ie_ocorrencia_glosa, 
				nr_seq_protocolo, 
				nm_prestador_pagamento, 
				ie_status_conta, 
				ds_status_conta, 
				ds_seq_analise, 
				nr_seq_mot_liberacao, 
				cd_material, 
				cd_porte_anestesico, 
				nr_auxiliares, 
				ie_tipo_despesa, 
				nr_seq_guia, 
				ie_autorizado, 
				cd_classificacao_sip, 
				cd_classif_cred, 
				cd_classif_deb, 
				ie_tipo_item, 
				ie_carater_internacao, 
				ie_exige_nf, 
				cd_guia, 
				ie_tipo_guia, 
				nr_seq_res_conta_princ, 
				nr_seq_analise, 
				nr_seq_prestador_solic, 
				nm_prestador_solic, 
				ie_via_acesso, 
				ds_fornecedor, 
				ie_pagamento, 
				nr_identificador, 
				nr_seq_grupo_item, 
				nr_seq_prestador_pgto, 
				nr_seq_cbo_saude, 
				nr_seq_item_ref, 
				vl_uni_calculado, 
				ds_item_despesa_order, 
				nr_seq_apres_prof, 
				ds_setor_atendimento, 
				ds_unidade_medida, 
				nr_seq_partic_proc, 
				ie_tipo_glosa, 
				ds_item_importacao, 
				ds_medico_executor, 
				cd_tiss, 
				vl_glosa, 
				ie_gestacao, 
				ie_aborto, 
				ie_parto_normal, 
				ie_complicacao_puerperio, 
				ie_complicacao_neonatal, 
				ie_parto_cesaria, 
				ie_baixo_peso, 
				ie_atend_rn_sala_parto, 
				ie_transtorno, 
				ie_obito_mulher, 
				nm_usuario_liberacao, 
				nr_seq_conta_proc, 
				nr_seq_conta_mat, 
				nm_usuario_glosa, 
				vl_calculado_hi, 
				vl_calculado_co, 
				vl_calculado_mat, 
				vl_liberado_hi, 
				vl_liberado_co, 
				vl_liberado_mat, 
				vl_glosa_co, 
				vl_glosa_mat, 
				vl_glosa_hi, 
				ie_custo_operacional, 
				vl_diferenca, 
				ie_valor_base, 
				ds_espec_cbo, 
				ds_carater_internacao, 
				ds_exige_nf, 
				nr_conta_princ, 
				ie_guia, 
				ie_auditor_item, 
				ie_fluxo_com_glosa, 
				ie_fluxo_com_glosa_check, 
				ie_inserir, 
				ie_inserir_check 
			from	( 
				SELECT	CASE WHEN a.ds_tipo_despesa='P1' THEN '1' WHEN a.ds_tipo_despesa='P2' THEN '3' WHEN a.ds_tipo_despesa='P3' THEN '2' WHEN a.ds_tipo_despesa='P4' THEN '4' WHEN a.ds_tipo_despesa='M1' THEN '6' WHEN a.ds_tipo_despesa='M2' THEN '5' WHEN a.ds_tipo_despesa='M3' THEN '7' END  ie_ordem, 
					1 ie_ordem_titulo, 
					a.nr_sequencia, 
					a.nr_seq_conta, 
					a.nr_seq_item, 
					substr('     ' ||CASE WHEN a.ie_custo_operacional='S' THEN  '     '||a.nm_prestador_exec  ELSE CASE WHEN coalesce(coalesce(pls_obter_cod_mat_analise(a.cd_item, a.ds_tipo_despesa),a.cd_item),0)=0 THEN initcap(pls_obter_desc_item_desp(a.ds_tipo_despesa, 'S'))||' não reconhecido.'  ELSE a.ds_item END  END ,1,255) ds_item_despesa, 
					--substr('     ' ||decode(a.ie_custo_operacional, 'S', case when a.ie_tipo_guia = 5 then decode(nvl(nvl(pls_obter_cod_mat_analise(a.cd_item, a.ds_tipo_despesa),a.cd_item),0),0,initcap(pls_obter_desc_item_desp(a.ds_tipo_despesa, 'S'))||' não reconhecido.',a.ds_item) 
					--	else '     '||a.nm_prestador_exec end, decode(nvl(nvl(pls_obter_cod_mat_analise(a.cd_item, a.ds_tipo_despesa),a.cd_item),0),0,initcap(pls_obter_desc_item_desp(a.ds_tipo_despesa, 'S'))||' não reconhecido.',a.ds_item)),1,255) ds_item_despesa, 
					a.cd_item, 
					a.ds_tipo_despesa, 
					a.ds_via_acesso ds_via_aces, 
					a.nr_seq_prestador_exec, 
					a.nm_prestador nm_prestador_exec, 
					to_char(trunc(a.dt_item),'dd/mm/yyyy')||' '||to_char(a.dt_inicio_item, 'hh24:mi:ss') dt_item, 
					a.ds_grau_participacao ds_grau_part, 
					a.ie_origem_proced, 
					a.nr_seq_grau_partic, 
					a.tx_item, 
					a.qt_apresentado, 
					a.qt_liberado, 
					a.vl_unitario, 
					a.vl_total, 
					a.vl_unitario_apres,    
					a.vl_total_apres, 
					a.vl_calculado, 
					a.ds_tipo_guia ds_guia, 
					a.nr_seq_conta_referencia, 
					coalesce(a.cd_guia_referencia,a.cd_guia) nr_guia, 
					1 nr_seq_apres, 
					a.ie_status ie_status_item, 
					a.ie_situacao, 
					a.ie_ocorrencia_glosa, 
					a.nr_seq_protocolo, 
					a.nm_prestador_pagamento, 
					a.ie_status_conta, 
					a.ds_status_conta, 
					a.nr_seq_analise ds_seq_analise, 
					a.nr_seq_mot_liberacao, 
					substr(pls_obter_cod_mat_analise(a.cd_item, a.ds_tipo_despesa),1,20) cd_material, 
					a.cd_porte_anestesico, 
					a.nr_auxiliares, 
					a.ie_tipo_despesa, 
					a.nr_seq_guia, 
					a.ie_autorizado, 
					a.cd_classificacao_sip, 
					a.cd_classif_cred, 
					a.cd_classif_deb, 
					a.ie_tipo_item, 
					a.ie_carater_internacao, 
					a.ie_exige_nf, 
					a.cd_guia, 
					a.ie_tipo_guia, 
					a.nr_seq_res_conta_princ, 
					a.nr_seq_analise, 
					a.nr_seq_prestador_solic, 
					a.nm_prestador_solic, 
					a.ie_via_acesso, 
					a.ds_fornecedor, 
					a.ie_pagamento, 
					a.nr_identificador, 
					a.nr_seq_grupo_item, 
					a.nr_seq_prestador_pgto, 
					a.nr_seq_cbo_saude, 
					a.nr_seq_item_ref, 
					dividir_sem_round(a.vl_calculado, a.qt_apresentado) vl_uni_calculado, 
					a.ds_item ds_item_despesa_order, 
					a.nr_seq_apres_prof, 
					a.ds_setor_atendimento, 
					CASE WHEN a.ie_tipo_item='M' THEN  substr(pls_obter_dados_material(a.cd_item,'UM'),1,255)  ELSE null END  ds_unidade_medida, 
					0 nr_seq_partic_proc, 
					pls_obter_ie_valor_glosa(a.nr_seq_item, a.ie_tipo_item) ie_tipo_glosa, 
					a.ds_item_importacao, 
					CASE WHEN a.ie_tipo_item='P' THEN  substr(a.cd_medico_executor||' - '||obter_nome_pf(a.cd_medico_executor),1,255)  ELSE null END  ds_medico_executor, 
					coalesce(pls_obter_cd_tiss_participacao(a.nr_seq_grau_partic),'0') cd_tiss, 
					a.vl_glosa, 
					a.ie_gestacao, 
					a.ie_aborto, 
					a.ie_parto_normal, 
					a.ie_complicacao_puerperio, 
					a.ie_complicacao_neonatal, 
					a.ie_parto_cesaria, 
					a.ie_baixo_peso, 
					a.ie_atend_rn_sala_parto, 
					a.ie_transtorno, 
					a.ie_obito_mulher, 
					a.nm_usuario_liberacao, 
					a.nr_seq_conta_proc, 
					a.nr_seq_conta_mat, 
					a.nm_usuario_glosa, 
					coalesce(a.vl_calculado_hi,0) vl_calculado_hi, 
					coalesce(a.vl_calculado_co,0) vl_calculado_co, 
					coalesce(a.vl_calculado_material,0) vl_calculado_mat, 
					coalesce(a.vl_liberado_hi,0) vl_liberado_hi, 
					coalesce(a.vl_liberado_co,0) vl_liberado_co, 
					coalesce(a.vl_liberado_material,0) vl_liberado_mat, 
					coalesce(a.vl_glosa_co,0) vl_glosa_co, 
					coalesce(a.vl_glosa_material,0) vl_glosa_mat, 
					coalesce(a.vl_glosa_hi,0) vl_glosa_hi, 
					a.ie_custo_operacional, 
					(a.vl_total_apres - a.vl_calculado) vl_diferenca, 
					a.ie_valor_base, 
					SUBSTR(CASE WHEN a.nr_seq_cbo_saude='' THEN  pls_obter_cod_desc_cbos(a.nr_seq_cbo_saude) END ,1,255) ds_espec_cbo, 
					obter_valor_dominio(2819,a.ie_carater_internacao) ds_carater_internacao, 
					CASE WHEN a.ie_exige_nf='S' THEN 'Entregue' WHEN a.ie_exige_nf='N' THEN 'Não entregue' WHEN a.ie_exige_nf='E' THEN  'Exige'  ELSE '' END  ds_exige_nf, 
					coalesce(a.nr_seq_res_conta_princ, coalesce(a.nr_sequencia,0)) nr_conta_princ, 
					1 ie_guia, 
					pls_obter_item_acao_auditor(a.nr_sequencia, nm_usuario_p, nr_seq_grupo_atual_p, a.nr_seq_analise) ie_auditor_item, 
					ie_fluxo_com_glosa, 
					'' ie_fluxo_com_glosa_check,			 
					0 ie_inserir, 
					'' ie_inserir_check 
				from	w_pls_resumo_conta a 
				where	a.nr_seq_analise = nr_seq_analise_p 
				and	((a.ie_tipo_guia <> '6') or (exists (select 1 from pls_proc_participante x where x.nr_seq_conta_proc = a.nr_seq_conta_proc))) 
				and	a.ie_tipo_item <> 'R' 
				and	((((coalesce(ie_fluxo_com_glosa_p,'N') = 'N') or (coalesce(a.ie_fluxo_com_glosa,'N') = 'P')) 
				and 	 ((coalesce(IE_SOMENTE_MINHA_ANALISE_P,'N') = 'N') or (exists (  	select	x.nr_sequencia 
													from  pls_analise_grupo_item x, 
														pls_analise_conta_item y 
													where  x.nr_seq_item_analise  = y.nr_sequencia  
													and   x.nr_seq_grupo     = nr_seq_grupo_atual_P 
													and   ((y.nr_seq_conta_proc  = a.nr_seq_conta_proc) or (y.nr_seq_conta_mat  = a.nr_seq_conta_mat)	) LIMIT 1)))) 
				or    ((a.ie_tipo_item = 'P') and (exists  (    select z.nr_sequencia 
										    from  w_pls_resumo_conta z 
										    where  z.nr_seq_analise = a.nr_seq_analise 
										    and   z.nr_seq_item_ref = a.nr_seq_conta_proc 
										    and   z.ie_tipo_item = 'R'  
										    and   ((coalesce(ie_fluxo_com_glosa_p,'N') = 'N') or (z.ie_fluxo_com_glosa = 'P')) 
										    and   ((coalesce(IE_SOMENTE_MINHA_ANALISE_P,'N') = 'N') or (exists ( select   x.nr_sequencia 
																			 from    pls_analise_grupo_item x, 
																				   pls_analise_conta_item y 
																			 where    x.nr_seq_item_analise  = y.nr_sequencia  
																			 and     x.nr_seq_grupo     = nr_seq_grupo_atual_P 
																			 and (y.nr_seq_proc_partic = z.nr_seq_partic_proc) LIMIT 1))) LIMIT 1)))) 
				
union
 
				select	CASE WHEN ds_tipo_despesa='P1' THEN '1' WHEN ds_tipo_despesa='P2' THEN '3' WHEN ds_tipo_despesa='P3' THEN '2' WHEN ds_tipo_despesa='P4' THEN '4' WHEN ds_tipo_despesa='M1' THEN '6' WHEN ds_tipo_despesa='M2' THEN '5' WHEN ds_tipo_despesa='M3' THEN '7' END  ie_ordem, 
					0 ie_ordem_titulo, 
					null nr_sequencia, 
					null nr_seq_conta, 
					null nr_seq_item, 
					substr(pls_obter_desc_item_desp(ds_tipo_despesa, 'P'),1,255) ds_item_despesa, 
					null cd_item, 
					ds_tipo_despesa, 
					null ds_via_aces, 
					null nr_seq_prestador_exec, 
					null nm_prestador_exec, 
					null dt_item,	 
					null ds_grau_part, 
					null ie_origem_proced, 
					null nr_seq_grau_partic, 
					null tx_item, 
					null qt_apresentado, 
					null qt_liberado, 
					null vl_unitario, 
					null vl_total, 
					null vl_unitario_apres,    
					null vl_total_apres,  
					null vl_calculado, 
					null ds_guia, 
					null nr_seq_conta_referencia, 
					coalesce(cd_guia_referencia,cd_guia) nr_guia, 
					0 nr_seq_apres, 
					null ie_status_item, 
					null ie_situacao, 
					null ie_ocorrencia_glosa, 
					null nr_seq_protocolo, 
					null nm_prestador_pagamento, 
					null ie_status_conta, 
					null ds_status_conta, 
					null ds_seq_analise, 
					null nr_seq_mot_liberacao, 
					null cd_material, 
					null cd_porte_anestesico, 
					null nr_auxiliares, 
					ie_tipo_despesa, 
					null nr_seq_guia, 
					null ie_autorizado, 
					null cd_classificacao_sip, 
					null cd_classif_cred, 
					null cd_classif_deb, 
					null ie_tipo_item, 
					null ie_carater_internacao, 
					null ie_exige_nf, 
					null cd_guia, 
					null ie_tipo_guia, 
					null nr_seq_res_conta_princ, 
					nr_seq_analise nr_seq_analise, 
					null nr_seq_prestador_solic, 
					null nm_prestador_solic, 
					null ie_via_acesso, 
					'' ds_fornecedor, 
					null ie_pagamento, 
					null nr_identificador, 
					null nr_seq_grupo_item, 
					null nr_seq_prestador_pgto, 
					null nr_seq_cbo_saude, 
					null nr_seq_item_ref, 
					null vl_uni_calculado, 
					null ds_item_despesa_order, 
					null nr_seq_apres_prof, 
					null ds_setor_atendimento, 
					null ds_unidade_medida, 
					null nr_seq_partic_proc, 
					null ie_tipo_glosa, 
					null ds_item_importacao, 
					null ds_medico_executor, 
					null cd_tiss, 
					null vl_glosa, 
					null ie_gestacao, 
					null ie_aborto, 
					null ie_parto_normal, 
					null ie_complicacao_puerperio, 
					null ie_complicacao_neonatal, 
					null ie_parto_cesaria, 
					null ie_baixo_peso, 
					null ie_atend_rn_sala_parto, 
					null ie_transtorno, 
					null ie_obito_mulher, 
					null nm_usuario_liberacao, 
					null nr_seq_conta_proc, 
					null nr_seq_conta_mat, 
					null nm_usuario_glosa, 
					null vl_calculado_hi, 
					null vl_calculado_co, 
					null vl_calculado_mat, 
					null vl_liberado_hi, 
					null vl_liberado_co, 
					null vl_liberado_mat, 
					null vl_glosa_co, 
					null vl_glosa_mat, 
					null vl_glosa_hi, 
					null ie_custo_operacional, 
					null vl_diferenca, 
					null ie_valor_base, 
					null ds_espec_cbo, 
					null ds_carater_internacao, 
					null ds_exige_nf, 
					null nr_conta_princ, 
					null ie_guia, 
					null ie_auditor_item,			 
					null ie_fluxo_com_glosa, 
					'' ie_fluxo_com_glosa_check, 
					0 ie_inserir, 
					'' ie_inserir_check 
				from	w_pls_resumo_conta y 
				where	y.nr_seq_analise = nr_seq_analise_p 
				and	((ie_tipo_guia <> '6' AND ie_tipo_item <> 'R') 
				or	 ((pls_obter_existe_item_resumo(nr_seq_item) = 'N') and (not exists (	select	1 
														from	w_pls_resumo_conta x 
														where	x.ie_tipo_guia <> '6' 
														and 	x.ie_tipo_item <> 'R' 
														and	y.nr_seq_analise = x.nr_seq_analise 
														and	y.ie_tipo_despesa = x.ie_tipo_despesa  LIMIT 1)))) 
				and 	exists(	select	z.nr_sequencia 
						from	w_pls_resumo_conta z							 
						where	z.nr_seq_analise = y.nr_seq_analise							 
						and	z.ie_tipo_despesa = y.ie_tipo_despesa  
						and 	((coalesce(ie_fluxo_com_glosa_p,'N') = 'N') or (z.ie_fluxo_com_glosa = 'P')) 
						and 	((coalesce(IE_SOMENTE_MINHA_ANALISE_P,'N') = 'N') or  (exists ( select	x.nr_sequencia 
														   from	pls_analise_grupo_item x, 
																pls_analise_conta_item p 
														   where	x.nr_seq_item_analise 	= p.nr_sequencia 
														   and	x.nr_seq_grupo 		= nr_seq_grupo_atual_P  
														   and	((p.nr_seq_conta_proc  = z.nr_seq_conta_proc) 	or (p.nr_seq_conta_mat 	= z.nr_seq_conta_mat) 	or (p.nr_seq_proc_partic = z.nr_seq_partic_proc)) LIMIT 1))) LIMIT 1)		 
				group by ds_tipo_despesa, ie_tipo_despesa, coalesce(cd_guia_referencia,cd_guia), nr_seq_analise		 
				
union
 
				--Quando for a situação de que somente existe a informação do procedimento na HI (não existe na resumo de internação) 
				select	CASE WHEN ds_tipo_despesa='P1' THEN '1' WHEN ds_tipo_despesa='P2' THEN '3' WHEN ds_tipo_despesa='P3' THEN '2' WHEN ds_tipo_despesa='P4' THEN '4' WHEN ds_tipo_despesa='M1' THEN '6' WHEN ds_tipo_despesa='M2' THEN '5' WHEN ds_tipo_despesa='M3' THEN '7' END  ie_ordem, 
					1 ie_ordem_titulo, 
					null nr_sequencia, 
					null nr_seq_conta, 
					0 nr_seq_item,	 
					substr('     ' ||CASE WHEN coalesce(coalesce(pls_obter_cod_mat_analise(cd_item, ds_tipo_despesa),cd_item),0)=0 THEN InitCap(pls_obter_desc_item_desp(ds_tipo_despesa, 'S'))||' não reconhecido.'  ELSE ds_item END ,1,255) ds_item_despesa, 
					cd_item, 
					ds_tipo_despesa, 
					null ds_via_aces, 
					null nr_seq_prestador_exec, 
					null nm_prestador_exec, 
					to_char(trunc(dt_item),'dd/mm/yyyy')||' '||to_char(dt_inicio_item, 'hh24:mi:ss') dt_item, 
					null ds_grau_part, 
					ie_origem_proced, 
					null nr_seq_grau_partic, 
					null tx_item, 
					null qt_apresentado, 
					null qt_liberado, 
					(	select	coalesce(sum(x.vl_unitario),0) 
						from	w_pls_resumo_conta x 
						where	x.nr_seq_item_ref = a.nr_seq_item_ref 
						and	x.nr_seq_analise = a.nr_seq_analise 
						and	x.ie_tipo_item	 <> 'R') vl_unitario, 
					(	select	coalesce(sum(x.vl_total),0) 
						from	w_pls_resumo_conta x 
						where	x.nr_seq_item_ref = a.nr_seq_item_ref 
						and	x.nr_seq_analise = a.nr_seq_analise	 
						and	x.ie_tipo_item	 <> 'R') vl_total, 
					(	select	coalesce(sum(x.vl_unitario_apres),0) 
						from	w_pls_resumo_conta x 
						where	x.nr_seq_item_ref = a.nr_seq_item_ref 
						and	x.nr_seq_analise = a.nr_seq_analise	 
						and	x.ie_tipo_item	 <> 'R') vl_unitario_apres,    
					(	select	coalesce(sum(x.vl_total_apres),0)	 
						from	w_pls_resumo_conta x 
						where	x.nr_seq_item_ref = a.nr_seq_item_ref 
						and	x.nr_seq_analise = a.nr_seq_analise	 
						and	x.ie_tipo_item	 <> 'R') vl_total_apres, 
					(	select	coalesce(sum(x.vl_calculado),0) 
						from	w_pls_resumo_conta x 
						where	x.nr_seq_item_ref = a.nr_seq_item_ref 
						and	x.nr_seq_analise = a.nr_seq_analise	 
						and	x.ie_tipo_item	 <> 'R') vl_calculado, 
					null ds_guia, 
					null nr_seq_conta_referencia, 
					null nr_guia, 
					CASE WHEN ie_custo_operacional='S' THEN  0  ELSE 1 END  nr_seq_apres, 
					'I' ie_status_item, 
					null ie_situacao, 
					null ie_ocorrencia_glosa, 
					null nr_seq_protocolo, 
					null nm_prestador_pagamento, 
					null ie_status_conta, 
					null ds_status_conta, 
					nr_seq_analise ds_seq_analise, 
					null nr_seq_mot_liberacao, 
					null cd_material, 
					null cd_porte_anestesico, 
					null nr_auxiliares, 
					ie_tipo_despesa, 
					null nr_seq_guia, 
					null ie_autorizado, 
					null cd_classificacao_sip, 
					null cd_classif_cred, 
					null cd_classif_deb, 
					'P' ie_tipo_item, 
					null ie_carater_internacao, 
					null ie_exige_nf, 
					null cd_guia, 
					null ie_tipo_guia, 
					null nr_seq_res_conta_princ, 
					nr_seq_analise, 
					null nr_seq_prestador_solic, 
					null nm_prestador_solic, 
					null ie_via_acesso, 
					null ds_fornecedor, 
					substr(pls_obter_status_item_inf(nr_seq_item_ref, nr_seq_analise),1,1) ie_pagamento, 
					null nr_identificador, 
					null nr_seq_grupo_item, 
					null nr_seq_prestador_pgto, 
					null nr_seq_cbo_saude, 
					nr_seq_item_ref, 
					(	select	sum(dividir_sem_round(x.vl_calculado, x.qt_apresentado))	 
						from	w_pls_resumo_conta x 
						where	x.nr_seq_item_ref = a.nr_seq_item_ref 
						and	x.nr_seq_analise = a.nr_seq_analise	 
						and	x.ie_tipo_item	 <> 'R') vl_uni_calculado, 
					ds_item ds_item_despesa_order, 
					null nr_seq_apres_prof, 
					null ds_setor_atendimento, 
					null ds_unidade_medida, 
					null nr_seq_partic_proc, 
					null ie_tipo_glosa, 
					null ds_item_importacao, 
					null ds_medico_executor, 
					null cd_tiss, 
					(	select	coalesce(sum(x.vl_glosa),0) 
						from	w_pls_resumo_conta x 
						where	x.nr_seq_item_ref = a.nr_seq_item_ref 
						and	x.nr_seq_analise = a.nr_seq_analise	 
						and	x.ie_tipo_item	 <> 'R') vl_glosa, 
					null ie_gestacao, 
					null ie_aborto, 
					null ie_parto_normal, 
					null ie_complicacao_puerperio, 
					null ie_complicacao_neonatal, 
					null ie_parto_cesaria, 
					null ie_baixo_peso, 
					null ie_atend_rn_sala_parto, 
					null ie_transtorno, 
					null ie_obito_mulher, 
					null nm_usuario_liberacao, 
					null nr_seq_conta_proc, 
					null nr_seq_conta_mat, 
					null nm_usuario_glosa, 
					(	select	coalesce(sum(x.vl_calculado_hi),0) 
						from	w_pls_resumo_conta x 
						where	x.nr_seq_item_ref = a.nr_seq_item_ref 
						and	x.nr_seq_analise = a.nr_seq_analise	 
						and	x.ie_tipo_item	 <> 'R') vl_calculado_hi, 
					(	select	coalesce(sum(x.vl_calculado_co),0) 
						from	w_pls_resumo_conta x 
						where	x.nr_seq_item_ref = a.nr_seq_item_ref 
						and	x.nr_seq_analise = a.nr_seq_analise	 
						and	x.ie_tipo_item	 <> 'R') vl_calculado_co, 
					(	select	coalesce(sum(x.vl_calculado_material),0) 
						from	w_pls_resumo_conta x 
						where	x.nr_seq_item_ref = a.nr_seq_item_ref 
						and	x.nr_seq_analise = a.nr_seq_analise	 
						and	x.ie_tipo_item	 <> 'R') vl_calculado_material, 
					(	select	coalesce(sum(x.vl_liberado_hi),0) 
						from	w_pls_resumo_conta x 
						where	x.nr_seq_item_ref = a.nr_seq_item_ref 
						and	x.nr_seq_analise = a.nr_seq_analise	 
						and	x.ie_tipo_item	 <> 'R') vl_liberado_hi, 
					(	select	coalesce(sum(x.vl_liberado_co),0) 
						from	w_pls_resumo_conta x 
						where	x.nr_seq_item_ref = a.nr_seq_item_ref 
						and	x.nr_seq_analise = a.nr_seq_analise	 
						and	x.ie_tipo_item	 <> 'R') vl_liberado_co, 
					(	select	coalesce(sum(x.vl_glosa_co),0) 
						from	w_pls_resumo_conta x 
						where	x.nr_seq_item_ref = a.nr_seq_item_ref 
						and	x.nr_seq_analise = a.nr_seq_analise	 
						and	x.ie_tipo_item	 <> 'R') vl_glosa_co, 
					(	select	coalesce(sum(x.vl_liberado_material),0) 
						from	w_pls_resumo_conta x 
						where	x.nr_seq_item_ref = a.nr_seq_item_ref 
						and	x.nr_seq_analise = a.nr_seq_analise	 
						and	x.ie_tipo_item	 <> 'R') vl_liberado_material, 
					(	select	coalesce(sum(x.vl_glosa_material),0) 
						from	w_pls_resumo_conta x 
						where	x.nr_seq_item_ref = a.nr_seq_item_ref 
						and	x.nr_seq_analise = a.nr_seq_analise	 
						and	x.ie_tipo_item	 <> 'R') vl_glosa_material, 
					(	select	coalesce(sum(x.vl_glosa_hi),0) 
						from	w_pls_resumo_conta x 
						where	x.nr_seq_item_ref = a.nr_seq_item_ref 
						and	x.nr_seq_analise = a.nr_seq_analise	 
						and	x.ie_tipo_item	 <> 'R') vl_glosa_hi,		 
					null ie_custo_operacional, 
					null vl_diferenca, 
					null ie_valor_base, 
					null ds_espec_cbo, 
					null ie_carater_internacao, 
					null ds_exige_nf, 
					null nr_conta_princ, 
					1 ie_guia, 
					null ie_auditor_item, 
					null ie_fluxo_com_glosa, 
					'' ie_fluxo_com_glosa_check,			 
					0 ie_inserir, 
					'' ie_inserir_check 
				from	w_pls_resumo_conta a 
				where	a.nr_seq_analise = nr_seq_analise_p 
				and	(((ie_tipo_guia = '6') 
				and (not exists (	select	y.nr_sequencia 
								from	pls_conta_proc	x, 
									pls_conta	y 
								where	y.nr_sequencia	= x.nr_seq_conta 
								and	x.nr_sequencia	= a.nr_seq_item_ref 
								and	y.ie_tipo_guia = 5 	 LIMIT 1))) 
				or (ie_custo_operacional = 'S')) 
				and	ie_tipo_item not in ('R','M') 
				and	exists (	select z.nr_sequencia 
							from  w_pls_resumo_conta z 
							where  z.nr_seq_analise = a.nr_seq_analise 
							and   z.nr_seq_item_ref = a.nr_seq_item_ref 							 
							and   ((coalesce(ie_fluxo_com_glosa_p,'N') = 'N') or (z.ie_fluxo_com_glosa = 'P')) 
							and   ((coalesce(IE_SOMENTE_MINHA_ANALISE_P,'N') = 'N') or  (exists ( select    x.nr_sequencia 
															  from    pls_analise_grupo_item x, 
																	pls_analise_conta_item y 
															  where    x.nr_seq_item_analise  = y.nr_sequencia 
															  and     x.nr_seq_grupo     = nr_seq_grupo_atual_P 
															  and     ((y.nr_seq_conta_proc  = z.nr_seq_conta_proc) or (y.nr_seq_conta_mat  = z.nr_seq_conta_mat)  or (y.nr_seq_proc_partic = z.nr_seq_partic_proc))  LIMIT 1))) LIMIT 1) 
				and	not exists (	select	1 
							from	pls_proc_participante x 
							where	x.nr_seq_conta_proc = a.nr_seq_item) 
				group by ds_tipo_despesa, 
					 cd_item, 
					 dt_item, 
					 dt_inicio_item, 
					 ie_origem_proced, 
					 nr_seq_analise, 
					 ie_tipo_despesa, 
					 nr_seq_analise, 
					 ds_item,	 
					 nr_seq_item_ref, 
					 ie_custo_operacional 
				
union
 
				select	CASE WHEN ds_tipo_despesa='P1' THEN '1' WHEN ds_tipo_despesa='P2' THEN '3' WHEN ds_tipo_despesa='P3' THEN '2' WHEN ds_tipo_despesa='P4' THEN '4' WHEN ds_tipo_despesa='R1' THEN '1' WHEN ds_tipo_despesa='R2' THEN '3' WHEN ds_tipo_despesa='R3' THEN '2' WHEN ds_tipo_despesa='R4' THEN '4' WHEN ds_tipo_despesa='M1' THEN '6' WHEN ds_tipo_despesa='M2' THEN '5' WHEN ds_tipo_despesa='M3' THEN '7' END  ie_ordem, 
					1 ie_ordem_titulo, 
					nr_sequencia, 
					nr_seq_conta, 
					nr_seq_item,	 
					substr('              ' ||nm_participante,1,255) ds_item_despesa, 
					cd_item, 
					ds_tipo_despesa, 
					null ds_via_aces, 
					nr_seq_prestador_exec, 
					null nm_prestador_exec, 
					null dt_item,	 
					ds_grau_participacao ds_grau_part, 
					ie_origem_proced, 
					nr_seq_grau_partic, 
					null tx_item, 
					qt_apresentado, 
					qt_liberado, 
					vl_unitario, 
					vl_total, 
					null vl_unitario_apres,    
					null vl_total_apres, 
					vl_calculado, 
					ds_tipo_guia ds_guia, 
					nr_seq_conta_referencia, 
					null nr_guia, 
					CASE WHEN ie_tipo_guia='6' THEN  3  ELSE 2 END  nr_seq_apres, 
					ie_status ie_status_item, 
					ie_situacao, 
					ie_ocorrencia_glosa, 
					nr_seq_protocolo, 
					nm_prestador_pagamento, 
					null ie_status_conta, 
					null ds_status_conta, 
					nr_seq_analise ds_seq_analise, 
					nr_seq_mot_liberacao, 
					null cd_material, 
					null cd_porte_anestesico, 
					null nr_auxiliares, 
					ie_tipo_despesa, 
					null nr_seq_guia, 
					null ie_autorizado, 
					null cd_classificacao_sip, 
					null cd_classif_cred, 
					null cd_classif_deb, 
					ie_tipo_item, 
					null ie_carater_internacao, 
					null ie_exige_nf, 
					cd_guia, 
					ie_tipo_guia, 
					nr_seq_res_conta_princ, 
					nr_seq_analise, 
					null nr_seq_prestador_solic, 
					null nm_prestador_solic, 
					null ie_via_acesso, 
					null ds_fornecedor, 
					ie_pagamento, 
					nr_identificador, 
					nr_seq_grupo_item, 
					nr_seq_prestador_pgto, 
					null nr_seq_cbo_saude, 
					nr_seq_item_ref, 
					dividir_sem_round(vl_calculado, qt_apresentado) vl_uni_calculado, 
					ds_item ds_item_despesa_order, 
					nr_seq_apres_prof, 
					null ds_setor_atendimento, 
					null ds_unidade_medida, 
					nr_seq_partic_proc, 
					pls_obter_ie_valor_glosa(nr_seq_item, ie_tipo_item) ie_tipo_glosa, 
					null ds_item_importacao, 
					null ds_medico_executor, 
					pls_obter_cd_tiss_participacao(nr_seq_grau_partic) cd_tiss, 
					vl_glosa, 
					null ie_gestacao, 
					null ie_aborto, 
					null ie_parto_normal, 
					null ie_complicacao_puerperio, 
					null ie_complicacao_neonatal, 
					null ie_parto_cesaria, 
					null ie_baixo_peso, 
					null ie_atend_rn_sala_parto, 
					null ie_transtorno, 
					null ie_obito_mulher, 
					nm_usuario_liberacao, 
					nr_seq_conta_proc, 
					nr_seq_conta_mat, 
					nm_usuario_glosa, 
					coalesce(vl_calculado_hi,0) vl_calculado_hi, 
					null vl_calculado_co, 
					null vl_calculado_material, 
					coalesce(vl_liberado_hi,0) vl_liberado_hi, 
					null vl_liberado_co, 
					null vl_liberado_material, 
					null vl_glosa_co, 
					null vl_glosa_material, 
					coalesce(vl_glosa_hi,0) vl_glosa_hi, 
					null ie_custo_operacional, 
					null vl_diferenca, 
					ie_valor_base, 
					SUBSTR(CASE WHEN a.nr_seq_cbo_saude='' THEN  pls_obter_cod_desc_cbos(a.nr_seq_cbo_saude) END ,1,255) ds_espec_cbo, 
					null ie_carater_internacao, 
					null ds_exige_nf, 
					coalesce(a.nr_seq_res_conta_princ, coalesce(a.nr_sequencia,0)) nr_conta_princ, 
					1 ie_guia, 
					pls_obter_item_acao_auditor(a.nr_sequencia, nm_usuario_p, nr_seq_grupo_atual_p, a.nr_seq_analise) ie_auditor_item, 
					ie_fluxo_com_glosa, 
					'' ie_fluxo_com_glosa_check,			 
					0 ie_inserir, 
					'' ie_inserir_check 
				from	w_pls_resumo_conta a 
				where	a.nr_seq_analise = nr_seq_analise_p 
				and	ie_tipo_item = 'R' 
				and	((coalesce(ie_fluxo_com_glosa_p,'N') = 'N') or (coalesce(a.ie_fluxo_com_glosa,'N') = 'P')) 
				and 	((coalesce(IE_SOMENTE_MINHA_ANALISE_P,'N') = 'N') or  (exists ( select   x.nr_sequencia 
												  from    pls_analise_grupo_item x, 
														pls_analise_conta_item y 
												  where    x.nr_seq_item_analise  = y.nr_sequencia 
												  and     x.nr_seq_grupo     = nr_seq_grupo_atual_P  
												  and     ((y.nr_seq_conta_proc  = a.nr_seq_conta_proc) or (y.nr_seq_conta_mat  = a.nr_seq_conta_mat)  or (y.nr_seq_proc_partic = a.nr_seq_partic_proc)) LIMIT 1))) 
				
union
 
				select	CASE WHEN ds_tipo_despesa='P1' THEN '1' WHEN ds_tipo_despesa='P2' THEN '3' WHEN ds_tipo_despesa='P3' THEN '2' WHEN ds_tipo_despesa='P4' THEN '4' WHEN ds_tipo_despesa='M1' THEN '6' WHEN ds_tipo_despesa='M2' THEN '5' WHEN ds_tipo_despesa='M3' THEN '7' END  ie_ordem, 
					1 ie_ordem_titulo, 
					nr_sequencia, 
					CASE WHEN a.ie_tipo_guia=5 THEN a.nr_seq_conta  ELSE coalesce(a.nr_seq_conta_referencia,a.nr_seq_conta) END  nr_seq_conta, 
					nr_seq_item,	 
					substr('         ' ||nm_participante,1,255) ds_item_despesa, 
					cd_item, 
					ds_tipo_despesa, 
					ds_via_acesso ds_via_aces, 
					nr_seq_prestador_exec, 
					nm_prestador nm_prestador_exec, 
					to_char(trunc(dt_item),'dd/mm/yyyy')||' '||to_char(dt_inicio_item, 'hh24:mi:ss') dt_item,	 
					ds_grau_participacao ds_grau_part, 
					ie_origem_proced, 
					nr_seq_grau_partic, 
					tx_item, 
					qt_apresentado, 
					qt_liberado, 
					vl_unitario, 
					vl_total, 
					vl_unitario_apres,    
					vl_total_apres, 
					vl_calculado, 
					ds_tipo_guia ds_guia, 
					nr_seq_conta_referencia, 
					coalesce(cd_guia_referencia,cd_guia) nr_guia, 
					2 nr_seq_apres, 
					ie_status ie_status_item, 
					ie_situacao, 
					ie_ocorrencia_glosa, 
					nr_seq_protocolo, 
					nm_prestador_pagamento, 
					ie_status_conta, 
					ds_status_conta, 
					nr_seq_analise ds_seq_analise, 
					nr_seq_mot_liberacao, 
					substr(pls_obter_cod_mat_analise(cd_item, ds_tipo_despesa),1,20) cd_material, 
					cd_porte_anestesico, 
					nr_auxiliares, 
					ie_tipo_despesa, 
					nr_seq_guia, 
					ie_autorizado, 
					cd_classificacao_sip, 
					cd_classif_cred, 
					cd_classif_deb, 
					ie_tipo_item, 
					ie_carater_internacao, 
					ie_exige_nf, 
					cd_guia, 
					ie_tipo_guia, 
					nr_seq_res_conta_princ, 
					nr_seq_analise, 
					nr_seq_prestador_solic, 
					nm_prestador_solic, 
					ie_via_acesso, 
					ds_fornecedor, 
					ie_pagamento, 
					nr_identificador, 
					nr_seq_grupo_item, 
					nr_seq_prestador_pgto, 
					nr_seq_cbo_saude, 
					nr_seq_item_ref, 
					dividir_sem_round(vl_calculado, qt_apresentado) vl_uni_calculado, 
					ds_item ds_item_despesa_order, 
					nr_seq_apres_prof, 
					ds_setor_atendimento, 
					null ds_unidade_medida, 
					null nr_seq_partic_proc, 
					pls_obter_ie_valor_glosa(nr_seq_item, ie_tipo_item) ie_tipo_glosa, 
					ds_item_importacao, 
					null ds_medico_executor, 
					null cd_tiss, 
					vl_glosa, 
					ie_gestacao, 
					ie_aborto, 
					ie_parto_normal, 
					ie_complicacao_puerperio, 
					ie_complicacao_neonatal, 
					ie_parto_cesaria, 
					ie_baixo_peso, 
					ie_atend_rn_sala_parto, 
					ie_transtorno, 
					ie_obito_mulher, 
					nm_usuario_liberacao, 
					nr_seq_conta_proc, 
					nr_seq_conta_mat, 
					nm_usuario_glosa, 
					coalesce(vl_calculado_hi,0) vl_calculado_hi, 
					coalesce(vl_calculado_co,0) vl_calculado_co, 
					coalesce(vl_calculado_material,0) vl_calculado_material, 
					coalesce(vl_liberado_hi,0) vl_liberado_hi, 
					coalesce(vl_liberado_co,0) vl_liberado_co, 
					coalesce(vl_liberado_material,0) vl_liberado_material, 
					coalesce(vl_glosa_co,0) vl_glosa_co, 
					coalesce(vl_glosa_material,0) vl_glosa_material, 
					coalesce(vl_glosa_hi,0) vl_glosa_hi, 
					null ie_custo_operacional, 
					(vl_total_apres - vl_calculado) vl_diferenca, 
					ie_valor_base, 
					SUBSTR(CASE WHEN a.nr_seq_cbo_saude='' THEN  pls_obter_cod_desc_cbos(a.nr_seq_cbo_saude) END ,1,255) ds_espec_cbo, 
					obter_valor_dominio(2819,a.ie_carater_internacao) ds_carater_internacao, 
					null ds_exige_nf, 
					coalesce(a.nr_seq_res_conta_princ, coalesce(a.nr_sequencia,0)) nr_conta_princ, 
					10 ie_guia, 
					pls_obter_item_acao_auditor(a.nr_sequencia, nm_usuario_p, nr_seq_grupo_atual_p, a.nr_seq_analise) ie_auditor_item, 
					ie_fluxo_com_glosa, 
					'' ie_fluxo_com_glosa_check,			 
					0 ie_inserir, 
					'' ie_inserir_check 
				from	w_pls_resumo_conta a 
				where	ie_tipo_guia = '6' 
				and	ie_tipo_item <> 'R' 
				and	a.nr_seq_analise = nr_seq_analise_p 
				and	(((coalesce(ie_fluxo_com_glosa_p,'N') = 'N') or (coalesce(a.ie_fluxo_com_glosa,'N') = 'P')) 
				and 	 ((coalesce(IE_SOMENTE_MINHA_ANALISE_P,'N') = 'N') or (exists ( select    x.nr_sequencia 
												  from     pls_analise_grupo_item x, 
														pls_analise_conta_item y 
												  where    x.nr_seq_item_analise  = y.nr_sequencia  
												  and     x.nr_seq_grupo     = nr_seq_grupo_atual_P 
												  and     y.nr_seq_conta_proc 	= a.nr_seq_conta_proc	 LIMIT 1)))) 
				and	not exists (	select	1 
							from	pls_proc_participante x 
							where	x.nr_seq_conta_proc = a.nr_seq_item) 
				 
			) alias240			 
         ) loop 
	 RETURN NEXT rw;
	 end loop;
 
	END;	

$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION pls_analise_pck.pls_obter_analise ( nm_usuario_p text, nr_seq_grupo_atual_p bigint, nr_seq_analise_p bigint, ie_fluxo_com_glosa_p text, ie_somente_minha_analise_p text ) FROM PUBLIC;