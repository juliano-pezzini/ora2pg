-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';

CREATE OR REPLACE VIEW abramge_v (ds_registro, tp_registro, ie_servico, cd_registro, cd_origem, nr_lote, nr_interno_conta, nr_parcela, cd_convenio, nm_convenio, tp_prestador, cd_prestador, nm_prestador, dt_geracao, nr_remessa, cd_plano, cd_paciente, cd_autorizacao, cd_acomodacao, dt_entrada, dt_saida, dt_inicio_cobranca, dt_fim_cobranca, ie_tipo_atendimento, cd_cid, cd_proc_principal, cd_medico_convenio, nr_crm, uf_crm, nr_crm_req, uf_crm_req, nr_seq_item, cd_item, nm_item, ie_emergencia, ie_extra, dt_item, ie_funcao_medico, qt_item, vl_item, ie_cirurgia_multipla, vl_total_item, qt_item_conta, nm_paciente, nr_fatura, qt_conta, vl_total_lote, nr_seq_protocolo, ds_espaco, nr_registro, ie_matmed, ds_ma_me_tx, ie_tipo_atend_esp, ie_tipo_atend_tasy) AS SELECT		'HEADER        '		DS_REGISTRO,
		1					TP_REGISTRO, 
		'CSMH'					IE_SERVICO, 
		0					CD_REGISTRO, 
		(coalesce(A.CD_INTERNO,0))::numeric 	CD_ORIGEM, 
		0					NR_LOTE, 
		0					NR_INTERNO_CONTA, 
		0					NR_PARCELA, 
		(coalesce(A.CD_REGIONAL,0))::numeric 	CD_CONVENIO, 
		substr(ELIMINA_ACENTUACAO(UPPER(A.NM_CONVENIO)),1,30) 
							NM_CONVENIO, 
		'J'					TP_PRESTADOR, 
		A.CD_CGC_HOSPITAL			CD_PRESTADOR, 
		substr(ELIMINA_ACENTUACAO(UPPER(A.NM_HOSPITAL)),1,40) 
							NM_PRESTADOR, 
		A.DT_REMESSA				DT_GERACAO, 
		A.nr_remessa				NR_REMESSA, 
		' '					CD_PLANO, 
		' '					CD_PACIENTE,		 
		' '					CD_AUTORIZACAO, 
		0					CD_ACOMODACAO, 
		LOCALTIMESTAMP				DT_ENTRADA, 
		LOCALTIMESTAMP				DT_SAIDA, 
		LOCALTIMESTAMP				DT_INICIO_COBRANCA, 
		LOCALTIMESTAMP				DT_FIM_COBRANCA, 
		0					IE_TIPO_ATENDIMENTO, 
		null					CD_CID, 
		' '					CD_PROC_PRINCIPAL, 
		' '					CD_MEDICO_CONVENIO, 
		' '					NR_CRM, 
		' '					UF_CRM, 
		' '					NR_CRM_REQ, 
		' '					UF_CRM_REQ, 
		1					NR_SEQ_ITEM, 
		' '					CD_ITEM, 
		' '					NM_ITEM, 
		' '					IE_EMERGENCIA, 
		' '					IE_EXTRA, 
		LOCALTIMESTAMP				DT_ITEM, 
		0					IE_FUNCAO_MEDICO, 
		0					QT_ITEM, 
		0					VL_ITEM, 
		0					IE_CIRURGIA_MULTIPLA, 
		0					VL_TOTAL_ITEM, 
      	0	   				QT_ITEM_CONTA, 
	   	' '					NM_PACIENTE, 
	    ' '	   				NR_FATURA, 
      	0					QT_CONTA, 
	    0					VL_TOTAL_LOTE, 
		A.NR_SEQ_PROTOCOLO			NR_SEQ_PROTOCOLO, 
		'          '		DS_ESPACO, 
		1					NR_REGISTRO, 
		' '					IE_MATMED, 
		' '					DS_MA_ME_TX, 
		' '					ie_tipo_atend_esp, 
		0					ie_tipo_atend_tasy 
