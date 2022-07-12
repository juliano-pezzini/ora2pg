-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';

CREATE OR REPLACE VIEW eis_contrato_v (ie_periodo, qt_contrato, cd_cgc_contratado, dt_inicio, nm_guerra, qt_cresc_total, sg_estado, ds_municipio) AS select	'M' ie_periodo,
	count(*) qt_contrato, 
	c.cd_cgc_contratado, 
	trunc(c.dt_inicio,'mm') dt_inicio, 
	b.nm_guerra, 
	max(obter_crescimento_ano(c.dt_inicio,'CT')) qt_cresc_total, 
	substr(obter_dados_pf_pj(null, c.cd_cgc_contratado, 'UF'),1,2) sg_estado, 
	substr(obter_dados_pf_pj(null, c.cd_cgc_contratado, 'CI'),1,30) || ' - ' || 
		substr(obter_dados_pf_pj(null, c.cd_cgc_contratado, 'UF'),1,2) ds_municipio 
FROM	com_canal b, 
	com_canal_cliente a, 
	com_cliente o, 
	contrato c 
where	c.cd_cgc_contratado	= o.cd_cnpj 
and	a.nr_seq_cliente	= o.nr_sequencia 
and	b.nr_sequencia 		= a.nr_seq_canal 
and	o.ie_classificacao	= 'C' 
and	a.ie_tipo_atuacao	= 'V' 
and	a.dt_fim_atuacao is null 
and	c.nr_seq_tipo_contrato in (1,3,81,91) 
and	c.ie_classificacao = 'AT' 
group by c.cd_cgc_contratado, 
	trunc(c.dt_inicio,'mm'), 
	b.nm_guerra 

union
 
select	'A' ie_periodo, 
	count(*) qt_contrato, 
	c.cd_cgc_contratado, 
	trunc(c.dt_inicio,'yyyy') dt_inicio, 
	b.nm_guerra, 
	max(obter_crescimento_ano(c.dt_inicio,'CT')) qt_cresc_total, 
	substr(obter_dados_pf_pj(null, c.cd_cgc_contratado, 'UF'),1,2) sg_estado, 
	substr(obter_dados_pf_pj(null, c.cd_cgc_contratado, 'CI'),1,30) || ' - ' || 
		substr(obter_dados_pf_pj(null, c.cd_cgc_contratado, 'UF'),1,2) ds_municipio 
from	com_canal b, 
	com_canal_cliente a, 
	com_cliente o, 
	contrato c 
where	c.cd_cgc_contratado	= o.cd_cnpj 
and	a.nr_seq_cliente	= o.nr_sequencia 
and	b.nr_sequencia 		= a.nr_seq_canal 
and	o.ie_classificacao	= 'C' 
and	a.ie_tipo_atuacao	= 'V' 
and	a.dt_fim_atuacao is null 
and	c.nr_seq_tipo_contrato in (1,3,81,91) 
and	c.ie_classificacao = 'AT' 
group by c.cd_cgc_contratado, 
	trunc(c.dt_inicio,'yyyy'), 
	b.nm_guerra;

