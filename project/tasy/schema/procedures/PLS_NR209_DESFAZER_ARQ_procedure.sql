-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE pls_nr209_desfazer_arq (nr_seq_controle_p bigint) AS $body$
BEGIN

if (nr_seq_controle_p > 0) then

	delete
	from	ops_rn209_arquivo
	where	nr_seq_controle = nr_seq_controle_p;

	commit;
end if;


commit;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE pls_nr209_desfazer_arq (nr_seq_controle_p bigint) FROM PUBLIC;

