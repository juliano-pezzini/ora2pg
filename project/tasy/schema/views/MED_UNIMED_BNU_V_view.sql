-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';

CREATE OR REPLACE VIEW med_unimed_bnu_v (tp_reg, nr_linha, tp_registro, nr_atendimento, nr_interno_conta, nr_seq_registro, cd_cgc_cpf_prestador, nr_relacao, nr_seq_protocolo, tp_documento, nr_documento, nr_seq_documento, dt_emissao, cd_usuario_convenio, cd_cgc_cpf_medico_solic, ie_origem_doc, ie_versao_cid, cd_cid, dt_internacao, dt_alta, ie_carater_intern, cd_motivo_alta, ie_clinica, cd_procedimento, dt_entrada, dt_saida, qt_procedimento, vl_procedimento, cd_cgc_cpf_med_exec, cd_cgc_cpf_resp_cred, dt_procedimento, cd_atividade_prestador, ie_porte_anestesico, hr_atendimento, ie_cirurgia_multipla, tx_procedimento, ie_pagar_honorario, ie_procedimento_uti, nr_total_linha, vl_total, qt_documento, ds_zeros, ds_espaco, cd_campo_quebra) AS SELECT	0 TP_REG,
	0 nr_linha,
	'00' tp_registro,
	0 nr_atendimento,
	0 nr_interno_conta,
	0 nr_seq_registro,
   	CASE WHEN a.ie_beneficiario='C' THEN a.cd_cgc  ELSE obter_cpf_pessoa_fisica(a.cd_medico) END  cd_cgc_cpf_prestador,
   	a.nr_sequencia nr_relacao,
   	a.nr_sequencia nr_seq_protocolo,
   	'' tp_documento,
   	'' nr_documento,
   	0 nr_seq_documento,
   	LOCALTIMESTAMP dt_emissao,
   	'' cd_usuario_convenio,
   	'' cd_cgc_cpf_medico_solic,
   	'' ie_origem_doc,
   	'' ie_versao_cid,
   	'' cd_cid,
   	LOCALTIMESTAMP dt_internacao,
   	LOCALTIMESTAMP dt_alta,
   	'' ie_carater_intern,
   	0 cd_motivo_alta,
   	0 ie_clinica,
   	'0' cd_procedimento,
   	LOCALTIMESTAMP dt_entrada,
   	LOCALTIMESTAMP dt_saida,
   	0 qt_procedimento,
   	0 vl_procedimento,
   	'' cd_cgc_cpf_med_exec,
   	'' cd_cgc_cpf_resp_cred,
   	LOCALTIMESTAMP dt_procedimento,
   	'' cd_atividade_prestador,
   	0 ie_porte_anestesico,
  	LOCALTIMESTAMP hr_atendimento,
   	'' ie_cirurgia_multipla,
  	0 tx_procedimento,
   	'' ie_pagar_honorario,
   	'' ie_procedimento_uti,
   	0 nr_total_linha,
   	0 vl_total,
   	0 qt_documento,
   	'00000000000000000000000000000000000000000000' ds_zeros,
   	'                                            ' ds_espaco,
	0 cd_campo_quebra
FROM   med_prot_convenio a

union all

/* Cabecalho do Documento */

SELECT 10 TP_REG,
	0 nr_linha,
   	'10' tp_registro,
  	c.nr_atendimento,
	c.nr_atendimento nr_interno_conta,
   	0 nr_seq_registro,
   	'' cd_cgc_cpf_prestador, 0,
   	a.nr_sequencia nr_seq_protocolo,
    	CASE WHEN b.ie_tipo_guia='C' THEN  '02'  ELSE CASE WHEN b.ie_tipo_guia='A' THEN  '03'  ELSE '05' END  END  tp_documento,
   	b.cd_guia nr_documento,
   	0 nr_seq_documento,
   	c.dt_entrada dt_emissao,
   	substr(c.cd_usuario_convenio,1,17) cd_usuario_convenio,
   	obter_cpf_pessoa_fisica(a.cd_medico) cd_cgc_cpf_medico_solic,
	CASE WHEN b.ie_tipo_guia='A' THEN  'P'  ELSE 'N' END  ie_origem_doc,
   	'0010' ie_versao_cid,
  	med_obter_pac_cid(c.nr_seq_cliente) cd_cid,
  	LOCALTIMESTAMP, LOCALTIMESTAMP, '', 0, 0, '0', LOCALTIMESTAMP, LOCALTIMESTAMP,
   	0 , 0 , '', '', LOCALTIMESTAMP, '', 0, LOCALTIMESTAMP, '', 0, '', '', 0, 0, 0,
   	'00000000000000000000000000000000000000000000' ds_zeros,
   	'                                            ' ds_espaco,
	1 cd_campo_quebra
