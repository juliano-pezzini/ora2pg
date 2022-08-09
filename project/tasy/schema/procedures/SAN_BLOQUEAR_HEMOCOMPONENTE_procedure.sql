-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE san_bloquear_hemocomponente ( nr_seq_producao_p bigint, nr_seq_motivo_p bigint, ds_observacao_p text, nm_usuario_p text) AS $body$
BEGIN

if (nr_seq_motivo_p IS NOT NULL AND nr_seq_motivo_p::text <> '') and (ds_observacao_p IS NOT NULL AND ds_observacao_p::text <> '') and (nr_seq_producao_p IS NOT NULL AND nr_seq_producao_p::text <> '') then

	update	san_producao
	set	ds_justificativa_bloqueio 	= ds_observacao_p,
		dt_bloqueio 			= clock_timestamp(),
		nm_usuario_bloqueio		= nm_usuario_p,
		nr_seq_motivo_bloqueio		= nr_seq_motivo_p
	where	nr_sequencia 			= nr_seq_producao_p;

end if;

commit;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE san_bloquear_hemocomponente ( nr_seq_producao_p bigint, nr_seq_motivo_p bigint, ds_observacao_p text, nm_usuario_p text) FROM PUBLIC;
