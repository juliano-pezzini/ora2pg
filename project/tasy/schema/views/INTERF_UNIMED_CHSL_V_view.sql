-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';

CREATE OR REPLACE VIEW interf_unimed_chsl_v (tp_registro, nr_sequencia, dt_remessa, nr_seq_protocolo, nr_interno_conta, cd_interno, cd_regional, nr_lote, cd_senha_guia, nr_doc_convenio, ie_tipo_documento, dt_emissao, dt_entrada, dt_alta, hr_entrada, hr_alta, cd_usuario_convenio, nm_usuario_convenio, uf_medico_solicitante, cd_medico_solicitante, cd_doenca_def, cd_motivo_alta, ie_carater_internacao, cd_procedimento_princ, cd_tipo_acomodacao, ie_clinica, cd_tipo_plano, dt_procedimento, hr_procedimento, ie_cirurgia_video, cd_medico_executor, ie_funcao_executor, cd_item, ie_cirurgia_multipla, ie_tipo_nascimento, ie_sexo, dt_nascimento, dt_mesano_referencia, ie_tipo_paciente, qt_item, vl_item, qt_filme, vl_filme, vl_custo_operacional, vl_medico, ds_zeros, ds_espaco, tp_obito, tp_transferencia, cd_cid_principal, tp_consulta, ie_carater_atendimento, tp_saida_sadt, nr_doc_principal, tp_atendimento, ie_acidente, ie_regime_inter, id_int_obstetricia_1, id_int_obstetricia_2, id_int_obstetricia_3, id_int_obstetricia_4, id_int_obstetricia_5, id_int_obstetricia_6, id_int_obstetricia_7, id_int_obstetricia_8, id_int_obstetricia_9, qt_obito_nasc_precoce, qt_obito_nasc_tardio, nr_declaracao_vivos, nr_declaracao_vivos2, nr_declaracao_vivos3, qt_nasc_vivo_termo, qt_nasc_mortos, qt_nasc_vivo_prematuro, nr_declaracao_obito, indicacao_clinica, obito_mulher, dt_validade_carteira, cd_conselho, nr_conselho, cd_tabela, tp_saida_consulta, hr_inicial_proc, hr_final_proc, cd_cnes, nr_seq_ref_partic, tp_faturamento, vl_total, cd_registro_ans, dt_validade_senha, nr_conselho_solic) AS SELECT	
	1 				tp_registro, 
	0 				nr_sequencia, 
	c.dt_remessa			dt_remessa, 
	a.nr_seq_protocolo		nr_seq_protocolo, 
	a.nr_interno_conta		nr_interno_conta, 
 	a.cd_interno			cd_interno, 
 	c.cd_regional 			cd_regional, 
	'001'||to_char(c.dt_remessa,'YYMM') nr_lote, 
 	somente_numero(substr(b.cd_senha_guia,1,9)) cd_senha_guia, 
   	somente_numero(substr(b.nr_doc_convenio,1,7)) nr_doc_convenio, 
 	substr(Obter_Conversao_Externa(a.cd_cgc_convenio,'INTERF_UNIMED_CHSL_V','IE_TIPO_DOCUMENTO', coalesce(a.ie_tipo_atendimento,0)),1,80) 
					ie_tipo_documento, 
 	a.dt_entrada 			dt_emissao, 
	CASE WHEN a.ie_tipo_atendimento=1 THEN    	 	to_char(a.dt_entrada,'ddmmyyyy')  ELSE '00000000' END  dt_entrada,           
	CASE WHEN a.ie_tipo_atendimento=1 THEN            	 	to_char(coalesce(a.dt_alta,a.dt_entrada),'ddmmyyyy')  ELSE '00000000' END  dt_alta,           
	CASE WHEN a.ie_tipo_atendimento=1 THEN            	 	CASE WHEN a.dt_entrada IS NULL THEN  '0000'  ELSE to_char(a.dt_entrada,'hh24mi') END    ELSE '0000' END  hr_entrada,           
	CASE WHEN a.ie_tipo_atendimento=1 THEN            	 	to_char(coalesce(a.dt_alta,a.dt_entrada),'hh24mi')  ELSE '0000' END  hr_alta,          
 	somente_numero(substr(a.cd_usuario_convenio,1,15)) cd_usuario_convenio,       
 	substr(a.nm_paciente,1,25) nm_usuario_convenio, 
 	a.uf_crm_medico_resp uf_medico_solicitante,    
	a.CD_CONV_MEDICO_RESP cd_medico_solicitante,    
 	CASE WHEN a.ie_tipo_atendimento=1 THEN a.cd_cid_principal  ELSE null END  cd_doenca_def, 
	CASE WHEN a.ie_tipo_atendimento=1 THEN  		CASE WHEN e.ie_obito='S' THEN 0  ELSE CASE WHEN e.ie_transferencia='S' THEN 0  ELSE a.cd_motivo_alta END  END   ELSE 0 END  cd_motivo_alta, 
 	CASE WHEN a.ie_tipo_atendimento=1 THEN  coalesce(a.ie_carater_sus,1)  ELSE ' ' END  ie_carater_internacao, 
 	a.cd_proc_principal cd_procedimento_princ, 
 	substr(Obter_Conversao_Externa(c.CD_CGC_CONVENIO, 'INTERF_UNIMED_CHSL_V', 'CD_TIPO_ACOMODACAO', 
		CASE WHEN a.ie_tipo_atendimento=1 THEN  a.cd_tipo_acomodacao  ELSE null END ),1,20) cd_tipo_acomodacao, 
 	CASE WHEN a.ie_tipo_atendimento=1 THEN  CASE WHEN coalesce(a.ie_clinica,0)=0 THEN 1  ELSE a.ie_clinica END   ELSE null END  ie_clinica,           
 	substr(Obter_Conversao_Externa(c.CD_CGC_CONVENIO, 'INTERF_UNIMED_CHSL_V', 'CD_TIPO_PLANO', a.cd_categoria_convenio),1,50) cd_tipo_plano, 
	trunc(CASE WHEN b.ie_tipo_item=1 THEN  b.dt_item  ELSE a.dt_entrada END ,'dd') 		dt_procedimento, 
	to_char(CASE WHEN b.ie_tipo_item=1 THEN  b.dt_item  ELSE a.dt_entrada END ,'hh24mi')	hr_procedimento, 
	/*decode(b.cd_medico_executor,null,trunc(a.dt_entrada,'dd'), 
			trunc(b.dt_item,'dd')) dt_procedimento, 
	decode(b.cd_medico_executor,null,to_char(a.dt_entrada,'hh24mi'), 
			to_char(b.dt_item,'hh24mi')) hr_procedimento,*/
 
 	b.ie_video ie_cirurgia_video, 
	substr(CASE WHEN b.ie_tipo_item=2 THEN Obter_prestador_convenio(b.CD_CGC_prestador, a.cd_convenio,null)  ELSE CASE WHEN coalesce(b.cd_medico_exec_conv,'0')='0' THEN  			Obter_prestador_convenio(coalesce(b.CD_CGC_PRESTADOR,b.CD_CGC_HOSPITAL),a.cd_convenio,null)  ELSE b.cd_medico_exec_conv END  END ,1,8) cd_medico_executor, 
	CASE WHEN coalesce(b.cd_funcao_executor,'0')='0' THEN  'H'  ELSE substr(Obter_Conversao_Externa(c.CD_CGC_CONVENIO, 'INTERF_UNIMED_CHSL_V', 			 'IE_FUNCAO_EXECUTOR', b.cd_funcao_executor),1,5) END  ie_funcao_executor,            
 	b.cd_item_convenio cd_item, 
	CASE WHEN a.ie_tipo_atendimento=1 THEN coalesce(b.ie_via_acesso,'N')  ELSE 'N' END  ie_cirurgia_multipla,           
 	a.ie_tipo_nascimento, 
 	a.ie_sexo,                  
 	a.dt_nascimento,      
	d.dt_mesano_referencia, 
	1 ie_tipo_paciente,         
 	CASE WHEN b.cd_item_convenio=9905010 THEN  1  ELSE CASE WHEN b.cd_item_convenio=9905011 THEN  1  ELSE sum(qt_item) END  END  qt_item, 
 	sum(CASE WHEN b.cd_area_proc=1 THEN b.vl_honorario  ELSE (CASE WHEN b.cd_area_proc=4 THEN b.vl_honorario  ELSE b.vl_total_item END ) END ) vl_item, 
	sum(b.qt_filme) qt_filme,                 
 	sum(b.vl_filme) vl_filme,                 
 	sum(b.vl_custo_oper) vl_custo_operacional, 
 	sum(vl_honorario) vl_medico,                 
 	'00000000000000000000000000000000000000000000' ds_zeros, 
	'                      ' ds_espaco, 
	CASE WHEN e.ie_obito='S' THEN  CASE WHEN a.ie_necropsia='S' THEN  1  ELSE 2 END   ELSE 0 END  tp_obito, 
	CASE WHEN e.ie_transferencia='S' THEN 8  ELSE 0 END  tp_transferencia, 
	a.cd_cid_principal, 
	1			tp_consulta, 
	a.ie_carater_inter	ie_carater_atendimento, 
	5			TP_SAIDA_SADT, 
	somente_numero(substr(b.nr_doc_convenio,1,7)) NR_DOC_PRINCIPAL, 
	somente_numero(substr(obter_tipo_atend_tiss(a.nr_atendimento, a.nr_interno_conta),1,2)) TP_ATENDIMENTO, 
	0			IE_ACIDENTE, 
	1			ie_regime_inter, 
	' ' 			ID_INT_OBSTETRICIA_1, 
	' ' 			ID_INT_OBSTETRICIA_2, 
	' ' 			ID_INT_OBSTETRICIA_3, 
	' ' 			ID_INT_OBSTETRICIA_4, 
	' ' 			ID_INT_OBSTETRICIA_5, 
	' ' 			ID_INT_OBSTETRICIA_6, 
	' ' 			ID_INT_OBSTETRICIA_7, 
	' ' 			ID_INT_OBSTETRICIA_8, 
	' ' 			ID_INT_OBSTETRICIA_9, 
	0 			qt_obito_nasc_precoce, 
	0 			qt_obito_nasc_tardio, 
	'0'			NR_DECLARACAO_VIVOS, 
	'0'			NR_DECLARACAO_VIVOS2, 
	'0'			NR_DECLARACAO_VIVOS3, 
	0			QT_NASC_VIVO_TERMO, 
	0			QT_NASC_MORTOS, 
	0 			qt_nasc_vivo_prematuro, 
	0			NR_DECLARACAO_OBITO, 
	coalesce(a.ie_clinica,0)	indicacao_clinica, 
	0 			obito_mulher, 
	a.dt_validade_carteira	DT_VALIDADE_CARTEIRA, 
	'CRM'			CD_CONSELHO, 
	a.uf_crm_medico_resp	NR_CONSELHO, 
	b.cd_funcao_executor	CD_TABELA, 
	'5'			TP_SAIDA_CONSULTA, 
	max(CASE WHEN b.ie_tipo_item=1 THEN  b.dt_item  ELSE a.dt_entrada END )	HR_INICIAL_PROC, 
	max(CASE WHEN b.ie_tipo_item=1 THEN  b.dt_item  ELSE a.dt_entrada END )	HR_FINAL_PROC, 
	' '			CD_CNES, 
	' '			NR_SEQ_REF_PARTIC, 
	'T'			TP_FATURAMENTO, 
	sum(CASE WHEN b.cd_area_proc=1 THEN b.vl_honorario  ELSE (CASE WHEN b.cd_area_proc=4 THEN b.vl_honorario  ELSE b.vl_total_item END ) END ) VL_TOTAL, 
	' '			CD_REGISTRO_ANS, 
	a.dt_validade_carteira	DT_VALIDADE_SENHA, 
	a.uf_crm_medico_resp 	NR_CONSELHO_SOLIC 
