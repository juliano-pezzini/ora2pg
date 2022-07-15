-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE obter_lipid_neonatal_act_md (Qt_Kcal_Lipid_p bigint, qt_total_Volume_p bigint, qt_Kcal_Lip_p INOUT bigint, qt_Vol_Lip INOUT bigint ) AS $body$
BEGIN
    qt_Kcal_Lip_p := coalesce(qt_Kcal_Lip_p,0) + coalesce(Qt_Kcal_Lipid_p,0);
    qt_Vol_Lip    := coalesce(qt_Vol_Lip,0)    + coalesce(qt_total_Volume_p,0);

END;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE obter_lipid_neonatal_act_md (Qt_Kcal_Lipid_p bigint, qt_total_Volume_p bigint, qt_Kcal_Lip_p INOUT bigint, qt_Vol_Lip INOUT bigint ) FROM PUBLIC;

