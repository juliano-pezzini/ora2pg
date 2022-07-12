-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';

CREATE OR REPLACE VIEW protocolo_doc_item_v (nr_sequencia, nr_seq_item, dt_atualizacao, nm_usuario, nr_documento, ds_documento, nr_seq_interno, nr_seq_tipo_item, dt_conferencia, dt_recebimento, qt_documento, ie_descartado, nm_usuario_receb, cd_convenio, nr_doc_item, nr_seq_motivo_dev, nr_doc_outros, dt_inclusao_item, nr_documento_ext, vl_documento_ext, cd_pessoa_fisica, cd_cnpj, ds_observacao, dt_retirada, nm_usuario_retirada, cd_setor_atendimento, cd_setor_atend_procedencia, nr_seq_contrato, vl_hora_medico, vl_hora_hospital, nm_usuario_conf, nm_usuario_entrega_pac, cd_pessoa_receb_pac, dt_entrega_pac, nr_seq_etapa_conta, nr_guia, nr_protocolo_devolucao, nr_seq_nascimento, nm_proprietario, dt_entrada, dt_alta, ds_convenio) AS SELECT A.NR_SEQUENCIA,A.NR_SEQ_ITEM,A.DT_ATUALIZACAO,A.NM_USUARIO,A.NR_DOCUMENTO,A.DS_DOCUMENTO,A.NR_SEQ_INTERNO,A.NR_SEQ_TIPO_ITEM,A.DT_CONFERENCIA,A.DT_RECEBIMENTO,A.QT_DOCUMENTO,A.IE_DESCARTADO,A.NM_USUARIO_RECEB,A.CD_CONVENIO,A.NR_DOC_ITEM,A.NR_SEQ_MOTIVO_DEV,A.NR_DOC_OUTROS,A.DT_INCLUSAO_ITEM,A.NR_DOCUMENTO_EXT,A.VL_DOCUMENTO_EXT,A.CD_PESSOA_FISICA,A.CD_CNPJ,A.DS_OBSERVACAO,A.DT_RETIRADA,A.NM_USUARIO_RETIRADA,A.CD_SETOR_ATENDIMENTO,A.CD_SETOR_ATEND_PROCEDENCIA,A.NR_SEQ_CONTRATO,A.VL_HORA_MEDICO,A.VL_HORA_HOSPITAL,A.NM_USUARIO_CONF,A.NM_USUARIO_ENTREGA_PAC,A.CD_PESSOA_RECEB_PAC,A.DT_ENTREGA_PAC,A.NR_SEQ_ETAPA_CONTA,A.NR_GUIA,A.NR_PROTOCOLO_DEVOLUCAO,A.NR_SEQ_NASCIMENTO,
	SUBSTR(OBTER_NOME_PESSOA_FISICA(B.CD_PESSOA_FISICA, NULL),1,80) NM_PROPRIETARIO, 
	B.DT_ENTRADA, 
	B.DT_ALTA, 
	B.DS_CONVENIO 
FROM 	ATENDIMENTO_PACIENTE_V B, 
	PROTOCOLO_DOCUMENTO C, 
	PROTOCOLO_DOC_ITEM A 
WHERE A.NR_SEQUENCIA 	= C.NR_SEQUENCIA 
 AND A.NR_SEQ_INTERNO	= B.NR_ATENDIMENTO 
 AND C.IE_TIPO_PROTOCOLO	IN ('2','3') 

UNION
 
