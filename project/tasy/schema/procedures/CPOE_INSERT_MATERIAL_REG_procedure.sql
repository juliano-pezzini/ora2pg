-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE cpoe_insert_material_reg ( nr_atendimento_p atendimento_paciente.nr_atendimento%type, nr_prescricao_p prescr_medica.nr_prescricao%type, nr_seq_reg_item_p cpoe_material.nr_sequencia%type, cd_estabelecimento_p estabelecimento.cd_estabelecimento%type, cd_perfil_p perfil.cd_perfil%type, nm_usuario_p usuario.nm_usuario%type, ie_origem_inf_p text, dt_inicio_prescr_p timestamp, dt_inicio_ret_p INOUT timestamp, cd_pessoa_fisica_p pessoa_fisica.cd_pessoa_fisica%type default null, ie_copia_diaria_p char default 'N', ie_disp_semanal_p char default 'N') AS $body$
DECLARE

				
ie_controle_tempo_w		cpoe_material.ie_controle_tempo%type;
dt_inicio_ret_w			cpoe_material.dt_inicio%type;
ie_material_w			cpoe_material.ie_material%type;


BEGIN

select	coalesce(max(ie_controle_tempo),'N'),
		coalesce(max(ie_material),'N')
into STRICT	ie_controle_tempo_w,
		ie_material_w
from	cpoe_material
where	nr_sequencia 	= nr_seq_reg_item_P
and		((CASE WHEN coalesce(dt_lib_suspensao::text, '') = '' THEN  coalesce(dt_fim_cih,dt_fim)  ELSE coalesce(dt_suspensao,dt_fim) END  >= clock_timestamp()) or (CASE WHEN coalesce(dt_lib_suspensao::text, '') = '' THEN  coalesce(dt_fim_cih,dt_fim)  ELSE coalesce(dt_suspensao,dt_fim) coalesce(END::text, '') = '') or (coalesce(ie_retrogrado,'N') = 'S' AND dt_inicio >= dt_inicio_prescr_p)); -- retrograde/backward item
if (ie_material_w = 'S') then
	dt_inicio_ret_w := cpoe_insert_materials_reg( nr_atendimento_p, nr_prescricao_p, nr_seq_reg_item_p, cd_estabelecimento_p, cd_perfil_p, nm_usuario_p, dt_inicio_prescr_p, dt_inicio_ret_w, ie_copia_diaria_p);
elsif (ie_controle_tempo_w = 'S') then
	dt_inicio_ret_w := cpoe_insert_solucoes_reg( nr_atendimento_p, nr_prescricao_p, nr_seq_reg_item_p, cd_estabelecimento_p, cd_perfil_p, nm_usuario_p, ie_origem_inf_p, dt_inicio_prescr_p, ie_copia_diaria_p, ie_disp_semanal_p);
else
	dt_inicio_ret_w := cpoe_insert_medic_reg( nr_atendimento_p, nr_prescricao_p, nr_seq_reg_item_p, cd_estabelecimento_p, cd_perfil_p, nm_usuario_p, ie_origem_inf_p, dt_inicio_prescr_p, cd_pessoa_fisica_p, ie_copia_diaria_p, ie_disp_semanal_p);
end if;

dt_inicio_ret_p := dt_inicio_ret_w;

exception when others then
	CALL gravar_log_cpoe(substr('CPOE_INSERT_MATERIAL_REG EXCEPTION:'|| substr(to_char(sqlerrm),1,2000)
		||'//nr_atendimento_p:'||nr_atendimento_p
		||'nr_prescricao_p:'||nr_prescricao_p
		||'nr_seq_reg_item_p:'||nr_seq_reg_item_p
		||'cd_estabelecimento_p'||cd_estabelecimento_p
		||'cd_perfil_p:'||cd_perfil_p
		||'nm_usuario_p : '||nm_usuario_p
		||'ie_origem_inf_p : '||ie_origem_inf_p
		||'cd_pessoa_fisica_p: ' || cd_pessoa_fisica_p
		||'ie_copia_diaria_p: ' || ie_copia_diaria_p
		||'dt_inicio_prescr_p :'||to_char(dt_inicio_prescr_p,'dd/mm/yyyy hh24:mi:ss')
		||'dt_inicio_ret_p :'||to_char(dt_inicio_ret_p,'dd/mm/yyyy hh24:mi:ss'),1,2000),
		nr_atendimento_p, 'M', nr_seq_reg_item_p);
end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE cpoe_insert_material_reg ( nr_atendimento_p atendimento_paciente.nr_atendimento%type, nr_prescricao_p prescr_medica.nr_prescricao%type, nr_seq_reg_item_p cpoe_material.nr_sequencia%type, cd_estabelecimento_p estabelecimento.cd_estabelecimento%type, cd_perfil_p perfil.cd_perfil%type, nm_usuario_p usuario.nm_usuario%type, ie_origem_inf_p text, dt_inicio_prescr_p timestamp, dt_inicio_ret_p INOUT timestamp, cd_pessoa_fisica_p pessoa_fisica.cd_pessoa_fisica%type default null, ie_copia_diaria_p char default 'N', ie_disp_semanal_p char default 'N') FROM PUBLIC;
