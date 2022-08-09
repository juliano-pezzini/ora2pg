-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE reg_resolver_contingencia ( nr_seq_contingencia_p bigint) AS $body$
BEGIN

if (coalesce(nr_seq_contingencia_p, 0) > 0) then
	update	log_integracao_evento
	set	ie_tipo_evento = 'C'
	where	nr_sequencia = nr_seq_contingencia_p;

	commit;
end if;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE reg_resolver_contingencia ( nr_seq_contingencia_p bigint) FROM PUBLIC;
