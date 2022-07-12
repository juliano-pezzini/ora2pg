-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';

CREATE OR REPLACE VIEW hsfa_interf_dativa_envio_v (ds_registro, tp_registro, ie_servico, cd_registro, cd_origem, nr_lote, nr_interno_conta, nr_parcela, cd_convenio, nm_convenio, tp_prestador, cd_prestador, nm_prestador, dt_geracao, nr_remessa, cd_plano, cd_paciente, cd_autorizacao, cd_acomodacao, dt_entrada, dt_saida, dt_inicio_cobranca, dt_fim_cobranca, ie_tipo_atendimento, cd_cid, cd_proc_principal, cd_medico_convenio, nr_crm, uf_crm, nr_crm_req, uf_crm_req, nr_seq_item, cd_item, nm_item, ie_emergencia, ie_extra, dt_item, ie_funcao_medico, qt_item, vl_item, ie_cirurgia_multipla, vl_total_item, qt_item_conta, nm_paciente, nr_fatura, qt_conta, vl_total_lote, nr_seq_protocolo, ds_espaco, nr_registro, cd_cgc_prestador, cd_motivo_alta, ie_laudo_especial, ie_laudo_prorrogacao, dt_autorizacao, dt_validade_carteirinha, nr_prontuario, nm_medico_resp, ie_tipo_doc_paciente, nr_doc_paciente, ie_matmed, nr_crm_resp, uf_crm_resp, cd_senha, cd_especialidade, vl_proc_principal, ie_tipo_cirurgia, cd_unidade_atend, qt_diaria_enfermaria, qt_diaria_uti, cd_leitora, ie_fim_registro, ie_tipo_atend_tasy, nr_doc_convenio) AS select	'HEADER        '	ds_registro,
	1		tp_registro, 
	'CSMH'		ie_servico, 
	0		cd_registro, 
	somente_numero(coalesce(substr(a.cd_interno,1,5),0))	cd_origem, 
	0		nr_lote, 
	0		nr_interno_conta, 
	0		nr_parcela, 
	somente_numero(coalesce(a.cd_regional,0))	cd_convenio, 
	substr(elimina_acentuacao(upper(a.nm_convenio)),1,30) 
			nm_convenio, 
	'J'		tp_prestador, 
	a.cd_cgc_hospital	cd_prestador, 
	substr(elimina_acentuacao(upper(a.nm_hospital)),1,40) 
			nm_prestador, 
	a.dt_remessa	dt_geracao, 
	a.nr_remessa	nr_remessa, 
	0		cd_plano, 
	' '		cd_paciente,		 
	' '		cd_autorizacao, 
	'0'		cd_acomodacao, 
	LOCALTIMESTAMP		dt_entrada, 
	LOCALTIMESTAMP		dt_saida, 
	LOCALTIMESTAMP		dt_inicio_cobranca, 
	LOCALTIMESTAMP		dt_fim_cobranca, 
	0		ie_tipo_atendimento, 
	null		cd_cid, 
	' '		cd_proc_principal, 
	' '		cd_medico_convenio, 
	' '		nr_crm, 
	' '		uf_crm, 
	' '		nr_crm_req, 
	' '		uf_crm_req, 
	1		nr_seq_item, 
	' '		cd_item, 
	' '		nm_item, 
	' '		ie_emergencia, 
	' '		ie_extra, 
	LOCALTIMESTAMP		dt_item, 
	0		ie_funcao_medico, 
	0		qt_item, 
	0		vl_item, 
	0		ie_cirurgia_multipla, 
	0		vl_total_item, 
      	0		qt_item_conta, 
	' '		nm_paciente, 
      	' '	   	nr_fatura, 
      	0		qt_conta, 
      	0		vl_total_lote, 
	a.nr_seq_protocolo	nr_seq_protocolo, 
	'          '	ds_espaco, 
		1				nr_registro, 
		' '				cd_cgc_prestador, 
		0 				cd_motivo_alta, 
		' '				ie_laudo_especial, 
		' '				ie_laudo_prorrogacao, 
		LOCALTIMESTAMP				dt_autorizacao, 
		LOCALTIMESTAMP				dt_validade_carteirinha, 
		0				nr_prontuario, 
		' '				nm_medico_resp, 
		' '				ie_tipo_doc_paciente, 
		' '				nr_doc_paciente, 
		' '				ie_matmed, 
		0				nr_crm_resp, 
		' '				uf_crm_resp, 
		' '				cd_senha, 
		0				cd_especialidade, 
		0				vl_proc_principal, 
		0				ie_tipo_cirurgia, 
		0				cd_unidade_atend, 
		0				qt_diaria_enfermaria, 
		0				qt_diaria_uti, 
		0				cd_leitora, 
		'F'				ie_fim_registro, 
		0				ie_tipo_atend_tasy, 
		' '				nr_doc_convenio 
