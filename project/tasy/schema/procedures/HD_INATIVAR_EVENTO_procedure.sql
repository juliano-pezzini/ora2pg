-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE hd_inativar_evento ( nr_seq_evento_p bigint, nr_seq_dialise_p bigint, nm_usuario_p text) AS $body$
BEGIN

if (nr_seq_evento_p IS NOT NULL AND nr_seq_evento_p::text <> '') then

	update	hd_dialise_evento
	set	dt_inativacao		= clock_timestamp(),
		nm_usuario_inativacao	= nm_usuario_p
	where	nr_sequencia  		= nr_seq_evento_p;

	update	hd_assinatura_item
	set	dt_inativacao		= clock_timestamp(),
		nm_usuario_inativacao	= nm_usuario_p
	where	nr_seq_evento = nr_seq_evento_p;

	CALL hd_gerar_assinatura(null, null, nr_seq_dialise_p, null, null, nr_seq_evento_p, null, null, null, 'IE', nm_usuario_p, 'N');
end if;

commit;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE hd_inativar_evento ( nr_seq_evento_p bigint, nr_seq_dialise_p bigint, nm_usuario_p text) FROM PUBLIC;

