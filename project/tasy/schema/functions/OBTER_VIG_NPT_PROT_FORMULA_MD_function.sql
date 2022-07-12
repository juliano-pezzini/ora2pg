-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_vig_npt_prot_formula_md (qt_Glicose_p bigint, qt_peso_p bigint ) RETURNS bigint AS $body$
DECLARE

   qt_result_w bigint;

BEGIN
    qt_result_w := dividir_sem_round_md(ceil((dividir_sem_round_md(coalesce(qt_Glicose_p,0),(coalesce(qt_peso_p,0)) * 1.44)) * 100.0),100.0);

    return coalesce(qt_result_w,0);

END;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_vig_npt_prot_formula_md (qt_Glicose_p bigint, qt_peso_p bigint ) FROM PUBLIC;

