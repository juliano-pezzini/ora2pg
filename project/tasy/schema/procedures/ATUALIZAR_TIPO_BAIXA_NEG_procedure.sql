-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE atualizar_tipo_baixa_neg ( nr_titulo_p bigint, cd_tipo_baixa_neg_p bigint) AS $body$
BEGIN
if (nr_titulo_p IS NOT NULL AND nr_titulo_p::text <> '') then
	begin
	update 	titulo_pagar
	set    	cd_tipo_baixa_neg = cd_tipo_baixa_neg_p
	where  	nr_titulo = nr_titulo_p;
	commit;
	end;
end if;
end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE atualizar_tipo_baixa_neg ( nr_titulo_p bigint, cd_tipo_baixa_neg_p bigint) FROM PUBLIC;
