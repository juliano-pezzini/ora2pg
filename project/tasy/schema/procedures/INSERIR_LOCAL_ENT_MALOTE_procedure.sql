-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE inserir_local_ent_malote (nr_seq_malote_p bigint, nr_seq_local_entrega_p bigint, nm_usuario_p text) AS $body$
BEGIN

if (nr_seq_malote_p IS NOT NULL AND nr_seq_malote_p::text <> '') then

	update	malote_envelope_laudo
	set		nr_seq_local_entrega	= nr_seq_local_entrega_p,
			nm_usuario		     	= nm_usuario_p,
			dt_atualizacao		 	= clock_timestamp()
	where	nr_sequencia			= nr_seq_malote_p;

end if;

commit;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE inserir_local_ent_malote (nr_seq_malote_p bigint, nr_seq_local_entrega_p bigint, nm_usuario_p text) FROM PUBLIC;

