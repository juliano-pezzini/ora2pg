-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE atend_alta_especial_del ( nr_sequencia_p bigint) AS $body$
BEGIN
if (coalesce(nr_sequencia_p,0) > 0) then

	delete
	from	atend_alta_esp_mat
	where	nr_seq_alta_esp = nr_sequencia_p;
end if;

commit;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE atend_alta_especial_del ( nr_sequencia_p bigint) FROM PUBLIC;

