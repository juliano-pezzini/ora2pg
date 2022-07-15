-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE calc_elem_water_nutrition_md (is_Round_p text, Qt_Aporte_Hidrico_Diario_p bigint, qt_Total_Volume_p bigint, qt_peso_p bigint, qt_Elem_KgDia_p INOUT bigint, Qt_ElemKgDia_p INOUT bigint, Qt_Diaria_p INOUT bigint, Qt_Volume_Final_p INOUT bigint ) AS $body$
DECLARE

   qt_Elem_KgDia_w bigint;

BEGIN
    if (is_Round_p = 'N') then
        if (Qt_Aporte_Hidrico_Diario_p > qt_Total_Volume_p) then
            qt_Elem_KgDia_w := qt_Elem_KgDia_p + round(dividir_sem_round_md((coalesce(Qt_Aporte_Hidrico_Diario_p,0) - coalesce(qt_Total_Volume_p,0)),qt_peso_p), 4);
            qt_Elem_KgDia_w := dividir_sem_round_md(ceil(qt_Elem_KgDia_w * 100),100);
            Qt_ElemKgDia_p  := coalesce(qt_Elem_KgDia_w, 0);

        elsif (Qt_Aporte_Hidrico_Diario_p < qt_Total_Volume_p) then

            qt_Elem_KgDia_w := qt_Elem_KgDia_p - round(dividir_sem_round_md((coalesce(qt_Total_Volume_p,0) - coalesce(Qt_Aporte_Hidrico_Diario_p,0)),qt_peso_p), 4);
            qt_Elem_KgDia_w := dividir_sem_round_md(ceil(qt_Elem_KgDia_w * 100),100);
            Qt_ElemKgDia_p  := coalesce(qt_Elem_KgDia_w,0);
        end if;
    else
        Qt_ElemKgDia_p    := dividir_sem_round_md(dividir_sem_round_md((ceil((coalesce(Qt_Aporte_Hidrico_Diario_p,0) - coalesce(qt_Total_Volume_p,0)) * 100)),100),qt_peso_p);
        Qt_Diaria_p       := dividir_sem_round_md(ceil((coalesce(Qt_Aporte_Hidrico_Diario_p,0) - coalesce(qt_Total_Volume_p,0)) * 100),100);
        Qt_Volume_Final_p := dividir_sem_round_md(ceil((coalesce(Qt_Aporte_Hidrico_Diario_p,0) - coalesce(qt_Total_Volume_p,0)) * 100),100);
    end if;

    if (Qt_ElemKgDia_p < 0) then
      Qt_ElemKgDia_p := 0;
    end if;

END;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE calc_elem_water_nutrition_md (is_Round_p text, Qt_Aporte_Hidrico_Diario_p bigint, qt_Total_Volume_p bigint, qt_peso_p bigint, qt_Elem_KgDia_p INOUT bigint, Qt_ElemKgDia_p INOUT bigint, Qt_Diaria_p INOUT bigint, Qt_Volume_Final_p INOUT bigint ) FROM PUBLIC;

