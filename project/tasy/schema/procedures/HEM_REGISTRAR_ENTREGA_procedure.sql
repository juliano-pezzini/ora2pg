-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE hem_registrar_entrega ( nr_seq_proc_p bigint, ds_observacao_p text, nm_usuario_p text) AS $body$
BEGIN
if (coalesce(nr_seq_proc_p, 0) > 0) then

	update	hem_proc
	set	dt_atualizacao		= clock_timestamp(),
		nm_usuario		= nm_usuario_p,
		dt_entrega		= clock_timestamp(),
		nm_usuario_entrega	= nm_usuario_p,
		ds_observacao_entrega	= ds_observacao_p
	where	nr_sequencia		= nr_seq_proc_p;

end if;
commit;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE hem_registrar_entrega ( nr_seq_proc_p bigint, ds_observacao_p text, nm_usuario_p text) FROM PUBLIC;

