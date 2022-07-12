-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';


CREATE TYPE r_ds_inf AS (	ds_dil_obs			varchar(2000),
								cd_material			varchar(15),
								cd_intervalo		varchar(10),
								qt_dose				double precision,
								ie_via_aplicacao	varchar(5),
								cd_unidade_medida	varchar(30),
								ie_suspenso			varchar(1),
								posicao				bigint,
								ie_obs_medica			varchar(1),
								ie_medicacao_paciente   varchar(1),
								ds_medic_nao_padr     	varchar(255),
								ds_medic_nao_padrao     varchar(255));


CREATE OR REPLACE PROCEDURE adep_gerar_horarios_pck.adep_sincronizar_medic ( cd_estabelecimento_p bigint, cd_setor_usuario_p bigint, cd_perfil_p bigint, nm_usuario_p text, nr_atendimento_p bigint, dt_inicial_horarios_p timestamp, dt_final_horarios_p timestamp, dt_validade_limite_p timestamp, ie_exibir_hor_realizados_p text, ie_exibir_hor_suspensos_p text, ie_regra_inclusao_p text, ie_data_lib_prescr_p text, ie_exibir_suspensos_p text, ie_agrupar_acm_sn_p text, ie_agrupar_dose_esp_p text, ie_obs_diferenciar_p text, dt_horario_p timestamp, nr_horario_p integer, ie_mostrar_substituido_p text, ie_prescr_setor_p text, cd_setor_paciente_p bigint, ie_agrupar_suspensos_p text, cd_item_p bigint, ie_quimio_p text, ie_palm_p text, ie_html_p text default 'N') AS $body$
DECLARE
				
	ds_sep_bv_w		varchar(50);
	nr_seq_material_w	integer;
	nr_seq_horario_w	bigint;
	ie_status_horario_w	varchar(15);
	cd_material_w		integer;
	ds_material_w		varchar(255);
	ie_acm_sn_w		varchar(1);
	cd_intervalo_w		varchar(7);
	qt_dose_w		double precision;
	nr_agrupamento_w	double precision;
	ie_controlado_w		varchar(1);
	ds_prescricao_w		varchar(240);
	ie_status_w		varchar(1);
	dt_suspensao_w		timestamp;
	ie_diferenciado_w	varchar(1);
	ds_dil_obs_w		varchar(2000);
	nr_dia_util_w		bigint;
	ds_comando_update_w	varchar(4000);
	ds_componentes_w	varchar(4000);
	ds_observacao_w		varchar(2000);
	ie_medicacao_paciente_w	varchar(1);
	cd_unidade_medida_dose_w	varchar(50);
	ie_via_aplicacao_w	varchar(5);
	ie_medic_atrasado_w	varchar(1);
	ie_quimio_w			varchar(1);
	ie_composto_w			varchar(1);
	current_setting('adep_gerar_horarios_pck.dt_horario_w')::timestamp	timestamp;
	nr_horario_w	integer;
	dt_fim_horario_w	timestamp;
	ie_horario_especial_w	varchar(1);
	ie_recem_nato_w		varchar(1) := adep_gerar_horarios_pck.get_ie_recem_nato();
	ie_item_orig_rep_w	varchar(1);
	x			integer := 1;
	ds_dil_obs_ww		varchar(4000);
	ds_item_w		varchar(400);
	ie_horario_adep_w	varchar(1);
	ie_obs_medica_w		varchar(1);
	ds_medic_nao_padr_w		prescr_material.ds_medic_nao_padr%type;	  --nome do medicamento nao padrao
	ds_medic_nao_padrao_w	prescr_material.ds_medic_nao_padrao%type; --nome do medicamento nao padronizado 'Do paciente'
	ds_texto_dilu_w		varchar(2000);
	cd_motivo_baixa_w	prescr_material.cd_motivo_baixa%type;
	type V_ds_inf is table of r_ds_inf index by integer;
	vt_ds_inf_w		V_ds_inf;
	nr_seq_mat_cpoe_w	prescr_material.nr_seq_mat_cpoe%type;
	ie_regra_disp_w		varchar(5);
	dt_suspensao_cpoe_w	timestamp;
	ie_medic_kit_w	varchar(1) := 'N';
	c01 CURSOR FOR
	SELECT	a.nr_prescricao,
			c.nr_seq_material,
			c.nr_sequencia,
			CASE WHEN   coalesce(c.dt_primeira_checagem::text, '') = '' THEN 				CASE WHEN   coalesce(c.dt_recusa::text, '') = '' THEN 						  CASE WHEN get_ie_usa_status_gedipa='S' THEN  								substr(obter_status_hor_medic(c.dt_fim_horario,c.dt_suspensao,c.ie_dose_especial,c.nr_seq_processo,c.nr_seq_area_prep,c.nr_sequencia),1,15)  ELSE substr(obter_status_hor_medic(c.dt_fim_horario,c.dt_suspensao,c.ie_dose_especial,null,null,c.nr_sequencia),1,15) END   ELSE substr(obter_status_recusa_pac(c.dt_fim_horario,c.dt_suspensao),1,15) END   ELSE CASE WHEN obter_status_prim_check(c.dt_primeira_checagem,c.dt_fim_horario,c.dt_suspensao,c.dt_recusa)='S' THEN  'Q'  ELSE CASE WHEN coalesce(c.dt_recusa::text, '') = '' THEN 				substr(obter_status_hor_medic(c.dt_fim_horario,c.dt_suspensao,c.ie_dose_especial,c.nr_seq_processo,c.nr_seq_area_prep,c.nr_sequencia),1,15)  ELSE substr(obter_status_recusa_pac(c.dt_fim_horario,c.dt_suspensao),1,15) END  END  END ,
			c.cd_material,
			y.ds_material,
			obter_se_acm_sn(x.ie_acm,x.ie_se_necessario) ie_acm_sn,		
			x.cd_intervalo,
			CASE WHEN coalesce(ie_palm_p,'N')='S' THEN CASE WHEN coalesce(c.ie_dose_especial,'N')='S' THEN c.qt_dose  ELSE CASE WHEN coalesce(x.qt_dose,0)=0 THEN c.qt_dose  ELSE x.qt_dose END  END   ELSE x.qt_dose END  qt_dose,
			CASE WHEN obter_se_agrupa_composto(a.nr_prescricao,c.nr_seq_material,x.nr_agrupamento,c.cd_material)='S' THEN  coalesce(obter_agrupamento_composto(a.nr_prescricao, c.cd_material, x.nr_seq_mat_cpoe), x.nr_agrupamento)  ELSE 0 END  nr_agrupamento,
			c.ie_controlado,
			substr(adep_obter_um_dosagem_prescr(a.nr_prescricao,c.nr_seq_material,x.ie_acm,x.ie_se_necessario),1,250) ds_prescricao,
			coalesce(x.ie_suspenso,'N') ie_suspenso,
			c.dt_suspensao,
			substr(coalesce(obter_se_item_dif_adep(a.nr_prescricao,c.nr_seq_material,x.nr_agrupamento,'M',ie_obs_diferenciar_p,x.ds_observacao),'N'),1,1) ie_diferenciado,
			substr(get_cpoe_notes(nr_seq_mat_cpoe) || CASE WHEN get_ie_gravar_diluicao_sol='S' THEN  substr(adep_obter_inf_dil_obs(a.nr_prescricao,c.nr_seq_material),1,2000)  ELSE CASE WHEN substr(adep_obter_inf_dil_obs(a.nr_prescricao,c.nr_seq_material),1,2000) IS NULL THEN  null  ELSE ds_texto_dilu_w END  END ,1,2000) ds_dil_obs,
			x.nr_dia_util,
			coalesce(x.ie_medicacao_paciente,'N'),
			substr(get_cpoe_notes(nr_seq_mat_cpoe) || adep_obter_inf_dil_obs(a.nr_prescricao,c.nr_seq_material),1,2000) ds_componentes,
			c.dt_horario,
			c.dt_fim_horario,
			coalesce(c.ie_horario_especial,'N'),
			CASE WHEN coalesce(a.nr_seq_atend::text, '') = '' THEN 'N'  ELSE 'S' END ,
			coalesce(VIPE_obter_se_medic_composto(a.nr_prescricao, x.nr_sequencia, x.nr_agrupamento, 'A'),'N'),
			x.cd_unidade_medida_dose,
			x.ie_via_aplicacao,
			substr(x.ds_observacao,1,2000) ds_observacao,
			substr(VIPE_obter_se_medic_composto(a.nr_prescricao, x.nr_sequencia, x.nr_agrupamento, 'D') || CASE WHEN coalesce(x.ie_lado, '')='N' THEN  '' WHEN coalesce(x.ie_lado, '')='' THEN  ''  ELSE ' (' || obter_desc_expressao(292416) || ': ' || obter_valor_dominio(1372,x.ie_lado) || ')' END ,1,240) ds_material,
			coalesce(c.ie_horario_adep,'S') ie_horario_adep,
			CASE WHEN trim(both coalesce(x.ds_observacao,x.ds_observacao_enf)) IS NULL THEN ''  ELSE 'S' END ,
			substr(coalesce(x.ds_medic_nao_padr, ''), 1,255) ds_medic_nao_padr,
			substr(coalesce(x.ds_medic_nao_padrao, ''), 1,255) ds_medic_nao_padrao,
			CASE WHEN adep_gerar_horarios_pck.get_nr_seq_cpoe_medic(a.nr_prescricao, a.nr_seq_atend, ie_html_p)='S' THEN  x.nr_seq_mat_cpoe  ELSE null END  nr_seq_mat_cpoe,
			CASE WHEN x.ie_regra_disp='E' THEN 'E'  ELSE null END  ie_regra_disp,
			CASE WHEN get_usa_legenda_item_baixado='S' THEN 			CASE WHEN obter_se_acm_sn(x.ie_acm,x.ie_se_necessario)='S' THEN  CASE WHEN coalesce(x.cd_motivo_baixa,0)=0 THEN  null  ELSE CASE WHEN obter_se_aprazou_hor(c.nr_prescricao, c.nr_seq_material, 'M')='S' THEN  x.cd_motivo_baixa  ELSE null END  END   ELSE x.cd_motivo_baixa END   ELSE null END ,
			obter_se_rep_cpoe(a.nr_prescricao) ie_item_origem_rep
	from	material y,
		prescr_material x,
		prescr_mat_hor c,
		prescr_medica a
	where	y.cd_material = x.cd_material
	and	x.nr_prescricao = c.nr_prescricao
	and	x.nr_sequencia = c.nr_seq_material	
	and	x.nr_prescricao = a.nr_prescricao
	and	c.nr_prescricao = a.nr_prescricao	
	and	obter_se_exibir_rep_adep_setor(cd_setor_paciente_p,a.cd_setor_atendimento,coalesce(a.ie_adep,'S')) = 'S'
	and	a.nr_atendimento = nr_atendimento_p
	and	coalesce(a.ie_hemodialise, 'N') <> 'R'
	and	((coalesce(a.ie_recem_nato,'N')	= 'N') or (ie_recem_nato_w = 'S'))	
	and	((coalesce(x.nr_seq_kit::text, '') = '') or ((getie_apres_kit = 'S') and (coalesce(ie_palm_p,'N') = 'N')))
	and	a.dt_validade_prescr between dt_validade_limite_p and dt_fim_w
	and	obter_se_prescr_lib_adep(coalesce(a.dt_liberacao_medico,x.dt_lib_material), coalesce(a.dt_liberacao,x.dt_lib_material), coalesce(a.dt_liberacao_farmacia,x.dt_lib_material), ie_data_lib_prescr_p, a.ie_lib_farm) = 'S'
	and	x.ie_agrupador = 1
	and	coalesce(cd_item_p,x.cd_material) = x.cd_material
	and	((ie_exibir_suspensos_p = 'S') or (coalesce(x.dt_suspensao::text, '') = ''))
	and	((obter_se_gerar_item_adep('M',a.nr_prescricao,c.nr_seq_material,x.nr_agrupamento,getie_apres_kit) = 'S') or
		(x.nr_seq_substituto IS NOT NULL AND x.nr_seq_substituto::text <> '' AND ie_mostrar_substituido_p	= 'S'))		
	and	coalesce(c.ie_situacao,'A') = 'A'
	and	coalesce(c.ie_adep,'S') = 'S'
	and	coalesce(x.ie_administrar,'S') <> 'N'
	and	c.ie_agrupador = 1
	and	((ie_mostrar_substituido_p	= 'S') or (coalesce(x.nr_seq_substituto::text, '') = ''))
	and	((ie_agrupar_dose_esp_p = 'S') or (coalesce(c.ie_dose_especial,'N') = 'N'))
	and	((ie_exibir_hor_realizados_p = 'S') or (coalesce(c.dt_fim_horario::text, '') = ''))
	and	((ie_exibir_hor_suspensos_p = 'S') or (coalesce(c.dt_suspensao::text, '') = ''))
	and	((ie_regra_inclusao_p = 'S') or
		 ((ie_regra_inclusao_p = 'R') and (adep_obter_regra_inclusao(	'MED', 
																		cd_estabelecimento_p, 
																		cd_setor_usuario_p, 
																		cd_perfil_p, 
																		c.cd_material, 
																		null, 
																		null, 
																		null,
																		a.cd_Setor_atendimento,
																		null, 
																		a.nr_prescricao,
																		null) = 'S'))) -- nr_seq_exame_p
	and	((c.dt_horario between dt_horario_inicio_sinc_w and dt_horario_fim_sinc_w) or (coalesce(c.ie_horario_especial,'N') = 'S'))
	and	((ie_prescr_setor_p = 'N') or (ie_prescr_setor_p = 'S' AND a.cd_setor_atendimento = cd_setor_paciente_p))
	and	Obter_se_horario_liberado(c.dt_lib_horario, c.dt_horario) = 'S'
	and	((get_ie_vigente = 'N') or (clock_timestamp() between a.dt_inicio_prescr and a.dt_validade_prescr + get_minutos_vigente/1440))
	and	((ie_quimio_p = 'S') or (coalesce(a.nr_seq_atend::text, '') = ''))
	and not exists (SELECT 1 
					  from cpoe_material m,
						   cpoe_hemoterapia h
					 where m.nr_sequencia = x.nr_seq_mat_cpoe
					   and h.nr_sequencia = m.nr_seq_hemoterapia)	 	
	group by
		c.dt_horario,
		a.nr_prescricao,
		c.nr_seq_material,
		c.nr_sequencia,
		c.dt_fim_horario,
		c.dt_suspensao,
		c.ie_dose_especial,
		c.nr_seq_processo,
		c.nr_seq_area_prep,
		substr(VIPE_obter_se_medic_composto(a.nr_prescricao, x.nr_sequencia, x.nr_agrupamento, 'D') || CASE WHEN coalesce(x.ie_lado, '')='N' THEN  '' WHEN coalesce(x.ie_lado, '')='' THEN  ''  ELSE ' (' || obter_desc_expressao(292416) || ': ' || obter_valor_dominio(1372,x.ie_lado) || ')' END ,1,240),
		c.cd_material,
		y.ds_material,
		x.ie_acm,
		x.ie_se_necessario,		
		x.cd_intervalo,
		c.dt_fim_horario,
		coalesce(c.ie_horario_especial,'N'),
		CASE WHEN coalesce(ie_palm_p,'N')='S' THEN CASE WHEN coalesce(c.ie_dose_especial,'N')='S' THEN c.qt_dose  ELSE CASE WHEN coalesce(x.qt_dose,0)=0 THEN c.qt_dose  ELSE x.qt_dose END  END   ELSE x.qt_dose END  ,
		x.nr_agrupamento,
		c.ie_controlado,
		x.ie_suspenso,
		x.ds_observacao,
		x.nr_dia_util,
		x.ie_medicacao_paciente,
		c.dt_recusa,
		x.cd_unidade_medida_dose,
		x.ie_via_aplicacao,
		c.dt_primeira_checagem,
		CASE WHEN coalesce(nr_seq_atend::text, '') = '' THEN 'N'  ELSE 'S' END ,
		coalesce(VIPE_obter_se_medic_composto(a.nr_prescricao, x.nr_sequencia, x.nr_agrupamento, 'A'),'N'),
		c.ie_horario_adep,
		x.ds_observacao_enf,
		substr(coalesce(x.ds_medic_nao_padr, ''), 1,255),
		substr(coalesce(x.ds_medic_nao_padrao, ''), 1,255),
		nr_seq_mat_cpoe,
		CASE WHEN x.ie_regra_disp='E' THEN 'E'  ELSE null END ,
		CASE WHEN get_usa_legenda_item_baixado='S' THEN 		CASE WHEN obter_se_acm_sn(x.ie_acm,x.ie_se_necessario)='S' THEN  CASE WHEN coalesce(x.cd_motivo_baixa,0)=0 THEN  null  ELSE CASE WHEN obter_se_aprazou_hor(c.nr_prescricao, c.nr_seq_material, 'M')='S' THEN  x.cd_motivo_baixa  ELSE null END  END   ELSE x.cd_motivo_baixa END   ELSE null END ,
		adep_gerar_horarios_pck.get_nr_seq_cpoe_medic(a.nr_prescricao, a.nr_seq_atend, ie_html_p),
		substr(adep_obter_um_dosagem_prescr(a.nr_prescricao,c.nr_seq_material,x.ie_acm,x.ie_se_necessario),1,250)
	order by 
		c.dt_horario,
		c.dt_suspensao;
	