SELECT A.NR_SEQUENCIA,A.NR_SEQ_ITEM,A.DT_ATUALIZACAO,A.NM_USUARIO,A.NR_DOCUMENTO,A.DS_DOCUMENTO,A.NR_SEQ_INTERNO,A.NR_SEQ_TIPO_ITEM,A.DT_CONFERENCIA,A.DT_RECEBIMENTO,A.QT_DOCUMENTO,A.IE_DESCARTADO,A.NM_USUARIO_RECEB,A.CD_CONVENIO,A.NR_DOC_ITEM,A.NR_SEQ_MOTIVO_DEV,A.NR_DOC_OUTROS,A.DT_INCLUSAO_ITEM,A.NR_DOCUMENTO_EXT,A.VL_DOCUMENTO_EXT,A.CD_PESSOA_FISICA,A.CD_CNPJ,A.DS_OBSERVACAO,A.DT_RETIRADA,A.NM_USUARIO_RETIRADA,A.CD_SETOR_ATENDIMENTO,A.CD_SETOR_ATEND_PROCEDENCIA,A.NR_SEQ_CONTRATO,A.VL_HORA_MEDICO,A.VL_HORA_HOSPITAL,A.NM_USUARIO_CONF,A.NM_USUARIO_ENTREGA_PAC,A.CD_PESSOA_RECEB_PAC,A.DT_ENTREGA_PAC,A.NR_SEQ_ETAPA_CONTA,A.NR_GUIA,A.NR_PROTOCOLO_DEVOLUCAO,A.NR_SEQ_NASCIMENTO, 
	SUBSTR(OBTER_RAZAO_SOCIAL(B.CD_CGC_EMITENTE),1,80) NM_PROPRIETARIO, 
	B.DT_EMISSAO DT_ENTRADA, 
	B.DT_ENTRADA_SAIDA DT_ALTA, 
	'' DS_CONVENIO 
FROM 	NOTA_FISCAL B, 
	PROTOCOLO_DOCUMENTO C, 
	PROTOCOLO_DOC_ITEM A 
WHERE A.NR_SEQUENCIA 	= C.NR_SEQUENCIA 
 AND A.NR_SEQ_INTERNO	= B.NR_SEQUENCIA 
 AND C.IE_TIPO_PROTOCOLO	= '1' 

UNION
 
SELECT A.NR_SEQUENCIA,A.NR_SEQ_ITEM,A.DT_ATUALIZACAO,A.NM_USUARIO,A.NR_DOCUMENTO,A.DS_DOCUMENTO,A.NR_SEQ_INTERNO,A.NR_SEQ_TIPO_ITEM,A.DT_CONFERENCIA,A.DT_RECEBIMENTO,A.QT_DOCUMENTO,A.IE_DESCARTADO,A.NM_USUARIO_RECEB,A.CD_CONVENIO,A.NR_DOC_ITEM,A.NR_SEQ_MOTIVO_DEV,A.NR_DOC_OUTROS,A.DT_INCLUSAO_ITEM,A.NR_DOCUMENTO_EXT,A.VL_DOCUMENTO_EXT,A.CD_PESSOA_FISICA,A.CD_CNPJ,A.DS_OBSERVACAO,A.DT_RETIRADA,A.NM_USUARIO_RETIRADA,A.CD_SETOR_ATENDIMENTO,A.CD_SETOR_ATEND_PROCEDENCIA,A.NR_SEQ_CONTRATO,A.VL_HORA_MEDICO,A.VL_HORA_HOSPITAL,A.NM_USUARIO_CONF,A.NM_USUARIO_ENTREGA_PAC,A.CD_PESSOA_RECEB_PAC,A.DT_ENTREGA_PAC,A.NR_SEQ_ETAPA_CONTA,A.NR_GUIA,A.NR_PROTOCOLO_DEVOLUCAO,A.NR_SEQ_NASCIMENTO, 
	'' NM_PROPRIETARIO, 
	LOCALTIMESTAMP DT_ENTRADA, 
	LOCALTIMESTAMP DT_ALTA, 
	'' DS_CONVENIO 
FROM 	PROTOCOLO_DOCUMENTO C, 
	PROTOCOLO_DOC_ITEM A 
WHERE A.NR_SEQUENCIA 	= C.NR_SEQUENCIA 
 AND C.IE_TIPO_PROTOCOLO	= '4';

