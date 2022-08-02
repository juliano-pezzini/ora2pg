-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE update_reg_lic_item_fornec ( nr_seq_parecer_p bigint, nr_sequencia_p bigint) AS $body$
BEGIN
 
update	reg_lic_item_fornec 
set	nr_seq_parecer = nr_seq_parecer_p 
where	nr_sequencia = nr_sequencia_p;
	 
commit;
 
end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE update_reg_lic_item_fornec ( nr_seq_parecer_p bigint, nr_sequencia_p bigint) FROM PUBLIC;

