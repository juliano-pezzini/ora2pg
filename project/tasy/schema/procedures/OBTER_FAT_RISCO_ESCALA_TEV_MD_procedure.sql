-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE obter_fat_risco_escala_tev_md ( ie_clinico_cirurgico_p text, qt_reg_p bigint, ie_trombofilia_p text, ie_idade_maior_p text, ie_eclampsia_p text, ie_avci_p text, ie_tvp_ep_previa_p text, ie_doenca_reumatol_p text, ie_hist_familiar_tev_p text, ie_anticoncepcionais_p text, ie_puerperio_p text, ie_obesidade_p text, ie_internacao_uti_p text, ie_cat_venoso_central_p text, ie_paralisia_inf_p text, ie_cancer_p text, ie_gravidez_p text, ie_insuf_resp_p text, ie_insuf_arterial_p text, ie_trh_p text, ie_icc_p text, ie_dpoc_p text, ie_pneumonia_p text, ie_infla_intestinal_p text, ie_varizes_p text, ie_infecsao_grave_p text, ie_quimioterapia_p text, ie_sindrome_nefrotica_p text, ie_doenca_autoimune_p text, ie_abortamento_p text, ie_trauma_p text, ie_iam_p text, ie_queimado_p text, ie_outros_p text, ie_mobilidade_reduzida_p text, ie_tabagismo_p text, qt_idade_p bigint, ie_condicao_p text, ie_artroplastia_joelho_p text, ie_artroplastia_quadril_p text, ie_fratura_quadril_p text, ie_oncol_curativa_p text, ie_trauma_medular_p text, ie_politrauma_p text, ie_bariatrica_p text, ie_demais_cirurgias_p text, ie_cir_pequeno_porte_p text, ie_risco_reclassif_p text, qt_peso_p bigint, qt_clearence_p bigint, qt_contra_indicacao_p bigint, qt_imc_p bigint, qt_contra_prof_mec_p bigint, qt_absoluta_p bigint, qt_relativa_p bigint, ie_cir_alto_risco_ori_p text, ie_nao_se_aplica_p text, ie_fator_risco_p INOUT text, ie_risco_p INOUT text, ds_resultado_p INOUT text, ie_cir_alto_risco_p INOUT text, ie_cir_grande_medio_porte_p INOUT text, nr_seq_resposta_p INOUT bigint ) AS $body$
DECLARE

  qt_reg_w bigint;

