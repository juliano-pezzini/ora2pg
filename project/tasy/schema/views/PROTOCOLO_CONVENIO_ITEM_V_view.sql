-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';

CREATE OR REPLACE VIEW protocolo_convenio_item_v (dt_entrada_unidade, nr_atendimento, ie_proc_mat, dt_conta, dt_item, cd_item, cd_item_convenio, qt_item, vl_item, vl_medico, vl_anestesista, vl_filme, vl_auxiliares, vl_custo_operacional, vl_desconto, nr_interno_conta, nr_conta_convenio, dt_acerto_conta, dt_acerto_convenio, cd_convenio, cd_categoria, cd_setor_atendimento, ds_item, tp_item, cd_subgrupo_item, ds_subgrupo_item, ds_unidade, cd_motivo_exc_conta, ie_cobra_pf_pj, vl_unitario, nr_protocolo, nr_seq_protocolo, cd_convenio_protocolo, dt_mesano_protocolo, cd_convenio_parametro, dt_mesano_referencia, dt_periodo_inicial, dt_periodo_final, ie_status_acerto, ie_cancelamento, cd_autorizacao, nr_sequencia, nr_prescricao, nr_sequencia_prescricao, cd_medico_executor, nr_lote_contabil, ie_funcao_medico, ie_origem_proced, ie_tipo_servico_sus, cd_setor_receita, nr_seq_proc_pacote, cd_cgc_prestador, nr_seq_apresent, vl_original, tx_procedimento, ie_status_protocolo, dt_vencimento, ie_video, cd_grupo_proc, dt_entrega_convenio, cd_tipo_item, nr_seq_proc_interno, cd_estabelecimento, ie_emite_conta, cd_categoria_parametro, cd_especialidade, cd_edicao_amb, cd_medico_req, cd_procedimento_tuss, nr_seq_grupo_rec, nr_seq_exame, ie_responsavel_credito, ie_tipo_atend_tiss, ie_tipo_atend_conta, vl_item_imposto) AS SELECT	TO_DATE(TO_CHAR(A.DT_ENTRADA_UNIDADE, 'DD/MM/YYYY'),'DD/MM/YYYY') DT_ENTRADA_UNIDADE,
	B.NR_ATENDIMENTO,
	1 IE_PROC_MAT,
	A.DT_CONTA,
	A.DT_PROCEDIMENTO      	DT_ITEM,
	A.CD_PROCEDIMENTO      	CD_ITEM,
	A.CD_PROCEDIMENTO_CONVENIO   CD_ITEM_CONVENIO,
	A.QT_PROCEDIMENTO      	QT_ITEM,
	A.VL_PROCEDIMENTO      	VL_ITEM,
	A.VL_MEDICO            	VL_MEDICO,
	A.VL_ANESTESISTA       	VL_ANESTESISTA,
	A.VL_MATERIAIS         	VL_FILME,
	A.VL_AUXILIARES        	VL_AUXILIARES,
	A.VL_CUSTO_OPERACIONAL 	VL_CUSTO_OPERACIONAL,
	Obter_Desconto_MatProc(A.nr_sequencia, 'P') VL_DESCONTO,
       	A.NR_INTERNO_CONTA,
		B.NR_CONTA_CONVENIO,
       	A.DT_ACERTO_CONTA,
       	A.DT_ACERTO_CONVENIO,
       	A.CD_CONVENIO,
       	A.CD_CATEGORIA,
       	A.CD_SETOR_ATENDIMENTO,
       	C.DS_PROCEDIMENTO      	DS_ITEM,
       	C.IE_CLASSIFICACAO     	TP_ITEM          /* 1-AMB  2-SERVICOS 3-DIARIAS */
