-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';




CREATE OR REPLACE PROCEDURE nutrition_intake_manager_pck.set_global_totals () AS $body$
BEGIN
	
		CALL nutrition_intake_manager_pck.init_record();
		
		r_basic_nutrition_item_w.nr_seq_cpoe        := '';
		r_basic_nutrition_item_w.ds_item			:= upper(obter_desc_expressao(307637));
		r_basic_nutrition_item_w.qt_duracao			:= '';
		r_basic_nutrition_item_w.qt_vezes			:= '';
		r_basic_nutrition_item_w.qt_volume			:= qt_volume_geral_w;
		r_basic_nutrition_item_w.qt_volume_kg       := qt_volume_kg_geral_w;
		r_basic_nutrition_item_w.qt_caloria			:= qt_caloria_geral_w;
		r_basic_nutrition_item_w.qt_caloria_kg      := qt_caloria_kg_geral_w;
		r_basic_nutrition_item_w.qt_carboidrato		:= qt_carboidrato_geral_w;
		r_basic_nutrition_item_w.qt_carboidrato_kg  := qt_carboidrato_kg_geral_w;
		r_basic_nutrition_item_w.qt_proteina		:= qt_proteina_geral_w;
		r_basic_nutrition_item_w.qt_proteina_kg     := qt_proteina_kg_geral_w;
		r_basic_nutrition_item_w.qt_gordura			:= qt_gordura_geral_w;
		r_basic_nutrition_item_w.qt_gordura_kg      := qt_gordura_kg_geral_w;
		r_basic_nutrition_item_w.qt_fosforo         := qt_fosforo_geral_w;
		r_basic_nutrition_item_w.qt_fosforo_kg      := qt_fosforo_kg_geral_w;
		r_basic_nutrition_item_w.qt_calcio          := qt_calcio_geral_w;
		r_basic_nutrition_item_w.qt_calcio_kg       := qt_calcio_kg_geral_w;
		r_basic_nutrition_item_w.qt_magnesio        := qt_magnesio_geral_w;
		r_basic_nutrition_item_w.qt_magnesio_kg     := qt_magnesio_kg_geral_w;
		r_basic_nutrition_item_w.qt_sodio           := qt_sodio_geral_w;
		r_basic_nutrition_item_w.qt_sodio_kg        := qt_sodio_kg_geral_w;
		r_basic_nutrition_item_w.qt_potassio        := qt_potassio_geral_w;
		r_basic_nutrition_item_w.qt_potassio_kg     := qt_potassio_kg_geral_w;
		r_basic_nutrition_item_w.qt_cloreto         := qt_cloreto_geral_w;
		r_basic_nutrition_item_w.qt_cloreto_kg      := qt_cloreto_kg_geral_w;
		r_basic_nutrition_item_w.ie_editado         := 'N';
		r_basic_nutrition_item_w.ie_preview         := 'N';

		r_basic_nutrition_item_w.ie_totalizador     := 'S';
		r_basic_nutrition_item_w.ie_tipo_item       := 'TG';
		r_basic_nutrition_item_w.nm_tabela          := '';

	end;


$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE nutrition_intake_manager_pck.set_global_totals () FROM PUBLIC;
