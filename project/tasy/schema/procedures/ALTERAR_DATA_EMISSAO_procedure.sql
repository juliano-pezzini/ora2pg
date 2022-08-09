-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE alterar_data_emissao ( nr_titulo_p bigint, dt_emissao_p timestamp) AS $body$
BEGIN
if (nr_titulo_p IS NOT NULL AND nr_titulo_p::text <> '')  and (dt_emissao_p IS NOT NULL AND dt_emissao_p::text <> '') then
	begin
	update	titulo_pagar
	set     	dt_emissao = dt_emissao_p
	where   	nr_titulo = nr_titulo_p;
	commit;
	end;
end if;
end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE alterar_data_emissao ( nr_titulo_p bigint, dt_emissao_p timestamp) FROM PUBLIC;
