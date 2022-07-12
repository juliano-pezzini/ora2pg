-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION somar_idade_gestacional (nr_sequencia_p bigint, dt_evolucao_p timestamp, ie_opcao_p text) RETURNS bigint AS $body$
DECLARE



dt_inicial_w	timestamp;
dt_final_w		timestamp;

qt_dias_ww	bigint;
qt_dias_w	bigint;
qt_semanas_w 	bigint:= 0;
maior_dia_w		bigint;
i 		smallint := 1;
j 		smallint := 1;

qt_dias_pn_w	bigint;
qt_semanas_pn_w	bigint;

qt_total_dias_w  bigint;
qt_total_semanas_w bigint;

multiplicar_w 	bigint;
adicionar_dias_w 	bigint := 0;


ds_retorno bigint;


BEGIN
if (dt_evolucao_p IS NOT NULL AND dt_evolucao_p::text <> '') then
	select	a.dt_prim_consulta,
			dt_evolucao_p
	into STRICT	dt_inicial_w,
			dt_final_w
	from	med_pac_pre_natal a
	where	a.nr_sequencia = nr_sequencia_p;

	--Total de dias entre a consulta PN e a primeira  evolução PN
	select	obter_dias_entre_datas(dt_inicial_w,dt_final_w)
	into STRICT	qt_dias_ww
	;

	select	qt_ig_dia_us,
			qt_ig_sem_us
	into STRICT	qt_dias_pn_w,
			qt_semanas_pn_w
	from 	med_pac_pre_natal
	where	nr_sequencia = nr_sequencia_p;

	maior_dia_w := i;

	--Transforma a diferença de dias entre as datas em dias semanas
	--exemplo 38 dias é equivalente a 5 semanas e 3 dias
	while(i	<= qt_dias_ww) loop

		if (mod(i,7)= 0) then
			qt_semanas_w:= qt_semanas_w+1;
			maior_dia_w := i;
		end if;

		i:= i+1;
	end loop;


	select	qt_dias_ww - maior_dia_w
	into STRICT	qt_dias_w
	;

	--Soma a IG US na consulta PN com a quantidade de dias que se passaram até a data da evolução PN
	select	qt_dias_pn_w + qt_dias_w,
			qt_semanas_pn_w + 	qt_semanas_w
	into STRICT	qt_total_dias_w,
			qt_total_semanas_w
	;


	--Verifica se o total de dias  é maior que sete(uma semana) e transforma em semanas
	--exemplo 9 semanas 18 dias é equivalente a  11 semanas e 4 dias
	if (qt_total_dias_w > 7) then

		while(j	<= qt_total_dias_w) loop

			if (mod(j,7)= 0) then
				adicionar_dias_w:= adicionar_dias_w+1;
			end if;

			j:= j+1;
		end loop;

		select	adicionar_dias_w + qt_total_semanas_w
		into STRICT	qt_total_semanas_w
		;

		select	adicionar_dias_w * 7
		into STRICT	multiplicar_w
		;


		select	qt_total_dias_w - multiplicar_w
		into STRICT	qt_total_dias_w
		;


	end if;

	if (ie_opcao_p = 'S') then
		ds_retorno:= qt_total_semanas_w;
	else if (ie_opcao_p = 'D') then
		ds_retorno:= qt_total_dias_w;
	end if;
	end if;
end if;

return ds_retorno;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION somar_idade_gestacional (nr_sequencia_p bigint, dt_evolucao_p timestamp, ie_opcao_p text) FROM PUBLIC;