FROM		w_interf_conta_header a 

union all
 
select		'CABECALHO CONTA   '		ds_registro, 
		2				tp_registro, 
		'CSMH'				ie_servico, 
		1				cd_registro, 
		somente_numero(coalesce(substr(x.cd_interno,1,5),0))	cd_origem, 
		b.nr_seq_protocolo		nr_lote, 
		b.nr_interno_conta		nr_interno_conta, 
		1				nr_parcela, 
		0				cd_convenio, 
		' '				nm_convenio, 
		'J'				tp_prestador, 
		b.cd_cgc_hospital		cd_prestador, 
		' '				nm_prestador, 
		LOCALTIMESTAMP				dt_geracao, 
		0				nr_remessa, 
		somente_numero(substr(coalesce(b.cd_plano_convenio,cd_categoria_convenio),1,3)) 
						cd_plano, 
		substr(b.cd_usuario_convenio,1,18) 
						cd_paciente,		 
		substr(b.cd_senha_guia,1,10) 
						cd_autorizacao, 
		substr(obter_unidade_atendimento(b.nr_atendimento, 'A', 'CTA'),1,1) cd_acomodacao, 
		b.dt_entrada			dt_entrada, 
		coalesce(b.dt_alta,b.dt_periodo_final) 
						dt_saida, 
		b.dt_periodo_inicial		dt_inicio_cobranca, 
		coalesce(b.dt_alta,b.dt_periodo_final) 
						dt_fim_cobranca, 
		coalesce(b.ie_clinica,1)		ie_tipo_atendimento, 
		b.cd_cid_principal		cd_cid, 
		b.cd_proc_principal		cd_proc_principal, 
		b.cd_conv_medico_resp		cd_medico_convenio, 
		substr(b.nr_crm_medico_resp,1,6) nr_crm, 
		b.uf_crm_medico_resp		uf_crm, 
		b.nr_crm_medico_resp		nr_crm_req, 
		b.uf_crm_medico_resp		uf_crm_req, 
		1				nr_seq_item, 
		' '				cd_item, 
		' '				nm_item, 
		' '				ie_emergencia, 
		' '				ie_extra, 
		LOCALTIMESTAMP			dt_item, 
		0				ie_funcao_medico, 
		0				qt_item, 
		0				vl_item, 
		0				ie_cirurgia_multipla, 
      	0		   		vl_total_item, 
      	0	   			qt_item_conta, 
	   	' '				nm_paciente, 
      	' '	   			nr_fatura, 
      	0				qt_conta, 
      	0				vl_total_lote, 
		b.nr_seq_protocolo		nr_seq_protocolo, 
		' '				ds_espaco, 
		1				nr_registro, 
		b.cd_cgc_hospital		cd_cgc_prestador, 
		b.cd_motivo_alta		cd_motivo_alta, 
		'N'				ie_laudo_especial, 
		'N'				ie_laudo_prorrogacao, 
		c.dt_autorizacao			dt_autorizacao, 
		b.dt_validade_carteira		dt_validade_carteirinha, 
		b.nr_prontuario			nr_prontuario, 
		substr(b.nm_medico_resp,1,40)	nm_medico_resp, 
		CASE WHEN b.nr_cpf_paciente IS NULL THEN      		CASE WHEN b.nr_identidade IS NULL THEN '  '  ELSE 'CI ' END   ELSE 'CPF' END  
						ie_tipo_doc_paciente, 
		coalesce(b.nr_cpf_paciente,somente_numero(b.nr_identidade)) 
						nr_doc_paciente, 
		' '				ie_matmed, 
		0				nr_crm_resp, 
		' '				uf_crm_resp, 
		' '				cd_senha, 
		0				cd_especialidade, 
		0				vl_proc_principal, 
		0				ie_tipo_cirurgia, 
		0				cd_unidade_atend, 
		0				qt_diaria_enfermaria, 
		0				qt_diaria_uti, 
		0				cd_leitora, 
		'F'				ie_fim_registro, 
		b.ie_tipo_atendimento		ie_tipo_atend_tasy, 
		substr(b.nr_doc_convenio,1,8)	nr_doc_convenio 
FROM w_interf_conta_header x, w_interf_conta_cab b
LEFT OUTER JOIN w_interf_conta_autor c ON (b.nr_interno_conta = c.nr_interno_conta)
WHERE b.nr_seq_protocolo	= x.nr_seq_protocolo  and coalesce(c.nr_sequencia,0) = 
		(select coalesce(min(y.nr_sequencia),0) 
			from w_interf_conta_autor y 
			where b.nr_interno_conta = y.nr_interno_conta) 
 
union all
 
