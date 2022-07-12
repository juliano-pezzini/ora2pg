-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';

CREATE OR REPLACE VIEW bsc_calc_indicador_v (nr_seq_indicador, nm_indicador, nr_seq_calc, nr_seq_inf, cd_estabelecimento, cd_empresa, cd_ano, cd_periodo, qt_meta, qt_real, qt_limite, ie_fechado, nr_seq_result, dt_liberacao, cd_resp_indic, nm_resp_indic, ds_resp_indic, ds_periodo, ds_cor, ds_cor_fundo, ie_periodo, cd_classificacao, ds_justificativa) AS select	c.nr_sequencia nr_seq_indicador,
	SUBSTR(obter_desc_expressao(c.cd_exp_nm_indicador,c.nm_indicador),1,255) nm_indicador, 
	a.nr_seq_calc, 
	b.nr_sequencia nr_seq_inf, 
	b.cd_estabelecimento, 
	b.cd_empresa, 
	b.cd_ano, 
	b.cd_periodo, 
	b.qt_meta, 
	b.qt_real, 
	b.qt_limite, 
	b.ie_fechado, 
	b.nr_seq_result, 
	b.dt_liberacao, 
	substr(bsc_obter_resp_indic(c.nr_sequencia,bsc_obter_data_inf(b.nr_sequencia),'C'),1,10) cd_resp_indic, 
	substr(bsc_obter_resp_indic(c.nr_sequencia,bsc_obter_data_inf(b.nr_sequencia),'N'),1,60) nm_resp_indic, 
	substr(bsc_obter_resp_indic(c.nr_sequencia,bsc_obter_data_inf(b.nr_sequencia),'T'),1,255) ds_resp_indic, 
	substr(bsc_obter_periodo_inf(b.nr_seq_indicador,null,cd_ano,cd_periodo),1,20) ds_periodo, 
	substr(obter_descricao_padrao('BSC_CLASSIF_RESULT','DS_COR',nr_seq_result),1,30) ds_cor, 
	substr(coalesce(obter_descricao_padrao('BSC_CLASSIF_RESULT','DS_COR_FUNDO',nr_seq_result), bsc_obter_cor_indicador(c.nr_sequencia, b.nr_sequencia, cd_ano, cd_periodo)),1,30) ds_cor_fundo, 
	/*substr(bsc_obter_cor_indicador(c.nr_sequencia, b.nr_sequencia, cd_ano, cd_periodo),1,20) ds_cor_fundo,*/
 
	c.ie_periodo, 
	c.cd_classificacao, 
	b.ds_justificativa 
FROM	bsc_indicador c, 
	bsc_calc_indicador a, 
	bsc_ind_inf b 
where	b.nr_sequencia 	= a.nr_seq_inf 
and	b.nr_seq_indicador	= a.nr_seq_indicador 
and	b.nr_seq_indicador	= c.nr_sequencia;
