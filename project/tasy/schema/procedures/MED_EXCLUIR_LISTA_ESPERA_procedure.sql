-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE med_excluir_lista_espera ( nr_seq_lista_p bigint) AS $body$
BEGIN

if (nr_seq_lista_p IS NOT NULL AND nr_seq_lista_p::text <> '') then
	delete from med_lista_espera where nr_sequencia = nr_seq_lista_p;
end if;

commit;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE med_excluir_lista_espera ( nr_seq_lista_p bigint) FROM PUBLIC;
