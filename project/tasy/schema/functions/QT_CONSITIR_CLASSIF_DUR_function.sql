-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION qt_consitir_classif_dur ( dt_agenda_p timestamp, qt_tempo_medico_p bigint, nr_seq_local_p bigint, cd_setor_atendimento_p bigint) RETURNS varchar AS $body$
DECLARE


nr_seq_classif_w	bigint;
qt_permitida_w		bigint;
hr_inicial_w		timestamp;
hr_final_w			timestamp;
qt_agendamento_w	bigint;
ds_retorno_w		varchar(1)	:= 'S';
nr_seq_regra_w		bigint;
nr_seq_grupo_quimio_w	bigint;


C01 CURSOR FOR
	SELECT	nr_sequencia
	from	qt_regra_classif_marc
	where	nr_seq_classif = nr_seq_classif_w
	and		((nr_seq_local = nr_seq_local_p) or (coalesce(nr_seq_local::text, '') = ''))
	and		((nr_seq_grupo_quimio = nr_seq_grupo_quimio_w) or (coalesce(nr_seq_grupo_quimio::text, '') = ''))
	and		dt_agenda_p between to_date(to_char(dt_agenda_p,'dd/mm/yyyy') || ' ' || coalesce(to_char(hr_inicial,'hh24:mi:ss'),'00:00:00'),'dd/mm/yyyy hh24:mi:ss')
					and to_date(to_char(dt_agenda_p,'dd/mm/yyyy') || ' ' || coalesce(to_char(hr_final,'hh24:mi:ss'),'23:59:59'),'dd/mm/yyyy hh24:mi:ss')
	and		((cd_setor_atendimento = cd_setor_atendimento_p) or (coalesce(cd_setor_atendimento::text, '') = ''))
	order by coalesce(nr_seq_grupo_quimio,0),
		 coalesce(nr_seq_local,0);


BEGIN

select	coalesce(max(nr_sequencia),0)
into STRICT	nr_seq_classif_w
from	qt_classif_duracao
where	nr_minuto_duracao = qt_tempo_medico_p;

select	max(nr_seq_grupo_quimio)
into STRICT	nr_seq_grupo_quimio_w
from	qt_local
where	nr_sequencia = nr_seq_local_p;

if (nr_seq_classif_w > 0) then

	open C01;
	loop
	fetch C01 into
		nr_seq_regra_w;
	EXIT WHEN NOT FOUND; /* apply on C01 */
		begin
		nr_seq_regra_w := nr_seq_regra_w;
		end;
	end loop;
	close C01;

	select	max(qt_permitida),
		max(hr_inicial),
		max(hr_final)
	into STRICT	qt_permitida_w,
		hr_inicial_w,
		hr_final_w
	from	qt_regra_classif_marc
	where	nr_sequencia = nr_seq_regra_w;

	if (qt_permitida_w IS NOT NULL AND qt_permitida_w::text <> '') then
		select	count(*)
		into STRICT	qt_agendamento_w
		from	agenda_quimio a,
			qt_local b
		where	a.nr_seq_local = b.nr_sequencia
		and	a.dt_agenda between to_date(to_char(dt_agenda_p,'dd/mm/yyyy') || ' ' || coalesce(to_char(hr_inicial_w,'hh24:mi:ss'),'00:00:00'),'dd/mm/yyyy hh24:mi:ss') and
			                  to_date(to_char(dt_agenda_p,'dd/mm/yyyy') || ' ' || coalesce(to_char(hr_final_w,'hh24:mi:ss'),'23:59:59'),'dd/mm/yyyy hh24:mi:ss')
		and	a.ie_tipo_pend_agenda = 'Q'
		and	coalesce(a.dt_cancelada::text, '') = ''
		and	coalesce(a.dt_falta::text, '') = ''
		and	coalesce(b.ie_situacao,'A') = 'A'
		and	a.nr_minuto_duracao	= qt_tempo_medico_p;

		if (qt_agendamento_w >= qt_permitida_w) then
			ds_retorno_w := 'N';
		end if;
	end if;

end if;


return	ds_retorno_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION qt_consitir_classif_dur ( dt_agenda_p timestamp, qt_tempo_medico_p bigint, nr_seq_local_p bigint, cd_setor_atendimento_p bigint) FROM PUBLIC;

