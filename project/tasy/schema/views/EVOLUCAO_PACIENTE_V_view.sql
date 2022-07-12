-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';

CREATE OR REPLACE VIEW evolucao_paciente_v (table_name, dt_evolucao, ds_tipo_evolucao, cd_pessoa_fisica, nr_atendimento, nr_sequencia, ds_departamento_medico, nm_usuario) AS SELECT 'EVOLUCAO_PACIENTE'                                                                                             TABLE_NAME,
       E.DT_EVOLUCAO,
       SUBSTR(OBTER_DESCRICAO_PADRAO('TIPO_EVOLUCAO', 'DS_TIPO_EVOLUCAO', E.IE_EVOLUCAO_CLINICA), 1, 200)              DS_TIPO_EVOLUCAO,
       E.CD_PESSOA_FISICA,
       A.NR_ATENDIMENTO,
       TO_CHAR(E.CD_EVOLUCAO)                                                                                          NR_SEQUENCIA,
       OBTER_NOME_DEPARTAMENTO_MEDICO(OBTER_DEPARTAMENTO_SETOR(E.CD_SETOR_ATENDIMENTO))                                DS_DEPARTAMENTO_MEDICO,
       E.NM_USUARIO
FROM evolucao_paciente e
LEFT OUTER JOIN atendimento_paciente a ON (E.NR_ATENDIMENTO = A.NR_ATENDIMENTO)
WHERE E.DT_LIBERACAO IS NULL and E.nm_usuario= wheb_usuario_pck.get_nm_usuario AND E.IE_EVOLUCAO_CLINICA <> 'CO' GROUP BY 'EVOLUCAO_PACIENTE',
         E.DT_EVOLUCAO,
         SUBSTR(OBTER_DESCRICAO_PADRAO('TIPO_EVOLUCAO', 'DS_TIPO_EVOLUCAO', E.IE_EVOLUCAO_CLINICA), 1, 200),
         E.CD_PESSOA_FISICA,
         A.NR_ATENDIMENTO,
         TO_CHAR(E.CD_EVOLUCAO),
         OBTER_NOME_DEPARTAMENTO_MEDICO(OBTER_DEPARTAMENTO_SETOR(E.CD_SETOR_ATENDIMENTO)),
         E.NM_USUARIO

UNION

SELECT DISTINCT 'PE_PRESCRICAO'                                                                                                 TABLE_NAME,
                A.DT_PRESCRICAO,
                OBTER_DESC_EXPRESSAO(334919)                                                                                    DS_PRESCRICAO,
                E.CD_PESSOA_FISICA,
                E.NR_ATENDIMENTO,
                TO_CHAR(A.NR_SEQUENCIA)                                                                                         NR_SEQUENCIA,
                OBTER_NOME_DEPARTAMENTO_MEDICO(OBTER_DEPARTAMENTO_SETOR(OBTER_SETOR_ATENDIMENTO(E.NR_ATENDIMENTO)))             DS_DEPARTAMENTO_MEDICO,
                E.NM_USUARIO
FROM pe_prescricao a
LEFT OUTER JOIN atendimento_paciente e ON (A.NR_ATENDIMENTO = E.NR_ATENDIMENTO)
WHERE A.DT_LIBERACAO IS NULL and A.nm_usuario= wheb_usuario_pck.get_nm_usuario

UNION

SELECT 'ATEND_SUMARIO_ALTA'                                                                                            TABLE_NAME,
       E.DT_ATUALIZACAO,
       OBTER_DESC_EXPRESSAO(554542)                                                                                    DS_PRESCRICAO,
       A.CD_PESSOA_FISICA,
       A.NR_ATENDIMENTO,
       TO_CHAR(E.NR_SEQUENCIA)                                                                                         NR_SEQUENCIA,
       OBTER_NOME_DEPARTAMENTO_MEDICO(OBTER_DEPARTAMENTO_SETOR(OBTER_SETOR_ATENDIMENTO(E.NR_ATENDIMENTO)))             DS_DEPARTAMENTO_MEDICO,
       E.NM_USUARIO
FROM atend_sumario_alta e
LEFT OUTER JOIN atendimento_paciente a ON (E.NR_ATENDIMENTO = A.NR_ATENDIMENTO)
WHERE E.DT_LIBERACAO IS NULL and E.nm_usuario= wheb_usuario_pck.get_nm_usuario
 
UNION

SELECT 'ATENDIMENTO_ALTA'                                                                                              TABLE_NAME,
       E.DT_ATUALIZACAO,
       OBTER_DESC_EXPRESSAO(294900)                                                                                    DS_PRESCRICAO,
       A.CD_PESSOA_FISICA,
       A.NR_ATENDIMENTO,
       TO_CHAR(E.NR_SEQUENCIA)                                                                                         NR_SEQUENCIA,
       OBTER_NOME_DEPARTAMENTO_MEDICO(OBTER_DEPARTAMENTO_SETOR(OBTER_SETOR_ATENDIMENTO(E.NR_ATENDIMENTO)))             DS_DEPARTAMENTO_MEDICO,
       E.NM_USUARIO
FROM atendimento_alta e
LEFT OUTER JOIN atendimento_paciente a ON (E.NR_ATENDIMENTO = A.NR_ATENDIMENTO)
WHERE E.DT_LIBERACAO IS NULL and E.nm_usuario= wheb_usuario_pck.get_nm_usuario
 
UNION

SELECT 'DIAGNOSTICO_DOENCA'                                                                                            TABLE_NAME,
       E.DT_DIAGNOSTICO,
       OBTER_DESC_EXPRESSAO(303710)                                                                                    DS_PRESCRICAO,
       A.CD_PESSOA_FISICA,
       A.NR_ATENDIMENTO,
       E.CD_DOENCA                                                                                                     NR_SEQUENCIA,
       OBTER_NOME_DEPARTAMENTO_MEDICO(OBTER_DEPARTAMENTO_SETOR(OBTER_SETOR_ATENDIMENTO(E.NR_ATENDIMENTO)))             DS_DEPARTAMENTO_MEDICO,
       E.NM_USUARIO