select   	'ITEM DA CONTA     ' 	ds_registro, 
      	3            	tp_registro, 
      	'CSMH'         	ie_servico, 
      	2            	cd_registro, 
      	somente_numero(coalesce(substr(x.cd_interno,1,5),0))	cd_origem, 
      	c.nr_seq_protocolo   	nr_lote, 
      	c.nr_interno_conta   	nr_interno_conta, 
      	max(c.nr_seq_item)	nr_parcela, 
      	0            	cd_convenio, 
      	' '            	nm_convenio, 
      	' '            	tp_prestador, 
      	' '            	cd_prestador, 
      	' '            	nm_prestador, 
      	LOCALTIMESTAMP         	dt_geracao, 
      	0            	nr_remessa, 
      	0            	cd_plano, 
      	' '            	cd_paciente,       
      	' '            	cd_autorizacao, 
      	'0'            	cd_acomodacao, 
      	LOCALTIMESTAMP         	dt_entrada, 
      	LOCALTIMESTAMP         	dt_saida, 
      	LOCALTIMESTAMP         	dt_inicio_cobranca, 
      	LOCALTIMESTAMP         	dt_fim_cobranca, 
      	0            	ie_tipo_atendimento, 
      	null           	cd_cid, 
      	' '            	cd_proc_principal, 
		' '				cd_medico_convenio, 
      	' '            	nr_crm, 
      	' '            	uf_crm, 
		' '				nr_crm_req, 
		' '				uf_crm_req, 
      	max(c.nr_seq_item)      	nr_seq_item, 
      	c.cd_item_convenio		cd_item, 
      	substr(elimina_acentuacao(upper(c.ds_item)),1,50) 
						nm_item, 
      	CASE WHEN w.ie_carater_inter='U' THEN 'S'  ELSE 'N' END  
						ie_emergencia, 
      	CASE WHEN c.pr_hora_extra=0 THEN 'N' WHEN c.pr_hora_extra=1 THEN 'N' WHEN c.pr_hora_extra IS NULL THEN 'N'  ELSE 'S' END  
            				ie_extra, 
      	trunc(w.dt_entrada,'dd') 		dt_item, 
      	c.cd_funcao_executor		ie_funcao_medico, 
      	sum(c.qt_item)        	qt_item, 
      	sum(coalesce(c.vl_honorario,0) + coalesce(c.vl_custo_oper,0) + coalesce(c.vl_filme,0)) 
							vl_item, 
      	0            	ie_cirurgia_multipla, 
      	0		   		vl_total_item, 
      	0	   			qt_item_conta, 
	   	' '				nm_paciente, 
      	' '	   			nr_fatura, 
      	0				qt_conta, 
     	0				vl_total_lote, 
	   	c.nr_seq_protocolo		nr_seq_protocolo, 
		' '				ds_espaco, 
      	1            	nr_registro, 
		CASE WHEN c.cd_item=10073 THEN  c.cd_cgc_hospital WHEN c.cd_item=40029 THEN  c.cd_cgc_hospital WHEN c.cd_item=40010 THEN  c.cd_cgc_hospital  ELSE CASE WHEN c.cd_grupo_proc=33010005 THEN c.cd_cgc_hospital  ELSE CASE WHEN obter_se_medico_conveniado(obter_estab_atend(c.nr_atendimento),c.cd_medico_executor,c.cd_convenio, 				null, null, null, null,null,null, null, null)='S' THEN  			c.cd_medico_exec_conv  ELSE c.cd_cgc_hospital END  END  END  cd_cgc_prestador, 
		0				cd_motivo_alta, 
		' '				ie_laudo_especial, 
		' '				ie_laudo_prorrogacao, 
		LOCALTIMESTAMP				dt_autorizacao, 
		LOCALTIMESTAMP				dt_validade_carteirinha, 
		0				nr_prontuario, 
		' '				nm_medico_resp, 
		' '				ie_tipo_doc_paciente, 
		' '				nr_doc_paciente, 
		' '				ie_matmed, 
		somente_numero(c.nr_crm_executor) 
						nr_crm_resp, 
		c.uf_crm_executor		uf_crm_resp, 
		substr(c.cd_senha_guia,1,10)	cd_senha, 
		c.cd_especialidade		cd_especialidade, 
		0				vl_proc_principal, 
		CASE WHEN c.pr_via_acesso=100 THEN 1 WHEN c.pr_via_acesso=70 THEN 2  ELSE 3 END  
						ie_tipo_cirurgia, 
		0				cd_unidade_atend, 
		0				qt_diaria_enfermaria, 
		0				qt_diaria_uti, 
		0				cd_leitora, 
		'F'				ie_fim_registro, 
		w.ie_tipo_atendimento		ie_tipo_atend_tasy, 
		substr(w.nr_doc_convenio,1,8)	nr_doc_convenio 
