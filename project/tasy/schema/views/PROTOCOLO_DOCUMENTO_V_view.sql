-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';

CREATE OR REPLACE VIEW protocolo_documento_v (nr_sequencia, dt_envio, nm_usuario_envio, ie_tipo_protocolo, dt_atualizacao, nm_usuario, cd_pessoa_origem, cd_setor_origem, cd_pessoa_destino, cd_setor_destino, cd_cgc_destino, dt_rec_destino, nm_usuario_receb, ds_obs, dt_fechamento, dt_cancelamento, nm_usuario_canc, ie_forma_armazenamento, ds_forma_recuperacao, ds_forma_protecao, ie_forma_descarte, qt_tempo_retencao, ie_tempo_retencao, dt_descarte, nm_usuario_descarte, ie_forma_descarte_real, ds_controle, dt_devolucao, nr_seq_protocolo_dev, cd_estabelecimento, ie_status_protocolo, nr_seq_tipo_doc_item, dt_atualizacao_nrec, nm_usuario_nrec, ie_destino_remessa, nr_seq_protocolo_origem, ds_tipo_protocolo, ds_setor_origem, ds_setor_destino, nm_pessoa_origem, nm_pessoa_destino, ds_razao_social_destino) AS SELECT A.NR_SEQUENCIA,A.DT_ENVIO,A.NM_USUARIO_ENVIO,A.IE_TIPO_PROTOCOLO,A.DT_ATUALIZACAO,A.NM_USUARIO,A.CD_PESSOA_ORIGEM,A.CD_SETOR_ORIGEM,A.CD_PESSOA_DESTINO,A.CD_SETOR_DESTINO,A.CD_CGC_DESTINO,A.DT_REC_DESTINO,A.NM_USUARIO_RECEB,A.DS_OBS,A.DT_FECHAMENTO,A.DT_CANCELAMENTO,A.NM_USUARIO_CANC,A.IE_FORMA_ARMAZENAMENTO,A.DS_FORMA_RECUPERACAO,A.DS_FORMA_PROTECAO,A.IE_FORMA_DESCARTE,A.QT_TEMPO_RETENCAO,A.IE_TEMPO_RETENCAO,A.DT_DESCARTE,A.NM_USUARIO_DESCARTE,A.IE_FORMA_DESCARTE_REAL,A.DS_CONTROLE,A.DT_DEVOLUCAO,A.NR_SEQ_PROTOCOLO_DEV,A.CD_ESTABELECIMENTO,A.IE_STATUS_PROTOCOLO,A.NR_SEQ_TIPO_DOC_ITEM,A.DT_ATUALIZACAO_NREC,A.NM_USUARIO_NREC,A.IE_DESTINO_REMESSA,A.NR_SEQ_PROTOCOLO_ORIGEM,
	B.DS_VALOR_DOMINIO DS_TIPO_PROTOCOLO, 
	OBTER_NOME_SETOR(A.CD_SETOR_ORIGEM) DS_SETOR_ORIGEM, 
	OBTER_NOME_SETOR(A.CD_SETOR_DESTINO) DS_SETOR_DESTINO, 
	OBTER_NOME_PESSOA_FISICA(A.CD_PESSOA_ORIGEM,'') NM_PESSOA_ORIGEM, 
	OBTER_NOME_PESSOA_FISICA(A.CD_PESSOA_DESTINO,'') NM_PESSOA_DESTINO, 
	OBTER_RAZAO_SOCIAL(A.CD_CGC_DESTINO) DS_RAZAO_SOCIAL_DESTINO 
FROM protocolo_documento a
LEFT OUTER JOIN valor_dominio b ON (A.IE_TIPO_PROTOCOLO = B.VL_DOMINIO)
WHERE B.CD_DOMINIO		= 1047;

