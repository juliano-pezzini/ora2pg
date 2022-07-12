-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION vtrp_obter_capacidade_agecons ( cd_agenda_p bigint, nr_sequencia_p bigint, dt_inicial_p timestamp, dt_final_p timestamp) RETURNS bigint AS $body$
DECLARE


/* function utilizada para agenda tipo (3) visando obter a capacidade total da agenda com base nas datas inicial e final, horarios inicial e final, dia da semana  e duração do horário.*/

qt_dias_vigencia_w    		bigint;
qt_capacidade_w    			bigint;
dt_dia_semana_w    			smallint;
qt_dias_efetivos_w   		bigint;
qt_total_dias_efetivos_w 	bigint;
dt_incrementa_w    			timestamp;
qt_agendamento_hr_espec		bigint;
dt_inicio_vigencia_w		timestamp;
dt_final_vigencia_w			timestamp;
qt_agendamento_hr_espec_w	bigint;
qt_total_agend_hr_espec_w	bigint;
ie_gerar_hor_w				varchar(1);
ie_frequencia_w				varchar(1);
ie_feriado_w				bigint;
BEGIN
-- início inicialização variaveis.
qt_total_dias_efetivos_w  	:= 0;
dt_incrementa_w    			:= clock_timestamp();
qt_dias_vigencia_w    		:= 0;
qt_capacidade_w    			:= 0;
dt_dia_semana_w    			:= 0;
qt_dias_efetivos_w   		:= 0;
qt_agendamento_hr_espec		:= 0;
dt_inicio_vigencia_w		:= clock_timestamp();
dt_final_vigencia_w			:= clock_timestamp();
qt_agendamento_hr_espec_w	:= 0;
qt_total_agend_hr_espec_w	:= 0;
ie_feriado_w				:= 0;
-- fim inicialização variaveis.
select 	a.ie_dia_semana,
		dt_inicial_p,
		dt_final_p - dt_inicial_p,
		coalesce(a.dt_inicio_vigencia,null),
		coalesce(a.dt_final_vigencia,null),
		a.ie_frequencia
into STRICT 	dt_dia_semana_w,		-- selecionar qual o dia da semana para a agenda em questão
		dt_incrementa_w, 		-- usada no loop de verificação, compara todas as datas do periodo e filtra/soma dias conforme dia semana selecionado
		qt_dias_vigencia_w,		-- qtde dias possíveis para agendamento baseados na data inicial e final do relatorio
		dt_inicio_vigencia_w,
		dt_final_vigencia_w,
		ie_frequencia_w
