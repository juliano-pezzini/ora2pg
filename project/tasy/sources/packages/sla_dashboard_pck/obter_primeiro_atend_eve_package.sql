-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';




CREATE OR REPLACE FUNCTION sla_dashboard_pck.obter_primeiro_atend_eve ( nr_seq_ordem_serv_p bigint, qt_min_inicio_p bigint) RETURNS bigint AS $body$
DECLARE


dt_min_resp_w	timestamp;
dt_atendimento_w timestamp;
qt_min_total_res_w	bigint;
dt_inicio_sla_w		timestamp;
cd_estabelecimento_w	bigint;
ie_tempo_w 		varchar(10);
ie_loc_exterior_w		varchar(1);
nr_seq_localizacao_w	bigint;
nm_timezone_database_w	varchar(50);
qt_min_inicio_w		man_ordem_serv_sla.qt_min_inicio%type;
nr_seq_evento_sla_w	man_sla_evento.nr_sequencia%type;
nr_seq_ultimo_sla_w	man_sla_evento.nr_sequencia%type;

BEGIN

select min(nr_sequencia)
into STRICT	nr_seq_evento_sla_w
from	man_sla_evento
where	nr_seq_ordem = nr_seq_ordem_serv_p
and	ie_tipo_evento in ('1','3');

select max(nr_sequencia)
into STRICT	nr_seq_ultimo_sla_w
from	man_sla_evento
where	nr_seq_ordem = nr_seq_ordem_serv_p
and	ie_tipo_evento in ('1','3','10');

select	max(dt_atualizacao)
into STRICT	dt_inicio_sla_w
from	man_sla_evento
where	nr_sequencia = nr_seq_evento_sla_w;

select	coalesce(max(ie_tempo), 'COM')
into STRICT	ie_tempo_w
from	man_sla_evento
where	nr_sequencia = nr_seq_ultimo_sla_w;

select	max(nr_seq_localizacao)
into STRICT	nr_seq_localizacao_w
from	man_ordem_servico
where	nr_sequencia =	nr_seq_ordem_serv_p;

if (nr_seq_localizacao_w IS NOT NULL AND nr_seq_localizacao_w::text <> '') then
	select	max(nm_timezone_database)
	into STRICT	nm_timezone_database_w
	from	man_localizacao_horario
	where	nr_seq_localizacao = nr_seq_localizacao_w;
else
	nm_timezone_database_w := null;
end if;

ie_loc_exterior_w := sla_dashboard_pck.obter_loc_exterior(nr_seq_ordem_serv_p);

if (ie_loc_exterior_w = 'S') and (nr_seq_localizacao_w IS NOT NULL AND nr_seq_localizacao_w::text <> '') then
	dt_atendimento_w := sla_dashboard_pck.obter_dt_primeiro_atend(nr_seq_ordem_serv_p);

	if (ie_tempo_w = 'COR') then
	
		qt_min_total_res_w := ((sla_dashboard_pck.obter_datetime_tz(dt_atendimento_w, nm_timezone_database_w) - sla_dashboard_pck.obter_datetime_tz(dt_inicio_sla_w, nm_timezone_database_w)) * 1440);
		
	elsif (ie_tempo_w = 'COM') then
	
		qt_min_total_res_w := sla_dashboard_pck.obter_tempo_comercial_loc_tz(dt_inicio_sla_w, dt_atendimento_w, 'MC', nr_seq_localizacao_w);
	
	end if;
else
	dt_atendimento_w := sla_dashboard_pck.obter_dt_primeiro_atend(nr_seq_ordem_serv_p);

	if (ie_tempo_w = 'COR') then
	
		qt_min_total_res_w := ((dt_atendimento_w - dt_inicio_sla_w) * 1440);
		
	elsif (ie_tempo_w = 'COM') then
	
		qt_min_total_res_w := sla_dashboard_pck.man_obter_min_com(1, dt_inicio_sla_w, dt_atendimento_w);
	
	end if;
end if;

return	qt_min_total_res_w;

END;

$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON FUNCTION sla_dashboard_pck.obter_primeiro_atend_eve ( nr_seq_ordem_serv_p bigint, qt_min_inicio_p bigint) FROM PUBLIC;
