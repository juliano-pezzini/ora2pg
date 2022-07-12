-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';

CREATE OR REPLACE VIEW requisicao_pendente_receb_v (cd_estabelecimento, cd_local_estoque, nr_requisicao, dt_solicitacao_requisicao, dt_liberacao, dt_aprovacao, nm_usuario, dt_emissao_loc_estoque, cd_centro_custo, cd_local_estoque_destino, ds_local_estoque, cd_operacao_estoque, ds_operacao, ds_obs, nr_seq_justificativa, cd_pessoa_solicitante, cd_pessoa_requisitante, ds_setor_usuario, ds_destino, ds_centro_custo, ds_pessoa_requisitante, ds_pessoa_solicitante, ds_geracao, ds_justificativa, dt_compra) AS select	b.cd_estabelecimento,
	b.cd_local_estoque,
	b.nr_requisicao,
	b.dt_solicitacao_requisicao,
	b.dt_liberacao,
	b.dt_aprovacao,
	b.nm_usuario,
	b.dt_emissao_loc_estoque,
	b.cd_centro_custo,
	b.cd_local_estoque_destino,
	l.ds_local_estoque,
	b.cd_operacao_estoque,
	o.ds_operacao,
	b.ds_observacao ds_obs,
	b.nr_seq_justificativa,
    b.cd_pessoa_solicitante,
    b.cd_pessoa_requisitante,
	substr(obter_nome_setor(obter_setor_usuario(b.nm_usuario)),1,40) ds_setor_usuario,
	substr(obter_desc_local_estoque(b.cd_local_estoque_destino),1,100) ds_destino,
	substr(obter_desc_centro_custo(b.cd_centro_custo),1,100) ds_centro_custo,
	substr(obter_nome_pf(b.cd_pessoa_requisitante),1,100) ds_pessoa_requisitante,
	substr(obter_nome_pf(b.cd_pessoa_solicitante),1,100) ds_pessoa_solicitante,
	substr(CASE WHEN b.ie_geracao='A' THEN wheb_mensagem_pck.get_texto(1156089) WHEN b.ie_geracao='AC' THEN wheb_mensagem_pck.get_texto(1156089)  ELSE wheb_mensagem_pck.get_texto(1156090) END ,1,30) ds_geracao,
	substr(obter_desc_just_requisicao(b.nr_seq_justificativa),1,255) ds_justificativa,
	b.dt_compra
FROM	requisicao_material b,
	local_estoque l,
	operacao_estoque o
where	b.cd_local_estoque = l.cd_local_estoque
and	b.cd_operacao_estoque = o.cd_operacao_estoque
and	o.ie_tipo_requisicao = 21
and	exists (	select 	1
		from 	item_requisicao_material c,
			sup_motivo_baixa_req e
		where	b.nr_requisicao	= c.nr_requisicao
		and	c.cd_motivo_baixa	= e.nr_sequencia
		and	e.cd_motivo_baixa	in (1,4)
		and	c.dt_recebimento is null)

union all

select	b.cd_estabelecimento,
	b.cd_local_estoque,
	b.nr_requisicao,
	b.dt_solicitacao_requisicao,
	b.dt_liberacao,
	b.dt_aprovacao,
	b.nm_usuario,
	b.dt_emissao_loc_estoque,
	b.cd_centro_custo,
	b.cd_local_estoque_destino,
	l.ds_local_estoque,
	b.cd_operacao_estoque,
	o.ds_operacao,
	b.ds_observacao ds_obs,
	b.nr_seq_justificativa,
    b.cd_pessoa_solicitante,
    b.cd_pessoa_requisitante,
	substr(obter_nome_setor(obter_setor_usuario(b.nm_usuario)),1,40) ds_setor_usuario,
	substr(obter_desc_local_estoque(b.cd_local_estoque_destino),1,100) ds_destino,
	substr(obter_desc_centro_custo(b.cd_centro_custo),1,100) ds_centro_custo,
	substr(obter_nome_pf(b.cd_pessoa_requisitante),1,100) ds_pessoa_requisitante,
	substr(obter_nome_pf(b.cd_pessoa_solicitante),1,100) ds_pessoa_solicitante,
	substr(CASE WHEN b.ie_geracao='A' THEN wheb_mensagem_pck.get_texto(1156089) WHEN b.ie_geracao='AC' THEN wheb_mensagem_pck.get_texto(1156089)  ELSE wheb_mensagem_pck.get_texto(1156090) END ,1,30) ds_geracao,
	substr(obter_desc_just_requisicao(b.nr_seq_justificativa),1,255) ds_justificativa,
	b.dt_compra
from	requisicao_material b,
	local_estoque l,
	operacao_estoque o,
	parametro_estoque p
where	b.cd_local_estoque = l.cd_local_estoque
and	b.cd_operacao_estoque = o.cd_operacao_estoque
and	b.cd_estabelecimento = p.cd_estabelecimento
and	o.ie_tipo_requisicao = '1'
and	coalesce(p.ie_duas_etapas_req_consumo,'N') = 'S'
and	exists (select  1
		from	item_requisicao_material c,
			sup_motivo_baixa_req e
		where	b.nr_requisicao = c.nr_requisicao
		and	c.cd_motivo_baixa = e.nr_sequencia
		and	e.cd_motivo_baixa in (1,4)
		and	c.dt_recebimento is null);

