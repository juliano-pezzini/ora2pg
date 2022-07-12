-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';

CREATE OR REPLACE VIEW man_ordem_serv_atual_v (ie_ordem, ie_tipo_os, ds_tipo_os, nr_sequencia, dt_ordem_servico, ds_prioridade, ds_setor, nm_solicitante, nm_exec, ds_dano_breve, ds_classificacao, ds_estagio, ds_localizacao, ie_prior_desen, qt_volta_os, qt_min_exec, ds_tipo_os_meta, nm_usuario_prev, qt_min_prev, ie_tipo_meta, dt_prevista, ie_classificacao, ie_prioridade, ie_prioridade_desen, dt_interna_acordo, dt_externa_acordo, nr_seq_ativ_exec, nr_seq_funcao, nr_seq_ativ_prev) AS SELECT	4 ie_ordem,
	'SDP' ie_tipo_os, 
	'Sem data prevista' ds_tipo_os, 
	a.nr_sequencia, 
	a.dt_ordem_servico, 
	SUBSTR(obter_valor_dominio(1046, a.ie_prioridade),1,40) ds_prioridade, 
	SUBSTR(a.ds_setor_atendimento, 1,60) ds_setor, 
	SUBSTR(obter_nome_pf_pj(a.cd_pessoa_solicitante, ''),1,60) nm_solicitante, 
	SUBSTR(obter_nome_usuario(a.nm_usuario_exec_prev),1,40) nm_exec, 
	a.ds_dano_breve, 
	a.ds_classificacao, 
	a.ds_estagio, 
	a.ds_localizacao, 
	coalesce(a.ie_prioridade_desen, 0) ie_prior_desen, 
	obter_qt_volta_os(a.nr_sequencia) qt_volta_os, 
	man_obter_min_ordem_real_usu(y.nr_seq_ordem_serv, y.nm_usuario_prev, y.dt_prevista) qt_min_exec, 
	SUBSTR(obter_valor_dominio(3419, SUBSTR(obter_tipo_os(a.dt_ordem_servico),1,15)),1,100) ds_tipo_os_meta, 
	y.nm_usuario_prev, 
	SUM(y.qt_min_prev) qt_min_prev, 
	SUBSTR(obter_tipo_os(a.dt_ordem_servico),1,20) ie_tipo_meta, 
	NULL dt_prevista, 
	a.ie_classificacao, 
	a.ie_prioridade, 
	y.IE_PRIORIDADE_DESEN, 
	a.dt_interna_acordo, 
	a.dt_externa_acordo, 
	y.NR_SEQ_ATIV_EXEC, 
	y.NR_SEQ_FUNCAO, 
	y.nr_sequencia	NR_SEQ_ATIV_PREV 
FROM	man_ordem_ativ_prev	y, 
	man_ordem_servico_v	a, 
	man_estagio_processo	c 
WHERE	a.nr_sequencia 		= y.nr_seq_ordem_serv 
AND	y.dt_prevista IS NULL 
AND	c.nr_sequencia 		= a.nr_seq_estagio 
AND	c.ie_desenv  		= 'S' 
GROUP BY	a.nr_sequencia, 
	a.dt_ordem_servico, 
	a.ie_prioridade, 
	a.ds_setor_atendimento, 
	a.cd_pessoa_solicitante, 
	a.nm_usuario_exec_prev, 
	a.ds_dano_breve, 
	a.ds_classificacao, 
	a.ds_estagio, 
	a.ds_localizacao, 
	a.ie_prioridade_desen, 
	man_obter_min_ordem_real_usu(y.nr_seq_ordem_serv, y.nm_usuario_prev, y.dt_prevista), 
	obter_tipo_os(a.dt_ordem_servico), 
	y.nm_usuario_prev, 
	y.IE_PRIORIDADE_DESEN, 
	a.ie_classificacao, 
	a.dt_interna_acordo, 
	a.dt_externa_acordo, 
	y.NR_SEQ_ATIV_EXEC, 
	y.NR_SEQ_FUNCAO, 
	y.nr_sequencia 

