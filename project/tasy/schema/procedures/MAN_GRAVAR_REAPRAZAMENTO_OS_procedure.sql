-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE man_gravar_reaprazamento_os ( nr_seq_ordem_serv_p bigint, dt_reaprazamento_p timestamp, nr_motivo_reapraz_p bigint, nm_usuario_p text) AS $body$
BEGIN

if (coalesce(nr_seq_ordem_serv_p,0) > 0) and (dt_reaprazamento_p IS NOT NULL AND dt_reaprazamento_p::text <> '') and (nr_motivo_reapraz_p IS NOT NULL AND nr_motivo_reapraz_p::text <> '') then
	begin
	update	man_ordem_servico
	set	dt_fim_previsto = dt_reaprazamento_p
	where	nr_sequencia	= nr_seq_ordem_serv_p;

	insert into man_ordem_serv_fim_prev(
			nr_sequencia,
			nr_seq_ordem_serv,
			dt_atualizacao,
			nm_usuario,
			dt_atualizacao_nrec,
			nm_usuario_nrec,
			ds_motivo,
			dt_fim_previsto,
			nr_seq_motivo)
		values (	nextval('man_ordem_serv_fim_prev_seq'),
			nr_seq_ordem_serv_p,
			clock_timestamp(),
			nm_usuario_p,
			clock_timestamp(),
			nm_usuario_p,
			' ',
			dt_reaprazamento_p,
			nr_motivo_reapraz_p);

	commit;
	end;
end if;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE man_gravar_reaprazamento_os ( nr_seq_ordem_serv_p bigint, dt_reaprazamento_p timestamp, nr_motivo_reapraz_p bigint, nm_usuario_p text) FROM PUBLIC;
