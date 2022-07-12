-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';

CREATE OR REPLACE VIEW unimed_curitiba_v (tp_registro, ie_tipo_protocolo, ie_tipo_prestador, cd_prestador, nr_especialidade, nm_prestador, cd_interno, nr_lote, dt_geracao, ie_tipo_atendimento, ie_clinica, nr_documento, cd_item, cd_serv_mat_med, ie_tipo_item, ds_item, qt_item, vl_item, vl_total_item, cd_unidade_medida, nr_cep, cd_tipo_prestador, nr_crm, dt_inicio_internacao, dt_periodo_inicial, dt_periodo_final, dt_alta, ie_padrao_internacao, cd_unimed_usuario, cd_contrato_usuario, cd_familia_usuario, ie_dependencia_usuario, ie_digito_ver_usuario, dt_exec_servico, hr_exec_servico, cd_cid, ie_detalhe_cid, cd_dig_verif_cid, cd_seq_doc_servico, cd_amb_lpm, cd_dig_verif_servico, qt_servico_executado, ie_porte_cirurgico, ie_partic_executante, cd_local_atendimento, vl_servico, cd_moeda_servico, vl_filme, cd_moeda_filme, nr_autorizacao, cd_fator_plano, ie_tipo_prest_executante, cd_prest_executante, ie_situacao_guia, nm_paciente, hr_saida_paciente, nr_seq_protocolo, nr_atendimento, nr_interno_conta, qt_doc_enviados, qt_serv_relacionados, qt_total_servicos_real, qt_total_cobrado_ch, qt_total_filme, cd_campo_quebra, pr_faturado, ie_utilizado, nr_guia, dt_atendimento, hr_atendimento, cd_cid_principal, cd_medico_solic, nm_medico_resp, qt_dias_internacao, ie_atend_emergencia, cd_tipo_acomodacao, cd_usuario_convenio, nm_empresa, dt_nascimento, ie_sexo, ie_tipo_nascimento, ie_status_nota, ie_tipo_registro, nr_identidade, ie_tipo_alta, ie_tipo_internamento, nr_guia_origem, nr_doc_convenio, cd_proc_principal, cd_conv_medico_resp, vl_unitario, nr_guia_liberacao, qt_contas, qt_total_itens, nr_protocolo_hosp) AS select		0					tp_registro,
		CASE WHEN a.ie_tipo_protocolo=1 THEN  81  ELSE 82 END  	ie_tipo_protocolo, 
		4					ie_tipo_prestador, 
		'127'					cd_prestador, 
		CASE WHEN a.ie_tipo_protocolo=1 THEN  to_char(b.CD_ESPECIALIDADE)  ELSE '00' END  NR_ESPECIALIDADE, 
		substr(a.nm_hospital,1,40)			nm_prestador, 
		'0' CD_INTERNO, 
		a.nr_seq_protocolo				nr_lote, 
		a.dt_remessa				dt_geracao, 
		0					IE_TIPO_ATENDIMENTO, 
		0					ie_clinica, 
		''					nr_documento, 
		''					cd_item, 
		''					CD_SERV_MAT_MED, 
		''					ie_tipo_item, 
		''					ds_item, 
		0					qt_item, 
		0					vl_item, 
		0					vl_total_item, 
		''					CD_UNIDADE_MEDIDA, 
		''					nr_cep, 
		1					cd_tipo_prestador, 
		''					nr_crm, 
		LOCALTIMESTAMP					dt_inicio_internacao, 
		LOCALTIMESTAMP DT_PERIODO_INICIAL, 
		LOCALTIMESTAMP DT_PERIODO_FINAL  ,   
		LOCALTIMESTAMP					dt_alta, 
		0					ie_padrao_internacao, 
		''					cd_unimed_usuario, 
		''					cd_contrato_usuario, 
		''					cd_familia_usuario, 
		''					ie_dependencia_usuario, 
		''					ie_digito_ver_usuario, 
		''					dt_exec_servico, 
		''					hr_exec_servico, 
		''					cd_cid, 
		''					ie_detalhe_cid, 
		''					cd_dig_verif_cid, 
		0					cd_seq_doc_servico, 
		''					cd_amb_lpm, 
		''					cd_dig_verif_servico, 
		0					qt_servico_executado, 
		''					ie_porte_cirurgico, 
		''					ie_partic_executante, 
		0					cd_local_atendimento, 
		0					vl_servico, 
		6					cd_moeda_servico, 
		0					vl_filme, 
		6					cd_moeda_filme, 
		''					nr_autorizacao, 
		0					cd_fator_plano, 
		0					ie_tipo_prest_executante, 
		0					cd_prest_executante, 
		''					ie_situacao_guia, 
		''					nm_PACIENTE, 
		''					hr_saida_paciente, 
		a.nr_seq_protocolo				nr_seq_protocolo, 
		0					nr_atendimento, 
		0					nr_interno_conta, 
		0					qt_doc_enviados, 
		0					qt_serv_relacionados, 
		0					qt_total_servicos_real, 
		0					qt_total_cobrado_ch, 
		0					qt_total_filme, 
		0					cd_campo_quebra, 
		0					pr_faturado, 
		''					ie_utilizado, 
		''					nr_guia, 
		LOCALTIMESTAMP					dt_atendimento, 
		''					hr_atendimento, 
		''					cd_cid_principal, 
		''					cd_medico_solic, 
		''					NM_MEDICO_RESP, 
		0					qt_dias_internacao, 
		'N'					ie_atend_emergencia, 
		0					cd_tipo_acomodacao, 
		''			 		cd_usuario_convenio, 
		''					nm_empresa, 
		LOCALTIMESTAMP					dt_nascimento, 
		'' 					ie_sexo, 
		''					ie_tipo_nascimento, 
		'NIP'					ie_status_nota, 
		'I'					ie_tipo_registro, 
		'' 					nr_identidade, 
		0					ie_tipo_alta, 
		1					ie_tipo_internamento, 
		null					nr_guia_origem, 
		' ' 					NR_DOC_CONVENIO, 
		''					CD_PROC_PRINCIPAL, 
		''					CD_CONV_MEDICO_RESP, 
		0					vl_unitario, 
		'' NR_GUIA_LIBERACAO, 
		0 qt_contas, 
		0 qt_total_itens, 
		'0' NR_PROTOCOLO_HOSP 
