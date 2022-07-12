-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';

CREATE OR REPLACE VIEW conta_paciente_desconto_v2 (nr_sequencia, nr_interno_conta, dt_desconto, ie_tipo_desconto, dt_atualizacao, nm_usuario, vl_conta, pr_desconto, vl_desconto, vl_liquido, dt_calculo, dt_atualizacao_nrec, nm_usuario_nrec, ds_observacao, cd_centro_custo, nr_seq_motivo_desc, cd_pessoa_solicitante, cd_cgc_solicitante, ie_pacote, dt_liberacao, nm_usuario_lib, cd_pessoa_autorizador, ie_emite_conta) AS select	a.NR_SEQUENCIA,a.NR_INTERNO_CONTA,a.DT_DESCONTO,a.IE_TIPO_DESCONTO,a.DT_ATUALIZACAO,a.NM_USUARIO,a.VL_CONTA,a.PR_DESCONTO,a.VL_DESCONTO,a.VL_LIQUIDO,a.DT_CALCULO,a.DT_ATUALIZACAO_NREC,a.NM_USUARIO_NREC,a.DS_OBSERVACAO,a.CD_CENTRO_CUSTO,a.NR_SEQ_MOTIVO_DESC,a.CD_PESSOA_SOLICITANTE,a.CD_CGC_SOLICITANTE,a.IE_PACOTE,a.DT_LIBERACAO,a.NM_USUARIO_LIB,a.CD_PESSOA_AUTORIZADOR,
	'22' ie_emite_conta
FROM	conta_paciente_desconto a;

