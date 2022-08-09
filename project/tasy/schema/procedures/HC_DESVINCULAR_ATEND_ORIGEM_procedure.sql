-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE hc_desvincular_atend_origem ( nr_seq_paciente_p bigint, ie_pasta_p text) AS $body$
BEGIN

--Pasta
--PA = paciente
--AT = atendimentos/visitas
if (nr_seq_paciente_p IS NOT NULL AND nr_seq_paciente_p::text <> '') and (ie_pasta_p IS NOT NULL AND ie_pasta_p::text <> '') then
	if (ie_pasta_p = 'PA') then
		update	paciente_home_care
		set	nr_atendimento_origem  = NULL
		where	nr_sequencia = nr_seq_paciente_p;
	elsif (ie_pasta_p = 'AT') then
		update	PACIENTE_HC_ATEND
		set		nr_atendimento  = NULL
		where	nr_sequencia = nr_seq_paciente_p;
	end if;
end if;

commit;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE hc_desvincular_atend_origem ( nr_seq_paciente_p bigint, ie_pasta_p text) FROM PUBLIC;