FROM		W_INTERF_CONTA_HEADER A 

union all
 
SELECT		'CABECALHO CONTA   '		DS_REGISTRO, 
		2					TP_REGISTRO, 
		'CSMH'					IE_SERVICO, 
		1					CD_REGISTRO, 
		0					CD_ORIGEM, 
		B.NR_SEQ_PROTOCOLO			NR_LOTE, 
		B.NR_INTERNO_CONTA			NR_INTERNO_CONTA, 
		1					NR_PARCELA, 
		0					CD_CONVENIO, 
		' '					NM_CONVENIO, 
		'J'					TP_PRESTADOR, 
		' '					CD_PRESTADOR, 
		' '			 		NM_PRESTADOR, 
		LOCALTIMESTAMP				DT_GERACAO, 
		1					NR_REMESSA, 
		B.CD_PLANO_CONVENIO			CD_PLANO, 
		substr(B.CD_USUARIO_CONVENIO,1,18) 
							CD_PACIENTE,		 
		substr(B.NR_DOC_CONVENIO,1,10)	CD_AUTORIZACAO, 
		B.CD_TIPO_ACOMODACAO			CD_ACOMODACAO, 
		B.DT_ENTRADA				DT_ENTRADA, 
		coalesce(B.DT_ALTA,B.DT_PERIODO_FINAL)	DT_SAIDA, 
		B.DT_PERIODO_INICIAL			DT_INICIO_COBRANCA, 
		coalesce(B.DT_ALTA,B.DT_PERIODO_FINAL)	DT_FIM_COBRANCA, 
		B.IE_CLINICA				IE_TIPO_ATENDIMENTO, 
		B.CD_CID_PRINCIPAL			CD_CID, 
		B.CD_PROC_PRINCIPAL			CD_PROC_PRINCIPAL, 
		B.CD_CONV_MEDICO_RESP		CD_MEDICO_CONVENIO, 
		B.NR_CRM_MEDICO_RESP			NR_CRM, 
		B.UF_CRM_MEDICO_RESP			UF_CRM, 
		B.NR_CRM_MEDICO_RESP			NR_CRM_REQ, 
		B.UF_CRM_MEDICO_RESP			UF_CRM_REQ, 
		1					NR_SEQ_ITEM, 
		' '					CD_ITEM, 
		' '					NM_ITEM, 
		' '					IE_EMERGENCIA, 
		' '					IE_EXTRA, 
		LOCALTIMESTAMP				DT_ITEM, 
		0					IE_FUNCAO_MEDICO, 
		0					QT_ITEM, 
		0					VL_ITEM, 
		0					IE_CIRURGIA_MULTIPLA, 
      	0	   				VL_TOTAL_ITEM, 
      	0	   				QT_ITEM_CONTA, 
	   	' '					NM_PACIENTE, 
	    ' '		   			NR_FATURA, 
      	0					QT_CONTA, 
	    0					VL_TOTAL_LOTE, 
		B.NR_SEQ_PROTOCOLO			NR_SEQ_PROTOCOLO, 
		' '					DS_ESPACO, 
		1					NR_REGISTRO, 
		' '					IE_MATMED, 
		' '					DS_MA_ME_TX, 
		to_char(Obter_Tipo_Atend_Abramge(B.nr_interno_conta)) 
							ie_tipo_atend_esp, 
		B.ie_tipo_atendimento		ie_tipo_atend_tasy 
FROM		W_INTERF_CONTA_CAB B 

union all
 
