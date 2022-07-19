-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE pls_atualizar_nr_seq_contrato ( nr_contrato_p bigint) AS $body$
DECLARE

nr_seq_contrato_w	pls_contrato.nr_sequencia%type;

BEGIN

if (coalesce(nr_contrato_p,0) > 0) then

	select  coalesce(max(nr_sequencia), 0)
	into STRICT	nr_seq_contrato_w
	from	pls_contrato
	where	nr_contrato = nr_contrato_p;

	if (nr_seq_contrato_w > 0) then
		update	pls_regra_declaracao_prop
		set	nr_seq_contrato = nr_seq_contrato_w
		where	nr_contrato = nr_contrato_p;

		commit;
	end if;

end if;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE pls_atualizar_nr_seq_contrato ( nr_contrato_p bigint) FROM PUBLIC;

