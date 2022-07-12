-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION rp_obter_se_mod_possui_tre ( nr_seq_modelo_p bigint, dt_inicio_p timestamp, dt_fim_p timestamp, cd_pessoa_fisica_p text) RETURNS varchar AS $body$
DECLARE


dt_inicio_w		timestamp;
ie_dia_semana_w	smallint;
hr_horario_w	timestamp;
qt_valida_w		bigint;
ds_retorno_w	varchar(1) := 'N';

C01 CURSOR FOR
	SELECT	ie_dia_semana,
			hr_horario
	from	RP_ITEM_MODELO_AGENDA
	where	nr_seq_modelo = nr_seq_modelo_p;



BEGIN

dt_inicio_w := dt_inicio_p;

while(dt_inicio_w <= dt_fim_p) loop
	begin
	open C01;
	loop
	fetch C01 into
			ie_dia_semana_w,
			hr_horario_w;
	EXIT WHEN NOT FOUND or (ds_retorno_w = 'S');  /* apply on C01 */
		begin
		if (obter_cod_dia_semana(dt_inicio_w) = ie_dia_semana_w) or (ds_retorno_w = 'N') then

			select	count(*)
			into STRICT	qt_valida_w
			from	tre_agenda b,
					tre_candidato c,
					tre_agenda_turno d
			where	c.nr_seq_agenda = b.nr_sequencia
			and		d.nr_seq_agenda_tre = b.nr_sequencia
			and		cd_pessoa_fisica_p = c.cd_pessoa_fisica
			and		dt_inicio_w	between inicio_dia(b.dt_inicio) and fim_dia(b.dt_termino)
			and		to_date(to_char(hr_horario_w,'hh24:mi'),'hh24:mi')	between to_date(to_char(d.HR_INICIAL,'hh24:mi'),'hh24:mi') and to_date(to_char(d.hr_final,'hh24:mi'),'hh24:mi')
			and		((dt_inicio_w between d.dt_inicio_vigencia and fim_dia(d.dt_fim_vigencia)) or ((coalesce(d.dt_inicio_vigencia::text, '') = '') or (coalesce(d.dt_fim_vigencia::text, '') = '')));

			if (qt_valida_w > 0) then
				ds_retorno_w := 'S';
			end if;
		end if;
		end;
	end loop;
	close C01;
	dt_inicio_w := dt_inicio_w + 1;
	end;
end loop;

return	ds_retorno_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION rp_obter_se_mod_possui_tre ( nr_seq_modelo_p bigint, dt_inicio_p timestamp, dt_fim_p timestamp, cd_pessoa_fisica_p text) FROM PUBLIC;

