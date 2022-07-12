-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';

CREATE OR REPLACE VIEW pacote_v (nr_seq_pacote, cd_convenio, cd_proced_pacote, ie_origem_proced, ie_situacao, dt_atualizacao, nm_usuario, ds_observacao, cd_estabelecimento, dt_atualizacao_nrec, nm_usuario_nrec, ie_prioridade, ie_agendavel, ie_pacote_automatico, cd_moeda, ds_procedimento) AS select   a.NR_SEQ_PACOTE,a.CD_CONVENIO,a.CD_PROCED_PACOTE,a.IE_ORIGEM_PROCED,a.IE_SITUACAO,a.DT_ATUALIZACAO,a.NM_USUARIO,a.DS_OBSERVACAO,a.CD_ESTABELECIMENTO,a.DT_ATUALIZACAO_NREC,a.NM_USUARIO_NREC,a.IE_PRIORIDADE,a.IE_AGENDAVEL,a.IE_PACOTE_AUTOMATICO,a.CD_MOEDA,
         substr(obter_descricao_procedimento(a.cd_proced_pacote, a.ie_origem_proced),1,254) ds_procedimento
FROM     pacote a
where    a.ie_situacao     = 'A';
