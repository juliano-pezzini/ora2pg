-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';

CREATE OR REPLACE VIEW pls_atendimento_v (nr_sequencia, cd_pessoa_fisica, cd_estabelecimento, ie_origem_atendimento, ie_tipo_pessoa, ie_tipo_ocorrencia, dt_inicio, dt_atualizacao, nm_usuario, dt_atualizacao_nrec, nm_usuario_nrec, dt_fim_atendimento, nr_seq_evento, cd_cgc, nr_seq_regra_tempo, nr_seq_segurado, nr_seq_contrato, nr_seq_pagador, nr_seq_prestador, ie_status, dt_conclusao, nm_contato, nr_telefone, nr_seq_congenere, ie_tipo_atendimento, nr_seq_operador, ds_historico_atend_chat, nr_seq_motivo_conclusao, ds_diretorio_arquivo, ie_estagio, nr_seq_lote_notif, cd_setor_atendimento, nr_seq_agente_motivador, nr_protocolo_atendimento, nr_seq_auditoria, nr_seq_tipo_ocorrencia, nr_seq_evento_atend) AS select	a.NR_SEQUENCIA,a.CD_PESSOA_FISICA,a.CD_ESTABELECIMENTO,a.IE_ORIGEM_ATENDIMENTO,a.IE_TIPO_PESSOA,a.IE_TIPO_OCORRENCIA,a.DT_INICIO,a.DT_ATUALIZACAO,a.NM_USUARIO,a.DT_ATUALIZACAO_NREC,a.NM_USUARIO_NREC,a.DT_FIM_ATENDIMENTO,a.NR_SEQ_EVENTO,a.CD_CGC,a.NR_SEQ_REGRA_TEMPO,a.NR_SEQ_SEGURADO,a.NR_SEQ_CONTRATO,a.NR_SEQ_PAGADOR,a.NR_SEQ_PRESTADOR,a.IE_STATUS,a.DT_CONCLUSAO,a.NM_CONTATO,a.NR_TELEFONE,a.NR_SEQ_CONGENERE,a.IE_TIPO_ATENDIMENTO,a.NR_SEQ_OPERADOR,a.DS_HISTORICO_ATEND_CHAT,a.NR_SEQ_MOTIVO_CONCLUSAO,a.DS_DIRETORIO_ARQUIVO,a.IE_ESTAGIO,a.NR_SEQ_LOTE_NOTIF,a.CD_SETOR_ATENDIMENTO,a.NR_SEQ_AGENTE_MOTIVADOR,a.NR_PROTOCOLO_ATENDIMENTO,a.NR_SEQ_AUDITORIA,
	b.nr_seq_tipo_ocorrencia nr_seq_tipo_ocorrencia,
	b.nr_seq_evento nr_seq_evento_atend
FROM	pls_atendimento_evento	b,
	pls_atendimento		a
where	b.nr_seq_atendimento = a.nr_sequencia;
