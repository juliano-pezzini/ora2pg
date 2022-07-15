-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE obter_glucose_n_neont_md (qt_glucose_Factor_Param_p bigint, qt_peso_p bigint, Qt_Vel_Inf_Glicose_p bigint, Qt_ElemKg_Dia_p INOUT bigint, Qt_Diaria_p INOUT bigint, Qt_Kcal_p INOUT bigint ) AS $body$
DECLARE


    qt_GGlucose_KgDay_w bigint;

BEGIN
        qt_GGlucose_KgDay_w  := round((Qt_Vel_Inf_Glicose_p * 1.44)::numeric, 2);
        Qt_ElemKg_Dia_p      := qt_GGlucose_KgDay_w;
        Qt_Diaria_p          := qt_GGlucose_KgDay_w * qt_peso_p;
        Qt_Kcal_p            := Qt_Diaria_p * qt_glucose_Factor_Param_p;

END;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE obter_glucose_n_neont_md (qt_glucose_Factor_Param_p bigint, qt_peso_p bigint, Qt_Vel_Inf_Glicose_p bigint, Qt_ElemKg_Dia_p INOUT bigint, Qt_Diaria_p INOUT bigint, Qt_Kcal_p INOUT bigint ) FROM PUBLIC;

