-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';

CREATE OR REPLACE VIEW hs_interf_unimed_sdc801_v (tp_registro, nr_sequencia, dt_remessa, nr_seq_protocolo, nr_interno_conta, cd_interno, cd_regional, nr_lote, cd_senha_guia, nr_doc_convenio, nr_doc_conta, ie_tipo_documento, dt_emissao, dt_entrada, dt_alta, hr_entrada, hr_alta, cd_usuario_convenio, nm_usuario_convenio, uf_medico_solicitante, cd_medico_solicitante, cd_doenca_def, cd_motivo_alta, ie_carater_internacao, cd_procedimento_princ, cd_tipo_acomodacao, ie_clinica, cd_tipo_plano, dt_procedimento, hr_procedimento, ie_cirurgia_video, cd_medico_executor, ie_funcao_executor, cd_item, ie_cirurgia_multipla, ie_tipo_nascimento, ie_sexo, dt_nascimento, dt_mesano_referencia, ie_tipo_paciente, qt_item, vl_item, qt_filme, vl_filme, vl_custo_operacional, vl_medico, ds_zeros, ds_espaco, tp_obito, tp_transferencia, cd_cid_principal, tp_consulta, ie_carater_atendimento, tp_saida_sadt, nr_doc_principal, tp_atendimento, ie_acidente, ie_regime_inter, id_int_obstetricia_1, id_int_obstetricia_2, id_int_obstetricia_3, id_int_obstetricia_4, id_int_obstetricia_5, id_int_obstetricia_6, id_int_obstetricia_7, id_int_obstetricia_8, id_int_obstetricia_9, qt_obito_nasc_precoce, qt_obito_nasc_tardio, nr_declaracao_vivos, nr_declaracao_vivos2, nr_declaracao_vivos3, qt_nasc_vivo_termo, qt_nasc_mortos, qt_nasc_vivo_prematuro, nr_declaracao_obito, indicacao_clinica, obito_mulher, dt_validade_carteira, cd_conselho, nr_conselho, cd_tabela, tp_saida_consulta, hr_inicial_proc, hr_final_proc, cd_cnes, nr_seq_ref_partic, tp_faturamento, vl_total, cd_registro_ans, dt_validade_senha, nr_conselho_solic, cd_cid_obito) AS SELECT	
	1 				tp_registro, 
	0 				nr_sequencia, 
	c.dt_remessa			dt_remessa, 
	a.nr_seq_protocolo		nr_seq_protocolo, 
	a.nr_interno_conta		nr_interno_conta, 
 	a.cd_interno			cd_interno, 
 	c.cd_regional 			cd_regional, 
	'001'||to_char(c.dt_remessa,'YYMM') nr_lote, 
 	somente_numero(substr(a.cd_senha_guia,1,9)) cd_senha_guia, 
   	somente_numero(substr(a.nr_doc_convenio,1,7)) nr_doc_convenio, 
	somente_numero(substr(b.nr_doc_convenio,1,7)) nr_doc_conta, 
 	substr(Obter_Conversao_Externa(a.cd_cgc_convenio,'HS_INTERF_UNIMED_SDC801_V','IE_TIPO_DOCUMENTO', 
			coalesce(substr(OBTER_TIPO_GUIA_CONVENIO(a.nr_atendimento),1,5),'0')),1,80) ie_tipo_documento, 
 	a.dt_entrada 			dt_emissao, 
	CASE WHEN a.ie_tipo_atendimento=1 THEN    	 	to_char(a.dt_entrada,'ddmmyyyy')  ELSE '    ' END  dt_entrada,           
	CASE WHEN a.ie_tipo_atendimento=1 THEN            	 	to_char(coalesce(a.dt_alta,a.dt_entrada),'ddmmyyyy')  ELSE '    ' END  dt_alta,           
	CASE WHEN a.ie_tipo_atendimento=1 THEN            	 	CASE WHEN a.dt_entrada IS NULL THEN  '0000'  ELSE to_char(a.dt_entrada,'hh24mi') END    ELSE '0000' END  hr_entrada,           
	CASE WHEN a.ie_tipo_atendimento=1 THEN            	 	to_char(coalesce(a.dt_alta,a.dt_entrada),'hh24mi')  ELSE '0000' END  hr_alta,          
 	somente_numero(substr(a.cd_usuario_convenio,1,15)) cd_usuario_convenio,       
 	substr(a.nm_paciente,1,25) nm_usuario_convenio, 
 	a.uf_crm_medico_resp uf_medico_solicitante,    
	a.CD_CONV_MEDICO_RESP cd_medico_solicitante,    
 	CASE WHEN a.ie_tipo_atendimento=1 THEN  a.cd_cid_principal WHEN a.ie_tipo_atendimento=3 THEN  a.cd_cid_principal WHEN a.ie_tipo_atendimento=7 THEN  a.cd_cid_principal  ELSE null END  cd_doenca_def, 
	CASE WHEN a.ie_tipo_atendimento=1 THEN to_char(a.cd_motivo_alta)  ELSE '00' END  cd_motivo_alta, 
 	coalesce(a.ie_carater_sus,1) ie_carater_internacao, 
 	a.cd_proc_principal cd_procedimento_princ, 
 	substr(Obter_Conversao_Externa(c.CD_CGC_CONVENIO, 'HS_INTERF_UNIMED_SDC801_V', 'CD_TIPO_ACOMODACAO', 
		CASE WHEN a.ie_tipo_atendimento=1 THEN  a.cd_tipo_acomodacao  ELSE null END ),1,20) cd_tipo_acomodacao, 
 	CASE WHEN a.ie_tipo_atendimento=1 THEN coalesce(a.ie_clinica,1)  ELSE 0 END  ie_clinica, 
 	substr(Obter_Conversao_Externa(c.CD_CGC_CONVENIO, 'HS_INTERF_UNIMED_SDC801_V', 'CD_TIPO_PLANO', a.cd_categoria_convenio),1,50) cd_tipo_plano, 
	trunc(CASE WHEN b.ie_tipo_item=1 THEN  b.dt_item  ELSE a.dt_alta END ,'dd') 	 dt_procedimento, 
	to_char(CASE WHEN b.ie_tipo_item=1 THEN  b.dt_item  ELSE a.dt_alta END , 'hh24mi') hr_procedimento, 
	/*decode(b.cd_medico_executor,null,trunc(a.dt_entrada,'dd'), 
			trunc(b.dt_item,'dd')) dt_procedimento, 
	decode(b.cd_medico_executor,null,to_char(a.dt_entrada,'hh24mi'), 
			to_char(b.dt_item,'hh24mi')) hr_procedimento,*/
 
 	b.ie_video ie_cirurgia_video, 
	--decode(nvl(b.cd_medico_exec_conv,'0'),'0', a.cd_interno, b.cd_medico_exec_conv) cd_medico_executor, 
	substr(CASE WHEN b.ie_tipo_item=2 THEN  coalesce(obter_prestador_convenio(b.cd_cgc_prestador,a.cd_convenio,a.cd_categoria_convenio),a.cd_interno)  ELSE CASE WHEN coalesce(b.cd_medico_exec_conv,'0')='0' THEN  a.cd_interno  ELSE b.cd_medico_exec_conv END  END ,1,14) cd_medico_executor, 
	substr(b.cd_funcao_executor,1,5) ie_funcao_executor, 
 	b.cd_item_convenio cd_item, 
	CASE WHEN a.ie_tipo_atendimento=1 THEN coalesce(b.ie_via_acesso,'N')  ELSE 'N' END  ie_cirurgia_multipla,           
 	a.ie_tipo_nascimento, 
 	a.ie_sexo,                  
 	a.dt_nascimento,      
	d.dt_mesano_referencia, 
	1 ie_tipo_paciente,         
 	CASE WHEN b.cd_item_convenio='9905010' THEN  1  ELSE CASE WHEN b.cd_item_convenio='9905011' THEN  1  ELSE sum(qt_item) END  END  qt_item, 
 	sum(CASE WHEN b.cd_area_proc=1 THEN b.vl_honorario  ELSE (CASE WHEN b.cd_area_proc=4 THEN b.vl_honorario  ELSE b.vl_total_item END ) END ) vl_item, 
	sum(b.qt_filme) qt_filme,                 
 	sum(b.vl_filme) vl_filme,                 
 	sum(b.vl_custo_oper) vl_custo_operacional, 
 	sum(vl_honorario) vl_medico,                 
 	'00000000000000000000000000000000000000000000' ds_zeros, 
	'                      ' ds_espaco, 
	CASE WHEN coalesce(substr(OBTER_SE_ALTA_OBITO(a.nr_atendimento),1,1),'N')='S' THEN  CASE WHEN a.ie_necropsia='S' THEN  1  ELSE 2 END   ELSE 0 END  tp_obito, 
	CASE WHEN substr(obter_se_transferencia(a.nr_atendimento),1,1)='S' THEN 8  ELSE 0 END  tp_transferencia, 
	a.cd_cid_principal, 
	CASE WHEN a.ie_tipo_atendimento=1 THEN  CASE WHEN b.cd_especialidade_proc=101 THEN 1  ELSE 0 END   ELSE 1 END  tp_consulta, 
	a.ie_carater_inter	ie_carater_atendimento, 
	coalesce(somente_numero(TISS_OBTER_TIPO_SAIDA('SPSADT',a.nr_interno_conta)),5) TP_SAIDA_SADT, 
	somente_numero(substr(coalesce(TISS_OBTER_GUIA_PRINCIPAL(a.nr_atendimento,a.cd_convenio),b.nr_doc_convenio),1,7)) NR_DOC_PRINCIPAL, 
	somente_numero(substr(obter_tipo_atend_tiss(a.nr_atendimento, a.nr_interno_conta),1,2)) TP_ATENDIMENTO, 
	OBTER_ACIDENTE_TISS_ATEND(a.nr_atendimento) IE_ACIDENTE, 
	CASE WHEN a.ie_tipo_atendimento=1 THEN 1  ELSE 0 END 	ie_regime_inter, 
	max(CASE WHEN substr(obter_dados_int_obstetrica(a.nr_atendimento,'1'),1,1)='S' THEN 'X'  ELSE ' ' END ) ID_INT_OBSTETRICIA_1, 
	max(CASE WHEN substr(obter_dados_int_obstetrica(a.nr_atendimento,'2'),1,1)='S' THEN 'X'  ELSE ' ' END ) ID_INT_OBSTETRICIA_2, 
	max(CASE WHEN substr(obter_dados_int_obstetrica(a.nr_atendimento,'3'),1,1)='S' THEN 'X'  ELSE ' ' END ) ID_INT_OBSTETRICIA_3, 
	max(CASE WHEN substr(obter_dados_int_obstetrica(a.nr_atendimento,'4'),1,1)='S' THEN 'X'  ELSE ' ' END ) ID_INT_OBSTETRICIA_4, 
	max(CASE WHEN substr(obter_dados_int_obstetrica(a.nr_atendimento,'5'),1,1)='S' THEN 'X'  ELSE ' ' END ) ID_INT_OBSTETRICIA_5, 
	max(CASE WHEN substr(obter_dados_int_obstetrica(a.nr_atendimento,'6'),1,1)='S' THEN 'X'  ELSE ' ' END ) ID_INT_OBSTETRICIA_6, 
	max(CASE WHEN substr(obter_dados_int_obstetrica(a.nr_atendimento,'7'),1,1)='S' THEN 'X'  ELSE ' ' END ) ID_INT_OBSTETRICIA_7, 
	max(CASE WHEN substr(obter_dados_int_obstetrica(a.nr_atendimento,'8'),1,1)='S' THEN 'X'  ELSE ' ' END ) ID_INT_OBSTETRICIA_8, 
	max(CASE WHEN substr(obter_dados_int_obstetrica(a.nr_atendimento,'9'),1,1)='S' THEN 'X'  ELSE ' ' END ) ID_INT_OBSTETRICIA_9, 
	CASE WHEN a.ie_tipo_nascimento=8 THEN 1  ELSE 0 END 		qt_obito_nasc_precoce, 
	CASE WHEN a.ie_tipo_nascimento=7 THEN 1  ELSE 0 END 		qt_obito_nasc_tardio, 
	substr(OBTER_DNV_NASCIMENTO(a.nr_atendimento),1,15) NR_DECLARACAO_VIVOS, 
	'0'			NR_DECLARACAO_VIVOS2, 
	'0'			NR_DECLARACAO_VIVOS3, 
	CASE WHEN a.ie_tipo_nascimento=4 THEN 1  ELSE 0 END 		QT_NASC_VIVO_TERMO, 
	CASE WHEN a.ie_tipo_nascimento=5 THEN 1  ELSE 0 END  		QT_NASC_MORTOS, 
	CASE WHEN a.ie_tipo_nascimento=3 THEN 1  ELSE 0 END 		qt_nasc_vivo_prematuro, 
	substr(Obter_Declaracao_Obito(a.nr_atendimento),1,7) NR_DECLARACAO_OBITO, 
	substr(Hs_Obter_indicacao_clinica(a.nr_atendimento, NULL, NULL),1,100)	indicacao_clinica, 
	0 			obito_mulher, 
	a.dt_validade_carteira	DT_VALIDADE_CARTEIRA, 
	'CRM'			CD_CONSELHO, 
	SUBSTR(b.NR_CRM_EXECUTOR,1,15) NR_CONSELHO, 
	b.ie_origem_proced	CD_TABELA, 
	substr(coalesce(TISS_OBTER_TIPO_SAIDA('C',a.nr_interno_conta),'5'),1,1) TP_SAIDA_CONSULTA, 
	/*max(b.dt_item)		HR_INICIAL_PROC, 
	max(b.dt_item)		HR_FINAL_PROC,*/
 
	max(CASE WHEN b.ie_tipo_item=1 THEN  b.dt_item  ELSE a.DT_ALTA END )	HR_INICIAL_PROC, 
	max(CASE WHEN b.ie_tipo_item=1 THEN  b.dt_item  ELSE a.DT_ALTA END )	HR_FINAL_PROC, 
	substr(obter_dados_pf_pj(null,a.cd_cgc_hospital,'CNES'),1,7) CD_CNES, 
	' '			NR_SEQ_REF_PARTIC, 
	'T'			TP_FATURAMENTO, 
	sum(CASE WHEN b.cd_area_proc=1 THEN b.vl_honorario  ELSE (CASE WHEN b.cd_area_proc=4 THEN b.vl_honorario  ELSE b.vl_total_item END ) END ) VL_TOTAL, 
	substr(obter_dados_pf_pj(null,a.cd_cgc_convenio,'ANS'),1,6) CD_REGISTRO_ANS, 
	a.dt_validade_carteira	DT_VALIDADE_SENHA, 
	SUBSTR(b.NR_CRM_EXECUTOR,1,15) NR_CONSELHO_SOLIC, 
	substr(obter_cid_obito(a.nr_atendimento),1,7) cd_cid_obito 
