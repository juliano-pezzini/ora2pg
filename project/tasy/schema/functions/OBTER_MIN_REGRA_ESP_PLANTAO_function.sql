-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_min_regra_esp_plantao ( nr_seq_regra_esp_p bigint, nr_seq_plantao_p bigint, dt_inicial_p timestamp default null, dt_final_p timestamp default null, ie_plantao_prev_p text default null) RETURNS bigint AS $body$
DECLARE


qt_regra_w		bigint;
qt_minuto_w		bigint	:= 0;
dt_ini_plantao_w	timestamp;
dt_fin_plantao_w	timestamp;
cd_estabelecimento_w	smallint;
qt_dia_plantao_w	bigint;
ie_dia_semana_w		bigint;
hr_inicial_w		varchar(8);
hr_final_w		varchar(8);
dt_inicial_w		timestamp;
dt_final_w		timestamp;
qt_dia_atual_w		bigint;
dt_referencia_w		timestamp;
ie_plantao_prev_w	regra_esp_repasse.ie_plantao_previsto%type;

c01 CURSOR FOR
SELECT	substr(to_char(a.dt_inicial,'dd/mm/yyyy hh24:mi:ss'),12,8) dt_inicial,
	substr(to_char(a.dt_final,'dd/mm/yyyy hh24:mi:ss'),12,8) dt_final
from	regra_esp_repasse_dia a
where	((coalesce(a.ie_dia_semana::text, '') = '') or (a.ie_dia_semana = ie_dia_semana_w) or
	 --(a.ie_dia_semana = 9 and ie_dia_semana_w in (2,3,4,5,6)))
	 (a.ie_dia_semana = 9 and pkg_date_utils.is_business_day(dt_ini_plantao_w,0) = 1) and obter_se_feriado(cd_estabelecimento_w,dt_ini_plantao_w) = 0)
and	a.ie_situacao		= 'A'
and	a.nr_seq_regra_esp	= nr_seq_regra_esp_p;


BEGIN

if (ie_plantao_prev_p IS NOT NULL AND ie_plantao_prev_p::text <> '') then
	ie_plantao_prev_w := ie_plantao_prev_p;
else
	select	max(coalesce(ie_plantao_previsto,'N'))
	into STRICT	ie_plantao_prev_w
	from	regra_esp_repasse
	where	nr_sequencia	= nr_seq_regra_esp_p;
end if;

if (nr_seq_plantao_p IS NOT NULL AND nr_seq_plantao_p::text <> '') then
	select	max(CASE WHEN ie_plantao_prev_w='S' THEN coalesce(a.dt_inicial,dt_inicial_prev)  ELSE dt_inicial END ),
		max(CASE WHEN ie_plantao_prev_w='S' THEN coalesce(a.dt_final,dt_final_prev)  ELSE dt_final END ),
		max(a.cd_estabelecimento),
		max(a.qt_minuto)
	into STRICT	dt_ini_plantao_w,
		dt_fin_plantao_w,
		cd_estabelecimento_w,
		qt_minuto_w
	from	medico_plantao a
	where	a.nr_sequencia	= nr_seq_plantao_p;
else
	select	max(a.cd_estabelecimento)
	into STRICT	cd_estabelecimento_w
	from	regra_esp_repasse a
	where	a.nr_sequencia		= nr_seq_regra_esp_p;

	dt_ini_plantao_w	:= dt_inicial_p;
	dt_fin_plantao_w	:= dt_final_p;

end if;

select	count(*)
into STRICT	qt_regra_w
from	regra_esp_repasse_dia
where	ie_situacao		= 'A'
and	nr_seq_regra_esp	= nr_seq_regra_esp_p;

