-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';

CREATE OR REPLACE VIEW eis_indicador_setor_v (cd_estab, cd_u_b, cd_u_c, dt_ref, cd_setor_atendimento, cd_setor, ds_setor, ie_periodo, cd_classif_setor, nr_u_setor, qt_disp, qt_ind, nr_leitos_ocup, nr_le_oc, nr_lto_liv, nr_adm, nr_altas, nr_obitos, nr_transf_entrada, nr_transf_saida, nr_dias_periodo, ie_ocup_hosp, ie_temp, ie_situacao, nr_u_temp, nr_u_ocup, qt_u_acomp, nr_u_interd, nr_u_int, nr_u_livres, nr_u_hig, nr_u_reserv, qt_u_isol, qt_u_alta, nr_u_t_ocup, cd_tipo_acomod, cd_conv) AS SELECT 	A.cd_estabelecimento cd_estab,
		A.cd_unidade_basica cd_u_b,
		A.cd_unidade_compl cd_u_c,
		A.DT_REFERENCIA dt_ref,
		A.CD_SETOR_ATENDIMENTO,
		A.CD_SETOR_ATENDIMENTO cd_setor,
 		S.DS_SETOR_ATENDIMENTO ds_setor,
		A.IE_PERIODO,
		S.CD_CLASSIF_SETOR,
		(sum(CASE WHEN A.IE_SITUACAO='P' THEN NR_PACIENTES  ELSE 1 END )) NR_U_SETOR,
		-- Troquei as duas linhas abaixo pela linha acima em 11/02/2008 - Com Ricardo
		--(sum(DECODE(a.IE_SITUACAO,'P',NR_PACIENTES,0)) +
		--		max(DECODE(a.IE_SITUACAO,'L',1,decode(a.IE_SITUACAO, 'I', 1, 0)))) NR_UNIDADES_SETOR,
		--dividir(SUM(decode(Obter_Se_Leito_Disp(a.cd_setor_atendimento, a.cd_unidade_basica, a.cd_unidade_compl), 'S', 1, 0)),2) qt_disponiveis,
		--Troquei pela linha abaixo
		SUM(CASE WHEN Obter_Se_Leito_Disp_periodo(A.cd_setor_atendimento, A.cd_unidade_basica, A.cd_unidade_compl,A.dt_referencia)='S' THEN  1  ELSE 0 END ) qt_disp,
		SUM(CASE WHEN Obter_Se_Leito_Disp_periodo(A.cd_setor_atendimento, A.cd_unidade_basica, A.cd_unidade_compl,A.dt_referencia)='N' THEN  1  ELSE 0 END ) qt_ind,
		CASE WHEN Obter_Se_Unidade_Temp(A.cd_setor_atendimento, A.dt_referencia, A.cd_unidade_basica, A.cd_unidade_compl)='N' THEN 	        	sum(CASE WHEN A.IE_SITUACAO='P' THEN NR_PACIENTES  ELSE 0 END )  ELSE sum(CASE WHEN A.cd_pessoa_fisica IS NULL THEN  0  ELSE NR_PACIENTES END ) END  NR_LEITOS_OCUP,
		CASE WHEN Obter_Se_Unidade_Temp(A.cd_setor_atendimento, A.dt_referencia, A.cd_unidade_basica, A.cd_unidade_compl)='N' THEN 	        	sum(CASE WHEN A.IE_SITUACAO='P' THEN NR_PACIENTES  ELSE 0 END )  ELSE sum(CASE WHEN A.cd_pessoa_fisica IS NULL THEN  0  ELSE NR_PACIENTES END ) END  NR_LE_OC,
		CASE WHEN Obter_Se_Unidade_Temp(A.cd_setor_atendimento, A.dt_referencia, A.cd_unidade_basica, A.cd_unidade_compl)='N' THEN 	        	sum(CASE WHEN obter_dados_param_atend(A.cd_estabelecimento,'LI')='S' THEN 				CASE WHEN A.cd_pessoa_fisica IS NULL THEN  1  ELSE CASE WHEN A.IE_SITUACAO='L' THEN nr_pacientes  ELSE 0 END  END   ELSE CASE WHEN A.IE_SITUACAO='I' THEN 0  ELSE CASE WHEN A.cd_pessoa_fisica IS NULL THEN  1  ELSE CASE WHEN A.IE_SITUACAO='L' THEN nr_pacientes  ELSE 0 END  END  END  END )  ELSE --sum(decode(a.cd_pessoa_fisica, null, 1, DECODE(a.IE_SITUACAO,'L',1,0))), Dalcastagne em 11/06/2008 - Mudei pela linha acima OS 92512
			sum(CASE WHEN A.cd_pessoa_fisica IS NULL THEN  1  ELSE 0 END ) END  NR_Lto_Liv,
        	SUM(NR_ADMISSOES) NR_ADM,
        	SUM(NR_ALTAS) NR_ALTAS,
        	SUM(NR_OBITOS) NR_OBITOS,
        	SUM(NR_TRANSF_ENTRADA) NR_TRANSF_ENTRADA,
        	SUM(NR_TRANSF_SAIDA)  NR_TRANSF_SAIDA,
       	avg(CASE WHEN A.IE_PERIODO='M' THEN  (TO_CHAR(LAST_DAY(A.DT_REFERENCIA),'DD'))::numeric   ELSE 1 END ) NR_DIAS_PERIODO,
		coalesce(ie_ocup_hospitalar,'S') ie_ocup_Hosp,
		substr(Obter_Se_Unidade_Temp(A.cd_setor_atendimento, A.dt_referencia, A.cd_unidade_basica, A.cd_unidade_compl),1,1) ie_temp,
		A.IE_SITUACAO,
		sum(CASE WHEN Obter_Se_Unidade_Temp(A.cd_setor_atendimento, A.dt_referencia, A.cd_unidade_basica, A.cd_unidade_compl)='S' THEN  1  ELSE 0 END )
