-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';

CREATE OR REPLACE VIEW eis_rouparia_v (qt_peca_origem, qt_peca_destino, qt_peso_origem, qt_peso_destino, dt_liberacao, cd_estabelecimento, ie_periodo, cd_setor, ds_setor, nr_seq_local, ds_local, nr_seq_personalizacao, ds_personalizacao, nr_seq_tipo, ds_tipo, nr_seq_tamanho, ds_tamanho, nr_seq_operacao, ds_operacao, qt_dias) AS select	1 qt_peca_origem,
 	0 qt_peca_destino,
	c.qt_peso qt_peso_origem,
	0 qt_peso_destino,
	trunc(a.dt_liberacao,'dd') dt_liberacao,
	a.cd_estabelecimento,
	'D' ie_periodo,
	rop_obter_setor_local(a.nr_seq_local) cd_setor,
	substr(coalesce(obter_nome_setor(rop_obter_setor_local(a.nr_seq_local)),'Não informado'),1,100) ds_setor,
	a.nr_seq_local,
	substr(coalesce(rop_obter_dados_local(a.nr_seq_local,'D'),'Não informado'),1,100) ds_local,
	c.nr_seq_personalizacao,
	substr(coalesce(rop_obter_dados_person(c.nr_seq_personalizacao,'D'),'Não informado'),1,100) ds_personalizacao,
	c.nr_seq_tipo,
	substr(coalesce(rop_obter_dados_tipo(c.nr_seq_tipo,'D'),'Não informado'),1,100) ds_tipo,
	c.nr_seq_tamanho,
	substr(coalesce(rop_obter_dados_tamanho(c.nr_seq_tamanho,'D'),'Não informado'),1,100) ds_tamanho,
	a.nr_seq_operacao,
	substr(coalesce(rop_obter_dados_operacao(a.nr_seq_operacao,'D'),'Não informado'),1,100) ds_operacao,
	rop_obter_dias_sem_movto(b.nr_seq_roupa) qt_dias
FROM	rop_lote_movto a,
	rop_movto_roupa b,
	rop_lote_roupa c,
	rop_roupa d
where	a.nr_sequencia = b.nr_seq_lote
and	d.nr_seq_lote_roupa = c.nr_sequencia
and	d.nr_sequencia = b.nr_seq_roupa
and	a.dt_liberacao is not null

union all

select	0 qt_peca_origem,
 	1 qt_peca_destino,
	0 qt_peso_origem,
	c.qt_peso qt_peso_destino,
	trunc(a.dt_liberacao,'dd') dt_liberacao,
	a.cd_estabelecimento,
	'D' ie_periodo,
	rop_obter_setor_local(a.nr_seq_local) cd_setor,
	substr(coalesce(obter_nome_setor(rop_obter_setor_local(a.nr_seq_local)),'Não informado'),1,100) ds_setor,
	a.nr_seq_local_orig_dest,
	substr(coalesce(rop_obter_dados_local(a.nr_seq_local_orig_dest,'D'),'Não informado'),1,100) ds_local,
	c.nr_seq_personalizacao,
	substr(coalesce(rop_obter_dados_person(c.nr_seq_personalizacao,'D'),'Não informado'),1,100) ds_personalizacao,
	c.nr_seq_tipo,
	substr(coalesce(rop_obter_dados_tipo(c.nr_seq_tipo,'D'),'Não informado'),1,100) ds_tipo,
	c.nr_seq_tamanho,
	substr(coalesce(rop_obter_dados_tamanho(c.nr_seq_tamanho,'D'),'Não informado'),1,100) ds_tamanho,
	a.nr_seq_operacao,
	substr(coalesce(rop_obter_dados_operacao(a.nr_seq_operacao,'D'),'Não informado'),1,100) ds_operacao,
	rop_obter_dias_sem_movto(b.nr_seq_roupa) qt_dias
from	rop_lote_movto a,
	rop_movto_roupa b,
	rop_lote_roupa c,
	rop_roupa d
where	a.nr_sequencia = b.nr_seq_lote
and	d.nr_seq_lote_roupa = c.nr_sequencia
and	d.nr_sequencia = b.nr_seq_roupa
and	a.dt_liberacao is not null;

