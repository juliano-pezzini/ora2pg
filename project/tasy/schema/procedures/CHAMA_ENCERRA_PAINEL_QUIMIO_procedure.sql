-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE chama_encerra_painel_quimio ( nr_seq_atendimento_p bigint, ie_opcao_p text, nm_usuario_p text) AS $body$
BEGIN

if (ie_opcao_p = 'C') then
	update 	paciente_atendimento
	set 	dt_chegada_painel = clock_timestamp(),
			dt_saida_painel  = NULL
	where 	nr_seq_atendimento = nr_seq_atendimento_p;

	commit;
elsif (ie_opcao_p = 'E') then
	update 	paciente_atendimento
	set 	dt_saida_painel = clock_timestamp()
	where 	nr_seq_atendimento = nr_seq_atendimento_p
	and		(dt_chegada_painel IS NOT NULL AND dt_chegada_painel::text <> '');

	commit;
end if;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE chama_encerra_painel_quimio ( nr_seq_atendimento_p bigint, ie_opcao_p text, nm_usuario_p text) FROM PUBLIC;

