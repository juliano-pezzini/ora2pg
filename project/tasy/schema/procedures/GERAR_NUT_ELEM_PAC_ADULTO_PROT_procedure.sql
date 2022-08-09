-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE gerar_nut_elem_pac_adulto_prot ( nr_sequencia_p bigint, nm_usuario_p text) AS $body$
DECLARE




nr_seq_protocolo_w			bigint;
nr_seq_elemento_w			bigint;
cd_unidade_medida_w			varchar(30);
qt_elemento_w				double precision;
ie_prim_fase_w				varchar(1);
ie_seg_fase_w				varchar(1);
ie_terc_fase_w				varchar(1);
ie_quar_fase_w				varchar(1);
qt_rel_kcal_n_w				double precision;
qt_vl_cal_n_prot_w			double precision;
ie_via_administracao_w		varchar(1);
qt_osmolaridade_teorica_w	double precision;
qt_osmolaridade_w			double precision;
nr_seq_elem_mat_w			bigint;
nr_seq_elem_prescr_w		bigint;
cd_material_w				integer;
nr_seq_nut_elem_mat_w		bigint;
qt_volume_w					double precision;
qt_vol_1_fase_w				double precision;
qt_vol_2_fase_w				double precision;
qt_vol_3_fase_w				double precision;
qt_vol_4_fase_w				double precision;
ie_permite_alterar_w		varchar(1);
ie_suplementacao_w			varchar(1);
ie_prod_adicional_w			varchar(1);
ie_somar_volume_w			varchar(1);
qt_dose_w					double precision;
qt_elem_mat_w				bigint;
ie_novo_produto_w			varchar(1);
nr_seq_nut_elem_mat_ww		nut_elem_material.nr_sequencia%type;

C01 CURSOR FOR
SELECT	nr_seq_elemento,
		cd_unidade_medida,
		qt_elemento,
		coalesce(ie_prim_fase,'N'),
		coalesce(ie_seg_fase,'N'),
		coalesce(ie_terc_fase,'N'),
		coalesce(ie_quar_fase,'N'),
		qt_osmolaridade,
		ie_prod_adicional
from	protocolo_npt_item
where	nr_seq_protocolo = nr_seq_protocolo_w
and		((ie_novo_produto_w = 'S') or (coalesce(ie_prod_adicional,'N') = 'N'))
order by
		coalesce(nr_seq_apres,999);

C02 CURSOR FOR
SELECT	nr_seq_elem_mat,
		cd_material,
		qt_volume,
		qt_vol_1_fase,
		qt_vol_2_fase,
		qt_vol_3_fase,
		qt_vol_4_fase,
		qt_dose,
		cd_unidade_medida,
		ie_prod_adicional,
		coalesce(ie_somar_volume,'S')
from	protocolo_npt_prod
where	nr_seq_protocolo = nr_seq_protocolo_w
and		((coalesce(ie_novo_produto_w,'N') = 'S') or (coalesce(ie_prod_adicional,'N') = 'N'))
order by
		coalesce(nr_seq_apresentacao,999);


BEGIN

ie_novo_produto_w := Obter_Param_Usuario(924, 1167, obter_perfil_ativo, nm_usuario_p, 0, ie_novo_produto_w);

select	nr_seq_protocolo
into STRICT	nr_seq_protocolo_w
from	nut_pac
where	nr_sequencia	= nr_sequencia_p;

if (coalesce(nr_seq_protocolo_w::text, '') = '') then
	CALL Wheb_mensagem_pck.exibir_mensagem_abort(268085);
end if;

select	qt_volume,
		qt_rel_kcal_n,
		qt_vl_cal_n_prot,
		ie_via_administracao,
		qt_osmolaridade,
		ie_permite_alteracao,
		coalesce(ie_suplementacao,'N')
