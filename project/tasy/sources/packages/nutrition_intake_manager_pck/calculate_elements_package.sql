-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';




CREATE OR REPLACE PROCEDURE nutrition_intake_manager_pck.calculate_elements ( cd_material_p bigint, qt_volume_p bigint, qt_vezes_p bigint, cd_unid_med_p text, ie_tipo_elem_p text, cd_unid_med_elem_p text, ie_sem_volme_p text, qt_fator_conv_prod_p bigint, qt_fator_conv_elem_p bigint, cd_unid_med_conv_p text, qt_conversao_p bigint) AS $body$
BEGIN

		qt_volume_w := 0;
		qt_fator_conv_prod_w := 0;
		qt_fator_conv_elem_w := 0;

		if ((coalesce(ie_sem_volme_p, 'N') = 'N')
			and (coalesce(qt_volume_p, 0) > 0)
			and (coalesce(qt_fator_conv_prod_p, 0) > 0)
			and (coalesce(qt_fator_conv_elem_p, 0) > 0)) then

			if (ie_dose_diferenciada_w = 'N') then
				qt_volume_w := qt_volume_p * coalesce(qt_vezes_p, 1);
			else
				qt_volume_w := qt_volume_p;
			end if;

			qt_fator_conv_prod_w := qt_fator_conv_prod_p;
			qt_fator_conv_elem_w := qt_fator_conv_elem_p;

		elsif ((coalesce(ie_sem_volme_p, 'N') = 'S')
			and (coalesce(qt_volume_p, 0) > 0)
			and (coalesce(cd_unid_med_conv_p, 'XPTO') > 'XPTO')
			and (coalesce(qt_conversao_p, 0) > 0)
			and (coalesce(qt_fator_conv_elem_p, 0) > 0)) then

			select  obter_dose_convertida(cd_material_p, qt_volume_p, cd_unid_med_p, cd_unid_med_conv_p)
			into STRICT    qt_volume_w
			;

			if (ie_dose_diferenciada_w = 'N') then
			qt_volume_w := qt_volume_w * coalesce(qt_vezes_p, 1);
			end if;

			qt_fator_conv_prod_w := qt_conversao_p;
			qt_fator_conv_elem_w := qt_fator_conv_elem_p;

		end if;

		if ((qt_volume_w > 0)
			and (qt_fator_conv_prod_w > 0)
			and (qt_fator_conv_elem_w > 0)) then

			if (ie_tipo_elem_p = 'P') then

				if ((coalesce(cd_unid_med_prot_w, 'XPTO') = 'XPTO') or (cd_unid_med_prot_w = cd_unid_med_elem_p)) then

					if (coalesce(cd_unid_med_prot_w, 'XPTO') = 'XPTO') then

						cd_unid_med_prot_w := cd_unid_med_elem_p;
						r_basic_nutrition_item_w.cd_unid_med_prot := cd_unid_med_prot_w;
					end if;

					r_basic_nutrition_item_w.qt_proteina := coalesce(r_basic_nutrition_item_w.qt_proteina, 0) + (qt_volume_w/qt_fator_conv_prod_w) * qt_fator_conv_elem_w;
				end if;
			end if;

			if (ie_tipo_elem_p = 'R') then

				if ((coalesce(cd_unid_med_cal_w, 'XPTO') = 'XPTO') or (cd_unid_med_cal_w = cd_unid_med_elem_p)) then

					if (coalesce(cd_unid_med_cal_w, 'XPTO') = 'XPTO') then

						cd_unid_med_cal_w := cd_unid_med_elem_p;
						r_basic_nutrition_item_w.cd_unid_med_cal := cd_unid_med_cal_w;
					end if;

					r_basic_nutrition_item_w.qt_caloria := coalesce(r_basic_nutrition_item_w.qt_caloria, 0) + (qt_volume_w/qt_fator_conv_prod_w) * qt_fator_conv_elem_w;
				end if;
			end if;

			if (ie_tipo_elem_p = 'C') then

				if ((coalesce(cd_unid_med_carb_w, 'XPTO') = 'XPTO') or (cd_unid_med_carb_w = cd_unid_med_elem_p)) then

					if (coalesce(cd_unid_med_carb_w, 'XPTO') = 'XPTO') then

						cd_unid_med_carb_w := cd_unid_med_elem_p;
						r_basic_nutrition_item_w.cd_unid_med_carb := cd_unid_med_carb_w;
					end if;

					r_basic_nutrition_item_w.qt_carboidrato := coalesce(r_basic_nutrition_item_w.qt_carboidrato, 0) + (qt_volume_w/qt_fator_conv_prod_w) * qt_fator_conv_elem_w;
				end if;
			end if;

			if (ie_tipo_elem_p = 'L') then

				if ((coalesce(cd_unid_med_gord_w, 'XPTO') = 'XPTO') or (cd_unid_med_gord_w = cd_unid_med_elem_p)) then

					if (coalesce(cd_unid_med_gord_w, 'XPTO') = 'XPTO') then

						cd_unid_med_gord_w := cd_unid_med_elem_p;
						r_basic_nutrition_item_w.cd_unid_med_gord := cd_unid_med_gord_w;
					end if;

					r_basic_nutrition_item_w.qt_gordura := coalesce(r_basic_nutrition_item_w.qt_gordura, 0) + (qt_volume_w/qt_fator_conv_prod_w) * qt_fator_conv_elem_w;
				end if;
			end if;

			if (ie_tipo_elem_p = 'F') then

				if ((coalesce(cd_unid_med_fos_w, 'XPTO') = 'XPTO') or (cd_unid_med_fos_w = cd_unid_med_elem_p)) then

					if (coalesce(cd_unid_med_fos_w, 'XPTO') = 'XPTO') then

						cd_unid_med_fos_w := cd_unid_med_elem_p;
						r_basic_nutrition_item_w.cd_unid_med_fos := cd_unid_med_fos_w;
					end if;

					r_basic_nutrition_item_w.qt_fosforo := coalesce(r_basic_nutrition_item_w.qt_fosforo, 0) + (qt_volume_w/qt_fator_conv_prod_w) * qt_fator_conv_elem_w;
				end if;
			end if;

			if (ie_tipo_elem_p = 'I') then

				if ((coalesce(cd_unid_med_ca_w, 'XPTO') = 'XPTO') or (cd_unid_med_ca_w = cd_unid_med_elem_p)) then

					if (coalesce(cd_unid_med_ca_w, 'XPTO') = 'XPTO') then

						cd_unid_med_ca_w := cd_unid_med_elem_p;
						r_basic_nutrition_item_w.cd_unid_med_ca := cd_unid_med_ca_w;
					end if;

					r_basic_nutrition_item_w.qt_calcio := coalesce(r_basic_nutrition_item_w.qt_calcio, 0) + (qt_volume_w/qt_fator_conv_prod_w) * qt_fator_conv_elem_w;
				end if;
			end if;

			if (ie_tipo_elem_p = 'M') then

				if ((coalesce(cd_unid_med_mag_w, 'XPTO') = 'XPTO') or (cd_unid_med_mag_w = cd_unid_med_elem_p)) then

					if (coalesce(cd_unid_med_mag_w, 'XPTO') = 'XPTO') then

						cd_unid_med_mag_w := cd_unid_med_elem_p;
						r_basic_nutrition_item_w.cd_unid_med_mag := cd_unid_med_mag_w;
					end if;

					r_basic_nutrition_item_w.qt_magnesio := coalesce(r_basic_nutrition_item_w.qt_magnesio, 0) + (qt_volume_w/qt_fator_conv_prod_w) * qt_fator_conv_elem_w;
				end if;
			end if;

			if (ie_tipo_elem_p = 'N') then

				if ((coalesce(cd_unid_med_sod_w, 'XPTO') = 'XPTO') or (cd_unid_med_sod_w = cd_unid_med_elem_p)) then

					if (coalesce(cd_unid_med_sod_w, 'XPTO') = 'XPTO') then

						cd_unid_med_sod_w := cd_unid_med_elem_p;
						r_basic_nutrition_item_w.cd_unid_med_sod := cd_unid_med_sod_w;
					end if;

					r_basic_nutrition_item_w.qt_sodio := coalesce(r_basic_nutrition_item_w.qt_sodio, 0) + (qt_volume_w/qt_fator_conv_prod_w) * qt_fator_conv_elem_w;
				end if;
			end if;

			if (ie_tipo_elem_p = 'K') then

				if ((coalesce(cd_unid_med_pot_w, 'XPTO') = 'XPTO') or (cd_unid_med_pot_w = cd_unid_med_elem_p)) then

					if (coalesce(cd_unid_med_pot_w, 'XPTO') = 'XPTO') then

						cd_unid_med_pot_w := cd_unid_med_elem_p;
						r_basic_nutrition_item_w.cd_unid_med_pot := cd_unid_med_pot_w;
					end if;

					r_basic_nutrition_item_w.qt_potassio := coalesce(r_basic_nutrition_item_w.qt_potassio, 0) + (qt_volume_w/qt_fator_conv_prod_w) * qt_fator_conv_elem_w;
				end if;
			end if;

			if (ie_tipo_elem_p = 'Y') then

				if ((coalesce(cd_unid_med_cl_w, 'XPTO') = 'XPTO') or (cd_unid_med_cl_w = cd_unid_med_elem_p)) then

					if (coalesce(cd_unid_med_cl_w, 'XPTO') = 'XPTO') then

						cd_unid_med_cl_w := cd_unid_med_elem_p;
						r_basic_nutrition_item_w.cd_unid_med_cl := cd_unid_med_cl_w;
					end if;

					r_basic_nutrition_item_w.qt_cloreto := coalesce(r_basic_nutrition_item_w.qt_cloreto, 0) + (qt_volume_w/qt_fator_conv_prod_w) * qt_fator_conv_elem_w;
				end if;
			end if;
		end if;
	end;

