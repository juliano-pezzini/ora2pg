-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE delete_fatores_prot_loco_reg ( nr_seq_loco_reg_p bigint ) AS $body$
BEGIN
	if (nr_seq_loco_reg_p > 0) then
		delete from fator_prog_loco_reg
		where nr_seq_can_loco_reg = nr_seq_loco_reg_p;
	end if;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE delete_fatores_prot_loco_reg ( nr_seq_loco_reg_p bigint ) FROM PUBLIC;