FROM	Protocolo_convenio d, 
	w_interf_conta_header c, 
	w_interf_conta_item b, 
	w_interf_conta_cab a	 
where	a.nr_interno_conta	= b.nr_interno_conta 
 and	a.nr_seq_protocolo	= d.nr_seq_protocolo 
 and	a.nr_seq_protocolo	= c.nr_seq_protocolo 
group by 
	c.dt_remessa, 
	substr(obter_cid_obito(a.nr_atendimento),1,7), 
	a.nr_seq_protocolo, 
	a.nr_interno_conta, 
 	a.cd_interno,            
 	c.cd_regional,        
	a.cd_cid_principal, 
	'001'||to_char(c.dt_remessa,'YYMM'), 
	substr(obter_dados_pf_pj(null,a.cd_cgc_hospital,'CNES'),1,7), 
	substr(obter_dados_pf_pj(null,a.cd_cgc_convenio,'ANS'),1,6), 
 	somente_numero(substr(a.cd_senha_guia,1,9)), 
	CASE WHEN a.ie_tipo_atendimento=1 THEN 1  ELSE 0 END , 
   	somente_numero(substr(a.nr_doc_convenio,1,7)), 
	somente_numero(substr(b.nr_doc_convenio,1,7)), 
	OBTER_ACIDENTE_TISS_ATEND(a.nr_atendimento), 
	substr(Obter_Conversao_Externa(c.CD_CGC_CONVENIO, 'HS_INTERF_UNIMED_SDC801_V', 'CD_TIPO_PLANO', a.cd_categoria_convenio),1,50), 
 	a.ie_tipo_atendimento, 
	substr(Obter_Conversao_Externa(a.cd_cgc_convenio,'HS_INTERF_UNIMED_SDC801_V','IE_TIPO_DOCUMENTO', 
			coalesce(substr(OBTER_TIPO_GUIA_CONVENIO(a.nr_atendimento),1,5),'0')),1,80), 
 	a.dt_entrada, 
	CASE WHEN a.ie_tipo_atendimento=1 THEN            	 	to_char(a.dt_entrada,'ddmmyyyy')  ELSE '    ' END ,           
	CASE WHEN a.ie_tipo_atendimento=1 THEN            	 	to_char(coalesce(a.dt_alta,a.dt_entrada),'ddmmyyyy')  ELSE '    ' END ,           
	CASE WHEN a.ie_tipo_atendimento=1 THEN            	 	to_char(a.dt_entrada,'hh24mi')  ELSE '0000' END ,           
	CASE WHEN a.ie_tipo_atendimento=1 THEN            	 	to_char(coalesce(a.dt_alta,a.dt_entrada),'hh24mi')  ELSE '0000' END ,          
 	somente_numero(substr(a.cd_usuario_convenio,1,15)),       
 	substr(a.nm_paciente,1,25),      
 	a.uf_crm_medico_resp,  
	SUBSTR(b.NR_CRM_EXECUTOR,1,15),   
	a.CD_CONV_MEDICO_RESP,    
 	CASE WHEN a.ie_tipo_atendimento=1 THEN  a.cd_cid_principal WHEN a.ie_tipo_atendimento=3 THEN  a.cd_cid_principal WHEN a.ie_tipo_atendimento=7 THEN  a.cd_cid_principal  ELSE null END , 
	CASE WHEN a.ie_tipo_atendimento=1 THEN to_char(a.cd_motivo_alta)  ELSE '00' END , 
 	coalesce(a.ie_carater_sus,1), 
	substr(OBTER_DNV_NASCIMENTO(a.nr_atendimento),1,15), 
	substr(Obter_Declaracao_Obito(a.nr_atendimento),1,7), 
 	a.cd_proc_principal, 
 	substr(Obter_Conversao_Externa(c.CD_CGC_CONVENIO, 'HS_INTERF_UNIMED_SDC801_V', 'CD_TIPO_ACOMODACAO', 
		CASE WHEN a.ie_tipo_atendimento=1 THEN  a.cd_tipo_acomodacao  ELSE null END ),1,20), 
 	CASE WHEN a.ie_tipo_atendimento=1 THEN coalesce(a.ie_clinica,1)  ELSE 0 END , 
 	a.cd_categoria_convenio, 
	/*decode(b.cd_medico_executor,null,trunc(a.dt_entrada,'dd'), 
			trunc(b.dt_item,'dd')), 
	decode(b.cd_medico_executor,null,to_char(a.dt_entrada,'hh24mi'), 
			to_char(b.dt_item,'hh24mi')),*/
 
	trunc(CASE WHEN b.ie_tipo_item=1 THEN  b.dt_item  ELSE a.dt_alta END ,'dd'), 
	to_char(CASE WHEN b.ie_tipo_item=1 THEN  b.dt_item  ELSE a.dt_alta END , 'hh24mi'), 
 	b.ie_video, 
	substr(CASE WHEN b.ie_tipo_item=2 THEN  coalesce(obter_prestador_convenio(b.cd_cgc_prestador,a.cd_convenio,a.cd_categoria_convenio),a.cd_interno)  ELSE CASE WHEN coalesce(b.cd_medico_exec_conv,'0')='0' THEN  a.cd_interno  ELSE b.cd_medico_exec_conv END  END ,1,14), 
	substr(b.cd_funcao_executor,1,5), 
	b.cd_item_convenio, 
	CASE WHEN coalesce(b.cd_funcao_executor,'0')='0' THEN  'H'  ELSE b.cd_funcao_executor END , 
	CASE WHEN a.ie_tipo_atendimento=1 THEN coalesce(b.ie_via_acesso,'N')  ELSE 'N' END ,           
 	a.ie_tipo_nascimento, 
 	a.ie_sexo,                  
 	a.dt_nascimento,      
	d.dt_mesano_referencia, 
	CASE WHEN coalesce(substr(OBTER_SE_ALTA_OBITO(a.nr_atendimento),1,1),'N')='S' THEN  CASE WHEN a.ie_necropsia='S' THEN  1  ELSE 2 END   ELSE 0 END , 
	CASE WHEN substr(obter_se_transferencia(a.nr_atendimento),1,1)='S' THEN 8  ELSE 0 END , 
	a.ie_carater_inter, 
	somente_numero(substr(coalesce(TISS_OBTER_GUIA_PRINCIPAL(a.nr_atendimento, a.cd_convenio),b.nr_doc_convenio),1,7)), 
	somente_numero(substr(obter_tipo_atend_tiss(a.nr_atendimento, a.nr_interno_conta),1,2)), 
	a.dt_validade_carteira,	 
	b.ie_origem_proced, 
	CASE WHEN a.ie_tipo_atendimento=1 THEN  CASE WHEN b.cd_especialidade_proc=101 THEN 1  ELSE 0 END   ELSE 1 END , 
	coalesce(somente_numero(TISS_OBTER_TIPO_SAIDA('SPSADT',a.nr_interno_conta)),5), 
	substr(coalesce(TISS_OBTER_TIPO_SAIDA('C',a.nr_interno_conta),'5'),1,1),	 
	substr(Hs_Obter_indicacao_clinica(a.nr_atendimento, null, null),1,100) 
having	CASE WHEN b.cd_item_convenio='9905010' THEN  1  ELSE CASE WHEN b.cd_item_convenio='9905011' THEN  1  ELSE sum(qt_item) END  END  > 0 

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
	'', 
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
	'', 
	'', 
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
	'', 
	'' 
from	w_interf_conta_Trailler;