FROM diagnostico_doenca e
LEFT OUTER JOIN atendimento_paciente a ON (E.NR_ATENDIMENTO = A.NR_ATENDIMENTO)
WHERE E.DT_LIBERACAO IS NULL and E.nm_usuario= wheb_usuario_pck.get_nm_usuario
 
UNION

SELECT 'PACIENTE_ALERGIA'                                                                                          TABLE_NAME,
       DT_REGISTRO                                                                                                 DATE_OF_REGISTRATION,
       OBTER_DESC_EXPRESSAO(331364)                                                                                DS_PRESCRICAO,
       CD_PESSOA_FISICA,
       NR_ATENDIMENTO,
       TO_CHAR(NR_SEQUENCIA)                                                                                       NR_SEQUENCIA,
       OBTER_NOME_DEPARTAMENTO_MEDICO(OBTER_DEPARTAMENTO_SETOR(OBTER_SETOR_ATENDIMENTO(NR_ATENDIMENTO)))           DS_DEPARTAMENTO_MEDICO,
       NM_USUARIO_NREC
FROM PACIENTE_ALERGIA
WHERE DT_LIBERACAO IS NULL and nm_usuario= wheb_usuario_pck.get_nm_usuario

UNION

SELECT 'PACIENTE_ANTEC_CLINICO'                                                                                    TABLE_NAME,
       DT_REGISTRO,
       OBTER_DESC_EXPRESSAO(888023)                                                                                DS_PRESCRICAO,
       CD_PESSOA_FISICA,
       NR_ATENDIMENTO,
       TO_CHAR(NR_SEQUENCIA)                                                                                       NR_SEQUENCIA,
       OBTER_NOME_DEPARTAMENTO_MEDICO(OBTER_DEPARTAMENTO_SETOR(OBTER_SETOR_ATENDIMENTO(NR_ATENDIMENTO)))           DS_DEPARTAMENTO_MEDICO,
       NM_USUARIO_NREC
FROM PACIENTE_ANTEC_CLINICO
WHERE DT_LIBERACAO IS NULL and nm_usuario= wheb_usuario_pck.get_nm_usuario

UNION

SELECT 'PACIENTE_MEDIC_USO'                                                                                        TABLE_NAME,
       DT_REGISTRO,
       OBTER_DESC_EXPRESSAO(293088)                                                                                DS_PRESCRICAO,
       CD_PESSOA_FISICA,
       NR_ATENDIMENTO,
       TO_CHAR(NR_SEQUENCIA)                                                                                       NR_SEQUENCIA,
       OBTER_NOME_DEPARTAMENTO_MEDICO(OBTER_DEPARTAMENTO_SETOR(OBTER_SETOR_ATENDIMENTO(NR_ATENDIMENTO)))           DS_DEPARTAMENTO_MEDICO,
       NM_USUARIO_NREC
FROM PACIENTE_MEDIC_USO
WHERE DT_LIBERACAO IS NULL and nm_usuario= wheb_usuario_pck.get_nm_usuario

UNION

SELECT 'PACIENTE_HABITO_VICIO'                                                                                     TABLE_NAME,
       DT_REGISTRO,
       OBTER_DESC_EXPRESSAO(888035)                                                                                DS_PRESCRICAO,
       CD_PESSOA_FISICA,
       NR_ATENDIMENTO,
       TO_CHAR(NR_SEQUENCIA)                                                                                       NR_SEQUENCIA,
       OBTER_NOME_DEPARTAMENTO_MEDICO(OBTER_DEPARTAMENTO_SETOR(OBTER_SETOR_ATENDIMENTO(NR_ATENDIMENTO)))           DS_DEPARTAMENTO_MEDICO,
       NM_USUARIO_NREC
FROM PACIENTE_HABITO_VICIO
WHERE DT_LIBERACAO IS NULL and nm_usuario= wheb_usuario_pck.get_nm_usuario

UNION

SELECT 'HISTORICO_SAUDE_INTERNACAO'                                                                                        TABLE_NAME,
       E.DT_REGISTRO,
       OBTER_DESC_EXPRESSAO(888027)                                                                                        DS_PRESCRICAO,
       E.CD_PESSOA_FISICA,
       A.NR_ATENDIMENTO,
       TO_CHAR(E.NR_SEQUENCIA)                                                                                           NR_SEQUENCIA,
       OBTER_NOME_DEPARTAMENTO_MEDICO(OBTER_DEPARTAMENTO_SETOR(OBTER_SETOR_ATENDIMENTO(MAX(NR_ATENDIMENTO))))              DS_DEPARTAMENTO_MEDICO,
       E.NM_USUARIO_NREC
FROM atendimento_paciente a
LEFT OUTER JOIN historico_saude_internacao e ON (A.CD_PESSOA_FISICA = E.CD_PESSOA_FISICA)
WHERE E.DT_LIBERACAO IS NULL and E.nm_usuario= wheb_usuario_pck.get_nm_usuario GROUP BY 'HISTORICO_SAUDE_INTERNACAO',
         DT_REGISTRO,
         OBTER_DESC_EXPRESSAO(888027),
         E.CD_PESSOA_FISICA,
         A.NR_ATENDIMENTO,
         TO_CHAR(E.NR_SEQUENCIA),
         E.NM_USUARIO_NREC

UNION

SELECT 'PACIENTE_REP_PRESCRICAO'                                                                                           TABLE_NAME,
       E.DT_ATUALIZACAO,
       OBTER_DESC_EXPRESSAO(297794)                                                                                        DS_PRESCRICAO,
       E.CD_PESSOA_FISICA,
       A.NR_ATENDIMENTO,
       TO_CHAR(E.NR_SEQUENCIA)                                                                                             NR_SEQUENCIA,
       OBTER_NOME_DEPARTAMENTO_MEDICO(OBTER_DEPARTAMENTO_SETOR(OBTER_SETOR_ATENDIMENTO(MAX(NR_ATENDIMENTO))))              DS_DEPARTAMENTO_MEDICO,
       E.NM_USUARIO_NREC
