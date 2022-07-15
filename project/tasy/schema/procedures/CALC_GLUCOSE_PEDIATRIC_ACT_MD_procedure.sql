-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE calc_glucose_pediatric_act_md (Qt_Elem_KgDia_p bigint, Qt_Peso_p bigint, qt_Conversion_ML_p bigint, qt_carb_Factor_p bigint, qt_Mult_Glic_p bigint, Qt_Diaria_p INOUT bigint, Qt_Volume_Final_p INOUT bigint, Qt_Kcal_p INOUT bigint, Qt_Vel_Inf_Glicose_p INOUT bigint ) AS $body$
DECLARE


    qt_Daily_w bigint;

BEGIN
      Qt_Diaria_p           := (round((Qt_Elem_KgDia_p * Qt_Peso_p)::numeric, 2));
      Qt_Volume_Final_p     :=  (round((Qt_Diaria_p * qt_Conversion_ML_p)::numeric, 2));
      Qt_Kcal_p             := (Qt_Diaria_p * qt_carb_Factor_p);
      Qt_Vel_Inf_Glicose_p  :=  (round((dividir_md(Qt_Elem_KgDia_p,qt_Mult_Glic_p))::numeric, 2));

END;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE calc_glucose_pediatric_act_md (Qt_Elem_KgDia_p bigint, Qt_Peso_p bigint, qt_Conversion_ML_p bigint, qt_carb_Factor_p bigint, qt_Mult_Glic_p bigint, Qt_Diaria_p INOUT bigint, Qt_Volume_Final_p INOUT bigint, Qt_Kcal_p INOUT bigint, Qt_Vel_Inf_Glicose_p INOUT bigint ) FROM PUBLIC;

