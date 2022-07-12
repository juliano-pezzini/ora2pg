-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION ageint_obter_se_hor_anest ( cd_agenda_p bigint, dt_agenda_p timestamp, nr_seq_proc_interno_p bigint) RETURNS varchar AS $body$
DECLARE


ds_retorno_w		varchar(1)	:= 'S';
nr_seq_anest_turno_w	bigint;
qt_perm_anest_w		bigint	:= 0;
qt_regra_w		bigint;
dt_dia_semana_w		bigint;

C01 CURSOR FOR
	SELECT	nr_seq_anest_turno
	from	ageint_agenda_turno_anest
	where	cd_agenda	= cd_agenda_p
	and	qt_perm_anest_w	= 0
	order by 1;


BEGIN
select	count(*)
into STRICT	qt_regra_w
from	ageint_agenda_turno_anest
where	cd_agenda	= cd_agenda_p;

if (qt_regra_w	> 0) then
	dt_dia_semana_w	:= obter_cod_dia_semana(dt_agenda_p);

	open C01;
	loop
	fetch C01 into
		nr_seq_anest_turno_w;
	EXIT WHEN NOT FOUND; /* apply on C01 */
		begin
		if (qt_perm_anest_w	= 0) then
			select	count(*)
			into STRICT	qt_perm_anest_w
			from	ageint_anestesia_turno
			where	nr_sequencia		= nr_seq_anest_turno_w
			and 	coalesce(cd_estabelecimento, wheb_usuario_pck.get_cd_estabelecimento) = wheb_usuario_pck.get_cd_estabelecimento
			and	((trunc(dt_agenda_p) >= trunc(dt_inicial_vigencia)) or (coalesce(dt_inicial_vigencia::text, '') = ''))
			and	((trunc(dt_agenda_p) <= trunc(dt_final_vigencia)) or (coalesce(dt_final_vigencia::text, '') = ''))
			and	((dt_dia_semana	= dt_dia_semana_w) or (dt_dia_semana = 9 and dt_dia_semana_w not in (1,7)))
			and	dt_agenda_p between to_date(to_char(dt_agenda_p,'dd/mm/yyyy') || ' ' || to_char(hr_inicial,'hh24:mi:ss'), 'dd/mm/yyyy hh24:mi:ss')
					and to_date(to_char(dt_agenda_p,'dd/mm/yyyy') || ' ' || to_char(hr_final,'hh24:mi:ss'), 'dd/mm/yyyy hh24:mi:ss');
		end if;
		end;
	end loop;
	close C01;

	if (qt_perm_anest_w	> 0) then
		ds_retorno_w	:= 'S';
	else
		ds_retorno_w	:= 'N';
	end if;
end if;

return	ds_retorno_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION ageint_obter_se_hor_anest ( cd_agenda_p bigint, dt_agenda_p timestamp, nr_seq_proc_interno_p bigint) FROM PUBLIC;
