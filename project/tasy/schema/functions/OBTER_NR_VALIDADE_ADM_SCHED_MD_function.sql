-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_nr_validade_adm_sched_md (qt_dif_Inicio_Fim_p bigint ) RETURNS bigint AS $body$
DECLARE

   result_w bigint;

BEGIN
    if qt_dif_Inicio_Fim_p <= 24 and qt_dif_Inicio_Fim_p > 0 then
      result_w := qt_dif_Inicio_Fim_p;
    else
      result_w := 24;
    end if;

    return coalesce(result_w,0);

END;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_nr_validade_adm_sched_md (qt_dif_Inicio_Fim_p bigint ) FROM PUBLIC;

