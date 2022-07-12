-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';

CREATE OR REPLACE VIEW man_obter_os_clientes_v (qt_reg, ie_tipo_reg, cd_gerencia, nr_seq_localizacao, nr_seq_grupo) AS select	sum(1) qt_reg,
	1 ie_tipo_reg,
	c.nr_sequencia cd_gerencia,
	d.nr_sequencia	nr_seq_localizacao,
	b.nr_sequencia	nr_seq_grupo
FROM	man_ordem_servico	a,
	man_localizacao		d,
	grupo_desenvolvimento	b,
	gerencia_wheb 		c
where	a.nr_seq_localizacao	= d.nr_sequencia
and	a.nr_seq_grupo_des	= b.nr_sequencia
and	b.nr_seq_gerencia	= c.nr_sequencia
and  	obter_tipo_os(a.dt_ordem_servico) <= '3'
and (	select	max(x.ie_aguarda_cliente)
		from	man_estagio_processo x,
			man_ordem_servico y
		where	y.nr_seq_estagio	= x.nr_sequencia
		and	y.nr_sequencia		= a.nr_sequencia) = 'N'
and (	select	max(ie_desenv)
		from	man_estagio_processo	x,
			man_ordem_servico 	y
		where	y.nr_sequencia		= a.nr_sequencia
		and	y.nr_seq_estagio	= x.nr_sequencia
		and	x.nr_sequencia		<> 51) = 'S'
and	a.ie_status_ordem <> '3'
and	not exists (	select	1
				from	proj_projeto	x,
					man_ordem_servico y
				where	x.nr_seq_ordem_serv	= y.nr_sequencia
				and	y.nr_sequencia		= a.nr_sequencia
				
union

				select	1
				from	PROJ_PROJETO_CLIENTE_ADIC	x,
					man_ordem_servico 		y
				where 	x.NR_SEQ_ORDEM_SERV  = y.nr_sequencia
				and	y.nr_sequencia		= a.nr_sequencia)
group by c.nr_sequencia, d.nr_sequencia, b.nr_sequencia

union all

select sum(1) qt_reg,
	2 ie_tipo_reg,
	c.nr_sequencia cd_gerencia,
	d.nr_sequencia	nr_seq_localizacao,
	b.nr_sequencia	nr_seq_grupo
from	man_ordem_servico	a,
	man_localizacao		d,
	grupo_desenvolvimento	b,
	gerencia_wheb 		c
where	a.nr_seq_localizacao	= d.nr_sequencia
and	a.nr_seq_grupo_des	= b.nr_sequencia
and	b.nr_seq_gerencia	= c.nr_sequencia
and  	obter_tipo_os(a.dt_ordem_servico) = '4'
and (	select	max(x.ie_aguarda_cliente)
		from	man_estagio_processo x,
			man_ordem_servico y
		where	y.nr_seq_estagio	= x.nr_sequencia
		and	y.nr_sequencia		= a.nr_sequencia) = 'N'
and (	select	max(ie_desenv)
		from	man_estagio_processo	x,
			man_ordem_servico 	y
		where	y.nr_sequencia		= a.nr_sequencia
		and	y.nr_seq_estagio	= x.nr_sequencia
		and	x.nr_sequencia		<> 51) = 'S'
and	a.ie_status_ordem <> '3'
and	not exists (	select	1
				from	proj_projeto	x,
					man_ordem_servico y
				where	x.nr_seq_ordem_serv	= y.nr_sequencia
				and	y.nr_sequencia		= a.nr_sequencia
				
union

				select	1
				from	PROJ_PROJETO_CLIENTE_ADIC	x,
					man_ordem_servico 		y
				where 	x.NR_SEQ_ORDEM_SERV  = y.nr_sequencia
				and	y.nr_sequencia		= a.nr_sequencia)
group by c.nr_sequencia, d.nr_sequencia, b.nr_sequencia

union all

select sum(1) qt_reg,
	 3 ie_tipo_reg,
	 c.nr_sequencia cd_gerencia,
	d.nr_sequencia	nr_seq_localizacao,
	b.nr_sequencia	nr_seq_grupo
from	man_ordem_servico	a,
	man_localizacao		d,
	grupo_desenvolvimento	b,
	gerencia_wheb 		c
where	a.nr_seq_localizacao	= d.nr_sequencia
and	a.nr_seq_grupo_des	= b.nr_sequencia
and	b.nr_seq_gerencia	= c.nr_sequencia
and  	obter_tipo_os(a.dt_ordem_servico) = '5'
and (	select	max(x.ie_aguarda_cliente)
		from	man_estagio_processo x,
			man_ordem_servico y
		where	y.nr_seq_estagio	= x.nr_sequencia
		and	y.nr_sequencia		= a.nr_sequencia) = 'N'
and (	select	max(ie_desenv)
		from	man_estagio_processo	x,
			man_ordem_servico 	y
		where	y.nr_sequencia		= a.nr_sequencia
		and	y.nr_seq_estagio	= x.nr_sequencia
		and	x.nr_sequencia		<> 51) = 'S'
