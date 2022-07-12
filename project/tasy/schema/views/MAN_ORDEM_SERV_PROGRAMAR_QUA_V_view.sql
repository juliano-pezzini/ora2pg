-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';

CREATE OR REPLACE VIEW man_ordem_serv_programar_qua_v (ie_ordem, ie_tipo_os, ds_tipo_os, nr_sequencia, dt_ordem_servico, ds_prioridade, ds_setor, nm_solicitante, nm_exec, ds_dano_breve, ds_classificacao, ds_estagio, ds_localizacao, ie_prior_desen, qt_volta_os, qt_min_exec, ds_tipo_os_meta, nm_usuario_prev, qt_min_prev, ie_tipo_meta, dt_prevista, ie_classificacao, ie_prioridade, ie_prioridade_desen, dt_interna_acordo, dt_externa_acordo, dt_atualizacao) AS select	4 ie_ordem,
	'SDP' ie_tipo_os, 
	'Sem data prevista' ds_tipo_os, 
	a.nr_sequencia, 
	a.dt_ordem_servico, 
	substr(obter_valor_dominio(1046,a.ie_prioridade),1,40) ds_prioridade, 
	substr(a.ds_setor_atendimento,1,60) ds_setor, 
	substr(obter_nome_pf_pj(a.cd_pessoa_solicitante,''),1,60) nm_solicitante, 
	substr(obter_nome_usuario(a.nm_usuario_exec_prev),1,40) nm_exec, 
	a.ds_dano_breve, 
	a.ds_classificacao, 
	a.ds_estagio, 
	a.ds_localizacao, 
	coalesce(a.ie_prioridade_desen,0) ie_prior_desen, 
	obter_qt_volta_os(a.nr_sequencia) qt_volta_os, 
	man_obter_min_ordem_real_usu(y.nr_seq_ordem_serv,y.nm_usuario_prev,y.dt_prevista) qt_min_exec, 
	substr(obter_valor_dominio(3419,substr(obter_tipo_os(a.dt_ordem_servico),1,15)),1,100) ds_tipo_os_meta, 
	y.nm_usuario_prev, 
	sum(y.qt_min_prev) qt_min_prev, 
	substr(obter_tipo_os(a.dt_ordem_servico),1,20) ie_tipo_meta, 
	null dt_prevista, 
	a.ie_classificacao, 
	a.ie_prioridade, 
	y.ie_prioridade_desen, 
	a.dt_interna_acordo, 
	a.dt_externa_acordo, 
	a.dt_atualizacao 
FROM	man_ordem_ativ_prev	y, 
	man_ordem_servico_v2	a, 
	man_estagio_processo	c 
where	a.nr_sequencia 		= y.nr_seq_ordem_serv 
and	y.dt_prevista is null 
and	c.nr_sequencia 		= a.nr_seq_estagio 
and	c.ie_qualidade  	= 'S' 
group by	a.nr_sequencia, 
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
	man_obter_min_ordem_real_usu(y.nr_seq_ordem_serv,y.nm_usuario_prev,y.dt_prevista), 
	obter_tipo_os(a.dt_ordem_servico), 
	y.nm_usuario_prev, 
	y.ie_prioridade_desen, 
	a.ie_classificacao, 
	a.dt_interna_acordo, 
	a.dt_externa_acordo, 
	a.dt_atualizacao 

union
 
select	3 ie_ordem, 
	'SAP' ie_tipo_os, 
	'Sem atividade prevista' ds_tipo_os, 
	a.nr_sequencia, 
	a.dt_ordem_servico, 
	substr(obter_valor_dominio(1046,a.ie_prioridade),1,40) ds_prioridade, 
	substr(a.ds_setor_atendimento,1,60) ds_setor, 
	substr(obter_nome_pf_pj(a.cd_pessoa_solicitante,''),1,60) nm_solicitante, 
	substr(obter_nome_usuario(a.nm_usuario_exec_prev),1,40) nm_exec, 
	a.ds_dano_breve, 
	a.ds_classificacao, 
	a.ds_estagio, 
	a.ds_localizacao, 
	coalesce(a.ie_prioridade_desen,0) ie_prior_desen, 
	obter_qt_volta_os(a.nr_sequencia) qt_volta_os, 
	man_obter_min_ordem_real_usu(y.nr_seq_ordem, y.nm_usuario_exec,null) qt_min_exec, 
	substr(obter_valor_dominio(3419,substr(obter_tipo_os(a.dt_ordem_servico),1,15)),1,100) ds_tipo_os_meta, 
	y.nm_usuario_exec nm_usuario_prev, 
	0 qt_min_prev, 
	substr(obter_tipo_os(a.dt_ordem_servico),1,20) ie_tipo_meta, 
	null dt_prevista, 
	a.ie_classificacao, 
	a.ie_prioridade, 
	0 ie_prioridade_desen, 
	a.dt_interna_acordo, 
	a.dt_externa_acordo, 
	a.dt_atualizacao 
