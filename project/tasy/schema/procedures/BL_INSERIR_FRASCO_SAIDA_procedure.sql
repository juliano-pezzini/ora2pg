-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE bl_inserir_frasco_saida ( nr_seq_frasco_p bigint, nr_seq_saida_p bigint, nm_usuario_p text) AS $body$
BEGIN
if (nr_seq_frasco_p IS NOT NULL AND nr_seq_frasco_p::text <> '') and (nr_seq_saida_p IS NOT NULL AND nr_seq_saida_p::text <> '') then

	update	bl_frasco
	set	dt_atualizacao	= clock_timestamp(),
		nm_usuario	= nm_usuario_p,
		nr_seq_saida	= nr_seq_saida_p
	where	nr_sequencia	= nr_seq_frasco_p;

end if;

commit;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE bl_inserir_frasco_saida ( nr_seq_frasco_p bigint, nr_seq_saida_p bigint, nm_usuario_p text) FROM PUBLIC;
