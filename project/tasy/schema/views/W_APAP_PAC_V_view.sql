-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';

CREATE OR REPLACE VIEW w_apap_pac_v (nr_seq_modelo, cd_pessoa_fisica, ds_grupo_informacao, nr_seq_apap_grupo, nr_seq_inf, ie_origem, ds_informacao, nr_sequencia, dt_registro, vl_resultado, ds_resultado, nr_seq_informacao, nr_atendimento, nm_usuario, ie_maxima, ie_media, ie_minima, ie_total, ie_grafico, ie_grupo_inf, ds_unid_med, dt_medida, ie_informacao) AS SELECT	a.nr_seq_modelo,
	a.cd_pessoa_fisica,
	b.ds_grupo_informacao,
	c.nr_seq_apap_grupo,
	c.nr_seq_inf,
	c.ie_origem,
	c.ds_informacao,
	d.nr_sequencia,
	d.dt_registro,
	d.vl_resultado,
	d.ds_resultado,
	c.nr_sequencia nr_seq_informacao,
	a.nr_atendimento,
	a.nm_usuario,
	c.IE_MAXIMA,
	c.IE_MEDIA,
	c.IE_MINIMA,
	c.IE_TOTAL,
	c.IE_GRAFICO,
	b.IE_GRUPO_INF,
	c.ds_unid_med,
	coalesce(d.DT_MEDICAO,d.DT_REGISTRO) dt_medida,
	b.ie_informacao
FROM w_apap_pac_grupo b, w_apap_pac a, w_apap_pac_informacao c
LEFT OUTER JOIN w_apap_pac_registro d ON (c.nr_sequencia = d.nr_seq_apap_inf)
WHERE a.nr_Sequencia = b.nr_seq_mod_apap AND b.nr_sequencia = c.nr_seq_apap_grupo  order by b.nr_sequencia,c.nr_Sequencia, d.dt_registro;