FROM atendimento_paciente a
LEFT OUTER JOIN paciente_rep_prescricao e ON (A.CD_PESSOA_FISICA = E.CD_PESSOA_FISICA)
WHERE E.DT_LIBERACAO IS NULL and E.nm_usuario= wheb_usuario_pck.get_nm_usuario GROUP BY 'PACIENTE_REP_PRESCRICAO',
         E.DT_ATUALIZACAO,
         OBTER_DESC_EXPRESSAO(297794),
         E.CD_PESSOA_FISICA,
         A.NR_ATENDIMENTO,
         TO_CHAR(E.NR_SEQUENCIA),
         E.NM_USUARIO_NREC

UNION

SELECT 'HISTORICO_SAUDE_TRATAMENTO'                                                                                        TABLE_NAME,
       E.DT_ATUALIZACAO,
       OBTER_DESC_EXPRESSAO(300463)                                                                                        DS_PRESCRICAO,
       E.CD_PESSOA_FISICA,
        A.NR_ATENDIMENTO,
       TO_CHAR(E.NR_SEQUENCIA)                                                                                             NR_SEQUENCIA,
       OBTER_NOME_DEPARTAMENTO_MEDICO(OBTER_DEPARTAMENTO_SETOR(OBTER_SETOR_ATENDIMENTO(MAX(NR_ATENDIMENTO))))              DS_DEPARTAMENTO_MEDICO,
       E.NM_USUARIO_NREC
FROM atendimento_paciente a
LEFT OUTER JOIN historico_saude_tratamento e ON (A.CD_PESSOA_FISICA = E.CD_PESSOA_FISICA)
WHERE E.DT_LIBERACAO IS NULL and E.nm_usuario= wheb_usuario_pck.get_nm_usuario GROUP BY 'HISTORICO_SAUDE_TRATAMENTO',
         E.DT_ATUALIZACAO,
         OBTER_DESC_EXPRESSAO(300463),
         E.CD_PESSOA_FISICA,
         A.NR_ATENDIMENTO,
         TO_CHAR(E.NR_SEQUENCIA),
         E.NM_USUARIO_NREC

UNION

SELECT 'PACIENTE_OCORRENCIA'                                                                                       TABLE_NAME,
       DT_REGISTRO,
       OBTER_DESC_EXPRESSAO(10651964)                                                                              DS_PRESCRICAO,
       CD_PESSOA_FISICA,
       NR_ATENDIMENTO,
       TO_CHAR(NR_SEQUENCIA)                                                                                       NR_SEQUENCIA,
       OBTER_NOME_DEPARTAMENTO_MEDICO(OBTER_DEPARTAMENTO_SETOR(OBTER_SETOR_ATENDIMENTO(NR_ATENDIMENTO)))           DS_DEPARTAMENTO_MEDICO,
       NM_USUARIO_NREC
FROM PACIENTE_OCORRENCIA
WHERE DT_LIBERACAO IS NULL and nm_usuario= wheb_usuario_pck.get_nm_usuario

UNION

SELECT 'PACIENTE_ANTEC_CLINICO'                                                                                    TABLE_NAME,
       DT_ATUALIZACAO,
       OBTER_DESC_EXPRESSAO(709477)                                                                                DS_PRESCRICAO,
       CD_PESSOA_FISICA,
       NR_ATENDIMENTO,
       TO_CHAR(NR_SEQUENCIA)                                                                                       NR_SEQUENCIA,
       OBTER_NOME_DEPARTAMENTO_MEDICO(OBTER_DEPARTAMENTO_SETOR(OBTER_SETOR_ATENDIMENTO(NR_ATENDIMENTO)))           DS_DEPARTAMENTO_MEDICO,
       NM_USUARIO_NREC
FROM PACIENTE_ANTEC_CLINICO
WHERE DT_LIBERACAO IS NULL and nm_usuario= wheb_usuario_pck.get_nm_usuario

UNION

SELECT 'PACIENTE_ACESSORIO'                                                                                                TABLE_NAME,
       E.DT_REGISTRO,
       OBTER_DESC_EXPRESSAO(283136)                                                                                        DS_PRESCRICAO,
       E.CD_PESSOA_FISICA,
       A.NR_ATENDIMENTO,
       TO_CHAR(E.NR_SEQUENCIA)                                                                                             NR_SEQUENCIA,
       OBTER_NOME_DEPARTAMENTO_MEDICO(OBTER_DEPARTAMENTO_SETOR(OBTER_SETOR_ATENDIMENTO(MAX(NR_ATENDIMENTO))))              DS_DEPARTAMENTO_MEDICO,
       E.NM_USUARIO_NREC
FROM atendimento_paciente a
LEFT OUTER JOIN paciente_acessorio e ON (A.CD_PESSOA_FISICA = E.CD_PESSOA_FISICA)
WHERE DT_LIBERACAO IS NULL and E.nm_usuario= wheb_usuario_pck.get_nm_usuario GROUP BY 'PACIENTE_ACESSORIO',
         E.DT_REGISTRO,
         OBTER_DESC_EXPRESSAO(283136),
         E.CD_PESSOA_FISICA,
         A.NR_ATENDIMENTO,
         TO_CHAR(E.NR_SEQUENCIA),
         E.NM_USUARIO_NREC

UNION

SELECT 'CIH_PAC_FAT_RISCO'                                                                                         TABLE_NAME,
       DT_REGISTRO,
       OBTER_DESC_EXPRESSAO(290020)                                                                                DS_PRESCRICAO,
       CD_PESSOA_FISICA,
       NR_ATENDIMENTO,
       TO_CHAR(NR_SEQUENCIA)                                                                                       NR_SEQUENCIA,
       OBTER_NOME_DEPARTAMENTO_MEDICO(OBTER_DEPARTAMENTO_SETOR(OBTER_SETOR_ATENDIMENTO(NR_ATENDIMENTO)))           DS_DEPARTAMENTO_MEDICO,
       NM_USUARIO_NREC
FROM CIH_PAC_FAT_RISCO E
WHERE DT_LIBERACAO IS NULL and E.nm_usuario= wheb_usuario_pck.get_nm_usuario

UNION