FROM		protocolo_convenio b, 
		w_interf_conta_header a 
where		a.nr_seq_protocolo	= b.nr_seq_protocolo 

union all
 
select		1					tp_registro, 
		CASE WHEN ie_tipo_protocolo=1 THEN  81  ELSE 82 END  	ie_tipo_protocolo, 
		4					ie_tipo_prestador, 
		'127'					cd_prestador, 
		'00' NR_ESPECIALIDADE, 
		substr(a.nm_hospital,1,40)			nm_prestador, 
		'0' CD_INTERNO, 
		a.nr_seq_protocolo				nr_lote, 
		a.dt_remessa				dt_geracao, 
		0					IE_TIPO_ATENDIMENTO, 
		0					ie_clinica, 
		''					nr_documento, 
		''					cd_item, 
		'' CD_SERV_MAT_MED, 
		''					ie_tipo_item, 
		''					ds_item, 
		0					qt_item, 
		0					vl_item, 
		0					vl_total_item, 
		''					CD_UNIDADE_MEDIDA, 
		''					nr_cep, 
		1					cd_tipo_prestador, 
		''					nr_crm, 
		LOCALTIMESTAMP					dt_inicio_internacao, 
		LOCALTIMESTAMP DT_PERIODO_INICIAL, 
		LOCALTIMESTAMP DT_PERIODO_FINAL  ,   
		LOCALTIMESTAMP					dt_alta, 
		0					ie_padrao_internacao, 
		''					cd_unimed_usuario, 
		''					cd_contrato_usuario, 
		''					cd_familia_usuario, 
		''					ie_dependencia_usuario, 
		''					ie_digito_ver_usuario, 
		''					dt_exec_servico, 
		''					hr_exec_servico, 
		''					cd_cid, 
		''					ie_detalhe_cid, 
		''					cd_dig_verif_cid, 
		0					cd_seq_doc_servico, 
		''					cd_amb_lpm, 
		''					cd_dig_verif_servico, 
		0					qt_servico_executado, 
		''					ie_porte_cirurgico, 
		''					ie_partic_executante, 
		0					cd_local_atendimento, 
		0					vl_servico, 
		6					cd_moeda_servico, 
		0					vl_filme, 
		6					cd_moeda_filme, 
		''					nr_autorizacao, 
		0					cd_fator_plano, 
		0					ie_tipo_prest_executante, 
		0					cd_prest_executante, 
		''					ie_situacao_guia, 
		''					nm_PACIENTE, 
		''					hr_saida_paciente, 
		a.nr_seq_protocolo				nr_seq_protocolo, 
		0					nr_atendimento, 
		0					nr_interno_conta, 
		0					qt_doc_enviados, 
		0					qt_serv_relacionados, 
		0					qt_total_servicos_real, 
		0					qt_total_cobrado_ch, 
		0					qt_total_filme, 
		0					cd_campo_quebra, 
		0					pr_faturado, 
		''					ie_utilizado, 
		''					nr_guia, 
		LOCALTIMESTAMP					dt_atendimento, 
		''					hr_atendimento, 
		''					cd_cid_principal, 
		''					cd_medico_solic, 
		''					NM_MEDICO_RESP, 
		0					qt_dias_internacao, 
		'N'					ie_atend_emergencia, 
		0					cd_tipo_acomodacao, 
		''			 		cd_usuario_convenio, 
		''					nm_empresa, 
		LOCALTIMESTAMP					dt_nascimento, 
		'' 					ie_sexo, 
		''					ie_tipo_nascimento, 
		'NIP'					ie_status_nota, 
		'I'					ie_tipo_registro, 
		'' 					nr_identidade, 
		0					ie_tipo_alta, 
		1					ie_tipo_internamento, 
		null					nr_guia_origem, 
		' ' 					NR_DOC_CONVENIO, 
		''					CD_PROC_PRINCIPAL, 
		''					CD_CONV_MEDICO_RESP, 
		0					vl_unitario, 
		'' NR_GUIA_LIBERACAO, 
		0 qt_contas, 
		0 qt_total_itens, 
		'0' NR_PROTOCOLO_HOSP 
from		w_interf_conta_header a 

union all
 
