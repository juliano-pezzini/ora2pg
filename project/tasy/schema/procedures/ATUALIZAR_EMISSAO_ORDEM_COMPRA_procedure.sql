-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE atualizar_emissao_ordem_compra ( nr_ordem_compra_p bigint) AS $body$
BEGIN
 
if (nr_ordem_compra_p IS NOT NULL AND nr_ordem_compra_p::text <> '') then 
	begin 
	update	ordem_compra 
	set	dt_emissao	= clock_timestamp() 
	where	nr_ordem_compra	= nr_ordem_compra_p;
	commit;
	end;
end if;
 
end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE atualizar_emissao_ordem_compra ( nr_ordem_compra_p bigint) FROM PUBLIC;