and	a.ie_status_ordem <> '3'
and	not exists (	select	1
				from	proj_projeto	x,
					man_ordem_servico y
				where	x.nr_seq_ordem_serv	= y.nr_sequencia
				and	y.nr_sequencia		= a.nr_sequencia
				
union

				select	1
				from	PROJ_PROJETO_CLIENTE_ADIC	x,
					man_ordem_servico 		y
				where 	x.NR_SEQ_ORDEM_SERV  = y.nr_sequencia
				and	y.nr_sequencia		= a.nr_sequencia)
group by c.nr_sequencia, d.nr_sequencia, b.nr_sequencia

union all

select sum(1) qt_reg,
	4 ie_tipo_reg,
	c.nr_sequencia cd_gerencia,
	d.nr_sequencia	nr_seq_localizacao,
	b.nr_sequencia	nr_seq_grupo
from	man_ordem_servico	a,
	man_localizacao		d,
	grupo_desenvolvimento	b,
	gerencia_wheb 		c
where	a.nr_seq_localizacao	= d.nr_sequencia
and	a.nr_seq_grupo_des	= b.nr_sequencia
and	b.nr_seq_gerencia	= c.nr_sequencia
and (	select	max(x.ie_aguarda_cliente)
		from	man_estagio_processo x,
			man_ordem_servico y
		where	y.nr_seq_estagio	= x.nr_sequencia
		and	y.nr_sequencia		= a.nr_sequencia) = 'N'
and (	select	max(ie_desenv)
		from	man_estagio_processo	x,
			man_ordem_servico 	y
		where	y.nr_sequencia		= a.nr_sequencia
		and	y.nr_seq_estagio	= x.nr_sequencia
		and	x.nr_sequencia		<> 51) = 'S'
and	a.ie_status_ordem <> '3'
and	exists (	select	1
			from	proj_projeto	x,
				man_ordem_servico y
			where	x.nr_seq_ordem_serv	= y.nr_sequencia
			and	y.nr_sequencia		= a.nr_sequencia
			
union

			select	1
			from	PROJ_PROJETO_CLIENTE_ADIC	x,
				man_ordem_servico 		y
			where 	x.NR_SEQ_ORDEM_SERV  = y.nr_sequencia
			and	y.nr_sequencia		= a.nr_sequencia)
group by c.nr_sequencia, d.nr_sequencia, b.nr_sequencia

union all

select sum(1) qt_reg,
	5 ie_tipo_reg,
	c.nr_sequencia cd_gerencia,
	d.nr_sequencia	nr_seq_localizacao,
	b.nr_sequencia	nr_seq_grupo
from	man_ordem_servico	a,
	man_localizacao		d,
	grupo_desenvolvimento	b,
	gerencia_wheb 		c
where	a.nr_seq_localizacao	= d.nr_sequencia
and	a.nr_seq_grupo_des	= b.nr_sequencia
and	b.nr_seq_gerencia	= c.nr_sequencia
and (	select	max(x.ie_aguarda_cliente)
		from	man_estagio_processo x,
			man_ordem_servico y
		where	y.nr_seq_estagio	= x.nr_sequencia
		and	y.nr_sequencia		= a.nr_sequencia) = 'N'
and (	select	max(ie_desenv)
		from	man_estagio_processo	x,
			man_ordem_servico 	y
		where	y.nr_sequencia		= a.nr_sequencia
		and	y.nr_seq_estagio	= x.nr_sequencia
		and	x.nr_sequencia		<> 51) = 'S'
and	a.ie_status_ordem <> '3'
group by c.nr_sequencia, d.nr_sequencia, b.nr_sequencia

union all

select sum(1) qt_reg,
	6 ie_tipo_reg,
	c.nr_sequencia cd_gerencia,
	d.nr_sequencia	nr_seq_localizacao,
	b.nr_sequencia	nr_seq_grupo
from	man_ordem_servico	a,
	man_localizacao		d,
	grupo_desenvolvimento	b,
	gerencia_wheb 		c
where	a.nr_seq_localizacao	= d.nr_sequencia
and	a.nr_seq_grupo_des	= b.nr_sequencia
and	b.nr_seq_gerencia	= c.nr_sequencia
and (	select	max(x.ie_aguarda_cliente)
		from	man_estagio_processo x,
			man_ordem_servico y
		where	y.nr_seq_estagio	= x.nr_sequencia
		and	y.nr_sequencia		= a.nr_sequencia) = 'N'
and (	select	max(ie_desenv)
		from	man_estagio_processo	x,
			man_ordem_servico 	y
		where	y.nr_sequencia		= a.nr_sequencia
		and	y.nr_seq_estagio	= x.nr_sequencia
		and	x.nr_sequencia		<> 51) = 'S'
and	a.ie_status_ordem <> '3'
and	not exists (	select	1
				from	proj_projeto	x,
					man_ordem_servico y
				where	x.nr_seq_ordem_serv	= y.nr_sequencia
				and	y.nr_sequencia		= a.nr_sequencia
				
union

				select	1
				from	PROJ_PROJETO_CLIENTE_ADIC	x,
					man_ordem_servico 		y
				where 	x.NR_SEQ_ORDEM_SERV  = y.nr_sequencia
				and	y.nr_sequencia		= a.nr_sequencia)
group by c.nr_sequencia, d.nr_sequencia, b.nr_sequencia;
