-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';

CREATE OR REPLACE VIEW unimed_hdh_v (tp_registro, ie_tipo_prestador, cd_prestador, nm_prestador, nr_lote, dt_geracao, cd_tipo_documento, nr_documento, nr_cep, cd_tipo_prestador, nr_crm, dt_inicio_internacao, dt_alta, ie_padrao_internacao, cd_unimed_usuario, cd_contrato_usuario, cd_familia_usuario, ie_dependencia_usuario, ie_digito_ver_usuario, dt_exec_servico, hr_exec_servico, cd_cid, ie_detalhe_cid, cd_dig_verif_cid, cd_seq_doc_servico, cd_amb_lpm, cd_dig_verif_servico, qt_servico_executado, ie_porte_cirurgico, ie_partic_executante, cd_local_atendimento, vl_servico, cd_moeda_servico, vl_filme, cd_moeda_filme, nr_autorizacao, cd_fator_plano, ie_tipo_prest_executante, cd_prest_executante, ie_situacao_guia, nm_usuario, hr_saida_paciente, nr_seq_protocolo, nr_atendimento, nr_interno_conta, qt_doc_enviados, qt_serv_relacionados, qt_total_servicos_real, qt_total_cobrado_ch, qt_total_filme, cd_campo_quebra) AS select	0					tp_registro,
		CASE WHEN a.ie_tipo_protocolo=21 THEN 2 WHEN a.ie_tipo_protocolo=22 THEN 2  ELSE 4 END
							ie_tipo_prestador,
		101					cd_prestador,
		substr(a.nm_hospital,1,40)	nm_prestador,
		a.nr_seq_protocolo		nr_lote,
		a.dt_remessa			dt_geracao,
		0					cd_tipo_documento,
		''					nr_documento,
		''					nr_cep,
		1					cd_tipo_prestador,
		''					nr_crm,
		LOCALTIMESTAMP				dt_inicio_internacao,
		LOCALTIMESTAMP				dt_alta,
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
		0					cd_moeda_servico,
		0					vl_filme,
		0					cd_moeda_filme,
		''					nr_autorizacao,
		0					cd_fator_plano,
		0					ie_tipo_prest_executante,
		0					cd_prest_executante,
		''					ie_situacao_guia,
		''					nm_usuario,
		''					hr_saida_paciente,
		a.nr_seq_protocolo		nr_seq_protocolo,
		0					nr_atendimento,
		0					nr_interno_conta,
		0					qt_doc_enviados,
		0					qt_serv_relacionados,
		0					qt_total_servicos_real,
		0					qt_total_cobrado_ch,
		0					qt_total_filme,
		0					cd_campo_quebra
FROM  	w_interf_conta_header a

union all

