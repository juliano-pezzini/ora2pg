-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';

CREATE OR REPLACE VIEW hepic_sinal_vital_v (nr_sequencia, nr_atendimento, dt_sinal_vital, dt_atualizacao, nm_usuario, qt_pa_diastolica, qt_pa_sistolica, ie_pressao, qt_freq_cardiaca, qt_freq_resp, qt_temp, ds_observacao, qt_peso, qt_imc, qt_superf_corporia, qt_bcf, qt_altura_cm, cd_pessoa_fisica, ie_membro, ie_manguito, qt_saturacao_o2, qt_glicemia_capilar, ie_aparelho_pa, cd_escala_dor, qt_escala_dor, qt_pam, qt_pvc, qt_pvc_h2o, qt_pae, qt_temp_incubadora, nr_seq_topografia_dor, qt_pressao_intra_abd, qt_pressao_intra_cranio, qt_perimetro_cefalico, nr_cirurgia, qt_insulina, ie_ritmo_ecg, qt_segmento_st, qt_maec, ie_sitio, ie_rn, qt_perimetro_toracico, qt_perimitro_abdominal, ie_lado, nr_hora, ie_relevante_apap, cd_paciente, dt_liberacao, ie_situacao, dt_inativacao, nm_usuario_inativacao, ds_justificativa, dt_referencia, ie_decubito, nr_seq_saep, cd_setor_atendimento, nr_seq_assinatura, nr_seq_condicao_dor, nr_seq_reg_elemento, qt_bilirrubina_tronco, qt_bilirrubina_fronte, qt_pupila_tamanho, ie_pupila_reacao_luz, ie_pupila_alteracao, ie_pupila_lado, ie_sinal_focal, ie_sinal_focal_local, cd_perfil_ativo, nr_seq_pepo, ie_origem_peso, ie_origem_altura, qt_peso_um, qt_tof_bloq_neuro_musc, ie_nivel_consciencia, nr_seq_intervencao, ie_rpa, qt_pupila_tam_esq, ie_pupila_reacao_luz_e, ie_babinski, qt_variacao_glic, qt_glic_media_dia, qt_glic_media_atend, qt_ppa, qt_ppc, qt_angulo_cabeceira, qt_perimetro_quadril, qt_circunf_panturrilha, qt_relacao_abd_quad, qt_circunf_braco, qt_prega_cutanea_triceps, qt_o2_suplementar, ie_unid_med_o2_suplem, nr_seq_horario, nr_seq_sinal_vital, nr_seq_triagem, qt_delta_peso, dt_delta_peso, ie_agitacao, ie_sudorese, ie_aum_trab_resp, nr_seq_assinat_inativacao, qt_freq_card_monit, nr_seq_result_dor, nr_seq_inapto_dor, ie_mae_canguru, ie_derivacao_seg_st, qt_glicose_adm, ie_glic_extrapol, qt_bcf_2, qt_bcf_3, qt_irradiancia, nr_recem_nato, ie_importado, qt_deriv_ventric_exter, qt_pic_temp, ie_cond_sat_o2, ie_membro_sat_o2) AS select nr_sequencia, nr_atendimento, dt_sinal_vital,
           dt_atualizacao, nm_usuario, qt_pa_diastolica,
           qt_pa_sistolica, ie_pressao, qt_freq_cardiaca, qt_freq_resp,
           qt_temp, ds_observacao, qt_peso, qt_imc,
           qt_superf_corporia, qt_bcf, qt_altura_cm, cd_pessoa_fisica,
           ie_membro, ie_manguito, qt_saturacao_o2,
           qt_glicemia_capilar, ie_aparelho_pa, cd_escala_dor,
           qt_escala_dor, qt_pam, qt_pvc, qt_pvc_h2o, qt_pae,
           qt_temp_incubadora, nr_seq_topografia_dor,
           qt_pressao_intra_abd, qt_pressao_intra_cranio,
           qt_perimetro_cefalico, nr_cirurgia, qt_insulina,
           ie_ritmo_ecg, qt_segmento_st, qt_maec, ie_sitio, ie_rn,
          qt_perimetro_toracico, qt_perimitro_abdominal, ie_lado,
          nr_hora, ie_relevante_apap, cd_paciente, dt_liberacao,
          ie_situacao, dt_inativacao, nm_usuario_inativacao,
          ds_justificativa, dt_referencia, ie_decubito, nr_seq_saep,
          cd_setor_atendimento, nr_seq_assinatura, nr_seq_condicao_dor,
          nr_seq_reg_elemento, qt_bilirrubina_tronco,
          qt_bilirrubina_fronte, qt_pupila_tamanho,
          ie_pupila_reacao_luz, ie_pupila_alteracao, ie_pupila_lado,
          ie_sinal_focal, ie_sinal_focal_local, cd_perfil_ativo,
          nr_seq_pepo, ie_origem_peso, ie_origem_altura, qt_peso_um,
          qt_tof_bloq_neuro_musc, ie_nivel_consciencia,
          nr_seq_intervencao, ie_rpa, qt_pupila_tam_esq,
          ie_pupila_reacao_luz_e, ie_babinski, qt_variacao_glic,
          qt_glic_media_dia, qt_glic_media_atend, qt_ppa, qt_ppc,
          qt_angulo_cabeceira, qt_perimetro_quadril,
          qt_circunf_panturrilha, qt_relacao_abd_quad, qt_circunf_braco,
          qt_prega_cutanea_triceps, qt_o2_suplementar,
          ie_unid_med_o2_suplem, nr_seq_horario, nr_seq_sinal_vital,
          nr_seq_triagem, qt_delta_peso, dt_delta_peso, ie_agitacao,
          ie_sudorese, ie_aum_trab_resp, nr_seq_assinat_inativacao,
          qt_freq_card_monit, nr_seq_result_dor, nr_seq_inapto_dor,
          ie_mae_canguru, ie_derivacao_seg_st, qt_glicose_adm,
          ie_glic_extrapol, qt_bcf_2, qt_bcf_3, qt_irradiancia,
          nr_recem_nato, ie_importado, qt_deriv_ventric_exter,
          qt_pic_temp, ie_cond_sat_o2, ie_membro_sat_o2
     FROM atendimento_sinal_vital
	 where 1 = 1
	 order by nr_atendimento;
