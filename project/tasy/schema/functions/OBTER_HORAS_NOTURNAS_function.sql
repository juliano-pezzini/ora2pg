-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_horas_noturnas (nr_seq_rat_p bigint) RETURNS bigint AS $body$
DECLARE


nr_horas_extras_w	double precision;
dt_inicial_w		timestamp;
dt_final_w		timestamp;
data_ini_extra_w	timestamp;
data_fim_extra_w	timestamp;
data_aux_w		timestamp;
data_aux1_w		timestamp;
total_horas_ativ_w	double precision;
qt_intervalo_dias_w	bigint;
contador_w		bigint;
total_horas_rat_w	double precision;
teste_w			varchar(255);

c01 CURSOR FOR
SELECT	dt_inicio_ativ,
	dt_fim_ativ
from 	proj_rat_ativ
where	nr_seq_rat = nr_seq_rat_p
and	(dt_inicio_ativ IS NOT NULL AND dt_inicio_ativ::text <> '')
and	(dt_fim_ativ IS NOT NULL AND dt_fim_ativ::text <> '');



BEGIN

total_horas_rat_w := 0;

open C01;
loop
fetch C01 into
	dt_inicial_w,
	dt_final_w;
EXIT WHEN NOT FOUND; /* apply on C01 */
	begin
	total_horas_ativ_w := 0;
	--consisti as ddatas
	data_ini_extra_w := to_date(to_char(dt_inicial_w,'dd/mm/yyyy') || ' 05:00:00','dd/mm/yyyy hh24:mi:ss');
	data_fim_extra_w := to_date(to_char(dt_inicial_w,'dd/mm/yyyy') || ' 22:00:00','dd/mm/yyyy hh24:mi:ss');

	/*if ((dt_inicial_w < data_ini_extra_w) or
	   (dt_inicial_w > data_fim_extra_w)) or
	   ((dt_final_w < data_ini_extra_w) or
	   (dt_final_w > data_fim_extra_w)) or
	   (to_char(dt_inicial_w,'dd/mm/yyyy') <> to_char(dt_final_w,'dd/mm/yyyy')) then

		data_ini_extra_w := to_date(to_char(dt_final_w,'dd/mm/yyyy') || ' 05:00:00','dd/mm/yyyy hh24:mi:ss');
		data_fim_extra_w := to_date(to_char(dt_final_w,'dd/mm/yyyy') || ' 22:00:00','dd/mm/yyyy hh24:mi:ss');
		teste_w := 'Teste1';
		if (dt_final_w < data_ini_extra_w) or
		   (dt_final_w > data_fim_extra_w) then */
			data_ini_extra_w := to_char(dt_inicial_w,'dd/mm/yyyy');
			data_fim_extra_w := to_char(dt_final_w,'dd/mm/yyyy');

			if data_ini_extra_w = data_fim_extra_w then
				data_ini_extra_w := to_date(to_char(dt_inicial_w,'dd/mm/yyyy') || ' 05:00:00','dd/mm/yyyy hh24:mi:ss');
				data_fim_extra_w := to_date(to_char(dt_inicial_w,'dd/mm/yyyy') || ' 22:00:00','dd/mm/yyyy hh24:mi:ss');
				if dt_inicial_w < data_ini_extra_w then
					if dt_final_w < data_ini_extra_w then
						total_horas_ativ_w := ( dt_final_w - dt_inicial_w) * 24;
					elsif dt_final_w > data_fim_extra_w then
						total_horas_ativ_w := (data_ini_extra_w - dt_inicial_w) * 24;
						total_horas_ativ_w := total_horas_ativ_w + (dt_final_w - data_fim_extra_w) * 24;
					else
						total_horas_ativ_w := (data_ini_extra_w - dt_inicial_w) * 24;
					end if;
				elsif dt_inicial_w > data_fim_extra_w then
					total_horas_ativ_w := (dt_final_w - dt_inicial_w) * 24;
				elsif (dt_inicial_w > data_ini_extra_w) and (dt_inicial_w < data_fim_extra_w) then
					if dt_final_w > data_fim_extra_w then
						total_horas_ativ_w := (dt_final_w - data_fim_extra_w) * 24;
					end if;
				end if;
				total_horas_rat_w := total_horas_rat_w + total_horas_ativ_w;
			else
				data_ini_extra_w := to_date(to_char(dt_inicial_w,'dd/mm/yyyy') || ' 00:00:00','dd/mm/yyyy hh24:mi:ss');
				data_fim_extra_w := to_date(to_char(dt_final_w,'dd/mm/yyyy') || ' 00:00:00','dd/mm/yyyy hh24:mi:ss');
				qt_intervalo_dias_w := obter_dias_entre_datas(data_ini_extra_w,data_fim_extra_w) + 1;
				contador_w := 0;
				data_ini_extra_w := dt_inicial_w;
				data_fim_extra_w := dt_final_w;
				--teste_w := qt_intervalo_dias_w;
				WHILE(contador_w < qt_intervalo_dias_w) LOOP
					if to_char(data_ini_extra_w,'dd/mm/yyyy') <> to_char(data_fim_extra_w,'dd/mm/yyyy') then
						data_aux_w := to_date(to_char(data_ini_extra_w,'dd/mm/yyyy') || ' 05:00:00','dd/mm/yyyy hh24:mi:ss');
						data_aux1_w:= to_date(to_char(data_ini_extra_w,'dd/mm/yyyy') || ' 22:00:00','dd/mm/yyyy hh24:mi:ss');
						if data_ini_extra_w < data_aux_w then
							total_horas_ativ_w := total_horas_ativ_w + ((data_aux_w - data_ini_extra_w)* 24);
							data_aux_w := to_date(to_char(data_ini_extra_w,'dd/mm/yyyy') || ' 22:00:00','dd/mm/yyyy hh24:mi:ss');
							data_aux1_w:= to_date(to_char(data_ini_extra_w,'dd/mm/yyyy') || ' 23:59:59','dd/mm/yyyy hh24:mi:ss');
							total_horas_ativ_w := total_horas_ativ_w + ((data_aux1_w - data_aux_w)* 24);
						elsif (data_ini_extra_w > data_aux_w) and (data_ini_extra_w < data_aux1_w) then
							data_aux_w:= to_date(to_char(data_ini_extra_w,'dd/mm/yyyy') || ' 23:59:59','dd/mm/yyyy hh24:mi:ss');
							total_horas_ativ_w := total_horas_ativ_w + ((data_aux_w - data_aux1_w) * 24);
						elsif (data_ini_extra_w > data_aux1_w) then
							data_aux1_w:= to_date(to_char(data_ini_extra_w,'dd/mm/yyyy') || ' 23:59:59','dd/mm/yyyy hh24:mi:ss');
							total_horas_ativ_w :=  total_horas_ativ_w + ((data_aux1_w - data_ini_extra_w) * 24);
						end if;
					else
						data_aux_w := to_date(to_char(data_ini_extra_w,'dd/mm/yyyy') || ' 05:00:00','dd/mm/yyyy hh24:mi:ss');
						data_aux1_w:= to_date(to_char(data_ini_extra_w,'dd/mm/yyyy') || ' 22:00:00','dd/mm/yyyy hh24:mi:ss');
						if (data_fim_extra_w < data_aux_w) then
							total_horas_ativ_w := total_horas_ativ_w + ((data_fim_extra_w - data_ini_extra_w) * 24);
						elsif (data_fim_extra_w > data_aux_w) and (data_fim_extra_w < data_aux1_w) then
							total_horas_ativ_w := total_horas_ativ_w + data_aux_w - data_ini_extra_w;
						elsif (data_fim_extra_w > data_aux1_w) then
							total_horas_ativ_w := total_horas_ativ_w + ((data_aux_w - data_ini_extra_w) * 24);
							total_horas_ativ_w := total_horas_ativ_w + ((data_fim_extra_w - data_aux1_w) * 24);
						end if;
					end if;
					--teste_w := teste_w || ' - ' || total_horas_ativ_w || ' - ' || contador_w || ' - ' || data_ini_extra_w;
					data_ini_extra_w := to_date(to_char(data_ini_extra_w + 1,'dd/mm/yyyy') || ' 00:00:00','dd/mm/yyyy hh24:mi:ss');
					contador_w := contador_w + 1;
				END LOOP;
				total_horas_rat_w := total_horas_rat_w + total_horas_ativ_w;
			end if;
		--end if;
	--end if;
	end;
end loop;
close C01;
--teste_w := total_horas_rat_w;
--return teste_w;
return	total_horas_rat_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_horas_noturnas (nr_seq_rat_p bigint) FROM PUBLIC;