FROM w_interf_conta_header x, w_interf_conta_cab w, w_interf_conta_item c
LEFT OUTER JOIN regra_honorario z ON (c.ie_responsavel_credito = z.cd_regra)
WHERE c.nr_interno_conta = w.nr_interno_conta and w.nr_seq_protocolo = x.nr_seq_protocolo  and c.ie_tipo_item	= 1 --and		nvl(z.ie_entra_conta,'S') = 'S'	 
  and c.cd_item in (select x.cd_procedimento 
		from estrutura_procedimento_v x 
		where x.cd_area_procedimento in (1,3,4,11,13)) group by	somente_numero(coalesce(substr(x.cd_interno,1,5),0)), 
		c.nr_seq_protocolo, 
      		c.nr_interno_conta, 
      		c.cd_item_convenio, 
      		substr(elimina_acentuacao(upper(c.ds_item)),1,50), 
      		CASE WHEN w.ie_carater_inter='U' THEN 'S'  ELSE 'N' END , 
      		CASE WHEN c.pr_hora_extra=0 THEN 'N' WHEN c.pr_hora_extra=1 THEN 'N' WHEN c.pr_hora_extra IS NULL THEN 'N'  ELSE 'S' END , 
      		trunc(w.dt_entrada,'dd'), 
      		c.cd_funcao_executor, 
      		c.nr_seq_protocolo, 
		somente_numero(c.nr_crm_executor), 
		c.uf_crm_executor, 
		substr(c.cd_senha_guia,1,10), 
		c.cd_especialidade, 
		CASE WHEN c.pr_via_acesso=100 THEN 1 WHEN c.pr_via_acesso=70 THEN 2  ELSE 3 END , 
		w.ie_tipo_atendimento, 
		CASE WHEN c.cd_item=10073 THEN  c.cd_cgc_hospital WHEN c.cd_item=40029 THEN  c.cd_cgc_hospital WHEN c.cd_item=40010 THEN  c.cd_cgc_hospital  ELSE CASE WHEN c.cd_grupo_proc=33010005 THEN c.cd_cgc_hospital  ELSE CASE WHEN obter_se_medico_conveniado(obter_estab_atend(c.nr_atendimento),c.cd_medico_executor,c.cd_convenio,null, null, null, null,null,null, null, null)='S' THEN  			c.cd_medico_exec_conv  ELSE c.cd_cgc_hospital END  END  END , 
		substr(w.nr_doc_convenio,1,8) 
having sum(c.qt_item) > 0 

union all
 
