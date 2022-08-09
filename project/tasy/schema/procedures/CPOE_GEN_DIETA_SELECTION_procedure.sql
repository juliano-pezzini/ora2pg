-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE cpoe_gen_dieta_selection ( cd_estabelecimento_p bigint, cd_perfil_p bigint, nm_usuario_p text, cd_material_p bigint default null, cd_dieta_p bigint default null, nr_seq_tipo_p bigint default null, nr_seq_item_p bigint DEFAULT NULL, nr_atendimento_p bigint DEFAULT NULL, ie_tipo_dieta_p text DEFAULT NULL, cd_paciente_p text default null, nr_seq_item_gerado_p INOUT bigint DEFAULT NULL, ie_prescritor_aux_p text default 'N', cd_medico_p bigint default null, ie_continuo_p text default null, nr_seq_cpoe_order_unit_p bigint default null, nr_seq_perfil_cal_p bigint default null) AS $body$
BEGIN

	if (ie_tipo_dieta_p = 'E') then
		nr_seq_item_gerado_p := CPOE_GEN_DIETA_ENTERAL_SELEC(nr_atendimento_p, cd_paciente_p, cd_material_p, cd_estabelecimento_p, cd_perfil_p, nm_usuario_p, nr_seq_item_gerado_p, ie_prescritor_aux_p, cd_medico_p, ie_continuo_p, nr_seq_cpoe_order_unit_p);
	elsif (ie_tipo_dieta_p = 'S') then
		nr_seq_item_gerado_p := CPOE_GEN_DIETA_SUPLEMENT_SELEC(	nr_atendimento_p, cd_material_p, cd_estabelecimento_p, cd_perfil_p, nm_usuario_p, cd_paciente_p, nr_seq_item_gerado_p, ie_prescritor_aux_p, cd_medico_p, nr_seq_cpoe_order_unit_p);
	elsif (ie_tipo_dieta_p = 'J') then
		nr_seq_item_gerado_p := CPOE_GEN_DIETA_FASTING_SELEC(	nr_atendimento_p, nr_seq_tipo_p, cd_estabelecimento_p, cd_perfil_p, nm_usuario_p, cd_paciente_p, nr_seq_item_gerado_p, ie_prescritor_aux_p, cd_medico_p, nr_seq_cpoe_order_unit_p);								
	elsif (ie_tipo_dieta_p = 'O') then
		nr_seq_item_gerado_p := CPOE_GEN_DIETA_ORAL_SELEC(	nr_atendimento_p, cd_dieta_p, cd_estabelecimento_p, cd_perfil_p, nm_usuario_p, cd_paciente_p, nr_seq_item_gerado_p, ie_prescritor_aux_p, cd_medico_p, nr_seq_cpoe_order_unit_p, nr_seq_perfil_cal_p);
	elsif (ie_tipo_dieta_p = 'L') then
		nr_seq_item_gerado_p := CPOE_GEN_DIETA_LEITE_SELEC(	cd_estabelecimento_p, cd_perfil_p, nm_usuario_p, nr_atendimento_p, nr_seq_item_gerado_p, cd_paciente_p, ie_prescritor_aux_p, cd_medico_p, nr_seq_cpoe_order_unit_p);

end if;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE cpoe_gen_dieta_selection ( cd_estabelecimento_p bigint, cd_perfil_p bigint, nm_usuario_p text, cd_material_p bigint default null, cd_dieta_p bigint default null, nr_seq_tipo_p bigint default null, nr_seq_item_p bigint DEFAULT NULL, nr_atendimento_p bigint DEFAULT NULL, ie_tipo_dieta_p text DEFAULT NULL, cd_paciente_p text default null, nr_seq_item_gerado_p INOUT bigint DEFAULT NULL, ie_prescritor_aux_p text default 'N', cd_medico_p bigint default null, ie_continuo_p text default null, nr_seq_cpoe_order_unit_p bigint default null, nr_seq_perfil_cal_p bigint default null) FROM PUBLIC;
