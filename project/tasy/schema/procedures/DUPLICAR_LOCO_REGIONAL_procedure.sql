-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE duplicar_loco_regional ( nr_sequencia_p bigint, nm_usuario_p text, nr_sequencia_dest_p INOUT bigint ) AS $body$
BEGIN

if (nr_sequencia_p IS NOT NULL AND nr_sequencia_p::text <> '') then

	select	nextval('can_loco_regional_seq')
	into STRICT 	nr_sequencia_dest_p 
	;

	insert	into can_loco_regional(
		nr_sequencia,
		cd_estabelecimento,
		cd_pessoa_fisica,
		dt_atualizacao,
		nm_usuario,
		cd_medico,
		nr_atendimento,
		cd_morfologia,
		cd_topografia,
		cd_estadiamento,
		cd_tumor_primario,
		cd_linfonodo_regional,
		cd_metastase_distancia,
		qt_peso,
		qt_altura,
		qt_auc,
		qt_creatinina,
		ie_l_dl_creatinina,
		qt_clearance_creatinina,
		qt_mg_carboplatina,
		cd_tumor_prim_pat,
		cd_linfonodo_reg_pat,
		cd_metastase_dist_pat,
		cd_estadio_outro,
		qt_redutor_sc,
		dt_atualizacao_nrec,
		nm_usuario_nrec,
		dt_avaliacao,
		ie_perfor_staus_zubrod,
		ie_karnofski,
		ds_exame_fisico,
		ds_loco_regional,
		ds_aparelho_ganglionar,
		cd_doenca_cid,
		ds_diag_histologico,
		ds_outro_sistema,
		ds_observacao,
		ds_proposta_terapeutica,
		dt_ptnm,
		ie_nivel_ecog,
		ie_situacao,
		cd_linfatico,
		cd_vascular,
		cd_perineural,
		cd_tumor_residual,
		ie_tipo_tnm,
		cd_dunkes,
		cd_mac,
		cd_categoria,
		cd_grau_histo,
		cd_linfatico_pat,
		cd_vascular_pat,
		cd_perineural_pat,
		cd_tumor_residual_pat,
		ie_tipo_tnm_pat,
		cd_dunkes_pat,
		cd_mac_pat,
		cd_categoria_pat,
		cd_grau_histo_pat,
		dt_diag_histopatologico,
		ds_exame_complementar,
		ds_linfonodo,
		ds_imunohistoquimica,
		ds_metastase)
	SELECT	nr_sequencia_dest_p,
		cd_estabelecimento,
		cd_pessoa_fisica,
		clock_timestamp(),
		nm_usuario_p,
		cd_medico,
		nr_atendimento,
		cd_morfologia,
		cd_topografia,
		cd_estadiamento,
		cd_tumor_primario,
		cd_linfonodo_regional,
		cd_metastase_distancia,
		qt_peso,
		qt_altura,
		qt_auc,
		qt_creatinina,
		ie_l_dl_creatinina,
		qt_clearance_creatinina,
		qt_mg_carboplatina,
		cd_tumor_prim_pat,
		cd_linfonodo_reg_pat,
		cd_metastase_dist_pat,
		cd_estadio_outro,
		qt_redutor_sc,
		clock_timestamp(),
		nm_usuario_p,
		clock_timestamp(),
		ie_perfor_staus_zubrod,
		ie_karnofski,
		ds_exame_fisico,
		ds_loco_regional,
		ds_aparelho_ganglionar,
		cd_doenca_cid,
		ds_diag_histologico,
		ds_outro_sistema,
		ds_observacao,
		ds_proposta_terapeutica,
		dt_ptnm,
		ie_nivel_ecog,
		'A',
		cd_linfatico,
		cd_vascular,
		cd_perineural,
		cd_tumor_residual,
		ie_tipo_tnm,
		cd_dunkes,
		cd_mac,
		cd_categoria,
		cd_grau_histo,
		cd_linfatico_pat,
		cd_vascular_pat,
		cd_perineural_pat,
		cd_tumor_residual_pat,
		ie_tipo_tnm_pat,
		cd_dunkes_pat,
		cd_mac_pat,
		cd_categoria_pat,
		cd_grau_histo_pat,
		dt_diag_histopatologico,
		ds_exame_complementar,
		ds_linfonodo,
		ds_imunohistoquimica,
		ds_metastase		
	from	can_loco_regional
	where	nr_sequencia = nr_sequencia_p;
end if;

commit;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE duplicar_loco_regional ( nr_sequencia_p bigint, nm_usuario_p text, nr_sequencia_dest_p INOUT bigint ) FROM PUBLIC;

