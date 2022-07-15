-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE hd_inativar_controle ( nr_seq_controle_p bigint, nr_seq_dialise_p bigint, nm_usuario_p text) AS $body$
BEGIN

if (nr_seq_controle_p IS NOT NULL AND nr_seq_controle_p::text <> '') then
	update	hd_controle
	set	dt_inativacao		= clock_timestamp(),
		nm_usuario_inativacao	= nm_usuario_p
	where	nr_sequencia  = nr_seq_controle_p;

	if (nr_seq_dialise_p IS NOT NULL AND nr_seq_dialise_p::text <> '') then
		update	hd_assinatura_digital
		set	dt_inativacao		= clock_timestamp(),
			nm_usuario_inativacao	= nm_usuario_p
		where	nr_seq_dialise 	= nr_seq_dialise_p
		and	nr_seq_controle = nr_seq_controle_p;

		CALL hd_gerar_assinatura(null, null, nr_seq_dialise_p, null, nr_seq_controle_p, null, null, null, null, 'CI', nm_usuario_p, 'N');
	end if;
end if;

commit;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE hd_inativar_controle ( nr_seq_controle_p bigint, nr_seq_dialise_p bigint, nm_usuario_p text) FROM PUBLIC;

