-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_sent_real_proj_migr ( nr_seq_projeto_p bigint, dt_previsao_p timestamp) RETURNS bigint AS $body$
DECLARE


qt_horas_prev_real_w	double precision;
qt_horas_real_proj_w	double precision;
qt_horas_real_os_w	double precision;
qt_horas_possiveis_w	double precision;
dt_previsao_anterior_w	timestamp;


BEGIN
if (nr_seq_projeto_p IS NOT NULL AND nr_seq_projeto_p::text <> '') and (dt_previsao_p IS NOT NULL AND dt_previsao_p::text <> '') then
	begin
	select	coalesce(max(dt_resumo),to_date(to_char(dt_previsao_p,'dd/mm/yyyy') || ' 08:00:00','dd/mm/yyyy hh24:mi:ss'))
	into STRICT	dt_previsao_anterior_w
	from	w_resumo_migracao
	where	nr_seq_projeto = nr_seq_projeto_p
	and	trunc(dt_resumo,'dd') = trunc(dt_previsao_p,'dd');

	select	sum(coalesce(obter_horas_sent_proj_migr(nr_sequencia, nr_seq_estagio), 0))
	into STRICT	qt_horas_real_proj_w
	from	proj_projeto
	where	nr_sequencia = nr_seq_projeto_p;

	select	coalesce(dividir(sum(a.qt_minuto),60),0)
	into STRICT	qt_horas_real_os_w
	from	man_ordem_serv_ativ a
	where	trunc(a.dt_atividade,'dd') = trunc(dt_previsao_p,'dd')
	and	trunc(a.dt_atividade,'hh24') between trunc(dt_previsao_anterior_w,'hh24') and trunc(dt_previsao_p,'hh24')
	and	exists (
			SELECT	1
			from	proj_cron_etapa e,
				proj_projeto p
			where	e.nr_sequencia = a.nr_seq_proj_cron_etapa
			and	p.nr_seq_ordem_serv = a.nr_seq_ordem_serv
			and	p.nr_sequencia = nr_seq_projeto_p);

	qt_horas_possiveis_w := ( trunc(dt_previsao_p,'hh24') - dt_previsao_anterior_w ) * 24;

	qt_horas_prev_real_w := (qt_horas_real_proj_w - qt_horas_real_os_w) + qt_horas_possiveis_w;
	end;
end if;
return qt_horas_prev_real_w;
end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_sent_real_proj_migr ( nr_seq_projeto_p bigint, dt_previsao_p timestamp) FROM PUBLIC;