SELECT   	'ITEM DA CONTA     '	 	DS_REGISTRO, 
    	3	         	   	TP_REGISTRO, 
      	'CSMH' 	 	       	IE_SERVICO, 
      	2       			CD_REGISTRO, 
      	0  	    			CD_ORIGEM, 
      	C.NR_SEQ_PROTOCOLO   		NR_LOTE, 
      	C.NR_INTERNO_CONTA	 		NR_INTERNO_CONTA, 
      	max(C.NR_SEQ_ITEM) 		  	NR_PARCELA, 
      	0  		        	CD_CONVENIO, 
      	' '	     			NM_CONVENIO, 
      	' ' 			   		TP_PRESTADOR, 
      	' '       	  	 	CD_PRESTADOR, 
      	' '         			NM_PRESTADOR, 
      	LOCALTIMESTAMP  	     		DT_GERACAO, 
      	1	          	 	NR_REMESSA, 
      	' '   	         	CD_PLANO, 
     	' ' 			      	CD_PACIENTE,       
     	' '         			CD_AUTORIZACAO, 
     	0       		   	CD_ACOMODACAO, 
      	LOCALTIMESTAMP	         	DT_ENTRADA, 
     	LOCALTIMESTAMP 		     	DT_SAIDA, 
	   	LOCALTIMESTAMP     	  		DT_INICIO_COBRANCA, 
      	LOCALTIMESTAMP	         	DT_FIM_COBRANCA, 
     	0	      	  		IE_TIPO_ATENDIMENTO, 
    	null 			       CD_CID, 
      	' '       	     	CD_PROC_PRINCIPAL, 
		' '					CD_MEDICO_CONVENIO, 
   		' '  		   		NR_CRM, 
      	' '	    	       	UF_CRM, 
		' '					NR_CRM_REQ, 
		' '					UF_CRM_REQ, 
		max(C.NR_SEQ_ITEM) 			NR_SEQ_ITEM, 
      	C.CD_ITEM_CONVENIO			CD_ITEM, 
      	substr(ELIMINA_ACENTUACAO(upper(C.DS_ITEM)),1,50) 
							NM_ITEM, 
	    CASE WHEN W.IE_CARATER_INTER='U' THEN 'S'  ELSE 'N' END 	IE_EMERGENCIA, 
      	CASE WHEN C.pr_hora_extra=0 THEN 'N' WHEN C.pr_hora_extra=1 THEN 'N' WHEN C.pr_hora_extra IS NULL THEN 'N'  ELSE 'S' END  
            				IE_EXTRA, 
      	TRUNC(W.DT_ENTRADA,'dd') 		DT_ITEM, 
    	C.CD_FUNCAO_EXECUTOR 	   	IE_FUNCAO_MEDICO, 
      	SUM(C.QT_ITEM)       	QT_ITEM, 
     	SUM(CASE WHEN(coalesce(C.vl_honorario,0) + coalesce(C.vl_custo_oper,0) + coalesce(C.vl_filme,0))=0 THEN C.vl_total_item  ELSE (coalesce(C.vl_honorario,0) + coalesce(C.vl_custo_oper,0) + coalesce(C.vl_filme,0)) END ) 
							VL_ITEM, 
      	0	   			   	IE_CIRURGIA_MULTIPLA, 
   		0				   	VL_TOTAL_ITEM, 
     	0	   				QT_ITEM_CONTA, 
   		' '					NM_PACIENTE, 
      	' '	   				NR_FATURA, 
   		0					QT_CONTA, 
     	0					VL_TOTAL_LOTE, 
		C.NR_SEQ_PROTOCOLO			NR_SEQ_PROTOCOLO, 
		' '					DS_ESPACO, 
      	1 		       		NR_REGISTRO, 
		' '					IE_MATMED, 
		' '					DS_MA_ME_TX, 
		' '					ie_tipo_atend_esp, 
		W.ie_tipo_atendimento		ie_tipo_atend_tasy 
