-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';




CREATE OR REPLACE FUNCTION sla_dashboard_pck.obter_dt_primeiro_atend ( nr_seq_ordem_serv_p bigint) RETURNS timestamp AS $body$
DECLARE


dt_min_resp_w	timestamp;

BEGIN

select	coalesce(least(
		coalesce((select	x.dt_atualizacao
		from	man_estagio_processo y,
			man_ordem_serv_estagio x
		where	x.nr_seq_ordem = a.nr_sequencia
		and	y.nr_sequencia = x.nr_seq_estagio
		and	y.ie_aguarda_cliente = 'N'
		and	x.nr_sequencia = (
					select	min(z.nr_sequencia)
					from	man_estagio_processo w,
						man_ordem_serv_estagio z
					where	z.nr_seq_ordem = a.nr_sequencia
					and	w.nr_sequencia = z.nr_seq_estagio
					and	w.ie_aguarda_cliente = 'N'
					and	z.nr_seq_estagio not in (231,1712,1051,1731))), clock_timestamp()),
		coalesce((select	min(x.dt_liberacao)
		from 	man_ordem_serv_tecnico x
		where	x.nr_seq_ordem_serv = a.nr_sequencia
		and	x.nr_seq_tipo = 1
		and	x.nm_usuario <> 'WebService'), clock_timestamp())), clock_timestamp())
into STRICT	dt_min_resp_w
from	man_ordem_servico a
where	a.nr_sequencia = nr_seq_ordem_serv_p;

return	dt_min_resp_w;

END;

$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON FUNCTION sla_dashboard_pck.obter_dt_primeiro_atend ( nr_seq_ordem_serv_p bigint) FROM PUBLIC;