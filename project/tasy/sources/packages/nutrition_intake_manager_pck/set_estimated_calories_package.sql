-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';




CREATE OR REPLACE PROCEDURE nutrition_intake_manager_pck.set_estimated_calories () AS $body$
BEGIN

		r_nutrition_energy_w.qt_carboidrato :=  qt_carboidrato_geral_w * 4;
		r_nutrition_energy_w.qt_gordura := qt_gordura_geral_w * 9;
		r_nutrition_energy_w.qt_proteina := qt_proteina_geral_w * 4;

		r_nutrition_energy_w.qt_total_energia := r_nutrition_energy_w.qt_carboidrato + r_nutrition_energy_w.qt_gordura + r_nutrition_energy_w.qt_proteina;
		
		CALL nutrition_intake_manager_pck.init_record();

		r_basic_nutrition_item_w.nr_seq_cpoe        := '';
		r_basic_nutrition_item_w.ds_item			:= upper(obter_desc_expressao(1007090));
		r_basic_nutrition_item_w.qt_duracao			:= '';
		r_basic_nutrition_item_w.qt_vezes			:= '';
		r_basic_nutrition_item_w.qt_volume			:= '';
		r_basic_nutrition_item_w.qt_volume_kg       := '';
		r_basic_nutrition_item_w.qt_caloria			:= '';
		r_basic_nutrition_item_w.qt_caloria_kg      := '';
		r_basic_nutrition_item_w.qt_carboidrato     := 0;
		r_basic_nutrition_item_w.qt_carboidrato_kg  := 0;
		r_basic_nutrition_item_w.qt_proteina        := 0;
		r_basic_nutrition_item_w.qt_proteina_kg     := 0;
		r_basic_nutrition_item_w.qt_gordura         := 0;
		r_basic_nutrition_item_w.qt_gordura_kg      := 0;
		r_basic_nutrition_item_w.ie_editado         := 'N';
		r_basic_nutrition_item_w.ie_preview         := 'N';

		if (coalesce(r_nutrition_energy_w.qt_carboidrato, 0) > 0) then
			r_basic_nutrition_item_w.qt_carboidrato := (r_nutrition_energy_w.qt_carboidrato / r_nutrition_energy_w.qt_total_energia) * 100;
		end if;

		if (coalesce(r_nutrition_energy_w.qt_proteina, 0) > 0) then
			r_basic_nutrition_item_w.qt_proteina := (r_nutrition_energy_w.qt_proteina / r_nutrition_energy_w.qt_total_energia) * 100;
		end if;

		if (coalesce(r_nutrition_energy_w.qt_gordura, 0) > 0) then
			r_basic_nutrition_item_w.qt_gordura := (r_nutrition_energy_w.qt_gordura / r_nutrition_energy_w.qt_total_energia) * 100;
		end if;

		r_basic_nutrition_item_w.ie_totalizador	:= 'N';
		r_basic_nutrition_item_w.ie_tipo_item   := 'CE';
		r_basic_nutrition_item_w.nm_tabela      := '';
	end;


$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE nutrition_intake_manager_pck.set_estimated_calories () FROM PUBLIC;