-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE obter_hydric_neonatal_act_md (Qt_Nec_Hidrica_Diaria_p bigint, qt_peso_p bigint, Qt_Descontar_Hidrico_p bigint, Qt_Nec_KcalKg_Dia_p bigint, Qt_Aporte_Hidrico_Diario_p INOUT bigint, Qt_Nec_Kcal_Dia_p INOUT bigint ) AS $body$
BEGIN
  Qt_Aporte_Hidrico_Diario_p := coalesce(Qt_Nec_Hidrica_Diaria_p,0) * coalesce(qt_peso_p,0) - coalesce(Qt_Descontar_Hidrico_p,0);	
  Qt_Nec_Kcal_Dia_p          := coalesce(Qt_Nec_KcalKg_Dia_p,0) * coalesce(qt_peso_p,0);

END;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE obter_hydric_neonatal_act_md (Qt_Nec_Hidrica_Diaria_p bigint, qt_peso_p bigint, Qt_Descontar_Hidrico_p bigint, Qt_Nec_KcalKg_Dia_p bigint, Qt_Aporte_Hidrico_Diario_p INOUT bigint, Qt_Nec_Kcal_Dia_p INOUT bigint ) FROM PUBLIC;