UNION
 
SELECT	3 ie_ordem, 
	'SAP' ie_tipo_os, 
	'Sem atividade prevista' ds_tipo_os, 
	a.nr_sequencia, 
	a.dt_ordem_servico, 
	SUBSTR(obter_valor_dominio(1046, a.ie_prioridade),1,40) ds_prioridade, 
	SUBSTR(a.ds_setor_atendimento, 1,60) ds_setor, 
	SUBSTR(obter_nome_pf_pj(a.cd_pessoa_solicitante, ''),1,60) nm_solicitante, 
	SUBSTR(obter_nome_usuario(a.nm_usuario_exec_prev),1,40) nm_exec, 
	a.ds_dano_breve, 
	a.ds_classificacao, 
	a.ds_estagio, 
	a.ds_localizacao, 
	coalesce(a.ie_prioridade_desen, 0) ie_prior_desen, 
	obter_qt_volta_os(a.nr_sequencia) qt_volta_os, 
	man_obter_min_ordem_real_usu(y.nr_seq_ordem, y.nm_usuario_exec, NULL) qt_min_exec, 
	SUBSTR(obter_valor_dominio(3419, SUBSTR(obter_tipo_os(a.dt_ordem_servico),1,15)),1,100) ds_tipo_os_meta, 
	y.nm_usuario_exec nm_usuario_prev, 
	0 qt_min_prev, 
	SUBSTR(obter_tipo_os(a.dt_ordem_servico),1,20) ie_tipo_meta, 
	NULL dt_prevista, 
	a.ie_classificacao, 
	a.ie_prioridade, 
	0 IE_PRIORIDADE_DESEN, 
	a.dt_interna_acordo, 
	a.dt_externa_acordo, 
	NULL NR_SEQ_ATIV_EXEC, 
	NULL NR_SEQ_FUNCAO, 
	null NR_SEQ_ATIV_PREV	 
FROM	man_ordem_servico_exec	y, 
	man_ordem_servico_v	a, 
	man_estagio_processo	c 
WHERE	a.nr_sequencia		= y.nr_seq_ordem 
AND	c.nr_sequencia		= a.nr_seq_estagio 
AND	c.ie_desenv  		= 'S' 
AND (y.nr_seq_tipo_exec <> 5 OR y.nr_seq_tipo_exec IS NULL) 
AND	NOT EXISTS (SELECT	1 
			FROM	man_ordem_ativ_prev	x 
			WHERE	x.nr_seq_ordem_serv	= a.nr_sequencia 
			AND	x.nm_usuario_prev	= y.nm_usuario_exec) 
GROUP BY	a.nr_sequencia, 
	a.dt_ordem_servico, 
	SUBSTR(obter_valor_dominio(1046, a.ie_prioridade),1,40) , 
	SUBSTR(a.ds_setor_atendimento, 1,60) , 
	SUBSTR(obter_nome_pf_pj(a.cd_pessoa_solicitante, ''),1,60) , 
	SUBSTR(obter_nome_usuario(a.nm_usuario_exec_prev),1,40) , 
	a.ds_dano_breve, 
	a.ds_classificacao, 
	a.ds_estagio, 
	a.ds_localizacao, 
	coalesce(a.ie_prioridade_desen, 0) , 
	obter_qt_volta_os(a.nr_sequencia), 
	man_obter_min_ordem_real_usu(y.nr_seq_ordem, y.nm_usuario_exec, NULL), 
	obter_tipo_os(a.dt_ordem_servico), 
	y.nm_usuario_exec, 
	a.ie_classificacao, 
	a.ie_prioridade, 
	a.dt_interna_acordo, 
	a.dt_externa_acordo 

UNION
 
