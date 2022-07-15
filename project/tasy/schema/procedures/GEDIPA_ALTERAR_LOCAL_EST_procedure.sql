-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE gedipa_alterar_local_est ( nr_sequencia_p bigint, cd_local_estoque_p bigint) AS $body$
BEGIN
update 	adep_processo
set 	cd_local_estoque = cd_local_estoque_p
where 	nr_sequencia = nr_sequencia_p;
commit;
end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE gedipa_alterar_local_est ( nr_sequencia_p bigint, cd_local_estoque_p bigint) FROM PUBLIC;

