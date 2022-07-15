-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE alterar_vl_bordero_tit_js ( vl_bordero_p bigint, nr_titulo_p bigint) AS $body$
BEGIN

update 	bordero_tit_pagar
set    	vl_bordero  = vl_bordero_p
where  	nr_titulo   = nr_titulo_p;

commit;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE alterar_vl_bordero_tit_js ( vl_bordero_p bigint, nr_titulo_p bigint) FROM PUBLIC;