select		2					tp_registro, 
		0					ie_tipo_protocolo, 
		4					ie_tipo_prestador, 
		CD_CONV_MEDICO_RESP			cd_prestador, 
		'00' NR_ESPECIALIDADE, 
		NM_MEDICO_RESP				nm_prestador, 
		SUBSTR(a.CD_USUARIO_CONVENIO, 1, 4) 	CD_INTERNO, 
		0					nr_lote, 
		LOCALTIMESTAMP					dt_geracao, 
		a.IE_TIPO_ATENDIMENTO, 
		a.ie_clinica, 
		''					nr_documento, 
		''					cd_item, 
		'' CD_SERV_MAT_MED, 
		''					ie_tipo_item, 
		''					ds_item, 
		0					qt_item, 
		0					vl_item, 
		0					vl_total_item, 
		''					CD_UNIDADE_MEDIDA, 
		''					nr_cep, 
		1					cd_tipo_prestador, 
		nr_crm_medico_resp			nr_crm, 
		trunc(a.dt_entrada, 'dd')		dt_inicio_internacao, 
		a.DT_PERIODO_INICIAL, 
		b.dt_remessa  ,   
		LOCALTIMESTAMP, 
		CASE WHEN obter_atepacu_paciente(a.nr_atendimento,'PI')=0 THEN 0  ELSE a.cd_tipo_acomodacao END 															ie_padrao_internacao, 
		''					cd_unimed_usuario, 
		CASE WHEN a.cd_convenio=10 THEN  '9999'  ELSE substr(a.cd_usuario_convenio,4,4) END 		cd_contrato_usuario, 
		CASE WHEN a.cd_convenio=10 THEN  '000000'  ELSE substr(a.cd_usuario_convenio,8,6) END 	cd_familia_usuario, 
		CASE WHEN a.cd_convenio=10 THEN  '00'  ELSE substr(a.cd_usuario_convenio,14,2) END 		ie_dependencia_usuario, 
		CASE WHEN a.cd_convenio=10 THEN  '0'  ELSE substr(a.cd_usuario_convenio,16,1) END 		ie_digito_ver_usuario, 
		to_char(a.dt_entrada,'ddmmyyyy')		dt_exec_servico, 
		to_char(a.dt_entrada,'hh24mi')			hr_exec_servico, 
		a.cd_cid_principal				cd_cid, 
		''					ie_detalhe_cid, 
		''					cd_dig_verif_cid, 
		0					cd_seq_doc_servico, 
		''					cd_amb_lpm, 
		''					cd_dig_verif_servico, 
		0					qt_servico_executado, 
		''					ie_porte_cirurgico, 
		''					ie_partic_executante, 
		0					cd_local_atendimento, 
		0					vl_servico, 
		6					cd_moeda_servico, 
		0					vl_filme, 
		6					cd_moeda_filme, 
		''					nr_autorizacao, 
		0					cd_fator_plano, 
		0					ie_tipo_prest_executante, 
		26840					cd_prest_executante, 
		''					ie_situacao_guia, 
		substr(a.nm_paciente,1,50)			nm_PACIENTE, 
		to_char(a.dt_alta,'hh24mi')			hr_saida_paciente, 
		a.nr_seq_protocolo				nr_seq_protocolo, 
		a.nr_atendimento				nr_atendimento, 
		a.nr_interno_conta				nr_interno_conta, 
		0					qt_doc_enviados, 
		0					qt_serv_relacionados, 
		0					qt_total_servicos_real, 
		0					qt_total_cobrado_ch, 
		0					qt_total_filme, 
		a.nr_interno_conta 				cd_campo_quebra, 
		0					pr_faturado, 
		''					ie_utilizado, 
		''					nr_guia, 
		trunc(a.dt_entrada,'dd')		dt_atendimento, 
		to_char(a.dt_entrada,'hh24mi')		hr_atendimento, 
		a.cd_cid_principal, 
		a.cd_medico_resp				cd_medico_solic, 
		a.nm_medico_resp				NM_MEDICO_RESP, 
		trunc(coalesce(a.dt_alta, LOCALTIMESTAMP), 'dd') - trunc(a.dt_entrada, 'dd') qt_dias_internacao, 
		'N'					ie_atend_emergencia, 
		a.cd_tipo_acomodacao, 
		a.cd_usuario_convenio			cd_usuario_convenio, 
		a.nm_empresa_referencia			nm_empresa, 
		a.dt_nascimento, 
		a.ie_sexo	, 
		a.ie_tipo_nascimento, 
		'NIP'					ie_status_nota, 
		'I'					ie_tipo_registro, 
		a.nr_identidade, 
		a.cd_motivo_alta			ie_tipo_alta, 
		1					ie_tipo_internamento, 
		null					nr_guia_origem, 
		a.NR_DOC_CONVENIO, 
		a.CD_PROC_PRINCIPAL, 
		a.CD_CONV_MEDICO_RESP, 
		0					vl_unitario, 
		a.nr_doc_convenio NR_GUIA_LIBERACAO, 
		0 qt_contas, 
		0 qt_total_itens, 
		'0' NR_PROTOCOLO_HOSP 
from		w_interf_conta_cab a, 
		w_interf_conta_header b 
where		a.nr_seq_protocolo	= b.nr_seq_protocolo 

union all
 
