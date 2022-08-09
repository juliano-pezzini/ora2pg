-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE man_atualizar_item_func ( nm_usuario_p text, nr_sequencia_p bigint, nr_seq_item_func_p bigint) AS $body$
BEGIN
if (coalesce(nr_sequencia_p,0) > 0) and (coalesce(nr_seq_item_func_p,0) > 0) then

	update	man_ordem_servico
	set	nr_seq_func_item = nr_seq_item_func_p,
		nm_usuario = nm_usuario_p,
		dt_atualizacao = clock_timestamp()
	where	nr_sequencia = nr_sequencia_p;

end if;

commit;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE man_atualizar_item_func ( nm_usuario_p text, nr_sequencia_p bigint, nr_seq_item_func_p bigint) FROM PUBLIC;
