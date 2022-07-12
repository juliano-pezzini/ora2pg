-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';

CREATE OR REPLACE VIEW le_agenda_consorcio_v (nm_pessoa_fisica, dt_nascimento, nr_telefone, qt_pontuacao, nr_seq_prioridade, qt_idade, nr_identidade, ds_municipio, cd_cid, ds_doenca, cd_estabelecimento, ds_estabelecimento, cd_especialidade, ds_especialidade, dt_lista_espera, nr_sequencia, cnpj_origem, nm_estabelecimento_origem, nr_seq_regulacao, nr_seq_lista_espera_origem) AS SELECT
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
  A.NM_ESTABELECIMENTO_ORIGEM,
  A.NR_SEQ_REGULACAO,
  A.NR_SEQ_LISTA_ESPERA_ORIGEM
FROM   AGENDA_LISTA_ESPERA A
  LEFT JOIN AGENDA B
  ON A.CD_AGENDA = B.CD_AGENDA
  LEFT JOIN ESTRUTURA_ORGANIZACIONAL C
  ON  B.CD_ESTABELECIMENTO = C.CD_ESTABELECIMENTO
  LEFT JOIN AGENDA_INTEGRADA D
  ON D.NR_SEQUENCIA = A.NR_SEQ_AGENDA_INT
 WHERE A.IE_CONSORCIO = 'S'
  AND A.IE_STATUS_ESPERA = 'A'
ORDER BY A.IE_PRIORIDADE,
  A.DT_AGENDAMENTO;

