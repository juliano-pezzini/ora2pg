-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';

CREATE OR REPLACE VIEW nutricao_v (dt_cardapio, ds_servico, nr_seq_servico, ds_receita, nr_seq_receita, ds_composicao, nr_seq_composicao, qt_pessoa_atend, qt_pessoa_atend_real, vl_custo_cardapio, vl_custo_dia, vl_custo_real, cd_estabelecimento) AS select	a.dt_cardapio,
	substr(obter_desc_nut_servico(a.nr_seq_servico),1,60) ds_servico,
	a.nr_seq_servico,
	c.ds_receita,
	c.nr_sequencia nr_seq_receita,
	d.ds_composicao,
	d.nr_sequencia nr_seq_composicao,
	a.QT_PESSOA_ATEND,
	a.QT_PESSOA_ATEND_REAL,
	(select	sum(e.vl_custo) TOTAL
	FROM    nut_rec_real_comp e,
		    nut_cardapio_dia d,
		    nut_cardapio c,
		    nut_receita_real f
	where	f.nr_sequencia   	= e.nr_seq_rec_real
	and		c.nr_sequencia     	= f.nr_seq_cardapio
	and		d.nr_sequencia     	= c.nr_seq_card_dia
	and		f.nr_seq_cardapio	= b.nr_sequencia) vl_custo_cardapio,
	(select	sum(o.vl_custo_real * d.qt_pessoa_atend) TOTAL
	from	nut_rec_real_comp o,
			nut_receita_real r,
			nut_cardapio c,
			nut_servico s,
			nut_cardapio_dia d
	where	o.nr_seq_rec_real = r.nr_sequencia
	and		r.nr_seq_cardapio    = c.nr_sequencia
	and		c.nr_seq_card_dia = d.nr_sequencia
	and		s.nr_sequencia   = d.nr_seq_servico
	and		d.nr_sequencia = a.nr_sequencia) vl_custo_dia,
	(select	sum(o.vl_custo_real) TOTAL
	from	nut_rec_real_comp o,
			nut_receita_real r,
			nut_cardapio c,
			nut_servico s,
			nut_cardapio_dia d
	where	o.nr_seq_rec_real = r.nr_sequencia
	and		r.nr_seq_cardapio    = c.nr_sequencia
	and		c.nr_seq_card_dia = d.nr_sequencia
	and		s.nr_sequencia   = d.nr_seq_servico
	and		d.nr_sequencia = a.nr_sequencia) vl_custo_real,
	a.cd_estabelecimento
from	NUT_CARDAPIO_DIA a,
	NUT_CARDAPIO b,
	nut_receita c,
	NUT_composicao d
where	a.nr_sequencia = b.nr_seq_card_dia
and	b.nr_seq_receita = c.nr_sequencia
and	b.nr_seq_comp = d.nr_sequencia;
