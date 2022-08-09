-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE libera_estorna_portal ( ie_liberacao_p text, nr_ordem_compra_p bigint) AS $body$
BEGIN
 
update	ordem_compra 
set 	ie_liberacao_portal	= ie_liberacao_p 
where 	nr_ordem_compra 	= nr_ordem_compra_p;
 
commit;
 
end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE libera_estorna_portal ( ie_liberacao_p text, nr_ordem_compra_p bigint) FROM PUBLIC;
