-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE alterar_tributo_titulo ( nr_sequencia_p bigint, cd_tributo_novo_p bigint) AS $body$
BEGIN
if (nr_sequencia_p IS NOT NULL AND nr_sequencia_p::text <> '')  and (cd_tributo_novo_p IS NOT NULL AND cd_tributo_novo_p::text <> '') then
	begin
	update 	titulo_pagar_imposto
	set    	cd_tributo = cd_tributo_novo_p
        	where 	nr_sequencia = nr_sequencia_p;
	commit;
	end;
end if;
end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE alterar_tributo_titulo ( nr_sequencia_p bigint, cd_tributo_novo_p bigint) FROM PUBLIC;

