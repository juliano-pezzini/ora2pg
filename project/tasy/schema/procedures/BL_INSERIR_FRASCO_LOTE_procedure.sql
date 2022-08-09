-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE bl_inserir_frasco_lote (nr_seq_frasco_p bigint, nr_seq_lote_p bigint, nm_usuario_p text) AS $body$
BEGIN
if (nr_seq_frasco_p IS NOT NULL AND nr_seq_frasco_p::text <> '') and (nr_seq_lote_p IS NOT NULL AND nr_seq_lote_p::text <> '') then

	insert into bl_lote_item(
		dt_atualizacao,
		nm_usuario,
		dt_atualizacao_nrec,
		nm_usuario_nrec,
		nr_seq_lote,
		nr_seq_frasco)
	values (	clock_timestamp(),
		nm_usuario_p,
		clock_timestamp(),
		nm_usuario_p,
		nr_seq_lote_p,
		nr_seq_frasco_p);

	update	bl_frasco
	set	ie_situacao_processa = 'L',
		dt_atualizacao	= clock_timestamp(),
		nm_usuario	= nm_usuario_p
	where	nr_sequencia	= nr_seq_frasco_p;

end if;

commit;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE bl_inserir_frasco_lote (nr_seq_frasco_p bigint, nr_seq_lote_p bigint, nm_usuario_p text) FROM PUBLIC;