FROM med_item d, med_atendimento c, med_prot_convenio a
LEFT OUTER JOIN med_faturamento b ON (a.nr_sequencia = b.nr_seq_protocolo)
WHERE b.nr_atendimento		= c.nr_atendimento and b.nr_seq_item		= d.nr_sequencia
group 	by c.nr_atendimento,
	c.nr_atendimento,
   	a.nr_sequencia,
    	CASE WHEN b.ie_tipo_guia='C' THEN  '02'  ELSE CASE WHEN b.ie_tipo_guia='A' THEN  '03'  ELSE '05' END  END ,
   	b.cd_guia,
   	c.dt_entrada,
   	substr(c.cd_usuario_convenio,1,17),
   	obter_cpf_pessoa_fisica(a.cd_medico),
	CASE WHEN b.ie_tipo_guia='A' THEN  'P'  ELSE 'N' END ,
  	med_obter_pac_cid(c.nr_seq_cliente)

union all

/* Servicos do Documento */

SELECT	13 TP_REG,
	0 nr_linha,
   	'13' tp_registro,
   	c.nr_atendimento,
	c.nr_atendimento nr_interno_conta,
   	0 nr_seq_registro, '', 0,
   	a.nr_sequencia nr_seq_protocolo,
   	'', '', 0, LOCALTIMESTAMP, '', '', '', '', '', LOCALTIMESTAMP, LOCALTIMESTAMP, '', 0, 0,
	MED_OBTER_COD_ITEM_CONVENIO(c.NR_ATENDIMENTO, b.NR_SEQ_ITEM) cd_procedimento,
   	LOCALTIMESTAMP,
   	LOCALTIMESTAMP,
   	sum(b.qt_item) qt_procedimento,
   	sum(b.vl_item) vl_procedimento,
   	obter_cpf_pessoa_fisica(a.cd_medico) cd_cgc_cpf_exec,
   	CASE WHEN a.ie_beneficiario='C' THEN a.cd_cgc  ELSE obter_cpf_pessoa_fisica(a.cd_medico) END  cd_cgc_cpf_resp_cred,
   	c.dt_entrada dt_procedimento,
   	'L' cd_atividade_prestador,
   	0 ie_porte_anestesico,
   	c.dt_entrada hr_atendimento,
   	'D' ie_cirurgia_multipla,
   	100 tx_procedimento,
   	'N' ie_pagar_honorario,
   	'N' ie_procedimento_uti , 0, 0, 0,
   	'00000000000000000000000000000000000000000000' ds_zeros,
   	'                                            ' ds_espaco,
	10 cd_campo_quebra
FROM med_atendimento c, med_prot_convenio a
LEFT OUTER JOIN med_faturamento b ON (a.nr_sequencia = b.nr_seq_protocolo)
WHERE b.nr_atendimento		= c.nr_atendimento
group 	by a.nr_sequencia,
	b.nr_seq_item,
	c.nr_atendimento,
	obter_cpf_pessoa_fisica(a.cd_medico),
	CASE WHEN a.ie_beneficiario='C' THEN a.cd_cgc  ELSE obter_cpf_pessoa_fisica(a.cd_medico) END ,
	c.dt_entrada
 
union all

/* Total do documento */

SELECT 19 TP_REG,
	0 nr_linha,
   	'19' tp_registro,
   	c.nr_atendimento,
	c.nr_atendimento nr_interno_conta,
   	0 nr_seq_registro, '', 0,
   	a.nr_sequencia nr_seq_protocolo,
   	'', '', 0, LOCALTIMESTAMP, '', '', '', '', '', LOCALTIMESTAMP, LOCALTIMESTAMP, '', 0, 0,
   	'0', LOCALTIMESTAMP, LOCALTIMESTAMP, 0, 0, '', '', LOCALTIMESTAMP, '', 0, LOCALTIMESTAMP, '',
   	0, '', '', 0, sum(b.qt_item * b.vl_item) vl_total, 0,
   	'00000000000000000000000000000000000000000000' ds_zeros,
   	'                                            ' ds_espaco,
	10 cd_campo_quebra
FROM med_atendimento c, med_prot_convenio a
LEFT OUTER JOIN med_faturamento b ON (a.nr_sequencia = b.nr_seq_protocolo)
WHERE b.nr_atendimento		= c.nr_atendimento
group 	by a.nr_sequencia,
	c.nr_atendimento
 
union all

/* Total do arquivo */

SELECT 99 TP_REG,
	0 nr_linha,
   	'99' tp_registro,
   	999999999 nr_atendimento,
  	999999999 nr_interno_conta,
   	0 nr_seq_registro, '', 0,
   	a.nr_sequencia nr_seq_protocolo,
   	'', '', 0, LOCALTIMESTAMP, '', '', '', '', '', LOCALTIMESTAMP, LOCALTIMESTAMP, '', 0, 0,
   	'0', LOCALTIMESTAMP, LOCALTIMESTAMP, 0, 0, '', '', LOCALTIMESTAMP, '', 0, LOCALTIMESTAMP, '',
   	0, '', '', 0 nr_total_linha, sum(b.qt_item * b.vl_item) vl_total, sum(b.qt_item) qt_documento,
   	'00000000000000000000000000000000000000000000' ds_zeros,
   	'                                            ' ds_espaco,
	0 cd_campo_quebra
FROM med_prot_convenio a
LEFT OUTER JOIN med_faturamento b ON (a.nr_sequencia = b.nr_seq_protocolo
group 	by a.nr_sequencia);
