-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION cpoe_obter_volume_total_rel ( cd_material_p bigint, qt_dose_p bigint, cd_unidade_medida_p text, cd_mat_dil_p bigint, qt_dose_dil_p bigint, cd_unid_med_dose_dil_p text, qt_volume_red_p bigint, cd_mat_red_p bigint, qt_dose_red_p bigint, cd_unid_med_dose_red_p text, cd_mat_comp1_p bigint, qt_dose_comp1_p bigint, cd_unid_med_dose_comp1_p text, cd_mat_comp2_p bigint, qt_dose_comp2_p bigint, cd_unid_med_dose_comp2_p text, cd_mat_comp3_p bigint, qt_dose_comp3_p bigint, cd_unid_med_dose_comp3_p text, cd_mat_comp4_p bigint, qt_dose_comp4_p bigint, cd_unid_med_dose_comp4_p text, cd_mat_comp5_p bigint, qt_dose_comp5_p bigint, cd_unid_med_dose_comp5_p text, cd_mat_comp6_p bigint, qt_dose_comp6_p bigint, cd_unid_med_dose_comp6_p text, qt_solucao_p bigint default null, cd_mat_comp7_p bigint default null, qt_dose_comp7_p bigint default null, cd_unid_med_dose_comp7_p text default null, nr_seq_mat_diluicao_p material_diluicao.nr_seq_interno%type default null) RETURNS varchar AS $body$
DECLARE


qt_dose_ml_w		cpoe_material.qt_dose%type;
qt_volume_total_w	cpoe_material.qt_solucao_total%type;
qt_solucao_w		varchar(20);
qt_volume_total_w2	varchar(255);

nr_casas_diluicao_w		bigint;
nr_casas_diluicao_cad_w parametro_medico.nr_casas_diluicao%type;
ie_diluir_inteiro_w		material_diluicao.ie_diluir_inteiro%type;
qt_volume_cad_w			material_diluicao.qt_volume%type;
qt_conversao_mat_w	 	material_conversao_unidade.qt_conversao%type;
qt_dose_dividida_w		double precision;
qt_dose_mat_w			double precision;
qt_volume_total_medic_w	double precision;
qt_conv_ml_w			cpoe_material.qt_dose%type;
qt_volume_medic_w		material_diluicao.qt_volume_medic%type;
ie_proporcao_w			material_diluicao.ie_proporcao%type;

function getVlAplcar return text is
;
BEGIN
	if (qt_solucao_w IS NOT NULL AND qt_solucao_w::text <> '') then
		return ' ' || obter_desc_expressao(303265, '') || ' ' || qt_solucao_w  || ' ' || obter_unid_med_usua('ml') ||',';
	else
		return ' ' || obter_desc_expressao(303265, '') || ' ' || qt_volume_total_w2  || ' ' || obter_unid_med_usua('ml') ||',';		
	end if;	
	
	return null;
end;

begin

