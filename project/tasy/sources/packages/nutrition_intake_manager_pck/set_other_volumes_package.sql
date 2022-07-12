-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';




CREATE OR REPLACE PROCEDURE nutrition_intake_manager_pck.set_other_volumes () AS $body$
BEGIN

		CALL nutrition_intake_manager_pck.init_record();
	
		r_basic_nutrition_item_w.nr_seq_cpoe        := '';
		r_basic_nutrition_item_w.ds_item			:= upper(obter_desc_expressao(1014150));
		r_basic_nutrition_item_w.qt_duracao			:= '';
		r_basic_nutrition_item_w.qt_vezes			:= '';
		r_basic_nutrition_item_w.qt_volume			:= '';
		r_basic_nutrition_item_w.qt_volume_kg       := '';
		r_basic_nutrition_item_w.qt_caloria			:= '';
		r_basic_nutrition_item_w.qt_caloria_kg      := '';
		r_basic_nutrition_item_w.qt_carboidrato		:= '';
		r_basic_nutrition_item_w.qt_carboidrato_kg  := '';
		r_basic_nutrition_item_w.qt_proteina		:= '';
		r_basic_nutrition_item_w.qt_proteina_kg     := '';
		r_basic_nutrition_item_w.qt_gordura			:= '';
		r_basic_nutrition_item_w.qt_gordura_kg      := '';
		r_basic_nutrition_item_w.qt_fosforo         := '';
		r_basic_nutrition_item_w.qt_fosforo_kg      := '';
		r_basic_nutrition_item_w.qt_calcio          := '';
		r_basic_nutrition_item_w.qt_calcio_kg       := '';
		r_basic_nutrition_item_w.qt_magnesio        := '';
		r_basic_nutrition_item_w.qt_magnesio_kg     := '';
		r_basic_nutrition_item_w.qt_sodio           := '';
		r_basic_nutrition_item_w.qt_sodio_kg        := '';
		r_basic_nutrition_item_w.qt_potassio        := '';
		r_basic_nutrition_item_w.qt_potassio_kg     := '';
		r_basic_nutrition_item_w.qt_cloreto         := '';
		r_basic_nutrition_item_w.qt_cloreto_kg      := '';
		r_basic_nutrition_item_w.ie_editado         := 'N';
		r_basic_nutrition_item_w.ie_preview         := 'N';

		r_basic_nutrition_item_w.ie_totalizador     := 'N';
		r_basic_nutrition_item_w.ie_tipo_item       := 'ON';
		r_basic_nutrition_item_w.nm_tabela          := '';

	end;


$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE nutrition_intake_manager_pck.set_other_volumes () FROM PUBLIC;
