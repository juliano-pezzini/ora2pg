-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE man_atualiza_just_grau_satisf ( nr_seq_justificativa_p bigint, nr_seq_ordem_p bigint) AS $body$
BEGIN

update	man_ordem_servico
set	nr_seq_justif_grau_satisf = nr_seq_justificativa_p
where	nr_sequencia = nr_seq_ordem_p;

commit;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE man_atualiza_just_grau_satisf ( nr_seq_justificativa_p bigint, nr_seq_ordem_p bigint) FROM PUBLIC;

