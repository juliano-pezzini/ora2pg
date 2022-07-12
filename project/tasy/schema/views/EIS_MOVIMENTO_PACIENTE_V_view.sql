-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';

CREATE OR REPLACE VIEW eis_movimento_paciente_v (dt_referencia, cd_setor_atendimento, cd_unidade_basica, cd_unidade_compl, ie_clinica, cd_convenio, cd_tipo_acomodacao, ds_convenio, ds_tipo_acomodacao, ds_clinica, nm_paciente, nr_pacientes, nr_admissoes, nr_altas, nr_obitos, nr_transf_entrada, nr_transf_saida, ie_periodo) AS SELECT A.DT_REFERENCIA,
 	A.CD_SETOR_ATENDIMENTO,
 	A.CD_UNIDADE_BASICA,
 	A.CD_UNIDADE_COMPL,
 	A.IE_CLINICA,
 	A.CD_CONVENIO,
 	A.CD_TIPO_ACOMODACAO,
      V.DS_CONVENIO,
      T.DS_TIPO_ACOMODACAO,
      D.ds_valor_dominio ds_clinica,
      P.nm_pessoa_fisica nm_paciente,
 	A.NR_PACIENTES,
      A.NR_ADMISSOES,
      A.NR_ALTAS,
      A.NR_OBITOS,
      A.NR_TRANSF_ENTRADA,
      A.NR_TRANSF_SAIDA,
      A.IE_PERIODO
 FROM CONVENIO V,
      TIPO_ACOMODACAO T,
      VALOR_DOMINIO D,
      PESSOA_FISICA P,
      EIS_OCUPACAO_HOSPITALAR A
 WHERE    A.CD_PESSOA_FISICA   = P.CD_PESSOA_FISICA
      AND A.CD_CONVENIO        = V.CD_CONVENIO
      AND A.CD_TIPO_ACOMODACAO = T.CD_TIPO_ACOMODACAO
      AND A.IE_CLINICA         = D.VL_DOMINIO
      AND D.CD_DOMINIO         = 17;

