-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE cpoe_del_mem_calc ( nr_seq_mat_cpoe_p cpoe_calc_memoria_usada.nr_seq_mat_cpoe%type ) AS $body$
BEGIN

    if (nr_seq_mat_cpoe_p > 0) then
        delete from CPOE_CALC_MEMORIA_USADA where nr_seq_mat_cpoe = nr_seq_mat_cpoe_p;
        commit;
    end if;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE cpoe_del_mem_calc ( nr_seq_mat_cpoe_p cpoe_calc_memoria_usada.nr_seq_mat_cpoe%type ) FROM PUBLIC;

