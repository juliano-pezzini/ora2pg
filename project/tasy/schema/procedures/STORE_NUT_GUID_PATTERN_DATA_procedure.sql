-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE store_nut_guid_pattern_data ( nr_seq_nut_guidance_p bigint, nr_seq_recomendacao_p bigint, qt_calories_p bigint, qt_composition_fat_p bigint, qt_composition_potassium_p bigint, qt_composition_carb_p bigint, qt_ps_ratio_p bigint, qt_protein_p bigint, qt_calcium_p bigint, qt_lipid_p bigint, qt_iron_p bigint, qt_carbohydrate_p bigint, qt_phosphorus_p bigint, qt_salt_p bigint, qt_water_p bigint, qt_potassium_p bigint, qt_vitamin_a_p bigint, qt_vitamin_b1_p bigint, qt_vitamin_b2_p bigint, qt_vitamin_b6_p bigint, qt_vitamin_b12_p bigint, qt_vitamin_c_p bigint, qt_vitamin_d_p bigint, qt_vitamin_e_p bigint, qt_vitamin_k_p bigint, ie_cpoe_rec_p text, nr_seq_cpoe_nut_guid_p INOUT bigint ) AS $body$
DECLARE

nr_sequencia_w  cpoe_nut_guidance.nr_sequencia%type;


BEGIN

    select 	max(nr_sequencia)
    into STRICT 	nr_sequencia_w
    from 	cpoe_nut_guidance
    where 	nr_seq_recomendacao = nr_seq_recomendacao_p
    and 	ie_cpoe_rec = 'N';

    if ( coalesce(ie_cpoe_rec_p, 'S') = 'S' and coalesce(nr_sequencia_w::text, '') = '') then

        select 	nextval('cpoe_nut_guidance_seq')
        into STRICT 	nr_sequencia_w
;

        insert into
            cpoe_nut_guidance(
                nr_sequencia,
                dt_atualizacao,
                nm_usuario,
                ie_situacao,
                qt_calories,
                qt_composition_fat,
                qt_composition_potassium,
                qt_composition_carb,
                qt_ps_ratio,
                qt_protein,
                qt_calcium,
                qt_lipid,
                qt_iron,
                qt_carbohydrate,
                qt_phosphorus,
                qt_salt,
                qt_water,
                qt_potassium,
                qt_vitamin_a,
                qt_vitamin_b1,
                qt_vitamin_b2,
                qt_vitamin_b6,
                qt_vitamin_b12,
                qt_vitamin_c,
                qt_vitamin_d,
                qt_vitamin_e,
                qt_vitamin_k,
                nr_seq_recomendacao,
                ie_cpoe_rec,
                nr_seq_nut_guidance
            ) values (
                nr_sequencia_w,
                clock_timestamp(),
                wheb_usuario_pck.get_nm_usuario,
                'A',
                qt_calories_p,
                qt_composition_fat_p,
                qt_composition_potassium_p,
                qt_composition_carb_p,
                qt_ps_ratio_p,
                qt_protein_p,
                qt_calcium_p,
                qt_lipid_p,
                qt_iron_p,
                qt_carbohydrate_p,
                qt_phosphorus_p,
                qt_salt_p,
                qt_water_p,
                qt_potassium_p,
                qt_vitamin_a_p,
                qt_vitamin_b1_p,
                qt_vitamin_b2_p,
                qt_vitamin_b6_p,
                qt_vitamin_b12_p,
                qt_vitamin_c_p,
                qt_vitamin_d_p,
                qt_vitamin_e_p,
                qt_vitamin_k_p,
                nr_seq_recomendacao_p,
                'N',
                nr_seq_nut_guidance_p
            );

        else
            nr_sequencia_w := coalesce(nr_sequencia_w, nr_seq_cpoe_nut_guid_p);

            update  cpoe_nut_guidance
            set 	dt_atualizacao              = clock_timestamp(),
                    nm_usuario                  = wheb_usuario_pck.get_nm_usuario,
                    qt_calories                 = qt_calories_p,
                    qt_composition_fat          = qt_composition_fat_p,
                    qt_composition_potassium    = qt_composition_potassium_p,
                    qt_composition_carb         = qt_composition_carb_p,
                    qt_ps_ratio                 = qt_ps_ratio_p,
                    qt_protein                  = qt_protein_p,
                    qt_calcium                  = qt_calcium_p,
                    qt_lipid                    = qt_lipid_p,
                    qt_iron                     = qt_iron_p,
                    qt_carbohydrate             = qt_carbohydrate_p,
                    qt_phosphorus               = qt_phosphorus_p,
                    qt_salt                     = qt_salt_p,
                    qt_water                    = qt_water_p,
                    qt_potassium                = qt_potassium_p,
                    qt_vitamin_a                = qt_vitamin_a_p,
                    qt_vitamin_b1               = qt_vitamin_b1_p,
                    qt_vitamin_b2               = qt_vitamin_b2_p,
                    qt_vitamin_b6               = qt_vitamin_b6_p,
                    qt_vitamin_b12              = qt_vitamin_b12_p,
                    qt_vitamin_c                = qt_vitamin_c_p,
                    qt_vitamin_d                = qt_vitamin_d_p,
                    qt_vitamin_e                = qt_vitamin_e_p,
                    qt_vitamin_k                = qt_vitamin_k_p,
                    nr_seq_nut_guidance         = nr_seq_nut_guidance_p
            where 	nr_sequencia                = nr_sequencia_w;
        end if;

        commit;

        nr_seq_cpoe_nut_guid_p := nr_sequencia_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE store_nut_guid_pattern_data ( nr_seq_nut_guidance_p bigint, nr_seq_recomendacao_p bigint, qt_calories_p bigint, qt_composition_fat_p bigint, qt_composition_potassium_p bigint, qt_composition_carb_p bigint, qt_ps_ratio_p bigint, qt_protein_p bigint, qt_calcium_p bigint, qt_lipid_p bigint, qt_iron_p bigint, qt_carbohydrate_p bigint, qt_phosphorus_p bigint, qt_salt_p bigint, qt_water_p bigint, qt_potassium_p bigint, qt_vitamin_a_p bigint, qt_vitamin_b1_p bigint, qt_vitamin_b2_p bigint, qt_vitamin_b6_p bigint, qt_vitamin_b12_p bigint, qt_vitamin_c_p bigint, qt_vitamin_d_p bigint, qt_vitamin_e_p bigint, qt_vitamin_k_p bigint, ie_cpoe_rec_p text, nr_seq_cpoe_nut_guid_p INOUT bigint ) FROM PUBLIC;
