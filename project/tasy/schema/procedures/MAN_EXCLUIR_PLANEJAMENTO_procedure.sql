-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE man_excluir_planejamento ( nr_seq_planej_p bigint, nm_usuario_p text) AS $body$
BEGIN

update	man_ordem_servico
set	nr_seq_planej  = NULL,
	nm_usuario = nm_usuario_p
where	nr_seq_planej = nr_seq_planej_p;

delete	from man_planej_prev
where	nr_sequencia = nr_seq_planej_p;

commit;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE man_excluir_planejamento ( nr_seq_planej_p bigint, nm_usuario_p text) FROM PUBLIC;
