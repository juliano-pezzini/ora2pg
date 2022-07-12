-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_quartis_relatorio (dt_inicial_p timestamp, dt_final_p timestamp, ie_opcao_p text, ie_tipo_p text) RETURNS bigint AS $body$
DECLARE


/*
ie_opcao_p
 MD - Matrícula / Diagnóstico
 DT - Diagnóstico / Tratamento
 MT - Matrícula / Tratamento
*/
/*
ie_tipo_p
 P - Primeiro quartis
 T - Terceiro quartis
*/
vl_primeiro_w	bigint;
vl_terceiro_w	bigint;
vl_result_w	bigint;



BEGIN

if (ie_opcao_p = 'MD') then

	select	dividir((25 * count(trunc((dt_preench_ficha) - (dt_diagnostico)))), 100) vl_primeiro,
		dividir((75 * count(trunc((dt_preench_ficha) - (dt_diagnostico)))), 100) vl_terceiro
	into STRICT	vl_primeiro_w,
		vl_terceiro_w
	from	can_ficha_admissao
	where	dt_diagnostico between dt_inicial_p and dt_final_p;

	if (ie_tipo_p = 'P') then

		select	max(qt_item)
		into STRICT	vl_result_w
		from	(SELECT	trunc((dt_preench_ficha) - (dt_diagnostico)) qt_item
		 	from	can_ficha_admissao
		 	where	dt_diagnostico between dt_inicial_p and dt_final_p
		 	order by 1) alias5 LIMIT (vl_primeiro_w);

	elsif (ie_tipo_p = 'T') then

		select	max(qt_item)
		into STRICT	vl_result_w
		from	(SELECT	trunc((dt_preench_ficha) - (dt_diagnostico)) qt_item
		 	from	can_ficha_admissao
		 	where	dt_diagnostico between dt_inicial_p and dt_final_p
		 	order by 1) alias5 LIMIT (vl_terceiro_w);

	end if;


elsif (ie_opcao_p = 'DT') then

	select	dividir((25 * count(trunc((dt_diagnostico) - (dt_inicio_trat)))), 100) vl_primeiro,
		dividir((75 * count(trunc((dt_diagnostico) - (dt_inicio_trat)))), 100) vl_terceiro
	into STRICT	vl_primeiro_w,
		vl_terceiro_w
	from	can_ficha_admissao
	where	dt_diagnostico between dt_inicial_p and dt_final_p;

	if (ie_tipo_p = 'P') then

		select	max(qt_item)
		into STRICT	vl_result_w
		from	(SELECT	trunc((dt_diagnostico) - (dt_inicio_trat)) qt_item
			from	can_ficha_admissao
		 	where	dt_diagnostico between dt_inicial_p and dt_final_p
	 		order by 1) alias5 LIMIT (vl_primeiro_w);

	elsif (ie_tipo_p = 'T') then

		select	max(qt_item)
		into STRICT	vl_result_w
		from	(SELECT	trunc((dt_diagnostico) - (dt_inicio_trat)) qt_item
			from	can_ficha_admissao
		 	where	dt_diagnostico between dt_inicial_p and dt_final_p
		 	order by 1) alias5 LIMIT (vl_terceiro_w);

	end if;


elsif (ie_opcao_p = 'MT') then

	select	dividir((25 * count(trunc((dt_preench_ficha) - (dt_inicio_trat)))), 100) vl_primeiro,
		dividir((75 * count(trunc((dt_preench_ficha) - (dt_inicio_trat)))), 100) vl_terceiro
	into STRICT	vl_primeiro_w,
		vl_terceiro_w
	from	can_ficha_admissao
	where	dt_diagnostico between dt_inicial_p and dt_final_P;

	if (ie_tipo_p = 'P') then

		select	max(qt_item)
		into STRICT	vl_result_w
		from	(SELECT trunc((dt_preench_ficha) - (dt_inicio_trat)) qt_item
			from	can_ficha_admissao
			where	dt_diagnostico between dt_inicial_p and dt_final_p
			order by 1) alias5 LIMIT (vl_primeiro_w);

	elsif (ie_tipo_p = 'T') then

		select	max(qt_item)
		into STRICT	vl_result_w
		from	(SELECT trunc((dt_preench_ficha) - (dt_inicio_trat)) qt_item
			from	can_ficha_admissao
			where	dt_diagnostico between dt_inicial_p and dt_final_p
			order by 1) alias5 LIMIT (vl_terceiro_w);

	end if;


end if;

RETURN vl_result_w;

END;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_quartis_relatorio (dt_inicial_p timestamp, dt_final_p timestamp, ie_opcao_p text, ie_tipo_p text) FROM PUBLIC;
