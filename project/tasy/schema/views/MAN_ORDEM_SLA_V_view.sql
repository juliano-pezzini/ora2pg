-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';

CREATE OR REPLACE VIEW man_ordem_sla_v (nr_sequencia, ds_periodo_os, dt_ordem_servico, ds_estagio, ds_dano_breve, ds_localizacao, ds_grupo_des, ds_grupo_sup, nm_usuario_executor, nr_seq_estagio, nr_seq_gerencia, nr_seq_status, ie_tipo_sla, qt_min_rest_pr_resp, qt_min_rest_solucao, qt_resp_cliente, ds_hr_rest_pr_resp, ds_hr_rest_solucao, ie_sla_leg, ie_desenv, nr_atraso) AS select os.nr_sequencia,
	os.ds_periodo_os,
	os.dt_ordem_servico,
	os.ds_estagio,
	os.ds_dano_breve,
	os.ds_localizacao,
	os.ds_grupo_des,
	os.ds_grupo_sup,
	os.nm_usuario_executor,
	os.nr_seq_estagio,
	os.nr_seq_gerencia,
	os.nr_seq_status,
	os.ie_tipo_sla,
	os.qt_min_rest_pr_resp,
	os.qt_min_rest_solucao,
	os.qt_resp_cliente,
	os.ds_hr_rest_pr_resp,
	os.ds_hr_rest_solucao,
	os.ie_sla_leg,
	os.ie_desenv,
	CASE WHEN ds_periodo_os='C' THEN  1 WHEN ds_periodo_os='W' THEN  2 WHEN ds_periodo_os='G' THEN  3 WHEN ds_periodo_os='B' THEN  4 END  nr_atraso
FROM (
		select	a.nr_sequencia,
			substr(sla_dashboard_pck.obter_status_resp(a.nr_sequencia), 1, 1) ds_periodo_os,
			a.dt_ordem_servico,
			substr(a.ds_estagio, 1, 60) ds_estagio,
			substr(a.ds_dano_breve, 1, 80) ds_dano_breve,
			substr(a.ds_localizacao, 1, 50) ds_localizacao,
			substr(obter_desc_grupo_desen(a.nr_seq_grupo_des), 1, 60) ds_grupo_des,
			substr(obter_desc_grupo_suporte(a.nr_seq_grupo_sup), 1, 60) ds_grupo_sup,
			substr(obter_nome_usuario(man_obter_executor_ativo(a.nr_sequencia)), 1, 100) nm_usuario_executor,
			a.nr_seq_estagio,
			d.nr_seq_gerencia,
			b.nr_seq_status,
			sla_dashboard_pck.obter_min_resp_rest(a.nr_sequencia) qt_min_rest_pr_resp,
			sla_dashboard_pck.obter_min_solucao(a.nr_sequencia) qt_min_rest_solucao,
			CASE WHEN sla_dashboard_pck.obter_dt_primeiro_atend(a.nr_sequencia) IS NULL THEN  0  ELSE 1 END  qt_resp_cliente,
			man_obter_tempo_sla_formatado(sla_dashboard_pck.obter_min_resp_rest(a.nr_sequencia)) ds_hr_rest_pr_resp,
			man_obter_tempo_sla_formatado(sla_dashboard_pck.obter_min_solucao(a.nr_sequencia)) ds_hr_rest_solucao,
			man_obter_sla_leg(a.nr_sequencia) ie_sla_leg,
			obter_se_os_desenv(a.nr_sequencia) ie_desenv,
			coalesce(man_obter_parametros_sla(a.nr_sequencia, b.cd_estabelecimento, 'TIPOSLA'), 997) ie_tipo_sla
		from	man_ordem_servico_v a,
			man_ordem_serv_sla b,
			grupo_desenvolvimento d
		where	a.nr_sequencia = b.nr_seq_ordem
		and	a.nr_seq_grupo_des = d.nr_sequencia
		and	b.nr_seq_status <> 412
		and	obter_periodo_os(a.nr_sequencia) is not null
		and	obter_se_os_pend_cliente(b.nr_seq_ordem) = 'N'
		and	ie_status_ordem <> 3
		and	a.nr_seq_estagio not in (511)
		and	not exists (
				select	1
				from	man_estagio_processo x
				where	x.nr_sequencia = a.nr_seq_estagio
				and	coalesce(x.ie_testes, 'N') = 'S'
			)
		
union all

		select	a.nr_sequencia,
			obter_periodo_os(a.nr_sequencia) ds_periodo_os,
			a.dt_ordem_servico,
			substr(a.ds_estagio, 1, 60) ds_estagio,
			substr(a.ds_dano_breve, 1, 80) ds_dano_breve,
			substr(a.ds_localizacao, 1, 50) ds_localizacao,
			substr(obter_desc_grupo_desen(a.nr_seq_grupo_des), 1, 60) ds_grupo_des,
			substr(obter_desc_grupo_suporte(a.nr_seq_grupo_sup), 1, 60) ds_grupo_sup,
			substr(obter_nome_usuario(man_obter_executor_ativo(a.nr_sequencia)), 1, 100) nm_usuario_executor,
			a.nr_seq_estagio,
			d.nr_seq_gerencia,
			null,
			man_obter_parametros_sla(a.nr_sequencia, a.cd_estabelecimento, 'QTRR') qt_min_rest_pr_resp,
			man_obter_parametros_sla(a.nr_sequencia, a.cd_estabelecimento, 'QTRS') qt_min_rest_solucao,
			man_obter_parametros_sla(a.nr_sequencia, a.cd_estabelecimento, 'RE') qt_resp_cliente,
			man_obter_tempo_sla_formatado(man_obter_parametros_sla(a.nr_sequencia, a.cd_estabelecimento, 'QTRR')) ds_hr_rest_pr_resp,
			man_obter_tempo_sla_formatado(man_obter_parametros_sla(a.nr_sequencia, a.cd_estabelecimento, 'QTRS')) ds_hr_rest_solucao,
			man_obter_sla_leg(a.nr_sequencia) ie_sla_leg,
			obter_se_os_desenv(a.nr_sequencia) ie_desenv,
			coalesce(man_obter_parametros_sla(a.nr_sequencia, a.cd_estabelecimento, 'TIPOSLA'), 999) ie_tipo_sla
		from	man_ordem_servico_v a,
			grupo_desenvolvimento d,
			desenv_acordo_os b,
			desenv_acordo c
		where	b.nr_seq_ordem_servico = a.nr_sequencia
		and	a.nr_seq_grupo_des = d.nr_sequencia
		and	c.nr_sequencia = b.nr_seq_acordo
		and	a.ie_status_ordem <> 3
		and	a.nr_seq_estagio not in (511)
		and	c.dt_fim_acordo is null
		and	b.ie_status_acordo = 'A'
		and	obter_periodo_os(a.nr_sequencia) is not null
	) os
where	os.nr_seq_status > 0
order by	nr_atraso,
		os.qt_min_rest_pr_resp,
		os.qt_min_rest_solucao,
		os.ds_periodo_os;