select		3					tp_registro, 
		0					ie_tipo_protocolo, 
		4					ie_tipo_prestador, 
		'127'					cd_prestador, 
		'00' NR_ESPECIALIDADE, 
		''					nm_prestador, 
		'0' CD_INTERNO, 
		0					nr_lote, 
		LOCALTIMESTAMP					dt_geracao, 
		a.ie_tipo_atendimento, 
		a.ie_clinica, 
		b.nr_doc_convenio				nr_documento, 
		b.cd_item_convenio, 
		'', 
		'HOS'					ie_tipo_item, 
		b.ds_item, 
		sum(b.qt_item)				qt_item, 
		sum(b.vl_unitario_item), 
		sum(b.vl_total_item), 
		b.CD_UNIDADE_MEDIDA, 
		''					nr_cep, 
		1					cd_tipo_prestador, 
		CASE WHEN b.nr_crm_executor IS NULL THEN a.nr_crm_medico_resp  ELSE b.nr_crm_executor END 	nr_crm, 
		trunc(a.dt_entrada,'dd')		dt_inicio_internacao, 
		LOCALTIMESTAMP DT_PERIODO_INICIAL, 
		LOCALTIMESTAMP DT_PERIODO_FINAL  ,   
		LOCALTIMESTAMP, 
		CASE WHEN obter_atepacu_paciente(b.nr_atendimento,'PI')=0 THEN 0  ELSE a.cd_tipo_acomodacao END  
										ie_padrao_internacao, 
		CASE WHEN b.cd_convenio=10 THEN  '027'  ELSE substr(a.cd_usuario_convenio,1,3) END 		cd_unimed_usuario, 
		CASE WHEN b.cd_convenio=10 THEN  '9999'  ELSE substr(a.cd_usuario_convenio,4,4) END 		cd_contrato_usuario, 
		CASE WHEN b.cd_convenio=10 THEN  '000000'  ELSE substr(a.cd_usuario_convenio,8,6) END 	cd_familia_usuario, 
		CASE WHEN b.cd_convenio=10 THEN  '00'  ELSE substr(a.cd_usuario_convenio,14,2) END 		ie_dependencia_usuario, 
		CASE WHEN b.cd_convenio=10 THEN  '0'  ELSE substr(a.cd_usuario_convenio,16,1) END 		ie_digito_ver_usuario, 
		to_char(a.dt_entrada,'ddmmyyyy')		dt_exec_servico, 
		to_char(a.dt_entrada,'hh24mi')			hr_exec_servico, 
		a.cd_cid_principal				cd_cid, 
		''					ie_detalhe_cid, 
		''					cd_dig_verif_cid, 
		0					cd_seq_doc_servico, 
		CASE WHEN coalesce(b.cd_item_convenio,b.cd_item)='10014' THEN '1001' WHEN coalesce(b.cd_item_convenio,b.cd_item)='10022' THEN '1002' WHEN coalesce(b.cd_item_convenio,b.cd_item)='1007' THEN '1007'  ELSE substr(coalesce(b.cd_item_convenio,b.cd_item),1,7) END 	cd_amb_lpm, 
		'0' 					cd_dig_verif_servico, 
		sum(b.qt_item)				qt_servico_executado, 
		to_char(b.nr_porte_anestesico)		ie_porte_cirurgico, 
		to_char(b.cd_funcao_executor)		ie_partic_executante, 
		CASE WHEN b.cd_cgc_prestador='86897113000157' THEN 9 WHEN b.cd_cgc_prestador='82606450000197' THEN 9 WHEN b.cd_cgc_prestador='03049264000128' THEN 9 WHEN b.cd_cgc_prestador='06243625000160' THEN 9  ELSE CASE WHEN b.ie_responsavel_credito='M' THEN 9  ELSE 8 END  END 			cd_local_atendimento, 
		sum(CASE WHEN b.cd_convenio=10 THEN CASE WHEN coalesce(b.cd_item_convenio,b.cd_item)='1007' THEN  			b.vl_honorario WHEN coalesce(b.cd_item_convenio,b.cd_item)='8004357' THEN b.vl_honorario WHEN coalesce(b.cd_item_convenio,b.cd_item)='8004352' THEN b.vl_honorario  ELSE (b.vl_total_item - coalesce(b.vl_filme,0)) END   ELSE (b.vl_total_item - coalesce(b.vl_filme,0)) END )			vl_servico, 
		6					cd_moeda_servico, 
		sum(b.vl_filme)				vl_filme, 
		6					cd_moeda_filme, 
		b.nr_doc_convenio				nr_autorizacao, 
		coalesce(x.tx_procedimento,100)			cd_fator_plano, 
		CASE WHEN b.cd_cgc_prestador='86897113000157' THEN 25 WHEN b.cd_cgc_prestador='82606450000197' THEN 19 WHEN b.cd_cgc_prestador='03049264000128' THEN 25 WHEN b.cd_cgc_prestador='06243625000160' THEN 25  ELSE CASE WHEN b.ie_responsavel_credito='M' THEN 1  ELSE CASE WHEN a.ie_tipo_atendimento=7 THEN 3  ELSE CASE WHEN b.cd_setor_atendimento=14 THEN 6 WHEN b.cd_setor_atendimento=15 THEN 6 WHEN b.cd_setor_atendimento=49 THEN 6 WHEN b.cd_setor_atendimento=50 THEN 6 WHEN b.cd_setor_atendimento=58 THEN 6 WHEN b.cd_setor_atendimento=59 THEN 6 WHEN b.cd_setor_atendimento=16 THEN 26 WHEN b.cd_setor_atendimento=18 THEN 24 WHEN b.cd_setor_atendimento=67 THEN 21  ELSE 4 END  END  END  END  
							ie_tipo_prest_executante, 
		CASE WHEN b.cd_cgc_prestador='86897113000157' THEN 01 WHEN b.cd_cgc_prestador='82606450000197' THEN 201 WHEN b.cd_cgc_prestador='03049264000128' THEN 02 WHEN b.cd_cgc_prestador='06243625000160' THEN 3  ELSE CASE WHEN b.ie_responsavel_credito='M' THEN somente_numero(b.nr_crm_executor)  ELSE CASE WHEN b.cd_setor_atendimento=16 THEN 01 WHEN b.cd_setor_atendimento=18 THEN 01 WHEN b.cd_setor_atendimento=67 THEN 316  ELSE 127 END  END  END  
								cd_prest_executante, 
		''						ie_situacao_guia, 
		substr(a.nm_paciente,1,25)			nm_PACIENTE, 
		to_char(a.dt_alta,'hh24mi')			hr_saida_paciente, 
		a.nr_seq_protocolo				nr_seq_protocolo, 
		a.nr_atendimento				nr_atendimento, 
		a.nr_interno_conta				nr_interno_conta, 
		0						qt_doc_enviados, 
		0						qt_serv_relacionados, 
		0						qt_total_servicos_real, 
		0						qt_total_cobrado_ch, 
		0						qt_total_filme, 
		a.nr_interno_conta 				cd_campo_quebra, 
		coalesce(x.tx_procedimento,100)			pr_faturado, 
		CASE WHEN y.cd_classif_setor=4 THEN  'U' WHEN y.cd_classif_setor=2 THEN  'C'  ELSE 'Q' END 	ie_utilizado, 
		a.cd_usuario_convenio, 
		b.dt_item, 
		to_char(b.dt_item, 'hh24mi'), 
		'', 
		''					cd_medico_solic, 
		''					NM_MEDICO_RESP, 
		0					qt_dias_internacao, 
		'N'					ie_atend_emergencia, 
		0, 
		''			 		cd_usuario, 
		''					nm_empresa, 
		LOCALTIMESTAMP, 
		'', 
		'', 
		'NIP'					ie_status_nota, 
		'I'					ie_tipo_registro, 
		'', 
		0					ie_tipo_alta, 
		1					ie_tipo_internamento, 
		null					nr_guia_origem, 
		a.NR_DOC_CONVENIO, 
		a.CD_PROC_PRINCIPAL, 
		a.CD_CONV_MEDICO_RESP, 
		0					vl_unitario, 
		a.nr_doc_convenio NR_GUIA_LIBERACAO, 
		0 qt_contas, 
		0 qt_total_itens, 
		'0' NR_PROTOCOLO_HOSP 
