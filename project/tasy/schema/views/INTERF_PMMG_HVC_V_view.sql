-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';

CREATE OR REPLACE VIEW interf_pmmg_hvc_v (tp_reg, tp_registro, cd_cgc, dt_remessa, nr_seq_remessa, nr_documento, tp_servico, cd_item, nr_segurado, dt_emissao, dt_entrada, ie_tipo_atendimento, dt_alta, cd_motivo_alta, cd_cid_principal, cd_especialidade, vl_total_conta, vl_total_item, qt_item, dt_item, nr_porte_anestesico, cd_proc_pmmg, cd_atuacao, cd_cpf_cgc, qt_ch_item, tp_faturamento, vl_taxa_sala, vl_matmed_sala, vl_matmed_enf, vl_banco_sangue, vl_gasoterapia, vl_patol_clinica, vl_radiologia, vl_ecg, vl_fisioterapia, vl_outros, ds_lista_proc, tp_diaria, vl_honorario, cd_funcao_espec_med, nr_atendimento, nr_atendimento_pmmg, nr_seq_protocolo, ie_cirurgico, ds_zeros, ds_espaco) AS SELECT	0 TP_REG,
		0 TP_REGISTRO,
		a.cd_cgc_hospital CD_CGC,
		a.dt_remessa DT_REMESSA,
		a.nr_remessa NR_SEQ_REMESSA,
		'0' NR_DOCUMENTO,
		0 TP_SERVICO,
		'0' CD_ITEM,
		'0' NR_SEGURADO,
		LOCALTIMESTAMP dt_emissao,
		LOCALTIMESTAMP dt_entrada,
		0 ie_tipo_atendimento,
		LOCALTIMESTAMP dt_alta,
		0 cd_motivo_alta,
		'0' cd_cid_principal,
		0 cd_especialidade,
		0 vl_total_Conta,
		0 vl_total_item,
		0 qt_item,
		LOCALTIMESTAMP dt_item,
		0 nr_porte_anestesico,
		0 cd_proc_pmmg,
		0 cd_atuacao,
		a.cd_cgc_hospital cd_cpf_cgc,
		0 qt_ch_item,
		'' tp_faturamento,
		0 vl_taxa_sala,
		0 vl_matmed_sala,
		0 vl_matmed_enf,
		0 vl_banco_sangue,
		0 vl_gasoterapia,
		0 vl_patol_clinica,
		0 vl_radiologia,
		0 vl_ecg,
		0 vl_fisioterapia,
		0 vl_outros,
		'' ds_lista_proc,
		0 tp_diaria,
		0 vl_honorario,
		0 cd_funcao_espec_med,
		0 nr_atendimento,
		'0' nr_atendimento_pmmg,
		a.nr_seq_protocolo,
		'N' ie_cirurgico,
		'00000000000000000000000000000000000000000000' ds_zeros,
		'                                            ' ds_espaco
FROM  	w_interf_conta_header a
where		a.ie_tipo_protocolo in (3,4,5,6)

union all

/* Header */

SELECT	1 TP_REG,
		0 TP_REGISTRO,
		a.cd_cgc_hospital CD_CGC,
		a.dt_remessa DT_REMESSA,
		a.nr_remessa NR_SEQ_REMESSA,
		'0' NR_DOCUMENTO,
		0 TP_SERVICO,
		'0' CD_ITEM,
		'0' NR_SEGURADO,
		LOCALTIMESTAMP dt_emissao,
		LOCALTIMESTAMP dt_entrada,
		0 ie_tipo_atendimento,
		LOCALTIMESTAMP dt_alta,
		0 cd_motivo_alta,
		'0' cd_cid_principal,
		0 cd_especialidade,
		0 vl_total_Conta,
		0 vl_total_item,
		0 qt_item,
		LOCALTIMESTAMP dt_item,
		0 nr_porte_anestesico,
		0 cd_proc_pmmg,
		0 cd_atuacao,
		a.cd_cgc_hospital cd_cpf_cgc,
		0 qt_ch_item,
		'' tp_faturamento,
		0 vl_taxa_sala,
		0 vl_matmed_sala,
		0 vl_matmed_enf,
		0 vl_banco_sangue,
		0 vl_gasoterapia,
		0 vl_patol_clinica,
		0 vl_radiologia,
		0 vl_ecg,
		0 vl_fisioterapia,
		0 vl_outros,
		'',
		0 tp_diaria,
		0 vl_honorario,
		0 cd_funcao_espec_med,
		0 nr_atendimento,
		'0' nr_atendimento_pmmg,
		a.nr_seq_protocolo,
		'N' ie_cirurgico,
		'00000000000000000000000000000000000000000000' ds_zeros,
		'' ds_espaco
