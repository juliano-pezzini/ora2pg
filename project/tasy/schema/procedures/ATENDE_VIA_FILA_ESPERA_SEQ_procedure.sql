-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE atende_via_fila_espera_seq ( nr_sequencia_p bigint, nr_atendimento_p bigint, nm_usuario_p text) AS $body$
DECLARE


nr_seq_pac_espera_w	bigint;


BEGIN

if (nr_sequencia_p IS NOT NULL AND nr_sequencia_p::text <> '') and (nr_atendimento_p IS NOT NULL AND nr_atendimento_p::text <> '') then

	nr_seq_pac_espera_w	:= nr_sequencia_p;

	if (nr_seq_pac_espera_w <> 0) then

		update	paciente_espera
		set	nr_atendimento 	= nr_atendimento_p,
			dt_atualizacao 	= clock_timestamp(),
			nm_usuario	= nm_usuario_p
		where	nr_sequencia	= nr_seq_pac_espera_w
		and	coalesce(nr_atendimento::text, '') = '';

		commit;

	end if;
end if;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE atende_via_fila_espera_seq ( nr_sequencia_p bigint, nr_atendimento_p bigint, nm_usuario_p text) FROM PUBLIC;