FROM w_interf_conta_cab w, w_interf_conta_item c
LEFT OUTER JOIN regra_honorario z ON (C.ie_responsavel_credito = Z.cd_regra)
WHERE C.NR_INTERNO_CONTA = W.NR_INTERNO_CONTA  and ((coalesce(Z.ie_entra_conta,'S') = 'S') or (C.nr_seq_proc_pacote = C.nr_seq_item)) and C.ie_tipo_item	= 1 and C.qt_item		<> 0 and C.cd_medico_executor is not null GROUP BY	C.NR_SEQ_PROTOCOLO, 
      	C.NR_INTERNO_CONTA, 
      	C.CD_ITEM_CONVENIO, 
      	substr(ELIMINA_ACENTUACAO(upper(C.DS_ITEM)),1,50), 
      	CASE WHEN W.IE_CARATER_INTER='U' THEN 'S'  ELSE 'N' END , 
      	CASE WHEN C.pr_hora_extra=0 THEN 'N' WHEN C.pr_hora_extra=1 THEN 'N' WHEN C.pr_hora_extra IS NULL THEN 'N'  ELSE 'S' END , 
      	TRUNC(W.DT_ENTRADA,'dd'), 
      	C.CD_FUNCAO_EXECUTOR, 
      	C.NR_SEQ_PROTOCOLO, 
		W.ie_tipo_atendimento 
having		SUM(C.QT_ITEM) <> 0 

union all
 
SELECT   	'ITEM DA CONTA     '	 	DS_REGISTRO, 
	   	3     	 	    	TP_REGISTRO, 
      	'CSMH' 	  			IE_SERVICO, 
	    2    	       	CD_REGISTRO, 
      	0      				CD_ORIGEM, 
	    C.NR_SEQ_PROTOCOLO	   		NR_LOTE, 
      	C.NR_INTERNO_CONTA	   		NR_INTERNO_CONTA, 
	    max(C.NR_SEQ_ITEM)   	   	NR_PARCELA, 
      	0         	  		CD_CONVENIO, 
	    ' '			       	NM_CONVENIO, 
      	' '   	 	    	TP_PRESTADOR, 
	    ' '      			CD_PRESTADOR, 
    	' ' 	 	    	 	NM_PRESTADOR, 
      	LOCALTIMESTAMP	    	    DT_GERACAO, 
   		1 	        		NR_REMESSA, 
      	' '		       	CD_PLANO, 
      	' ' 	    	       	CD_PACIENTE,       
      	' ' 		    	   	CD_AUTORIZACAO, 
   		0       		   	CD_ACOMODACAO, 
      	LOCALTIMESTAMP   	    	  	DT_ENTRADA, 
    	LOCALTIMESTAMP 			   	DT_SAIDA, 
     	LOCALTIMESTAMP         		DT_INICIO_COBRANCA, 
   		LOCALTIMESTAMP 		    	DT_FIM_COBRANCA, 
	    0	  	          	IE_TIPO_ATENDIMENTO, 
    	null  		    	CD_CID, 
	    ' '       	  		CD_PROC_PRINCIPAL, 
		' '					CD_MEDICO_CONVENIO, 
    	' ' 		        	NR_CRM, 
     	' '	    	   		UF_CRM, 
		' '					NR_CRM_REQ, 
		' '					UF_CRM_REQ, 
      	max(C.NR_SEQ_ITEM)      	NR_SEQ_ITEM, 
      	C.CD_ITEM_CONVENIO			CD_ITEM, 
      	substr(ELIMINA_ACENTUACAO(upper(C.DS_ITEM)),1,50) 
							NM_ITEM, 
      	CASE WHEN W.IE_CARATER_INTER='U' THEN 'S'  ELSE 'N' END 	IE_EMERGENCIA, 
      	CASE WHEN C.pr_hora_extra=0 THEN 'N' WHEN C.pr_hora_extra=1 THEN 'N' WHEN C.pr_hora_extra IS NULL THEN 'N'  ELSE 'S' END  
            				IE_EXTRA, 
      	TRUNC(W.DT_ENTRADA,'dd') 		DT_ITEM, 
      	C.CD_FUNCAO_EXECUTOR  	   	IE_FUNCAO_MEDICO, 
      	SUM(C.QT_ITEM)     	   	QT_ITEM, 
      	SUM(C.vl_total_item)   		VL_ITEM, 
      	0  		        	IE_CIRURGIA_MULTIPLA, 
      	0		   			VL_TOTAL_ITEM, 
      	0		   			QT_ITEM_CONTA, 
	   	' '					NM_PACIENTE, 
      	' '   				NR_FATURA, 
      	0					QT_CONTA, 
     	0					VL_TOTAL_LOTE, 
	 	C.NR_SEQ_PROTOCOLO			NR_SEQ_PROTOCOLO, 
		' '					DS_ESPACO, 
      	1        	    	NR_REGISTRO, 
		CASE WHEN C.ie_total_interf=2 THEN '1' WHEN C.ie_total_interf=9 THEN '1' WHEN C.ie_total_interf=10 THEN '1' WHEN C.ie_total_interf=11 THEN '1' WHEN C.ie_total_interf=3 THEN '2'  ELSE ' ' END  
							IE_MAT_MED, 
		CASE WHEN C.ie_total_interf=2 THEN 'MA' WHEN C.ie_total_interf=9 THEN 'MA' WHEN C.ie_total_interf=10 THEN 'MA' WHEN C.ie_total_interf=11 THEN 'MA' WHEN C.ie_total_interf=3 THEN 'ME' WHEN C.ie_total_interf=5 THEN 'TX' WHEN C.ie_total_interf=6 THEN 'TX' WHEN C.ie_total_interf=7 THEN 'TX'  ELSE ' ' END  
							DS_MA_ME_TX, 
		' '					ie_tipo_atend_esp, 
		W.ie_tipo_atendimento		ie_tipo_atend_tasy 
