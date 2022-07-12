-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_inicio_validade_case ( nr_seq_episodio_p episodio_paciente.nr_sequencia%type) RETURNS timestamp AS $body$
DECLARE

			
dt_inicio_validade_w	 atendimento_paciente_inf.dt_inicio_validade%type;


BEGIN

if (nr_seq_episodio_p IS NOT NULL AND nr_seq_episodio_p::text <> '') then

	select  max(api.dt_inicio_validade)
	into STRICT	dt_inicio_validade_w
	from    episodio_paciente ep,
			atendimento_paciente ap,
			atendimento_paciente_inf api
	where 	ep.nr_sequencia = ap.nr_seq_episodio
	and		api.nr_atendimento = ap.nr_atendimento
	and		ep.nr_sequencia = nr_seq_episodio_p;

end if;

return	dt_inicio_validade_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_inicio_validade_case ( nr_seq_episodio_p episodio_paciente.nr_sequencia%type) FROM PUBLIC;

