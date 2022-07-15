-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE calc_med_apresent_medic_md ( cd_materia_auxl_p INOUT bigint, cd_material_p bigint, qt_dose_aux_p INOUT bigint, qt_dose_p bigint, cd_unidade_medida_aux_p INOUT text, cd_unidade_medida_p text, ie_reg_nr_seq_fabric_aux_pp INOUT bigint, nr_seq_fabric_p INOUT bigint, qt_dose_total_aux_p INOUT bigint, ie_reg_p INOUT bigint, nr_tp_ret_p bigint ) AS $body$
BEGIN
    cd_materia_auxl_p := cd_material_p;
    qt_dose_aux_p := qt_dose_p;
    cd_unidade_medida_aux_p := cd_unidade_medida_p;
    IF ( nr_tp_ret_p = 1 ) THEN
        ie_reg_nr_seq_fabric_aux_pp := nr_seq_fabric_p;
    END IF;
    ie_reg_p := ie_reg_p + 1;
    qt_dose_total_aux_p := 0;
END;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE calc_med_apresent_medic_md ( cd_materia_auxl_p INOUT bigint, cd_material_p bigint, qt_dose_aux_p INOUT bigint, qt_dose_p bigint, cd_unidade_medida_aux_p INOUT text, cd_unidade_medida_p text, ie_reg_nr_seq_fabric_aux_pp INOUT bigint, nr_seq_fabric_p INOUT bigint, qt_dose_total_aux_p INOUT bigint, ie_reg_p INOUT bigint, nr_tp_ret_p bigint ) FROM PUBLIC;

