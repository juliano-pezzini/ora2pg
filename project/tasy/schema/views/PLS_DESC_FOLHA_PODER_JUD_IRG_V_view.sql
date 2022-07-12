-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';

CREATE OR REPLACE VIEW pls_desc_folha_poder_jud_irg_v (tp_registro, tp_registro_v, ds_zeros, cd_consignante, cd_consignatoria, dt_competencia, nr_seq_desconto, nr_seq_vinculo, nr_seq_pensionista, ds_especie, nr_contrato, vl_incluir, vl_excluir, tp_movimento, ie_tipo_movimentacao) AS select	max(1)							TP_REGISTRO,
	'H'							TP_REGISTRO_V,
	0							DS_ZEROS,
	'IRG'							CD_CONSIGNANTE,
	627							CD_CONSIGNATORIA,
	max(a.dt_geracao)					DT_COMPETENCIA,
	null							NR_SEQ_DESCONTO,
	null							NR_SEQ_VINCULO,
	null							NR_SEQ_PENSIONISTA,
	null							DS_ESPECIE,
	null							NR_CONTRATO,
	null							VL_INCLUIR,
	null							VL_EXCLUIR,
	CASE WHEN max(a.ie_tipo_alteracao)='E' THEN 'CAC'  ELSE 'CCD' END  	TP_MOVIMENTO,
	null							IE_TIPO_MOVIMENTACAO
FROM	w_pls_desconto_folha	a,
	cobranca_escritural	b
where	a.nr_seq_cobranca 	= b.nr_sequencia

union

select	2							TP_REGISTRO,
	'D'							TP_REGISTRO_V,
	0							DS_ZEROS,
	null 							CD_CONSIGNANTE,
	null							CD_CONSIGNATORIA,
	dt_geracao						DT_COMPETENCIA,
	substr(a.nr_sequencia,1,8)				NR_SEQ_DESCONTO,
(	select 	substr(c.nr_sequencia,1,2)
	from 	pls_empresa_vinculo	c
	where	b.nr_seq_empresa = c.nr_seq_empresa)		NR_SEQ_VINCULO,
	00							NR_SEQ_PENSIONISTA,
	'MENSALIDADE'						DS_ESPECIE,
(	select	'CTR-' || e.nr_contrato
	from 	pls_contrato_pagador	d,
		pls_contrato		e
	where	a.nr_seq_pagador = d.nr_sequencia
	and	d.nr_seq_contrato = e.nr_sequencia)		NR_CONTRATO,
	obter_Valor_sem_virgula(a.vl_incluir) 			VL_INCLUIR,
	obter_Valor_sem_virgula(a.vl_excluir) 			VL_EXCLUIR,
	null							TP_MOVIMENTO,
	ie_tipo_movimentacao					IE_TIPO_MOVIMENTACAO
from	w_pls_desconto_folha	a,
	cobranca_escritural	b
where	a.nr_seq_cobranca 	= b.nr_sequencia

union all

select	max(3)							TP_REGISTRO,
	null							TP_REGISTRO_V,
	null							DS_ZEROS,
	null 							CD_CONSIGNANTE,
	null							CD_CONSIGNATORIA,
	null							DT_COMPETENCIA,
	null							NR_SEQ_DESCONTO,
	null							NR_SEQ_VINCULO,
	null							NR_SEQ_PENSIONISTA,
	null							DS_ESPECIE,
	null							NR_CONTRATO,
	null							VL_INCLUIR,
	null							VL_EXCLUIR,
	null							TP_MOVIMENTO,
	null							IE_TIPO_MOVIMENTACAO
from	w_pls_desconto_folha;
