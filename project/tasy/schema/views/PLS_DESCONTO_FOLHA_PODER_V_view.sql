-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';

CREATE OR REPLACE VIEW pls_desconto_folha_poder_v (tp_registro, dt_competencia, cd_matricula_8, cd_matricula_12, cd_matricula_11, vl_incluir, vl_excluir, ie_contrato_novo, cd_profissao, identificador1, nr_seq_contrato, tp_movimento, ds_zeros) AS select	max(1)				TP_REGISTRO,
	max(dt_geracao)			DT_COMPETENCIA,
	null				CD_MATRICULA_8,
	null				CD_MATRICULA_12,
	null				CD_MATRICULA_11,
	null				VL_INCLUIR,
	null				VL_EXCLUIR,
	null				IE_CONTRATO_NOVO,
	cd_profissao			CD_PROFISSAO,
	CASE WHEN cd_profissao=100633 THEN 'TJE' WHEN cd_profissao=100632 THEN 'TJM'  ELSE 'X' END 	IDENTIFICADOR1,
	null				NR_SEQ_CONTRATO,
	null				TP_MOVIMENTO,
	null				DS_ZEROS
FROM	w_pls_desconto_folha
where	cd_profissao in (100633, 100632)
group by cd_profissao

union

select	2				TP_REGISTRO,
	null				DT_COMPETENCIA,
	substr(cd_matricula,1,8)	CD_MATRICULA_8,
	substr(cd_matricula,1,12)	CD_MATRICULA_12,
	substr(cd_matricula,1,11)	CD_MATRICULA_11,
	obter_Valor_sem_virgula(vl_incluir) VL_INCLUIR,
	obter_Valor_sem_virgula(vl_excluir) VL_EXCLUIR,
	ie_contrato_novo		IE_CONTRATO_NOVO,
	cd_profissao			CD_PROFISSAO,
	CASE WHEN cd_profissao=100633 THEN 'TJE' WHEN cd_profissao=100632 THEN 'TJM'  ELSE 'X' END 	IDENTIFICADOR1,
	nr_seq_pagador			NR_SEQ_CONTRATO,
	'N'				TP_MOVIMENTO,
	0				DS_ZEROS
from	w_pls_desconto_folha LIMIT 1;
