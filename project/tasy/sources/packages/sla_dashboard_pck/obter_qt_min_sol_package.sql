-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';




CREATE OR REPLACE FUNCTION sla_dashboard_pck.obter_qt_min_sol ( nr_seq_ordem_serv_p bigint) RETURNS bigint AS $body$
DECLARE


dt_min_resp_w		timestamp;
dt_inicio_sla_w	 	man_ordem_serv_sla.dt_inicio_sla%type;
ie_tempo_termino_w	man_ordem_serv_sla.ie_tempo_termino%type;
ie_tempo_w		man_ordem_serv_sla.ie_tempo%type;
qt_solucao_com_w	bigint;
nm_timezone_database_w	varchar(50);
nr_seq_localizacao_w	bigint;
ie_loc_exterior_w		varchar(1);
dt_ordem_w		timestamp;

BEGIN

select 	max(nr_seq_localizacao)
into STRICT	nr_seq_localizacao_w
from	man_ordem_servico
where	nr_sequencia = nr_seq_ordem_serv_p;

ie_loc_exterior_w := sla_dashboard_pck.obter_loc_exterior(nr_seq_ordem_serv_p);

select	max(dt_inicio_sla),
	max(ie_tempo_termino),
	max(ie_tempo),
	max(dt_ordem)
into STRICT	dt_inicio_sla_w,
	ie_tempo_termino_w,
	ie_tempo_w,
	dt_ordem_w
from	man_ordem_serv_sla
where	nr_seq_ordem = nr_seq_ordem_serv_p;

select	max(nm_timezone_database)
into STRICT	nm_timezone_database_w
from	man_localizacao_horario
where	nr_seq_localizacao = nr_seq_localizacao_w;

if (ie_loc_exterior_w = 'S') and (nm_timezone_database_w IS NOT NULL AND nm_timezone_database_w::text <> '') then
	Select
		coalesce((select	sum(sla_dashboard_pck.man_obter_temp_estagio_tz(x.nr_sequencia,x.nr_seq_ordem,CASE WHEN coalesce(ie_tempo_termino_w, ie_tempo_w)='COR' THEN 'M' WHEN coalesce(ie_tempo_termino_w, ie_tempo_w)='COM' THEN 'MC' END ))
		from	man_ordem_serv_estagio x
		where	x.nr_seq_ordem = a.nr_sequencia
		and	x.dt_atualizacao between coalesce(dt_inicio_sla_w, dt_ordem_w) and sla_dashboard_pck.obter_data_fim_solucao(nr_seq_ordem_serv_p, dt_inicio_sla_w, dt_ordem_w)--fim_mes(nvl(dt_inicio_sla_w, dt_ordem_w))
		and	x.nr_seq_estagio not in (2,261,1511,1902,1341,511,9,121,41,2231,562,1061,1071,2155,791,1234)),0)
	into STRICT	qt_solucao_com_w
	from	man_ordem_servico a
	where	a.nr_sequencia = nr_seq_ordem_serv_p;
	--Quando existir insert coin e nao tiver estagio no novo mes ainda

	if (coalesce(qt_solucao_com_w::text, '') = '') then
		Select (select	sum(sla_dashboard_pck.man_obter_temp_estagio_tz(x.nr_sequencia,x.nr_seq_ordem,CASE WHEN coalesce(ie_tempo_termino_w, ie_tempo_w)='COR' THEN 'M' WHEN coalesce(ie_tempo_termino_w, ie_tempo_w)='COM' THEN 'MC' END ))
			from	man_ordem_serv_estagio x
			where	x.nr_seq_ordem = a.nr_sequencia
			and	x.dt_atualizacao between dt_ordem_w and sla_dashboard_pck.obter_data_fim_solucao(nr_seq_ordem_serv_p, dt_inicio_sla_w, dt_ordem_w)
			and	x.nr_seq_estagio not in (2,261,1511,1902,1341,511,9,121,41,2231,562,1061,1071,2155,791,1234))
		into STRICT	qt_solucao_com_w
		from	man_ordem_servico a
		where	a.nr_sequencia = nr_seq_ordem_serv_p;
	end if;
else
	Select
		coalesce((select	sum(man_obter_tempo_estagio(x.nr_sequencia,x.nr_seq_ordem,CASE WHEN coalesce(ie_tempo_termino_w, ie_tempo_w)='COR' THEN 'M' WHEN coalesce(ie_tempo_termino_w, ie_tempo_w)='COM' THEN 'MC' END ))
		from	man_ordem_serv_estagio x
		where	x.nr_seq_ordem = a.nr_sequencia
		and	x.dt_atualizacao between coalesce(dt_inicio_sla_w, dt_ordem_w) and sla_dashboard_pck.obter_data_fim_solucao(nr_seq_ordem_serv_p, dt_inicio_sla_w, dt_ordem_w)
		and	x.nr_seq_estagio not in (2,261,1511,1902,1341,511,9,121,41,2231,562,1061,1071,2155,791,1234)),0)
	into STRICT	qt_solucao_com_w
	from	man_ordem_servico a
	where	a.nr_sequencia = nr_seq_ordem_serv_p;
	
	if (coalesce(qt_solucao_com_w::text, '') = '') then
		--Quando existir insert coin e nao tiver estagio no novo mes ainda

		Select (select	sum(man_obter_tempo_estagio(x.nr_sequencia,x.nr_seq_ordem,CASE WHEN coalesce(ie_tempo_termino_w, ie_tempo_w)='COR' THEN 'M' WHEN coalesce(ie_tempo_termino_w, ie_tempo_w)='COM' THEN 'MC' END ))
			from	man_ordem_serv_estagio x
			where	x.nr_seq_ordem = a.nr_sequencia
			and	x.dt_atualizacao between dt_ordem_w and sla_dashboard_pck.obter_data_fim_solucao(nr_seq_ordem_serv_p, dt_inicio_sla_w, dt_ordem_w)
			and	x.nr_seq_estagio not in (2,261,1511,1902,1341,511,9,121,41,2231,562,1061,1071,2155,791,1234))
		into STRICT	qt_solucao_com_w
		from	man_ordem_servico a
		where	a.nr_sequencia = nr_seq_ordem_serv_p;
	
	end if;

end if;

return	qt_solucao_com_w;

END;

$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON FUNCTION sla_dashboard_pck.obter_qt_min_sol ( nr_seq_ordem_serv_p bigint) FROM PUBLIC;