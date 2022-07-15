-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE liberar_informacao_adicional (nr_seq_proced_info_p bigint) AS $body$
BEGIN

if (nr_seq_proced_info_p IS NOT NULL AND nr_seq_proced_info_p::text <> '') then
	update	prescr_proced_inf_adic
	set	dt_liberacao = clock_timestamp()
	where	nr_sequencia = nr_seq_proced_info_p;
end if;

commit;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE liberar_informacao_adicional (nr_seq_proced_info_p bigint) FROM PUBLIC;