FROM		W_INTERF_CONTA_ITEM C, 
		W_INTERF_CONTA_CAB W 
WHERE 	C.NR_INTERNO_CONTA = W.NR_INTERNO_CONTA 
and (C.ie_tipo_item	= 2 or (C.ie_tipo_item	= 1 and 
		C.cd_medico_executor is null)) 
and		C.vl_total_item	<> 0 
and		C.qt_item		<> 0 
GROUP BY	C.NR_SEQ_PROTOCOLO, 
      	C.NR_INTERNO_CONTA, 
      	C.CD_ITEM_CONVENIO, 
      	substr(ELIMINA_ACENTUACAO(upper(C.DS_ITEM)),1,50), 
      	CASE WHEN W.IE_CARATER_INTER='U' THEN 'S'  ELSE 'N' END , 
      	CASE WHEN C.pr_hora_extra=0 THEN 'N' WHEN C.pr_hora_extra=1 THEN 'N' WHEN C.pr_hora_extra IS NULL THEN 'N'  ELSE 'S' END , 
      	TRUNC(W.DT_ENTRADA,'dd'), 
      	C.CD_FUNCAO_EXECUTOR, 
      	C.NR_SEQ_PROTOCOLO, 
		CASE WHEN C.ie_total_interf=2 THEN '1' WHEN C.ie_total_interf=9 THEN '1' WHEN C.ie_total_interf=10 THEN '1' WHEN C.ie_total_interf=11 THEN '1' WHEN C.ie_total_interf=3 THEN '2'  ELSE ' ' END , 
		CASE WHEN C.ie_total_interf=2 THEN 'MA' WHEN C.ie_total_interf=9 THEN 'MA' WHEN C.ie_total_interf=10 THEN 'MA' WHEN C.ie_total_interf=11 THEN 'MA' WHEN C.ie_total_interf=3 THEN 'ME' WHEN C.ie_total_interf=5 THEN 'TX' WHEN C.ie_total_interf=6 THEN 'TX' WHEN C.ie_total_interf=7 THEN 'TX'  ELSE ' ' END , 
		W.ie_tipo_atendimento 
having		SUM(C.QT_ITEM) <> 0 

union all
 
