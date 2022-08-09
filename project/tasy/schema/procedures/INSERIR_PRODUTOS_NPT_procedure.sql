-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE inserir_produtos_npt ( nr_sequencia_p bigint, nr_seq_mat_p bigint, nm_usuario_p text) AS $body$
DECLARE


cd_material_w			protocolo_npt_prod.cd_material%type;
qt_volume_w				protocolo_npt_prod.qt_volume%type;
qt_dose_w				protocolo_npt_prod.qt_dose%type;
cd_unidade_medida_w		protocolo_npt_prod.cd_unidade_medida%type;
ie_prod_adicional_w		protocolo_npt_prod.ie_prod_adicional%type;
ie_somar_volume_w		protocolo_npt_prod.ie_somar_volume%type;
nr_seq_protocolo_w		protocolo_npt_prod.nr_seq_protocolo%type;
nr_seq_elemento_w		protocolo_npt_item.nr_seq_elemento%type;
qt_elemento_w			protocolo_npt_item.qt_elemento%type;
ie_prim_fase_w			protocolo_npt_item.ie_prim_fase%type;
ie_seg_fase_w			protocolo_npt_item.ie_seg_fase%type;
ie_terc_fase_w			protocolo_npt_item.ie_terc_fase%type;
ie_quar_fase_w			protocolo_npt_item.ie_quar_fase%type;
qt_osmolaridade_w		protocolo_npt_item.qt_osmolaridade%type;


BEGIN

select	max(cd_material),
		max(cd_unidade_medida),
		max(ie_prod_adicional),
		coalesce(max(ie_somar_volume),'S'),
		max(qt_dose),
		max(qt_volume),
		max(nr_seq_protocolo)
into STRICT	cd_material_w,
		cd_unidade_medida_w,
		ie_prod_adicional_w,
		ie_somar_volume_w,
		qt_dose_w,
		qt_volume_w,
		nr_seq_protocolo_w
from	protocolo_npt_prod
where	nr_sequencia = nr_seq_mat_p;


insert into nut_pac_elem_mat(
			nr_sequencia,
			nr_seq_nut_pac,
			cd_material,
			qt_volume,
			qt_protocolo,
			qt_dose,
			cd_unidade_medida,
			ie_prod_adicional,
			ie_somar_volume,
			dt_atualizacao,
			nm_usuario)
		values (
			nextval('nut_pac_elem_mat_seq'),
			nr_sequencia_p,
			cd_material_w,
			qt_volume_w,
			qt_volume_w,
			qt_dose_w,
			cd_unidade_medida_w,
			ie_prod_adicional_w,
			ie_somar_volume_w,
			clock_timestamp(),
			nm_usuario_p);

select	coalesce(max(a.nr_seq_elemento),0),
		max(a.cd_unidade_medida),
		max(a.qt_elemento),
		coalesce(max(a.ie_prim_fase),'N'),
		coalesce(max(a.ie_seg_fase),'N'),
		coalesce(max(a.ie_terc_fase),'N'),
		coalesce(max(a.ie_quar_fase),'N'),
		max(a.qt_osmolaridade),
		max(a.ie_prod_adicional)
into STRICT	nr_seq_elemento_w,
		cd_unidade_medida_w,
		qt_elemento_w,
		ie_prim_fase_w,
		ie_seg_fase_w,
		ie_terc_fase_w,
		ie_quar_fase_w,
		qt_osmolaridade_w,
		ie_prod_adicional_w
from	protocolo_npt_item a,
		nut_elem_material b
where	a.nr_seq_elemento = b.nr_seq_elemento
and		b.cd_material = cd_material_w
and		a.nr_seq_protocolo = nr_seq_protocolo_w
and		coalesce(a.ie_prod_adicional,'N') = 'S';

if (nr_seq_elemento_w > 0) then
	insert into nut_pac_elemento(
				nr_sequencia,
				nr_seq_nut_pac,
				nr_seq_elemento,
				dt_atualizacao,
				nm_usuario,
				cd_unidade_medida,
				qt_elem_kg_dia,
				qt_diaria,
				pr_total,
				qt_kcal,
				ie_prim_fase,
				ie_seg_fase,
				ie_terc_fase,
				ie_quar_fase,
				ie_npt,
				dt_atualizacao_nrec,
				nm_usuario_nrec,
				qt_osmolaridade,
				qt_protocolo,
				ie_prod_adicional)
			values (
				nextval('nut_pac_elemento_seq'),
				nr_sequencia_p,
				nr_seq_elemento_w,
				clock_timestamp(),
				nm_usuario_p,
				cd_unidade_medida_w,
				0,
				qt_elemento_w,
				0,
				0,
				ie_prim_fase_w,
				ie_seg_fase_w,
				ie_terc_fase_w,
				ie_quar_fase_w,
				'S',
				clock_timestamp(),
				nm_usuario_p,
				qt_osmolaridade_w,
				qt_elemento_w,
				ie_prod_adicional_w);
end if;

commit;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE inserir_produtos_npt ( nr_sequencia_p bigint, nr_seq_mat_p bigint, nm_usuario_p text) FROM PUBLIC;
