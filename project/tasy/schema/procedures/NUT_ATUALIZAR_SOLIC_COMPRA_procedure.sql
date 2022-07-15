-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE nut_atualizar_solic_compra ( nr_seq_serv_p bigint, nr_solic_compra_p bigint, nm_usuario_p text) AS $body$
BEGIN

if (nr_seq_serv_p IS NOT NULL AND nr_seq_serv_p::text <> '') then

	update 	nut_atend_serv_dia
	set	nr_solic_compra = nr_solic_compra_p,
		dt_atualizacao	= clock_timestamp(),
		nm_usuario	= nm_usuario_p
	where	nr_sequencia	= nr_seq_serv_p;

end if;


commit;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE nut_atualizar_solic_compra ( nr_seq_serv_p bigint, nr_solic_compra_p bigint, nm_usuario_p text) FROM PUBLIC;