SELECT	1 ie_ordem, 
	'ATR' ie_tipo_os, 
	'Atrasada' ds_tipo_os, 
	a.nr_sequencia, 
	a.dt_ordem_servico, 
	SUBSTR(obter_valor_dominio(1046, a.ie_prioridade),1,40) ds_prioridade, 
	SUBSTR(a.ds_setor_atendimento, 1,60) ds_setor, 
	SUBSTR(obter_nome_pf_pj(a.cd_pessoa_solicitante, ''),1,60) nm_solicitante, 
	SUBSTR(obter_nome_usuario(a.nm_usuario_exec_prev),1,40) nm_exec, 
	a.ds_dano_breve, 
	a.ds_classificacao, 
	a.ds_estagio, 
	a.ds_localizacao, 
	coalesce(a.ie_prioridade_desen, 0) ie_prior_desen, 
	obter_qt_volta_os(a.nr_sequencia) qt_volta_os, 
	man_obter_min_ordem_real_usu(y.nr_seq_ordem, y.nm_usuario_exec, NULL) qt_min_exec, 
	SUBSTR(obter_valor_dominio(3419, SUBSTR(obter_tipo_os(a.dt_ordem_servico),1,15)),1,100) ds_tipo_os_meta, 
	y.nm_usuario_exec nm_usuario_prev, 
	SUM(z.qt_min_prev) qt_min_prev, 
	SUBSTR(obter_tipo_os(a.dt_ordem_servico),1,20) ie_tipo_meta, 
	MAX(z.dt_prevista) dt_prevista, 
	a.ie_classificacao, 
	a.ie_prioridade, 
	z.IE_PRIORIDADE_DESEN, 
	a.dt_interna_acordo, 
	a.dt_externa_acordo, 
	NULL NR_SEQ_ATIV_EXEC, 
	NULL NR_SEQ_FUNCAO, 
	null NR_SEQ_ATIV_PREV 
FROM	man_ordem_ativ_prev z, 
	man_ordem_servico_exec	y, 
	man_ordem_servico_v	a, 
	man_estagio_processo	c 
WHERE	a.nr_sequencia		= y.nr_seq_ordem 
AND	c.nr_sequencia		= a.nr_seq_estagio 
AND	z.nr_seq_ordem_serv	= a.nr_sequencia 
AND	z.nm_usuario_prev	= y.nm_usuario_exec 
AND	c.ie_desenv  		= 'S' 
AND (y.nr_seq_tipo_exec <> 5 OR y.nr_seq_tipo_exec IS NULL) 
AND	z.dt_prevista IS NOT NULL 
AND	z.dt_prevista	< TRUNC(LOCALTIMESTAMP,'dd') 
AND	NOT EXISTS	(SELECT	1 
			FROM	man_ordem_ativ_prev x 
			WHERE	x.nr_seq_ordem_serv	= a.nr_sequencia 
			AND	x.nm_usuario_prev	= z.nm_usuario_prev 
			AND	x.dt_prevista >= TRUNC(LOCALTIMESTAMP,'dd') 
			AND	((x.dt_real IS NULL) OR (TRUNC(x.dt_real) = TRUNC(LOCALTIMESTAMP)))) 
GROUP BY	a.nr_sequencia, 
	a.dt_ordem_servico, 
	SUBSTR(obter_valor_dominio(1046, a.ie_prioridade),1,40) , 
	SUBSTR(a.ds_setor_atendimento, 1,60) , 
	SUBSTR(obter_nome_pf_pj(a.cd_pessoa_solicitante, ''),1,60) , 
	SUBSTR(obter_nome_usuario(a.nm_usuario_exec_prev),1,40) , 
	a.ds_dano_breve, 
	a.ds_classificacao, 
	a.ds_estagio, 
	a.ds_localizacao, 
	coalesce(a.ie_prioridade_desen, 0) , 
	obter_qt_volta_os(a.nr_sequencia), 
	man_obter_min_ordem_real_usu(y.nr_seq_ordem, y.nm_usuario_exec, NULL), 
	obter_tipo_os(a.dt_ordem_servico), 
	y.nm_usuario_exec, 
	a.ie_classificacao, 
	z.IE_PRIORIDADE_DESEN, 
	a.ie_prioridade, 
	a.dt_interna_acordo, 
	a.dt_externa_acordo 

