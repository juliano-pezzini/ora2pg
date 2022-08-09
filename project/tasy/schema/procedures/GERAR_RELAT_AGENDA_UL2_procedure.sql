-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE gerar_relat_agenda_ul2 (cd_profissional_p bigint, dt_referencia_p timestamp) AS $body$
DECLARE

dt_dia_atual_p					bigint := 1; --PRIMEIRO DIA 
dt_dia_atual_w 					timestamp 		:= clock_timestamp();
dt_maximo_mes 					smallint := 0;
ie_dia_semana_w 					smallint := 0;
qt_hr_dias_trab_w					double precision := 0;
qt_hr_dias_indv_w					double precision := 0;
qt_hr_turn_especial					double precision	:= 0;
--cd_agenda_w					number(10,0); 
nr_retorno_w 					double precision := 0;
qt_hr_encaixe					double precision	:= 0;
qt_dia01_w					double precision	:= 0;
qt_dia02_w					double precision	:= 0;
qt_dia03_w					double precision	:= 0;
qt_dia04_w					double precision	:= 0;
qt_dia05_w					double precision	:= 0;
qt_dia06_w					double precision	:= 0;
qt_dia07_w					double precision	:= 0;
qt_dia08_w					double precision	:= 0;
qt_dia09_w					double precision	:= 0;
qt_dia10_w					double precision	:= 0;
qt_dia11_w					double precision	:= 0;
qt_dia12_w					double precision	:= 0;
qt_dia13_w					double precision	:= 0;
qt_dia14_w					double precision	:= 0;
qt_dia15_w					double precision	:= 0;
qt_dia16_w					double precision	:= 0;
qt_dia17_w					double precision	:= 0;
qt_dia18_w					double precision	:= 0;
qt_dia19_w					double precision	:= 0;
qt_dia20_w					double precision	:= 0;
qt_dia21_w					double precision	:= 0;
qt_dia22_w					double precision	:= 0;
qt_dia23_w					double precision	:= 0;
qt_dia24_w					double precision	:= 0;
qt_dia25_w					double precision	:= 0;
qt_dia26_w					double precision	:= 0;
qt_dia27_w					double precision	:= 0;
qt_dia28_w					double precision	:= 0;
qt_dia29_w					double precision	:= 0;
qt_dia30_w					double precision	:= 0;
qt_dia31_w					double precision	:= 0;
qt_total_w					double precision	:= 0;
nm_profissional_w			varchar(5000)	:= null;

