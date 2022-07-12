-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';

CREATE OR REPLACE VIEW far_pedido_v (nr_sequencia, cd_estabelecimento, cd_pessoa_fisica, nr_seq_vendedor, dt_pedido, dt_fechamento, vl_total, nr_atendimento, ie_entregar, dt_inicio_atendimento, nr_seq_entregador, dt_saida, dt_entrega_real) AS select	nr_sequencia,
	cd_estabelecimento,
	cd_pessoa_fisica,
	nr_seq_vendedor,
	dt_pedido,
	dt_fechamento,
	vl_total,
	nr_atendimento,
	ie_entregar,
	dt_inicio_atendimento,
	null nr_seq_entregador,
	null dt_saida,
	null dt_entrega_real
FROM	far_pedido a
where	coalesce(ie_entregar,'N') = 'S'
and	not exists (select 1 from far_rom_entrega_pedido x where x.nr_seq_pedido = a.nr_sequencia)
-- Nunca estiveram em nenhum romaneio
union all

select	nr_sequencia,
	cd_estabelecimento,
	cd_pessoa_fisica,
	nr_seq_vendedor,
	dt_pedido,
	dt_fechamento,
	vl_total,
	nr_atendimento,
	ie_entregar,
	dt_inicio_atendimento,
	null nr_seq_entregador,
	null dt_saida,
	null dt_entrega_real
from	far_pedido a
where	coalesce(ie_entregar,'N') = 'S'
and	exists (select 1 from far_rom_entrega_pedido x where x.nr_seq_pedido = a.nr_sequencia and x.nr_seq_motivo_entrega is not null)
and	not exists (select 1 from far_rom_entrega_pedido x where x.nr_seq_pedido = a.nr_sequencia and x.nr_seq_motivo_entrega is null)
-- Estiveram em romaneio, voltaram e não foram para outro
union all

select	a.nr_sequencia,
	a.cd_estabelecimento,
	a.cd_pessoa_fisica,
	a.nr_seq_vendedor,
	a.dt_pedido,
	a.dt_fechamento,
	a.vl_total,
	a.nr_atendimento,
	a.ie_entregar,
	dt_inicio_atendimento,
	b.nr_seq_entregador,
	b.dt_saida,
	c.dt_entrega_real
from	far_pedido a,
	far_rom_entrega b,
	far_rom_entrega_pedido c
where	a.nr_sequencia = c.nr_seq_pedido
and	b.nr_sequencia = c.nr_seq_romaneio
and	coalesce(ie_entregar,'N') = 'S'
and	b.dt_saida is null
-- Estão em romaneio
union all

select	a.nr_sequencia,
	a.cd_estabelecimento,
	a.cd_pessoa_fisica,
	a.nr_seq_vendedor,
	a.dt_pedido,
	a.dt_fechamento,
	a.vl_total,
	a.nr_atendimento,
	a.ie_entregar,
	dt_inicio_atendimento,
	b.nr_seq_entregador,
	b.dt_saida,
	c.dt_entrega_real
from	far_pedido a,
	far_rom_entrega b,
	far_rom_entrega_pedido c
where	a.nr_sequencia = c.nr_seq_pedido
and	b.nr_sequencia = c.nr_seq_romaneio
and	coalesce(ie_entregar,'N') = 'S'
and	b.dt_liberacao is not null
and	b.dt_saida is not null
and	b.dt_retorno is null
and	c.dt_entrega_real is null
and	c.nr_seq_motivo_entrega is null
-- Sairam para entregar
union all

select	a.nr_sequencia,
	a.cd_estabelecimento,
	a.cd_pessoa_fisica,
	a.nr_seq_vendedor,
	a.dt_pedido,
	a.dt_fechamento,
	a.vl_total,
	a.nr_atendimento,
	a.ie_entregar,
	dt_inicio_atendimento,
	b.nr_seq_entregador,
	b.dt_saida,
	c.dt_entrega_real
from	far_pedido a,
	far_rom_entrega b,
	far_rom_entrega_pedido c
where	a.nr_sequencia = c.nr_seq_pedido
and	b.nr_sequencia = c.nr_seq_romaneio
and	coalesce(ie_entregar,'N') = 'S'
and	c.nr_seq_motivo_entrega is null
and	c.dt_entrega_real is not null
-- Foram entregues
union all

select	nr_sequencia,
	cd_estabelecimento,
	cd_pessoa_fisica,
	nr_seq_vendedor,
	dt_pedido,
	dt_fechamento,
	vl_total,
	nr_atendimento,
	ie_entregar,
	dt_inicio_atendimento,
	null nr_seq_entregador,
	null dt_saida,
	null dt_entrega_real
from	far_pedido a
where	coalesce(ie_entregar,'N') = 'N'
-- Não são para entregar
;