FROM w_interf_conta_cab a, w_interf_conta_item b
LEFT OUTER JOIN procedimento_paciente x ON (b.nr_interno_conta = x.nr_interno_conta AND b.nr_seq_item = x.nr_sequencia)
LEFT OUTER JOIN setor_atendimento y ON (b.cd_setor_atendimento = y.cd_setor_atendimento)
WHERE b.nr_interno_conta		= a.nr_interno_conta and b.ie_tipo_item			= 1    group by	b.dt_item, 
		a.cd_usuario_convenio, 
		a.nr_doc_convenio, 
		b.cd_item_convenio, 
		b.ds_item, 
		a.ie_tipo_atendimento, 
		a.ie_clinica, 
		b.nr_doc_convenio, 
		CASE WHEN b.nr_crm_executor IS NULL THEN a.nr_crm_medico_resp  ELSE b.nr_crm_executor END , 
		trunc(a.dt_entrada,'dd'), 
		CASE WHEN a.ie_tipo_atendimento=7 THEN a.dt_entrada  ELSE a.dt_alta END , 
		CASE WHEN obter_atepacu_paciente(b.nr_atendimento,'PI')=0 THEN 0  ELSE a.cd_tipo_acomodacao END , 
		CASE WHEN b.cd_convenio=10 THEN  '027'  ELSE substr(a.cd_usuario_convenio,1,3) END , 
		CASE WHEN b.cd_convenio=10 THEN  '9999'  ELSE substr(a.cd_usuario_convenio,4,4) END , 
		CASE WHEN b.cd_convenio=10 THEN  '000000'  ELSE substr(a.cd_usuario_convenio,8,6) END , 
		CASE WHEN b.cd_convenio=10 THEN  '00'  ELSE substr(a.cd_usuario_convenio,14,2) END , 
		CASE WHEN b.cd_convenio=10 THEN  '0'  ELSE substr(a.cd_usuario_convenio,16,1) END , 
		to_char(a.dt_entrada,'ddmmyyyy'), 
		to_char(a.dt_entrada,'hh24mi'), 
		a.cd_cid_principal, 
		CASE WHEN y.cd_classif_setor=4 THEN  'U' WHEN y.cd_classif_setor=2 THEN  'C'  ELSE 'Q' END , 
		CASE WHEN coalesce(b.cd_item_convenio,b.cd_item)='10014' THEN '1001' WHEN coalesce(b.cd_item_convenio,b.cd_item)='10022' THEN '1002' WHEN coalesce(b.cd_item_convenio,b.cd_item)='1007' THEN '1007'  ELSE substr(coalesce(b.cd_item_convenio,b.cd_item),1,7) END , 
		to_char(b.nr_porte_anestesico), 
		to_char(b.cd_funcao_executor), 
		CASE WHEN b.cd_cgc_prestador='86897113000157' THEN 9 WHEN b.cd_cgc_prestador='82606450000197' THEN 9 WHEN b.cd_cgc_prestador='03049264000128' THEN 9 WHEN b.cd_cgc_prestador='06243625000160' THEN 9  ELSE CASE WHEN b.ie_responsavel_credito='M' THEN 9  ELSE 8 END  END , 
		b.nr_doc_convenio, 
		coalesce(x.tx_procedimento,100), 
		CASE WHEN b.cd_cgc_prestador='86897113000157' THEN 25 WHEN b.cd_cgc_prestador='82606450000197' THEN 19 WHEN b.cd_cgc_prestador='03049264000128' THEN 25 WHEN b.cd_cgc_prestador='06243625000160' THEN 25  ELSE CASE WHEN b.ie_responsavel_credito='M' THEN 1  ELSE CASE WHEN a.ie_tipo_atendimento=7 THEN 3  ELSE CASE WHEN b.cd_setor_atendimento=14 THEN 6 WHEN b.cd_setor_atendimento=15 THEN 6 WHEN b.cd_setor_atendimento=49 THEN 6 WHEN b.cd_setor_atendimento=50 THEN 6 WHEN b.cd_setor_atendimento=58 THEN 6 WHEN b.cd_setor_atendimento=59 THEN 6 WHEN b.cd_setor_atendimento=16 THEN 26 WHEN b.cd_setor_atendimento=18 THEN 24 WHEN b.cd_setor_atendimento=67 THEN 21  ELSE 4 END  END  END  END , 
		CASE WHEN b.cd_cgc_prestador='86897113000157' THEN 01 WHEN b.cd_cgc_prestador='82606450000197' THEN 201 WHEN b.cd_cgc_prestador='03049264000128' THEN 02 WHEN b.cd_cgc_prestador='06243625000160' THEN 03  ELSE CASE WHEN b.ie_responsavel_credito='M' THEN somente_numero(b.nr_crm_executor)  ELSE CASE WHEN b.cd_setor_atendimento=16 THEN 01 WHEN b.cd_setor_atendimento=18 THEN 01 WHEN b.cd_setor_atendimento=67 THEN 316  ELSE 127 END  END  END , 
		substr(a.nm_paciente,1,25), 
		to_char(a.dt_alta,'hh24mi'), 
		a.nr_seq_protocolo, 
		a.nr_atendimento, 
		b.CD_UNIDADE_MEDIDA, 
		a.nr_interno_conta, 
		a.NR_DOC_CONVENIO, 
		a.CD_PROC_PRINCIPAL, 
		a.CD_CONV_MEDICO_RESP 
having		sum(b.qt_item) > 0 

union all
 
