-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';




CREATE OR REPLACE PROCEDURE ger_npt_harris_benedi_md_pck.calcula_carb_npt_md (qt_kcal_carboidrato_p bigint, qt_formula_carb_p bigint, qt_conversao_ml_p bigint, cd_unid_medida_ori_p text, cd_unid_medida_dest_p text, cd_unid_med_cons_p text, qt_conversao_und_ori_p bigint, qt_conversao_und_dest_p bigint, qt_diaria_p INOUT bigint, qt_vol_diaria_p INOUT bigint, pr_conc_glic_solucao_p INOUT bigint, qt_dose_diaria_p INOUT bigint ) AS $body$
DECLARE

	   EXEC_W varchar(200);
	
BEGIN
		qt_diaria_p		          := dividir_sem_round_md(qt_kcal_carboidrato_p, qt_formula_carb_p);
		qt_vol_diaria_p         := qt_diaria_p * qt_conversao_ml_p;
		pr_conc_glic_solucao_p	:= dividir_sem_round_md(qt_kcal_carboidrato_p, qt_formula_carb_p);

    if (upper(cd_unid_medida_dest_p) = upper(cd_unid_medida_ori_p)) then
      qt_dose_diaria_p	:= qt_vol_diaria_p;
    elsif (cd_unid_medida_dest_p IS NOT NULL AND cd_unid_medida_dest_p::text <> '') then
      begin
        EXEC_W := 'CALL obter_dose_convertida_md(:1,:2,:3,:4,:5,:6) INTO :RESULT';

        EXECUTE EXEC_W USING IN qt_vol_diaria_p,
                                       IN cd_unid_medida_ori_p,
                                       IN cd_unid_medida_dest_p,
                                       IN cd_unid_med_cons_p,
                                       IN qt_conversao_und_ori_p,
                                       IN qt_conversao_und_dest_p,
                                       OUT qt_dose_diaria_p;
      exception
          when others then
            qt_dose_diaria_p := null;
      end;
    end if;
	end;


$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE ger_npt_harris_benedi_md_pck.calcula_carb_npt_md (qt_kcal_carboidrato_p bigint, qt_formula_carb_p bigint, qt_conversao_ml_p bigint, cd_unid_medida_ori_p text, cd_unid_medida_dest_p text, cd_unid_med_cons_p text, qt_conversao_und_ori_p bigint, qt_conversao_und_dest_p bigint, qt_diaria_p INOUT bigint, qt_vol_diaria_p INOUT bigint, pr_conc_glic_solucao_p INOUT bigint, qt_dose_diaria_p INOUT bigint ) FROM PUBLIC;