nr_u_temp,
		sum(CASE WHEN A.ie_situacao='P' THEN  1  ELSE 0 END ) nr_u_ocup,
		sum(CASE WHEN A.ie_situacao='M' THEN  1  ELSE 0 END ) qt_u_acomp,
		sum(CASE WHEN A.ie_situacao='I' THEN  1  ELSE 0 END ) nr_u_interd,
		sum(CASE WHEN A.ie_situacao='I' THEN  1  ELSE 0 END ) nr_u_int, -- mesmo campo que o que está acima, mas com alias menor para caber no select do Subindicador Setor do Censo
		sum(CASE WHEN A.ie_situacao='L' THEN  1  ELSE 0 END ) nr_u_livres,
		sum(CASE WHEN A.ie_situacao='H' THEN  1  ELSE 0 END ) nr_u_hig,
		sum(CASE WHEN A.ie_situacao='R' THEN  1  ELSE 0 END ) nr_u_reserv,
		sum(CASE WHEN A.ie_situacao='O' THEN  1  ELSE 0 END ) qt_u_isol,
		sum(CASE WHEN A.ie_situacao='A' THEN  1  ELSE 0 END ) qt_u_alta,
		sum(CASE WHEN Obter_Se_Unidade_Temp(A.cd_setor_atendimento, A.dt_referencia, A.cd_unidade_basica, A.cd_unidade_compl)='S' THEN CASE WHEN A.ie_situacao='P' THEN  1  ELSE 0 END   ELSE 0 END ) nr_u_t_ocup,
		A.cd_tipo_acomodacao cd_tipo_acomod,
		A.cd_convenio cD_conv
FROM   		SETOR_ATENDIMENTO S,
        	EIS_OCUPACAO_HOSPITALAR A
WHERE 		A.CD_SETOR_ATENDIMENTO = S.CD_SETOR_ATENDIMENTO
GROUP BY 	A.cd_estabelecimento,
		A.DT_REFERENCIA,
		A.cd_unidade_basica,
		A.cd_unidade_compl,
		A.CD_SETOR_ATENDIMENTO,
	       	S.DS_SETOR_ATENDIMENTO,
		A.IE_PERIODO,
		S.CD_CLASSIF_SETOR,
		A.cd_tipo_acomodacao,
		A.ie_temp,
		coalesce(ie_ocup_hospitalar,'S'),
		A.IE_SITUACAO,
		A.cd_convenio;