select		3					tp_registro, 
		0					ie_tipo_protocolo, 
		4					ie_tipo_prestador, 
		'127'					cd_prestador, 
		'00' NR_ESPECIALIDADE, 
		''					nm_prestador, 
		'0' CD_INTERNO, 
		0					nr_lote, 
		LOCALTIMESTAMP					dt_geracao, 
		a.ie_tipo_atendimento, 
		a.ie_clinica, 
		b.nr_doc_convenio				nr_documento, 
		b.cd_item_convenio, 
		b.cd_brasindice CD_SERV_MAT_MED,				 
		CASE WHEN x.ie_tipo_material='1' THEN  'MAT'  ELSE 'MED' END 	ie_tipo_item, 
		b.ds_item, 
		sum(b.qt_item)				qt_item, 
		sum(b.vl_unitario_item), 
		sum(b.vl_total_item), 
		b.CD_UNIDADE_MEDIDA, 
		''					nr_cep, 
		1					cd_tipo_prestador, 
		CASE WHEN b.nr_crm_executor IS NULL THEN a.nr_crm_medico_resp  ELSE b.nr_crm_executor END 		 nr_crm, 
		trunc(a.dt_entrada,'dd')				dt_inicio_internacao, 
		LOCALTIMESTAMP DT_PERIODO_INICIAL, 
		LOCALTIMESTAMP DT_PERIODO_FINAL  ,   
		CASE WHEN a.ie_tipo_atendimento=7 THEN a.dt_entrada  ELSE a.dt_alta END  				dt_alta, 
		CASE WHEN obter_atepacu_paciente(b.nr_atendimento,'PI')=0 THEN 0  ELSE a.cd_tipo_acomodacao END 	ie_padrao_internacao, 
		CASE WHEN b.cd_convenio=10 THEN  '027'  ELSE substr(a.cd_usuario_convenio,1,3) END 			cd_unimed_usuario, 
		CASE WHEN b.cd_convenio=10 THEN  '9999'  ELSE substr(a.cd_usuario_convenio,4,4) END 			cd_contrato_usuario, 
		CASE WHEN b.cd_convenio=10 THEN  '000000'  ELSE substr(a.cd_usuario_convenio,8,6) END 		cd_familia_usuario, 
		CASE WHEN b.cd_convenio=10 THEN  '00'  ELSE substr(a.cd_usuario_convenio,14,2) END 			ie_dependencia_usuario, 
		CASE WHEN b.cd_convenio=10 THEN  '0'  ELSE substr(a.cd_usuario_convenio,16,1) END 			ie_digito_ver_usuario, 
		to_char(a.dt_entrada,'ddmmyyyy')		dt_exec_servico, 
		to_char(a.dt_entrada,'hh24mi')			hr_exec_servico, 
		null					cd_cid, 
		''					ie_detalhe_cid, 
		''					cd_dig_verif_cid, 
		0					cd_seq_doc_servico, 
		substr(coalesce(b.cd_item_convenio,b.cd_item),1,7) 	cd_amb_lpm, 
		'0'					cd_dig_verif_servico, 
		1					qt_servico_executado, 
		''					ie_porte_cirurgico, 
		''					ie_partic_executante, 
		8					cd_local_atendimento, 
		sum(b.vl_total_item)			vl_servico, 
		6					cd_moeda_servico, 
		0					vl_filme, 
		6					cd_moeda_filme, 
		b.nr_doc_convenio				nr_autorizacao, 
		CASE WHEN a.cd_categoria_convenio='1' THEN 100  ELSE 200 END 	cd_fator_plano, 
		CASE WHEN b.cd_cgc_prestador='86897113000157' THEN 25 WHEN b.cd_cgc_prestador='82606450000197' THEN 19 WHEN b.cd_cgc_prestador='03049264000128' THEN 25 WHEN b.cd_cgc_prestador='06243625000160' THEN 25  ELSE CASE WHEN b.ie_responsavel_credito='M' THEN 1  ELSE CASE WHEN a.ie_tipo_atendimento=7 THEN 3  ELSE CASE WHEN b.cd_setor_atendimento=14 THEN 6 WHEN b.cd_setor_atendimento=15 THEN 6 WHEN b.cd_setor_atendimento=49 THEN 6 WHEN b.cd_setor_atendimento=50 THEN 6 WHEN b.cd_setor_atendimento=58 THEN 6 WHEN b.cd_setor_atendimento=59 THEN 6 WHEN b.cd_setor_atendimento=16 THEN 26 WHEN b.cd_setor_atendimento=18 THEN 24 WHEN b.cd_setor_atendimento=67 THEN 21  ELSE 4 END  END  END  END  
							ie_tipo_prest_executante, 
		CASE WHEN b.cd_setor_atendimento=16 THEN 01 WHEN b.cd_setor_atendimento=18 THEN 01 WHEN b.cd_setor_atendimento=67 THEN 316  ELSE 127 END 				cd_prest_executante, 
		''					ie_situacao_guia, 
		substr(a.nm_paciente,1,25)			nm_PACIENTE, 
		to_char(a.dt_alta,'hh24mi')			hr_saida_paciente, 
		a.nr_seq_protocolo				nr_seq_protocolo, 
		a.nr_atendimento				nr_atendimento, 
		a.nr_interno_conta				nr_interno_conta, 
		0					qt_doc_enviados, 
		0					qt_serv_relacionados, 
		0					qt_total_servicos_real, 
		0					qt_total_cobrado_ch, 
		0					qt_total_filme, 
		a.nr_interno_conta				cd_campo_quebra, 
		100					pr_faturado, 
		CASE WHEN y.cd_classif_setor=4 THEN  'U' WHEN y.cd_classif_setor=2 THEN  'C'  ELSE 'Q' END  	ie_utilizado, 
		a.cd_usuario_convenio, 
		b.dt_item, 
		to_char(b.dt_item, 'hh24mi'), 
		'', 
		''					cd_medico_solic, 
		''					NM_MEDICO_RESP, 
		0					qt_dias_internacao, 
		'N'					ie_atend_emergencia, 
		0, 
		''			 		cd_usuario, 
		''					nm_empresa, 
		LOCALTIMESTAMP, 
		'', 
		'', 
		'NIP'					ie_status_nota, 
		'I'					ie_tipo_registro, 
		'', 
		0					ie_tipo_alta, 
		1					ie_tipo_internamento, 
		null					nr_guia_origem, 
		a.NR_DOC_CONVENIO, 
		a.CD_PROC_PRINCIPAL, 
		a.CD_CONV_MEDICO_RESP, 
		0					vl_unitario, 
		a.nr_doc_convenio NR_GUIA_LIBERACAO, 
		0 qt_contas, 
		0 qt_total_itens, 
		'0' NR_PROTOCOLO_HOSP 