begin

    qt_volume_total_w			:= 0;
    qt_volume_kg_total_w 		:= 0;
    qt_caloria_total_w			:= 0;
    qt_caloria_kg_total_w		:= 0;
    qt_carboidrato_total_w		:= 0;
    qt_carboidrato_kg_total_w	:= 0;
    qt_proteina_total_w			:= 0;
    qt_proteina_kg_total_w		:= 0;
    qt_gordura_total_w			:= 0;
    qt_gordura_kg_total_w		:= 0;
    qt_fosforo_total_w		    := 0;
    qt_fosforo_kg_total_w		:= 0;
    qt_calcio_total_w		    := 0;
    qt_calcio_kg_total_w		:= 0;
    qt_magnesio_total_w		    := 0;
    qt_magnesio_kg_total_w		:= 0;
    qt_sodio_total_w		    := 0;
    qt_sodio_kg_total_w		    := 0;
    qt_potassio_total_w		    := 0;
    qt_potassio_kg_total_w		:= 0;
    qt_cloreto_total_w		    := 0;
    qt_cloreto_kg_total_w		:= 0;

    qt_volume_geral_w			:= 0;
    qt_volume_kg_geral_w 		:= 0;
    qt_caloria_geral_w			:= 0;
    qt_caloria_kg_geral_w		:= 0;
    qt_carboidrato_geral_w		:= 0;
    qt_carboidrato_kg_geral_w	:= 0;
    qt_proteina_geral_w			:= 0;
    qt_proteina_kg_geral_w		:= 0;
    qt_gordura_geral_w			:= 0;
    qt_gordura_kg_geral_w		:= 0;
    qt_fosforo_geral_w		    := 0;
    qt_fosforo_kg_geral_w		:= 0;
    qt_calcio_geral_w		    := 0;
    qt_calcio_kg_geral_w		:= 0;
    qt_magnesio_geral_w		    := 0;
    qt_magnesio_kg_geral_w		:= 0;
    qt_sodio_geral_w		    := 0;
    qt_sodio_kg_geral_w		    := 0;
    qt_potassio_geral_w		    := 0;
    qt_potassio_kg_geral_w		:= 0;
    qt_cloreto_geral_w		    := 0;
    qt_cloreto_kg_geral_w		:= 0;

    select  max(cd_pessoa_fisica)
    into STRICT    cd_pessoa_fisica_w
    from    atendimento_paciente
    where   nr_atendimento = nr_atendimento_p;

    for nutrition_item_w in cNutrition
	loop

        CALL nutrition_intake_manager_pck.init_record();
        r_basic_nutrition_item_w.nr_seq_cpoe    := nutrition_item_w.nr_seq_cpoe;
        r_basic_nutrition_item_w.ds_item		:= nutrition_item_w.ds_item;
        r_basic_nutrition_item_w.qt_duracao     := nutrition_intake_manager_pck.get_qt_duracao(nutrition_item_w.ie_duracao, nutrition_item_w.dt_fim, nutrition_item_w.dt_suspensao, dt_start_p);
        r_basic_nutrition_item_w.qt_vezes		:= nutrition_item_w.qt_vezes;
        r_basic_nutrition_item_w.qt_volume  	:= nutrition_item_w.qt_volume;
        r_basic_nutrition_item_w.ie_editado     := nutrition_item_w.ie_editado;
        r_basic_nutrition_item_w.ie_preview     := nutrition_item_w.ie_preview;
        r_basic_nutrition_item_w.ie_totalizador	:= 'N';
        r_basic_nutrition_item_w.ie_tipo_item   := 'D';
        r_basic_nutrition_item_w.nm_tabela      := 'CPOE_DIETA';

        cd_material_w := nutrition_item_w.cd_material;
        ie_medic_solucao_w := 'N';

        if (nutrition_item_w.ie_tipo_dieta = 'I') then
          ie_pediatric_w := 'S';
        else
          ie_pediatric_w := 'N';
        end if;

        for element_item_w in cElements
        loop
		
			CALL nutrition_intake_manager_pck.calculate_elements( nutrition_item_w.cd_material,
								nutrition_item_w.qt_volume,
								nutrition_item_w.qt_vezes,
								nutrition_item_w.unid_med_prescricao,
								element_item_w.ie_tipo_elemento,
								element_item_w.unid_med_elemento,
								element_item_w.ie_sem_volume,
								element_item_w.fator_conv_qt_prod,
								element_item_w.fator_conv_um_elem,
								element_item_w.cd_unid_med_conv,
								element_item_w.qt_conversao);

        end loop;

        if (qt_peso_w > 0) then

          if (coalesce(r_basic_nutrition_item_w.qt_volume, 0) > 0) then
            r_basic_nutrition_item_w.qt_volume_kg := r_basic_nutrition_item_w.qt_volume / qt_peso_w;
          end if;

          if (coalesce(r_basic_nutrition_item_w.qt_proteina, 0) > 0) then
            r_basic_nutrition_item_w.qt_proteina_kg := r_basic_nutrition_item_w.qt_proteina / qt_peso_w;
  				end if;

          if (coalesce(r_basic_nutrition_item_w.qt_carboidrato, 0) > 0) then
      			r_basic_nutrition_item_w.qt_carboidrato_kg := r_basic_nutrition_item_w.qt_carboidrato / qt_peso_w;
          end if;

          if (coalesce(r_basic_nutrition_item_w.qt_gordura, 0) > 0) then
            r_basic_nutrition_item_w.qt_gordura_kg := r_basic_nutrition_item_w.qt_gordura / qt_peso_w;
          end if;

          if (coalesce(r_basic_nutrition_item_w.qt_fosforo, 0) > 0) then
            r_basic_nutrition_item_w.qt_fosforo_kg := r_basic_nutrition_item_w.qt_fosforo / qt_peso_w;
          end if;

          if (coalesce(r_basic_nutrition_item_w.qt_calcio, 0) > 0) then
            r_basic_nutrition_item_w.qt_calcio_kg := r_basic_nutrition_item_w.qt_calcio / qt_peso_w;
          end if;

          if (coalesce(r_basic_nutrition_item_w.qt_magnesio, 0) > 0) then
            r_basic_nutrition_item_w.qt_magnesio_kg := r_basic_nutrition_item_w.qt_magnesio / qt_peso_w;
          end if;

          if (coalesce(r_basic_nutrition_item_w.qt_sodio, 0) > 0) then
            r_basic_nutrition_item_w.qt_sodio_kg := r_basic_nutrition_item_w.qt_sodio / qt_peso_w;
          end if;

          if (coalesce(r_basic_nutrition_item_w.qt_potassio, 0) > 0) then
            r_basic_nutrition_item_w.qt_potassio_kg := r_basic_nutrition_item_w.qt_potassio / qt_peso_w;
          end if;

          if (coalesce(r_basic_nutrition_item_w.qt_cloreto, 0) > 0) then
            r_basic_nutrition_item_w.qt_cloreto_kg := r_basic_nutrition_item_w.qt_cloreto / qt_peso_w;
          end if;

        end if;

		RETURN;
		ie_criar_grupo_w := 'S';
		
		if (r_basic_nutrition_item_w.ie_editado <> 'S') then
			CALL nutrition_intake_manager_pck.update_group_totals();
		end if;

	end loop;

    if (ie_criar_grupo_w = 'S') then
		CALL nutrition_intake_manager_pck.set_group_totals('D');
		RETURN;
		CALL nutrition_intake_manager_pck.update_global_totals();
		ie_criar_grupo_w := 'S';
    end if;

    CALL nutrition_intake_manager_pck.reset_totals();
    ie_criar_grupo_w := 'N';

    for infusion_item_w in cInfusion
	loop

        CALL nutrition_intake_manager_pck.init_record();
        r_basic_nutrition_item_w.nr_seq_cpoe    := infusion_item_w.nr_seq_cpoe;
        r_basic_nutrition_item_w.ds_item		:= infusion_item_w.ds_item;
        r_basic_nutrition_item_w.qt_duracao		:= nutrition_intake_manager_pck.get_qt_duracao(infusion_item_w.ie_duracao, infusion_item_w.dt_fim, infusion_item_w.dt_suspensao, dt_start_p);
        r_basic_nutrition_item_w.qt_vezes		:= infusion_item_w.qt_vezes;
        r_basic_nutrition_item_w.qt_volume  	:= infusion_item_w.qt_volume;
        r_basic_nutrition_item_w.ie_editado     := infusion_item_w.ie_editado;
        r_basic_nutrition_item_w.ie_preview     := infusion_item_w.ie_preview;
        r_basic_nutrition_item_w.ie_totalizador	:= 'N';
        r_basic_nutrition_item_w.ie_tipo_item   := 'SOL';
        r_basic_nutrition_item_w.nm_tabela      := 'CPOE_MATERIAL';

        cd_material_w := infusion_item_w.cd_material;
        ie_medic_solucao_w := 'S';
        ie_pediatric_w := 'N';

        for element_item_w in cElements
        loop
	
			CALL nutrition_intake_manager_pck.calculate_elements( infusion_item_w.cd_material,
								infusion_item_w.qt_volume,
								infusion_item_w.qt_vezes,
								infusion_item_w.unid_med_prescricao,
								element_item_w.ie_tipo_elemento,
								element_item_w.unid_med_elemento,
								element_item_w.ie_sem_volume,
								element_item_w.fator_conv_qt_prod,
								element_item_w.fator_conv_um_elem,
								element_item_w.cd_unid_med_conv,
								element_item_w.qt_conversao);

        end loop;

        if (qt_peso_w > 0) then

			if (coalesce(r_basic_nutrition_item_w.qt_volume, 0) > 0) then
				r_basic_nutrition_item_w.qt_volume_kg := r_basic_nutrition_item_w.qt_volume / qt_peso_w;
			end if;

			if (coalesce(r_basic_nutrition_item_w.qt_proteina, 0) > 0) then
				r_basic_nutrition_item_w.qt_proteina_kg := r_basic_nutrition_item_w.qt_proteina / qt_peso_w;
					end if;

			if (coalesce(r_basic_nutrition_item_w.qt_carboidrato, 0) > 0) then
					r_basic_nutrition_item_w.qt_carboidrato_kg := r_basic_nutrition_item_w.qt_carboidrato / qt_peso_w;
			end if;

			if (coalesce(r_basic_nutrition_item_w.qt_gordura, 0) > 0) then
				r_basic_nutrition_item_w.qt_gordura_kg := r_basic_nutrition_item_w.qt_gordura / qt_peso_w;
			end if;

			if (coalesce(r_basic_nutrition_item_w.qt_fosforo, 0) > 0) then
				r_basic_nutrition_item_w.qt_fosforo_kg := r_basic_nutrition_item_w.qt_fosforo / qt_peso_w;
			end if;

			if (coalesce(r_basic_nutrition_item_w.qt_calcio, 0) > 0) then
				r_basic_nutrition_item_w.qt_calcio_kg := r_basic_nutrition_item_w.qt_calcio / qt_peso_w;
			end if;

			if (coalesce(r_basic_nutrition_item_w.qt_magnesio, 0) > 0) then
				r_basic_nutrition_item_w.qt_magnesio_kg := r_basic_nutrition_item_w.qt_magnesio / qt_peso_w;
			end if;

			if (coalesce(r_basic_nutrition_item_w.qt_sodio, 0) > 0) then
				r_basic_nutrition_item_w.qt_sodio_kg := r_basic_nutrition_item_w.qt_sodio / qt_peso_w;
			end if;

			if (coalesce(r_basic_nutrition_item_w.qt_potassio, 0) > 0) then
				r_basic_nutrition_item_w.qt_potassio_kg := r_basic_nutrition_item_w.qt_potassio / qt_peso_w;
			end if;

			if (coalesce(r_basic_nutrition_item_w.qt_cloreto, 0) > 0) then
				r_basic_nutrition_item_w.qt_cloreto_kg := r_basic_nutrition_item_w.qt_cloreto / qt_peso_w;
			end if;
        end if;

		RETURN;
		ie_criar_grupo_w := 'S';

		if (r_basic_nutrition_item_w.ie_editado <> 'S') then
			CALL nutrition_intake_manager_pck.update_group_totals();
		end if;
	end loop;

	if (ie_criar_grupo_w = 'S') then
		CALL nutrition_intake_manager_pck.set_group_totals('SOL');
		RETURN;
		CALL nutrition_intake_manager_pck.update_global_totals();
		ie_criar_grupo_w := 'N';
    end if;

    CALL nutrition_intake_manager_pck.reset_totals();
    ie_criar_grupo_w := 'N';

    for medicine_item_w in cMedicine
	loop

        cd_material_w := medicine_item_w.cd_material;
        qt_dose_w := 0;
        ie_dose_diferenciada_w := 'N';
        ie_medic_solucao_w := 'S';
        ie_pediatric_w := 'N';

        CALL nutrition_intake_manager_pck.init_record();

        r_basic_nutrition_item_w.nr_seq_cpoe	:= medicine_item_w.nr_seq_cpoe;
        r_basic_nutrition_item_w.ds_item		:= medicine_item_w.ds_item;
        r_basic_nutrition_item_w.qt_duracao		:= medicine_item_w.qt_duracao;
        r_basic_nutrition_item_w.qt_vezes		:= medicine_item_w.qt_vezes;
		r_basic_nutrition_item_w.qt_volume		:= 0;

        if (medicine_item_w.qt_volume > 0) then

          r_basic_nutrition_item_w.qt_volume := medicine_item_w.qt_vezes * medicine_item_w.qt_volume;
          qt_dose_w := r_basic_nutrition_item_w.qt_volume;
        elsif (medicine_item_w.qt_dose > 0) then

          qt_dose_w := medicine_item_w.qt_dose;
        elsif (medicine_item_w.qt_dose_ataque > 0) then

          qt_dose_w := medicine_item_w.qt_dose_ataque;
        elsif (coalesce(medicine_item_w.ds_dose_diferenciada, 'XPTO') <> 'XPTO') then

          qt_dose_w := nutrition_intake_manager_pck.get_total_dose(medicine_item_w.ds_dose_diferenciada);
          ie_dose_diferenciada_w := 'S';
        end if;

        r_basic_nutrition_item_w.ie_editado         := medicine_item_w.ie_editado;
        r_basic_nutrition_item_w.ie_preview         := medicine_item_w.ie_preview;
        r_basic_nutrition_item_w.ie_totalizador     := 'N';
        r_basic_nutrition_item_w.ie_tipo_item       := 'M';
        r_basic_nutrition_item_w.nm_tabela          := 'CPOE_MATERIAL';

        for element_item_w in cElements
        loop

			CALL nutrition_intake_manager_pck.calculate_elements( medicine_item_w.cd_material,
                              qt_dose_w,
                              medicine_item_w.qt_vezes,
                              medicine_item_w.unid_med_prescricao,
                              element_item_w.ie_tipo_elemento,
                              element_item_w.unid_med_elemento,
                              element_item_w.ie_sem_volume,
                              element_item_w.fator_conv_qt_prod,
                              element_item_w.fator_conv_um_elem,
                              element_item_w.cd_unid_med_conv,
                              element_item_w.qt_conversao);

        end loop;

        if (qt_peso_w > 0) then

          if (coalesce(r_basic_nutrition_item_w.qt_volume, 0) > 0) then
            r_basic_nutrition_item_w.qt_volume_kg := r_basic_nutrition_item_w.qt_volume / qt_peso_w;
          end if;

          if (coalesce(r_basic_nutrition_item_w.qt_proteina, 0) > 0) then
            r_basic_nutrition_item_w.qt_proteina_kg := r_basic_nutrition_item_w.qt_proteina / qt_peso_w;
  				end if;

          if (coalesce(r_basic_nutrition_item_w.qt_carboidrato, 0) > 0) then
      			r_basic_nutrition_item_w.qt_carboidrato_kg := r_basic_nutrition_item_w.qt_carboidrato / qt_peso_w;
          end if;

          if (coalesce(r_basic_nutrition_item_w.qt_gordura, 0) > 0) then
            r_basic_nutrition_item_w.qt_gordura_kg := r_basic_nutrition_item_w.qt_gordura / qt_peso_w;
          end if;

          if (coalesce(r_basic_nutrition_item_w.qt_fosforo, 0) > 0) then
            r_basic_nutrition_item_w.qt_fosforo_kg := r_basic_nutrition_item_w.qt_fosforo / qt_peso_w;
          end if;

          if (coalesce(r_basic_nutrition_item_w.qt_calcio, 0) > 0) then
            r_basic_nutrition_item_w.qt_calcio_kg := r_basic_nutrition_item_w.qt_calcio / qt_peso_w;
          end if;

          if (coalesce(r_basic_nutrition_item_w.qt_magnesio, 0) > 0) then
            r_basic_nutrition_item_w.qt_magnesio_kg := r_basic_nutrition_item_w.qt_magnesio / qt_peso_w;
          end if;

          if (coalesce(r_basic_nutrition_item_w.qt_sodio, 0) > 0) then
            r_basic_nutrition_item_w.qt_sodio_kg := r_basic_nutrition_item_w.qt_sodio / qt_peso_w;
          end if;

          if (coalesce(r_basic_nutrition_item_w.qt_potassio, 0) > 0) then
            r_basic_nutrition_item_w.qt_potassio_kg := r_basic_nutrition_item_w.qt_potassio / qt_peso_w;
          end if;

          if (coalesce(r_basic_nutrition_item_w.qt_cloreto, 0) > 0) then
            r_basic_nutrition_item_w.qt_cloreto_kg := r_basic_nutrition_item_w.qt_cloreto / qt_peso_w;
          end if;

        end if;

		RETURN;
		ie_criar_grupo_w := 'S';

		if (r_basic_nutrition_item_w.ie_editado <> 'S') then
			CALL nutrition_intake_manager_pck.update_group_totals();
		end if;
	end loop;

	if (ie_criar_grupo_w = 'S') then
		CALL nutrition_intake_manager_pck.set_group_totals('M');
		RETURN;
		CALL nutrition_intake_manager_pck.update_global_totals();
	end if;

    CALL nutrition_intake_manager_pck.reset_totals();

    CALL nutrition_intake_manager_pck.set_other_volumes();
    RETURN;

    CALL nutrition_intake_manager_pck.set_global_totals();
    RETURN;

    CALL nutrition_intake_manager_pck.set_minimal_goals();
    RETURN;

    CALL nutrition_intake_manager_pck.set_maximum_goals();
    RETURN;

	
	CALL nutrition_intake_manager_pck.init_record();
    r_basic_nutrition_item_w.nr_seq_cpoe        := '';
    r_basic_nutrition_item_w.ds_item			:= upper(obter_desc_expressao(1005508));
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
    r_basic_nutrition_item_w.ie_totalizador     := 'N';
    r_basic_nutrition_item_w.ie_tipo_item       := 'DF';
    r_basic_nutrition_item_w.nm_tabela          := '';

    RETURN;

    CALL nutrition_intake_manager_pck.set_estimated_calories();
    RETURN;

	CALL nutrition_intake_manager_pck.set_measurement_units();
	RETURN;

	return;

END;

$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE nutrition_intake_manager_pck.calculate_elements ( cd_material_p bigint, qt_volume_p bigint, qt_vezes_p bigint, cd_unid_med_p text, ie_tipo_elem_p text, cd_unid_med_elem_p text, ie_sem_volme_p text, qt_fator_conv_prod_p bigint, qt_fator_conv_elem_p bigint, cd_unid_med_conv_p text, qt_conversao_p bigint) FROM PUBLIC;