into STRICT	qt_volume_w,
		qt_rel_kcal_n_w,
		qt_vl_cal_n_prot_w,
		ie_via_administracao_w,
		qt_osmolaridade_teorica_w,
		ie_permite_alterar_w,
		ie_suplementacao_w
from	protocolo_npt
where	nr_sequencia	= nr_seq_protocolo_w;

update	nut_pac
set		qt_volume_diario		= qt_volume_w,
		qt_rel_cal_nit			= qt_rel_kcal_n_w,
		qt_kcal_nao_proteico	= qt_vl_cal_n_prot_w,
		ie_via_administracao	= ie_via_administracao_w,
		qt_osmolaridade_total	= qt_osmolaridade_teorica_w,
		ie_permite_alteracao	= ie_permite_alterar_w,
		ie_suplementacao		= ie_suplementacao_w
where	nr_sequencia		= nr_sequencia_p;

open C01;
loop
	fetch C01 into
			nr_seq_elemento_w,
			cd_unidade_medida_w,
			qt_elemento_w,
			ie_prim_fase_w,
			ie_seg_fase_w,
			ie_terc_fase_w,
			ie_quar_fase_w,
			qt_osmolaridade_w,
			ie_prod_adicional_w;
	EXIT WHEN NOT FOUND; /* apply on C01 */
		begin

		select	nextval('nut_pac_elemento_seq')
		into STRICT	nr_seq_elem_prescr_w
		;

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
			nr_seq_elem_prescr_w,
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

		end;
end Loop;
close C01;

select	count(*)
into STRICT	qt_elemento_w
from	nut_pac_elemento
where	nr_seq_nut_pac	= nr_sequencia_p;

select	count(*)
into STRICT	qt_elem_mat_w
from	nut_pac_elem_mat
where	nr_seq_nut_pac = nr_sequencia_p;

if (qt_elem_mat_w = 0) or
	(qt_elem_mat_w = 0 AND qt_elemento_w = 0) then
	open C02;
	loop
	fetch C02 into
		nr_seq_elem_mat_w,
		cd_material_w,
		qt_volume_w,
		qt_vol_1_fase_w,
		qt_vol_2_fase_w,
		qt_vol_3_fase_w,
		qt_vol_4_fase_w,
		qt_dose_w,
		cd_unidade_medida_w,
		ie_prod_adicional_w,
		ie_somar_volume_w;
	EXIT WHEN NOT FOUND; /* apply on C02 */
		begin

		select	nextval('nut_pac_elem_mat_seq')
		into STRICT	nr_seq_nut_elem_mat_w
		;

		select	max(nr_sequencia)
		into STRICT	nr_seq_nut_elem_mat_ww
		from 	nut_elem_material
		where	cd_material	= cd_material_w;

		insert into nut_pac_elem_mat(
				nr_sequencia,
				nr_seq_nut_pac,
				dt_atualizacao,
				nm_usuario,
				nr_seq_elem_mat,
				cd_material,
				qt_volume,
				qt_vol_1_fase,
				qt_vol_2_fase,
				qt_vol_3_fase,
				qt_vol_4_fase,
				qt_protocolo,
				qt_dose,
				cd_unidade_medida,
				ie_prod_adicional,
				ie_somar_volume)
			values (
				nr_seq_nut_elem_mat_w,
				nr_sequencia_p,
				clock_timestamp(),
				nm_usuario_p,
				nr_seq_nut_elem_mat_ww,
				cd_material_w,
				qt_volume_w,
				qt_vol_1_fase_w,
				qt_vol_2_fase_w,
				qt_vol_3_fase_w,
				qt_vol_4_fase_w,
				qt_volume_w,
				qt_dose_w,
				cd_unidade_medida_w,
				ie_prod_adicional_w,
				ie_somar_volume_w);

		end;
	end Loop;
	close C02;
end if;

commit;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE gerar_nut_elem_pac_adulto_prot ( nr_sequencia_p bigint, nm_usuario_p text) FROM PUBLIC;
