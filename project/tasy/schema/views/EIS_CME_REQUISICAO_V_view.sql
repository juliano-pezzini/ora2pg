-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';

CREATE OR REPLACE VIEW eis_cme_requisicao_v (ie_tipo, qt_requisicoes, qt_req_atendidas, qt_req_pendentes, dt_requisicao, cd_setor_atendimento, nm_setor_atendimento, cd_pessoa_requisitante, nm_pessoa_requisitante, nm_pessoa_atendeu, cd_estabelecimento) AS select	1 ie_tipo,
	count(*) qt_requisicoes, 
	0 qt_req_atendidas, 
	0 qt_req_pendentes, 
	trunc(dt_requisicao) dt_requisicao, 
	cd_setor_atendimento, 
	substr(obter_nome_setor(cd_setor_atendimento),1,100) nm_setor_atendimento, 
	cd_pessoa_requisitante, 
	substr(obter_nome_pessoa_fisica(cd_pessoa_requisitante,null),1,100) nm_pessoa_requisitante, 
	substr(obter_pessoa_fisica_usuario(nm_usuario,'D'),1,100) nm_pessoa_atendeu, 
	cd_estabelecimento 
FROM	cm_requisicao 
group by trunc(dt_requisicao), 
	cd_setor_atendimento, 
	cd_pessoa_requisitante, 
	cd_estabelecimento, 
	substr(obter_pessoa_fisica_usuario(nm_usuario,'D'),1,100) 

union
 
select	2 ie_tipo, 
	0 qt_requisicoes, 
	count(*) qt_req_atendidas, 
	0 qt_req_pendentes, 
	trunc(dt_requisicao) dt_requisicao, 
	cd_setor_atendimento, 
	substr(obter_nome_setor(cd_setor_atendimento),1,100) nm_setor_atendimento, 
	cd_pessoa_requisitante, 
	substr(obter_nome_pessoa_fisica(cd_pessoa_requisitante,null),1,100) nm_pessoa_requisitante, 
	substr(obter_pessoa_fisica_usuario(nm_usuario,'D'),1,100) nm_pessoa_atendeu, 
	cd_estabelecimento 
from	cm_requisicao 
where	dt_baixa is not null 
group by trunc(dt_requisicao), 
	cd_setor_atendimento, 
	cd_pessoa_requisitante, 
	cd_estabelecimento, 
	substr(obter_pessoa_fisica_usuario(nm_usuario,'D'),1,100) 

union
 
select	3 ie_tipo, 
	0 qt_requisicoes, 
	0 qt_req_atendidas, 
	count(*) qt_req_pendentes, 
	trunc(dt_requisicao) dt_requisicao, 
	cd_setor_atendimento, 
	substr(obter_nome_setor(cd_setor_atendimento),1,100) nm_setor_atendimento, 
	cd_pessoa_requisitante, 
	substr(obter_nome_pessoa_fisica(cd_pessoa_requisitante,null),1,100) nm_pessoa_requisitante, 
	substr(obter_pessoa_fisica_usuario(nm_usuario,'D'),1,100) nm_pessoa_atendeu, 
	cd_estabelecimento 
from	cm_requisicao 
where	dt_baixa is null 
group by trunc(dt_requisicao), 
	cd_setor_atendimento, 
	cd_pessoa_requisitante, 
	cd_estabelecimento, 
	substr(obter_pessoa_fisica_usuario(nm_usuario,'D'),1,100);

