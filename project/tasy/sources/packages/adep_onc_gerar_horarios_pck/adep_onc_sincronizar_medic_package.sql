-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';


CREATE TYPE r_ds_inf AS (ds_dil_obs		varchar(2000),
				cd_material		varchar(15),
				cd_intervalo		varchar(10),
				qt_dose			double precision,
				posicao			bigint);


CREATE OR REPLACE PROCEDURE adep_onc_gerar_horarios_pck.adep_onc_sincronizar_medic ( nm_usuario_p text, nr_atendimento_p bigint, ie_data_lib_prescr_p text, ie_exibir_suspensos_p text, ie_opcao_filtro_p text, dt_filtro_p timestamp, nr_ciclo_p bigint, dt_inicial_horario_p timestamp, dt_final_horario_p timestamp) AS $body$
DECLARE

				
	ds_sep_bv_w		varchar(50);
	nr_prescricao_w		bigint;
	nr_seq_material_w	integer;
	nr_seq_horario_w	bigint;
	ie_status_horario_w	varchar(15);
	cd_material_w		integer;
	ds_material_w		varchar(255);
	ie_acm_sn_w		varchar(1);
	cd_intervalo_w		varchar(7);
	qt_dose_w		double precision;
	nr_agrupamento_w	double precision;
	ds_prescricao_w		varchar(240);
	ie_status_w		varchar(1);
	ds_dil_obs_w		varchar(2000);
	ds_comando_update_w	varchar(4000);
	ds_componentes_w	varchar(4000);
	current_setting('adep_onc_gerar_horarios_pck.dt_horario_w')::timestamp		timestamp;
	nr_horario_w		integer;
	dt_fim_horario_w	timestamp;
	ie_horario_especial_w	varchar(1);
	x			integer := 1;
	ds_dil_obs_ww		varchar(4000);
	nr_ciclo_w		smallint;
	ds_dia_ciclo_w		varchar(5);
	nr_seq_onc_w		bigint;
	ie_pre_medicacao_w	varchar(1);
	dt_oncologia_w		timestamp;
	nr_seq_mat_cpoe_w	prescr_material.nr_seq_mat_cpoe%type;
	ie_composto_w		varchar(1);
	ie_tipo_status_w 	varchar(2);
	type V_ds_inf is table of r_ds_inf index by integer;
	vt_ds_inf_w		V_ds_inf;


	c01 CURSOR FOR	
	SELECT	a.nr_prescricao,
		c.nr_seq_material,
		c.nr_sequencia,
		CASE WHEN 	coalesce(c.dt_primeira_checagem::text, '') = '' THEN 			CASE WHEN 	coalesce(c.dt_recusa::text, '') = '' THEN 				CASE WHEN ie_tipo_status_w='A' THEN 					substr(obter_status_proc_area_farm(c.nr_sequencia),1,15)  ELSE substr(obter_status_hor_medic(c.dt_fim_horario,c.dt_suspensao,c.ie_dose_especial,c.nr_seq_processo,c.nr_seq_area_prep),1,15) END   ELSE substr(obter_status_recusa_pac(c.dt_fim_horario,c.dt_suspensao),1,15) END   ELSE 'Q' END ,
		c.cd_material,
		y.ds_material,
		obter_se_acm_sn(x.ie_acm,x.ie_se_necessario) ie_acm_sn,		
		x.cd_intervalo,
		x.qt_dose,
		CASE WHEN obter_se_agrupa_composto(a.nr_prescricao,c.nr_seq_material,x.nr_agrupamento,c.cd_material)='S' THEN x.nr_agrupamento  ELSE 0 END  nr_agrupamento,
		substr(adep_obter_um_dosagem_prescr(a.nr_prescricao,c.nr_seq_material,x.ie_acm,x.ie_se_necessario),1,100) ds_prescricao,
		coalesce(x.ie_suspenso,'N') ie_suspenso,
		substr(adep_obter_inf_dil_obs(a.nr_prescricao,c.nr_seq_material),1,2000) ds_dil_obs,
		substr(adep_obter_inf_dil_obs(a.nr_prescricao,c.nr_seq_material),1,2000) ds_componentes,
		c.dt_horario,
		c.dt_fim_horario,
		coalesce(c.ie_horario_especial,'N'),
		b.nr_ciclo,
		coalesce(b.ds_dia_ciclo, b.ds_dia_ciclo_real) ds_dia_ciclo,
		coalesce(x.nr_seq_ordem_adep,x.nr_agrupamento) nr_seq_ordem_adep,
		coalesce(x.ie_pre_medicacao,'N') ie_pre_medicacao,
		coalesce(b.dt_real, b.dt_prevista) dt_oncologia,
		x.nr_seq_mat_cpoe,
		coalesce(VIPE_obter_se_medic_composto(a.nr_prescricao, x.nr_sequencia, x.nr_agrupamento, 'A'),'N')
	from	material y,
		prescr_material x,
		prescr_mat_hor c,
		prescr_medica a,
		paciente_atendimento b,
		paciente_setor p
	where	y.cd_material = x.cd_material
	and	x.nr_prescricao = c.nr_prescricao
	and	x.nr_sequencia = c.nr_seq_material	
	and	x.nr_prescricao = a.nr_prescricao
	and	c.nr_prescricao = a.nr_prescricao	
	and	a.nr_seq_atend	= b.nr_seq_atendimento
	and	b.nr_seq_paciente = p.nr_seq_paciente
	and	a.nr_atendimento = nr_atendimento_p
	and	p.cd_pessoa_fisica = a.cd_pessoa_fisica
	and	coalesce(a.ie_recem_nato,'N')	= 'N'
	and	coalesce(x.nr_seq_kit::text, '') = ''
	and	obter_se_prescr_lib_adep(coalesce(a.dt_liberacao_medico,x.dt_lib_material), coalesce(a.dt_liberacao,x.dt_lib_material), coalesce(a.dt_liberacao_farmacia,x.dt_lib_material), ie_data_lib_prescr_p) = 'S'
	and	x.ie_agrupador = 1
	and	((ie_exibir_suspensos_p = 'S') or (coalesce(x.dt_suspensao::text, '') = ''))
	and	obter_se_gerar_item_adep('M',a.nr_prescricao,c.nr_seq_material,x.nr_agrupamento,getie_apres_kit) = 'S'
	and	coalesce(c.ie_situacao,'A') = 'A'
	and	coalesce(c.ie_adep,'S') = 'S'
	and	c.ie_agrupador = 1
	and	Obter_se_horario_liberado(c.dt_lib_horario, c.dt_horario) = 'S'
	and ((ie_opcao_filtro_p in ('Q','C')) or
		 ((ie_opcao_filtro_p = 'D') and (coalesce(b.dt_real,b.dt_prevista) between trunc(dt_filtro_p) and fim_dia(dt_filtro_p))) or
         (ie_opcao_filtro_p = 'H' AND c.dt_horario between dt_inicial_horario_p and dt_final_horario_p))
	and	b.nr_ciclo	= coalesce(nr_ciclo_p,b.nr_ciclo)	
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
		c.cd_material,
		y.ds_material,
		x.ie_acm,
		x.ie_se_necessario,		
		x.cd_intervalo,
		c.dt_fim_horario,
		coalesce(c.ie_horario_especial,'N'),
		x.qt_dose,
		x.nr_agrupamento,
		x.ie_suspenso,
		x.ds_observacao,
		c.dt_recusa,
		c.dt_primeira_checagem,
		b.nr_ciclo,
		coalesce(b.ds_dia_ciclo, b.ds_dia_ciclo_real),
		coalesce(x.nr_seq_ordem_adep,x.nr_agrupamento),
		coalesce(x.ie_pre_medicacao,'N'),
		coalesce(b.dt_real, b.dt_prevista),
		x.nr_seq_mat_cpoe,
		coalesce(VIPE_obter_se_medic_composto(a.nr_prescricao, x.nr_sequencia, x.nr_agrupamento, 'A'),'N'),
		x.nr_prescricao,
		b.nr_seq_atendimento
	order by
		c.dt_horario,
		c.dt_suspensao;
		
	
