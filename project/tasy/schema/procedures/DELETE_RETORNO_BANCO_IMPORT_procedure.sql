-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE delete_retorno_banco_import ( nm_tabela_p text, nr_sequencia_p bigint) AS $body$
DECLARE


ds_sep_bv_w	varchar(10);


BEGIN
	if (coalesce(nr_sequencia_p, 0) > 0) then
		begin

		select 	obter_separador_bv
		into STRICT	ds_sep_bv_w
		;

		CALL exec_sql_dinamico_bv('', 'delete from ' || nm_tabela_p || ' where nr_seq_cobr_escrit = :nr_seq_cobr_escrit','nr_seq_cobr_escrit=' ||  nr_sequencia_p || ds_sep_bv_w);
		end;
	end if;
commit;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE delete_retorno_banco_import ( nm_tabela_p text, nr_sequencia_p bigint) FROM PUBLIC;