FROM material x, w_interf_conta_cab a, w_interf_conta_item b
LEFT OUTER JOIN setor_atendimento y ON (b.cd_setor_atendimento = y.cd_setor_atendimento)
WHERE b.nr_interno_conta		= a.nr_interno_conta and b.ie_tipo_item			= 2 and b.cd_item			= x.cd_material  group by	a.cd_usuario_convenio, 
		4, 
		'127', 
		b.cd_brasindice, 
		CASE WHEN x.ie_tipo_material='1' THEN  'MAT'  ELSE 'MED' END , 
		a.nr_doc_convenio, 
		b.ds_item, 
		a.ie_tipo_atendimento, 
		a.ie_clinica, 
		b.nr_doc_convenio, 
		b.cd_brasindice,b.cd_item_convenio, 
		CASE WHEN b.nr_crm_executor IS NULL THEN a.nr_crm_medico_resp  ELSE b.nr_crm_executor END , 
		trunc(a.dt_entrada,'dd'), 
		CASE WHEN a.ie_tipo_atendimento=7 THEN a.dt_entrada  ELSE a.dt_alta END , 
		CASE WHEN obter_atepacu_paciente(b.nr_atendimento,'PI')=0 THEN 0  ELSE a.cd_tipo_acomodacao END , 
		CASE WHEN b.cd_convenio=10 THEN  '027'  ELSE substr(a.cd_usuario_convenio,1,3) END , 
		CASE WHEN b.cd_convenio=10 THEN  '9999'  ELSE substr(a.cd_usuario_convenio,4,4) END , 
		CASE WHEN b.cd_convenio=10 THEN  '000000'  ELSE substr(a.cd_usuario_convenio,8,6) END , 
		CASE WHEN b.cd_convenio=10 THEN  '00'  ELSE substr(a.cd_usuario_convenio,14,2) END , 
		CASE WHEN b.cd_convenio=10 THEN  '0'  ELSE substr(a.cd_usuario_convenio,16,1) END , 
		to_char(a.dt_entrada,'ddmmyyyy'), 
		to_char(a.dt_entrada,'hh24mi'), 
		substr(coalesce(b.cd_item_convenio,b.cd_item),1,7), 
		'0', 
		a.cd_tipo_acomodacao, 
		b.nr_doc_convenio, 
		CASE WHEN a.cd_categoria_convenio='1' THEN 100  ELSE 200 END , 
		CASE WHEN b.cd_cgc_prestador='86897113000157' THEN 25 WHEN b.cd_cgc_prestador='82606450000197' THEN 19 WHEN b.cd_cgc_prestador='03049264000128' THEN 25 WHEN b.cd_cgc_prestador='06243625000160' THEN 25  ELSE CASE WHEN b.ie_responsavel_credito='M' THEN 1  ELSE CASE WHEN a.ie_tipo_atendimento=7 THEN 3  ELSE CASE WHEN b.cd_setor_atendimento=14 THEN 6 WHEN b.cd_setor_atendimento=15 THEN 6 WHEN b.cd_setor_atendimento=49 THEN 6 WHEN b.cd_setor_atendimento=50 THEN 6 WHEN b.cd_setor_atendimento=58 THEN 6 WHEN b.cd_setor_atendimento=59 THEN 6 WHEN b.cd_setor_atendimento=16 THEN 26 WHEN b.cd_setor_atendimento=18 THEN 24 WHEN b.cd_setor_atendimento=67 THEN 21  ELSE 4 END  END  END  END , 
		CASE WHEN b.cd_setor_atendimento=16 THEN 01 WHEN b.cd_setor_atendimento=18 THEN 01 WHEN b.cd_setor_atendimento=67 THEN 316  ELSE 127 END , 
		substr(a.nm_paciente,1,25), 
		to_char(a.dt_alta,'hh24mi'), 
		a.nr_seq_protocolo, 
		a.nr_atendimento, 
		a.nr_interno_conta, 
		CASE WHEN y.cd_classif_setor=4 THEN  'U' WHEN y.cd_classif_setor=2 THEN  'C'  ELSE 'Q' END , 
		b.dt_item, 
		b.CD_UNIDADE_MEDIDA, 
		a.NR_DOC_CONVENIO, 
		a.CD_PROC_PRINCIPAL, 
		a.CD_CONV_MEDICO_RESP 
having		sum(b.vl_total_item) > 0 

union all
 
