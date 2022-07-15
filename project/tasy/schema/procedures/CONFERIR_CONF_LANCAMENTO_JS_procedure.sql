-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE conferir_conf_lancamento_js ( nr_sequencia_p bigint, dt_conferencia_p timestamp) AS $body$
BEGIN
if (nr_sequencia_p IS NOT NULL AND nr_sequencia_p::text <> '') then
	begin
	update movto_trans_financ
	set dt_conferencia = dt_conferencia_p
	where	nr_sequencia = nr_sequencia_p;
	commit;
	end;
end if;
end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE conferir_conf_lancamento_js ( nr_sequencia_p bigint, dt_conferencia_p timestamp) FROM PUBLIC;