FROM  	w_interf_conta_header a
where		a.ie_tipo_protocolo in (1,2)

union all

/* Cabecalho da conta */

SELECT     	2,
		1, a.cd_cgc_hospital,
		LOCALTIMESTAMP, 0,
		CASE WHEN a.ie_tipo_atendimento=1 THEN coalesce(a.nr_doc_convenio,0)  ELSE coalesce(a.nr_doc_convenio, a.nr_atendimento) END ,
		0, '0',
		substr(a.cd_usuario_convenio,1,9),
		a.dt_periodo_final,
		a.dt_entrada,
		CASE WHEN a.ie_tipo_atendimento=1 THEN 1  ELSE 2 END ,
		CASE WHEN a.ie_tipo_atendimento=1 THEN  a.dt_alta  ELSE '' END  dt_alta,
		CASE WHEN a.ie_tipo_atendimento=1 THEN  a.cd_motivo_alta  ELSE '' END  cd_motivo_alta,
		a.cd_proc_principal,
		CASE WHEN a.ie_tipo_atendimento=1 THEN 			CASE WHEN a.cd_setor_cirurgia IS NULL THEN 1  ELSE 2 END   ELSE 3 END  cd_especialidade,
		b.vl_total_conta + b.vl_honor_conv + b.vl_honor_nconv,
		0, 0, LOCALTIMESTAMP, 0, 0, 0, '0', 0,'',
		0,0,0,0,0,0,0,0,0,0,'',
		0 tp_diaria,
		0 vl_honorario,
		0 cd_funcao_espec_med,
		a.nr_atendimento,
		to_char(a.nr_atendimento,'FM0000000') || '84' nr_atendimento_pmmg,
		a.nr_seq_protocolo,
		substr(obter_se_atend_cirurgico(a.nr_atendimento),1,1) ie_cirurgico,
		'00000000000000000000000000000000000000000000' ds_zeros,
		'' ds_espaco
from 		w_interf_conta_total b,
		w_interf_conta_cab a
where 	a.nr_interno_conta = b.nr_interno_conta
and		a.ie_tipo_protocolo in (1,2)

union all

/* Registro de Diarias */

SELECT     	3,
		1, a.cd_cgc_hospital,
		LOCALTIMESTAMP, 0,
		CASE WHEN a.ie_tipo_atendimento=1 THEN coalesce(a.nr_doc_convenio,0)  ELSE coalesce(a.nr_doc_convenio, a.nr_atendimento) END ,
		1, b.cd_item_convenio,
		to_char(a.cd_tipo_acomodacao),
		min(LOCALTIMESTAMP),
		a.dt_entrada,
		0,
		min(LOCALTIMESTAMP),
		0,
		'0',
		0,
		0,
		sum(b.vl_total_item),
		sum(b.qt_item),
		min(dt_item),
		0, b.cd_item,
		0, '0', 0,'',
		0,0,0,0,0,0,0,0,0,0,'',
		b.cd_item tp_diaria,
		0 vl_honorario,
		0 cd_funcao_espec_med,
		a.nr_atendimento,
		to_char(a.nr_atendimento,'FM0000000') || '84' nr_atendimento_pmmg,
		a.nr_seq_protocolo,
		'N' ie_cirurgico,
		'00000000000000000000000000000000000000000000' ds_zeros,
		'' ds_espaco
