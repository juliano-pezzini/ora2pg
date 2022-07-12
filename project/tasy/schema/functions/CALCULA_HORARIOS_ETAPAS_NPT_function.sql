-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION calcula_horarios_etapas_npt ( nr_prescricao_p bigint) RETURNS varchar AS $body$
DECLARE


i			bigint := 1;
ds_retorno_w		varchar(200) := '';
qt_fase_npt_w		bigint;
hr_prim_horario_w	timestamp;
qt_hora_w		timestamp;
Mascara_w		varchar(10);
nr_horas_intervalo_w	bigint;


BEGIN

select	qt_fase_npt,
	to_date(to_char(clock_timestamp(),'dd/mm/yyyy ')||hr_prim_horario ||':00','dd/mm/yyyy hh24:mi:ss')
into STRICT	qt_fase_npt_w,
	hr_prim_horario_w
from	nut_pac
where	nr_sequencia	= (	SELECT	min(nr_sequencia)
				from	nut_pac
				where	nr_prescricao	= nr_prescricao_p);

nr_horas_intervalo_w	:= dividir(24,qt_fase_npt_w);


if (to_char(hr_prim_horario_w, 'mi') <> '00') then
	Mascara_w 			:= 'hh24:mi';
else
	Mascara_w 			:= 'hh24';
end if;

qt_hora_w	:= hr_prim_horario_w;

For i in 1.. qt_fase_npt_w LOOP
	begin

	ds_retorno_w 	:= 	ds_retorno_w || ' ' || wheb_mensagem_pck.get_texto(307054, 'NR_PRIM_HOR=' ||  to_char(trunc(qt_hora_w,'mi'),Mascara_w)) || ' ' || -- das #@NR_PRIM_HOR#@ às
				to_char(trunc(qt_hora_w,'mi') + (nr_horas_intervalo_w / 24),Mascara_w) || ' - ';
	qt_hora_w	:= trunc(qt_hora_w,'mi') + ((24 / qt_fase_npt_w) / 24);

	end;
END LOOP;

return ds_retorno_w;

End;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION calcula_horarios_etapas_npt ( nr_prescricao_p bigint) FROM PUBLIC;

