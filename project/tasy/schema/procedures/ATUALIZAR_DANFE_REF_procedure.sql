-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE atualizar_danfe_ref ( nr_danfe_ref_p bigint, nr_seq_nota_p bigint) AS $body$
BEGIN

if (nr_seq_nota_p IS NOT NULL AND nr_seq_nota_p::text <> '') then
	begin
		update 	nota_fiscal
		set 	nr_danfe_referencia	= nr_danfe_ref_p
		where 	nr_sequencia		= nr_seq_nota_p;
		commit;
	end;
end if;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE atualizar_danfe_ref ( nr_danfe_ref_p bigint, nr_seq_nota_p bigint) FROM PUBLIC;