from	man_ordem_servico_exec	y, 
	man_ordem_servico_v2	a, 
	man_estagio_processo	c 
where	a.nr_sequencia		= y.nr_seq_ordem 
and	c.nr_sequencia		= a.nr_seq_estagio 
and	c.ie_qualidade  	= 'S' 
and (y.nr_seq_tipo_exec <> 5 or y.nr_seq_tipo_exec is null) 
and	not exists (	select	1 
			from	man_ordem_ativ_prev	x 
			where	x.nr_seq_ordem_serv	= a.nr_sequencia 
			and	x.nm_usuario_prev	= y.nm_usuario_exec) 
group by	a.nr_sequencia, 
	a.dt_ordem_servico, 
	substr(obter_valor_dominio(1046,a.ie_prioridade),1,40) , 
	substr(a.ds_setor_atendimento,1,60) , 
	substr(obter_nome_pf_pj(a.cd_pessoa_solicitante,''),1,60) , 
	substr(obter_nome_usuario(a.nm_usuario_exec_prev),1,40) , 
	a.ds_dano_breve, 
	a.ds_classificacao, 
	a.ds_estagio, 
	a.ds_localizacao, 
	coalesce(a.ie_prioridade_desen,0) , 
	obter_qt_volta_os(a.nr_sequencia), 
	man_obter_min_ordem_real_usu(y.nr_seq_ordem,y.nm_usuario_exec,null), 
	obter_tipo_os(a.dt_ordem_servico), 
	y.nm_usuario_exec, 
	a.ie_classificacao, 
	a.ie_prioridade, 
	a.dt_interna_acordo, 
	a.dt_externa_acordo, 
	a.dt_atualizacao 

union
 
select	1 ie_ordem, 
	'ATR' ie_tipo_os, 
	'Atrasada' ds_tipo_os, 
	a.nr_sequencia, 
	a.dt_ordem_servico, 
	substr(obter_valor_dominio(1046,a.ie_prioridade),1,40) ds_prioridade, 
	substr(a.ds_setor_atendimento,1,60) ds_setor, 
	substr(obter_nome_pf_pj(a.cd_pessoa_solicitante,''),1,60) nm_solicitante, 
	substr(obter_nome_usuario(a.nm_usuario_exec_prev),1,40) nm_exec, 
	a.ds_dano_breve, 
	a.ds_classificacao, 
	a.ds_estagio, 
	a.ds_localizacao, 
	coalesce(a.ie_prioridade_desen,0) ie_prior_desen, 
	obter_qt_volta_os(a.nr_sequencia) qt_volta_os, 
	man_obter_min_ordem_real_usu(y.nr_seq_ordem,y.nm_usuario_exec,null) qt_min_exec, 
	substr(obter_valor_dominio(3419,substr(obter_tipo_os(a.dt_ordem_servico),1,15)),1,100) ds_tipo_os_meta, 
	y.nm_usuario_exec nm_usuario_prev, 
	sum(z.qt_min_prev) qt_min_prev, 
	substr(obter_tipo_os(a.dt_ordem_servico),1,20) ie_tipo_meta, 
	max(z.dt_prevista) dt_prevista, 
	a.ie_classificacao, 
	a.ie_prioridade, 
	z.ie_prioridade_desen, 
	a.dt_interna_acordo, 
	a.dt_externa_acordo, 
	a.dt_atualizacao 
from	man_ordem_ativ_prev z, 
	man_ordem_servico_exec	y, 
	man_ordem_servico_v2	a, 
	man_estagio_processo	c 