SELECT 'PACIENTE_HIST_SOCIAL'                                                                                                  TABLE_NAME,
       E.DT_REGISTRO,
       OBTER_DESC_EXPRESSAO(314073)                                                                                            DS_PRESCRICAO,
       E.CD_PESSOA_FISICA,
       A.NR_ATENDIMENTO,
       TO_CHAR(E.NR_SEQUENCIA)                                                                                                 NR_SEQUENCIA,
       OBTER_NOME_DEPARTAMENTO_MEDICO(OBTER_DEPARTAMENTO_SETOR(OBTER_SETOR_ATENDIMENTO(MAX(A.NR_ATENDIMENTO))))                DS_DEPARTAMENTO_MEDICO,
       E.NM_USUARIO_NREC
FROM atendimento_paciente a
LEFT OUTER JOIN paciente_hist_social e ON (A.CD_PESSOA_FISICA = E.CD_PESSOA_FISICA)
WHERE E.DT_LIBERACAO IS NULL and E.nm_usuario= wheb_usuario_pck.get_nm_usuario GROUP BY 'PACIENTE_HIST_SOCIAL',
         E.DT_REGISTRO,
         OBTER_DESC_EXPRESSAO(314073),
         E.CD_PESSOA_FISICA,
         A.NR_ATENDIMENTO,
         TO_CHAR(E.NR_SEQUENCIA),
         E.NM_USUARIO_NREC

UNION

SELECT 'PACIENTE_VACINA'                                                                                           TABLE_NAME,
       DT_ATUALIZACAO,
       OBTER_DESC_EXPRESSAO(888031)                                                                                DS_PRESCRICAO,
       CD_PESSOA_FISICA,
       NR_ATENDIMENTO,
       TO_CHAR(NR_SEQUENCIA)                                                                                       NR_SEQUENCIA,
       OBTER_NOME_DEPARTAMENTO_MEDICO(OBTER_DEPARTAMENTO_SETOR(OBTER_SETOR_ATENDIMENTO(NR_ATENDIMENTO)))           DS_DEPARTAMENTO_MEDICO,
       NM_USUARIO
FROM PACIENTE_VACINA
WHERE DT_LIBERACAO IS NULL and nm_usuario= wheb_usuario_pck.get_nm_usuario

UNION

SELECT 'PF_TIPO_DEFICIENCIA'                                                                                                   TABLE_NAME,
       E.DT_ATUALIZACAO,
       OBTER_DESC_EXPRESSAO(787605)                                                                                            DS_PRESCRICAO,
       E.CD_PESSOA_FISICA,
       A.NR_ATENDIMENTO,
       TO_CHAR(E.NR_SEQUENCIA)                                                                                                 NR_SEQUENCIA,
       OBTER_NOME_DEPARTAMENTO_MEDICO(OBTER_DEPARTAMENTO_SETOR(OBTER_SETOR_ATENDIMENTO(MAX(A.NR_ATENDIMENTO))))                DS_DEPARTAMENTO_MEDICO,
       E.NM_USUARIO_NREC
FROM atendimento_paciente a
LEFT OUTER JOIN pf_tipo_deficiencia e ON (A.CD_PESSOA_FISICA = E.CD_PESSOA_FISICA)
WHERE E.DT_LIBERACAO IS NULL and E.nm_usuario= wheb_usuario_pck.get_nm_usuario  GROUP BY 'PF_TIPO_DEFICIENCIA',
         E.DT_ATUALIZACAO,
         OBTER_DESC_EXPRESSAO(787605),
         E.CD_PESSOA_FISICA,
         A.NR_ATENDIMENTO,
         TO_CHAR(E.NR_SEQUENCIA),
         E.NM_USUARIO_NREC

UNION

SELECT 'PLS_DECLARACAO_SEGURADO'                                                                                               TABLE_NAME,
       E.DT_ATUALIZACAO,
       OBTER_DESC_EXPRESSAO(492118)                                                                                            DS_PRESCRICAO,
       E.CD_PESSOA_FISICA,
       A.NR_ATENDIMENTO,
       TO_CHAR(E.NR_SEQUENCIA)                                                                                                 NR_SEQUENCIA,
       OBTER_NOME_DEPARTAMENTO_MEDICO(OBTER_DEPARTAMENTO_SETOR(OBTER_SETOR_ATENDIMENTO(MAX(A.NR_ATENDIMENTO))))                DS_DEPARTAMENTO_MEDICO,
       E.NM_USUARIO_NREC
FROM atendimento_paciente a
LEFT OUTER JOIN pls_declaracao_segurado e ON (A.CD_PESSOA_FISICA = E.CD_PESSOA_FISICA)
WHERE E.DT_LIBERACAO IS NULL and E.nm_usuario= wheb_usuario_pck.get_nm_usuario  GROUP BY 'PLS_DECLARACAO_SEGURADO',
         E.DT_ATUALIZACAO,
         OBTER_DESC_EXPRESSAO(492118),
         E.CD_PESSOA_FISICA,
         A.NR_ATENDIMENTO,
         TO_CHAR(E.NR_SEQUENCIA),
         E.NM_USUARIO_NREC

UNION

SELECT 'PACIENTE_EXAME'                                                                                                        TABLE_NAME,
       E.DT_ATUALIZACAO,
       OBTER_DESC_EXPRESSAO(10652378)                                                                                          DS_PRESCRICAO,
       E.CD_PESSOA_FISICA,
       A.NR_ATENDIMENTO,
       TO_CHAR(E.NR_SEQUENCIA)                                                                                                 NR_SEQUENCIA,
       OBTER_NOME_DEPARTAMENTO_MEDICO(OBTER_DEPARTAMENTO_SETOR(OBTER_SETOR_ATENDIMENTO(MAX(A.NR_ATENDIMENTO))))                DS_DEPARTAMENTO_MEDICO,
       E.NM_USUARIO_NREC
FROM atendimento_paciente a
LEFT OUTER JOIN paciente_exame e ON (A.CD_PESSOA_FISICA = E.CD_PESSOA_FISICA)
WHERE E.DT_LIBERACAO IS NULL and E.nm_usuario= wheb_usuario_pck.get_nm_usuario  GROUP BY 'PACIENTE_EXAME',
         E.DT_ATUALIZACAO,
         OBTER_DESC_EXPRESSAO(10652378),
         E.CD_PESSOA_FISICA,
         A.NR_ATENDIMENTO,
         TO_CHAR(E.NR_SEQUENCIA),
         E.NM_USUARIO_NREC

