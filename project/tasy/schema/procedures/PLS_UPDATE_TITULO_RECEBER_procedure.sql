-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE pls_update_titulo_receber ( nr_titulo_p bigint, nr_seq_conta_banco_p bigint, nr_seq_carteira_cobr_p bigint, nm_usuario_p text) AS $body$
BEGIN
if (nr_titulo_p IS NOT NULL AND nr_titulo_p::text <> '') and (nr_seq_carteira_cobr_p IS NOT NULL AND nr_seq_carteira_cobr_p::text <> '') and (nr_seq_conta_banco_p IS NOT NULL AND nr_seq_conta_banco_p::text <> '') and (nm_usuario_p IS NOT NULL AND nm_usuario_p::text <> '') then
	begin
	update	titulo_receber
	set	nr_seq_conta_banco 	= nr_seq_conta_banco_p,
		nr_seq_carteira_cobr 	= nr_seq_carteira_cobr_p,
		nm_usuario 		= nm_usuario_p
	where	nr_titulo 		= nr_titulo_p
	and	coalesce(nr_seq_conta_banco::text, '') = '';
	end;
end if;
commit;
end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE pls_update_titulo_receber ( nr_titulo_p bigint, nr_seq_conta_banco_p bigint, nr_seq_carteira_cobr_p bigint, nm_usuario_p text) FROM PUBLIC;