select   	'ITEM DA CONTA     ' 	ds_registro, 
      	3            	tp_registro, 
      	'CSMH'         	ie_servico, 
      	2            	cd_registro, 
      	somente_numero(coalesce(substr(x.cd_interno,1,5),0))	cd_origem, 
      	c.nr_seq_protocolo   	nr_lote, 
      	c.nr_interno_conta   	nr_interno_conta, 
      	max(c.nr_seq_item)		nr_parcela, 
      	0            	cd_convenio, 
      	' '            	nm_convenio, 
      	' '            	tp_prestador, 
      	' '            	cd_prestador, 
      	' '            	nm_prestador, 
      	LOCALTIMESTAMP         	dt_geracao, 
      	0            	nr_remessa, 
      	0            	cd_plano, 
      	' '            	cd_paciente,       
      	' '            	cd_autorizacao, 
      	'0'            	cd_acomodacao, 
      	LOCALTIMESTAMP         	dt_entrada, 
      	LOCALTIMESTAMP         	dt_saida, 
      	LOCALTIMESTAMP         	dt_inicio_cobranca, 
      	LOCALTIMESTAMP         	dt_fim_cobranca, 
      	0            	ie_tipo_atendimento, 
      	null           	cd_cid, 
      	' '            	cd_proc_principal, 
		' '				cd_medico_convenio, 
      	' '            	nr_crm, 
      	' '            	uf_crm, 
		' '				nr_crm_req, 
		' '				uf_crm_req, 
      	max(c.nr_seq_item)      	nr_seq_item, 
      	c.cd_item_convenio		cd_item, 
      	substr(elimina_acentuacao(upper(c.ds_item)),1,50) 
						nm_item, 
      	CASE WHEN w.ie_carater_inter='U' THEN 'S'  ELSE 'N' END  
						ie_emergencia, 
      	CASE WHEN c.pr_hora_extra=0 THEN 'N' WHEN c.pr_hora_extra=1 THEN 'N' WHEN c.pr_hora_extra IS NULL THEN 'N'  ELSE 'S' END  
            				ie_extra, 
      	trunc(w.dt_entrada,'dd') 		dt_item, 
      	c.cd_funcao_executor     	ie_funcao_medico, 
      	sum(c.qt_item)        	qt_item, 
      	sum(c.vl_total_item)     	vl_item, 
      	0            	ie_cirurgia_multipla, 
      	0		   		vl_total_item, 
      	0	   			qt_item_conta, 
	   	' '				nm_paciente, 
      	' '	   			nr_fatura, 
      	0				qt_conta, 
     	0				vl_total_lote, 
	   	c.nr_seq_protocolo		nr_seq_protocolo, 
		' '				ds_espaco, 
      	1            	nr_registro, 
		CASE WHEN c.cd_item=10073 THEN  c.cd_cgc_hospital WHEN c.cd_item=40029 THEN  c.cd_cgc_hospital WHEN c.cd_item=40010 THEN  c.cd_cgc_hospital  ELSE CASE WHEN c.cd_grupo_proc=33010005 THEN c.cd_cgc_hospital  ELSE CASE WHEN obter_se_medico_conveniado(obter_estab_atend(c.nr_atendimento),c.cd_medico_executor,c.cd_convenio, null,null, null, null,null,null, null, null)='S' THEN  			c.cd_medico_exec_conv  ELSE c.cd_cgc_hospital END  END  END  cd_cgc_prestador, 
		0				cd_motivo_alta, 
		' '				ie_laudo_especial, 
		' '				ie_laudo_prorrogacao, 
		LOCALTIMESTAMP				dt_autorizacao, 
		LOCALTIMESTAMP				dt_validade_carteirinha, 
		0				nr_prontuario, 
		' '				nm_medico_resp, 
		' '				ie_tipo_doc_paciente, 
		' '				nr_doc_paciente, 
		CASE WHEN c.ie_total_interf=2 THEN '1' WHEN c.ie_total_interf=3 THEN '2'  ELSE ' ' END  
						ie_matmed, 
		0				nr_crm_resp, 
		' '				uf_crm_resp, 
		substr(c.cd_senha_guia,1,10)	cd_senha, 
		c.cd_especialidade		cd_especialidade, 
		0				vl_proc_principal, 
		0				ie_tipo_cirurgia, 
		0				cd_unidade_atend, 
		0				qt_diaria_enfermaria, 
		0				qt_diaria_uti, 
		0				cd_leitora, 
		'F'				ie_fim_registro, 
		w.ie_tipo_atendimento		ie_tipo_atend_tasy, 
		substr(w.nr_doc_convenio,1,8)	nr_doc_convenio 
from		w_interf_conta_header x, 
		w_interf_conta_item c, 
		w_interf_conta_cab w 
where    	c.nr_interno_conta = w.nr_interno_conta 
and		w.nr_seq_protocolo = x.nr_seq_protocolo	 
and (c.ie_tipo_item	= 2 or (c.ie_tipo_item	= 1 			and 
		c.cd_item not in (select x.cd_procedimento 
		from estrutura_procedimento_v x 
		where x.cd_area_procedimento in (1,3,4,11,13)))) 
and		c.vl_total_item	<> 0 
group by	somente_numero(coalesce(substr(x.cd_interno,1,5),0)), 
		c.nr_seq_protocolo, 
      	c.nr_interno_conta, 
      	c.cd_item_convenio, 
      	substr(elimina_acentuacao(upper(c.ds_item)),1,50), 
      	CASE WHEN w.ie_carater_inter='U' THEN 'S'  ELSE 'N' END , 
      	CASE WHEN c.pr_hora_extra=0 THEN 'N' WHEN c.pr_hora_extra=1 THEN 'N' WHEN c.pr_hora_extra IS NULL THEN 'N'  ELSE 'S' END , 
      	trunc(w.dt_entrada,'dd'), 
      	c.cd_funcao_executor, 
      	c.nr_seq_protocolo, 
		CASE WHEN c.ie_total_interf=2 THEN '1' WHEN c.ie_total_interf=3 THEN '2'  ELSE ' ' END , 
		substr(c.cd_senha_guia,1,10), 
		c.cd_especialidade, 
		CASE WHEN c.cd_item=10073 THEN  c.cd_cgc_hospital WHEN c.cd_item=40029 THEN  c.cd_cgc_hospital WHEN c.cd_item=40010 THEN  c.cd_cgc_hospital  ELSE CASE WHEN c.cd_grupo_proc=33010005 THEN c.cd_cgc_hospital  ELSE CASE WHEN obter_se_medico_conveniado(obter_estab_atend(c.nr_atendimento),c.cd_medico_executor,c.cd_convenio,null, null, null, null,null,null, null, null)='S' THEN  			c.cd_medico_exec_conv  ELSE c.cd_cgc_hospital END  END  END , 
		w.ie_tipo_atendimento, 
		substr(w.nr_doc_convenio,1,8) 