BEGIN
	Obter_Param_Usuario(1113, 719,  current_setting('adep_onc_gerar_horarios_pck.cd_perfil_w')::bigint, current_setting('adep_onc_gerar_horarios_pck.nm_usuario_w')::varchar(15), current_setting('adep_onc_gerar_horarios_pck.cd_estabelecimento_w')::smallint, ie_tipo_status_w);
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
			ds_prescricao_w,
			ie_status_w,
			ds_dil_obs_w,
			ds_componentes_w,
			current_setting('adep_onc_gerar_horarios_pck.dt_horario_w')::timestamp,
			dt_fim_horario_w,
			ie_horario_especial_w,
			nr_ciclo_w,
			ds_dia_ciclo_w,
			nr_seq_onc_w,
			ie_pre_medicacao_w,
			dt_oncologia_w,
			nr_seq_mat_cpoe_w,
			ie_composto_w;
	EXIT WHEN NOT FOUND; /* apply on c01 */
		begin
		nr_horario_w := adep_onc_gerar_horarios_pck.get_posicao_horario(current_setting('adep_onc_gerar_horarios_pck.dt_horario_w')::timestamp);
		
		ds_dil_obs_ww := '';
		
		if (ds_dil_obs_w IS NOT NULL AND ds_dil_obs_w::text <> '') then
			vt_ds_inf_w[x].ds_dil_obs	:= ds_dil_obs_w;
			vt_ds_inf_w[x].cd_material	:= cd_material_w;
			vt_ds_inf_w[x].cd_intervalo	:= cd_intervalo_w;
			vt_ds_inf_w[x].qt_dose		:= qt_dose_w;
			vt_ds_inf_w[x].posicao		:= x;
		end if;
		
		for i in 1..vt_ds_inf_w.count loop
			begin
			if (vt_ds_inf_w[i].cd_material	= cd_material_w) and (vt_ds_inf_w[i].cd_intervalo	= cd_intervalo_w) and (vt_ds_inf_w[i].qt_dose		= qt_dose_w) and
				((coalesce(vt_ds_inf_w[i].ds_dil_obs,'XPTO') <> coalesce(ds_dil_obs_w,'XPTO')) or (vt_ds_inf_w[i].posicao = x)) then
				ds_dil_obs_ww	:= substr(ds_dil_obs_ww || vt_ds_inf_w[i].ds_dil_obs || chr(10),1,2000);
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
						' and cd_item = :cd_item ' ||
						' and nvl(cd_intervalo,0) = nvl(:cd_intervalo,0) ' ||
						' and nvl(qt_item,0) = nvl(:qt_item,0) ' ||
						' and nvl(nr_agrupamento,0) = nvl(:nr_agrupamento,0) ' ||
						' and ((ie_status_item is null) or (ie_status_item = :ie_status))' ||
						' and ((ds_prescricao = :ds_prescricao) or (ds_prescricao is null)) ' ||
						' and nr_ciclo = :nr_ciclo ' ||
						' and ds_dia_ciclo = :ds_dia_ciclo ' ||
						' and nr_seq_onc = :nr_seq_onc ' ||
						' and ie_pre_medicacao = :ie_pre_medicacao ' ||
						' and dt_oncologia = :dt_oncologia ' ||
						' and nr_seq_cpoe = :nr_seq_cpoe ' ||
						' and nvl(ie_composto,''N'') = :ie_composto ';
				
		CALL exec_sql_dinamico_bv('ADEP', ds_comando_update_w,	'nr_prescricao=' || to_char(nr_prescricao_w) || ds_sep_bv_w ||
									'ds_dil_obs=' || ds_dil_obs_ww || ds_sep_bv_w || 
									'nm_usuario=' || nm_usuario_p || ds_sep_bv_w || 
									'ie_tipo=M' || ds_sep_bv_w ||
									'nr_seq_item='|| to_char(nr_seq_material_w) || ds_sep_bv_w ||
									'cd_item=' || to_char(cd_material_w) || ds_sep_bv_w ||
									'cd_intervalo=' || cd_intervalo_w  || ds_sep_bv_w ||
									'qt_item=' || to_char(qt_dose_w) || ds_sep_bv_w ||
									'nr_agrupamento=' || to_char(nr_agrupamento_w) || ds_sep_bv_w ||
									'ie_status=' || ie_status_w || ds_sep_bv_w ||
									'ds_prescricao=' || ds_prescricao_w || ds_sep_bv_w ||
									'ds_componentes=' || ds_componentes_w || ds_sep_bv_w ||
									'nr_ciclo=' || to_char(nr_ciclo_w) || ds_sep_bv_w ||
									'ds_dia_ciclo=' || ds_dia_ciclo_w || ds_sep_bv_w ||
									'nr_seq_onc=' || to_char(nr_seq_onc_w) || ds_sep_bv_w ||
									'ie_pre_medicacao=' || ie_pre_medicacao_w || ds_sep_bv_w ||
									'dt_oncologia=' || to_char(dt_oncologia_w,'dd/mm/yyyy hh24:mi:ss') || ds_sep_bv_w ||
									'nr_seq_cpoe='|| to_char(nr_seq_mat_cpoe_w) || ds_sep_bv_w ||
									'ie_composto=' || ie_composto_w || ds_sep_bv_w);
		commit;
		if (nr_horario_w IS NOT NULL AND nr_horario_w::text <> '') and
			((dt_fim_horario_w IS NOT NULL AND dt_fim_horario_w::text <> '') or (ie_horario_especial_w = 'N')) then
			
			ds_comando_update_w	:=	' update w_adep_t ' ||
							' set hora' || to_char(nr_horario_w) || ' = :vl_hora, ' ||
							' nr_prescricoes = adep_juntar_prescricao(nr_prescricoes,:nr_prescricao), ' ||
							' ds_diluicao = :ds_dil_obs, ' ||
							' ds_componentes = :ds_componentes ' ||
							' where nm_usuario = :nm_usuario ' ||
							' and ie_tipo_item = :ie_tipo ' ||
							' and nvl(nr_prescricao,nvl(:nr_prescricao,0)) = nvl(:nr_prescricao,0) ' ||
							' and nvl(nr_seq_item,nvl(:nr_seq_item,0)) = nvl(:nr_seq_item,0) ' ||					
							' and cd_item = :cd_item ' ||
							' and nvl(cd_intervalo,0) = nvl(:cd_intervalo,0) ' ||
							' and nvl(qt_item,0) = nvl(:qt_item,0) ' ||
							' and nvl(nr_agrupamento,0) = nvl(:nr_agrupamento,0) ' ||
							' and ((ie_status_item is null) or (ie_status_item = :ie_status))' ||
							' and ((ds_prescricao = :ds_prescricao) or (ds_prescricao is null)) ' ||
							' and nr_ciclo = :nr_ciclo ' ||
							' and ds_dia_ciclo = :ds_dia_ciclo ' ||
							' and nr_seq_onc = :nr_seq_onc ' ||
							' and ie_pre_medicacao = :ie_pre_medicacao ' ||
							' and dt_oncologia = :dt_oncologia ';							
						
			CALL exec_sql_dinamico_bv('ADEP', ds_comando_update_w,	'vl_hora=S' || to_char(nr_seq_horario_w) || 'H' || ie_status_horario_w || ds_sep_bv_w ||
										'nr_prescricao=' || to_char(nr_prescricao_w) || ds_sep_bv_w ||
										'ds_dil_obs=' || ds_dil_obs_ww || ds_sep_bv_w || 
										'ds_componentes=' || ds_componentes_w || ds_sep_bv_w || 
										'nm_usuario=' || nm_usuario_p || ds_sep_bv_w || 
										'ie_tipo=M' || ds_sep_bv_w ||
										'nr_seq_item='|| to_char(nr_seq_material_w) || ds_sep_bv_w ||
										'cd_item=' || to_char(cd_material_w) || ds_sep_bv_w ||
										'cd_intervalo=' || cd_intervalo_w  || ds_sep_bv_w ||
										'qt_item=' || to_char(qt_dose_w) || ds_sep_bv_w ||
										'nr_agrupamento=' || to_char(nr_agrupamento_w) || ds_sep_bv_w ||
										'ie_status=' || ie_status_w || ds_sep_bv_w ||
										'ds_prescricao=' || ds_prescricao_w || ds_sep_bv_w ||
										'nr_ciclo=' || to_char(nr_ciclo_w) || ds_sep_bv_w ||
										'ds_dia_ciclo=' || ds_dia_ciclo_w || ds_sep_bv_w ||
										'nr_seq_onc=' || to_char(nr_seq_onc_w) || ds_sep_bv_w ||
										'ie_pre_medicacao=' || ie_pre_medicacao_w || ds_sep_bv_w ||
										'dt_oncologia=' || to_char(dt_oncologia_w,'dd/mm/yyyy hh24:mi:ss') || ds_sep_bv_w );
			commit;
		end if;
		end;
	end loop;
	close c01;
	END;

$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE adep_onc_gerar_horarios_pck.adep_onc_sincronizar_medic ( nm_usuario_p text, nr_atendimento_p bigint, ie_data_lib_prescr_p text, ie_exibir_suspensos_p text, ie_opcao_filtro_p text, dt_filtro_p timestamp, nr_ciclo_p bigint, dt_inicial_horario_p timestamp, dt_final_horario_p timestamp) FROM PUBLIC;