select	a.TP_REGISTRO,a.IE_TIPO_PRESTADOR,a.CD_PRESTADOR,a.NM_PRESTADOR,a.NR_LOTE,a.DT_GERACAO,a.CD_TIPO_DOCUMENTO,a.NR_DOCUMENTO,a.NR_CEP,a.CD_TIPO_PRESTADOR,a.NR_CRM,a.DT_INICIO_INTERNACAO,a.DT_ALTA,a.IE_PADRAO_INTERNACAO,a.CD_UNIMED_USUARIO,a.CD_CONTRATO_USUARIO,a.CD_FAMILIA_USUARIO,a.IE_DEPENDENCIA_USUARIO,a.IE_DIGITO_VER_USUARIO,a.DT_EXEC_SERVICO,a.HR_EXEC_SERVICO,a.CD_CID,a.IE_DETALHE_CID,a.CD_DIG_VERIF_CID,a.CD_SEQ_DOC_SERVICO,a.CD_AMB_LPM,a.CD_DIG_VERIF_SERVICO,a.QT_SERVICO_EXECUTADO,a.IE_PORTE_CIRURGICO,a.IE_PARTIC_EXECUTANTE,a.CD_LOCAL_ATENDIMENTO,a.VL_SERVICO,a.CD_MOEDA_SERVICO,a.VL_FILME,a.CD_MOEDA_FILME,a.NR_AUTORIZACAO,a.CD_FATOR_PLANO,a.IE_TIPO_PREST_EXECUTANTE,a.CD_PREST_EXECUTANTE,a.IE_SITUACAO_GUIA,a.NM_USUARIO,a.HR_SAIDA_PACIENTE,a.NR_SEQ_PROTOCOLO,a.NR_ATENDIMENTO,a.NR_INTERNO_CONTA,a.QT_DOC_ENVIADOS,a.QT_SERV_RELACIONADOS,a.QT_TOTAL_SERVICOS_REAL,a.QT_TOTAL_COBRADO_CH,a.QT_TOTAL_FILME,a.CD_CAMPO_QUEBRA
from (select	1		tp_registro,
		CASE WHEN a.ie_tipo_atendimento=1 THEN 4 WHEN a.ie_tipo_atendimento=3 THEN 6  ELSE CASE WHEN b.cd_setor_atendimento=15 THEN 3 WHEN b.cd_setor_atendimento=13 THEN 3 WHEN b.cd_setor_atendimento=21 THEN 3 WHEN b.cd_setor_atendimento=22 THEN 3 WHEN b.cd_setor_atendimento=12 THEN 3 WHEN b.cd_setor_atendimento=11 THEN 3 WHEN b.cd_setor_atendimento=24 THEN 3 WHEN b.cd_setor_atendimento=23 THEN 3 WHEN b.cd_setor_atendimento=49 THEN 7 WHEN b.cd_setor_atendimento=14 THEN 14 WHEN b.cd_setor_atendimento=19 THEN 16 WHEN b.cd_setor_atendimento=16 THEN 16 WHEN b.cd_setor_atendimento=17 THEN 16 WHEN b.cd_setor_atendimento=18 THEN 17 WHEN b.cd_setor_atendimento=20 THEN 20 WHEN b.cd_setor_atendimento=48 THEN 2 WHEN b.cd_setor_atendimento=51 THEN 2  ELSE 9 END  END 
							ie_tipo_prestador,
		CASE WHEN b.cd_setor_atendimento=49 THEN 120 WHEN b.cd_setor_atendimento=14 THEN 1  ELSE CASE WHEN b.cd_item=10014 THEN 8889  ELSE 101 END  END 
							cd_prestador,
		''					nm_prestador,
		0					nr_lote,
		LOCALTIMESTAMP				dt_geracao,
		CASE WHEN b.cd_item=10014 THEN 6  ELSE CASE WHEN a.ie_tipo_atendimento=1 THEN 2 WHEN a.ie_tipo_atendimento=3 THEN 16 WHEN a.ie_tipo_atendimento=7 THEN 1 WHEN a.ie_tipo_atendimento=8 THEN 1  ELSE CASE WHEN b.cd_setor_atendimento=48 THEN 10 WHEN b.cd_setor_atendimento=51 THEN 10  ELSE 3 END  END  END 
							cd_tipo_documento,
		coalesce(c.cd_autorizacao,a.nr_doc_convenio)
							nr_documento,
		''					nr_cep,
		1					cd_tipo_prestador,
		a.nr_crm_medico_resp		nr_crm,
		a.dt_entrada			dt_inicio_internacao,
		a.dt_alta				dt_alta,
		a.cd_tipo_acomodacao		ie_padrao_internacao,
		substr(a.cd_usuario_convenio,1,3)
							cd_unimed_usuario,
		substr(a.cd_usuario_convenio,4,4)
							cd_contrato_usuario,
		substr(a.cd_usuario_convenio,8,6)
							cd_familia_usuario,
		substr(a.cd_usuario_convenio,14,2)
							ie_dependencia_usuario,
		substr(a.cd_usuario_convenio,16,1)
							ie_digito_ver_usuario,
		to_char(b.dt_item,'ddmmyyyy')	dt_exec_servico,
		to_char(b.dt_item,'hh24mi')	hr_exec_servico,
		a.cd_cid_principal		cd_cid,
		''					ie_detalhe_cid,
		''					cd_dig_verif_cid,
		0					cd_seq_doc_servico,
		CASE WHEN b.cd_item_convenio='10014' THEN '1001' WHEN b.cd_item_convenio='10022' THEN '1002'  ELSE substr(b.cd_item_convenio,1,7) END  cd_amb_lpm,
		'0' cd_dig_verif_servico,
		sum(b.qt_item)				qt_servico_executado,
		to_char(b.nr_porte_anestesico)	ie_porte_cirurgico,
		CASE WHEN Obter_Se_Negativo(vl_total_item)='N' THEN  to_char(b.cd_funcao_executor)  ELSE null END  ie_partic_executante,
		CASE WHEN b.cd_setor_atendimento=48 THEN 2 WHEN b.cd_setor_atendimento=51 THEN 2  ELSE CASE WHEN a.ie_tipo_atendimento=3 THEN 6  ELSE 4 END  END 
							cd_local_atendimento,
		sum(b.vl_total_item - coalesce(b.vl_filme,0)) vl_servico,
		6					cd_moeda_servico,
		sum(b.vl_filme)				vl_filme,
		6					cd_moeda_filme,
		coalesce(substr(Obter_Guias_Conta(b.nr_interno_conta),1,20),'0') nr_autorizacao,
		0					cd_fator_plano,
		CASE WHEN b.cd_item_convenio='10014' THEN 15 WHEN b.cd_item_convenio='0001007' THEN 15 WHEN b.cd_item_convenio='00010071' THEN 15  ELSE CASE WHEN a.ie_tipo_atendimento=3 THEN 6  ELSE CASE WHEN b.cd_setor_atendimento=49 THEN 7 WHEN b.cd_setor_atendimento=14 THEN 14 WHEN b.cd_setor_atendimento=15 THEN 3 WHEN b.cd_setor_atendimento=13 THEN 3 WHEN b.cd_setor_atendimento=21 THEN 3 WHEN b.cd_setor_atendimento=22 THEN 3 WHEN b.cd_setor_atendimento=12 THEN 3 WHEN b.cd_setor_atendimento=11 THEN 3 WHEN b.cd_setor_atendimento=24 THEN 3 WHEN b.cd_setor_atendimento=23 THEN 3 WHEN b.cd_setor_atendimento=48 THEN 2 WHEN b.cd_setor_atendimento=51 THEN 2 WHEN b.cd_setor_atendimento=19 THEN 16 WHEN b.cd_setor_atendimento=16 THEN 16 WHEN b.cd_setor_atendimento=17 THEN 16 WHEN b.cd_setor_atendimento=65 THEN 17 WHEN b.cd_setor_atendimento=20 THEN 20  ELSE CASE WHEN a.ie_tipo_atendimento=1 THEN 4 WHEN a.ie_tipo_atendimento=8 THEN 9  ELSE 6 END  END  END  END  ie_tipo_prest_executante,
		CASE WHEN b.cd_item_convenio='10014' THEN 8889 WHEN b.cd_item_convenio='0001007' THEN 8889 WHEN b.cd_item_convenio='00010071' THEN 8889  ELSE CASE WHEN a.ie_tipo_atendimento=3 THEN 101  ELSE CASE WHEN b.cd_setor_atendimento=49 THEN 120 WHEN b.cd_setor_atendimento=14 THEN 1  ELSE 101 END  END  END  cd_prest_executante,
		''					ie_situacao_guia,
		substr(a.nm_paciente,1,25)	nm_usuario,
		to_char(a.dt_alta,'hh24mi')	hr_saida_paciente,
		a.nr_seq_protocolo		nr_seq_protocolo,
		a.nr_atendimento			nr_atendimento,
		a.nr_interno_conta		nr_interno_conta,
		0					qt_doc_enviados,
		0					qt_serv_relacionados,
		0					qt_total_servicos_real,
		0					qt_total_cobrado_ch,
		0					qt_total_filme,
		a.nr_interno_conta 		cd_campo_quebra
FROM w_interf_conta_cab a, w_interf_conta_item b
LEFT OUTER JOIN w_interf_conta_autor c ON (b.nr_interno_conta = c.nr_interno_conta)
WHERE b.nr_interno_conta		= a.nr_interno_conta  and b.ie_tipo_item			= 1 and coalesce(c.nr_sequencia,0)		=
		(select coalesce(min(x.nr_sequencia),0)
		from	w_interf_conta_autor x
		where	a.nr_interno_conta	= x.nr_interno_conta) /*	Marcus inseriu a ultima condição em 12/07/2002 - Rosane */

 group by 	CASE WHEN a.ie_tipo_atendimento=1 THEN 4 WHEN a.ie_tipo_atendimento=3 THEN 6  ELSE CASE WHEN b.cd_setor_atendimento=15 THEN 3 WHEN b.cd_setor_atendimento=13 THEN 3 WHEN b.cd_setor_atendimento=21 THEN 3 WHEN b.cd_setor_atendimento=22 THEN 3 WHEN b.cd_setor_atendimento=12 THEN 3 WHEN b.cd_setor_atendimento=11 THEN 3 WHEN b.cd_setor_atendimento=24 THEN 3 WHEN b.cd_setor_atendimento=23 THEN 3 WHEN b.cd_setor_atendimento=49 THEN 7 WHEN b.cd_setor_atendimento=14 THEN 14 WHEN b.cd_setor_atendimento=19 THEN 16 WHEN b.cd_setor_atendimento=16 THEN 16 WHEN b.cd_setor_atendimento=17 THEN 16 WHEN b.cd_setor_atendimento=18 THEN 17 WHEN b.cd_setor_atendimento=20 THEN 20 WHEN b.cd_setor_atendimento=48 THEN 2 WHEN b.cd_setor_atendimento=51 THEN 2  ELSE 9 END  END ,
		CASE WHEN b.cd_setor_atendimento=49 THEN 120 WHEN b.cd_setor_atendimento=14 THEN 1  ELSE CASE WHEN b.cd_item=10014 THEN 8889  ELSE 101 END  END ,
		CASE WHEN b.cd_item=10014 THEN 6  ELSE CASE WHEN a.ie_tipo_atendimento=1 THEN 2 WHEN a.ie_tipo_atendimento=3 THEN 16 WHEN a.ie_tipo_atendimento=7 THEN 1 WHEN a.ie_tipo_atendimento=8 THEN 1  ELSE CASE WHEN b.cd_setor_atendimento=48 THEN 10 WHEN b.cd_setor_atendimento=51 THEN 10  ELSE 3 END  END  END ,
		coalesce(c.cd_autorizacao,a.nr_doc_convenio),
		a.nr_crm_medico_resp,
		a.dt_entrada,
		a.dt_alta,
		a.cd_tipo_acomodacao,
		substr(a.cd_usuario_convenio,1,3),
		substr(a.cd_usuario_convenio,4,4),
		substr(a.cd_usuario_convenio,8,6),
		substr(a.cd_usuario_convenio,14,2),
		substr(a.cd_usuario_convenio,16,1),
		to_char(b.dt_item,'ddmmyyyy'),
		to_char(b.dt_item,'hh24mi'),
		a.cd_cid_principal,
		CASE WHEN b.cd_item_convenio='10014' THEN '1001' WHEN b.cd_item_convenio='10022' THEN '1002'  ELSE substr(b.cd_item_convenio,1,7) END ,
		to_char(b.nr_porte_anestesico),
		CASE WHEN Obter_Se_Negativo(vl_total_item)='N' THEN  to_char(b.cd_funcao_executor)  ELSE null END  ,
		CASE WHEN b.cd_setor_atendimento=48 THEN 2 WHEN b.cd_setor_atendimento=51 THEN 2  ELSE CASE WHEN a.ie_tipo_atendimento=3 THEN 6  ELSE 4 END  END ,
		coalesce(substr(Obter_Guias_Conta(b.nr_interno_conta),1,20),'0'),
		CASE WHEN b.cd_item_convenio='10014' THEN 15 WHEN b.cd_item_convenio='0001007' THEN 15 WHEN b.cd_item_convenio='00010071' THEN 15  ELSE CASE WHEN a.ie_tipo_atendimento=3 THEN 6  ELSE CASE WHEN b.cd_setor_atendimento=49 THEN 7 WHEN b.cd_setor_atendimento=14 THEN 14 WHEN b.cd_setor_atendimento=15 THEN 3 WHEN b.cd_setor_atendimento=13 THEN 3 WHEN b.cd_setor_atendimento=21 THEN 3 WHEN b.cd_setor_atendimento=22 THEN 3 WHEN b.cd_setor_atendimento=12 THEN 3 WHEN b.cd_setor_atendimento=11 THEN 3 WHEN b.cd_setor_atendimento=24 THEN 3 WHEN b.cd_setor_atendimento=23 THEN 3 WHEN b.cd_setor_atendimento=48 THEN 2 WHEN b.cd_setor_atendimento=51 THEN 2 WHEN b.cd_setor_atendimento=19 THEN 16 WHEN b.cd_setor_atendimento=16 THEN 16 WHEN b.cd_setor_atendimento=17 THEN 16 WHEN b.cd_setor_atendimento=65 THEN 17 WHEN b.cd_setor_atendimento=20 THEN 20  ELSE CASE WHEN a.ie_tipo_atendimento=1 THEN 4 WHEN a.ie_tipo_atendimento=8 THEN 9  ELSE 6 END  END  END  END ,
		CASE WHEN b.cd_item_convenio='10014' THEN 8889 WHEN b.cd_item_convenio='0001007' THEN 8889 WHEN b.cd_item_convenio='00010071' THEN 8889  ELSE CASE WHEN a.ie_tipo_atendimento=3 THEN 101  ELSE CASE WHEN b.cd_setor_atendimento=49 THEN 120 WHEN b.cd_setor_atendimento=14 THEN 1  ELSE 101 END  END  END ,
		substr(a.nm_paciente,1,25),
		to_char(a.dt_alta,'hh24mi'),
		a.nr_seq_protocolo,
		a.nr_atendimento,
		a.nr_interno_conta) a