,
	C.IE_CLASSIFICACAO CD_SUBGRUPO_ITEM,
       	CASE WHEN C.IE_CLASSIFICACAO=1 THEN 'Procedimentos Médicos' WHEN C.IE_CLASSIFICACAO=2 THEN 'Servicos Hospitalares'  ELSE 'Diarias' END  DS_SUBGRUPO_ITEM,
       	'Un' DS_UNIDADE,
       	A.CD_MOTIVO_EXC_CONTA,
	A.IE_COBRA_PF_PJ,
       	(A.VL_PROCEDIMENTO / CASE WHEN A.QT_PROCEDIMENTO=0 THEN 1  ELSE A.QT_PROCEDIMENTO END ) VL_UNITARIO,
	D.NR_PROTOCOLO,
	D.NR_SEQ_PROTOCOLO,
	D.CD_CONVENIO	CD_CONVENIO_PROTOCOLO,
       	D.DT_MESANO_REFERENCIA DT_MESANO_PROTOCOLO,
	B.CD_CONVENIO_PARAMETRO,
       	B.DT_MESANO_REFERENCIA,
       	B.DT_PERIODO_INICIAL,
       	B.DT_PERIODO_FINAL,
	B.IE_STATUS_ACERTO,
	B.IE_CANCELAMENTO,
	A.NR_DOC_CONVENIO CD_AUTORIZACAO,
	A.NR_SEQUENCIA,
	A.NR_PRESCRICAO,
	A.NR_SEQUENCIA_PRESCRICAO,
	A.CD_MEDICO_EXECUTOR	CD_MEDICO_EXECUTOR,
	A.NR_LOTE_CONTABIL,
	A.IE_FUNCAO_MEDICO IE_FUNCAO_MEDICO,
	A.IE_ORIGEM_PROCED,
	A.IE_TIPO_SERVICO_SUS,
	A.CD_SETOR_RECEITA,
	A.NR_SEQ_PROC_PACOTE,
	A.CD_CGC_PRESTADOR CD_CGC_PRESTADOR,
	B.NR_SEQ_APRESENT,
	coalesce(G.VL_PROCEDIMENTO, A.VL_PROCEDIMENTO) VL_ORIGINAL,
	coalesce(A.TX_PROCEDIMENTO,100) TX_PROCEDIMENTO,
	D.IE_STATUS_PROTOCOLO,
	D.DT_VENCIMENTO,
	A.ie_video,
	C.CD_GRUPO_PROC,
	D.dt_entrega_convenio,
	C.cd_tipo_procedimento cd_tipo_item,
	A.nr_seq_proc_interno,
	B.cd_estabelecimento,
	A.ie_emite_conta,
	B.CD_CATEGORIA_PARAMETRO,
	A.cd_especialidade,
	A.cd_edicao_amb,
	A.CD_MEDICO_REQ,
	A.CD_PROCEDIMENTO_TUSS,
	A.NR_SEQ_GRUPO_REC NR_SEQ_GRUPO_REC,
	A.nr_seq_exame nr_seq_exame,
	A.ie_responsavel_credito,
	B.ie_tipo_atend_tiss,
	B.ie_tipo_atend_conta,
	(A.VL_PROCEDIMENTO + coalesce(Y.VL_IMPOSTO,0)) VL_ITEM_IMPOSTO
FROM protocolo_convenio d, procedimento c, conta_paciente b, procedimento_paciente a
LEFT OUTER JOIN proc_paciente_valor g ON (A.NR_SEQUENCIA = G.NR_SEQ_PROCEDIMENTO AND 1 = G.IE_TIPO_VALOR)
LEFT OUTER JOIN propaci_imposto y ON (A.NR_SEQUENCIA = Y.NR_SEQ_PROPACI)
WHERE D.NR_SEQ_PROTOCOLO	= B.NR_SEQ_PROTOCOLO AND A.CD_MOTIVO_EXC_CONTA IS NULL AND A.CD_PROCEDIMENTO       = C.CD_PROCEDIMENTO AND A.IE_ORIGEM_PROCED      = C.IE_ORIGEM_PROCED AND A.NR_INTERNO_CONTA   	= B.NR_INTERNO_CONTA
UNION