UNION
 
SELECT	2 ie_ordem, 
	'PA' ie_tipo_os, 
	'Prevista para o dia' ds_tipo_os, 
	a.nr_sequencia, 
	a.dt_ordem_servico, 
	SUBSTR(obter_valor_dominio(1046, a.ie_prioridade),1,40) ds_prioridade, 
	SUBSTR(a.ds_setor_atendimento, 1,60) ds_setor, 
	SUBSTR(obter_nome_pf_pj(a.cd_pessoa_solicitante, ''),1,60) nm_solicitante, 
	SUBSTR(obter_nome_usuario(a.nm_usuario_exec_prev),1,40) nm_exec, 
	a.ds_dano_breve, 
	a.ds_classificacao, 
	a.ds_estagio, 
	a.ds_localizacao, 
	coalesce(a.ie_prioridade_desen, 0) ie_prior_desen, 
	obter_qt_volta_os(a.nr_sequencia) qt_volta_os, 
	man_obter_min_ordem_real_usu(y.nr_seq_ordem_serv, y.nm_usuario_prev, y.dt_prevista) qt_min_exec, 
	SUBSTR(obter_valor_dominio(3419, SUBSTR(obter_tipo_os(a.dt_ordem_servico),1,15)),1,100) ds_tipo_os_meta, 
	y.nm_usuario_prev, 
	SUM(y.qt_min_prev) qt_min_prev, 
	SUBSTR(obter_tipo_os(a.dt_ordem_servico),1,20) ie_tipo_meta, 
	y.dt_prevista dt_prevista, 
	a.ie_classificacao, 
	a.ie_prioridade, 
	y.IE_PRIORIDADE_DESEN, 
	a.dt_interna_acordo, 
	a.dt_externa_acordo, 
	y.NR_SEQ_ATIV_EXEC, 
	y.NR_SEQ_FUNCAO, 
	y.nr_sequencia	NR_SEQ_ATIV_PREV 
FROM	man_ordem_ativ_prev	y, 
	man_ordem_servico_v	a, 
	man_estagio_processo	c 
WHERE	a.nr_sequencia 		= y.nr_seq_ordem_serv 
AND	c.nr_sequencia		= a.nr_seq_estagio 
AND	c.ie_desenv  		= 'S' 
AND	y.DT_PREVISTA BETWEEN TRUNC(LOCALTIMESTAMP) AND fim_dia(LOCALTIMESTAMP) 
GROUP BY 
	a.nr_sequencia, 
	a.dt_ordem_servico, 
	a.ie_prioridade, 
	a.ds_setor_atendimento, 
	a.cd_pessoa_solicitante, 
	a.nm_usuario_exec_prev, 
	a.ds_dano_breve, 
	a.ds_classificacao, 
	a.ds_estagio, 
	a.ds_localizacao, 
	a.ie_prioridade_desen, 
	man_obter_min_ordem_real_usu(y.nr_seq_ordem_serv, y.nm_usuario_prev, y.dt_prevista), 
	obter_tipo_os(a.dt_ordem_servico), 
	y.nm_usuario_prev, 
	y.dt_prevista, 
	a.ie_classificacao, 
	y.IE_PRIORIDADE_DESEN, 
	a.ie_prioridade, 
	a.dt_interna_acordo, 
	a.dt_externa_acordo, 
	y.NR_SEQ_ATIV_EXEC, 
	y.nr_sequencia, 
	y.NR_SEQ_FUNCAO;

