-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_os_prim_hist ( nm_usuario_p text, dt_inicial_p timestamp, dt_final_p timestamp) RETURNS bigint AS $body$
DECLARE


qt_os_primeiro_atend_w	bigint;


BEGIN

if (nm_usuario_p IS NOT NULL AND nm_usuario_p::text <> '') then
	begin
		select	count(a.nr_sequencia)
		into STRICT	qt_os_primeiro_atend_w
		from	man_ordem_servico a
		where	a.ie_status_ordem = '3'
		and	a.ie_classificacao in ('D','E')
		and	a.dt_fim_real between dt_inicial_p and dt_final_p + 86399/86400
		and	exists (SELECT 1
				from	man_ordem_serv_tecnico c
				where 	a.nr_sequencia = c.nr_seq_ordem_serv
				and	c.ie_mtvo_retorno_ws not in ('SNE','SEII','NCE'))
		and	a.nr_seq_grupo_sup in (	select	l.nr_sequencia
						from	grupo_suporte l,
							gerencia_wheb t
						where	t.nr_sequencia = l.nr_seq_gerencia_sup
						and	t.nr_sequencia in (5,58)
						and	l.ie_situacao = 'A')
		and exists (	select	1
					from	man_ordem_serv_estagio x,
						man_estagio_processo y
					where	x.nr_seq_estagio = y.nr_sequencia
					and	x.nr_seq_ordem = a.nr_sequencia
					and	y.ie_suporte = 'S')
		and	exists (select	1
				from	man_ordem_ativ_prev x
				where	a.nr_sequencia = x.nr_seq_ordem_serv
				and	x.nm_usuario_prev = a.nm_usuario_exec
				and	a.nm_usuario_exec = nm_usuario_p);
	end;
end if;


return	qt_os_primeiro_atend_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_os_prim_hist ( nm_usuario_p text, dt_inicial_p timestamp, dt_final_p timestamp) FROM PUBLIC;

