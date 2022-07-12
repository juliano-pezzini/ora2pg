-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';

CREATE OR REPLACE VIEW pls_desconto_folha_poder_jud_v (tp_registro, dt_competencia, cd_matricula_8, cd_matricula_12, vl_incluir, vl_excluir, ie_contrato_novo, cd_profissao, identificador1, ie_tipo_alteracao, tp_movimento, ie_tipo_movimentacao) AS select	max(1)				TP_REGISTRO,
	max(dt_geracao)			DT_COMPETENCIA,
	null				CD_MATRICULA_8,
	null				CD_MATRICULA_12,
	null				VL_INCLUIR,
	null				VL_EXCLUIR,
	null				IE_CONTRATO_NOVO,
	null				CD_PROFISSAO,
	null				IDENTIFICADOR1,
	null				IE_TIPO_ALTERACAO,
	CASE WHEN max(ie_tipo_alteracao)='E' THEN 'CAC'  ELSE 'CCD' END  TP_MOVIMENTO,
	null				IE_TIPO_MOVIMENTACAO
FROM	w_pls_desconto_folha

union

select	2				TP_REGISTRO,
	null				DT_COMPETENCIA,
	substr(cd_matricula,1,8)	CD_MATRICULA_8,
	substr(cd_matricula,1,12)	CD_MATRICULA_12,
	obter_Valor_sem_virgula(vl_incluir) VL_INCLUIR,
	obter_Valor_sem_virgula(vl_excluir) VL_EXCLUIR,
	ie_contrato_novo		IE_CONTRATO_NOVO,
	cd_profissao			CD_PROFISSAO,
	CASE WHEN cd_profissao=100633 THEN 'TJE' WHEN cd_profissao=100632 THEN 'TJM'  ELSE 'X' END 	IDENTIFICADOR1,
	ie_tipo_alteracao		IE_TIPO_ALTERACAO,
	null				TP_MOVIMENTO,
	ie_tipo_movimentacao		IE_TIPO_MOVIMENTACAO
from	w_pls_desconto_folha

union all

select	max(3)				TP_REGISTRO,
	null				DT_COMPETENCIA,
	null				CD_MATRICULA_8,
	null				CD_MATRICULA_12,
	null				VL_INCLUIR,
	null				VL_EXCLUIR,
	null				IE_CONTRATO_NOVO,
	null				CD_PROFISSAO,
	null				IDENTIFICADOR1,
	null				IE_TIPO_ALTERACAO,
	null				TP_MOVIMENTO,
	null				IE_TIPO_MOVIMENTACAO
from	w_pls_desconto_folha;
