-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE duplicar_sinal_vital ( nr_sequencia_p bigint, nm_usuario_p text, nr_sequencia_w INOUT bigint) AS $body$
BEGIN

if (nr_sequencia_p IS NOT NULL AND nr_sequencia_p::text <> '') then
	select 	nextval('atendimento_sinal_vital_seq')
	into STRICT	nr_sequencia_w
	;


	insert into atendimento_sinal_vital(
		nr_sequencia,
		dt_atualizacao,
		nm_usuario,
		nr_atendimento,
		dt_sinal_vital,
		qt_pa_diastolica,
		qt_pa_sistolica,
		ie_pressao,
		qt_freq_cardiaca,
		qt_freq_resp,
		qt_temp,
		ds_observacao,
		qt_peso,
		qt_imc,
		qt_superf_corporia,
		qt_bcf,
		qt_altura_cm,
		cd_pessoa_fisica,
		ie_membro,
		ie_manguito,
		qt_saturacao_o2,
		qt_glicemia_capilar,
		cd_escala_dor,
		qt_escala_dor,
		qt_pam,
		qt_pvc,
		qt_pae,
		qt_pvc_h2o,
		ie_aparelho_pa,
		qt_temp_incubadora,
		nr_seq_topografia_dor,
		qt_pressao_intra_abd,
		qt_pressao_intra_cranio,
		qt_perimetro_cefalico,
		ie_ritmo_ecg,
		qt_segmento_st,
		qt_insulina,
		nr_cirurgia,
		qt_maec,
		ie_sitio,
		ie_rn,
		qt_perimetro_toracico,
		qt_perimitro_abdominal,
		ie_lado,
		ie_relevante_apap,
		nr_hora,
		cd_paciente,
		ds_justificativa,
		ie_decubito,
		dt_referencia,
		nr_seq_saep,
		cd_setor_atendimento,
		nr_seq_assinatura,
		nr_seq_condicao_dor,
		nr_seq_reg_elemento,
		qt_bilirrubina_tronco,
		qt_bilirrubina_fronte,
		qt_pupila_tamanho,
		ie_pupila_reacao_luz,
		ie_pupila_alteracao,
		ie_pupila_lado,
		ie_sinal_focal,
		ie_sinal_focal_local,
		nr_seq_pepo,
		cd_perfil_ativo,
		ie_origem_peso,
		ie_origem_altura,
		qt_peso_um,
		qt_tof_bloq_neuro_musc,
		ie_nivel_consciencia,
		ie_rpa,
		nr_seq_intervencao,
		qt_pupila_tam_esq,
		ie_pupila_reacao_luz_e,
		ie_babinski,
		qt_variacao_glic,
		qt_glic_media_dia,
		qt_glic_media_atend,
		qt_ppa,
		qt_ppc,
		qt_o2_suplementar,
		ie_unid_med_o2_suplem,
		qt_perimetro_quadril,
		qt_relacao_abd_quad,
		qt_angulo_cabeceira,
		qt_circunf_panturrilha,
		qt_circunf_braco,
		qt_prega_cutanea_triceps,
		nr_seq_horario,
		nr_seq_sinal_vital,
		nr_seq_triagem,
		qt_delta_peso,
		dt_delta_peso,
		ie_agitacao,
		ie_sudorese,
		ie_aum_trab_resp,
		nr_seq_assinat_inativacao,
		nr_seq_inapto_dor,
		qt_freq_card_monit,
		nr_seq_result_dor,
		ie_mae_canguru,
		ie_derivacao_seg_st,
		ie_glic_extrapol,
		qt_glicose_adm,
		qt_irradiancia,
		qt_bcf_2,
		qt_bcf_3,
		nr_recem_nato,
		ie_importado,
		qt_deriv_ventric_exter,
		qt_pic_temp,
		ie_cond_sat_o2,
		ie_membro_sat_o2,
		ie_situacao)
	SELECT	nr_sequencia_w,
		clock_timestamp(),
		nm_usuario_p,
		nr_atendimento,
		dt_sinal_vital,
		qt_pa_diastolica,
		qt_pa_sistolica,
		ie_pressao,
		qt_freq_cardiaca,
		qt_freq_resp,
		qt_temp,
		ds_observacao,
		qt_peso,
		qt_imc,
		qt_superf_corporia,
		qt_bcf,
		qt_altura_cm,
		cd_pessoa_fisica,
		ie_membro,
		ie_manguito,
		qt_saturacao_o2,
		qt_glicemia_capilar,
		cd_escala_dor,
		qt_escala_dor,
		qt_pam,
		qt_pvc,
		qt_pae,
		qt_pvc_h2o,
		ie_aparelho_pa,
		qt_temp_incubadora,
		nr_seq_topografia_dor,
		qt_pressao_intra_abd,
		qt_pressao_intra_cranio,
		qt_perimetro_cefalico,
		ie_ritmo_ecg,
		qt_segmento_st,
		qt_insulina,
		nr_cirurgia,
		qt_maec,
		ie_sitio,
		ie_rn,
		qt_perimetro_toracico,
		qt_perimitro_abdominal,
		ie_lado,
		ie_relevante_apap,
		nr_hora,
		cd_paciente,
		ds_justificativa,
		ie_decubito,
		dt_referencia,
		nr_seq_saep,
		cd_setor_atendimento,
		nr_seq_assinatura,
		nr_seq_condicao_dor,
		nr_seq_reg_elemento,
		qt_bilirrubina_tronco,
		qt_bilirrubina_fronte,
		qt_pupila_tamanho,
		ie_pupila_reacao_luz,
		ie_pupila_alteracao,
		ie_pupila_lado,
		ie_sinal_focal,
		ie_sinal_focal_local,
		nr_seq_pepo,
		cd_perfil_ativo,
		ie_origem_peso,
		ie_origem_altura,
		qt_peso_um,
		qt_tof_bloq_neuro_musc,
		ie_nivel_consciencia,
		ie_rpa,
		nr_seq_intervencao,
		qt_pupila_tam_esq,
		ie_pupila_reacao_luz_e,
		ie_babinski,
		qt_variacao_glic,
		qt_glic_media_dia,
		qt_glic_media_atend,
		qt_ppa,
		qt_ppc,
		qt_o2_suplementar,
		ie_unid_med_o2_suplem,
		qt_perimetro_quadril,
		qt_relacao_abd_quad,
		qt_angulo_cabeceira,
		qt_circunf_panturrilha,
		qt_circunf_braco,
		qt_prega_cutanea_triceps,
		nr_seq_horario,
		nr_seq_sinal_vital,
		nr_seq_triagem,
		qt_delta_peso,
		dt_delta_peso,
		ie_agitacao,
		ie_sudorese,
		ie_aum_trab_resp,
		nr_seq_assinat_inativacao,
		nr_seq_inapto_dor,
		qt_freq_card_monit,
		nr_seq_result_dor,
		ie_mae_canguru,
		ie_derivacao_seg_st,
		ie_glic_extrapol,
		qt_glicose_adm,
		qt_irradiancia,
		qt_bcf_2,
		qt_bcf_3,
		nr_recem_nato,
		ie_importado,
		qt_deriv_ventric_exter,
		qt_pic_temp,
		ie_cond_sat_o2,
		ie_membro_sat_o2,
		'A'
	from	atendimento_sinal_vital
	where 	nr_sequencia = nr_sequencia_p;

	update 	atendimento_sinal_vital
	set	dt_inativacao 		= clock_timestamp(),
		nm_usuario_inativacao 	= nm_usuario_p,
		ie_situacao		= 'I'
	where	nr_sequencia 		= nr_sequencia_p;
end if;

commit;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE duplicar_sinal_vital ( nr_sequencia_p bigint, nm_usuario_p text, nr_sequencia_w INOUT bigint) FROM PUBLIC;
