-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE alterar_estabelecimento ( nr_seq_cliente_p bigint, cd_estabelecimento_p bigint ) AS $body$
BEGIN
	if (nr_seq_cliente_p IS NOT NULL AND nr_seq_cliente_p::text <> '') then
		update	com_cliente
		set 	cd_estabelecimento = cd_estabelecimento_p
		where 	nr_sequencia = nr_seq_cliente_p;

		update contrato
		set cd_estabelecimento = cd_estabelecimento_p
		where cd_estabelecimento <> cd_estabelecimento_p
		and nr_seq_cliente = nr_seq_cliente_p;

	end if;
	commit;
end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE alterar_estabelecimento ( nr_seq_cliente_p bigint, cd_estabelecimento_p bigint ) FROM PUBLIC;