BEGIN
	if (ie_clinico_cirurgico_p = 'C') then

        qt_reg_w := coalesce(qt_reg_p, 0);

		if (ie_trombofilia_p = 'S') then
		  qt_reg_w := qt_reg_w + 1;
		end if;

		if (ie_idade_maior_p = 'S') then
		  qt_reg_w := qt_reg_w + 1;
		end if;

		if (ie_eclampsia_p = 'S') then
		  qt_reg_w := qt_reg_w + 1;
		end if;

		if (ie_avci_p = 'S') then
		  qt_reg_w := qt_reg_w + 1;
		end if;

		if (ie_tvp_ep_previa_p = 'S') then
		  qt_reg_w := qt_reg_w + 1;
		end if;

		if (ie_doenca_reumatol_p = 'S') then
		  qt_reg_w := qt_reg_w + 1;
		end if;

		if (ie_hist_familiar_tev_p = 'S') then
		  qt_reg_w := qt_reg_w + 1;
		end if;

		if (ie_anticoncepcionais_p = 'S') then
		  qt_reg_w := qt_reg_w + 1;
		end if;

		if (ie_puerperio_p = 'S') then
		  qt_reg_w := qt_reg_w + 1;
		end if;

		if (ie_obesidade_p = 'S') then
		  qt_reg_w := qt_reg_w + 1;
		end if;

		if (ie_internacao_uti_p = 'S') then
		  qt_reg_w := qt_reg_w + 1;
		end if;

		if (ie_cat_venoso_central_p = 'S') then
		  qt_reg_w := qt_reg_w + 1;
		end if;

		if (ie_paralisia_inf_p = 'S') then
		  qt_reg_w := qt_reg_w + 1;
		end if;

		if (ie_cancer_p = 'S') then
		  qt_reg_w := qt_reg_w + 1;
		end if;

		if (ie_gravidez_p = 'S') then
		  qt_reg_w := qt_reg_w + 1;
		end if;

		if (ie_insuf_resp_p = 'S') then
		  qt_reg_w := qt_reg_w + 1;
		end if;

		if (ie_insuf_arterial_p = 'S') then
		  qt_reg_w := qt_reg_w + 1;
		end if;

		if (ie_trh_p = 'S') then
		  qt_reg_w := qt_reg_w + 1;
		end if;

		if (ie_icc_p = 'S') then
		  qt_reg_w := qt_reg_w + 1;
		end if;

		if (ie_dpoc_p = 'S') then
		  qt_reg_w := qt_reg_w + 1;
		end if;

		if (ie_pneumonia_p = 'S') then
		  qt_reg_w := qt_reg_w + 1;
		end if;

		if (ie_infla_intestinal_p = 'S') then
		  qt_reg_w := qt_reg_w + 1;
		end if;

		if (ie_varizes_p = 'S') then
		  qt_reg_w := qt_reg_w + 1;
		end if;

		if (ie_infecsao_grave_p = 'S') then
		  qt_reg_w := qt_reg_w + 1;
		end if;

		if (ie_quimioterapia_p = 'S') then
		  qt_reg_w := qt_reg_w + 1;
		end if;

		if (ie_sindrome_nefrotica_p = 'S') then
		  qt_reg_w := qt_reg_w + 1;
		end if;

		if (ie_doenca_autoimune_p = 'S') then
		  qt_reg_w := qt_reg_w + 1;
		end if;

		if (ie_abortamento_p = 'S') then
		  qt_reg_w := qt_reg_w + 1;
		end if;

		if (ie_trauma_p = 'S') then
		  qt_reg_w := qt_reg_w + 1;
		end if;

		if (ie_iam_p = 'S') then
		  qt_reg_w := qt_reg_w + 1;
		end if;

		if (ie_queimado_p = 'S') then
		  qt_reg_w := qt_reg_w + 1;
		end if;

		if (ie_outros_p = 'S') then
		  qt_reg_w := qt_reg_w + 1;
		end if;

		ie_fator_risco_p := 'N';
		if (qt_reg_w > 0) and (ie_mobilidade_reduzida_p = 'S') then
		  ie_fator_risco_p := 'S';
		end if;

	elsif (ie_clinico_cirurgico_p = 'I') then

		ie_risco_p := 'B';

		qt_reg_w := 0;

		if (ie_abortamento_p = 'S') then
			qt_reg_w := qt_reg_w + 1;
		end if;

		if (ie_avci_p = 'S') then
			qt_reg_w := qt_reg_w + 1;
		end if;

		if (ie_hist_familiar_tev_p = 'S') then
			qt_reg_w := qt_reg_w + 1;
		end if;

		if (ie_tvp_ep_previa_p = 'S') then
			qt_reg_w := qt_reg_w + 1;
		end if;

		if (ie_cancer_p = 'S') then
			qt_reg_w := qt_reg_w + 1;
		end if;

		if (ie_tabagismo_p = 'S') then
			qt_reg_w := qt_reg_w + 1;
		end if;

		if (ie_cat_venoso_central_p = 'S') then
			qt_reg_w := qt_reg_w + 1;
		end if;

		if (ie_anticoncepcionais_p = 'S') then
			qt_reg_w := qt_reg_w + 1;
		end if;

		if (ie_infla_intestinal_p = 'S') then
			qt_reg_w := qt_reg_w + 1;
		end if;

		if (ie_tabagismo_p = 'S') then
			qt_reg_w := qt_reg_w + 1;
		end if;

		if (ie_dpoc_p = 'S') then
			qt_reg_w := qt_reg_w + 1;
		end if;

		if (ie_doenca_autoimune_p = 'S') then
			qt_reg_w := qt_reg_w + 1;
		end if;

		if (ie_iam_p = 'S') then
			qt_reg_w := qt_reg_w + 1;
		end if;

		if (ie_infecsao_grave_p = 'S') then
			qt_reg_w := qt_reg_w + 1;
		end if;

		if (ie_insuf_arterial_p = 'S') then
			qt_reg_w := qt_reg_w + 1;
		end  if;

		if (ie_icc_p = 'S') then
			qt_reg_w := qt_reg_w + 1;
		end if;

		if (ie_insuf_resp_p = 'S') then
			qt_reg_w := qt_reg_w + 1;
		end if;

		if (ie_internacao_uti_p = 'S') then
			qt_reg_w := qt_reg_w + 1;
		end if;

		if (ie_obesidade_p = 'S') then
			qt_reg_w := qt_reg_w + 1;
		end if;

		if (ie_paralisia_inf_p = 'S') then
			qt_reg_w := qt_reg_w + 1;
		end if;

		if (ie_pneumonia_p = 'S') then
			qt_reg_w := qt_reg_w + 1;
		end if;

		if (ie_puerperio_p = 'S') then
			qt_reg_w := qt_reg_w + 1;
		end if;

		if (ie_quimioterapia_p = 'S') then
			qt_reg_w := qt_reg_w + 1;
		end if;

		if (ie_sindrome_nefrotica_p = 'S') then
			qt_reg_w := qt_reg_w + 1;
		end if;

		if (ie_trombofilia_p = 'S') then
			qt_reg_w := qt_reg_w + 1;
		end if;

		if (ie_varizes_p = 'S') then
			qt_reg_w := qt_reg_w + 1;
		end if;

	end if;

	SELECT * FROM obter_risco_escala_tev_md(ie_clinico_cirurgico_p, qt_reg_w, qt_idade_p, ie_mobilidade_reduzida_p, ie_fator_risco_p, ie_condicao_p, ie_artroplastia_joelho_p, ie_artroplastia_quadril_p, ie_fratura_quadril_p, ie_oncol_curativa_p, ie_trauma_medular_p, ie_politrauma_p, ie_bariatrica_p, ie_demais_cirurgias_p, ie_cir_pequeno_porte_p, ie_nao_se_aplica_p, ie_risco_p, ds_resultado_p, ie_cir_alto_risco_p, ie_cir_grande_medio_porte_p) INTO STRICT ie_risco_p, ds_resultado_p, ie_cir_alto_risco_p, ie_cir_grande_medio_porte_p;
									
    nr_seq_resposta_p := obter_resultado_escala_tev_md(ie_clinico_cirurgico_p,
                                                       ie_risco_p,
                                                       ie_risco_reclassif_p,
                                                       qt_idade_p,
                                                       ie_mobilidade_reduzida_p,
                                                       qt_reg_w,
                                                       qt_peso_p,
                                                       qt_clearence_p,
                                                       qt_contra_indicacao_p,
                                                       qt_imc_p,
                                                       qt_contra_prof_mec_p,
                                                       ie_bariatrica_p,
                                                       qt_absoluta_p,
                                                       qt_relativa_p,
                                                       ie_cir_grande_medio_porte_p,
                                                       ie_artroplastia_quadril_p,
                                                       ie_artroplastia_joelho_p,
                                                       ie_fratura_quadril_p,
                                                       ie_trauma_medular_p,
                                                       ie_politrauma_p,
                                                       ie_oncol_curativa_p);

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE obter_fat_risco_escala_tev_md ( ie_clinico_cirurgico_p text, qt_reg_p bigint, ie_trombofilia_p text, ie_idade_maior_p text, ie_eclampsia_p text, ie_avci_p text, ie_tvp_ep_previa_p text, ie_doenca_reumatol_p text, ie_hist_familiar_tev_p text, ie_anticoncepcionais_p text, ie_puerperio_p text, ie_obesidade_p text, ie_internacao_uti_p text, ie_cat_venoso_central_p text, ie_paralisia_inf_p text, ie_cancer_p text, ie_gravidez_p text, ie_insuf_resp_p text, ie_insuf_arterial_p text, ie_trh_p text, ie_icc_p text, ie_dpoc_p text, ie_pneumonia_p text, ie_infla_intestinal_p text, ie_varizes_p text, ie_infecsao_grave_p text, ie_quimioterapia_p text, ie_sindrome_nefrotica_p text, ie_doenca_autoimune_p text, ie_abortamento_p text, ie_trauma_p text, ie_iam_p text, ie_queimado_p text, ie_outros_p text, ie_mobilidade_reduzida_p text, ie_tabagismo_p text, qt_idade_p bigint, ie_condicao_p text, ie_artroplastia_joelho_p text, ie_artroplastia_quadril_p text, ie_fratura_quadril_p text, ie_oncol_curativa_p text, ie_trauma_medular_p text, ie_politrauma_p text, ie_bariatrica_p text, ie_demais_cirurgias_p text, ie_cir_pequeno_porte_p text, ie_risco_reclassif_p text, qt_peso_p bigint, qt_clearence_p bigint, qt_contra_indicacao_p bigint, qt_imc_p bigint, qt_contra_prof_mec_p bigint, qt_absoluta_p bigint, qt_relativa_p bigint, ie_cir_alto_risco_ori_p text, ie_nao_se_aplica_p text, ie_fator_risco_p INOUT text, ie_risco_p INOUT text, ds_resultado_p INOUT text, ie_cir_alto_risco_p INOUT text, ie_cir_grande_medio_porte_p INOUT text, nr_seq_resposta_p INOUT bigint ) FROM PUBLIC;

