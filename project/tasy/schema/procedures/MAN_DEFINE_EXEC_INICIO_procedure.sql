-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE man_define_exec_inicio ( nr_seq_ordem_p bigint, nr_seq_estagio_p bigint, nm_usuario_exec_p text) AS $body$
BEGIN

update	man_ordem_servico
set	nm_usuario_exec = nm_usuario_exec_p
where	nr_sequencia = nr_seq_ordem_p;

if (coalesce(nr_seq_estagio_p,0) <> 0) then
	begin

	update	man_ordem_servico
	set	nr_seq_estagio = nr_seq_estagio_p
	where	nr_sequencia = nr_seq_ordem_p;

	end;
end if;

commit;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE man_define_exec_inicio ( nr_seq_ordem_p bigint, nr_seq_estagio_p bigint, nm_usuario_exec_p text) FROM PUBLIC;