FROM protocolo_convenio d, w_interf_conta_header c, w_interf_conta_item b, w_interf_conta_cab a
LEFT OUTER JOIN motivo_alta e ON (a.cd_motivo_alta = e.cd_motivo_alta)
WHERE a.nr_interno_conta	= b.nr_interno_conta and a.nr_seq_protocolo	= d.nr_seq_protocolo and a.nr_seq_protocolo	= c.nr_seq_protocolo  group by 
	c.dt_remessa, 
	a.nr_seq_protocolo, 
	a.nr_interno_conta, 
 	a.cd_interno,            
 	c.cd_regional,        
	a.cd_cid_principal, 
	'001'||to_char(c.dt_remessa,'YYMM'), 
 	somente_numero(substr(b.cd_senha_guia,1,9)), 
   	somente_numero(substr(b.nr_doc_convenio,1,7)), 
	substr(Obter_Conversao_Externa(c.CD_CGC_CONVENIO, 'INTERF_UNIMED_CHSL_V', 'CD_TIPO_PLANO', a.cd_categoria_convenio),1,50), 
 	a.ie_tipo_atendimento, 
	Obter_Conversao_Externa(a.cd_cgc_convenio,'INTERF_UNIMED_CHSL_V','IE_TIPO_DOCUMENTO', coalesce(a.ie_tipo_atendimento,0)), 
 	a.dt_entrada, 
	CASE WHEN a.ie_tipo_atendimento=1 THEN            	 	to_char(a.dt_entrada,'ddmmyyyy')  ELSE '00000000' END ,           
	CASE WHEN a.ie_tipo_atendimento=1 THEN            	 	to_char(coalesce(a.dt_alta,a.dt_entrada),'ddmmyyyy')  ELSE '00000000' END ,           
	CASE WHEN a.ie_tipo_atendimento=1 THEN            	 	to_char(a.dt_entrada,'hh24mi')  ELSE '0000' END ,           
	CASE WHEN a.ie_tipo_atendimento=1 THEN            	 	to_char(coalesce(a.dt_alta,a.dt_entrada),'hh24mi')  ELSE '0000' END ,          
 	somente_numero(substr(a.cd_usuario_convenio,1,15)),       
 	substr(a.nm_paciente,1,25),      
 	a.uf_crm_medico_resp,    
	a.CD_CONV_MEDICO_RESP,    
 	CASE WHEN a.ie_tipo_atendimento=1 THEN a.cd_cid_principal  ELSE null END , 
	CASE WHEN a.ie_tipo_atendimento=1 THEN  		CASE WHEN e.ie_obito='S' THEN 0  ELSE CASE WHEN e.ie_transferencia='S' THEN 0  ELSE a.cd_motivo_alta END  END   ELSE 0 END , 
 	CASE WHEN a.ie_tipo_atendimento=1 THEN  coalesce(a.ie_carater_sus,1)  ELSE ' ' END , 
 	a.cd_proc_principal, 
 	substr(Obter_Conversao_Externa(c.CD_CGC_CONVENIO, 'INTERF_UNIMED_CHSL_V', 'CD_TIPO_ACOMODACAO', 
		CASE WHEN a.ie_tipo_atendimento=1 THEN  a.cd_tipo_acomodacao  ELSE null END ),1,20), 
 	CASE WHEN a.ie_tipo_atendimento=1 THEN  CASE WHEN coalesce(a.ie_clinica,0)=0 THEN 1  ELSE a.ie_clinica END   ELSE null END , 
 	a.cd_categoria_convenio, 
	somente_numero(substr(obter_tipo_atend_tiss(a.nr_atendimento, a.nr_interno_conta),1,2)), 
	trunc(CASE WHEN b.ie_tipo_item=1 THEN  b.dt_item  ELSE a.dt_entrada END ,'dd') , 
	to_char(CASE WHEN b.ie_tipo_item=1 THEN  b.dt_item  ELSE a.dt_entrada END ,'hh24mi'), 
	/*decode(b.cd_medico_executor,null,trunc(a.dt_entrada,'dd'), 
			trunc(b.dt_item,'dd')), 
	decode(b.cd_medico_executor,null,to_char(a.dt_entrada,'hh24mi'), 
			to_char(b.dt_item,'hh24mi')),*/
 
 	b.ie_video, 
	substr(CASE WHEN b.ie_tipo_item=2 THEN Obter_prestador_convenio(b.CD_CGC_prestador, a.cd_convenio,null)  ELSE CASE WHEN coalesce(b.cd_medico_exec_conv,'0')='0' THEN  			Obter_prestador_convenio(coalesce(b.CD_CGC_PRESTADOR,b.CD_CGC_HOSPITAL),a.cd_convenio,null)  ELSE b.cd_medico_exec_conv END  END ,1,8), 
	CASE WHEN coalesce(b.cd_funcao_executor,'0')='0' THEN  'H'  ELSE substr(Obter_Conversao_Externa(c.CD_CGC_CONVENIO, 'INTERF_UNIMED_CHSL_V', 			 'IE_FUNCAO_EXECUTOR', b.cd_funcao_executor),1,5) END ,            
 	b.cd_item_convenio, 
	CASE WHEN coalesce(b.cd_funcao_executor,'0')='0' THEN  'H'  ELSE b.cd_funcao_executor END , 
	CASE WHEN a.ie_tipo_atendimento=1 THEN coalesce(b.ie_via_acesso,'N')  ELSE 'N' END ,           
 	a.ie_tipo_nascimento, 
 	a.ie_sexo,                  
 	a.dt_nascimento,      
	d.dt_mesano_referencia, 
	CASE WHEN e.ie_obito='S' THEN  CASE WHEN a.ie_necropsia='S' THEN  1  ELSE 2 END   ELSE 0 END , 
	CASE WHEN e.ie_transferencia='S' THEN 8  ELSE 0 END , 
	a.ie_carater_inter, 
	somente_numero(substr(b.nr_doc_convenio,1,7)), 
	coalesce(a.ie_clinica,0), 
	a.dt_validade_carteira,	 
	b.cd_funcao_executor	 