where a.vl_servico <> 0

union all

select 1					tp_registro,
		CASE WHEN a.ie_tipo_atendimento=1 THEN 4 WHEN a.ie_tipo_atendimento=3 THEN 6  ELSE CASE WHEN b.cd_setor_atendimento=15 THEN 3 WHEN b.cd_setor_atendimento=13 THEN 3 WHEN b.cd_setor_atendimento=21 THEN 3 WHEN b.cd_setor_atendimento=22 THEN 3 WHEN b.cd_setor_atendimento=12 THEN 3 WHEN b.cd_setor_atendimento=11 THEN 3 WHEN b.cd_setor_atendimento=24 THEN 3 WHEN b.cd_setor_atendimento=23 THEN 3 WHEN b.cd_setor_atendimento=49 THEN 7 WHEN b.cd_setor_atendimento=14 THEN 14 WHEN b.cd_setor_atendimento=19 THEN 16 WHEN b.cd_setor_atendimento=16 THEN 16 WHEN b.cd_setor_atendimento=17 THEN 16 WHEN b.cd_setor_atendimento=18 THEN 17 WHEN b.cd_setor_atendimento=20 THEN 20 WHEN b.cd_setor_atendimento=48 THEN 2 WHEN b.cd_setor_atendimento=51 THEN 2  ELSE 9 END  END 
							ie_tipo_prestador,
		CASE WHEN b.cd_setor_atendimento=49 THEN 120 WHEN b.cd_setor_atendimento=14 THEN 1  ELSE CASE WHEN b.cd_item=10014 THEN 8889  ELSE 101 END  END 
							cd_prestador,
		''					nm_prestador,
		0					nr_lote,
		LOCALTIMESTAMP				dt_geracao,
		CASE WHEN b.cd_item=10014 THEN 6  ELSE CASE WHEN a.ie_tipo_atendimento=1 THEN 2 WHEN a.ie_tipo_atendimento=3 THEN 16 WHEN a.ie_tipo_atendimento=7 THEN 1 WHEN a.ie_tipo_atendimento=8 THEN 1  ELSE CASE WHEN b.cd_setor_atendimento=48 THEN 10 WHEN b.cd_setor_atendimento=51 THEN 10  ELSE 3 END  END  END 
							cd_tipo_documento,
		coalesce(c.cd_autorizacao,a.nr_doc_convenio)
							nr_documento,
		''					nr_cep,
		1					cd_tipo_prestador,
		a.nr_crm_medico_resp		nr_crm,
		a.dt_entrada			dt_inicio_internacao,
		a.dt_alta				dt_alta,
		a.cd_tipo_acomodacao		ie_padrao_internacao,
		substr(a.cd_usuario_convenio,1,3)
							cd_unimed_usuario,
		substr(a.cd_usuario_convenio,4,4)
							cd_contrato_usuario,
		substr(a.cd_usuario_convenio,8,6)
							cd_familia_usuario,
		substr(a.cd_usuario_convenio,14,2)
							ie_dependencia_usuario,
		substr(a.cd_usuario_convenio,16,1)
							ie_digito_ver_usuario,
		to_char(a.dt_entrada,'ddmmyyyy')
							dt_exec_servico,
		to_char(a.dt_entrada,'hh24mi')
							hr_exec_servico,
		null					cd_cid,
		''					ie_detalhe_cid,
		''					cd_dig_verif_cid,
		0					cd_seq_doc_servico,
		CASE WHEN b.cd_classif_setor=2 THEN 			CASE WHEN b.ie_tipo_item=2 THEN 				CASE WHEN b.cd_grupo_gasto='2' THEN '8007121'  ELSE '8007111' END 					  ELSE substr(b.cd_item_convenio,1,7) END   ELSE substr(b.cd_item_convenio,1,7) END  cd_amb_lpm,
		'0'					cd_dig_verif_servico,
		1					qt_servico_executado,
		''					ie_porte_cirurgico,
		''					ie_partic_executante,
		CASE WHEN b.cd_setor_atendimento=48 THEN 2 WHEN b.cd_setor_atendimento=51 THEN 2  ELSE CASE WHEN a.ie_tipo_atendimento=3 THEN 6  ELSE 4 END  END 
							cd_local_atendimento,
		sum(b.vl_total_item)		vl_servico,
		6					cd_moeda_servico,
		0					vl_filme,
		6					cd_moeda_filme,
		coalesce(substr(Obter_Guias_Conta(b.nr_interno_conta),1,20),'0') nr_autorizacao,
		0					cd_fator_plano,
		CASE WHEN b.cd_item_convenio='10014' THEN 15 WHEN b.cd_item_convenio='0001007' THEN 15 WHEN b.cd_item_convenio='00010071' THEN 15  ELSE CASE WHEN a.ie_tipo_atendimento=3 THEN 6  ELSE CASE WHEN b.cd_setor_atendimento=49 THEN 7 WHEN b.cd_setor_atendimento=14 THEN 14 WHEN b.cd_setor_atendimento=15 THEN 3 WHEN b.cd_setor_atendimento=13 THEN 3 WHEN b.cd_setor_atendimento=21 THEN 3 WHEN b.cd_setor_atendimento=22 THEN 3 WHEN b.cd_setor_atendimento=12 THEN 3 WHEN b.cd_setor_atendimento=11 THEN 3 WHEN b.cd_setor_atendimento=24 THEN 3 WHEN b.cd_setor_atendimento=23 THEN 3 WHEN b.cd_setor_atendimento=48 THEN 2 WHEN b.cd_setor_atendimento=51 THEN 2 WHEN b.cd_setor_atendimento=19 THEN 16 WHEN b.cd_setor_atendimento=16 THEN 16 WHEN b.cd_setor_atendimento=17 THEN 16 WHEN b.cd_setor_atendimento=65 THEN 17 WHEN b.cd_setor_atendimento=20 THEN 20  ELSE CASE WHEN a.ie_tipo_atendimento=1 THEN 4 WHEN a.ie_tipo_atendimento=8 THEN 9  ELSE 6 END  END  END  END  ie_tipo_prest_executante,
		CASE WHEN b.cd_item_convenio='10014' THEN 8889 WHEN b.cd_item_convenio='0001007' THEN 8889 WHEN b.cd_item_convenio='00010071' THEN 8889  ELSE CASE WHEN a.ie_tipo_atendimento=3 THEN 101  ELSE CASE WHEN b.cd_setor_atendimento=49 THEN 120 WHEN b.cd_setor_atendimento=14 THEN 1  ELSE 101 END  END  END  cd_prest_executante,
		''					ie_situacao_guia,
		substr(a.nm_paciente,1,25)	nm_usuario,
		to_char(a.dt_alta,'hh24mi')	hr_saida_paciente,
		a.nr_seq_protocolo		nr_seq_protocolo,
		a.nr_atendimento			nr_atendimento,
		a.nr_interno_conta		nr_interno_conta,
		0					qt_doc_enviados,
		0					qt_serv_relacionados,
		0					qt_total_servicos_real,
		0					qt_total_cobrado_ch,
		0					qt_total_filme,
		a.nr_interno_conta		cd_campo_quebra
