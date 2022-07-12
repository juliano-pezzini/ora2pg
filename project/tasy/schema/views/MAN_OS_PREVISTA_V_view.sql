-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';

CREATE OR REPLACE VIEW man_os_prevista_v (nr_sequencia, ie_classificacao, dt_ordem_servico, ds_prioridade, ds_setor, nm_solicitante, nm_exec, ds_dano_breve, ds_classificacao, ds_estagio, ds_localizacao, qt_volta_os, qt_min_prev, qt_min_exec, ds_tipo_os_meta, ie_ativ_aberta, ie_prioridade, nr_seq_estagio, ie_prioridade_desen, ie_prioridade_sup, pr_atividade, ie_finalizado, dt_fim_atividade, dt_atividade, dt_prevista, ie_situacao_os, qt_dias_atuais, qt_dias_prev, nm_usuario_prev, dt_externa_acordo, cd_funcao, nr_seq_cliente, ie_fora_planej_diario) AS select	a.nr_sequencia,
	a.ie_classificacao, 
	a.dt_ordem_servico, 
	SUBSTR(obter_valor_dominio(1046, a.ie_prioridade),1,40) ds_prioridade, 
	SUBSTR(a.ds_setor_atendimento, 1,60) ds_setor, 
	SUBSTR(obter_nome_pf_pj(a.cd_pessoa_solicitante, ''),1,60) nm_solicitante, 
	SUBSTR(obter_nome_usuario(a.nm_usuario_exec_prev),1,40) nm_exec, 
	a.ds_dano_breve, 
	a.ds_classificacao, 
	a.ds_estagio, 
	a.ds_localizacao,	 
	obter_qt_volta_os(a.nr_sequencia) qt_volta_os, 
	SUM(y.qt_min_prev) qt_min_prev, 
	man_obter_min_ordem_real_usu(y.nr_seq_ordem_serv,y.nm_usuario_prev,y.dt_prevista) qt_min_exec, 
	SUBSTR(obter_valor_dominio(3419, SUBSTR(obter_tipo_os(a.dt_ordem_servico),1,15)),1,100) ds_tipo_os_meta, 
	obter_se_ativ_real_aberta(a.nr_sequencia,nm_usuario_prev) ie_ativ_aberta, 
	a.ie_prioridade, 
	a.nr_seq_estagio, 
	y.ie_prioridade_desen, 
	y.ie_prioridade_sup, 
	y.pr_atividade, 
	obter_se_ativ_real_pendente(a.nr_sequencia,y.nr_sequencia,y.nm_usuario_prev) ie_finalizado, 
	obter_dt_ativ_real(a.nr_sequencia,nm_usuario_prev) dt_fim_atividade, 
	man_obter_dt_ativ_atual(a.nr_sequencia,nm_usuario_prev) dt_atividade, 
	y.dt_prevista, 
	b.ie_situacao_os, 
	trunc(trunc(LOCALTIMESTAMP) - trunc(a.dt_ordem_servico)) qt_dias_atuais, 
	trunc(trunc(y.dt_prevista) - trunc(a.dt_ordem_servico)) qt_dias_prev, 
	y.nm_usuario_prev, 
	a.dt_externa_acordo, 
	a.cd_funcao, 
	a.nr_seq_cliente, 
	y.ie_fora_planej_diario 
FROM	man_ordem_ativ_prev	y, 
	man_estagio_processo	b, 
	man_ordem_servico_v	a 
WHERE	a.nr_seq_estagio 	= b.nr_sequencia 
AND	a.nr_sequencia	= y.nr_seq_ordem_serv 
group by a.nr_sequencia, 
	a.ie_classificacao, 
	a.dt_ordem_servico, 
	SUBSTR(obter_valor_dominio(1046, a.ie_prioridade),1,40), 
	SUBSTR(a.ds_setor_atendimento, 1,60), 
	SUBSTR(obter_nome_pf_pj(a.cd_pessoa_solicitante, ''),1,60), 
	SUBSTR(obter_nome_usuario(a.nm_usuario_exec_prev),1,40), 
	a.ds_dano_breve, 
	a.ds_classificacao, 
	a.ds_estagio, 
	a.ds_localizacao,	 
	obter_qt_volta_os(a.nr_sequencia), 
	man_obter_min_ordem_real_usu(y.nr_seq_ordem_serv,y.nm_usuario_prev,y.dt_prevista), 
	SUBSTR(obter_valor_dominio(3419, SUBSTR(obter_tipo_os(a.dt_ordem_servico),1,15)),1,100), 
	obter_se_ativ_real_aberta(a.nr_sequencia,nm_usuario_prev), 
	a.ie_prioridade, 
	a.nr_seq_estagio, 
	y.ie_prioridade_desen,  
	y.ie_prioridade_sup, 
	y.pr_atividade, 
	obter_se_ativ_real_pendente(a.nr_sequencia,y.nr_sequencia,y.nm_usuario_prev), 
	obter_dt_ativ_real(a.nr_sequencia,nm_usuario_prev), 
	man_obter_dt_ativ_atual(a.nr_sequencia,nm_usuario_prev), 
	y.dt_prevista, 
	b.ie_situacao_os, 
	trunc(trunc(LOCALTIMESTAMP) - trunc(a.dt_ordem_servico)), 
	trunc(LOCALTIMESTAMP - y.dt_prevista), 
	y.nm_usuario_prev, 
	a.dt_externa_acordo, 
	a.cd_funcao, 
	a.nr_seq_cliente, 
	y.ie_fora_planej_diario;