UNION

SELECT 'PACIENTE_TRANSFUSAO'                                                                                                   TABLE_NAME,
       E.DT_TRANSFUSAO,
       OBTER_DESC_EXPRESSAO(300409)                                                                                            DS_PRESCRICAO,
       E.CD_PESSOA_FISICA,
       A.NR_ATENDIMENTO,
       TO_CHAR(E.NR_SEQUENCIA)                                                                                                 NR_SEQUENCIA,
       OBTER_NOME_DEPARTAMENTO_MEDICO(OBTER_DEPARTAMENTO_SETOR(OBTER_SETOR_ATENDIMENTO(MAX(A.NR_ATENDIMENTO))))                DS_DEPARTAMENTO_MEDICO,
       E.NM_USUARIO_NREC
FROM atendimento_paciente a
LEFT OUTER JOIN paciente_transfusao e ON (A.CD_PESSOA_FISICA = E.CD_PESSOA_FISICA)
WHERE E.DT_LIBERACAO IS NULL and E.nm_usuario= wheb_usuario_pck.get_nm_usuario  GROUP BY 'PACIENTE_TRANSFUSAO',
         E.DT_TRANSFUSAO,
         OBTER_DESC_EXPRESSAO(300409),
         E.CD_PESSOA_FISICA,
         A.NR_ATENDIMENTO,
         TO_CHAR(E.NR_SEQUENCIA),
         E.NM_USUARIO_NREC

UNION

SELECT 'HISTORICO_SAUDE_MULHER'                                                                                                TABLE_NAME,
       E.DT_ATUALIZACAO,
       OBTER_DESC_EXPRESSAO(314077)                                                                                            DS_PRESCRICAO,
       E.CD_PESSOA_FISICA,
       A.NR_ATENDIMENTO,
       TO_CHAR(E.NR_SEQUENCIA)                                                                                                 NR_SEQUENCIA,
       OBTER_NOME_DEPARTAMENTO_MEDICO(OBTER_DEPARTAMENTO_SETOR(OBTER_SETOR_ATENDIMENTO(MAX(A.NR_ATENDIMENTO))))                DS_DEPARTAMENTO_MEDICO,
       E.NM_USUARIO_NREC
FROM atendimento_paciente a
LEFT OUTER JOIN historico_saude_mulher e ON (A.CD_PESSOA_FISICA = E.CD_PESSOA_FISICA)
WHERE E.DT_LIBERACAO IS NULL and E.nm_usuario= wheb_usuario_pck.get_nm_usuario  GROUP BY 'HISTORICO_SAUDE_MULHER',
         E.DT_ATUALIZACAO,
         OBTER_DESC_EXPRESSAO(314077),
         E.CD_PESSOA_FISICA,
         A.NR_ATENDIMENTO,
         TO_CHAR(E.NR_SEQUENCIA),
         E.NM_USUARIO_NREC

UNION

SELECT 'PACIENTE_AMPUTACAO'                                                                                                    TABLE_NAME,
       E.DT_ATUALIZACAO,
       OBTER_DESC_EXPRESSAO(314083)                                                                                            DS_PRESCRICAO,
       E.CD_PESSOA_FISICA,
       A.NR_ATENDIMENTO,
       TO_CHAR(E.NR_SEQUENCIA)                                                                                                 NR_SEQUENCIA,
       OBTER_NOME_DEPARTAMENTO_MEDICO(OBTER_DEPARTAMENTO_SETOR(OBTER_SETOR_ATENDIMENTO(MAX(A.NR_ATENDIMENTO))))                DS_DEPARTAMENTO_MEDICO,
       E.NM_USUARIO_NREC
FROM atendimento_paciente a
LEFT OUTER JOIN paciente_amputacao e ON (A.CD_PESSOA_FISICA = E.CD_PESSOA_FISICA)
WHERE E.DT_LIBERACAO IS NULL and E.nm_usuario= wheb_usuario_pck.get_nm_usuario  GROUP BY 'PACIENTE_AMPUTACAO',
         E.DT_ATUALIZACAO,
         OBTER_DESC_EXPRESSAO(314083),
         E.CD_PESSOA_FISICA,
         A.NR_ATENDIMENTO,
         TO_CHAR(E.NR_SEQUENCIA),
         E.NM_USUARIO_NREC

UNION

SELECT 'INTERROGATORIO_APARELHO'                                                                                   TABLE_NAME,
       DT_ATUALIZACAO,
       OBTER_DESC_EXPRESSAO(887931)                                                                                DS_PRESCRICAO,
       CD_PESSOA_FISICA,
       NR_ATENDIMENTO,
       TO_CHAR(NR_SEQUENCIA)                                                                                       NR_SEQUENCIA,
       OBTER_NOME_DEPARTAMENTO_MEDICO(OBTER_DEPARTAMENTO_SETOR(OBTER_SETOR_ATENDIMENTO(NR_ATENDIMENTO)))           DS_DEPARTAMENTO_MEDICO,
       NM_USUARIO_NREC
FROM INTERROGATORIO_APARELHO
WHERE DT_LIBERACAO IS NULL and nm_usuario= wheb_usuario_pck.get_nm_usuario

UNION

SELECT 'PACIENTE_ANTEC_SEXUAIS'                                                                                    TABLE_NAME,
       DT_ATUALIZACAO,
       OBTER_DESC_EXPRESSAO(929992)                                                                                DS_PRESCRICAO,
       CD_PESSOA_FISICA,
       NR_ATENDIMENTO,
       TO_CHAR(NR_SEQUENCIA)                                                                                       NR_SEQUENCIA,
       OBTER_NOME_DEPARTAMENTO_MEDICO(OBTER_DEPARTAMENTO_SETOR(OBTER_SETOR_ATENDIMENTO(NR_ATENDIMENTO)))           DS_DEPARTAMENTO_MEDICO,
       NM_USUARIO_NREC
FROM PACIENTE_ANTEC_SEXUAIS
WHERE DT_LIBERACAO IS NULL and nm_usuario= wheb_usuario_pck.get_nm_usuario

UNION