FROM w_interf_conta_cab a, w_interf_conta_item b
LEFT OUTER JOIN w_interf_conta_autor c ON (b.nr_interno_conta = c.nr_interno_conta)
WHERE b.nr_interno_conta		= a.nr_interno_conta  and b.ie_tipo_item			= 2 and coalesce(c.nr_sequencia,0)		=
		(select coalesce(min(x.nr_sequencia),0)
		from	w_interf_conta_autor x
		where	a.nr_interno_conta	= x.nr_interno_conta) /*	Marcus inseriu a ultima condição em 12/07/2002 - Rosane */

 group by
		CASE WHEN a.ie_tipo_atendimento=1 THEN 4 WHEN a.ie_tipo_atendimento=3 THEN 6  ELSE CASE WHEN b.cd_setor_atendimento=15 THEN 3 WHEN b.cd_setor_atendimento=13 THEN 3 WHEN b.cd_setor_atendimento=21 THEN 3 WHEN b.cd_setor_atendimento=22 THEN 3 WHEN b.cd_setor_atendimento=12 THEN 3 WHEN b.cd_setor_atendimento=11 THEN 3 WHEN b.cd_setor_atendimento=24 THEN 3 WHEN b.cd_setor_atendimento=23 THEN 3 WHEN b.cd_setor_atendimento=49 THEN 7 WHEN b.cd_setor_atendimento=14 THEN 14 WHEN b.cd_setor_atendimento=19 THEN 16 WHEN b.cd_setor_atendimento=16 THEN 16 WHEN b.cd_setor_atendimento=17 THEN 16 WHEN b.cd_setor_atendimento=18 THEN 17 WHEN b.cd_setor_atendimento=20 THEN 20 WHEN b.cd_setor_atendimento=48 THEN 2 WHEN b.cd_setor_atendimento=51 THEN 2  ELSE 9 END  END ,
		CASE WHEN b.cd_setor_atendimento=49 THEN 120 WHEN b.cd_setor_atendimento=14 THEN 1  ELSE CASE WHEN b.cd_item=10014 THEN 8889  ELSE 101 END  END ,
		CASE WHEN b.cd_item=10014 THEN 6  ELSE CASE WHEN a.ie_tipo_atendimento=1 THEN 2 WHEN a.ie_tipo_atendimento=3 THEN 16 WHEN a.ie_tipo_atendimento=7 THEN 1 WHEN a.ie_tipo_atendimento=8 THEN 1  ELSE CASE WHEN b.cd_setor_atendimento=48 THEN 10 WHEN b.cd_setor_atendimento=51 THEN 10  ELSE 3 END  END  END ,
		coalesce(c.cd_autorizacao,a.nr_doc_convenio),
		a.nr_crm_medico_resp,
		a.dt_entrada,
		a.dt_alta,
		a.cd_tipo_acomodacao,
		substr(a.cd_usuario_convenio,1,3),
		substr(a.cd_usuario_convenio,4,4),
		substr(a.cd_usuario_convenio,8,6),
		substr(a.cd_usuario_convenio,14,2),
		substr(a.cd_usuario_convenio,16,1),
		to_char(a.dt_entrada,'ddmmyyyy'),
		to_char(a.dt_entrada,'hh24mi'),
		CASE WHEN b.cd_classif_setor=2 THEN 			CASE WHEN b.ie_tipo_item=2 THEN 				CASE WHEN b.cd_grupo_gasto='2' THEN '8007121'  ELSE '8007111' END 					  ELSE substr(b.cd_item_convenio,1,7) END   ELSE substr(b.cd_item_convenio,1,7) END ,
		'0',
		CASE WHEN b.cd_setor_atendimento=48 THEN 2 WHEN b.cd_setor_atendimento=51 THEN 2  ELSE CASE WHEN a.ie_tipo_atendimento=3 THEN 6  ELSE 4 END  END ,
		c.cd_senha,
		a.cd_tipo_acomodacao,
		coalesce(substr(Obter_Guias_Conta(b.nr_interno_conta),1,20),'0'),
		CASE WHEN b.cd_item_convenio='10014' THEN 15 WHEN b.cd_item_convenio='0001007' THEN 15 WHEN b.cd_item_convenio='00010071' THEN 15  ELSE CASE WHEN a.ie_tipo_atendimento=3 THEN 6  ELSE CASE WHEN b.cd_setor_atendimento=49 THEN 7 WHEN b.cd_setor_atendimento=14 THEN 14 WHEN b.cd_setor_atendimento=15 THEN 3 WHEN b.cd_setor_atendimento=13 THEN 3 WHEN b.cd_setor_atendimento=21 THEN 3 WHEN b.cd_setor_atendimento=22 THEN 3 WHEN b.cd_setor_atendimento=12 THEN 3 WHEN b.cd_setor_atendimento=11 THEN 3 WHEN b.cd_setor_atendimento=24 THEN 3 WHEN b.cd_setor_atendimento=23 THEN 3 WHEN b.cd_setor_atendimento=48 THEN 2 WHEN b.cd_setor_atendimento=51 THEN 2 WHEN b.cd_setor_atendimento=19 THEN 16 WHEN b.cd_setor_atendimento=16 THEN 16 WHEN b.cd_setor_atendimento=17 THEN 16 WHEN b.cd_setor_atendimento=65 THEN 17 WHEN b.cd_setor_atendimento=20 THEN 20  ELSE CASE WHEN a.ie_tipo_atendimento=1 THEN 4 WHEN a.ie_tipo_atendimento=8 THEN 9  ELSE 6 END  END  END  END ,
		CASE WHEN b.cd_item_convenio='10014' THEN 8889 WHEN b.cd_item_convenio='0001007' THEN 8889 WHEN b.cd_item_convenio='00010071' THEN 8889  ELSE CASE WHEN a.ie_tipo_atendimento=3 THEN 101  ELSE CASE WHEN b.cd_setor_atendimento=49 THEN 120 WHEN b.cd_setor_atendimento=14 THEN 1  ELSE 101 END  END  END ,
		substr(a.nm_paciente,1,25),
		to_char(a.dt_alta,'hh24mi'),
		a.nr_seq_protocolo,
		a.nr_atendimento,
		a.nr_interno_conta

