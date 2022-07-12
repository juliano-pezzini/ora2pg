-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';

CREATE OR REPLACE VIEW agendamento_cancelado_v (nm_pessoa_fisica, dt_nascimento, nr_telefone, qt_pontuacao, nr_seq_prioridade, qt_idade, nr_identidade, ds_municipio, cd_cid, ds_doenca, cd_estabelecimento, ds_estabelecimento, cd_especialidade, ds_especialidade, dt_lista_espera, nr_sequencia, cnpj_origem, nm_estabelecimento_origem, nr_seq_regulacao, nr_seq_lista_espera_origem, dt_agenda_externo, cnpj_local_agenda_externo, ds_local_agenda_externo, dt_realizacao_agenda, ds_observacao, ie_realizacao_externa) AS SELECT
  SUBSTR(OBTER_NOME_PF(A.CD_PESSOA_FISICA), 1, 255) NM_PESSOA_FISICA,
  OBTER_DATA_NASCTO_PF(A.CD_PESSOA_FISICA) DT_NASCIMENTO,
  A.NR_TELEFONE,
  OBTER_SCORE_PACIENTE(A.NR_SEQUENCIA, 'T')QT_PONTUACAO,
  A.NR_SEQ_PRIORIDADE,
  SUBSTR(OBTER_DADOS_PF(A.CD_PESSOA_FISICA,'I'), 1, 255)QT_IDADE,
  SUBSTR(OBTER_DADOS_PF(A.CD_PESSOA_FISICA, 'RG'),1,200) NR_IDENTIDADE,
  UPPER(trim(both SUBSTR(OBTER_MUNICIPIO_PF(A.CD_PESSOA_FISICA), 1, 255))) DS_MUNICIPIO,
  A.CD_CID,
  UPPER(trim(both SUBSTR(OBTER_DESCRICAO_CID(A.CD_CID), 1, 255))) DS_DOENCA,
  C.CD_ESTABELECIMENTO,
  UPPER(C.DS_CURTA) DS_ESTABELECIMENTO,
  A.CD_ESPECIALIDADE,
  UPPER(SUBSTR(OBTER_DESC_ESPEC_MEDICA(A.CD_ESPECIALIDADE),1,50)) DS_ESPECIALIDADE,
  A.DT_ATUALIZACAO_NREC DT_LISTA_ESPERA,
  A.NR_SEQUENCIA,
  A.CNPJ_ORIGEM,
  UPPER(A.NM_ESTABELECIMENTO_ORIGEM) NM_ESTABELECIMENTO_ORIGEM,
  A.NR_SEQ_REGULACAO,
  A.NR_SEQ_LISTA_ESPERA_ORIGEM,
  A.DT_AGENDA_EXTERNO,
  A.CNPJ_LOCAL_AGENDA_EXTERNO,
  UPPER(A.DS_LOCAL_AGENDA_EXTERNO) DS_LOCAL_AGENDA_EXTERNO,
  A.DT_REALIZACAO_AGENDA,
  F.DS_OBSERVACAO,
  OBTER_EXPRESSAO_SIM_NAO(CASE WHEN A.DT_AGENDA_EXTERNO IS NULL THEN  'S'  ELSE 'N' END ) IE_REALIZACAO_EXTERNA
FROM   AGENDA_LISTA_ESPERA A
  LEFT JOIN AGENDA B
  ON A.CD_AGENDA = B.CD_AGENDA
  LEFT JOIN ESTRUTURA_ORGANIZACIONAL C
  ON  B.CD_ESTABELECIMENTO = C.CD_ESTABELECIMENTO
  LEFT JOIN AG_LISTA_ESPERA_CONTATO F
  ON F.NR_SEQ_LISTA_ESPERA = A.NR_SEQUENCIA
  LEFT JOIN LISTA_ESPERA_SITUACAO_CONT G
  ON G.NR_SEQUENCIA = F.NR_SEQ_SITUACAO_ATUAL
 WHERE A.IE_STATUS_ESPERA = 'C'
ORDER BY A.IE_PRIORIDADE,
  A.DT_AGENDAMENTO;
