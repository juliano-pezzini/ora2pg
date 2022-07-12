-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION cpoe_obter_se_dieta_fav_prescr ( nr_atendimento_p bigint, nr_seq_fav_p bigint, ie_tipo_dieta_p text, ie_tipo_atendimento_p bigint, cd_setor_atendimento_p bigint, cd_perfil_p bigint, cd_convenio_p bigint, nm_usuario_p text, cd_estabelecimento_p bigint, cd_paciente_p text) RETURNS varchar AS $body$
DECLARE

						 
ie_retorno_w			varchar(255);
cd_material_w			bigint;
ie_via_aplicacao_w		varchar(15);


BEGIN 
ie_retorno_w	:= 'S';
if (ie_tipo_dieta_p in ('S','E')) then 
 
	select	cd_material, 
			ie_via_aplicacao 
	into STRICT	cd_material_w, 
			ie_via_aplicacao_w 
	from	cpoe_fav_dieta 
	where	nr_sequencia = nr_seq_fav_p;
	 
	ie_retorno_w := substr(cpoe_obter_se_medic_lib_med(nr_atendimento_p, cd_material_w, 'N', ie_via_aplicacao_w, ie_tipo_atendimento_p, cd_setor_atendimento_p, cd_perfil_p, cd_convenio_p, nm_usuario_p, cd_estabelecimento_p, cd_paciente_p, clock_timestamp()),1,255);
	 
elsif (ie_tipo_dieta_p = 'L') then 
	 
	select	cd_mat_prod1, 
			ie_via_leite1 
	into STRICT	cd_material_w, 
			ie_via_aplicacao_w 
	from	cpoe_fav_dieta 
	where	nr_sequencia = nr_seq_fav_p;
	 
	ie_retorno_w := substr(cpoe_obter_se_medic_lib_med(nr_atendimento_p, cd_material_w, 'N', ie_via_aplicacao_w, ie_tipo_atendimento_p, cd_setor_atendimento_p, cd_perfil_p, cd_convenio_p, nm_usuario_p, cd_estabelecimento_p, cd_paciente_p, clock_timestamp()),1,255);
	 
end if;
 
return ie_retorno_w;
 
end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION cpoe_obter_se_dieta_fav_prescr ( nr_atendimento_p bigint, nr_seq_fav_p bigint, ie_tipo_dieta_p text, ie_tipo_atendimento_p bigint, cd_setor_atendimento_p bigint, cd_perfil_p bigint, cd_convenio_p bigint, nm_usuario_p text, cd_estabelecimento_p bigint, cd_paciente_p text) FROM PUBLIC;

