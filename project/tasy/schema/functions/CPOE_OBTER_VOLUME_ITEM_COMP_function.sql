-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION cpoe_obter_volume_item_comp ( cd_mat_comp1_p bigint, qt_dose_comp1_p bigint, cd_unid_med_dose_comp1_p text, cd_mat_comp2_p bigint, qt_dose_comp2_p bigint, cd_unid_med_dose_comp2_p text, cd_mat_comp3_p bigint, qt_dose_comp3_p bigint, cd_unid_med_dose_comp3_p text, cd_mat_comp4_p bigint, qt_dose_comp4_p bigint, cd_unid_med_dose_comp4_p text, cd_mat_comp5_p bigint, qt_dose_comp5_p bigint, cd_unid_med_dose_comp5_p text, cd_mat_comp6_p bigint, qt_dose_comp6_p bigint, cd_unid_med_dose_comp6_p text, cd_mat_comp7_p bigint, qt_dose_comp7_p bigint, cd_unid_med_dose_comp7_p text, nr_sequencia_p bigint default null) RETURNS bigint AS $body$
DECLARE


	c01 CURSOR FOR
	SELECT  distinct a.cd_material,
			a.qt_dose,
			a.cd_unidade_medida
	from    cpoe_material_add_comp a
	where   a.nr_seq_cpoe_material = nr_sequencia_p;

	qt_volume_total_w  double precision := 0;
	cd_unid_med_usua_w varchar(30);

	procedure obter_dados_dose_convertida(
						cd_unid_med_usua_p      in text,
						cd_unidade_medida_p     in text,
						cd_material_p           in bigint,
						cd_unid_med_cons_p      out text,
						qt_conversao_und_ori_p  out bigint,
						qt_conversao_und_dest_p out bigint) is
	;
BEGIN
	begin
		select	coalesce(a.cd_unidade_medida_consumo, b.cd_unidade_medida_consumo)
		into STRICT	cd_unid_med_cons_p
		from	material_estab a, material b
		where	b.cd_material = a.cd_material
		and		a.cd_material = cd_material_p
		and		a.cd_estabelecimento = wheb_usuario_pck.get_cd_estabelecimento;
	exception
		when others then
			begin
				select	cd_unidade_medida_consumo
				into STRICT	cd_unid_med_cons_p
				from	material
				where	cd_material = cd_material_p;
			exception
				when others then
					null;
			end;
	end;

	begin
		select	coalesce(max(qt_conversao), 0)
		into STRICT	qt_conversao_und_ori_p
		from	material_conversao_unidade
		where	upper(cd_unidade_medida) = upper(cd_unid_med_usua_p)
		and		cd_material = cd_material_p;
	exception
		when others then
			qt_conversao_und_ori_p := null;
	end;

	begin
		select	coalesce(max(qt_conversao), 0)
		into STRICT	qt_conversao_und_dest_p
		from	material_conversao_unidade
		where	upper(cd_unidade_medida) = upper(cd_unidade_medida_p)
		and		cd_material = cd_material_p;
	exception
		when others then
			qt_conversao_und_dest_p := null;
	end;
	end;

	procedure adicionardose(
					cd_material_p number,
					qt_dose_p     number,
					cd_unid_med_p varchar2) is
  
    cd_unid_med_cons_w      varchar2(30);
    qt_conversao_und_ori_w  number(18, 6);
    qt_conversao_und_dest_w number(18, 6);
    exec_w                  varchar2(4000);

    qt_dose_w number(18, 6);

	begin
	obter_dados_dose_convertida(cd_unid_med_p,cd_unid_med_usua_w, cd_material_p, cd_unid_med_cons_w, qt_conversao_und_ori_w, qt_conversao_und_dest_w);
	begin
		exec_w := 'call obter_dose_convertida_md(:1,:2,:3,:4,:5,:6) into :result';
		EXECUTE exec_w using in qt_dose_p,
									   in cd_unid_med_p, 
									   in cd_unid_med_usua_w, 
									   in cd_unid_med_cons_w, 
									   in qt_conversao_und_ori_w, 
									   in qt_conversao_und_dest_w, 
									   out qt_dose_w;
	exception
		when others then
		qt_dose_w := null;
	end;

	begin
		exec_w := 'begin obter_dose_volume_cpoe_md(:1, :2, :3, :4, :5, :6); end;';
		EXECUTE exec_w using in cd_material_p,
									   in qt_dose_p, 
									   in cd_unid_med_p, 
									   in cd_unid_med_usua_w, 
									   in qt_dose_w, 
									   in out qt_volume_total_w;
	exception
		when others then
			qt_volume_total_w := null;
	end;
	end;

begin
  cd_unid_med_usua_w  := obter_unid_med_usua('ml');

  adicionarDose(cd_mat_comp1_p, qt_dose_comp1_p, cd_unid_med_dose_comp1_p);
  adicionarDose(cd_mat_comp2_p, qt_dose_comp2_p, cd_unid_med_dose_comp2_p);
  adicionarDose(cd_mat_comp3_p, qt_dose_comp3_p, cd_unid_med_dose_comp3_p);
  adicionarDose(cd_mat_comp4_p, qt_dose_comp4_p, cd_unid_med_dose_comp4_p);
  adicionarDose(cd_mat_comp5_p, qt_dose_comp5_p, cd_unid_med_dose_comp5_p);
  adicionarDose(cd_mat_comp6_p, qt_dose_comp6_p, cd_unid_med_dose_comp6_p);
  adicionarDose(cd_mat_comp7_p, qt_dose_comp7_p, cd_unid_med_dose_comp7_p);

  for c01_w in c01 loop
    adicionarDose(c01_w.cd_material, c01_w.qt_dose, c01_w.cd_unidade_medida);
  end loop;

  return  qt_volume_total_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION cpoe_obter_volume_item_comp ( cd_mat_comp1_p bigint, qt_dose_comp1_p bigint, cd_unid_med_dose_comp1_p text, cd_mat_comp2_p bigint, qt_dose_comp2_p bigint, cd_unid_med_dose_comp2_p text, cd_mat_comp3_p bigint, qt_dose_comp3_p bigint, cd_unid_med_dose_comp3_p text, cd_mat_comp4_p bigint, qt_dose_comp4_p bigint, cd_unid_med_dose_comp4_p text, cd_mat_comp5_p bigint, qt_dose_comp5_p bigint, cd_unid_med_dose_comp5_p text, cd_mat_comp6_p bigint, qt_dose_comp6_p bigint, cd_unid_med_dose_comp6_p text, cd_mat_comp7_p bigint, qt_dose_comp7_p bigint, cd_unid_med_dose_comp7_p text, nr_sequencia_p bigint default null) FROM PUBLIC;

