-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE cih_excluir_tecnica_hig_maos ( nr_seq_dados_hig_p bigint) AS $body$
BEGIN
if (nr_seq_dados_hig_p IS NOT NULL AND nr_seq_dados_hig_p::text <> '') then
	begin
		delete
		from cih_tecnica_hig_maos
		where nr_seq_dados_hig = nr_seq_dados_hig_p;
	end;
end if;

commit;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE cih_excluir_tecnica_hig_maos ( nr_seq_dados_hig_p bigint) FROM PUBLIC;

