-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE obter_glucose_y_neont_md (qt_GGlucose_Day_p bigint, qt_glucose_Factor_Param_p bigint, Qt_Aporte_Hidrico_Diario_p bigint, qt_peso_p bigint, ie_Round_p text default 'S', Qt_Diaria_p INOUT bigint DEFAULT NULL, Qt_Kcal_p INOUT bigint DEFAULT NULL, Qt_ElemKg_Dia_p INOUT bigint DEFAULT NULL, Pr_Concentracao_p INOUT bigint DEFAULT NULL, Qt_Vel_Inf_Glicose_p INOUT bigint  DEFAULT NULL) AS $body$
DECLARE


    qt_GGlucose_KgDay_w bigint;

BEGIN
        qt_GGlucose_KgDay_w := dividir_md(qt_GGlucose_Day_p,qt_peso_p);

        if ie_Round_p = 'S' then
           Qt_Diaria_p       := round((qt_GGlucose_Day_p)::numeric,2);
           Qt_ElemKg_Dia_p   := round((qt_GGlucose_KgDay_w)::numeric,2);
        else
           Qt_Diaria_p       := qt_GGlucose_Day_p;
           Qt_ElemKg_Dia_p   := qt_GGlucose_KgDay_w;
        end if;

        Qt_Kcal_p            := qt_GGlucose_Day_p * qt_glucose_Factor_Param_p;
        Pr_Concentracao_p    := dividir_sem_round_md((qt_GGlucose_Day_p * 100),Qt_Aporte_Hidrico_Diario_p);
        Qt_Vel_Inf_Glicose_p := (round((dividir_md(qt_GGlucose_KgDay_w,1.44))::numeric, 2));

END;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE obter_glucose_y_neont_md (qt_GGlucose_Day_p bigint, qt_glucose_Factor_Param_p bigint, Qt_Aporte_Hidrico_Diario_p bigint, qt_peso_p bigint, ie_Round_p text default 'S', Qt_Diaria_p INOUT bigint DEFAULT NULL, Qt_Kcal_p INOUT bigint DEFAULT NULL, Qt_ElemKg_Dia_p INOUT bigint DEFAULT NULL, Pr_Concentracao_p INOUT bigint DEFAULT NULL, Qt_Vel_Inf_Glicose_p INOUT bigint  DEFAULT NULL) FROM PUBLIC;