from 		w_interf_conta_item b,
		w_interf_conta_cab a
where 	a.nr_interno_conta 	= b.nr_interno_conta
and		b.ie_total_interf		= 5
and		a.ie_tipo_protocolo in (1,2)
group by 	a.cd_cgc_hospital,
		CASE WHEN a.ie_tipo_atendimento=1 THEN coalesce(a.nr_doc_convenio,0)  ELSE coalesce(a.nr_doc_convenio, a.nr_atendimento) END ,
		to_char(a.cd_tipo_acomodacao),
		a.dt_entrada, b.cd_item, b.cd_item_convenio, a.cd_tipo_acomodacao,
		a.nr_atendimento,
		to_char(a.nr_atendimento,'FM0000000') || '84',
		a.nr_seq_protocolo

union all

/* Registro de Taxas de Sala */

SELECT     	4,
		1, a.cd_cgc_hospital,
		LOCALTIMESTAMP, 0,
		CASE WHEN a.ie_tipo_atendimento=1 THEN coalesce(a.nr_doc_convenio,0)  ELSE coalesce(a.nr_doc_convenio, a.nr_atendimento) END ,
		2,
		to_char(cd_item),
		'0',
		LOCALTIMESTAMP,
		a.dt_entrada,
		0,
		LOCALTIMESTAMP,
		0,
		'0',
		0,
		0,
		b.vl_total_item,
		b.qt_item,
		b.dt_item,
		b.nr_porte_anestesico,
		b.cd_procedimento_ref,
		0, '0', 0,'',
		0,0,0,0,0,0,0,0,0,0,'',
		0 tp_diaria,
		0 vl_honorario,
		0 cd_funcao_espec_med,
		a.nr_atendimento,
		to_char(a.nr_atendimento,'FM0000000') || '84' nr_atendimento_pmmg,
		a.nr_seq_protocolo,
		'N' ie_cirurgico,
		'00000000000000000000000000000000000000000000' ds_zeros,
		'' ds_espaco
from 		w_interf_conta_item b,
		w_interf_conta_cab a
where 	a.nr_interno_conta = b.nr_interno_conta
and		b.ie_total_interf		= 7
and		a.ie_tipo_protocolo in (1,2)

union all

/* Registro de Servicos/Matmed -   */

