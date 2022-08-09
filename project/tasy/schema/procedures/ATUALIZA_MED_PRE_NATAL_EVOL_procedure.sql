-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE atualiza_med_pre_natal_evol (nm_usuario_p text, nr_sequencia_p bigint, nr_seq_evolucao_p bigint) AS $body$
BEGIN

if (nr_sequencia_p IS NOT NULL AND nr_sequencia_p::text <> '') and (nr_seq_evolucao_p IS NOT NULL AND nr_seq_evolucao_p::text <> '')	then

	update 	med_pac_pre_natal_evol
	set		nm_usuario 			= nm_usuario_p,
				nr_seq_evolucao 	= nr_seq_evolucao_p,
				dt_atualizacao 	= clock_timestamp()
	where		nr_sequencia 		=	nr_sequencia_p;
end if;

commit;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE atualiza_med_pre_natal_evol (nm_usuario_p text, nr_sequencia_p bigint, nr_seq_evolucao_p bigint) FROM PUBLIC;