select		4					tp_registro, 
		0					ie_tipo_protocolo, 
		4					ie_tipo_prestador, 
		'127'					cd_prestador, 
		'00' NR_ESPECIALIDADE, 
		''					nm_prestador, 
		'0' CD_INTERNO, 
		0					nr_lote, 
		LOCALTIMESTAMP					dt_geracao, 
		0					IE_TIPO_ATENDIMENTO, 
		0					ie_clinica, 
		''					nr_documento, 
		''					cd_item, 
		'', 
		''					ie_tipo_item, 
		''					ds_item, 
		sum(b.qt_item)					qt_item, 
		0, 
		0, 
		'', 
		''					nr_cep, 
		1					cd_tipo_prestador, 
		''					nr_crm, 
		LOCALTIMESTAMP					dt_inicio_internacao, 
		LOCALTIMESTAMP DT_PERIODO_INICIAL, 
		LOCALTIMESTAMP DT_PERIODO_FINAL  ,   
		LOCALTIMESTAMP					dt_alta, 
		0					ie_padrao_internacao, 
		''					cd_unimed_usuario, 
		''					cd_contrato_usuario, 
		''					cd_familia_usuario, 
		''					ie_dependencia_usuario, 
		''					ie_digito_ver_usuario, 
		''					dt_exec_servico, 
		''					hr_exec_servico, 
		''					cd_cid, 
		''					ie_detalhe_cid, 
		''					cd_dig_verif_cid, 
		0					cd_seq_doc_servico, 
		''					cd_amb_lpm, 
		''					cd_dig_verif_servico, 
		0					qt_servico_executado, 
		''					ie_porte_cirurgico, 
		''					ie_partic_executante, 
		0					cd_local_atendimento, 
		sum(b.vl_total_item)			vl_servico, 
		0					cd_moeda_servico, 
		0					vl_filme, 
		0					cd_moeda_filme, 
		''					nr_autorizacao, 
		0					cd_fator_plano, 
		0					ie_tipo_prest_executante, 
		0					cd_prest_executante, 
		''					ie_situacao_guia, 
		''					nm_PACIENTE, 
		''					hr_saida_paciente, 
		x.nr_seq_protocolo			nr_seq_protocolo, 
		0					nr_atendimento, 
		99999999				nr_interno_conta, 
		x.qt_total_conta				qt_doc_enviados, 
		0					qt_serv_relacionados, 
		sum(b.vl_total_item)			qt_total_servicos_real, 
		0					qt_total_cobrado_ch, 
		sum(b.vl_filme)				qt_total_filme, 
		0					cd_campo_quebra, 
		0					pr_faturado, 
		'', 
		'', 
		LOCALTIMESTAMP, 
		'', 
		'', 
		''					cd_medico_solic, 
		''					NM_MEDICO_RESP, 
		0					qt_dias_internacao, 
		'N'					ie_atend_emergencia, 
		0, 
		''			 		cd_usuario, 
		''					nm_empresa, 
		LOCALTIMESTAMP, 
		'', 
		'', 
		'NIP'					ie_status_nota, 
		'I'					ie_tipo_registro, 
		'', 
		0					ie_tipo_alta, 
		1					ie_tipo_internamento, 
		null					nr_guia_origem, 
		' '					NR_DOC_CONVENIO, 
		'' 					CD_PROC_PRINCIPAL, 
		''					CD_CONV_MEDICO_RESP, 
		sum(b.vl_unitario_item)			vl_unitario, 
		'', 
		0 qt_contas, 
		0 qt_total_itens, 
		'0' NR_PROTOCOLO_HOSP 
from 		w_interf_conta_trailler x, 
		w_interf_conta_item b 
where		x.nr_seq_protocolo		= 		b.nr_seq_protocolo 
group by	x.nr_seq_protocolo, x.qt_total_conta 

union all
 
select		5					tp_registro, 
		0					ie_tipo_protocolo, 
		4					ie_tipo_prestador, 
		'127'					cd_prestador, 
		'00' NR_ESPECIALIDADE, 
		''					nm_prestador, 
		'0' CD_INTERNO, 
		0					nr_lote, 
		LOCALTIMESTAMP					dt_geracao, 
		0					IE_TIPO_ATENDIMENTO, 
		0					ie_clinica, 
		''					nr_documento, 
		''					cd_item, 
		'', 
		''					ie_tipo_item, 
		''					ds_item, 
		sum(b.qt_item)					qt_item, 
		0, 
		0, 
		'', 
		''					nr_cep, 
		1					cd_tipo_prestador, 
		''					nr_crm, 
		LOCALTIMESTAMP					dt_inicio_internacao, 
		LOCALTIMESTAMP DT_PERIODO_INICIAL, 
		LOCALTIMESTAMP DT_PERIODO_FINAL  ,   
		LOCALTIMESTAMP					dt_alta, 
		0					ie_padrao_internacao, 
		''					cd_unimed_usuario, 
		''					cd_contrato_usuario, 
		''					cd_familia_usuario, 
		''					ie_dependencia_usuario, 
		''					ie_digito_ver_usuario, 
		''					dt_exec_servico, 
		''					hr_exec_servico, 
		''					cd_cid, 
		''					ie_detalhe_cid, 
		''					cd_dig_verif_cid, 
		0					cd_seq_doc_servico, 
		''					cd_amb_lpm, 
		''					cd_dig_verif_servico, 
		0					qt_servico_executado, 
		''					ie_porte_cirurgico, 
		''					ie_partic_executante, 
		0					cd_local_atendimento, 
		sum(b.vl_total_item)			vl_servico, 
		0					cd_moeda_servico, 
		0					vl_filme, 
		0					cd_moeda_filme, 
		''					nr_autorizacao, 
		0					cd_fator_plano, 
		0					ie_tipo_prest_executante, 
		0					cd_prest_executante, 
		''					ie_situacao_guia, 
		''					nm_PACIENTE, 
		''					hr_saida_paciente, 
		x.nr_seq_protocolo			nr_seq_protocolo, 
		0					nr_atendimento, 
		99999999				nr_interno_conta, 
		x.qt_total_conta				qt_doc_enviados, 
		0					qt_serv_relacionados, 
		sum(b.vl_total_item)			qt_total_servicos_real, 
		0					qt_total_cobrado_ch, 
		sum(b.vl_filme)				qt_total_filme, 
		0					cd_campo_quebra, 
		0					pr_faturado, 
		'', 
		'', 
		LOCALTIMESTAMP, 
		'', 
		'', 
		''					cd_medico_solic, 
		''					NM_MEDICO_RESP, 
		0					qt_dias_internacao, 
		'N'					ie_atend_emergencia, 
		0, 
		''			 		cd_usuario, 
		''					nm_empresa, 
		LOCALTIMESTAMP, 
		'', 
		'', 
		'NIP'					ie_status_nota, 
		'I'					ie_tipo_registro, 
		'', 
		0					ie_tipo_alta, 
		1					ie_tipo_internamento, 
		null					nr_guia_origem, 
		' '					NR_DOC_CONVENIO, 
		'' 					CD_PROC_PRINCIPAL, 
		''					CD_CONV_MEDICO_RESP, 
		sum(b.vl_unitario_item)			vl_unitario, 
		'', 
		count(distinct nr_interno_conta)	qt_contas, 
		count(cd_item_convenio)			qt_total_itens, 
		'0' NR_PROTOCOLO_HOSP 
from 		w_interf_conta_trailler x, 
		w_interf_conta_item b 
where		x.nr_seq_protocolo		= 		b.nr_seq_protocolo 
group by	x.nr_seq_protocolo, x.qt_total_conta;
