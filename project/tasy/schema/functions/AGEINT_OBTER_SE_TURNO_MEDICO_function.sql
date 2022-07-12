-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION ageint_obter_se_turno_medico ( cd_medico_p text, dt_agenda_p timestamp, cd_agenda_p bigint, nm_usuario_p text, nr_seq_medico_Regra_p bigint, cd_estabelecimento_p bigint, cd_estab_agenda_p bigint default 0, ie_dia_semana_p text default null, qt_regra_p bigint default 0, qt_regra_med_p bigint default 0, nr_seq_turno_p bigint default null) RETURNS varchar AS $body$
DECLARE

 
ds_retorno_w		varchar(1)	:= 'S';
qt_regra_w			bigint;
qt_regra_ww			bigint;
qt_perm_w			bigint;
ie_dia_semana_w		integer;
qt_perm_diario_w	bigint;
qt_perm_dia_w		bigint;
qt_perm_dia_sem_w	bigint;
cd_estabelecimento_w	bigint;
qt_agenda_medico_w  bigint;
			

BEGIN
--CASO MEXER NESSA FUNCTION MEXER NA Ageint_Obter_Se_Turno_Medico DENTRO DA PCK ageint_sugerir_html5_pck
if (coalesce(ie_dia_semana_p::text, '') = '') then
	select	obter_cod_dia_semana(dt_agenda_p)
	into STRICT	ie_dia_semana_w
	;
else
	ie_dia_semana_w := ie_dia_semana_p;
end if;		

if (cd_estab_agenda_p = 0) then
	select	max(cd_estabelecimento)
	into STRICT	cd_estabelecimento_w
	from	agenda
	where	cd_agenda = cd_agenda_p;
else
	cd_estabelecimento_w := cd_estab_agenda_p;
end if;	

if (qt_regra_p = 0) then
	select	count(1)
	into STRICT	qt_regra_w
	from	ageint_turno_medico
	where	cd_pessoa_fisica	= cd_medico_p
	and		coalesce(ie_situacao, 'A')	= 'A'
	and (nr_seq_medico_regra	= nr_seq_medico_regra_p or (coalesce(nr_seq_medico_Regra_p::text, '') = '' and coalesce(nr_seq_medico_regra::text, '') = ''))
	and		((cd_estabelecimento = cd_estabelecimento_w) or (coalesce(cd_estabelecimento::text, '') = ''))
	and (cd_agenda	= cd_agenda_p or coalesce(cd_Agenda::text, '') = '')  LIMIT 1;
else
	qt_regra_w := qt_regra_p;
end if;