SELECT   	'TOTAL DA CONTA    ' 		DS_REGISTRO, 
      	4    		       	TP_REGISTRO, 
      	'CSMH' 	        	IE_SERVICO, 
      	3       		   	CD_REGISTRO, 
      	0		      		CD_ORIGEM, 
      	B.NR_SEQ_PROTOCOLO	   		NR_LOTE, 
      	B.NR_INTERNO_CONTA   	 	NR_INTERNO_CONTA, 
      	1 			       	NR_PARCELA, 
      	0   		       	CD_CONVENIO, 
      	' '  			    NM_CONVENIO, 
      	' ' 			      	TP_PRESTADOR, 
      	' '   		      	CD_PRESTADOR, 
      	' '  			       	NM_PRESTADOR, 
      	LOCALTIMESTAMP  			   	DT_GERACAO, 
      	1        		   	NR_REMESSA, 
      	' ' 		  	      	CD_PLANO, 
      	' '       			CD_PACIENTE,       
      	' '            		CD_AUTORIZACAO, 
      	0 		        	CD_ACOMODACAO, 
      	LOCALTIMESTAMP		       	DT_ENTRADA, 
      	LOCALTIMESTAMP        	 	DT_SAIDA, 
      	LOCALTIMESTAMP        		DT_INICIO_COBRANCA, 
      	LOCALTIMESTAMP 	        	DT_FIM_COBRANCA, 
      	0  		          	IE_TIPO_ATENDIMENTO, 
      	null           		CD_CID, 
      	' '            		CD_PROC_PRINCIPAL, 
		' '					CD_MEDICO_CONVENIO, 
      	' ' 		          	NR_CRM, 
      	' '          	  	UF_CRM, 
		' '					NR_CRM_REQ, 
		' '					UF_CRM_REQ, 
      	1 		         	NR_SEQ_ITEM, 
      	' '					CD_ITEM, 
      	' '   				NM_ITEM, 
      	' '   				IE_EMERGENCIA, 
      	' ' 		          	IE_EXTRA, 
      	LOCALTIMESTAMP				DT_ITEM, 
      	0         		   	IE_FUNCAO_MEDICO, 
      	0					QT_ITEM, 
      	0					VL_ITEM, 
      	0					IE_CIRURGIA_MULTIPLA, 
      	sum(CASE WHEN e.cd_medico_executor IS NULL THEN e.vl_total_item  ELSE CASE WHEN(coalesce(e.vl_honorario,0) + coalesce(e.vl_custo_oper,0) + coalesce(e.vl_filme,0))=0 THEN e.vl_total_item  ELSE (coalesce(e.vl_honorario,0) + coalesce(e.vl_custo_oper,0) + coalesce(e.vl_filme,0)) END  END ) VL_TOTAL_ITEM, 
      	0					QT_ITEM_CONTA, 
		substr(ELIMINA_ACENTUACAO(UPPER(B.NM_PACIENTE)),1,40) 
							NM_PACIENTE, 
      	' '	   				NR_FATURA, 
      	0					QT_CONTA, 
      	0					VL_TOTAL_LOTE, 
  		B.NR_SEQ_PROTOCOLO			NR_SEQ_PROTOCOLO, 
		' '					DS_ESPACO, 
      	1         		   	NR_REGISTRO, 
		' '					IE_MATMED, 
		' '					DS_MA_ME_TX, 
		' '					ie_tipo_atend_esp, 
		B.ie_tipo_atendimento		ie_tipo_atend_tasy 
FROM w_interf_conta_cab b, w_interf_conta_item e
LEFT OUTER JOIN estrutura_procedimento_v x ON (E.CD_ITEM = X.CD_PROCEDIMENTO AND E.IE_ORIGEM_PROCED = X.IE_ORIGEM_PROCED)
LEFT OUTER JOIN regra_honorario z ON (E.IE_RESPONSAVEL_CREDITO = Z.cd_regra)
WHERE B.NR_INTERNO_CONTA 	= E.NR_INTERNO_CONTA    and ((coalesce(Z.ie_entra_conta,'S') = 'S') or (e.nr_seq_proc_pacote = e.nr_seq_item)) GROUP BY	B.NR_SEQ_PROTOCOLO, 
     	B.NR_INTERNO_CONTA, 
		substr(ELIMINA_ACENTUACAO(UPPER(B.NM_PACIENTE)),1,40), 
		B.ie_tipo_atendimento 

union all
 
