-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE apagar_int_princ_alterada ( nr_seq_ficha_p bigint, nr_seq_ficha_interacao_p bigint) AS $body$
BEGIN

if 	(nr_seq_ficha_p IS NOT NULL AND nr_seq_ficha_p::text <> '' AND nr_seq_ficha_interacao_p IS NOT NULL AND nr_seq_ficha_interacao_p::text <> '') then
	delete	from material_interacao_medic
	where	nr_seq_ficha = nr_seq_ficha_interacao_p
	and 	nr_seq_ficha_interacao = nr_seq_ficha_p;

	commit;
end if;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE apagar_int_princ_alterada ( nr_seq_ficha_p bigint, nr_seq_ficha_interacao_p bigint) FROM PUBLIC;
