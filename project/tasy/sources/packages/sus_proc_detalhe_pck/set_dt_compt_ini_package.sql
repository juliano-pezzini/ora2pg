-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';




CREATE OR REPLACE PROCEDURE sus_proc_detalhe_pck.set_dt_compt_ini (dt_compt_ini_p sus_detalhe_proc.dt_compt_ini%type) AS $body$
BEGIN
        PERFORM set_config('sus_proc_detalhe_pck.dt_compt_ini_w', dt_compt_ini_p, false);
        end;


$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE sus_proc_detalhe_pck.set_dt_compt_ini (dt_compt_ini_p sus_detalhe_proc.dt_compt_ini%type) FROM PUBLIC;