having sum(c.qt_item) > 0 

union all
 
select   	'TOTAL DA CONTA    ' 	ds_registro, 
      	4            	tp_registro, 
      	'CSMH'         	ie_servico, 
      	3            	cd_registro, 
      	somente_numero(coalesce(substr(y.cd_interno,1,5),0))	cd_origem, 
      	b.nr_seq_protocolo   	nr_lote, 
      	b.nr_interno_conta   	nr_interno_conta, 
      	1            	nr_parcela, 
      	0            	cd_convenio, 
      	' '            	nm_convenio, 
      	' '            	tp_prestador, 
      	' '            	cd_prestador, 
      	' '            	nm_prestador, 
      	LOCALTIMESTAMP         	dt_geracao, 
      	0            	nr_remessa, 
      	0            	cd_plano, 
      	' '            	cd_paciente,       
      	' '            	cd_autorizacao, 
      	'0'            	cd_acomodacao, 
      	LOCALTIMESTAMP         	dt_entrada, 
      	LOCALTIMESTAMP         	dt_saida, 
      	LOCALTIMESTAMP         	dt_inicio_cobranca, 
      	LOCALTIMESTAMP         	dt_fim_cobranca, 
      	0            	ie_tipo_atendimento, 
      	null           	cd_cid, 
      	' '            	cd_proc_principal, 
		' '					cd_medico_convenio, 
      	' '            	nr_crm, 
      	' '            	uf_crm, 
		b.nr_crm_medico_resp		nr_crm_req, 
		b.uf_crm_medico_resp		uf_crm_req, 
      	1            	nr_seq_item, 
      	' '				cd_item, 
      	' '            	nm_item, 
      	' '   			ie_emergencia, 
      	' '            	ie_extra, 
      	LOCALTIMESTAMP				dt_item, 
      	0            	ie_funcao_medico, 
      	0				qt_item, 
      	0				vl_item, 
      	0				ie_cirurgia_multipla, 
      	sum(CASE WHEN x.cd_area_procedimento=1 THEN (coalesce(e.vl_honorario,0) + coalesce(e.vl_custo_oper,0)) WHEN x.cd_area_procedimento=4 THEN (coalesce(e.vl_honorario,0) + coalesce(e.vl_custo_oper,0)) WHEN x.cd_area_procedimento=11 THEN (coalesce(e.vl_honorario,0) + coalesce(e.vl_custo_oper,0)) WHEN x.cd_area_procedimento=13 THEN (coalesce(e.vl_honorario,0) + coalesce(e.vl_custo_oper,0))  ELSE e.vl_total_item END ) vl_total_item, 
      	0			qt_item_conta, 
	   	substr(elimina_acentuacao(upper(b.nm_paciente)),1,40) 
						nm_paciente, 
      	' '	   			nr_fatura, 
      	0				qt_conta, 
      	0				vl_total_lote, 
	   	b.nr_seq_protocolo		nr_seq_protocolo, 
		' '				ds_espaco, 
      	1            	nr_registro, 
		' '				cd_cgc_prestador, 
		0				cd_motivo_alta, 
		' '				ie_laudo_especial, 
		' '				ie_laudo_prorrogacao, 
		LOCALTIMESTAMP				dt_autorizacao, 
		LOCALTIMESTAMP				dt_validade_carteirinha, 
		0				nr_prontuario, 
		' '				nm_medico_resp, 
		' '				ie_tipo_doc_paciente, 
		' '				nr_doc_paciente, 
		' '				ie_matmed, 
		0				nr_crm_resp, 
		' '				uf_crm_resp, 
		' '				cd_senha, 
		0				cd_especialidade, 
		0				vl_proc_principal, 
		0				ie_tipo_cirurgia, 
		0				cd_unidade_atend, 
		0				qt_diaria_enfermaria, 
		0				qt_diaria_uti, 
		0				cd_leitora, 
		'F'				ie_fim_registro, 
		b.ie_tipo_atendimento		ie_tipo_atend_tasy, 
		substr(b.nr_doc_convenio,1,8)	nr_doc_convenio 
FROM w_interf_conta_header y, w_interf_conta_cab b, w_interf_conta_item e
LEFT OUTER JOIN estrutura_procedimento_v x ON (e.cd_item = x.cd_procedimento AND e.ie_origem_proced = x.ie_origem_proced)
LEFT OUTER JOIN regra_honorario z ON (e.ie_responsavel_credito = z.cd_regra)
WHERE b.nr_interno_conta 	= e.nr_interno_conta and b.nr_seq_protocolo	= y.nr_seq_protocolo    --and		nvl(z.ie_entra_conta,'S') = 'S' 
 group by	somente_numero(coalesce(substr(y.cd_interno,1,5),0)), 
		b.nr_seq_protocolo, 
      	b.nr_interno_conta, 
		substr(elimina_acentuacao(upper(b.nm_paciente)),1,40), 
		b.nr_crm_medico_resp, 
		b.uf_crm_medico_resp, 
		b.ie_tipo_atendimento, 
		substr(b.nr_doc_convenio,1,8) 