SELECT     	5,
		1, a.cd_cgc_hospital,
		LOCALTIMESTAMP, 0,
		CASE WHEN a.ie_tipo_atendimento=1 THEN coalesce(a.nr_doc_convenio,0)  ELSE coalesce(a.nr_doc_convenio, a.nr_atendimento) END ,
		3, '0',
		'0',
		LOCALTIMESTAMP,
		LOCALTIMESTAMP,
		0,
		LOCALTIMESTAMP,
		0,
		'0',
		0,
		0,
		0,
		0,
		LOCALTIMESTAMP,
		0,
		0,
		0, '0', 0,'',
		sum(CASE WHEN b.ie_total_interf=7 THEN b.vl_total_item  ELSE 0 END ) 	vl_taxa_sala,
		sum(CASE WHEN b.ie_total_interf=16 THEN b.vl_total_item  ELSE 0 END ) 	vl_matmed_sala,
		sum(CASE WHEN b.ie_total_interf=1 THEN b.vl_total_item WHEN b.ie_total_interf=2 THEN b.vl_total_item WHEN b.ie_total_interf=3 THEN b.vl_total_item  ELSE 0 END ) 		vl_matmed_enf,
		sum(CASE WHEN b.ie_total_interf=17 THEN b.vl_total_item  ELSE 0 END ) 	vl_banco_sangue,
		sum(CASE WHEN b.ie_total_interf=18 THEN b.vl_total_item  ELSE 0 END ) 	vl_gasoterapia,
		sum(CASE WHEN b.ie_total_interf=19 THEN b.vl_total_item  ELSE 0 END ) 	vl_patol_clinica,
		sum(CASE WHEN b.ie_total_interf=20 THEN b.vl_total_item  ELSE 0 END ) 	vl_radiologia,
		sum(CASE WHEN b.ie_total_interf=21 THEN b.vl_total_item  ELSE 0 END ) 	vl_ecg,
		sum(CASE WHEN b.ie_total_interf=22 THEN b.vl_total_item  ELSE 0 END ) 	vl_fisioterapia,
		sum(CASE WHEN b.ie_total_interf=7 THEN 0 WHEN b.ie_total_interf=16 THEN 0 WHEN b.ie_total_interf=1 THEN 0 WHEN b.ie_total_interf=2 THEN 0 WHEN b.ie_total_interf=3 THEN 0 WHEN b.ie_total_interf=17 THEN 0 WHEN b.ie_total_interf=18 THEN 0 WHEN b.ie_total_interf=19 THEN 0 WHEN b.ie_total_interf=20 THEN 0 WHEN b.ie_total_interf=21 THEN 0 WHEN b.ie_total_interf=22 THEN 0 WHEN b.ie_total_interf=5 THEN 0  ELSE b.vl_total_item END )		vl_outros,
		'',
		0 tp_diaria,
		0 vl_honorario,
		0 cd_funcao_espec_med,
		a.nr_atendimento,
		to_char(a.nr_atendimento,'FM0000000') || '84' nr_atendimento_pmmg,
		a.nr_seq_protocolo,
		'N' ie_cirurgico,
		'00000000000000000000000000000000000000000000' ds_zeros,
		'' ds_espaco
from 		w_interf_conta_item b,
		w_interf_conta_cab a
where 	a.nr_interno_conta = b.nr_interno_conta
and		b.ie_total_interf not in (5,12,13,14)
and		a.ie_tipo_protocolo in (1,2)
group by 	a.cd_cgc_hospital,
		CASE WHEN a.ie_tipo_atendimento=1 THEN coalesce(a.nr_doc_convenio,0)  ELSE coalesce(a.nr_doc_convenio, a.nr_atendimento) END ,
		a.nr_atendimento,
		to_char(a.nr_atendimento,'FM0000000') || '84',
		a.nr_seq_protocolo

union all

/* Registro Servicos Profissionais */

SELECT     	6,
		1, a.cd_cgc_hospital,
		LOCALTIMESTAMP, 0,
		CASE WHEN a.ie_tipo_atendimento=1 THEN coalesce(a.nr_doc_convenio,0)  ELSE coalesce(a.nr_doc_convenio, a.nr_atendimento) END ,
		4, b.cd_item_convenio,
		'0',
		LOCALTIMESTAMP,
		a.dt_entrada,
		0,
		LOCALTIMESTAMP,
		0,
		'0',
		0,
		0,
		b.vl_total_item,
		b.qt_item,
		b.dt_item,
		b.nr_porte_anestesico,
		b.cd_item,
		b.cd_funcao_executor cd_atuacao,
		b.cd_cgc_cpf_resp_cred,
		b.qt_ch_item,
		b.ie_responsavel_credito,
		0,0,0,0,0,0,0,0,0,0,'',
		0 tp_diaria,
		b.vl_honorario vl_honorario,
		b.cd_funcao_espec_med,
		a.nr_atendimento,
		to_char(a.nr_atendimento,'FM0000000') || '84' nr_atendimento_pmmg,
		a.nr_seq_protocolo,
		'N' ie_cirurgico,
		'00000000000000000000000000000000000000000000' ds_zeros,
		'' ds_espaco