BEGIN 
 
	if	(dt_referencia_p IS NOT NULL AND dt_referencia_p::text <> '' AND cd_profissional_p IS NOT NULL AND cd_profissional_p::text <> '') then 
	/*limpar tabela*/
 
	delete from w_relat_agenda_ul;
	commit;
 
	select 	obter_nome_pf(a.cd_pessoa_fisica) 
	into STRICT		nm_profissional_w 
	from  	pessoa_fisica a 
	where 	a.cd_pessoa_fisica = to_char(cd_profissional_p);
 
	select 	(substr(last_day(dt_referencia_p),1,2))::numeric  --maximo mes 
	into STRICT		dt_maximo_mes 
	;
 
	for i in 0..31 
		loop 
			if dt_dia_atual_p > dt_maximo_mes then 
				nr_retorno_w := 0;
 
			else 
 
			select 	to_date(dt_dia_atual_p||'/'||substr(to_char(dt_referencia_p,'dd/mm/yyyy'),4,10),'dd/mm/yyyy') -- converte dt_dia_atual_p para data no mes 
			into STRICT		dt_dia_atual_w 
			;
 
			select 		coalesce((sum(to_date(('30/12/1899'||to_char(b.hr_final,' hh24:mi:ss')),'dd/mm/yyyy hh24:mi:ss') - 
						to_date(('30/12/1899'||to_char(b.hr_inicial,' hh24:mi:ss')),'dd/mm/yyyy hh24:mi:ss'))*24),0) qt_horas_dia_w -- somar horas quando for dias de semana 
			into STRICT			qt_hr_dias_trab_w 
			from  	  	agenda a, 
						agenda_turno b 
			where 	  	a.cd_agenda 	   	 			 = b.cd_agenda 
			and	  		a.cd_pessoa_fisica 	 				 = cd_profissional_p 
			and	  		dt_dia_atual_w						 between b.dt_inicio_vigencia and b.dt_final_vigencia 
			and	  		obter_cod_dia_semana(dt_dia_atual_w) not in (1,7) 
			and	  		b.ie_dia_semana 					 = 9 
			and			a.cd_tipo_agenda 					 = 3;
 
			select 		coalesce((sum(to_date(('30/12/1899'||to_char(b.hr_final,' hh24:mi:ss')),'dd/mm/yyyy hh24:mi:ss') - 
						to_date(('30/12/1899'||to_char(b.hr_inicial,' hh24:mi:ss')),'dd/mm/yyyy hh24:mi:ss'))*24),0) qt_horas_dia_w -- somar horas quando for dias de semana 
			into STRICT			qt_hr_dias_indv_w 
			from  	  	agenda a, 
						agenda_turno b 
			where 	  	a.cd_agenda 	   	 			= b.cd_agenda 
			and	  		a.cd_pessoa_fisica 	 				= cd_profissional_p 
			and	  		dt_dia_atual_w						between b.dt_inicio_vigencia and b.dt_final_vigencia 
			and	  		b.ie_dia_semana 					<> 9 
			and			obter_cod_dia_semana(dt_dia_atual_w) = b.ie_dia_semana 
			and			a.cd_tipo_agenda 					 = 3;
 
			select		coalesce(dividir(sum(a.nr_minuto_duracao),60),0) 
			into STRICT			qt_hr_encaixe 
			from			agenda_consulta a, 
						agenda b 
			where		a.ie_encaixe 		= 'S' 
			and			b.cd_agenda 		= a.cd_agenda 
			and			trunc(a.dt_agenda) = dt_dia_atual_w 
			and			b.cd_pessoa_fisica 	= cd_profissional_p 
			and			a.ie_status_agenda 	<>'C' 
			and			b.cd_tipo_agenda 					 = 3;
 
			select 	coalesce((sum(to_date(('30/12/1899'||to_char(b.hr_final,' hh24:mi:ss')),'dd/mm/yyyy hh24:mi:ss') - 
					to_date(('30/12/1899'||to_char(b.hr_inicial,' hh24:mi:ss')),'dd/mm/yyyy hh24:mi:ss'))*24),0) qt_horas_dia_w -- somar horas quando for dias de semana * 24),0) 
			into STRICT  	qt_hr_turn_especial 
			from  	agenda a, 
					agenda_turno_esp b 
			where 	a.cd_agenda 	 	= b.cd_agenda 
			and  	a.cd_pessoa_fisica 	= cd_profissional_p 
			and  	b.cd_agenda 	 	= a.cd_agenda 
			and  	dt_dia_atual_w 		between b.dt_agenda and b.dt_agenda_fim 
			and		a.cd_tipo_agenda 	= 3;
 
			nr_retorno_w := coalesce(qt_hr_dias_trab_w,0) + coalesce(qt_hr_dias_indv_w,0) + coalesce(qt_hr_encaixe,0) + coalesce(qt_hr_turn_especial,0);
 
				if dt_dia_atual_p 	 = 1 then qt_dia01_w := nr_retorno_w; qt_total_w:= qt_total_w + coalesce(qt_dia01_w,0);
				elsif dt_dia_atual_p = 2 then qt_dia02_w := nr_retorno_w; qt_total_w:= qt_total_w + coalesce(qt_dia02_w,0);
				elsif dt_dia_atual_p = 3 then qt_dia03_w := nr_retorno_w; qt_total_w:= qt_total_w + coalesce(qt_dia03_w,0);
				elsif dt_dia_atual_p = 4 then qt_dia04_w := nr_retorno_w; qt_total_w:= qt_total_w + coalesce(qt_dia04_w,0);
				elsif dt_dia_atual_p = 5 then qt_dia05_w := nr_retorno_w; qt_total_w:= qt_total_w + coalesce(qt_dia05_w,0);
				elsif dt_dia_atual_p = 6 then qt_dia06_w := nr_retorno_w; qt_total_w:= qt_total_w + coalesce(qt_dia06_w,0);
				elsif dt_dia_atual_p = 7 then qt_dia07_w := nr_retorno_w; qt_total_w:= qt_total_w + coalesce(qt_dia07_w,0);
				elsif dt_dia_atual_p = 8 then qt_dia08_w := nr_retorno_w; qt_total_w:= qt_total_w + coalesce(qt_dia08_w,0);
				elsif dt_dia_atual_p = 9 then qt_dia09_w := nr_retorno_w; qt_total_w:= qt_total_w + coalesce(qt_dia09_w,0);
				elsif dt_dia_atual_p = 10 then qt_dia10_w := nr_retorno_w; qt_total_w:= qt_total_w + coalesce(qt_dia10_w,0);
				elsif dt_dia_atual_p = 11 then qt_dia11_w := nr_retorno_w; qt_total_w:= qt_total_w + coalesce(qt_dia11_w,0);
				elsif dt_dia_atual_p = 12 then qt_dia12_w := nr_retorno_w; qt_total_w:= qt_total_w + coalesce(qt_dia12_w,0);
				elsif dt_dia_atual_p = 13 then qt_dia13_w := nr_retorno_w; qt_total_w:= qt_total_w + coalesce(qt_dia13_w,0);
				elsif dt_dia_atual_p = 14 then qt_dia14_w := nr_retorno_w; qt_total_w:= qt_total_w + coalesce(qt_dia14_w,0);
				elsif dt_dia_atual_p = 15 then qt_dia15_w := nr_retorno_w; qt_total_w:= qt_total_w + coalesce(qt_dia15_w,0);
				elsif dt_dia_atual_p = 16 then qt_dia16_w := nr_retorno_w; qt_total_w:= qt_total_w + coalesce(qt_dia16_w,0);
				elsif dt_dia_atual_p = 17 then qt_dia17_w := nr_retorno_w; qt_total_w:= qt_total_w + coalesce(qt_dia17_w,0);
				elsif dt_dia_atual_p = 18 then qt_dia18_w := nr_retorno_w; qt_total_w:= qt_total_w + coalesce(qt_dia18_w,0);
				elsif dt_dia_atual_p = 19 then qt_dia19_w := nr_retorno_w; qt_total_w:= qt_total_w + coalesce(qt_dia19_w,0);
				elsif dt_dia_atual_p = 20 then qt_dia20_w := nr_retorno_w; qt_total_w:= qt_total_w + coalesce(qt_dia20_w,0);
				elsif dt_dia_atual_p = 21 then qt_dia21_w := nr_retorno_w; qt_total_w:= qt_total_w + coalesce(qt_dia21_w,0);
				elsif dt_dia_atual_p = 22 then qt_dia22_w := nr_retorno_w; qt_total_w:= qt_total_w + coalesce(qt_dia22_w,0);
				elsif dt_dia_atual_p = 23 then qt_dia23_w := nr_retorno_w; qt_total_w:= qt_total_w + coalesce(qt_dia23_w,0);
				elsif dt_dia_atual_p = 24 then qt_dia24_w := nr_retorno_w; qt_total_w:= qt_total_w + coalesce(qt_dia24_w,0);
				elsif dt_dia_atual_p = 25 then qt_dia25_w := nr_retorno_w; qt_total_w:= qt_total_w + coalesce(qt_dia25_w,0);
				elsif dt_dia_atual_p = 26 then qt_dia26_w := nr_retorno_w; qt_total_w:= qt_total_w + coalesce(qt_dia26_w,0);
				elsif dt_dia_atual_p = 27 then qt_dia27_w := nr_retorno_w; qt_total_w:= qt_total_w + coalesce(qt_dia27_w,0);
				elsif dt_dia_atual_p = 28 then qt_dia28_w := nr_retorno_w; qt_total_w:= qt_total_w + coalesce(qt_dia28_w,0);
				elsif dt_dia_atual_p = 29 then qt_dia29_w := nr_retorno_w; qt_total_w:= qt_total_w + coalesce(qt_dia29_w,0);
				elsif dt_dia_atual_p = 30 then qt_dia30_w := nr_retorno_w; qt_total_w:= qt_total_w + coalesce(qt_dia30_w,0);
				elsif dt_dia_atual_p = 31 then qt_dia31_w := nr_retorno_w; qt_total_w:= qt_total_w + coalesce(qt_dia31_w,0);
				end if;
 
			dt_dia_atual_p := dt_dia_atual_p + 1;
		end if;
		end loop;
 
		insert	into w_relat_agenda_ul 
					values ( 
						cd_profissional_p, 
						nm_profissional_W, 
						qt_dia01_w, 
						qt_dia02_w, 
						qt_dia03_w, 
						qt_dia04_w, 
						qt_dia05_w, 
						qt_dia06_w, 
						qt_dia07_w, 
						qt_dia08_w, 
						qt_dia09_w, 
						qt_dia10_w, 
						qt_dia11_w, 
						qt_dia12_w, 
						qt_dia13_w, 
						qt_dia14_w, 
						qt_dia15_w, 
						qt_dia16_w, 
						qt_dia17_w, 
						qt_dia18_w, 
						qt_dia19_w, 
						qt_dia20_w, 
						qt_dia21_w, 
						qt_dia22_w, 
						qt_dia23_w, 
						qt_dia24_w, 
						qt_dia25_w, 
						qt_dia26_w, 
						qt_dia27_w, 
						qt_dia28_w, 
						qt_dia29_w, 
						qt_dia30_w, 
						qt_dia31_w, 
						qt_total_w 
						);
commit;
end if;
end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE gerar_relat_agenda_ul2 (cd_profissional_p bigint, dt_referencia_p timestamp) FROM PUBLIC;
