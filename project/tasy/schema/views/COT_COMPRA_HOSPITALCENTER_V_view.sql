-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';

CREATE OR REPLACE VIEW cot_compra_hospitalcenter_v (cd_material, qt_material, nr_cot_compra, dt_entregas) AS select	a.cd_material,
	a.qt_material,
	a.nr_cot_compra,
	substr(substr(obter_select_concatenado_bv('
		select	to_char(dt_entrega,' || chr(39) || 'dd/mm/yyyy' || chr(39) || ') || chr(59) ||  qt_entrega
		from	cot_compra_item_entrega
		where	nr_cot_compra = :nr_cot_compra
		and	nr_item_cot_compra = :nr_item',
		'nr_cot_compra='|| a.nr_cot_compra || ';' ||
		'nr_item=' || a.nr_item_cot_compra || ';',';'),1,2000),1,2000)  dt_entregas
FROM	cot_compra_item a;