FROM w_interf_conta_item b, w_interf_conta_cab a, coalesce(somente_numero(b
LEFT OUTER JOIN conta_paciente_estrutura c ON (coalesce(somente_numero(b.ie_emite_conta),9999) = c.cd_estrutura)
WHERE a.nr_interno_conta 	= b.nr_interno_conta and c.ie_total_interf		in (12,13,14) and a.ie_tipo_protocolo in (1,2)
union all

/* Detalhe conta exame */

SELECT     	7,
		1, a.cd_cgc_hospital,
		LOCALTIMESTAMP, 0,
		CASE WHEN a.ie_tipo_atendimento=1 THEN coalesce(c.cd_autorizacao,0)  ELSE coalesce(c.cd_autorizacao, a.nr_atendimento) END ,
		0, '0',
		substr(a.cd_usuario_convenio,1,9),
		a.dt_periodo_final,
		a.dt_entrada,
		CASE WHEN a.ie_tipo_atendimento=1 THEN 1  ELSE 2 END ,
		a.dt_alta,
		a.cd_motivo_alta,
		a.cd_proc_principal,
		a.ie_clinica,
		b.vl_total_conta,
		0, 0, LOCALTIMESTAMP, 0, 0, 0, '0', 0,'',
		0,0,0,0,0,0,0,0,0,0,
		rpad(substr(obter_lista_proc_conta(a.nr_interno_conta,c.cd_autorizacao,'N','N','T'),1,96),96,'0') ds_lista_proc,
		0 tp_diaria,
		0 vl_honorario,
		0 cd_funcao_espec_med,
		a.nr_atendimento,
		to_char(a.nr_atendimento,'FM0000000') || '84' nr_atendimento_pmmg,
		a.nr_seq_protocolo,
		'N' ie_cirurgico,
		'00000000000000000000000000000000000000000000' ds_zeros,
		'' ds_espaco
from 		w_interf_conta_autor c,
		w_interf_conta_total b,
		w_interf_conta_cab a
where 	a.nr_interno_conta = b.nr_interno_conta
and		a.nr_interno_conta = c.nr_interno_conta
and		a.ie_tipo_protocolo in (3,4,5,6)

union all

/* Trailler Internados */

SELECT	8,
		9,
		a.cd_cgc_hospital CD_CGC,
		LOCALTIMESTAMP, 0,
		'0', 0, '0', '0', LOCALTIMESTAMP, LOCALTIMESTAMP,
		0 , LOCALTIMESTAMP, 0, '0',
		0, 0, 0, 0,
		LOCALTIMESTAMP,
		0,0,0, '0',0,'',
		0,0,0,0,0,0,0,0,0,0,'',
		0 tp_diaria,
		0 vl_honorario,
		0 cd_funcao_espec_med,	0 nr_atendimento,
		'0' nr_atendimento_pmmg,
		a.nr_seq_protocolo,
		'N' ie_cirurgico,
		'00000000000000000000000000000000000000000000' ds_zeros,
		'' ds_espaco
from 		w_interf_conta_Trailler a,
		w_interf_conta_header b
where		a.nr_seq_protocolo	= b.nr_seq_protocolo
and		b.ie_tipo_protocolo in (1,2)

union all

/* Trailler Externos */

SELECT	9,
		9,
		a.cd_cgc_hospital CD_CGC,
		LOCALTIMESTAMP, 0,
		'0', 0, '0', '0', LOCALTIMESTAMP, LOCALTIMESTAMP,
		0 , LOCALTIMESTAMP, 0, '0',
		0, 0, 0, 0,
		LOCALTIMESTAMP,
		0,0,0, '0',0,'',
		0,0,0,0,0,0,0,0,0,0,'',
		0 tp_diaria,
		0 vl_honorario,
		0 cd_funcao_espec_med,
		0 nr_atendimento,
		'0' nr_atendimento_pmmg,
		a.nr_seq_protocolo,
		'N' ie_cirurgico,
		'00000000000000000000000000000000000000000000' ds_zeros,
		'' ds_espaco
from 		w_interf_conta_Trailler a,
		w_interf_conta_header b
where		a.nr_seq_protocolo	= b.nr_seq_protocolo
and		b.ie_tipo_protocolo in (3,4,5,6);

