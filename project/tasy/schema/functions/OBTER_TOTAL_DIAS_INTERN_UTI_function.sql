-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_total_dias_intern_uti ( nr_atendimento_p bigint) RETURNS bigint AS $body$
DECLARE


qt_dias_internacao_w	bigint := 0;
dt_entrada_unidade_w	timestamp;
dt_saida_unidade_w	timestamp;
dt_saida_unidade_ant_w	timestamp;

C01 CURSOR FOR
	SELECT	ESTABLISHMENT_TIMEZONE_UTILS.startOfDay(dt_entrada_unidade),
		ESTABLISHMENT_TIMEZONE_UTILS.startOfDay(coalesce(dt_saida_unidade, clock_timestamp()))
	from	atend_paciente_unidade a
	where	nr_atendimento = nr_atendimento_p
	and	obter_classif_setor(cd_setor_atendimento) = 4
	order by dt_entrada_unidade;


BEGIN

if (nr_atendimento_p IS NOT NULL AND nr_atendimento_p::text <> '') then

	open C01;
	loop
	fetch C01 into
		dt_entrada_unidade_w,
		dt_saida_unidade_w;
	EXIT WHEN NOT FOUND; /* apply on C01 */
		qt_dias_internacao_w := qt_dias_internacao_w + (dt_saida_unidade_w - dt_entrada_unidade_w);
		if (ESTABLISHMENT_TIMEZONE_UTILS.startOfDay(dt_entrada_unidade_w) <> ESTABLISHMENT_TIMEZONE_UTILS.startOfDay(dt_saida_unidade_ant_w)) then
			qt_dias_internacao_w := qt_dias_internacao_w + 1;
		end if;
		dt_saida_unidade_ant_w	:= dt_saida_unidade_w;
	end loop;
	close C01;
end if;

if (dt_saida_unidade_ant_w IS NOT NULL AND dt_saida_unidade_ant_w::text <> '') then
	qt_dias_internacao_w	:= qt_dias_internacao_w+1;
end if;

return qt_dias_internacao_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_total_dias_intern_uti ( nr_atendimento_p bigint) FROM PUBLIC;
