-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION gpt_obter_dt_ult_evol_med ( nr_atendimento_p bigint ) RETURNS EVOLUCAO_PACIENTE.DT_EVOLUCAO%TYPE AS $body$
DECLARE


	dt_evolucao_w   evolucao_paciente.dt_evolucao%type := clock_timestamp();


BEGIN

	if (nr_atendimento_p IS NOT NULL AND nr_atendimento_p::text <> '') then

		select	max(a.dt_liberacao)
		into STRICT 	dt_evolucao_w
		from	evolucao_paciente a,
				medico b
		where	a.cd_medico = b.cd_pessoa_fisica
		and		(a.dt_liberacao IS NOT NULL AND a.dt_liberacao::text <> '')
		and		a.nr_atendimento = nr_atendimento_p;

	end if;

	return dt_evolucao_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION gpt_obter_dt_ult_evol_med ( nr_atendimento_p bigint ) FROM PUBLIC;