BEGIN
	ds_sep_bv_w	:= obter_separador_bv;
	ds_texto_dilu_w := substr(wheb_mensagem_pck.get_texto(343559),1,2000);
	open c01;
	loop
	fetch c01 into	current_setting('adep_gerar_horarios_pck.nr_prescricao_w')::prescr_medica.nr_prescricao%type,
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
			ie_medicacao_paciente_w,
			ds_componentes_w,
			current_setting('adep_gerar_horarios_pck.dt_horario_w')::timestamp,
			dt_fim_horario_w,
			ie_horario_especial_w,
			ie_quimio_w,
			ie_composto_w,
			cd_unidade_medida_dose_w,
			ie_via_aplicacao_w,
			ds_observacao_w,
			ds_item_w,
			ie_horario_adep_w,
			ie_obs_medica_w,
			ds_medic_nao_padr_w,
			ds_medic_nao_padrao_w,
			nr_seq_mat_cpoe_w,
			ie_regra_disp_w,
			cd_motivo_baixa_w,
			ie_item_orig_rep_w;
	EXIT WHEN NOT FOUND; /* apply on c01 */
		begin
        	if (current_setting('adep_gerar_horarios_pck.nr_prescricao_w')::prescr_medica.nr_prescricao%(type IS NOT NULL AND type::text <> '') and
				(nr_seq_material_w IS NOT NULL AND nr_seq_material_w::text <> '')) then
				select	coalesce(max('S'),'N') ie_item_kit
				into STRICT	ie_medic_kit_w
				from	prescr_material a
				where a.nr_prescricao = current_setting('adep_gerar_horarios_pck.nr_prescricao_w')::prescr_medica.nr_prescricao%type
        and   a.nr_sequencia = nr_seq_material_w
				and		(a.nr_seq_kit IS NOT NULL AND a.nr_seq_kit::text <> '');
			end if;
		nr_horario_w := adep_gerar_horarios_pck.get_posicao_horario(current_setting('adep_gerar_horarios_pck.dt_horario_w')::timestamp);
		--Medic
		dt_suspensao_cpoe_w := cpoe_obter_dt_suspensao(nr_seq_mat_cpoe_w, 'M');
		if	dt_suspensao_cpoe_w <= clock_timestamp() then
			ds_item_w := wheb_mensagem_pck.get_texto(820376) || ' ' || substr(ds_item_w,1,240);
		elsif (dt_suspensao_cpoe_w > clock_timestamp()) then
			ds_item_w := '(' || wheb_mensagem_pck.get_texto(1061446, 'DT_SUSPENSAO=' || TO_CHAR(dt_suspensao_cpoe_w, pkg_date_formaters.localize_mask('short', pkg_date_formaters.getUserLanguageTag(wheb_usuario_pck.get_cd_estabelecimento, wheb_usuario_pck.get_nm_usuario)))) || ') ' || substr(ds_item_w,1,240);
		end if;
		ds_dil_obs_ww := '';
		if (ds_dil_obs_w IS NOT NULL AND ds_dil_obs_w::text <> '') then
			vt_ds_inf_w[x].ds_dil_obs	:= ds_dil_obs_w;
			vt_ds_inf_w[x].cd_material	:= cd_material_w;
			vt_ds_inf_w[x].cd_intervalo	:= cd_intervalo_w;
			vt_ds_inf_w[x].ie_via_aplicacao	:= ie_via_aplicacao_w;
			vt_ds_inf_w[x].cd_unidade_medida	:= cd_unidade_medida_dose_w;
			vt_ds_inf_w[x].qt_dose		:= qt_dose_w;
			vt_ds_inf_w[x].ie_suspenso	:= ie_status_w;
			vt_ds_inf_w[x].posicao		:= x;
			vt_ds_inf_w[x].ie_obs_medica	:= ie_obs_medica_w;
			vt_ds_inf_w[x].ie_medicacao_paciente := ie_medicacao_paciente_w;
			vt_ds_inf_w[x].ds_medic_nao_padr	 := ds_medic_nao_padr_w;
			vt_ds_inf_w[x].ds_medic_nao_padrao	 := ds_medic_nao_padrao_w; 			
		end if;
		for i in 1..vt_ds_inf_w.count loop
			begin
			if (vt_ds_inf_w[i].cd_material	= cd_material_w) and (vt_ds_inf_w[i].cd_intervalo	= cd_intervalo_w) and (vt_ds_inf_w[i].qt_dose		= qt_dose_w) and				
				(((ie_medicacao_paciente_w = 'S') or (coalesce(ds_medic_nao_padr_w::text, '') = ''))  or (vt_ds_inf_w[i].ds_medic_nao_padr		= ds_medic_nao_padr_w) or (vt_ds_inf_w[i].ds_medic_nao_padrao		= ds_medic_nao_padrao_w)) and (coalesce(vt_ds_inf_w[i].ie_via_aplicacao,'XPTO') = coalesce(ie_via_aplicacao_w,'XPTO')) and (vt_ds_inf_w[i].cd_unidade_medida = cd_unidade_medida_dose_w) and (vt_ds_inf_w[i].ie_suspenso = ie_status_w) and (coalesce(vt_ds_inf_w[i].ie_obs_medica, 'XPTO') = coalesce(ie_obs_medica_w, 'XPTO')) then
				if (coalesce(vt_ds_inf_w[i].ds_dil_obs,'XPTO') <> coalesce(ds_dil_obs_w,'XPTO'))  then
				   ds_dil_obs_ww	:= substr(ds_dil_obs_ww || vt_ds_inf_w[i].ds_dil_obs || chr(10),1,2000);
				else
				   ds_dil_obs_ww	:= substr(ds_dil_obs_w || chr(10),1,2000);
				end if;
			end if;
			end;
		end loop;
		if (ds_dil_obs_w IS NOT NULL AND ds_dil_obs_w::text <> '') then
			x := x + 1;
		end if;

		ds_comando_update_w	:=	' update w_adep_t ' ||
						' set nr_prescricoes = adep_juntar_prescricao(nr_prescricoes,:nr_prescricao), ' ||
						' ds_diluicao = :ds_dil_obs, ' ||
						' ds_componentes = :ds_componentes ' ||
						' where nm_usuario = :nm_usuario ' ||
						' and ie_tipo_item = :ie_tipo ' ||
						' and nvl(nr_prescricao,nvl(:nr_prescricao,0)) = nvl(:nr_prescricao,0) ' ||
						' and nvl(nr_seq_item,nvl(:nr_seq_item,0)) = nvl(:nr_seq_item,0) ' ||					
						' and nvl(nr_seq_cpoe,nvl(:nr_seq_cpoe,0)) = nvl(:nr_seq_cpoe,0) ' ||					
						' and cd_item = :cd_item ' ||
						' and nvl(cd_intervalo,0) = nvl(:cd_intervalo,0) ' ||
						' and nvl(qt_item,0) = nvl(:qt_item,0) ' ||
						' and cd_unidade_medida = :cd_unidade_medida_dose ' ||
						' and nvl(ie_via_aplicacao,''XPTO'') = nvl(:ie_via_aplicacao,''XPTO'') ' || 
						' and nvl(nr_agrupamento,0) = nvl(:nr_agrupamento,0) ' ||
						' and nvl(cd_motivo_baixa,0) = nvl(:cd_motivo_baixa,0) ' ||
						' and ((ie_status_item is null) or (ie_status_item = :ie_status))' ||
						' and ((ds_prescricao = :ds_prescricao) or (ds_prescricao is null)) '||
						' and nvl(ie_medicacao_paciente,''N'') = :ie_medic_pac ' ||
						' and ds_item = :ds_item' ||
						' and nvl(ie_quimio,''N'') = :ie_quimio ' ||
						' and nvl(ie_composto,''N'') = :ie_composto ' ||
						' and nvl(ie_regra_disp,''XPTO'') = nvl(:ie_regra_disp,''XPTO'') ' || 						
						' and nvl(ds_observacao,''XPTO'') = nvl(:ds_observacao,''XPTO'') ' ||
						' and ((nr_seq_cpoe is null and (:ie_item_orig_rep = ''N'' or :ie_medic_kit = ''S'')) ' ||			
						' or (nr_seq_cpoe is not null))';
		CALL exec_sql_dinamico_bv('ADEP', ds_comando_update_w,	'nr_prescricao=' || to_char(current_setting('adep_gerar_horarios_pck.nr_prescricao_w')::prescr_medica.nr_prescricao%type) || ds_sep_bv_w ||
									'ds_dil_obs=' || ds_dil_obs_ww || ds_sep_bv_w || 
									'nm_usuario=' || nm_usuario_p || ds_sep_bv_w || 
									'ie_tipo=M' || ds_sep_bv_w ||
									'nr_seq_item='|| to_char(nr_seq_material_w) || ds_sep_bv_w ||
									'nr_seq_cpoe='|| to_char(nr_seq_mat_cpoe_w) || ds_sep_bv_w ||
									'cd_item=' || to_char(cd_material_w) || ds_sep_bv_w ||
									'cd_motivo_baixa=' || cd_motivo_baixa_w || ds_sep_bv_w ||
									'cd_intervalo=' || cd_intervalo_w  || ds_sep_bv_w ||
									'qt_item=' || to_char(qt_dose_w) || ds_sep_bv_w ||
									'cd_unidade_medida_dose=' || cd_unidade_medida_dose_w || ds_sep_bv_w ||
									'ie_via_aplicacao=' || ie_via_aplicacao_w || ds_sep_bv_w ||
									'nr_agrupamento=' || to_char(nr_agrupamento_w) || ds_sep_bv_w ||
									'ie_status=' || ie_status_w || ds_sep_bv_w ||
									'ds_prescricao=' || ds_prescricao_w || ds_sep_bv_w ||
									'ie_medic_pac=' || ie_medicacao_paciente_w || ds_sep_bv_w ||
									'ds_componentes=' || ds_componentes_w || ds_sep_bv_w ||
									'ds_item=' || ds_item_w || ds_sep_bv_w ||
									'ie_quimio=' || ie_quimio_w || ds_sep_bv_w ||
									'ie_composto=' || ie_composto_w || ds_sep_bv_w ||
									'ie_regra_disp=' || ie_regra_disp_w || ds_sep_bv_w ||									
									'ds_observacao=' || ds_observacao_w || ds_sep_bv_w ||
                  'ie_medic_kit=' || ie_medic_kit_w || ds_sep_bv_w ||
									'ie_item_orig_rep=' || ie_item_orig_rep_w || ds_sep_bv_w);
		commit;
		if (nr_horario_w IS NOT NULL AND nr_horario_w::text <> '') and (ie_horario_adep_w	= 'S') and
			((dt_fim_horario_w IS NOT NULL AND dt_fim_horario_w::text <> '') or (ie_horario_especial_w = 'N')) then
			ie_medic_atrasado_w := 'N';
			if (ie_status_horario_w not in ('A', 'S')) and (coalesce(get_qt_minutos_atraso,0) > 0) then
				select 	obter_se_medic_atraso_adep(nr_seq_horario_w, ie_status_horario_w, get_qt_minutos_atraso)
				into STRICT	ie_medic_atrasado_w
				;
			end if;
			ds_comando_update_w	:=	' update w_adep_t ' ||
							' set hora' || to_char(nr_horario_w) || ' = :vl_hora, ' ||
							' nr_prescricoes = adep_juntar_prescricao(nr_prescricoes,:nr_prescricao), ' ||
							' ds_horarios = adep_atualizar_inf_horarios(ds_horarios,:nr_horario,:vl_hora), ' ||
							' ie_diferenciado = :ie_diferenciado, ' ||
							' ds_diluicao = :ds_dil_obs, ' ||
							' ds_componentes = :ds_componentes, ' ||
							' ie_medic_controlado = :ie_controlado, ' ||
							' nr_dia_util = :nr_dia_util, ' ||
							' ie_atrasado = :ie_atrasado ' ||
							' where nm_usuario = :nm_usuario ' ||
							' and ie_tipo_item = :ie_tipo ' ||
							' and nvl(nr_prescricao,nvl(:nr_prescricao,0)) = nvl(:nr_prescricao,0) ' ||
							' and nvl(nr_seq_item,nvl(:nr_seq_item,0)) = nvl(:nr_seq_item,0) ' ||		
							' and nvl(nr_seq_cpoe,nvl(:nr_seq_cpoe,0)) = nvl(:nr_seq_cpoe,0) ' ||												
							' and cd_item = :cd_item ' ||
							' and nvl(cd_motivo_baixa,0) = nvl(:cd_motivo_baixa,0) ' ||
							' and nvl(cd_intervalo,0) = nvl(:cd_intervalo,0) ' ||
							' and nvl(qt_item,0) = nvl(:qt_item,0) ' ||
							' and cd_unidade_medida = :cd_unidade_medida_dose ' || 
							' and nvl(ie_via_aplicacao,''XPTO'') = nvl(:ie_via_aplicacao,''XPTO'') ' || 
							' and nvl(nr_agrupamento,0) = nvl(:nr_agrupamento,0) ' ||
							' and ((ie_status_item is null) or (ie_status_item = :ie_status))' ||
							' and ((ds_prescricao = :ds_prescricao) or (ds_prescricao is null)) '||
							' and nvl(ie_medicacao_paciente,''N'') = :ie_medic_pac ' ||
							' and ds_item = :ds_item' ||
							' and nvl(ie_quimio,''N'') = :ie_quimio	' ||
							' and nvl(ie_composto,''N'') = :ie_composto ' ||
							' and nvl(ie_regra_disp,''XPTO'') = nvl(:ie_regra_disp,''XPTO'') ' || 						
							' and nvl(ds_observacao,''XPTO'') = nvl(:ds_observacao,''XPTO'') ' ||
							' and ((nr_seq_cpoe is null and (:ie_item_orig_rep = ''N'' or :ie_medic_kit = ''S'')) ' ||						
							' or (nr_seq_cpoe is not null))';
							--' and ((ds_observacao is null) or (ds_observacao = :ds_observacao)) ';
			CALL exec_sql_dinamico_bv('ADEP', ds_comando_update_w,	'vl_hora=S' || to_char(nr_seq_horario_w) || 'H' || ie_status_horario_w || ds_sep_bv_w ||
										'nr_prescricao=' || to_char(current_setting('adep_gerar_horarios_pck.nr_prescricao_w')::prescr_medica.nr_prescricao%type) || ds_sep_bv_w ||
										'nr_horario=' || to_char(nr_horario_p) || ds_sep_bv_w || 
										'ie_diferenciado=' || ie_diferenciado_w || ds_sep_bv_w || 
										'ds_dil_obs=' || ds_dil_obs_ww || ds_sep_bv_w || 
										'ds_componentes=' || ds_componentes_w || ds_sep_bv_w || 
										'ie_controlado=' || ie_controlado_w || ds_sep_bv_w || 
										'nr_dia_util=' || to_char(nr_dia_util_w) || ds_sep_bv_w || 
										'ie_atrasado=' || ie_medic_atrasado_w || ds_sep_bv_w || 
										'nm_usuario=' || nm_usuario_p || ds_sep_bv_w || 
										'ie_tipo=M' || ds_sep_bv_w ||
										'nr_seq_item='|| to_char(nr_seq_material_w) || ds_sep_bv_w ||
										'nr_seq_cpoe='|| to_char(nr_seq_mat_cpoe_w) || ds_sep_bv_w ||
										'cd_item=' || to_char(cd_material_w) || ds_sep_bv_w ||
										'cd_motivo_baixa=' || cd_motivo_baixa_w || ds_sep_bv_w ||
										'cd_intervalo=' || cd_intervalo_w  || ds_sep_bv_w ||
										'qt_item=' || to_char(qt_dose_w) || ds_sep_bv_w ||
										'cd_unidade_medida_dose=' || cd_unidade_medida_dose_w || ds_sep_bv_w ||
										'ie_via_aplicacao=' || ie_via_aplicacao_w || ds_sep_bv_w ||
										'nr_agrupamento=' || to_char(nr_agrupamento_w) || ds_sep_bv_w ||
										'ie_status=' || ie_status_w || ds_sep_bv_w ||
										'ds_prescricao=' || ds_prescricao_w || ds_sep_bv_w ||
										'ie_medic_pac=' || ie_medicacao_paciente_w || ds_sep_bv_w ||
										'ds_item=' || ds_item_w || ds_sep_bv_w ||
										'ie_quimio=' || ie_quimio_w || ds_sep_bv_w ||
										'ie_composto=' || ie_composto_w || ds_sep_bv_w ||
										'ie_regra_disp=' || ie_regra_disp_w || ds_sep_bv_w ||
										'ds_observacao=' || ds_observacao_w || ds_sep_bv_w ||
										'ie_medic_kit=' || ie_medic_kit_w || ds_sep_bv_w ||
										'ie_item_orig_rep=' || ie_item_orig_rep_w || ds_sep_bv_w);
			commit;
		end if;
		end;
	end loop;
	close c01;
	CALL Atualizar_adep_controle(nm_usuario_p, nr_atendimento_p, 'M', 'N');
	END;

$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE adep_gerar_horarios_pck.adep_sincronizar_medic ( cd_estabelecimento_p bigint, cd_setor_usuario_p bigint, cd_perfil_p bigint, nm_usuario_p text, nr_atendimento_p bigint, dt_inicial_horarios_p timestamp, dt_final_horarios_p timestamp, dt_validade_limite_p timestamp, ie_exibir_hor_realizados_p text, ie_exibir_hor_suspensos_p text, ie_regra_inclusao_p text, ie_data_lib_prescr_p text, ie_exibir_suspensos_p text, ie_agrupar_acm_sn_p text, ie_agrupar_dose_esp_p text, ie_obs_diferenciar_p text, dt_horario_p timestamp, nr_horario_p integer, ie_mostrar_substituido_p text, ie_prescr_setor_p text, cd_setor_paciente_p bigint, ie_agrupar_suspensos_p text, cd_item_p bigint, ie_quimio_p text, ie_palm_p text, ie_html_p text default 'N') FROM PUBLIC;