where	a.nr_sequencia		= y.nr_seq_ordem 
and	c.nr_sequencia		= a.nr_seq_estagio 
and	z.nr_seq_ordem_serv	= a.nr_sequencia 
and	z.nm_usuario_prev	= y.nm_usuario_exec 
and	c.ie_qualidade  	= 'S' 
and (y.nr_seq_tipo_exec <> 5 or y.nr_seq_tipo_exec is null) 
and	z.dt_prevista is not null 
and	z.dt_prevista	< trunc(LOCALTIMESTAMP,'dd') 
and	not exists(	select	1 
			from	man_ordem_ativ_prev x 
			where	x.nr_seq_ordem_serv	= a.nr_sequencia 
			and	x.nm_usuario_prev	= z.nm_usuario_prev 
			and	x.dt_prevista >= trunc(LOCALTIMESTAMP,'dd') 
			and	((x.dt_real is null) or (trunc(x.dt_real) = trunc(LOCALTIMESTAMP)))) 
group by	a.nr_sequencia, 
	a.dt_ordem_servico, 
	substr(obter_valor_dominio(1046,a.ie_prioridade),1,40) , 
	substr(a.ds_setor_atendimento,1,60) , 
	substr(obter_nome_pf_pj(a.cd_pessoa_solicitante, ''),1,60) , 
	substr(obter_nome_usuario(a.nm_usuario_exec_prev),1,40) , 
	a.ds_dano_breve, 
	a.ds_classificacao, 
	a.ds_estagio, 
	a.ds_localizacao, 
	coalesce(a.ie_prioridade_desen, 0) , 
	obter_qt_volta_os(a.nr_sequencia), 
	man_obter_min_ordem_real_usu(y.nr_seq_ordem,y.nm_usuario_exec, null), 
	obter_tipo_os(a.dt_ordem_servico), 
	y.nm_usuario_exec, 
	a.ie_classificacao, 
	z.ie_prioridade_desen, 
	a.ie_prioridade, 
	a.dt_interna_acordo, 
	a.dt_externa_acordo, 
	a.dt_atualizacao 

union
 
select	5 ie_ordem, 
	'PF' ie_tipo_os, 
	'Prevista próximos dias' ds_tipo_os, 
	a.nr_sequencia, 
	a.dt_ordem_servico, 
	substr(obter_valor_dominio(1046,a.ie_prioridade),1,40) ds_prioridade, 
	substr(a.ds_setor_atendimento,1,60) ds_setor, 
	substr(obter_nome_pf_pj(a.cd_pessoa_solicitante,''),1,60) nm_solicitante, 
	substr(obter_nome_usuario(a.nm_usuario_exec_prev),1,40) nm_exec, 
	a.ds_dano_breve, 
	a.ds_classificacao, 
	a.ds_estagio, 
	a.ds_localizacao, 
	coalesce(a.ie_prioridade_desen,0) ie_prior_desen, 
	obter_qt_volta_os(a.nr_sequencia) qt_volta_os, 
	man_obter_min_ordem_real_usu(y.nr_seq_ordem_serv,y.nm_usuario_prev,y.dt_prevista) qt_min_exec, 
	substr(obter_valor_dominio(3419,substr(obter_tipo_os(a.dt_ordem_servico),1,15)),1,100) ds_tipo_os_meta, 
	y.nm_usuario_prev, 
	sum(y.qt_min_prev) qt_min_prev, 
	substr(obter_tipo_os(a.dt_ordem_servico),1,20) ie_tipo_meta, 
	y.dt_prevista dt_prevista, 
	a.ie_classificacao, 
	a.ie_prioridade, 
	y.ie_prioridade_desen, 
	a.dt_interna_acordo, 
	a.dt_externa_acordo, 
	a.dt_atualizacao 
from	man_ordem_ativ_prev	y, 
	man_ordem_servico_v2	a, 
	man_estagio_processo	c 
where	a.nr_sequencia 		= y.nr_seq_ordem_serv 
and	c.nr_sequencia		= a.nr_seq_estagio 
and	c.ie_qualidade  	= 'S' 
and	y.dt_prevista > fim_dia(LOCALTIMESTAMP) 
group by 
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
	man_obter_min_ordem_real_usu(y.nr_seq_ordem_serv,y.nm_usuario_prev,y.dt_prevista), 
	obter_tipo_os(a.dt_ordem_servico), 
	y.nm_usuario_prev, 
	y.dt_prevista, 
	a.ie_classificacao, 
	y.ie_prioridade_desen, 
	a.ie_prioridade, 
	a.dt_interna_acordo, 
	a.dt_externa_acordo, 
	a.dt_atualizacao;