if (qt_regra_w	> 0) then
	select	count(1)
	into STRICT	qt_perm_dia_sem_w
	from	ageint_turno_medico
	where	cd_pessoa_fisica	= cd_medico_p
	and		coalesce(ie_situacao, 'A')	= 'A'
	and		((coalesce(dt_inicial_vigencia::text, '') = '') or (trunc(dt_inicial_vigencia) <= pkg_date_utils.start_of(dt_agenda_p,'DD',0)))
	and		((coalesce(dt_final_vigencia::text, '') = '') or (trunc(dt_final_vigencia)+86399/86400 >= pkg_date_utils.start_of(dt_agenda_p,'DD',0)))
	and		dt_dia_semana = ie_dia_semana_w
	and (nr_seq_medico_regra	= nr_seq_medico_regra_p or (coalesce(nr_seq_medico_Regra_p::text, '') = '' and coalesce(nr_seq_medico_regra::text, '') = ''))
	and		((cd_estabelecimento = cd_estabelecimento_w) or (coalesce(cd_estabelecimento::text, '') = ''))
	and (cd_agenda	= cd_agenda_p or coalesce(cd_Agenda::text, '') = '')
	and		obter_se_gerar_turno_agecons(trunc(dt_inicial_vigencia),ie_frequencia,dt_agenda_p) = 'S'
	and		((Obter_Semana_Dia_Agecons(dt_agenda_p,dt_dia_semana) = coalesce(ie_semana,0)) or (coalesce(ie_semana,0) = 0))  LIMIT 1;
	
	if (qt_perm_dia_sem_w	> 0) then
	
		select	count(1)
		into STRICT	qt_perm_dia_w
		from	ageint_turno_medico
		where	cd_pessoa_fisica	= cd_medico_p
		and		coalesce(ie_situacao, 'A')	= 'A'
		and		dt_agenda_p 	between pkg_date_utils.get_DateTime(dt_agenda_p, hr_inicial)
						and 	pkg_date_utils.get_DateTime(dt_agenda_p, hr_final) - 1 /1440
		and		((coalesce(dt_inicial_vigencia::text, '') = '') or (trunc(dt_inicial_vigencia) <= pkg_date_utils.start_of(dt_agenda_p, 'DD',0)))
		and		((coalesce(dt_final_vigencia::text, '') = '') or (trunc(dt_final_vigencia)+86399/86400 >= pkg_date_utils.start_of(dt_agenda_p, 'DD', 0)))
		and		dt_dia_semana = ie_dia_semana_w
		and (nr_seq_medico_regra	= nr_seq_medico_regra_p or (coalesce(nr_seq_medico_Regra_p::text, '') = '' and coalesce(nr_seq_medico_regra::text, '') = ''))
		and		((cd_estabelecimento = cd_estabelecimento_w) or (coalesce(cd_estabelecimento::text, '') = ''))
		and (cd_agenda	= cd_agenda_p or coalesce(cd_Agenda::text, '') = '')
		and		obter_se_gerar_turno_agecons(trunc(dt_inicial_vigencia),ie_frequencia,dt_agenda_p) = 'S'
		and		((Obter_Semana_Dia_Agecons(dt_agenda_p,dt_dia_semana) = coalesce(ie_semana,0)) or (coalesce(ie_semana,0) = 0))  LIMIT 1;
		
		if (qt_perm_dia_w	= 0) then
			ds_retorno_w	:= 'N';		
		end if;
		
	else
	
		select	count(1)
		into STRICT	qt_perm_diario_w
		from	ageint_turno_medico
		where	cd_pessoa_fisica	= cd_medico_p
		and		coalesce(ie_situacao, 'A')	= 'A'
		and		dt_agenda_p 	between	pkg_date_utils.get_DateTime(dt_agenda_p, hr_inicial)
						and 	pkg_date_utils.get_DateTime(dt_agenda_p, hr_final) - 1 /1440
		and		((coalesce(dt_inicial_vigencia::text, '') = '') or (trunc(dt_inicial_vigencia) <= pkg_date_utils.start_of(dt_agenda_p, 'DD', 0)))
		and		((coalesce(dt_final_vigencia::text, '') = '') or (trunc(dt_final_vigencia)+86399/86400 >= pkg_date_utils.start_of(dt_agenda_p, 'DD', 0)))
		and		((dt_dia_semana = 9) and (ie_dia_Semana_w not in (7,1)))
		and (nr_seq_medico_regra	= nr_seq_medico_regra_p or (coalesce(nr_seq_medico_Regra_p::text, '') = '' and coalesce(nr_seq_medico_regra::text, '') = ''))
		and		((cd_estabelecimento = cd_estabelecimento_w) or (coalesce(cd_estabelecimento::text, '') = ''))
		and (cd_agenda	= cd_agenda_p or coalesce(cd_Agenda::text, '') = '')
		and		obter_se_gerar_turno_agecons(trunc(dt_inicial_vigencia),ie_frequencia,dt_agenda_p) = 'S'
		and		((Obter_Semana_Dia_Agecons(dt_agenda_p,dt_dia_semana) = coalesce(ie_semana,0)) or (coalesce(ie_semana,0) = 0))  LIMIT 1;
		
		if (qt_perm_diario_w	= 0) then
			ds_retorno_w	:= 'N';		
		end if;
	end if;
