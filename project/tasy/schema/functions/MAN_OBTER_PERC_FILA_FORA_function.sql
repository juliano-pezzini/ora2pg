-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION man_obter_perc_fila_fora ( nr_seq_fila_p bigint, qt_dias_p bigint, cd_estabelecimento_p bigint) RETURNS bigint AS $body$
DECLARE


dt_referencia_w			timestamp;
qt_pendente_w			integer;
qt_fora_dias_w			integer;
pr_fora_dias_ant_w		integer	:= 0;


BEGIN

begin

select	obter_dia_util_ant_periodo(clock_timestamp(),qt_dias_p,cd_estabelecimento_p)
into STRICT	dt_referencia_w
;

exception when others then

	select	trunc(clock_timestamp() - qt_dias_p)
	into STRICT	dt_referencia_w
	;

end;

select	count(*)
into STRICT	qt_pendente_w
from	man_estagio_processo p,
	man_ordem_servico b
where	exists (SELECT	1
	from	cadastro_fila a,
		man_ordem_servico_exec c
	where	c.nm_usuario_exec = a.nm_usuario_fila
	and	a.nr_sequencia = nr_seq_fila_p
	and	b.nr_sequencia = c.nr_seq_ordem)
and	b.ie_status_ordem <> '3'
and	p.nr_sequencia = b.nr_seq_estagio
and	p.ie_desenv = 'S'
and	b.nr_seq_grupo_des in (select	x.nr_sequencia
	from	cadastro_fila y,
		grupo_desenvolvimento x
	where	x.nr_seq_gerencia 	= y.nr_seq_gerencia
	and	y.nr_sequencia 		= nr_seq_fila_p);

if (qt_pendente_w > 0) then
	begin

	select	count(*)
	into STRICT	qt_fora_dias_w
	from	man_estagio_processo p,
		man_ordem_servico b
	where	exists (SELECT	1
		from	cadastro_fila a,
			man_ordem_servico_exec c
		where	c.nm_usuario_exec = a.nm_usuario_fila
		and	a.nr_sequencia = nr_seq_fila_p
		and	b.nr_sequencia = c.nr_seq_ordem)
	and	b.ie_status_ordem <> '3'
	and	p.nr_sequencia = b.nr_seq_estagio
	and	p.ie_desenv = 'S'
	and	b.dt_ordem_servico	< dt_referencia_w
	and	b.nr_seq_grupo_des in (select	x.nr_sequencia
		from	cadastro_fila y,
			grupo_desenvolvimento x
		where	x.nr_seq_gerencia 	= y.nr_seq_gerencia
		and	y.nr_sequencia 		= nr_seq_fila_p);

	pr_fora_dias_ant_w	:= ((qt_fora_dias_w * 100) / qt_pendente_w);

	end;
end if;

return	pr_fora_dias_ant_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION man_obter_perc_fila_fora ( nr_seq_fila_p bigint, qt_dias_p bigint, cd_estabelecimento_p bigint) FROM PUBLIC;
