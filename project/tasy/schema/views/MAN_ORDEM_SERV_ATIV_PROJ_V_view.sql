-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';

CREATE OR REPLACE VIEW man_ordem_serv_ativ_proj_v (dt_atividade, nm_executor, ds_funcao_manutencao, ds_ativ_proj, qt_minuto, pr_etapa, nr_seq_os, ds_dano_breve, ie_tipo_os, ds_tipo_os, ds_estagio, ds_funcao_tasy) AS select	a.dt_atividade,
	a.nm_usuario_exec nm_executor,
	f.ds_funcao ds_funcao_manutencao,
	e.ds_atividade ds_ativ_proj,
	a.qt_minuto,
	e.pr_etapa,
	o.nr_sequencia nr_seq_os,
	o.ds_dano_breve,
	obter_tipo_os(o.dt_ordem_servico) ie_tipo_os,
	CASE WHEN obter_se_ordem_orig_projeto(o.nr_sequencia)='S' THEN 'Projeto'  ELSE obter_valor_dominio(3419,obter_tipo_os(o.dt_ordem_servico)) END  ds_tipo_os,
	substr(obter_desc_expressao(s.cd_exp_estagio,s.ds_estagio),1,40) ds_estagio,
	obter_desc_funcao(o.cd_funcao) ds_funcao_tasy
FROM man_estagio_processo s, man_ordem_servico o, man_tipo_funcao f, proj_cronograma c
LEFT OUTER JOIN proj_projeto p ON (c.nr_seq_proj = p.nr_sequencia)
, proj_cron_etapa e
LEFT OUTER JOIN proj_cronograma c ON (e.nr_seq_cronograma = c.nr_sequencia)
, man_ordem_serv_ativ a
LEFT OUTER JOIN proj_cron_etapa e ON (a.nr_seq_proj_cron_etapa = e.nr_sequencia)
WHERE s.nr_sequencia = o.nr_seq_estagio and o.nr_sequencia = a.nr_seq_ordem_serv    and f.nr_sequencia = a.nr_seq_funcao;
