-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_horas_etapa_recurso (nr_seq_etapa_p bigint) RETURNS bigint AS $body$
DECLARE


qt_horas_etapa_w	double precision := 0;
qt_hora_prev_w		double precision;
qt_recurso_w		bigint;
ie_fase_w			varchar(1);
nr_seq_cronograma_w	bigint;


BEGIN
select	qt_hora_prev,
	ie_fase,
	nr_seq_cronograma
into STRICT	qt_hora_prev_w,
	ie_fase_w,
	nr_seq_cronograma_w
from	proj_cron_etapa
where	nr_sequencia = nr_seq_etapa_p
and	nr_sequencia not in (401694);

if (ie_fase_w = 'S') then

	begin

	select	coalesce(sum(obter_horas_etapa_recurso(nr_sequencia)),0)
	into STRICT	qt_horas_etapa_w
	from	proj_cron_etapa
	where	nr_seq_superior = nr_seq_etapa_p
	and		nr_seq_cronograma = nr_seq_cronograma_w;

	exception
	when others then
		qt_horas_etapa_w := 0;
	end;



elsif (ie_fase_w = 'N') then

	select	count(*)
	into STRICT	qt_recurso_w
	from	proj_cron_etapa_equipe
	where	nr_seq_etapa_cron = nr_seq_etapa_p
	and	((ie_recurso_externo = 'N') or (coalesce(ie_recurso_externo::text, '') = ''));

	if (qt_recurso_w = 0) then
		qt_recurso_w := 1;
	end if;

	qt_horas_etapa_w := qt_hora_prev_w / qt_recurso_w;

end if;

return	qt_horas_etapa_w;


end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_horas_etapa_recurso (nr_seq_etapa_p bigint) FROM PUBLIC;
