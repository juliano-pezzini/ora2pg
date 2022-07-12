-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';

CREATE OR REPLACE VIEW reg_contingencia_v (nm_pessoa_fisica, ds_status, ds_observacao, nr_seq_log_int_retorno, nr_sequencia, nr_regulacao, nr_atendimento_original, dt_geracao, ds_informacao, nr_seq_evento, nr_seq_informacao, nr_seq_log_int_gm, nr_seq_log_ultima) AS SELECT	CASE WHEN a.nr_atendimento IS NULL THEN  		substr(obter_nome_pf(g.cd_pessoa_fisica),1,255)  ELSE SUBSTR(obter_pessoa_atendimento(a.nr_atendimento,'N'),1,250) END  nm_pessoa_fisica,
	SUBSTR(obter_valor_dominio(2263,a.ie_status),1,255) ds_status, 
	a.ds_observacao, 
	a.nr_seq_log_int_retorno, 
	a.nr_sequencia, 
	g.nr_regulacao, 
	coalesce(g.nr_atendimento_original,a.nr_atendimento) nr_atendimento_original, 
	a.dt_geracao, 
	SUBSTR(obter_dados_inf_integracao(a.nr_seq_informacao,''),1,255) ds_informacao, 
	h.nr_seq_evento, 
	a.nr_seq_informacao, 
	a.nr_seq_log_int_gm, 
	a.nr_seq_log_ultima 
FROM informacao_integracao h, reg_log_integracao_v a
LEFT OUTER JOIN regulacao_atendimento g ON (a.nr_seq_regulacao_atendimento = g.nr_sequencia)
WHERE a.cd_evento		IN ('ER','N') AND a.nr_seq_informacao	= h.nr_sequencia;