SELECT	TO_DATE(TO_CHAR(X.DT_ENTRADA_UNIDADE, 'DD/MM/YYYY'),'DD/MM/YYYY') DT_ENTRADA_UNIDADE,
       	Y.NR_ATENDIMENTO,
       	2 IE_PROC_MAT,
       	X.DT_CONTA,
       	X.DT_ATENDIMENTO       	DT_ITEM,
       	X.CD_MATERIAL          	CD_ITEM,
       	X.CD_MATERIAL_CONVENIO	CD_ITEM_CONVENIO,
       	X.QT_MATERIAL          	QT_ITEM,
	X.VL_MATERIAL          	VL_ITEM,
       	0                      	VL_MEDICO,
       	0                      	VL_ANESTESISTA,
       	0                      	VL_FILME,
       	0                      	VL_AUXILIARES,
       	0                      	VL_CUSTO_OPERACIONAL,
	Obter_Desconto_MatProc(x.nr_sequencia, 'M') VL_DESCONTO,
       	X.NR_INTERNO_CONTA,
		Y.NR_CONTA_CONVENIO,
       	X.DT_ACERTO_CONTA,
       	X.DT_ACERTO_CONVENIO,
       	X.CD_CONVENIO,
       	X.CD_CATEGORIA,
       	X.CD_SETOR_ATENDIMENTO,
       	W.DS_MATERIAL          DS_ITEM,
	CASE WHEN W.IE_TIPO_MATERIAL=1 THEN '1' WHEN W.IE_TIPO_MATERIAL=	--MATERIA
	7 THEN '1' WHEN W.IE_TIPO_MATERIAL=	--Material da bolsa de sangue
	10 THEN '1' WHEN W.IE_TIPO_MATERIAL=	--Material exclusivo para faturamento
	2 THEN '2' WHEN W.IE_TIPO_MATERIAL=	--Medicamento Comercial
	3 THEN '2' WHEN W.IE_TIPO_MATERIAL=	--Medicamento Genérico
	6 THEN '2' WHEN W.IE_TIPO_MATERIAL=	--Medicamento sem apresentação
	8 THEN '2' WHEN W.IE_TIPO_MATERIAL=	--Medicamento exclusivo para faturamento
	9 THEN '2'  ELSE 	--Medicamento Similar
	'5' END      TP_ITEM,
	IE_TIPO_MATERIAL CD_SUBGRUPO_ITEM,
	CASE WHEN W.IE_TIPO_MATERIAL=1 THEN 'Materiais' WHEN W.IE_TIPO_MATERIAL=7 THEN 'Materiais' WHEN W.IE_TIPO_MATERIAL=10 THEN 'Materiais' WHEN W.IE_TIPO_MATERIAL=2 THEN 'Medicamentos' WHEN W.IE_TIPO_MATERIAL=3 THEN 'Medicamentos' WHEN W.IE_TIPO_MATERIAL=6 THEN 'Medicamentos' WHEN W.IE_TIPO_MATERIAL=8 THEN 'Medicamentos' WHEN W.IE_TIPO_MATERIAL=9 THEN 'Medicamentos'  ELSE 'Extras' END  DS_SUBGRUPO_ITEM,
       	substr(obter_dados_material_estab(x.cd_material,Y.cd_estabelecimento,'UMS'),1,30) DS_UNIDADE,
       	X.CD_MOTIVO_EXC_CONTA,
	'' IE_COBRA_PF_PJ,
       	X.VL_UNITARIO,
	Z.NR_PROTOCOLO,
	Z.NR_SEQ_PROTOCOLO,
	Z.CD_CONVENIO CD_CONVENIO_PROTOCOLO,
       	Z.DT_MESANO_REFERENCIA DT_MESANO_PROTOCOLO,
	Y.CD_CONVENIO_PARAMETRO,
       	Y.DT_MESANO_REFERENCIA,
       	Y.DT_PERIODO_INICIAL,
       	Y.DT_PERIODO_FINAL,
	Y.IE_STATUS_ACERTO,
	Y.IE_CANCELAMENTO,
	X.NR_DOC_CONVENIO CD_AUTORIZACAO,
	X.NR_SEQUENCIA,
	X.NR_PRESCRICAO,
	X.NR_SEQUENCIA_PRESCRICAO,
	''	CD_MEDICO_EXECUTOR,
	X.NR_LOTE_CONTABIL,
	'' IE_FUNCAO_MEDICO,
	0 IE_ORIGEM_PROCED,
	0 IE_TIPO_SERVICO_SUS,
	X.CD_SETOR_RECEITA,
	X.NR_SEQ_PROC_PACOTE,
	'' CD_CGC_PRESTADOR,
	Y.NR_SEQ_APRESENT,
	coalesce(X.VL_TABELA_ORIGINAL, X.VL_MATERIAL),
	100 TX_PROCEDIMENTO,
	Z.IE_STATUS_PROTOCOLO,
	Z.DT_VENCIMENTO,
	'N', 0,
	z.dt_entrega_convenio,
	0,
	0,
	Y.cd_estabelecimento,
	x.ie_emite_conta,
	Y.CD_CATEGORIA_PARAMETRO,
	0 cd_especialidade,
	null cd_edicao_amb,
	null CD_MEDICO_REQ,
	null,
	NULL NR_SEQ_GRUPO_REC,
	0 nr_seq_exame,
	x.ie_responsavel_credito,
	Y.ie_tipo_atend_tiss,
	Y.ie_tipo_atend_conta,
	(X.VL_MATERIAL + coalesce(I.VL_IMPOSTO,0)) VL_ITEM_IMPOSTO
FROM protocolo_convenio z, conta_paciente y, material w, material_atend_paciente x
LEFT OUTER JOIN matpaci_imposto i ON (X.NR_SEQUENCIA = I.NR_SEQ_MATPACI)
WHERE Z.NR_SEQ_PROTOCOLO = Y.NR_SEQ_PROTOCOLO AND X.CD_MOTIVO_EXC_CONTA IS NULL AND X.CD_MATERIAL      = W.CD_MATERIAL AND X.NR_INTERNO_CONTA  = Y.NR_INTERNO_CONTA;
