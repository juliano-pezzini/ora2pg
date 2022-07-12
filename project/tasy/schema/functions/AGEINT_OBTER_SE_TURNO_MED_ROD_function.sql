-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION ageint_obter_se_turno_med_rod ( cd_medico_p text, dt_agenda_p timestamp, cd_agenda_p bigint, nm_usuario_p text, nr_seq_medico_Regra_p bigint, cd_estabelecimento_p bigint) RETURNS varchar AS $body$
DECLARE

 
ds_retorno_w		varchar(1)	:= 'S';
qt_regra_w		bigint;
qt_perm_w		bigint;
ie_dia_semana_w		integer;
qt_perm_diario_w	bigint;
qt_perm_dia_w		bigint;
qt_perm_dia_sem_w	bigint;
			

BEGIN
select	obter_cod_dia_semana(dt_agenda_p)
into STRICT	ie_dia_semana_w
;

select	count(1)
into STRICT	qt_regra_w
from	ageint_turno_medico
where	cd_pessoa_fisica		= cd_medico_p
and		coalesce(ie_situacao, 'A')	= 'A'
and (nr_seq_medico_regra	= nr_seq_medico_regra_p or (coalesce(nr_seq_medico_Regra_p::text, '') = '' and coalesce(nr_seq_medico_regra::text, '') = ''))
and		((cd_estabelecimento 	= cd_estabelecimento_p) or (coalesce(cd_estabelecimento::text, '') = ''))
and (cd_agenda				= cd_agenda_p or coalesce(cd_Agenda::text, '') = '')  LIMIT 1;


if (qt_regra_w	> 0) then
	select	count(1)
	into STRICT	qt_perm_dia_sem_w
	from	ageint_turno_medico
	where	cd_pessoa_fisica	= cd_medico_p
	and		coalesce(ie_situacao, 'A')	= 'A'
	and		((coalesce(dt_inicial_vigencia::text, '') = '') or (dt_inicial_vigencia <= trunc(dt_agenda_p)))
	and		((coalesce(dt_final_vigencia::text, '') = '') or (dt_final_vigencia >= trunc(dt_agenda_p)))
	and		dt_dia_semana = ie_dia_semana_w
	and (nr_seq_medico_regra	= nr_seq_medico_regra_p or (coalesce(nr_seq_medico_Regra_p::text, '') = '' and coalesce(nr_seq_medico_regra::text, '') = ''))
	and		((cd_estabelecimento = cd_estabelecimento_p) or (coalesce(cd_estabelecimento::text, '') = ''))
	and (cd_agenda	= cd_agenda_p or coalesce(cd_Agenda::text, '') = '')
	and		obter_se_gerar_turno_agecons(dt_inicial_vigencia,ie_frequencia,dt_agenda_p) = 'S'
	and		((Obter_Semana_Dia_Agecons(dt_agenda_p,dt_dia_semana) = coalesce(ie_semana,0)) or (coalesce(ie_semana,0) = 0))  LIMIT 1;	
	
	
	if (qt_perm_dia_sem_w	> 0) then
	
		select	count(1)
		into STRICT	qt_perm_dia_w
		from	ageint_turno_medico
		where	cd_pessoa_fisica	= cd_medico_p
		and		coalesce(ie_situacao, 'A')	= 'A'
		and		((coalesce(dt_inicial_vigencia::text, '') = '') or (dt_inicial_vigencia <= trunc(dt_agenda_p)))
		and		((coalesce(dt_final_vigencia::text, '') = '') or (dt_final_vigencia >= trunc(dt_agenda_p)))
		and		dt_dia_semana = ie_dia_semana_w
		and (nr_seq_medico_regra	= nr_seq_medico_regra_p or (coalesce(nr_seq_medico_Regra_p::text, '') = '' and coalesce(nr_seq_medico_regra::text, '') = ''))
		and		((cd_estabelecimento = cd_estabelecimento_p) or (coalesce(cd_estabelecimento::text, '') = ''))
		and (cd_agenda	= cd_agenda_p or coalesce(cd_Agenda::text, '') = '')
		and		obter_se_gerar_turno_agecons(dt_inicial_vigencia,ie_frequencia,dt_agenda_p) = 'S'
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
		and		((coalesce(dt_inicial_vigencia::text, '') = '') or (dt_inicial_vigencia <= trunc(dt_agenda_p)))
		and		((coalesce(dt_final_vigencia::text, '') = '') or (dt_final_vigencia >= trunc(dt_agenda_p)))
		and		((dt_dia_semana = 9) and (ie_dia_Semana_w not in (7,1)))
		and (nr_seq_medico_regra	= nr_seq_medico_regra_p or (coalesce(nr_seq_medico_Regra_p::text, '') = '' and coalesce(nr_seq_medico_regra::text, '') = ''))
		and		((cd_estabelecimento = cd_estabelecimento_p) or (coalesce(cd_estabelecimento::text, '') = ''))
		and (cd_agenda	= cd_agenda_p or coalesce(cd_Agenda::text, '') = '')
		and		obter_se_gerar_turno_agecons(dt_inicial_vigencia,ie_frequencia,dt_agenda_p) = 'S'
		and		((Obter_Semana_Dia_Agecons(dt_agenda_p,dt_dia_semana) = coalesce(ie_semana,0)) or (coalesce(ie_semana,0) = 0))  LIMIT 1;
		
		if (qt_perm_diario_w	= 0) then
			ds_retorno_w	:= 'N';		
		end if;
	end if;
else
	select	count(1)
	into STRICT	qt_regra_w
	from	agenda_medico
	where	cd_medico	= cd_medico_p
	and		cd_agenda	= cd_agenda_p
	and		(hr_inicial IS NOT NULL AND hr_inicial::text <> '')
	and		(hr_final IS NOT NULL AND hr_final::text <> '')
	and		coalesce(ie_situacao, 'A') = 'A'
	and (nr_seq_medico_regra	= nr_seq_medico_regra_p or (coalesce(nr_seq_medico_Regra_p::text, '') = '' and coalesce(nr_seq_medico_regra::text, '') = ''))  LIMIT 1;

	if (qt_regra_w > 0) then
		select	count(1)
		into STRICT	qt_perm_w
		from	agenda_medico
		where	cd_medico	= cd_medico_p 
		and		cd_agenda	= cd_agenda_p
		and		((dt_Agenda_p >= dt_inicio_vigencia) or (coalesce(dt_inicio_vigencia::text, '') = ''))
		and		((dt_agenda_p <= dt_fim_vigencia) or (coalesce(dt_fim_vigencia::text, '') = ''))
		and (nr_seq_medico_regra	= nr_seq_medico_regra_p or (coalesce(nr_seq_medico_Regra_p::text, '') = '' and coalesce(nr_seq_medico_regra::text, '') = ''))
		and		coalesce(ie_situacao, 'A') = 'A'  LIMIT 1;
		
		if (qt_perm_w	= 0) then
			ds_retorno_w	:= 'N';
		end if;
	end if;
end if;

return	ds_retorno_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION ageint_obter_se_turno_med_rod ( cd_medico_p text, dt_agenda_p timestamp, cd_agenda_p bigint, nm_usuario_p text, nr_seq_medico_Regra_p bigint, cd_estabelecimento_p bigint) FROM PUBLIC;

