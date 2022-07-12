-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';

CREATE OR REPLACE VIEW eis_cme_conj_requisicao_v (ie_tipo, qt_requisicoes, qt_req_atendidas, qt_req_pendentes, nm_conjunto, dt_requisicao, cd_setor_atendimento, nm_setor_atendimento, cd_pessoa_requisitante, nm_pessoa_requisitante, nm_pessoa_atendeu, cd_estabelecimento) AS select	1 ie_tipo,
	sum(b.qt_conjunto) qt_requisicoes, 
	0 qt_req_atendidas, 
	0 qt_req_pendentes, 
	substr(cme_obter_nome_conjunto(b.nr_seq_conjunto),1,100) nm_conjunto, 
	trunc(a.dt_requisicao) dt_requisicao, 
	a.cd_setor_atendimento, 
	substr(obter_nome_setor(a.cd_setor_atendimento),1,100) nm_setor_atendimento, 
	a.cd_pessoa_requisitante, 
	substr(obter_nome_pessoa_fisica(a.cd_pessoa_requisitante,null),1,100) nm_pessoa_requisitante, 
	substr(obter_pessoa_fisica_usuario(a.nm_usuario,'D'),1,100) nm_pessoa_atendeu, 
	a.cd_estabelecimento 
FROM	cm_requisicao a, 
	cm_requisicao_item b 
where	a.nr_sequencia = b.nr_seq_requisicao 
group by trunc(a.dt_requisicao), 
	a.cd_setor_atendimento, 
	a.cd_pessoa_requisitante, 
	b.nr_seq_conjunto, 
	a.cd_estabelecimento, 
	substr(obter_pessoa_fisica_usuario(a.nm_usuario,'D'),1,100), 
	substr(cme_obter_nome_conjunto(b.nr_seq_conjunto),1,100) 

union
 
select	2 ie_tipo, 
	0 qt_requisicoes, 
	sum(b.qt_conjunto) qt_req_atendidas, 
	0 qt_req_pendentes, 
	substr(cme_obter_nome_conjunto(b.nr_seq_conjunto),1,100) nm_conjunto, 
	trunc(a.dt_requisicao) dt_requisicao, 
	a.cd_setor_atendimento, 
	substr(obter_nome_setor(a.cd_setor_atendimento),1,100) nm_setor_atendimento, 
	a.cd_pessoa_requisitante, 
	substr(obter_nome_pessoa_fisica(a.cd_pessoa_requisitante,null),1,100) nm_pessoa_requisitante, 
	substr(obter_pessoa_fisica_usuario(a.nm_usuario,'D'),1,100) nm_pessoa_atendeu, 
	a.cd_estabelecimento 
from	cm_requisicao a, 
	cm_requisicao_item b 
where	a.nr_sequencia = b.nr_seq_requisicao 
--and	dt_baixa is not null 
and	b.cd_motivo_baixa is not null 
group by trunc(a.dt_requisicao), 
	a.cd_setor_atendimento, 
	a.cd_pessoa_requisitante, 
	b.nr_seq_conjunto, 
	a.cd_estabelecimento, 
	substr(obter_pessoa_fisica_usuario(a.nm_usuario,'D'),1,100), 
	substr(cme_obter_nome_conjunto(b.nr_seq_conjunto),1,100) 

union
 
select	3 ie_tipo, 
	0 qt_requisicoes, 
	0 qt_req_atendidas, 
	sum(b.qt_conjunto) qt_req_pendentes, 
	substr(cme_obter_nome_conjunto(b.nr_seq_conjunto),1,100) nm_conjunto, 
	trunc(a.dt_requisicao) dt_requisicao, 
	a.cd_setor_atendimento, 
	substr(obter_nome_setor(a.cd_setor_atendimento),1,100) nm_setor_atendimento, 
	a.cd_pessoa_requisitante, 
	substr(obter_nome_pessoa_fisica(a.cd_pessoa_requisitante,null),1,100) nm_pessoa_requisitante, 
	substr(obter_pessoa_fisica_usuario(a.nm_usuario,'D'),1,100) nm_pessoa_atendeu, 
	a.cd_estabelecimento 
from	cm_requisicao a, 
	cm_requisicao_item b 
where	a.nr_sequencia = b.nr_seq_requisicao 
--and	dt_baixa is null 
and	b.cd_motivo_baixa is null 
group by trunc(a.dt_requisicao), 
	a.cd_setor_atendimento, 
	a.cd_pessoa_requisitante, 
	b.nr_seq_conjunto, 
	a.cd_estabelecimento, 
	substr(obter_pessoa_fisica_usuario(a.nm_usuario,'D'),1,100), 
	substr(cme_obter_nome_conjunto(b.nr_seq_conjunto),1,100) 
order by ie_tipo;

