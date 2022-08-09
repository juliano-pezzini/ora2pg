-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE nut_liberar_servico_refeicao ( nr_seq_cardapio_p bigint, nm_usuario_p text) AS $body$
BEGIN

if (nr_seq_cardapio_p IS NOT NULL AND nr_seq_cardapio_p::text <> '') then

	update 	nut_cardapio_dia
	set 	dt_liberacao		= clock_timestamp(),
		nm_usuario_liberacao 	= nm_usuario_p
	where	nr_sequencia		= nr_seq_cardapio_p;

	update	nut_pac_opcao_rec
	set	dt_liberacao		= clock_timestamp()
	where	nr_seq_cardapio_dia 	= nr_seq_cardapio_p;

end if;

commit;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE nut_liberar_servico_refeicao ( nr_seq_cardapio_p bigint, nm_usuario_p text) FROM PUBLIC;