from    agenda_turno a
where  	a.cd_agenda     	= cd_agenda_p
and    	a.nr_sequencia   	= nr_sequencia_p;

	if ((coalesce(dt_inicio_vigencia_w::text, '') = '') or (coalesce(dt_final_vigencia_w::text, '') = '')) then
		begin

			if (dt_dia_semana_w <> 9) then 		-- se não for dias de trabalho...
				for i in 0..qt_dias_vigencia_w 	-- até total dias possíveis p/ agendamento (*)
				loop

				select	Obter_Se_Feriado(wheb_usuario_pck.get_cd_estabelecimento,dt_incrementa_w) --tratar se o dia do período é feriado
				into STRICT	ie_feriado_w
				;

					if (ie_feriado_w = 0)then
						begin

						select 	coalesce(count(*), 0)
						into STRICT 	qt_dias_efetivos_w
						
						where 	obter_cod_dia_semana(dt_incrementa_w)  = dt_dia_semana_w;

						-- Tratar geração de horário, de acordo com a frequência do turno
						ie_gerar_hor_w	:= coalesce(obter_se_gerar_turno_agecons(dt_inicio_vigencia_w, ie_frequencia_w, dt_incrementa_w),'N');

						if (ie_gerar_hor_w = 'S') then
							qt_total_dias_efetivos_w 	:= qt_dias_efetivos_w  	+ qt_total_dias_efetivos_w;
						end if;

						end;
					end if;
					dt_incrementa_w    		:= dt_incrementa_w  	+ 1;	--(*) soma 1 dia a partir dt inicio até dt final
				end loop;
			else 								-- caso o dia da semana seja "dias de trabalho" (9), soma todos desconsiderando os sabados e domingos
				for i in 0..qt_dias_vigencia_w 	-- até total dias possíveis p/ agendamento(*)
				loop

					select	Obter_Se_Feriado(wheb_usuario_pck.get_cd_estabelecimento,dt_incrementa_w) --tratar se o dia do período é feriado
					into STRICT	ie_feriado_w
					;

					if (ie_feriado_w = 0)then

						begin

						select 	coalesce(count(*), 0)
						into STRICT 	qt_dias_efetivos_w
						
						where 	obter_cod_dia_semana(dt_incrementa_w) not in (1,7);

						-- Tratar geração de horário, de acordo com a frequência do turno
						ie_gerar_hor_w	:= coalesce(obter_se_gerar_turno_agecons(dt_inicio_vigencia_w, ie_frequencia_w, dt_incrementa_w),'N');

						if (ie_gerar_hor_w = 'S') then
							qt_total_dias_efetivos_w 	:= qt_dias_efetivos_w 	+ qt_total_dias_efetivos_w;
						end if;

						end;
					end if;
					dt_incrementa_w    		:= dt_incrementa_w 	+ 1;	--(*) soma 1 dia a partir dt inicio até dt final
				end loop;
			end if;
		end;
	else -- Se as datas de vigencia tiverem sido informadas...
		begin
			if (dt_dia_semana_w <> 9) then 			-- se não for dias de trabalho...
				for i in 0..qt_dias_vigencia_w 		-- até total dias possíveis p/ agendamento (*)
				loop

					select	Obter_Se_Feriado(wheb_usuario_pck.get_cd_estabelecimento,dt_incrementa_w) --tratar se o dia do período é feriado
					into STRICT	ie_feriado_w
					;

					if (ie_feriado_w = 0)then

						begin

						select 	coalesce(count(*), 0)
						into STRICT 	qt_dias_efetivos_w
						
						where 	obter_cod_dia_semana(dt_incrementa_w)  = dt_dia_semana_w
						and		dt_incrementa_w between dt_inicio_vigencia_w and fim_dia(dt_final_vigencia_w);

						-- Tratar geração de horário, de acordo com a frequência do turno
						ie_gerar_hor_w	:= coalesce(obter_se_gerar_turno_agecons(dt_inicio_vigencia_w, ie_frequencia_w, dt_incrementa_w),'N');

						if (ie_gerar_hor_w = 'S') then
							qt_total_dias_efetivos_w 		:= qt_dias_efetivos_w  	+ qt_total_dias_efetivos_w;
						end if;

						end;
					end if;

					dt_incrementa_w    			:= dt_incrementa_w  	+ 1;	--(*) soma 1 dia a partir dt inicio até dt final
				end loop;
			else 									-- caso o dia da semana seja "dias de trabalho" (9), soma todos desconsiderando os sabados e domingos
				for i in 0..qt_dias_vigencia_w 		-- até total dias possíveis p/ agendamento (*)
				loop

					select	Obter_Se_Feriado(wheb_usuario_pck.get_cd_estabelecimento,dt_incrementa_w) --tratar se o dia do período é feriado
					into STRICT	ie_feriado_w
					;

					if (ie_feriado_w = 0)then

						begin

						select coalesce(count(*), 0)
						into STRICT 	qt_dias_efetivos_w
						
						where 	obter_cod_dia_semana(dt_incrementa_w) not in (1,7)
						and		dt_incrementa_w between dt_inicio_vigencia_w and fim_dia(dt_final_vigencia_w);

						-- Tratar geração de horário, de acordo com a frequência do turno
						ie_gerar_hor_w	:= coalesce(obter_se_gerar_turno_agecons(dt_inicio_vigencia_w, ie_frequencia_w, dt_incrementa_w),'N');

						if (ie_gerar_hor_w = 'S') then
							qt_total_dias_efetivos_w 		:= qt_dias_efetivos_w 	+ qt_total_dias_efetivos_w;
						end if;

						end;
					end if;

					dt_incrementa_w    		 	:= dt_incrementa_w 	+ 1;	--(*) soma 1 dia a partir dt inicio até dt final
				end loop;
			end if;
		end;
	end if;

-- calculo para obter o total de agendamentos.
select	((((((a.hr_final - a.hr_inicial) * 1440) / a.nr_minuto_intervalo)) * qt_total_dias_efetivos_w) + qt_total_agend_hr_espec_w)	--+ qt_agendamento_aux
into STRICT 	qt_capacidade_w
from    agenda_turno a
where  	a.cd_agenda     	= cd_agenda_p
and     a.nr_sequencia   	= nr_sequencia_p;

return qt_capacidade_w;			-- retorno total agendamentos
end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION vtrp_obter_capacidade_agecons ( cd_agenda_p bigint, nr_sequencia_p bigint, dt_inicial_p timestamp, dt_final_p timestamp) FROM PUBLIC;