SELECT 'HISTORICO_INFECCAO'                                                                                                    TABLE_NAME,
       E.DT_ATUALIZACAO,
       OBTER_DESC_EXPRESSAO(291904)                                                                                            DS_PRESCRICAO,
       E.CD_PESSOA_FISICA,
       A.NR_ATENDIMENTO,
       TO_CHAR(E.NR_SEQUENCIA)                                                                                                 NR_SEQUENCIA,
       OBTER_NOME_DEPARTAMENTO_MEDICO(OBTER_DEPARTAMENTO_SETOR(OBTER_SETOR_ATENDIMENTO(MAX(A.NR_ATENDIMENTO))))                DS_DEPARTAMENTO_MEDICO,
       E.NM_USUARIO_NREC
FROM atendimento_paciente a
LEFT OUTER JOIN historico_infeccao e ON (A.CD_PESSOA_FISICA = E.CD_PESSOA_FISICA)
WHERE E.DT_LIBERACAO IS NULL and E.nm_usuario= wheb_usuario_pck.get_nm_usuario  GROUP BY 'HISTORICO_INFECCAO',
         E.DT_ATUALIZACAO,
         OBTER_DESC_EXPRESSAO(291904),
         E.CD_PESSOA_FISICA,
         A.NR_ATENDIMENTO,
         TO_CHAR(E.NR_SEQUENCIA),
         E.NM_USUARIO_NREC

UNION

SELECT 'CUIDADO_LONGO_PRAZO'                                                                                                   TABLE_NAME,
       E.DT_ATUALIZACAO,
       OBTER_DESC_EXPRESSAO(1041890)                                                                                           DS_PRESCRICAO,
       E.CD_PESSOA_FISICA,
       A.NR_ATENDIMENTO,
       TO_CHAR(E.NR_SEQUENCIA)                                                                                                 NR_SEQUENCIA,
       OBTER_NOME_DEPARTAMENTO_MEDICO(OBTER_DEPARTAMENTO_SETOR(OBTER_SETOR_ATENDIMENTO(MAX(A.NR_ATENDIMENTO))))                DS_DEPARTAMENTO_MEDICO,
       E.NM_USUARIO_NREC
FROM atendimento_paciente a
LEFT OUTER JOIN cuidado_longo_prazo e ON (A.CD_PESSOA_FISICA = E.CD_PESSOA_FISICA)
WHERE E.DT_LIBERACAO IS NULL and E.nm_usuario= wheb_usuario_pck.get_nm_usuario  GROUP BY 'CUIDADO_LONGO_PRAZO',
         E.DT_ATUALIZACAO,
         OBTER_DESC_EXPRESSAO(1041890),
         E.CD_PESSOA_FISICA,
         A.NR_ATENDIMENTO,
         TO_CHAR(E.NR_SEQUENCIA),
         E.NM_USUARIO_NREC

UNION

SELECT 'CPOE_DIETA' TABLE_NAME,
       E.DT_ATUALIZACAO,
       OBTER_DESC_EXPRESSAO(608679)||'-'||OBTER_DESC_EXPRESSAO(287903) DS_PRESCRICAO,
       E.CD_PESSOA_FISICA,
       A.NR_ATENDIMENTO,
       TO_CHAR(E.NR_SEQUENCIA) NR_SEQUENCIA,
       OBTER_NOME_DEPARTAMENTO_MEDICO(OBTER_DEPARTAMENTO_SETOR(OBTER_SETOR_ATENDIMENTO(MAX(A.NR_ATENDIMENTO)))) DS_DEPARTAMENTO_MEDICO,
       E.NM_USUARIO_NREC
FROM atendimento_paciente a
LEFT OUTER JOIN cpoe_dieta e ON (A.NR_ATENDIMENTO = E.NR_ATENDIMENTO)
WHERE E.DT_LIBERACAO IS NULL and E.nm_usuario= wheb_usuario_pck.get_nm_usuario AND LOCALTIMESTAMP BETWEEN TRUNC(coalesce(E.DT_INICIO,LOCALTIMESTAMP)) AND TRUNC(FIM_DIA(coalesce(E.DT_FIM,LOCALTIMESTAMP + interval '30 days')))  GROUP BY 'CPOE_DIETA',
         E.DT_ATUALIZACAO,
         OBTER_DESC_EXPRESSAO(608679)||'-'||OBTER_DESC_EXPRESSAO(287903),
         E.CD_PESSOA_FISICA,
         A.NR_ATENDIMENTO,
         TO_CHAR(E.NR_SEQUENCIA),
         E.NM_USUARIO_NREC

UNION

SELECT 'CPOE_MATERIAL' TABLE_NAME,
       E.DT_ATUALIZACAO,
       OBTER_DESC_EXPRESSAO(608679)||'-'||OBTER_DESC_EXPRESSAO(292949) DS_PRESCRICAO,
       E.CD_PESSOA_FISICA,
       A.NR_ATENDIMENTO,
       TO_CHAR(E.NR_SEQUENCIA) NR_SEQUENCIA,
       OBTER_NOME_DEPARTAMENTO_MEDICO(OBTER_DEPARTAMENTO_SETOR(OBTER_SETOR_ATENDIMENTO(MAX(A.NR_ATENDIMENTO)))) DS_DEPARTAMENTO_MEDICO,
       E.NM_USUARIO_NREC
FROM atendimento_paciente a
LEFT OUTER JOIN cpoe_material e ON (A.NR_ATENDIMENTO = E.NR_ATENDIMENTO)
WHERE E.DT_LIBERACAO IS NULL and E.nm_usuario= wheb_usuario_pck.get_nm_usuario AND LOCALTIMESTAMP BETWEEN TRUNC(coalesce(E.DT_INICIO,LOCALTIMESTAMP)) AND TRUNC(FIM_DIA(coalesce(E.DT_FIM,LOCALTIMESTAMP + interval '30 days')))  GROUP BY 'CPOE_MATERIAL',
         E.DT_ATUALIZACAO,
         OBTER_DESC_EXPRESSAO(608679)||'-'||OBTER_DESC_EXPRESSAO(292949),
         E.CD_PESSOA_FISICA,
         A.NR_ATENDIMENTO,
         TO_CHAR(E.NR_SEQUENCIA),
         E.NM_USUARIO_NREC