union all
 
select   	'FIM DE LOTE      ' 	ds_registro, 
      	5            	tp_registro, 
      	'CSMH'         	ie_servico, 
      	4            	cd_registro, 
      	somente_numero(coalesce(substr(y.cd_interno,1,5),0))	cd_origem, 
      	b.nr_seq_protocolo   	nr_lote, 
      	99999999	   		nr_interno_conta, 
      	99            	nr_parcela, 
      	0            	cd_convenio, 
      	' '            	nm_convenio, 
      	' '            	tp_prestador, 
      	' '            	cd_prestador, 
      	' '            	nm_prestador, 
      	LOCALTIMESTAMP         	dt_geracao, 
      	0            	nr_remessa, 
      	0            	cd_plano, 
      	' '            	cd_paciente,       
      	' '            	cd_autorizacao, 
      	'0'            	cd_acomodacao, 
      	LOCALTIMESTAMP         	dt_entrada, 
      	LOCALTIMESTAMP         	dt_saida, 
      	LOCALTIMESTAMP         	dt_inicio_cobranca, 
      	LOCALTIMESTAMP         	dt_fim_cobranca, 
      	0            	ie_tipo_atendimento, 
      	null           	cd_cid, 
      	' '            	cd_proc_principal, 
		' '					cd_medico_convenio, 
      	' '            	nr_crm, 
      	' '            	uf_crm, 
		' '				nr_crm_req, 
		' '				uf_crm_req, 
      	1            	nr_seq_item, 
      	' '				cd_item, 
      	' '            	nm_item, 
      	' '   			ie_emergencia, 
      	' '            	ie_extra, 
      	LOCALTIMESTAMP				dt_item, 
      	0            	ie_funcao_medico, 
      	0				qt_item, 
      	0				vl_item, 
      	0				ie_cirurgia_multipla, 
      	0		   		vl_total_item, 
      	0	   			qt_item_conta, 
	   	' '				nm_paciente, 
      	' '	   			nr_fatura, 
      	count(distinct e.nr_interno_conta) qt_conta, 
      	sum(CASE WHEN x.cd_area_procedimento=1 THEN (coalesce(e.vl_honorario,0) + coalesce(e.vl_custo_oper,0)) WHEN x.cd_area_procedimento=4 THEN (coalesce(e.vl_honorario,0) + coalesce(e.vl_custo_oper,0)) WHEN x.cd_area_procedimento=11 THEN (coalesce(e.vl_honorario,0) + coalesce(e.vl_custo_oper,0)) WHEN x.cd_area_procedimento=13 THEN (coalesce(e.vl_honorario,0) + coalesce(e.vl_custo_oper,0))  ELSE e.vl_total_item END ) vl_total_item, 
	   	b.nr_seq_protocolo		nr_seq_protocolo, 
		' '				ds_espaco, 
      	1            	nr_registro, 
		' '				cd_cgc_prestador, 
		0				cd_motivo_alta, 
		' '				ie_laudo_especial, 
		' '				ie_laudo_prorrogacao, 
		LOCALTIMESTAMP				dt_autorizacao, 
		LOCALTIMESTAMP				dt_validade_carteirinha, 
		0				nr_prontuario, 
		' '				nm_medico_resp, 
		' '				ie_tipo_doc_paciente, 
		' '				nr_doc_paciente, 
		' '				ie_matmed, 
		0				nr_crm_resp, 
		' '				uf_crm_resp, 
		' '				cd_senha, 
		0				cd_especialidade, 
		0				vl_proc_principal, 
		0				ie_tipo_cirurgia, 
		0				cd_unidade_atend, 
		0				qt_diaria_enfermaria, 
		0				qt_diaria_uti, 
		0				cd_leitora, 
		'F'				ie_fim_registro, 
		0				ie_tipo_atend_tasy, 
		' '				nr_doc_convenio 
FROM w_interf_conta_header y, w_interf_conta_cab b, w_interf_conta_item e
LEFT OUTER JOIN estrutura_procedimento_v x ON (e.cd_item = x.cd_procedimento AND e.ie_origem_proced = x.ie_origem_proced)
LEFT OUTER JOIN regra_honorario z ON (e.ie_responsavel_credito = z.cd_regra)
WHERE b.nr_interno_conta 	= e.nr_interno_conta and b.nr_seq_protocolo	= y.nr_seq_protocolo    --and		nvl(z.ie_entra_conta,'S') = 'S' 
 group by	somente_numero(coalesce(substr(y.cd_interno,1,5),0)), 
		b.nr_seq_protocolo 