union all

select	9					tp_registro,
		4					ie_tipo_prestador,
		101					cd_prestador,
		''					nm_prestador,
		0					nr_lote,
		LOCALTIMESTAMP				dt_geracao,
		0					cd_tipo_documento,
		''					nr_documento,
		''					nr_cep,
		1					cd_tipo_prestador,
		''					nr_crm,
		LOCALTIMESTAMP				dt_inicio_internacao,
		LOCALTIMESTAMP				dt_alta,
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
		0					cd_moeda_servico,
		0					vl_filme,
		0					cd_moeda_filme,
		''					nr_autorizacao,
		0					cd_fator_plano,
		0					ie_tipo_prest_executante,
		0					cd_prest_executante,
		''					ie_situacao_guia,
		''					nm_usuario,
		''					hr_saida_paciente,
		x.nr_seq_protocolo		nr_seq_protocolo,
		0					nr_atendimento,
		0					nr_interno_conta,
		x.qt_total_conta			qt_doc_enviados,
		0					qt_serv_relacionados,
		sum(b.vl_total_item)		qt_total_servicos_real,
		0					qt_total_cobrado_ch,
		sum(b.vl_filme)			qt_total_filme,
		0					cd_campo_quebra
from  	w_interf_conta_trailler x,
		w_interf_conta_item b
where		x.nr_seq_protocolo	= b.nr_seq_protocolo
group by
		x.nr_seq_protocolo,
		x.qt_total_conta;