UNION

SELECT 'CPOE_PROCEDIMENTO' TABLE_NAME,
       E.DT_ATUALIZACAO,
       OBTER_DESC_EXPRESSAO(608679)||'-'||OBTER_DESC_EXPRESSAO(614206) DS_PRESCRICAO,
       E.CD_PESSOA_FISICA,
       A.NR_ATENDIMENTO,
       TO_CHAR(E.NR_SEQUENCIA) NR_SEQUENCIA,
       OBTER_NOME_DEPARTAMENTO_MEDICO(OBTER_DEPARTAMENTO_SETOR(OBTER_SETOR_ATENDIMENTO(MAX(A.NR_ATENDIMENTO)))) DS_DEPARTAMENTO_MEDICO,
       E.NM_USUARIO_NREC
FROM atendimento_paciente a
LEFT OUTER JOIN cpoe_procedimento e ON (A.NR_ATENDIMENTO = E.NR_ATENDIMENTO)
WHERE E.DT_LIBERACAO IS NULL and E.nm_usuario= wheb_usuario_pck.get_nm_usuario AND LOCALTIMESTAMP BETWEEN TRUNC(coalesce(E.DT_INICIO,LOCALTIMESTAMP)) AND TRUNC(FIM_DIA(coalesce(E.DT_FIM,LOCALTIMESTAMP + interval '30 days')))  GROUP BY 'CPOE_PROCEDIMENTO',
         E.DT_ATUALIZACAO,
         OBTER_DESC_EXPRESSAO(608679)||'-'||OBTER_DESC_EXPRESSAO(614206),
         E.CD_PESSOA_FISICA,
         A.NR_ATENDIMENTO,
         TO_CHAR(E.NR_SEQUENCIA),
         E.NM_USUARIO_NREC

UNION

SELECT 'CPOE_GASOTERAPIA' TABLE_NAME,
       E.DT_ATUALIZACAO,
       OBTER_DESC_EXPRESSAO(608679)||'-'||OBTER_DESC_EXPRESSAO(290567) DS_PRESCRICAO,
       E.CD_PESSOA_FISICA,
       A.NR_ATENDIMENTO,
       TO_CHAR(E.NR_SEQUENCIA) NR_SEQUENCIA,
       OBTER_NOME_DEPARTAMENTO_MEDICO(OBTER_DEPARTAMENTO_SETOR(OBTER_SETOR_ATENDIMENTO(MAX(A.NR_ATENDIMENTO)))) DS_DEPARTAMENTO_MEDICO,
       E.NM_USUARIO_NREC
FROM atendimento_paciente a
LEFT OUTER JOIN cpoe_gasoterapia e ON (A.NR_ATENDIMENTO = E.NR_ATENDIMENTO)
WHERE E.DT_LIBERACAO IS NULL and E.nm_usuario= wheb_usuario_pck.get_nm_usuario AND LOCALTIMESTAMP BETWEEN TRUNC(coalesce(E.DT_INICIO,LOCALTIMESTAMP)) AND TRUNC(FIM_DIA(coalesce(E.DT_FIM,LOCALTIMESTAMP + interval '30 days')))  GROUP BY 'CPOE_GASOTERAPIA',
         E.DT_ATUALIZACAO,
         OBTER_DESC_EXPRESSAO(608679)||'-'||OBTER_DESC_EXPRESSAO(290567),
         E.CD_PESSOA_FISICA,
         A.NR_ATENDIMENTO,
         TO_CHAR(E.NR_SEQUENCIA),
         E.NM_USUARIO_NREC

UNION

SELECT 'CPOE_RECOMENDACAO' TABLE_NAME,
       E.DT_ATUALIZACAO,
       OBTER_DESC_EXPRESSAO(608679)||'-'||OBTER_DESC_EXPRESSAO(797205) DS_PRESCRICAO,
       E.CD_PESSOA_FISICA,
       A.NR_ATENDIMENTO,
       TO_CHAR(E.NR_SEQUENCIA) NR_SEQUENCIA,
       OBTER_NOME_DEPARTAMENTO_MEDICO(OBTER_DEPARTAMENTO_SETOR(OBTER_SETOR_ATENDIMENTO(MAX(A.NR_ATENDIMENTO)))) DS_DEPARTAMENTO_MEDICO,
       E.NM_USUARIO_NREC
FROM atendimento_paciente a
LEFT OUTER JOIN cpoe_recomendacao e ON (A.NR_ATENDIMENTO = E.NR_ATENDIMENTO)
WHERE E.DT_LIBERACAO IS NULL and E.nm_usuario= wheb_usuario_pck.get_nm_usuario AND LOCALTIMESTAMP BETWEEN TRUNC(coalesce(E.DT_INICIO,LOCALTIMESTAMP)) AND TRUNC(FIM_DIA(coalesce(E.DT_FIM,LOCALTIMESTAMP + interval '30 days')))  GROUP BY 'CPOE_RECOMENDACAO',
         E.DT_ATUALIZACAO,
         OBTER_DESC_EXPRESSAO(608679)||'-'||OBTER_DESC_EXPRESSAO(797205),
         E.CD_PESSOA_FISICA,
         A.NR_ATENDIMENTO,
         TO_CHAR(E.NR_SEQUENCIA),
         E.NM_USUARIO_NREC

UNION

SELECT 'CPOE_HEMOTERAPIA' TABLE_NAME,
       E.DT_ATUALIZACAO,
       OBTER_DESC_EXPRESSAO(608679)||'-'||OBTER_DESC_EXPRESSAO(955702) DS_PRESCRICAO,
       E.CD_PESSOA_FISICA,
       A.NR_ATENDIMENTO,
       TO_CHAR(E.NR_SEQUENCIA) NR_SEQUENCIA,
       OBTER_NOME_DEPARTAMENTO_MEDICO(OBTER_DEPARTAMENTO_SETOR(OBTER_SETOR_ATENDIMENTO(MAX(A.NR_ATENDIMENTO)))) DS_DEPARTAMENTO_MEDICO,
       E.NM_USUARIO_NREC
