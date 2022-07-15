-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE nut_cancelar_solic_lanche ( nr_sequencia_p bigint, nm_usuario_p text) AS $body$
BEGIN
if (nr_sequencia_p IS NOT NULL AND nr_sequencia_p::text <> '') then
update 	nut_solic_lanche
set	dt_cancelamento = clock_timestamp(),
	nm_usuario_canc = nm_usuario_p
where  	nr_sequencia = nr_sequencia_p;
end if;
commit;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE nut_cancelar_solic_lanche ( nr_sequencia_p bigint, nm_usuario_p text) FROM PUBLIC;

