-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';

CREATE OR REPLACE VIEW med_evolucao_v (nr_sequencia, nr_atendimento, dt_atualizacao, nm_usuario, dt_evolucao, ds_evolucao, nr_seq_cliente, qt_peso, qt_variacao_peso, qt_altura_cm, qt_imc, qt_superf_corporal, qt_pa_sistolica, qt_pa_diastolica, qt_temp, qt_perimetro_cefalico, qt_ca, nr_seq_tipo_evolucao, nr_seq_pac_ginec, nr_seq_pac_pre_natal, nr_seq_pac_pre_natal_evol, nr_seq_origem, qt_freq_cardiaca, cd_pessoa_fisica, cd_medico_resp) AS SELECT A.NR_SEQUENCIA,A.NR_ATENDIMENTO,A.DT_ATUALIZACAO,A.NM_USUARIO,A.DT_EVOLUCAO,A.DS_EVOLUCAO,A.NR_SEQ_CLIENTE,A.QT_PESO,A.QT_VARIACAO_PESO,A.QT_ALTURA_CM,A.QT_IMC,A.QT_SUPERF_CORPORAL,A.QT_PA_SISTOLICA,A.QT_PA_DIASTOLICA,A.QT_TEMP,A.QT_PERIMETRO_CEFALICO,A.QT_CA,A.NR_SEQ_TIPO_EVOLUCAO,A.NR_SEQ_PAC_GINEC,A.NR_SEQ_PAC_PRE_NATAL,A.NR_SEQ_PAC_PRE_NATAL_EVOL,A.NR_SEQ_ORIGEM,A.QT_FREQ_CARDIACA,
               C.CD_PESSOA_FISICA,
               C.CD_MEDICO CD_MEDICO_RESP
FROM MED_EVOLUCAO A,
             MED_ATENDIMENTO B,
             MED_CLIENTE C
WHERE A.NR_ATENDIMENTO = B.NR_ATENDIMENTO
     AND B.NR_SEQ_CLIENTE     = C.NR_SEQUENCIA;

