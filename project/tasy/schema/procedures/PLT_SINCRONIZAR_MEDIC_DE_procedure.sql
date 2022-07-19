-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE plt_sincronizar_medic_de ( nm_usuario_p text, nr_atendimento_p bigint, dt_validade_limite_p timestamp, ie_obs_diferenciar_p text, dt_horario_p timestamp, nr_horario_p integer, ie_prescr_usuario_p text) AS $body$
DECLARE

				 
ds_sep_bv_w			varchar(50);
nr_prescricao_w			bigint;
nr_seq_material_w		integer;
nr_seq_horario_w		bigint;
ie_status_horario_w		varchar(15);
cd_material_w			integer;
ds_material_w			varchar(255);
ie_acm_sn_w			varchar(1);
cd_intervalo_w			varchar(7);
qt_dose_w			double precision;
nr_agrupamento_w		double precision;
ie_controlado_w			varchar(1);
ds_prescricao_w			varchar(100);
ie_status_w			varchar(1);
dt_suspensao_w			timestamp;
ie_diferenciado_w		varchar(1);
ds_dil_obs_w			varchar(2000);
nr_dia_util_w			bigint;
ds_comando_update_w		varchar(4000);
ie_lib_pend_rep_w		varchar(1);

c01 CURSOR FOR	 
SELECT	a.nr_prescricao, 
	c.nr_seq_material, 
	c.nr_sequencia, 
	SUBSTR(obter_status_hor_medic_lib(c.dt_fim_horario,c.dt_suspensao,c.ie_dose_especial,c.nr_seq_processo,c.nr_seq_area_prep,c.dt_lib_horario),1,15), 
	c.cd_material, 
	y.ds_material, 
	obter_se_acm_sn(x.ie_acm,x.ie_se_necessario) ie_acm_sn,		 
	x.cd_intervalo, 
	x.qt_dose, 
	CASE WHEN obter_se_agrupa_composto(a.nr_prescricao,c.nr_seq_material,x.nr_agrupamento,c.cd_material)='S' THEN x.nr_agrupamento  ELSE 0 END  nr_agrupamento, 
	c.ie_controlado, 
	'DE ' || to_char(x.qt_dose_especial) || ' ' || x.cd_unidade_medida_dose ds_prescricao,	 
	coalesce(x.ie_suspenso,'N') ie_suspenso, 
	c.dt_suspensao, 
	substr(coalesce(obter_se_item_dif_adep(a.nr_prescricao,c.nr_seq_material,x.nr_agrupamento,'M',ie_obs_diferenciar_p,x.ds_observacao),'N'),1,1) ie_diferenciado, 
	substr(adep_obter_inf_dil_obs(a.nr_prescricao,c.nr_seq_material),1,2000) ds_dil_obs, 
	x.nr_dia_util, 
	substr(plt_obter_lib_pend_prescr(a.dt_liberacao_medico,a.dt_liberacao,a.dt_liberacao_farmacia),1,1) 
from	material y, 
	prescr_material x, 
	prescr_mat_hor c, 
	prescr_medica a 
where	y.cd_material = x.cd_material 
and	x.nr_prescricao = c.nr_prescricao 
and	x.nr_sequencia = c.nr_seq_material	 
and	x.nr_prescricao = a.nr_prescricao 
and	c.nr_prescricao = a.nr_prescricao	 
and	a.nr_atendimento = nr_atendimento_p 
and	a.dt_validade_prescr > dt_validade_limite_p 
and	x.ie_agrupador = 1 
and	coalesce(c.ie_situacao,'A') = 'A' 
and	c.ie_agrupador = 1 
and	coalesce(x.nr_seq_kit::text, '') = '' 
and	coalesce(c.ie_dose_especial,'N') = 'S' 
and	coalesce(a.ie_adep,'S') = 'S' 
and	((coalesce(c.ie_horario_especial,'N') = 'N') or (c.dt_fim_horario IS NOT NULL AND c.dt_fim_horario::text <> '')) 
and	c.dt_horario = dt_horario_p 
and	((a.dt_liberacao_medico IS NOT NULL AND a.dt_liberacao_medico::text <> '' AND ie_prescr_usuario_p = 'N') or (a.nm_usuario_original = nm_usuario_p)) 
group by 
	a.nr_prescricao, 
	c.nr_seq_material, 
	c.nr_sequencia, 
	c.dt_fim_horario, 
	c.dt_suspensao, 
	c.ie_dose_especial, 
	c.nr_seq_processo, 
	c.nr_seq_area_prep, 
	c.cd_material, 
	y.ds_material, 
	x.ie_acm, 
	x.ie_se_necessario,		 
	x.cd_intervalo, 
	x.qt_dose, 
	x.nr_agrupamento, 
	c.ie_controlado, 
	x.qt_dose_especial, 
	x.cd_unidade_medida_dose, 
	x.ie_suspenso, 
	x.ds_observacao, 
	x.nr_dia_util, 
	c.dt_lib_horario, 
	a.dt_liberacao_medico, 
	a.dt_liberacao, 
	a.dt_liberacao_farmacia 