SELECT   	'FIM DE LOTE      '		DS_REGISTRO, 
      	5    		    	TP_REGISTRO, 
      	'CSMH'   				IE_SERVICO, 
      	4       			CD_REGISTRO, 
      	0			      	CD_ORIGEM, 
      	B.NR_SEQ_PROTOCOLO		   	NR_LOTE, 
      	99999999		   		NR_INTERNO_CONTA, 
      	99   			   	NR_PARCELA, 
      	0   			   	CD_CONVENIO, 
      	' '   			   	NM_CONVENIO, 
      	' '   			    TP_PRESTADOR, 
      	' '   			    CD_PRESTADOR, 
      	' '   			    NM_PRESTADOR, 
      	LOCALTIMESTAMP   			    DT_GERACAO, 
      	1    			    NR_REMESSA, 
      	' '     				CD_PLANO, 
      	' '    				CD_PACIENTE,       
      	' '     				CD_AUTORIZACAO, 
      	0      				CD_ACOMODACAO, 
      	LOCALTIMESTAMP  			   	DT_ENTRADA, 
      	LOCALTIMESTAMP         		DT_SAIDA, 
      	LOCALTIMESTAMP  			   	DT_INICIO_COBRANCA, 
      	LOCALTIMESTAMP  			   	DT_FIM_COBRANCA, 
      	0       			IE_TIPO_ATENDIMENTO, 
      	null    				CD_CID, 
      	' '           		CD_PROC_PRINCIPAL, 
		' '					CD_MEDICO_CONVENIO, 
      	' '    			   	NR_CRM, 
      	' '   			   	UF_CRM, 
		' '					NR_CRM_REQ, 
		' '					UF_CRM_REQ, 
      	1            		NR_SEQ_ITEM, 
      	' '					CD_ITEM, 
      	' '        			NM_ITEM, 
      	' '   				IE_EMERGENCIA, 
      	' '      			IE_EXTRA, 
      	LOCALTIMESTAMP				DT_ITEM, 
      	0         			IE_FUNCAO_MEDICO, 
      	0					QT_ITEM, 
      	0					VL_ITEM, 
      	0					IE_CIRURGIA_MULTIPLA, 
      	0		   			VL_TOTAL_ITEM, 
      	0	   				QT_ITEM_CONTA, 
		' '					NM_PACIENTE, 
      	' '	   				NR_FATURA, 
      	count(distinct e.nr_interno_conta)	QT_CONTA, 
      	sum(CASE WHEN e.cd_medico_executor IS NULL THEN e.vl_total_item  ELSE CASE WHEN(coalesce(e.vl_honorario,0) + coalesce(e.vl_custo_oper,0) + coalesce(e.vl_filme,0))=0 THEN e.vl_total_item  ELSE (coalesce(e.vl_honorario,0) + coalesce(e.vl_custo_oper,0) + coalesce(e.vl_filme,0)) END  END ) VL_TOTAL_ITEM, 
		B.NR_SEQ_PROTOCOLO			NR_SEQ_PROTOCOLO, 
		' '					DS_ESPACO, 
     	1       			NR_REGISTRO, 
		' '					IE_MATMED, 
		' '					DS_MA_ME_TX, 
		' '					ie_tipo_atend_esp, 
		0					ie_tipo_atend_tasy 
FROM w_interf_conta_cab b, w_interf_conta_item e
LEFT OUTER JOIN estrutura_procedimento_v x ON (E.CD_ITEM = X.CD_PROCEDIMENTO AND E.IE_ORIGEM_PROCED = X.IE_ORIGEM_PROCED)
LEFT OUTER JOIN regra_honorario z ON (e.ie_responsavel_credito = Z.cd_regra)
WHERE B.NR_INTERNO_CONTA 	= E.NR_INTERNO_CONTA    and ((coalesce(Z.ie_entra_conta,'S') = 'S') or (e.nr_seq_proc_pacote = e.nr_seq_item)) GROUP BY	B.NR_SEQ_PROTOCOLO 

union all
 