having	CASE WHEN b.cd_item_convenio=9905010 THEN  1  ELSE CASE WHEN b.cd_item_convenio=9905011 THEN  1  ELSE sum(qt_item) END  END  > 0 

union all
 
SELECT	 
	9 tp_registro, 
	0, 
	LOCALTIMESTAMP, 
	nr_seq_protocolo, 
	0, 
 	'',            
 	'',        
	'', 
 	0, 
   0, 
 	'0', 
 	LOCALTIMESTAMP, 
	'', 
	'', 
	'', 
	'', 
 	0,       
 	'',      
 	'',    
	'',    
 	'', 
	0, 
 	'', 
 	'', 
 	'0', 
 	0,           
 	'', 
	LOCALTIMESTAMP, 
	'', 
 	'', 
	'', 
	'',            
 	'', 
	'',           
 	'', 
 	'',                  
 	LOCALTIMESTAMP,      
	LOCALTIMESTAMP, 
	0,         
 	0, 
 	0,                
	0,                 
 	0,                 
 	0, 
 	0, 
 	'', 
	'', 
	0, 
	0, 
	'', 
	1, 
	'', 
	0, 
	0, 
	0, 
	0, 
	0, 
	'', 
	'', 
	'', 
	'', 
	'', 
	'', 
	'', 
	'', 
	'', 
	0, 
	0, 
	'0', 
	'0', 
	'0', 
	0, 
	0, 
	0, 
	0, 
	0, 
	0, 
	LOCALTIMESTAMP, 
	'', 
	'', 
	0, 
	'',	 
	LOCALTIMESTAMP, 
	LOCALTIMESTAMP, 
	'', 
	'', 
	'', 
	0, 
	'', 
	LOCALTIMESTAMP, 
	'' 
from	w_interf_conta_Trailler;

