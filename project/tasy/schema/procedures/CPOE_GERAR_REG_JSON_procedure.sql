-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE cpoe_gerar_reg_json ( nm_usuario_p text, dt_referencia_p timestamp default clock_timestamp() - interval '1 days') AS $body$
DECLARE


C01 CURSOR FOR
	SELECT distinct nr_atendimento_w
	from (
		SELECT	nr_atendimento nr_atendimento_w
		from	unidade_atendimento
		where	(nr_atendimento IS NOT NULL AND nr_atendimento::text <> '')
		
union

		select	a.nr_atendimento nr_atendimento_w
		from	atend_paciente_unidade a,
				setor_atendimento b,
				atendimento_paciente c
		where	a.cd_setor_atendimento = b.cd_setor_atendimento
		and		a.nr_atendimento = c.nr_atendimento
		and		a.dt_saida_interno = to_date('30/12/2999','dd/mm/yyyy')
		and		c.dt_alta_interno = to_date('30/12/2999','dd/mm/yyyy')
		
union

		select	nr_atendimento
		from	atendimento_paciente
		where	dt_alta between trunc(dt_referencia_p) and fim_dia(dt_referencia_p)
		order by nr_atendimento_w) a
	where (select count(1)
			from cpoe_itens_json_v b
			where	a.nr_atendimento_w = b.nr_atendimento
			and	b.dt_prox_geracao > dt_referencia_p - 2) > 0
	order by nr_atendimento_w;

nr_hora_w			bigint;

BEGIN
EXECUTE 'ALTER SESSION SET NLS_LANGUAGE=''BRAZILIAN PORTUGUESE''';
EXECUTE 'ALTER SESSION SET NLS_TERRITORY = ''BRAZIL''';
EXECUTE 'ALTER SESSION SET NLS_NUMERIC_CHARACTERS='',.''';
EXECUTE 'ALTER SESSION SET NLS_DATE_FORMAT = ''DD/MM/YY''';

nr_hora_w := (to_char(dt_referencia_p,'hh24'))::numeric;
if (nr_hora_w <= 12) then
	for c01_w in C01
	loop
		begin
		CALL CPOE_Gerar_Registro_Json_PCK.CPOE_Gerar_Registros_Json(c01_w.nr_atendimento_w,dt_referencia_p,nm_usuario_p);
		exception
		when others then
			CALL gravar_log_cpoe('CPOE_GERAR_REG_JSON - STACK: ' || dbms_utility.format_call_stack || ' ERRO: ' ||to_char(sqlerrm), c01_w.nr_atendimento_w);
		end;
		commit;
	end loop;
end if;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE cpoe_gerar_reg_json ( nm_usuario_p text, dt_referencia_p timestamp default clock_timestamp() - interval '1 days') FROM PUBLIC;