-- Item principal
if (cd_material_p IS NOT NULL AND cd_material_p::text <> '') and (qt_dose_p IS NOT NULL AND qt_dose_p::text <> '') and (cd_unidade_medida_p <> obter_unid_med_usua('gts')) then

	select	coalesce(max(nr_casas_diluicao),0)
	into STRICT	nr_casas_diluicao_cad_w
	from	parametro_medico
	where	cd_estabelecimento = obter_estabelecimento_ativo;

	nr_casas_diluicao_w := nr_casas_diluicao_cad_w;	
	if (nr_casas_diluicao_w = 0) then
		nr_casas_diluicao_w := 3;
	end if;
	
	if (cd_unidade_medida_p <> obter_unid_med_usua('ml')) then
		qt_volume_total_w := obter_dose_convertida(cd_material_p, qt_dose_p, cd_unidade_medida_p, obter_unid_med_usua('ml'));
	else
		qt_volume_total_w := qt_dose_p;
	end if;	

	qt_volume_total_w := qt_volume_total_w + CPOE_Obter_volume_item_comp(	cd_mat_comp1_p,
																			qt_dose_comp1_p,
																			cd_unid_med_dose_comp1_p,
																			cd_mat_comp2_p,
																			qt_dose_comp2_p,
																			cd_unid_med_dose_comp2_p,
																			cd_mat_comp3_p,
																			qt_dose_comp3_p,
																			cd_unid_med_dose_comp3_p,
																			cd_mat_comp4_p,
																			qt_dose_comp4_p,
																			cd_unid_med_dose_comp4_p,
																			cd_mat_comp5_p,
																			qt_dose_comp5_p,
																			cd_unid_med_dose_comp5_p,
																			cd_mat_comp6_p,
																			qt_dose_comp6_p,
																			cd_unid_med_dose_comp6_p,
																			qt_solucao_p,
																			cd_mat_comp7_p,
																			qt_dose_comp7_p );

	-- Diluente
	if (cd_mat_dil_p IS NOT NULL AND cd_mat_dil_p::text <> '') and (qt_dose_dil_p > 0) then
		
		select max(b.ie_diluir_inteiro),
			   max(b.qt_volume),
			   max(b.qt_volume_medic),
			   max(b.ie_proporcao)
		  into STRICT ie_diluir_inteiro_w,
			   qt_volume_cad_w,
			   qt_volume_medic_w,
			   ie_proporcao_w
		  from material_diluicao b,
			   material a
		 where a.cd_material = b.cd_material
		   and b.nr_seq_interno = nr_seq_mat_diluicao_p
		   and a.cd_material = cd_material_p
		   and (cd_mat_dil_p IS NOT NULL AND cd_mat_dil_p::text <> '');
		
		if (ie_diluir_inteiro_w = 'S') then
			select coalesce(max(a.qt_conversao), 1)
			  into STRICT qt_conversao_mat_w
			  from material_conversao_unidade a
			 where a.cd_material = cd_material_p
			   and a.cd_unidade_medida = cd_unidade_medida_p;

			qt_conversao_mat_w := dividir(qt_dose_p, qt_conversao_mat_w);
			
			if (qt_conversao_mat_w <= 0) then
				qt_conversao_mat_w := 1;
			end if;
			qt_dose_dividida_w := qt_conversao_mat_w;
			
			qt_dose_mat_w := obter_dose_convertida(cd_material_p, ceil(qt_dose_dividida_w), obter_dados_material(cd_material_p,'UMC'), cd_unidade_medida_p);
			qt_conv_ml_w := obter_conversao_ml(cd_material_p, qt_dose_mat_w, cd_unidade_medida_p);
			qt_dose_ml_w := obter_conversao_ml(cd_mat_dil_p, qt_dose_dil_p, cd_unid_med_dose_dil_p);
			
			if (qt_volume_cad_w > 0) then
				qt_conv_ml_w := qt_dose_ml_w;
			end if;
			
			if (nr_casas_diluicao_w > 0) then
				qt_dose_ml_w := round((qt_dose_ml_w * qt_conversao_mat_w) / ceil(qt_dose_dividida_w), nr_casas_diluicao_w);
			else
				qt_dose_ml_w := ((qt_dose_ml_w * qt_conversao_mat_w) / ceil(qt_dose_dividida_w));
			end if;

		else		
			if (cd_unid_med_dose_dil_p <> obter_unid_med_usua('ml')) then
				qt_dose_ml_w := obter_dose_convertida(cd_mat_dil_p, qt_dose_dil_p, cd_unid_med_dose_dil_p, obter_unid_med_usua('ml'));
			else
				qt_dose_ml_w := qt_dose_dil_p;
			end if;	

			if ((coalesce(ie_proporcao_w, 'F') = 'F') and (coalesce(qt_volume_medic_w,0) > 0) and (nr_casas_diluicao_cad_w > 0)) then
				qt_volume_total_medic_w := qt_volume_medic_w;
			end if;
		end if;

		qt_volume_total_w := round(round(coalesce(qt_volume_total_medic_w,0), nr_casas_diluicao_w) + round(qt_volume_total_w, nr_casas_diluicao_w) + round(qt_dose_ml_w, nr_casas_diluicao_w), nr_casas_diluicao_w);
	else
		qt_volume_total_w := qt_volume_total_w + qt_volume_total_medic_w;
	end if;

	-- Rediluente
	if (cd_mat_red_p IS NOT NULL AND cd_mat_red_p::text <> '') and (qt_dose_red_p > 0) then
		if (coalesce(qt_volume_red_p,0) > 0) then
			qt_volume_total_w := qt_volume_red_p;
		end if;
		if (cd_unid_med_dose_red_p <> obter_unid_med_usua('ml')) then
			qt_dose_ml_w := obter_dose_convertida(cd_mat_red_p, qt_dose_red_p, cd_unid_med_dose_red_p, obter_unid_med_usua('ml'));
		else
			qt_dose_ml_w := qt_dose_red_p;
		end if;		
		qt_volume_total_w := qt_volume_total_w + qt_dose_ml_w;
	end if;
end if;


if (coalesce(qt_volume_total_w,0) > 0) then
	
		if (substr(qt_volume_total_w,1,1) = ',') then
			qt_volume_total_w2	:= '0' || to_char(qt_volume_total_w);
			qt_volume_total_w2	:= replace(qt_volume_total_w2,'.',',');			
		else
			qt_volume_total_w2 := qt_volume_total_w;
		end if;		
		
		qt_solucao_w := to_char(qt_solucao_p);
		if (substr(qt_solucao_w,1,1) = ',') then
			qt_solucao_w	:= '0' || to_char(qt_solucao_w);
			qt_solucao_w	:= replace(qt_solucao_w,'.',',');	
		end if;
	
	return obter_desc_expressao(302287, '')  || ' ' || qt_volume_total_w2 || ' '|| obter_unid_med_usua('ml') || ',' || getVlAplcar();
	
else
	return null;
end if;


end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION cpoe_obter_volume_total_rel ( cd_material_p bigint, qt_dose_p bigint, cd_unidade_medida_p text, cd_mat_dil_p bigint, qt_dose_dil_p bigint, cd_unid_med_dose_dil_p text, qt_volume_red_p bigint, cd_mat_red_p bigint, qt_dose_red_p bigint, cd_unid_med_dose_red_p text, cd_mat_comp1_p bigint, qt_dose_comp1_p bigint, cd_unid_med_dose_comp1_p text, cd_mat_comp2_p bigint, qt_dose_comp2_p bigint, cd_unid_med_dose_comp2_p text, cd_mat_comp3_p bigint, qt_dose_comp3_p bigint, cd_unid_med_dose_comp3_p text, cd_mat_comp4_p bigint, qt_dose_comp4_p bigint, cd_unid_med_dose_comp4_p text, cd_mat_comp5_p bigint, qt_dose_comp5_p bigint, cd_unid_med_dose_comp5_p text, cd_mat_comp6_p bigint, qt_dose_comp6_p bigint, cd_unid_med_dose_comp6_p text, qt_solucao_p bigint default null, cd_mat_comp7_p bigint default null, qt_dose_comp7_p bigint default null, cd_unid_med_dose_comp7_p text default null, nr_seq_mat_diluicao_p material_diluicao.nr_seq_interno%type default null) FROM PUBLIC;
