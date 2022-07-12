-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION cpoe_obter_diluicao_medic ( nr_atendimento_p bigint, cd_pessoa_fisica_p text default null, cd_material_p bigint DEFAULT NULL, qt_dose_p bigint DEFAULT NULL, cd_unid_med_dose_p text DEFAULT NULL, cd_intervalo_p text DEFAULT NULL, ie_via_aplicacao_p text DEFAULT NULL, qt_solucao_p bigint DEFAULT NULL, hr_min_aplicacao_p text DEFAULT NULL, ie_se_necessario_p text DEFAULT NULL, ie_fator_correcao_p text DEFAULT NULL, ie_bomba_infusao_p text DEFAULT NULL, nr_seq_mat_dil_p bigint DEFAULT NULL, cd_mat_dil_p bigint DEFAULT NULL, qt_dose_dil_p bigint DEFAULT NULL, cd_unid_med_dose_dil_p text DEFAULT NULL, qt_solucao_dil_p bigint DEFAULT NULL, nr_seq_mat_red_p bigint DEFAULT NULL, cd_mat_red_p bigint DEFAULT NULL, qt_dose_red_p bigint DEFAULT NULL, cd_unid_med_dose_red_p text DEFAULT NULL, qt_solucao_red_p bigint DEFAULT NULL, nr_seq_mat_recons_p bigint DEFAULT NULL, cd_mat_recons_p bigint DEFAULT NULL, qt_dose_recons_p bigint DEFAULT NULL, cd_unid_med_dose_recons_p text DEFAULT NULL, qt_solucao_recons_p bigint DEFAULT NULL, ie_tipo_dosagem_p text DEFAULT NULL, qt_dosagem_p bigint DEFAULT NULL, cd_estabelecimento_p bigint DEFAULT NULL, cd_perfil_p bigint DEFAULT NULL, nm_usuario_p text DEFAULT NULL) RETURNS varchar AS $body$
DECLARE

 
ds_retorno_w			varchar(4000);
qt_vel_infusao_w		double precision;
ie_tipo_dosagem_out_w	varchar(4000);
qt_minutos_aplicacao_w	double precision;


BEGIN 
 
SELECT * FROM CPOE_Dados_diluicao_medic(	nr_atendimento_p, cd_pessoa_fisica_p, cd_material_p, qt_dose_p, cd_unid_med_dose_p, cd_intervalo_p, ie_via_aplicacao_p, qt_solucao_p, hr_min_aplicacao_p, ie_se_necessario_p, ie_fator_correcao_p, ie_bomba_infusao_p, nr_seq_mat_dil_p, cd_mat_dil_p, qt_dose_dil_p, cd_unid_med_dose_dil_p, qt_solucao_dil_p, nr_seq_mat_red_p, cd_mat_red_p, qt_dose_red_p, cd_unid_med_dose_red_p, qt_solucao_red_p, nr_seq_mat_recons_p, cd_mat_recons_p, qt_dose_recons_p, cd_unid_med_dose_recons_p, qt_solucao_recons_p, ie_tipo_dosagem_p, qt_dosagem_p, cd_estabelecimento_p, cd_perfil_p, nm_usuario_p) INTO STRICT ds_retorno_w, qt_vel_infusao_w, ie_tipo_dosagem_out_w, qt_minutos_aplicacao_w;
							 
return substr(ds_retorno_w,1,2000);
 
end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION cpoe_obter_diluicao_medic ( nr_atendimento_p bigint, cd_pessoa_fisica_p text default null, cd_material_p bigint DEFAULT NULL, qt_dose_p bigint DEFAULT NULL, cd_unid_med_dose_p text DEFAULT NULL, cd_intervalo_p text DEFAULT NULL, ie_via_aplicacao_p text DEFAULT NULL, qt_solucao_p bigint DEFAULT NULL, hr_min_aplicacao_p text DEFAULT NULL, ie_se_necessario_p text DEFAULT NULL, ie_fator_correcao_p text DEFAULT NULL, ie_bomba_infusao_p text DEFAULT NULL, nr_seq_mat_dil_p bigint DEFAULT NULL, cd_mat_dil_p bigint DEFAULT NULL, qt_dose_dil_p bigint DEFAULT NULL, cd_unid_med_dose_dil_p text DEFAULT NULL, qt_solucao_dil_p bigint DEFAULT NULL, nr_seq_mat_red_p bigint DEFAULT NULL, cd_mat_red_p bigint DEFAULT NULL, qt_dose_red_p bigint DEFAULT NULL, cd_unid_med_dose_red_p text DEFAULT NULL, qt_solucao_red_p bigint DEFAULT NULL, nr_seq_mat_recons_p bigint DEFAULT NULL, cd_mat_recons_p bigint DEFAULT NULL, qt_dose_recons_p bigint DEFAULT NULL, cd_unid_med_dose_recons_p text DEFAULT NULL, qt_solucao_recons_p bigint DEFAULT NULL, ie_tipo_dosagem_p text DEFAULT NULL, qt_dosagem_p bigint DEFAULT NULL, cd_estabelecimento_p bigint DEFAULT NULL, cd_perfil_p bigint DEFAULT NULL, nm_usuario_p text DEFAULT NULL) FROM PUBLIC;
