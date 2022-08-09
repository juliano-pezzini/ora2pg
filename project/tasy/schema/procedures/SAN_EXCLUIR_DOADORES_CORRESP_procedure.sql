-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE san_excluir_doadores_corresp (nr_seq_corresp bigint) AS $body$
BEGIN
if (nr_seq_corresp IS NOT NULL AND nr_seq_corresp::text <> '') then

	delete
	from	san_envio_corresp_item
	where	nr_sequencia = nr_seq_corresp;

end if;

commit;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE san_excluir_doadores_corresp (nr_seq_corresp bigint) FROM PUBLIC;