SELECT 	'TRAILLER       ' 		DS_REGISTRO, 
      	6        			TP_REGISTRO, 
      	'CSMH'  				IE_SERVICO, 
      	9   			      	CD_REGISTRO, 
      	(coalesce(f.CD_INTERNO,0))::numeric 	CD_ORIGEM, 
      	99999999		   		NR_LOTE, 
      	99999999	   			NR_INTERNO_CONTA, 
      	99    		      	NR_PARCELA, 
      	0 	           	CD_CONVENIO, 
      	' '       			NM_CONVENIO, 
      	' ' 			      	TP_PRESTADOR, 
      	' '  			   	CD_PRESTADOR, 
      	' '  			   	NM_PRESTADOR, 
      	LOCALTIMESTAMP     			DT_GERACAO, 
      	1    			   	NR_REMESSA, 
      	' '   			   	CD_PLANO, 
      	' '      			CD_PACIENTE,       
      	' '     				CD_AUTORIZACAO, 
      	0        			CD_ACOMODACAO, 
      	LOCALTIMESTAMP       			DT_ENTRADA, 
      	LOCALTIMESTAMP         		DT_SAIDA, 
      	LOCALTIMESTAMP         		DT_INICIO_COBRANCA, 
		LOCALTIMESTAMP    			DT_FIM_COBRANCA, 
      	0     			   	IE_TIPO_ATENDIMENTO, 
      	null 			       	CD_CID, 
      	' '   			   	CD_PROC_PRINCIPAL, 
		' '					CD_MEDICO_CONVENIO, 
      	' '    				NR_CRM, 
      	' '    				UF_CRM, 
		' '					NR_CRM_REQ, 
		' '					UF_CRM_REQ, 
      	1            		NR_SEQ_ITEM, 
      	' '					CD_ITEM, 
      	' '  			   	NM_ITEM, 
      	' '   				IE_EMERGENCIA, 
      	' '   		    	IE_EXTRA, 
      	LOCALTIMESTAMP				DT_ITEM, 
      	0   			   	IE_FUNCAO_MEDICO, 
      	0					QT_ITEM, 
      	0					VL_ITEM, 
      	0					IE_CIRURGIA_MULTIPLA, 
      	0				   	VL_TOTAL_ITEM, 
      	0	   				QT_ITEM_CONTA, 
		' '					NM_PACIENTE, 
      	' '			   		NR_FATURA, 
      	count(distinct e.nr_interno_conta)	QT_CONTA, 
      	sum(CASE WHEN e.cd_medico_executor IS NULL THEN e.vl_total_item  ELSE CASE WHEN(coalesce(e.vl_honorario,0) + coalesce(e.vl_custo_oper,0) + coalesce(e.vl_filme,0))=0 THEN e.vl_total_item  ELSE (coalesce(e.vl_honorario,0) + coalesce(e.vl_custo_oper,0) + coalesce(e.vl_filme,0)) END  END ) VL_TOTAL_ITEM, 
		B.NR_SEQ_PROTOCOLO			NR_SEQ_PROTOCOLO, 
		' '					DS_ESPACO, 
      	1         		    NR_REGISTRO, 
		' '					IE_MATMED, 
		' '					DS_MA_ME_TX, 
		' '					ie_tipo_atend_esp, 
		9					ie_tipo_atend_tasy 
FROM w_interf_conta_header f, w_interf_conta_cab b, w_interf_conta_item e
LEFT OUTER JOIN estrutura_procedimento_v x ON (E.CD_ITEM = X.CD_PROCEDIMENTO AND E.IE_ORIGEM_PROCED = X.IE_ORIGEM_PROCED)
LEFT OUTER JOIN regra_honorario z ON (E.IE_RESPONSAVEL_CREDITO = Z.cd_regra)
WHERE B.NR_INTERNO_CONTA 	= E.NR_INTERNO_CONTA and B.nr_seq_protocolo	= f.nr_seq_protocolo    and ((coalesce(Z.ie_entra_conta,'S') = 'S') or (e.nr_seq_proc_pacote = e.nr_seq_item)) GROUP BY	(coalesce(f.CD_INTERNO,0))::numeric , 
		B.NR_SEQ_PROTOCOLO;