order by 
	c.dt_suspensao;
	

BEGIN 
ds_sep_bv_w	:= obter_separador_bv;
 
open c01;
loop 
fetch c01 into	nr_prescricao_w, 
		nr_seq_material_w, 
		nr_seq_horario_w, 
		ie_status_horario_w, 
		cd_material_w, 
		ds_material_w, 
		ie_acm_sn_w,		 
		cd_intervalo_w, 
		qt_dose_w, 
		nr_agrupamento_w, 
		ie_controlado_w, 
		ds_prescricao_w, 
		ie_status_w, 
		dt_suspensao_w, 
		ie_diferenciado_w, 
		ds_dil_obs_w, 
		nr_dia_util_w, 
		ie_lib_pend_rep_w;
EXIT WHEN NOT FOUND; /* apply on c01 */
	begin 
	ds_comando_update_w	:=	' update w_rep_t ' || 
					' set hora' || to_char(nr_horario_p) || ' = :vl_hora, ' || 
					' nr_prescricoes = adep_juntar_prescricao(nr_prescricoes,:nr_prescricao), ' || 
					' ie_diferenciado = :ie_diferenciado, ' || 
					' ds_diluicao = :ds_dil_obs, ' || 
					' ie_medic_controlado = :ie_controlado, ' || 
					' nr_dia_util = :nr_dia_util ' || 
					' where nm_usuario = :nm_usuario ' || 
					' and ie_tipo_item = :ie_tipo ' || 
					' and nvl(nr_prescricao,nvl(:nr_prescricao,0)) = nvl(:nr_prescricao,0) ' || 
					' and nvl(nr_seq_item,nvl(:nr_seq_item,0)) = nvl(:nr_seq_item,0) ' ||					 
					' and cd_item = :cd_item ' || 
					' and ie_pendente_liberacao = :ie_pendente_liberacao ' ||					 
					' and nvl(cd_intervalo,0) = nvl(:cd_intervalo,0) ' || 
					' and nvl(qt_item,0) = nvl(:qt_item,0) ' || 
					' and nvl(nr_agrupamento,0) = nvl(:nr_agrupamento,0) ' || 
					' and ((ds_prescricao = :ds_prescricao) or (ds_prescricao is null)) ';
				 
	CALL exec_sql_dinamico_bv('PLT', ds_comando_update_w,	'vl_hora=S' || to_char(nr_seq_horario_w) || 'H' || ie_status_horario_w || ds_sep_bv_w || 
								'nr_prescricao=' || to_char(nr_prescricao_w) || ds_sep_bv_w || 
								'ie_diferenciado=' || ie_diferenciado_w || ds_sep_bv_w || 
								'ds_dil_obs=' || ds_dil_obs_w || ds_sep_bv_w || 
								'ie_controlado=' || ie_controlado_w || ds_sep_bv_w || 
								'nr_dia_util=' || to_char(nr_dia_util_w) || ds_sep_bv_w || 
								'nm_usuario=' || nm_usuario_p || ds_sep_bv_w || 
								'ie_tipo=M' || ds_sep_bv_w || 
								'nr_seq_item='|| to_char(nr_seq_material_w) || ds_sep_bv_w || 
								'cd_item=' || to_char(cd_material_w) || ds_sep_bv_w || 
								'ie_pendente_liberacao=' || ie_lib_pend_rep_w || ds_sep_bv_w ||								 
								'cd_intervalo=' || cd_intervalo_w || ds_sep_bv_w || 
								'qt_item=' || to_char(qt_dose_w) || ds_sep_bv_w || 
								'nr_agrupamento=' || to_char(nr_agrupamento_w) || ds_sep_bv_w || 
								'ds_prescricao=' || ds_prescricao_w || ds_sep_bv_w );
	end;
end loop;
close c01;
end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE plt_sincronizar_medic_de ( nm_usuario_p text, nr_atendimento_p bigint, dt_validade_limite_p timestamp, ie_obs_diferenciar_p text, dt_horario_p timestamp, nr_horario_p integer, ie_prescr_usuario_p text) FROM PUBLIC;

