-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_se_imprimi_turno ( nr_prescricao_p bigint, nr_seq_turno_p bigint, qt_hora_antes_p bigint, dt_horario_p timestamp) RETURNS varchar AS $body$
DECLARE


retorno_w 					varchar(1) := 'N';
dt_horario_w 				timestamp;
dt_impressao_w 				timestamp;
hr_inicial_w				varchar(5);
hr_final_w					varchar(5);
cd_estabelecimento_w		smallint;
cd_setor_atendimento_w		integer;
dt_atual_w					timestamp	:= clock_timestamp();


C01 CURSOR FOR
	SELECT	to_char(b.hr_inicial,'hh24:mi'),
			to_char(b.hr_final,'hh24:mi')
	from	regra_turno_disp_param b,
			regra_turno_disp a
	where	a.nr_sequencia		= b.nr_seq_turno
	and		a.cd_estabelecimento	= cd_estabelecimento_w
	and		a.nr_sequencia		= nr_seq_turno_p
	and (coalesce(b.cd_setor_atendimento,cd_setor_atendimento_w)	= cd_setor_atendimento_w)
	order by
			coalesce(b.cd_setor_atendimento,0),
			to_char(b.hr_inicial,'hh24:mi');


BEGIN

dt_horario_w 	:= dt_horario_p;

select	max(cd_setor_atendimento),
		max(coalesce(cd_estabelecimento,1))
into STRICT	cd_setor_atendimento_w,
		cd_estabelecimento_w
from	prescr_medica
where	nr_prescricao		= nr_prescricao_p;

OPEN C01;
LOOP
	FETCH C01 INTO
		hr_inicial_w,
		hr_final_w;
	EXIT WHEN NOT FOUND; /* apply on c01 */
	begin
	hr_inicial_w	:= hr_inicial_w;
	hr_final_w		:= hr_final_w;
	end;
END LOOP;
CLOSE C01;

if (qt_hora_antes_p = 0) then
	dt_atual_w	:= dt_atual_w + 5;
end if;

if (hr_inicial_w > hr_final_w) then
	dt_horario_w	:= dt_horario_w - 1;
end if;

dt_impressao_w 		:= to_date(to_char(dt_horario_w,'dd/mm/yyyy ')||' '|| hr_inicial_w||':00','dd/mm/yyyy hh24:mi:ss') - qt_hora_antes_p/24;

if (dt_impressao_w <= dt_atual_w) then
	retorno_w := 'S';
end if;

return retorno_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_se_imprimi_turno ( nr_prescricao_p bigint, nr_seq_turno_p bigint, qt_hora_antes_p bigint, dt_horario_p timestamp) FROM PUBLIC;
