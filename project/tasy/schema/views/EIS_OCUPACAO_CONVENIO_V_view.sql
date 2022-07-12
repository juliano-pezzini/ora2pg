-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';

CREATE OR REPLACE VIEW eis_ocupacao_convenio_v (cd_estabelecimento, dt_referencia, cd_convenio, ds_convenio, nr_unidades_setor, qt_disponiveis, nr_leitos_ocupados, nr_leitos_livres, nr_admissoes, nr_altas, nr_obitos, nr_transf_entrada, nr_transf_saida, nr_dias_periodo, cd_medico, nm_medico, ie_periodo, cd_setor_atendimento, ie_clinica, ie_tipo_atendimento, ie_clinica_alta, nr_seq_origem, ie_sexo, cd_cid_principal, ie_tipo_convenio, cd_especialidade, qt_hora_alta, cd_procedencia, cd_tipo_acomodacao, hr_alta, cd_unidade_basica, cd_unidade_compl, ie_situacao, ie_temp) AS SELECT 	A.cd_estabelecimento,
		A.DT_REFERENCIA,
		A.CD_convenio,
		substr(obter_nome_convenio(cd_convenio),1,60) ds_convenio,
				(sum(CASE WHEN A.IE_SITUACAO='P' THEN NR_PACIENTES  ELSE 0 END ) +
				max(CASE WHEN A.IE_SITUACAO='L' THEN 1  ELSE CASE WHEN A.IE_SITUACAO='I' THEN  1  ELSE 0 END  END )) NR_UNIDADES_SETOR,
		sum(CASE WHEN Obter_Se_Leito_Disp(A.cd_setor_atendimento, A.cd_unidade_basica, A.cd_unidade_compl)='S' THEN  1  ELSE 0 END ) qt_disponiveis,
		CASE WHEN Obter_Se_Unidade_Temp(A.cd_setor_atendimento, A.dt_referencia, A.cd_unidade_basica, A.cd_unidade_compl)='N' THEN 	        	sum(CASE WHEN A.IE_SITUACAO='P' THEN NR_PACIENTES  ELSE 0 END )  ELSE sum(CASE WHEN A.cd_pessoa_fisica IS NULL THEN  0  ELSE NR_PACIENTES END ) END  NR_LEITOS_OCUPADOS,
		SUM(coalesce(QT_LEITO_LIVRE,0)) NR_LEITOS_Livres,
        	SUM(NR_ADMISSOES) NR_ADMISSOES,
        	SUM(NR_ALTAS) NR_ALTAS,
        	SUM(NR_OBITOS) NR_OBITOS,
        	SUM(NR_TRANSF_ENTRADA) NR_TRANSF_ENTRADA,
        	SUM(NR_TRANSF_SAIDA)  NR_TRANSF_SAIDA,
       		avg(CASE WHEN A.IE_PERIODO='M' THEN  (TO_CHAR(LAST_DAY(A.DT_REFERENCIA),'DD'))::numeric   ELSE 1 END ) NR_DIAS_PERIODO,
		A.cd_medico,
		obter_nome_medico(A.cd_medico, 'N') nm_medico,
		A.ie_periodo,
		A.cd_setor_atendimento,
		A.ie_clinica,
		A.ie_tipo_atendimento,
		A.ie_clinica_alta,
		A.nr_seq_origem,
		A.ie_sexo ie_sexo,
		A.cd_cid_principal,
		A.ie_tipo_convenio ie_tipo_convenio,
		A.cd_espec_medico cd_especialidade,
		to_char(A.hr_alta,'00') qt_hora_alta,
		A.cd_procedencia,
		A.cd_tipo_acomodacao,
		A.hr_alta,
		A.cd_unidade_basica,
		A.cd_unidade_compl,
		A.IE_SITUACAO,
		A.ie_leito_temp ie_temp
FROM   		EIS_OCUPACAO_HOSPITALAR A
GROUP BY 	A.cd_estabelecimento,
		A.DT_REFERENCIA,
		A.CD_convenio,
		A.cd_convenio,
		A.cd_medico,
		A.cd_medico,
		A.ie_periodo,
		A.cd_setor_atendimento,
		A.ie_clinica,
		A.ie_tipo_atendimento,
		A.ie_clinica_alta,
		A.nr_seq_origem,
		A.ie_sexo,
		A.cd_cid_principal,
		A.ie_tipo_convenio,
		A.cd_espec_medico,
		to_char(A.hr_alta,'00'),
		A.cd_procedencia,
		A.cd_tipo_acomodacao,
		A.hr_alta,
		A.cd_unidade_basica,
		A.cd_unidade_compl,
		A.IE_SITUACAO,
		A.ie_leito_temp;