if (coalesce(qt_regra_w,0)	> 0) then	/* se não tem regra, não precisa continuar */
	qt_minuto_w	:= 0;

	/* obter a quantidade de dias do plantão */

	qt_dia_plantao_w := (trunc(dt_fin_plantao_w,'dd') - trunc(dt_ini_plantao_w,'dd'))::numeric;

	qt_dia_atual_w	:= qt_dia_plantao_w;
	dt_referencia_w	:= dt_ini_plantao_w;

	/* obter os dias da semana pelos quais o plantão passa (no caso de começar num dia e terminar em outro) */

	while(qt_dia_atual_w	> -1) loop
		begin

		dt_ini_plantao_w 	:= dt_referencia_w + coalesce(qt_dia_atual_w,0);
		/* se for algum dia posterior ao início do plantão, começa no horário 00:00:00 */

		if (qt_dia_atual_w > 0) then
			dt_ini_plantao_w	:= trunc(dt_ini_plantao_w,'dd');
		end if;

		dt_fin_plantao_w	:= to_date(to_char(dt_ini_plantao_w,'dd/mm/yyyy') || ' ' || to_char(dt_fin_plantao_w,'hh24:mi:ss'),'dd/mm/yyyy hh24:mi:ss');

		/* se não for o último dia do plantão, termina no horário 23:59:59 */

		if (qt_dia_atual_w < qt_dia_plantao_w) then
			dt_fin_plantao_w	:= fim_dia(dt_fin_plantao_w);
		end if;

		select CASE WHEN obter_se_feriado(cd_estabelecimento_w,dt_ini_plantao_w)=0 THEN pkg_date_utils.get_WeekDay(dt_ini_plantao_w)  ELSE 0 END  ie_dia_semana
		into STRICT ie_dia_semana_w
		;

		/* obter as regras que passam pela data do plantão */

		open	c01;
		loop
		fetch	c01 into
			hr_inicial_w,
			hr_final_w;
		EXIT WHEN NOT FOUND; /* apply on c01 */

			if (coalesce(hr_inicial_w::text, '') = '') then
				dt_inicial_w	:= trunc(dt_ini_plantao_w,'dd');
			else
				dt_inicial_w	:= to_date(to_char(dt_ini_plantao_w,'dd/mm/yyyy') || ' ' || hr_inicial_w,'dd/mm/yyyy hh24:mi:ss');
			end if;

			if (coalesce(hr_final_w::text, '') = '') then
				dt_final_w	:= fim_dia(dt_fin_plantao_w);
			else
				dt_final_w	:= to_date(to_char(dt_fin_plantao_w,'dd/mm/yyyy') || ' ' || hr_final_w,'dd/mm/yyyy hh24:mi:ss');
			end if;

			/* se o plantão inteiro cair na regra */

			if (dt_fin_plantao_w	<= dt_final_w) and (dt_ini_plantao_w	>= dt_inicial_w) then

				qt_minuto_w	:= coalesce(qt_minuto_w,0) + ((dt_fin_plantao_w - dt_ini_plantao_w) * 1440);	/* 1440 é a quantidade de minutos que existe num dia */
			/* se o plantão começar fora e terminar dentro da regra */

			elsif (dt_fin_plantao_w	<= dt_final_w) and (dt_ini_plantao_w	< dt_inicial_w) and (dt_fin_plantao_w	>= dt_inicial_w) then

				qt_minuto_w	:= coalesce(qt_minuto_w,0) + ((dt_fin_plantao_w - dt_inicial_w) * 1440);

			/* se o plantão começar dentro e terminar fora da regra */

			elsif (dt_fin_plantao_w	> dt_final_w) and (dt_ini_plantao_w	>= dt_inicial_w) and (dt_ini_plantao_w	<= dt_final_w) then

				qt_minuto_w	:= coalesce(qt_minuto_w,0) + ((dt_final_w - dt_ini_plantao_w) * 1440);

			/* se o plantão começar antes e terminar depois da regra */

			elsif (dt_fin_plantao_w	> dt_final_w) and (dt_ini_plantao_w	< dt_inicial_w) then

				qt_minuto_w	:= coalesce(qt_minuto_w,0) + ((dt_final_w - dt_inicial_w) * 1440);

			end if;

		end	loop;
		close	c01;

		qt_dia_atual_w	:= coalesce(qt_dia_atual_w,0) -1;

		end;
	end	loop;

end if;

return qt_minuto_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_min_regra_esp_plantao ( nr_seq_regra_esp_p bigint, nr_seq_plantao_p bigint, dt_inicial_p timestamp default null, dt_final_p timestamp default null, ie_plantao_prev_p text default null) FROM PUBLIC;