union all
 
select   	'TRAILLER       ' 	ds_registro, 
      	6            	tp_registro, 
      	'CSMH'         	ie_servico, 
      	9            	cd_registro, 
      	somente_numero(coalesce(substr(y.cd_interno,1,5),0))	cd_origem, 
      	99999999	   		nr_lote, 
      	99999999	   		nr_interno_conta, 
      	99            	nr_parcela, 
      	0            	cd_convenio, 
      	' '            	nm_convenio, 
      	' '            	tp_prestador, 
      	' '            	cd_prestador, 
      	' '            	nm_prestador, 
      	LOCALTIMESTAMP         	dt_geracao, 
      	0            	nr_remessa, 
      	0            	cd_plano, 
      	' '            	cd_paciente,       
      	' '            	cd_autorizacao, 
      	'0'            	cd_acomodacao, 
      	LOCALTIMESTAMP         	dt_entrada, 
      	LOCALTIMESTAMP         	dt_saida, 
      	LOCALTIMESTAMP         	dt_inicio_cobranca, 
      	LOCALTIMESTAMP         	dt_fim_cobranca, 
      	0            	ie_tipo_atendimento, 
      	null           	cd_cid, 
      	' '            	cd_proc_principal, 
		' '					cd_medico_convenio, 
      	' '            	nr_crm, 
      	' '            	uf_crm, 
	   	' '				nr_crm_req, 
		' '				uf_crm_req, 
      	1            	nr_seq_item, 
      	' '				cd_item, 
      	' '            	nm_item, 
      	' '   			ie_emergencia, 
      	' '            	ie_extra, 
      	LOCALTIMESTAMP				dt_item, 
      	0            	ie_funcao_medico, 
      	0				qt_item, 
      	0				vl_item, 
      	0				ie_cirurgia_multipla, 
      	0		   		vl_total_item, 
      	0	   			qt_item_conta, 
	   	' '				nm_paciente, 
      	' '	   			nr_fatura, 
      	count(distinct e.nr_interno_conta) qt_conta, 
      	sum(CASE WHEN x.cd_area_procedimento=1 THEN (coalesce(e.vl_honorario,0) + coalesce(e.vl_custo_oper,0)) WHEN x.cd_area_procedimento=4 THEN (coalesce(e.vl_honorario,0) + coalesce(e.vl_custo_oper,0)) WHEN x.cd_area_procedimento=11 THEN (coalesce(e.vl_honorario,0) + coalesce(e.vl_custo_oper,0)) WHEN x.cd_area_procedimento=13 THEN (coalesce(e.vl_honorario,0) + coalesce(e.vl_custo_oper,0))  ELSE e.vl_total_item END ) vl_total_item, 
	   	b.nr_seq_protocolo		nr_seq_protocolo, 
		' '				ds_espaco, 
      	1            	nr_registro, 
		' '				cd_cgc_prestador, 
		0				cd_motivo_alta, 
		' '				ie_laudo_especial, 
		' '				ie_laudo_prorrogacao, 
		LOCALTIMESTAMP				dt_autorizacao, 
		LOCALTIMESTAMP				dt_validade_carteirinha, 
		0				nr_prontuario, 
		' '				nm_medico_resp, 
		' '				ie_tipo_doc_paciente, 
		' '				nr_doc_paciente, 
		' '				ie_matmed, 
		0				nr_crm_resp, 
		' '				uf_crm_resp, 
		' '				cd_senha, 
		0				cd_especialidade, 
		0				vl_proc_principal, 
		0				ie_tipo_cirurgia, 
		0				cd_unidade_atend, 
		0				qt_diaria_enfermaria, 
		0				qt_diaria_uti, 
		0				cd_leitora, 
		'F'				ie_fim_registro, 
		9				ie_tipo_atend_tasy, 
		' '				nr_doc_convenio 
FROM w_interf_conta_header y, w_interf_conta_cab b, w_interf_conta_item e
LEFT OUTER JOIN estrutura_procedimento_v x ON (e.cd_item = x.cd_procedimento AND e.ie_origem_proced = x.ie_origem_proced)
LEFT OUTER JOIN regra_honorario z ON (e.ie_responsavel_credito = z.cd_regra)
WHERE b.nr_interno_conta 	= e.nr_interno_conta and b.nr_seq_protocolo	= y.nr_seq_protocolo    --and		nvl(z.ie_entra_conta,'S') = 'S' 
 group by	somente_numero(coalesce(substr(y.cd_interno,1,5),0)), 
		b.nr_seq_protocolo;
