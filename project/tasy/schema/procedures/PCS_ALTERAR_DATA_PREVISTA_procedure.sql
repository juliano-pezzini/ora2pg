-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE pcs_alterar_data_prevista (nr_seq_ordem_p bigint, nr_seq_atividade_p bigint, dt_prevista_p timestamp, nm_usuario_p text) AS $body$
BEGIN

if (dt_prevista_p IS NOT NULL AND dt_prevista_p::text <> '') then
	update	man_ordem_ativ_prev
	set 	dt_prevista = dt_prevista_p,
			nm_usuario = nm_usuario_p,
			dt_atualizacao = clock_timestamp()
	where	nr_seq_ordem_serv = nr_seq_ordem_p
	and		nr_sequencia = nr_seq_atividade_p;
end if;
commit;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE pcs_alterar_data_prevista (nr_seq_ordem_p bigint, nr_seq_atividade_p bigint, dt_prevista_p timestamp, nm_usuario_p text) FROM PUBLIC;