else
	select count(1)
	into STRICT   qt_agenda_medico_w
	from   agenda_medico
	where  cd_agenda = cd_agenda_p
	and    coalesce(ie_situacao, 'A') = 'A'
	and		(nr_seq_turno IS NOT NULL AND nr_seq_turno::text <> '')  LIMIT 1;
	
	if (nr_seq_turno_p IS NOT NULL AND nr_seq_turno_p::text <> '') and (qt_agenda_medico_w > 0) then
		
		select	count(1)
		into STRICT	qt_perm_w
		from	agenda_medico am,
			    agenda_horario ah
		where	(((ah.nr_sequencia = nr_seq_turno_p) and (coalesce(am.nr_seq_turno::text, '') = '')) or (am.nr_seq_turno = ah.nr_sequencia AND am.nr_seq_turno = nr_seq_turno_p))
		and     ((am.cd_medico	= cd_medico_p) or (coalesce(cd_medico_p::text, '') = '' and coalesce(am.cd_medico::text, '') = ''))
		and		am.cd_agenda	= cd_agenda_p
		and		((dt_Agenda_p >= am.dt_inicio_vigencia) or (coalesce(am.dt_inicio_vigencia::text, '') = ''))
		and		((dt_agenda_p <= am.dt_fim_vigencia) or (coalesce(am.dt_fim_vigencia::text, '') = ''))
		and		dt_Agenda_p between	pkg_date_utils.get_DateTime(dt_agenda_p, CASE WHEN coalesce(to_char(am.hr_inicial), '0')='0' THEN  CASE WHEN coalesce(to_char(ah.hr_inicial), '0')='0' THEN  to_date('01/01/0001 00:00:00', 'dd/mm/yyyy hh24:mi:ss')  ELSE ah.hr_inicial END   ELSE am.hr_inicial END )
		and 	pkg_date_utils.get_DateTime(dt_agenda_p, CASE WHEN coalesce(to_char(am.hr_final), '0')='0' THEN  CASE WHEN coalesce(to_char(ah.hr_final), '0')='0' THEN  to_date('01/01/0001 00:00:00', 'dd/mm/yyyy hh24:mi:ss')  ELSE ah.hr_final END   ELSE am.hr_final END ) - 1 /1440
		and (am.nr_seq_medico_regra	= nr_seq_medico_regra_p or (coalesce(nr_seq_medico_Regra_p::text, '') = '' and coalesce(am.nr_seq_medico_regra::text, '') = ''))
		and		coalesce(am.ie_permite, 'S') = 'S'
		and		coalesce(am.ie_situacao, 'A') = 'A'  LIMIT 1;				

		if (qt_perm_w	= 0) then
			ds_retorno_w	:= 'N';
		end if;
	else
		if (qt_regra_med_p = 0) then
			select	count(1)
			into STRICT	qt_regra_w
			from	agenda_medico
			where	cd_medico	= cd_medico_p
			and		cd_agenda	= cd_agenda_p
			and		(hr_inicial IS NOT NULL AND hr_inicial::text <> '')
			and		(hr_final IS NOT NULL AND hr_final::text <> '')
			and		coalesce(ie_situacao, 'A') = 'A'
			and (nr_seq_medico_regra	= nr_seq_medico_regra_p or (coalesce(nr_seq_medico_Regra_p::text, '') = '' and coalesce(nr_seq_medico_regra::text, '') = ''))  LIMIT 1;
		else
			qt_regra_w := qt_regra_med_p;
		end if;

		if (qt_regra_w > 0) then
			select	count(1)
			into STRICT	qt_perm_w
			from	agenda_medico
			where	cd_medico	= cd_medico_p 
			and		cd_agenda	= cd_agenda_p
			and		((dt_Agenda_p >= dt_inicio_vigencia) or (coalesce(dt_inicio_vigencia::text, '') = ''))
			and		((dt_agenda_p <= dt_fim_vigencia) or (coalesce(dt_fim_vigencia::text, '') = ''))
			and		dt_Agenda_p 	between	pkg_date_utils.get_DateTime(dt_agenda_p, CASE WHEN coalesce(to_char(hr_inicial), '0')='0' THEN  to_date('01/01/0001 00:00:00', 'dd/mm/yyyy hh24:mi:ss')  ELSE hr_inicial END )
							and 	pkg_date_utils.get_DateTime(dt_agenda_p, CASE WHEN coalesce(to_char(hr_final), '0')='0' THEN  to_date('01/01/0001 00:00:00', 'dd/mm/yyyy hh24:mi:ss')  ELSE hr_final END ) - 1 /1440
			and (nr_seq_medico_regra	= nr_seq_medico_regra_p or (coalesce(nr_seq_medico_Regra_p::text, '') = '' and coalesce(nr_seq_medico_regra::text, '') = ''))
			and		coalesce(ie_permite, 'S') = 'S'
			and		coalesce(ie_situacao, 'A') = 'A'  LIMIT 1;				
			
			if (qt_perm_w	= 0) then
				ds_retorno_w	:= 'N';
			end if;
		end if;
	end if;
end if;

return	ds_retorno_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION ageint_obter_se_turno_medico ( cd_medico_p text, dt_agenda_p timestamp, cd_agenda_p bigint, nm_usuario_p text, nr_seq_medico_Regra_p bigint, cd_estabelecimento_p bigint, cd_estab_agenda_p bigint default 0, ie_dia_semana_p text default null, qt_regra_p bigint default 0, qt_regra_med_p bigint default 0, nr_seq_turno_p bigint default null) FROM PUBLIC;

