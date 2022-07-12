-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';




CREATE OR REPLACE FUNCTION cpoe_obter_dados_vol_md_pck.obter_qt_dose_ml_md ( ie_diluir_inteiro_p text, nr_casas_diluicao_p bigint, qt_dose_p bigint, qt_conversao_mat_p bigint, qt_dose_dividida_p bigint, cd_unid_med_dose_dil_p text, cd_unid_med_usua_p text, cd_unid_med_cons_p text, qt_conversao_und_ori_p bigint, qt_conversao_und_dest_p bigint) RETURNS bigint AS $body$
DECLARE

		exec_w       varchar(4000);
		qt_dose_ml_w double precision;
	
BEGIN
		if (ie_diluir_inteiro_p = 'S') then
			if (nr_casas_diluicao_p > 0) then
				qt_dose_ml_w := round(dividir_sem_round_md((qt_dose_p * qt_conversao_mat_p),ceil(qt_dose_dividida_p)), nr_casas_diluicao_p);
			else
				qt_dose_ml_w := dividir_sem_round_md((qt_dose_p * qt_conversao_mat_p),ceil(qt_dose_dividida_p));
			end if;
		else
			if (upper(cd_unid_med_dose_dil_p) <> upper(cd_unid_med_usua_p)) then
				begin
					exec_w := 'call obter_dose_convertida_md(:1,:2,:3,:4,:5,:6) into :result';

					EXECUTE exec_w using in qt_dose_p,
                                         in cd_unid_med_dose_dil_p,
                                         in cd_unid_med_usua_p,
                                         in cd_unid_med_cons_p,
                                         in qt_conversao_und_ori_p,
                                         in qt_conversao_und_dest_p,
                                         out qt_dose_ml_w;
				exception
					when others then
						qt_dose_ml_w := null;
				end;
			else
				qt_dose_ml_w := qt_dose_p;
			end if;
		end if;

		return qt_dose_ml_w;
	end;


$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION cpoe_obter_dados_vol_md_pck.obter_qt_dose_ml_md ( ie_diluir_inteiro_p text, nr_casas_diluicao_p bigint, qt_dose_p bigint, qt_conversao_mat_p bigint, qt_dose_dividida_p bigint, cd_unid_med_dose_dil_p text, cd_unid_med_usua_p text, cd_unid_med_cons_p text, qt_conversao_und_ori_p bigint, qt_conversao_und_dest_p bigint) FROM PUBLIC;