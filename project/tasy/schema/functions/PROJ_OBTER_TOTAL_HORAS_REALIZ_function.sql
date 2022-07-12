-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION proj_obter_total_horas_realiz ( nr_seq_proj_p bigint, dt_inicial_p timestamp, dt_final_p timestamp ) RETURNS bigint AS $body$
DECLARE


qt_horas_totais_w		bigint;


BEGIN

select (coalesce(a.qt_horas, 0) + coalesce(b.qt_horas, 0))
into STRICT	qt_horas_totais_w
from (	SELECT	sum(v.qt_minuto)/60 qt_horas
		from 	proj_cronograma p,
			proj_cron_etapa e,
			man_ordem_servico m,
			man_ordem_serv_ativ v,
			usuario u
		where	nr_seq_proj_p = p.nr_seq_proj
		and	p.nr_sequencia = e.nr_seq_cronograma
		and	e.nr_sequencia = m.nr_seq_proj_cron_etapa
		and	m.nr_sequencia = v.nr_seq_ordem_serv
		and	u.nm_usuario = v.nm_usuario
		and	u.cd_setor_atendimento in (2,16,7)
		and	trunc(v.dt_atividade, 'month') between to_date(dt_inicial_p) and to_date(dt_final_p)	) a,
	(	select	sum(v.qt_minuto)/60 qt_horas
		from 	proj_projeto a,
			man_ordem_servico m,
			man_ordem_serv_ativ v,
			usuario u
		where	nr_seq_proj_p = a.nr_sequencia
		and	a.nr_seq_ordem_serv = m.nr_sequencia
		and	m.nr_sequencia = v.nr_seq_ordem_serv
		and	u.nm_usuario = v.nm_usuario
		and	u.cd_setor_atendimento in (2,16,7)
		and	trunc(v.dt_atividade, 'month') between to_date(dt_inicial_p) and to_date(dt_final_p)	) b;

return 	qt_horas_totais_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION proj_obter_total_horas_realiz ( nr_seq_proj_p bigint, dt_inicial_p timestamp, dt_final_p timestamp ) FROM PUBLIC;