FROM atendimento_paciente a
LEFT OUTER JOIN cpoe_hemoterapia e ON (A.NR_ATENDIMENTO = E.NR_ATENDIMENTO)
WHERE E.DT_LIBERACAO IS NULL and E.nm_usuario= wheb_usuario_pck.get_nm_usuario AND LOCALTIMESTAMP BETWEEN TRUNC(coalesce(E.DT_INICIO,LOCALTIMESTAMP)) AND TRUNC(FIM_DIA(coalesce(E.DT_FIM,LOCALTIMESTAMP + interval '30 days')))  GROUP BY 'CPOE_HEMOTERAPIA',
         E.DT_ATUALIZACAO,
         OBTER_DESC_EXPRESSAO(608679)||'-'||OBTER_DESC_EXPRESSAO(955702),
         E.CD_PESSOA_FISICA,
         A.NR_ATENDIMENTO,
         TO_CHAR(E.NR_SEQUENCIA),
         E.NM_USUARIO_NREC

UNION

SELECT 'CPOE_DIALISE' TABLE_NAME,
       E.DT_ATUALIZACAO,
       OBTER_DESC_EXPRESSAO(608679)||'-'||OBTER_DESC_EXPRESSAO(287725) DS_PRESCRICAO,
       E.CD_PESSOA_FISICA,
       A.NR_ATENDIMENTO,
       TO_CHAR(E.NR_SEQUENCIA) NR_SEQUENCIA,
       OBTER_NOME_DEPARTAMENTO_MEDICO(OBTER_DEPARTAMENTO_SETOR(OBTER_SETOR_ATENDIMENTO(MAX(A.NR_ATENDIMENTO)))) DS_DEPARTAMENTO_MEDICO,
       E.NM_USUARIO_NREC
FROM atendimento_paciente a
LEFT OUTER JOIN cpoe_dialise e ON (A.NR_ATENDIMENTO = E.NR_ATENDIMENTO)
WHERE E.DT_LIBERACAO IS NULL and E.nm_usuario= wheb_usuario_pck.get_nm_usuario AND LOCALTIMESTAMP BETWEEN TRUNC(coalesce(E.DT_INICIO,LOCALTIMESTAMP)) AND TRUNC(FIM_DIA(coalesce(E.DT_FIM,LOCALTIMESTAMP + interval '30 days')))  GROUP BY 'CPOE_DIALISE',
         E.DT_ATUALIZACAO,
         OBTER_DESC_EXPRESSAO(608679)||'-'||OBTER_DESC_EXPRESSAO(287725),
         E.CD_PESSOA_FISICA,
         A.NR_ATENDIMENTO,
         TO_CHAR(E.NR_SEQUENCIA),
         E.NM_USUARIO_NREC

UNION

SELECT 'CPOE_INTERVENCAO' TABLE_NAME,
       E.DT_ATUALIZACAO,
       OBTER_DESC_EXPRESSAO(608679)||'-'||OBTER_DESC_EXPRESSAO(292225) DS_PRESCRICAO,
       E.CD_PESSOA_FISICA,
       A.NR_ATENDIMENTO,
       TO_CHAR(E.NR_SEQUENCIA) NR_SEQUENCIA,
       OBTER_NOME_DEPARTAMENTO_MEDICO(OBTER_DEPARTAMENTO_SETOR(OBTER_SETOR_ATENDIMENTO(MAX(A.NR_ATENDIMENTO)))) DS_DEPARTAMENTO_MEDICO,
       E.NM_USUARIO_NREC
FROM atendimento_paciente a
LEFT OUTER JOIN cpoe_intervencao e ON (A.NR_ATENDIMENTO = E.NR_ATENDIMENTO)
WHERE E.DT_LIBERACAO IS NULL and E.nm_usuario= wheb_usuario_pck.get_nm_usuario AND LOCALTIMESTAMP BETWEEN TRUNC(coalesce(E.DT_INICIO,LOCALTIMESTAMP)) AND TRUNC(FIM_DIA(coalesce(E.DT_FIM,LOCALTIMESTAMP + interval '30 days')))  GROUP BY 'CPOE_INTERVENCAO',
         E.DT_ATUALIZACAO,
         OBTER_DESC_EXPRESSAO(608679)||'-'||OBTER_DESC_EXPRESSAO(292225),
         E.CD_PESSOA_FISICA,
         A.NR_ATENDIMENTO,
         TO_CHAR(E.NR_SEQUENCIA),
         E.NM_USUARIO_NREC

UNION

SELECT 'CPOE_ANATOMIA_PATOLOGICA' TABLE_NAME,
       E.DT_ATUALIZACAO,
       OBTER_DESC_EXPRESSAO(608679)||'-'||OBTER_DESC_EXPRESSAO(314898) DS_PRESCRICAO,
       E.CD_PESSOA_FISICA,
       A.NR_ATENDIMENTO,
       TO_CHAR(E.NR_SEQUENCIA) NR_SEQUENCIA,
       OBTER_NOME_DEPARTAMENTO_MEDICO(OBTER_DEPARTAMENTO_SETOR(OBTER_SETOR_ATENDIMENTO(MAX(A.NR_ATENDIMENTO)))) DS_DEPARTAMENTO_MEDICO,
       E.NM_USUARIO_NREC
FROM atendimento_paciente a
LEFT OUTER JOIN cpoe_anatomia_patologica e ON (A.NR_ATENDIMENTO = E.NR_ATENDIMENTO)
WHERE E.DT_LIBERACAO IS NULL and E.nm_usuario= wheb_usuario_pck.get_nm_usuario AND LOCALTIMESTAMP BETWEEN TRUNC(coalesce(E.DT_INICIO,LOCALTIMESTAMP)) AND TRUNC(FIM_DIA(coalesce(E.DT_FIM,LOCALTIMESTAMP + interval '30 days')))  GROUP BY 'CPOE_ANATOMIA_PATOLOGICA',
         E.DT_ATUALIZACAO,
         OBTER_DESC_EXPRESSAO(608679)||'-'||OBTER_DESC_EXPRESSAO(314898),
         E.CD_PESSOA_FISICA,
         A.NR_ATENDIMENTO,
         TO_CHAR(E.NR_SEQUENCIA),
         E.NM_USUARIO_NREC;
