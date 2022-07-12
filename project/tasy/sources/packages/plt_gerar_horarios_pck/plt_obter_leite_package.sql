-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';




CREATE OR REPLACE PROCEDURE plt_gerar_horarios_pck.plt_obter_leite ( nm_usuario_p text, nr_atendimento_p bigint, dt_inicial_horarios_p timestamp, dt_final_horarios_p timestamp, dt_validade_limite_p timestamp, ie_agrupar_acm_sn_p text, ie_prescr_usuario_p text, nr_seq_regra_p bigint, ie_edicao_p text, ie_estendidos_p bigint, dt_referencia_p timestamp, ie_exibir_hor_suspensos_p text, dt_plano_p text) AS $body$
DECLARE


	nr_seq_wadep_w			bigint;
	nr_prescricao_w			bigint;
	nr_seq_material_w		integer;
	cd_material_w			integer;
	ds_material_w			varchar(255);
	ie_acm_sn_w			varchar(1);
	cd_intervalo_w			varchar(7);
	qt_dose_w			double precision;
	ds_prescricao_w			varchar(100);
	ie_status_w			varchar(1);
	current_setting('plt_gerar_horarios_pck.ie_lib_pend_rep_w')::varchar(15)		varchar(1);
	ie_liberado_w			varchar(1);
	cd_unid_med_qtde_w		varchar(30);
	ie_via_administracao_w		varchar(5);
	ds_interv_prescr_w		varchar(240);
	ie_erro_w			integer;
	ie_copiar_w			varchar(1);
	dt_fim_w			timestamp;
	dt_extensao_w			timestamp;
	nr_seq_leite_deriv_w		bigint;
	ie_proximo_plano_w		varchar(1);	
	hr_prim_horario_w		varchar(5);
	ie_plano_atual_w		varchar(1);
	ie_horario_susp_w		varchar(1);
	ds_hint_w			varchar(2000);
	ie_composto_w			varchar(1);
	ds_composto_w			varchar(255);
	ie_retrogrado_w			varchar(1);
	ie_pend_assinatura_w 		varchar(1);
	ie_estendido_w			varchar(1);
	dt_validade_prescr_w		timestamp;
	ds_cor_titulo_w			varchar(20);
	ie_curta_duracao_w		varchar(1);
	cd_funcao_origem_w		bigint;
	cd_classif_setor_w		integer;
	ie_interv_farm_w		varchar(1);
	ie_recem_nato_w			varchar(1);
	
	
	c01 REFCURSOR;

	
BEGIN
	dt_fim_w	:= dt_validade_limite_p + 5;
	ie_copiar_w 	:= plt_obter_se_item_marcado('LD', nr_seq_regra_p);
	ds_cor_titulo_w	:= plt_obter_cor_titulo('LD',nr_seq_regra_p);

	if (nr_atendimento_p IS NOT NULL AND nr_atendimento_p::text <> '') then
		open	c01 for
		SELECT	CASE WHEN ie_acm_sn='S' THEN  CASE WHEN obter_se_agrupar_acm_sn_adep(nr_prescricao,nr_seq_material,ie_agrupar_acm_sn_p)='N' THEN  nr_prescricao  ELSE null END   ELSE null END ,
				CASE WHEN ie_acm_sn='S' THEN  CASE WHEN obter_se_agrupar_acm_sn_adep(nr_prescricao,nr_seq_material,ie_agrupar_acm_sn_p)='N' THEN  nr_seq_material  ELSE null END   ELSE null END ,	
				CASE WHEN ie_acm_sn='S' THEN  CASE WHEN obter_se_agrupar_acm_sn_adep(nr_prescricao,nr_seq_material,ie_agrupar_acm_sn_p)='N' THEN  nr_seq_leite_deriv  ELSE null END   ELSE null END ,
				cd_material,
				ds_material,
				ie_acm_sn,
				cd_intervalo,
				qt_dose,
				ds_prescricao,
				CASE WHEN ie_suspenso='S' THEN  ie_suspenso  ELSE CASE WHEN ie_acm_sn='S' THEN  CASE WHEN obter_se_agrupar_acm_sn_adep(nr_prescricao,nr_seq_material,ie_agrupar_acm_sn_p)='N' THEN  CASE WHEN ie_suspenso='S' THEN  ie_suspenso  ELSE null END   ELSE null END   ELSE null END  END  ie_status,
				cd_unidade_medida_dose,
				ie_via_aplicacao,
				ds_intervalo,
				ie_lib_pend_rep,
				ie_liberado,
				ie_erro,
				dt_extensao,
				CASE WHEN ie_prescr_emergencia='N' THEN CASE WHEN ie_acm_sn='S' THEN  CASE WHEN obter_se_hor_prescr(nr_prescricao, nr_seq_material, 'M')='S' THEN 'S'  ELSE 'N' END   ELSE 'N' END   ELSE 'N' END ,
				hr_prim_horario,
				ie_plano_atual,
				ie_horario_susp,
				ds_hint,
				ie_composto,
				ds_composto,
				ie_retrogrado,
				ie_pend_assinatura,
				ie_estendido,
				dt_validade_prescr,
				ie_curta_duracao,
				cd_funcao_origem,
				ie_prescr_farm,
				ie_recem_nato
		from	(
			SELECT	a.nr_prescricao,
					c.nr_seq_material,
					b.nr_sequencia nr_seq_leite_deriv,
					c.cd_material,
					coalesce(d.nm_produto,y.ds_material) ds_material,
					obter_se_acm_sn(x.ie_acm,x.ie_se_necessario) ie_acm_sn,		
					b.cd_intervalo,
					x.qt_dose,
					substr(adep_obter_um_dosagem_prescr(a.nr_prescricao,c.nr_seq_material,x.ie_acm,x.ie_se_necessario),1,100) ds_prescricao,
					coalesce(x.ie_suspenso,'N') ie_suspenso,
					substr(obter_desc_unid_med(obter_unid_med_usua(x.cd_unidade_medida_dose)),1,30) cd_unidade_medida_dose,
					b.ie_via_aplicacao,
					CASE WHEN b.ie_via_aplicacao='O' THEN 'Oral' WHEN b.ie_via_aplicacao='OS' THEN 'Oral/Sonda'  ELSE 'Sonda' END  || ' ' || obter_desc_intervalo_prescr(b.cd_intervalo)||CASE WHEN coalesce(b.cd_intervalo::text, '') = '' THEN ''  ELSE ' ' END ||obter_desc_acm_sn(x.ie_acm,x.ie_se_necessario) ds_intervalo,
					substr(plt_obter_lib_pend_prescr(a.dt_liberacao_medico,a.dt_liberacao,CASE WHEN a.ie_lib_farm='S' THEN a.dt_liberacao_farmacia  ELSE clock_timestamp() END ),1,1) ie_lib_pend_rep,
					plt_obter_se_liberado(a.dt_liberacao_medico,a.dt_liberacao,a.dt_liberacao_farmacia) ie_liberado,
					CASE WHEN plt_obter_se_liberado(a.dt_liberacao_medico,a.dt_liberacao,a.dt_liberacao_farmacia)='N' THEN x.ie_erro  ELSE null END  ie_erro,
					PLT_obter_dt_extensao(x.dt_extensao,a.dt_validade_prescr,a.nr_horas_validade) dt_extensao,
					coalesce(a.ie_prescr_emergencia,'N') ie_prescr_emergencia,
					x.hr_prim_horario,
					substr(PLT_obter_se_plano_atual(a.nr_prescricao),1,1) ie_plano_atual,
					CASE WHEN get_ie_identifica_hor_susp='S' THEN coalesce(x.ie_horario_susp,'N')  ELSE null END  ie_horario_susp,
					'Disp.: ' || substr(Obter_desc_disp_succao(b.nr_seq_disp_succao),1,40) || ' Volume total: '||b.qt_volume_total||' ml'||CASE WHEN b.ie_via_aplicacao='O' THEN ' (Via oral)' WHEN b.ie_via_aplicacao='S' THEN ' (Via sonda)'  ELSE ', sendo '||b.qt_volume_oral||' ml via oral e '||b.qt_volume_sonda||' ml via sonda' END  ds_hint,
					substr(coalesce(obter_se_leite_composto(x.nr_prescricao, x.nr_sequencia, x.nr_agrupamento),'N'),1,1) ie_composto,
					substr(plt_obter_compostos(x.nr_prescricao, x.nr_sequencia, x.nr_agrupamento,'LD'),1,255) ds_composto,
					coalesce(a.ie_prescr_emergencia,'N') ie_retrogrado,
					substr(obter_pendencia_assinatura(nm_usuario_p,a.nr_prescricao,'PR'),1,1) ie_pend_assinatura,
					substr(PLT_obter_ie_validade(PLT_obter_dt_extensao(x.dt_extensao,a.dt_validade_prescr,a.nr_horas_validade),a.dt_validade_prescr,dt_referencia_p),1,1) ie_estendido,
					a.dt_validade_prescr,
					obter_ie_curta_duracao(a.nr_prescricao,dt_referencia_p, current_setting('plt_gerar_horarios_pck.cd_perfil_w')::perfil.cd_perfil%type, current_setting('plt_gerar_horarios_pck.cd_pessoa_usuario_w')::pessoa_fisica.cd_pessoa_fisica%type, current_setting('plt_gerar_horarios_pck.cd_especialidade_w')::especialidade_medica.cd_especialidade%type) ie_curta_duracao,
					a.cd_funcao_origem,
					coalesce(a.ie_prescr_farm, 'N') ie_prescr_farm,
					coalesce(a.ie_recem_nato, 'N') ie_recem_nato,
					c.dt_horario,
					x.dt_suspensao
			from	nutricao_leite_deriv d,
					material y,
					prescr_leite_deriv b,
					prescr_material x,
					prescr_mat_hor c,
					prescr_medica a
			where	y.cd_material = d.cd_material
			and		y.cd_material = x.cd_material
			and		y.cd_material = c.cd_material
			and		x.nr_prescricao = c.nr_prescricao
			and		x.nr_sequencia = c.nr_seq_material
			and		x.nr_prescricao = a.nr_prescricao
			and		c.nr_prescricao = a.nr_prescricao
			and		b.nr_sequencia	= x.nr_seq_leite_deriv
			and		b.nr_prescricao	= x.nr_prescricao
			and		a.nr_atendimento = nr_atendimento_p
			and 	coalesce(d.ie_situacao,'A') = 'A'
			and		PLT_Gerar_Horarios_PCK.OBTER_SE_MOSTRA_REP_INTER(a.ie_motivo_prescricao) = 'S'
			and		a.nr_prescricao	between current_setting('plt_gerar_horarios_pck.nr_prescr_inicial_w')::bigint	and current_setting('plt_gerar_horarios_pck.nr_prescr_final_w')::bigint
			and		a.dt_validade_prescr	between dt_validade_limite_p	and dt_fim_w	
			and		((current_setting('plt_gerar_horarios_pck.ie_regra_incl_leite_w')::char(1) = 'S') or
					((current_setting('plt_gerar_horarios_pck.ie_regra_incl_leite_w')::char(1) = 'R') and (adep_obter_regra_inclusao(	'LD',
																					wheb_usuario_pck.get_cd_estabelecimento, 
																					wheb_usuario_pck.get_cd_setor_atendimento, 
																					wheb_usuario_pck.get_cd_perfil, 
																					c.cd_material, 
																					null, 
																					null, 
																					null,
																					a.cd_setor_Atendimento,
																					null,
																					a.nr_prescricao,
																					null) = 'S')))
			and		x.ie_agrupador = 16
			and		coalesce(c.ie_situacao,'A') = 'A'
			and		c.ie_agrupador = 16
			group by
					a.nr_prescricao,
					c.nr_seq_material,
					c.cd_material,
					coalesce(d.nm_produto,y.ds_material),
					x.ie_acm,
					x.ie_se_necessario,		
					b.cd_intervalo,
					x.qt_dose,
					x.ie_suspenso,
					substr(obter_desc_unid_med(obter_unid_med_usua(x.cd_unidade_medida_dose)),1,30),
					a.dt_liberacao_medico,
					a.dt_liberacao,
					a.dt_liberacao_farmacia,
					x.ie_erro,
					PLT_obter_dt_extensao(x.dt_extensao,a.dt_validade_prescr,a.nr_horas_validade),
					substr(plt_obter_lib_pend_prescr(a.dt_liberacao_medico,a.dt_liberacao,CASE WHEN a.ie_lib_farm='S' THEN a.dt_liberacao_farmacia  ELSE clock_timestamp() END ),1,1),
					b.nr_sequencia,
					CASE WHEN b.ie_via_aplicacao='O' THEN 'Oral' WHEN b.ie_via_aplicacao='OS' THEN 'Oral/Sonda'  ELSE 'Sonda' END ,
					b.ie_via_aplicacao,
					a.ie_prescr_emergencia,
					'Disp.: ' || substr(Obter_desc_disp_succao(b.nr_seq_disp_succao),1,40) || ' Volume total: '||b.qt_volume_total||' ml'||CASE WHEN b.ie_via_aplicacao='O' THEN ' (Via oral)' WHEN b.ie_via_aplicacao='S' THEN ' (Via sonda)'  ELSE ', sendo '||b.qt_volume_oral||' ml via oral e '||b.qt_volume_sonda||' ml via sonda' END ,
					x.hr_prim_horario,
					CASE WHEN get_ie_identifica_hor_susp='S' THEN coalesce(x.ie_horario_susp,'N')  ELSE null END ,
					b.qt_volume_oral,
					b.qt_volume_sonda,
					b.qt_volume_total,
					obter_se_leite_composto(x.nr_prescricao, x.nr_sequencia, x.nr_agrupamento),
					plt_obter_compostos(x.nr_prescricao, x.nr_sequencia, x.nr_agrupamento,'LD'),
					a.ie_prescr_emergencia,
					substr(obter_pendencia_assinatura(nm_usuario_p,a.nr_prescricao,'PR'),1,1),
					substr(PLT_obter_ie_validade(PLT_obter_dt_extensao(x.dt_extensao,a.dt_validade_prescr,a.nr_horas_validade),a.dt_validade_prescr,dt_referencia_p),1,1),
					a.dt_validade_prescr,
					obter_ie_curta_duracao(a.nr_prescricao,dt_referencia_p, current_setting('plt_gerar_horarios_pck.cd_perfil_w')::perfil.cd_perfil%type, current_setting('plt_gerar_horarios_pck.cd_pessoa_usuario_w')::pessoa_fisica.cd_pessoa_fisica%type, current_setting('plt_gerar_horarios_pck.cd_especialidade_w')::especialidade_medica.cd_especialidade%type),
					a.cd_funcao_origem,
					a.ie_prescr_farm,
					coalesce(a.ie_recem_nato, 'N'),
					c.dt_horario,
					x.dt_suspensao) alias84
		where	plt_obter_se_item_periodo(	dt_validade_limite_p,		dt_fim_w,				get_ie_plano_por_setor,		dt_plano_p,			dt_horario,
											dt_inicial_horarios_p,		dt_final_horarios_p,	ie_prescr_usuario_p,		nm_usuario_p,		ie_estendidos_p,
											dt_referencia_p,			ie_edicao_p,			ie_exibir_hor_suspensos_p,	dt_suspensao,		'LD',
											nr_seq_material,			nr_prescricao,			'O') = 'S'
		group by
				CASE WHEN ie_acm_sn='S' THEN  CASE WHEN obter_se_agrupar_acm_sn_adep(nr_prescricao,nr_seq_material,ie_agrupar_acm_sn_p)='N' THEN  nr_prescricao  ELSE null END   ELSE null END ,
				CASE WHEN ie_acm_sn='S' THEN  CASE WHEN obter_se_agrupar_acm_sn_adep(nr_prescricao,nr_seq_material,ie_agrupar_acm_sn_p)='N' THEN  nr_seq_material  ELSE null END   ELSE null END ,	
				CASE WHEN ie_acm_sn='S' THEN  CASE WHEN obter_se_agrupar_acm_sn_adep(nr_prescricao,nr_seq_material,ie_agrupar_acm_sn_p)='N' THEN  nr_seq_leite_deriv  ELSE null END   ELSE null END ,
				cd_material,
				ds_material,
				ie_acm_sn,	
				cd_intervalo,
				qt_dose,
				ds_prescricao,
				CASE WHEN ie_suspenso='S' THEN  ie_suspenso  ELSE CASE WHEN ie_acm_sn='S' THEN  CASE WHEN obter_se_agrupar_acm_sn_adep(nr_prescricao,nr_seq_material,ie_agrupar_acm_sn_p)='N' THEN  CASE WHEN ie_suspenso='S' THEN  ie_suspenso  ELSE null END   ELSE null END   ELSE null END  END ,
				cd_unidade_medida_dose,
				ie_via_aplicacao,
				ds_intervalo,
				ie_lib_pend_rep,
				ie_liberado,
				ie_erro,
				dt_extensao,
				CASE WHEN ie_prescr_emergencia='N' THEN CASE WHEN ie_acm_sn='S' THEN  CASE WHEN obter_se_hor_prescr(nr_prescricao, nr_seq_material, 'M')='S' THEN 'S'  ELSE 'N' END   ELSE 'N' END   ELSE 'N' END ,
				hr_prim_horario,
				ie_plano_atual,
				ie_horario_susp,
				ds_hint,
				ie_composto,
				ds_composto,
				ie_retrogrado,
				ie_pend_assinatura,
				ie_estendido,
				dt_validade_prescr,
				ie_curta_duracao,
				cd_funcao_origem,
				ie_prescr_farm,
				ie_recem_nato;	
	else
		open	c01 for
		SELECT	CASE WHEN ie_acm_sn='S' THEN  CASE WHEN obter_se_agrupar_acm_sn_adep(nr_prescricao,nr_seq_material,ie_agrupar_acm_sn_p)='N' THEN  nr_prescricao  ELSE null END   ELSE null END ,
				CASE WHEN ie_acm_sn='S' THEN  CASE WHEN obter_se_agrupar_acm_sn_adep(nr_prescricao,nr_seq_material,ie_agrupar_acm_sn_p)='N' THEN  nr_seq_material  ELSE null END   ELSE null END ,	
				CASE WHEN ie_acm_sn='S' THEN  CASE WHEN obter_se_agrupar_acm_sn_adep(nr_prescricao,nr_seq_material,ie_agrupar_acm_sn_p)='N' THEN  nr_seq_leite_deriv  ELSE null END   ELSE null END ,
				cd_material,
				ds_material,
				ie_acm_sn,
				cd_intervalo,
				qt_dose,
				ds_prescricao,
				CASE WHEN ie_suspenso='S' THEN  ie_suspenso  ELSE CASE WHEN ie_acm_sn='S' THEN  CASE WHEN obter_se_agrupar_acm_sn_adep(nr_prescricao,nr_seq_material,ie_agrupar_acm_sn_p)='N' THEN  CASE WHEN ie_suspenso='S' THEN  ie_suspenso  ELSE null END   ELSE null END   ELSE null END  END  ie_status,
				cd_unidade_medida_dose,
				ie_via_aplicacao,
				ds_intervalo,
				ie_lib_pend_rep,
				ie_liberado,
				ie_erro,
				dt_extensao,
				CASE WHEN ie_prescr_emergencia='N' THEN CASE WHEN ie_acm_sn='S' THEN  CASE WHEN obter_se_hor_prescr(nr_prescricao, nr_seq_material, 'M')='S' THEN 'S'  ELSE 'N' END   ELSE 'N' END   ELSE 'N' END ,
				hr_prim_horario,
				ie_plano_atual,
				ie_horario_susp,
				ds_hint,
				ie_composto,
				ds_composto,
				ie_retrogrado,
				ie_pend_assinatura,
				ie_estendido,
				dt_validade_prescr,
				ie_curta_duracao,
				cd_funcao_origem,
				ie_prescr_farm,
				ie_recem_nato
		from	(
			SELECT	a.nr_prescricao,
					c.nr_seq_material,
					b.nr_sequencia nr_seq_leite_deriv,
					c.cd_material,
					coalesce(d.nm_produto,y.ds_material) ds_material,
					obter_se_acm_sn(x.ie_acm,x.ie_se_necessario) ie_acm_sn,		
					b.cd_intervalo,
					x.qt_dose,
					substr(adep_obter_um_dosagem_prescr(a.nr_prescricao,c.nr_seq_material,x.ie_acm,x.ie_se_necessario),1,100) ds_prescricao,
					coalesce(x.ie_suspenso,'N') ie_suspenso,
					substr(obter_desc_unid_med(obter_unid_med_usua(x.cd_unidade_medida_dose)),1,30) cd_unidade_medida_dose,
					b.ie_via_aplicacao,
					CASE WHEN b.ie_via_aplicacao='O' THEN 'Oral' WHEN b.ie_via_aplicacao='OS' THEN 'Oral/Sonda'  ELSE 'Sonda' END  || ' ' || obter_desc_intervalo_prescr(b.cd_intervalo)||CASE WHEN coalesce(b.cd_intervalo::text, '') = '' THEN ''  ELSE ' ' END ||obter_desc_acm_sn(x.ie_acm,x.ie_se_necessario) ds_intervalo,
					substr(plt_obter_lib_pend_prescr(a.dt_liberacao_medico,a.dt_liberacao,CASE WHEN a.ie_lib_farm='S' THEN a.dt_liberacao_farmacia  ELSE clock_timestamp() END ),1,1) ie_lib_pend_rep,
					plt_obter_se_liberado(a.dt_liberacao_medico,a.dt_liberacao,a.dt_liberacao_farmacia) ie_liberado,
					CASE WHEN plt_obter_se_liberado(a.dt_liberacao_medico,a.dt_liberacao,a.dt_liberacao_farmacia)='N' THEN x.ie_erro  ELSE null END  ie_erro,
					PLT_obter_dt_extensao(x.dt_extensao,a.dt_validade_prescr,a.nr_horas_validade) dt_extensao,
					coalesce(a.ie_prescr_emergencia,'N') ie_prescr_emergencia,
					x.hr_prim_horario,
					substr(PLT_obter_se_plano_atual(a.nr_prescricao),1,1) ie_plano_atual,
					CASE WHEN get_ie_identifica_hor_susp='S' THEN coalesce(x.ie_horario_susp,'N')  ELSE null END  ie_horario_susp,
					'Disp.: ' || substr(Obter_desc_disp_succao(b.nr_seq_disp_succao),1,40) || ' Volume total: '||b.qt_volume_total||' ml'||CASE WHEN b.ie_via_aplicacao='O' THEN ' (Via oral)' WHEN b.ie_via_aplicacao='S' THEN ' (Via sonda)'  ELSE ', sendo '||b.qt_volume_oral||' ml via oral e '||b.qt_volume_sonda||' ml via sonda' END  ds_hint,
					substr(coalesce(obter_se_leite_composto(x.nr_prescricao, x.nr_sequencia, x.nr_agrupamento),'N'),1,1) ie_composto,
					substr(plt_obter_compostos(x.nr_prescricao, x.nr_sequencia, x.nr_agrupamento,'LD'),1,255) ds_composto,
					coalesce(a.ie_prescr_emergencia,'N') ie_retrogrado,
					substr(obter_pendencia_assinatura(nm_usuario_p,a.nr_prescricao,'PR'),1,1) ie_pend_assinatura,
					substr(PLT_obter_ie_validade(PLT_obter_dt_extensao(x.dt_extensao,a.dt_validade_prescr,a.nr_horas_validade),a.dt_validade_prescr,dt_referencia_p),1,1) ie_estendido,
					a.dt_validade_prescr,
					obter_ie_curta_duracao(a.nr_prescricao,dt_referencia_p, current_setting('plt_gerar_horarios_pck.cd_perfil_w')::perfil.cd_perfil%type, current_setting('plt_gerar_horarios_pck.cd_pessoa_usuario_w')::pessoa_fisica.cd_pessoa_fisica%type, current_setting('plt_gerar_horarios_pck.cd_especialidade_w')::especialidade_medica.cd_especialidade%type) ie_curta_duracao,
					a.cd_funcao_origem,
					coalesce(a.ie_prescr_farm, 'N') ie_prescr_farm,
					coalesce(a.ie_recem_nato, 'N') ie_recem_nato,
					c.dt_horario,
					x.dt_suspensao
			from	nutricao_leite_deriv d,
					material y,
					prescr_leite_deriv b,
					prescr_material x,
					prescr_mat_hor c,
					prescr_medica a
			where	y.cd_material = d.cd_material
			and		y.cd_material = x.cd_material
			and		y.cd_material = c.cd_material
			and		x.nr_prescricao = c.nr_prescricao
			and		x.nr_sequencia = c.nr_seq_material
			and		x.nr_prescricao = a.nr_prescricao
			and		c.nr_prescricao = a.nr_prescricao
			and		b.nr_sequencia	= x.nr_seq_leite_deriv
			and		b.nr_prescricao	= x.nr_prescricao
			and		d.ie_se_necessario =  coalesce(x.ie_se_necessario,'N')
			and		a.cd_pessoa_fisica = current_setting('plt_gerar_horarios_pck.cd_pessoa_fisica_w')::varchar(10)
			and 	coalesce(d.ie_situacao,'A') = 'A'
			and		plt_gerar_horarios_pck.obter_se_mostra_rep_inter(a.ie_motivo_prescricao) = 'S'				
			and		a.nr_prescricao	between current_setting('plt_gerar_horarios_pck.nr_prescr_inicial_w')::bigint	and current_setting('plt_gerar_horarios_pck.nr_prescr_final_w')::bigint
			and		a.dt_validade_prescr	between dt_validade_limite_p	and dt_fim_w			
			and		((current_setting('plt_gerar_horarios_pck.ie_regra_incl_leite_w')::char(1) = 'S') or
					((current_setting('plt_gerar_horarios_pck.ie_regra_incl_leite_w')::char(1) = 'R') and (adep_obter_regra_inclusao(	'LD',
																					wheb_usuario_pck.get_cd_estabelecimento,
																					wheb_usuario_pck.get_cd_setor_atendimento, 
																					wheb_usuario_pck.get_cd_perfil, 
																					c.cd_material, 
																					null, 
																					null, 
																					null,
																					a.cd_setor_Atendimento,
																					null,
																					a.nr_prescricao,
																					null) = 'S')))
			and		x.ie_agrupador = 16
			and		coalesce(c.ie_situacao,'A') = 'A'
			and		c.ie_agrupador = 16
			group by
					a.nr_prescricao,
					c.nr_seq_material,
					c.cd_material,
					coalesce(d.nm_produto,y.ds_material),
					x.ie_acm,
					x.ie_se_necessario,		
					b.cd_intervalo,
					x.qt_dose,
					x.ie_suspenso,
					substr(obter_desc_unid_med(obter_unid_med_usua(x.cd_unidade_medida_dose)),1,30),
					a.dt_liberacao_medico,
					a.dt_liberacao,
					a.dt_liberacao_farmacia,
					x.ie_erro,
					PLT_obter_dt_extensao(x.dt_extensao,a.dt_validade_prescr,a.nr_horas_validade),
					substr(plt_obter_lib_pend_prescr(a.dt_liberacao_medico,a.dt_liberacao,CASE WHEN a.ie_lib_farm='S' THEN a.dt_liberacao_farmacia  ELSE clock_timestamp() END ),1,1),
					b.nr_sequencia,
					CASE WHEN b.ie_via_aplicacao='O' THEN 'Oral' WHEN b.ie_via_aplicacao='OS' THEN 'Oral/Sonda'  ELSE 'Sonda' END ,
					b.ie_via_aplicacao,
					a.ie_prescr_emergencia,
					'Disp.: ' || substr(Obter_desc_disp_succao(b.nr_seq_disp_succao),1,40) || ' Volume total: '||b.qt_volume_total||' ml'||CASE WHEN b.ie_via_aplicacao='O' THEN ' (Via oral)' WHEN b.ie_via_aplicacao='S' THEN ' (Via sonda)'  ELSE ', sendo '||b.qt_volume_oral||' ml via oral e '||b.qt_volume_sonda||' ml via sonda' END ,
					x.hr_prim_horario,
					CASE WHEN get_ie_identifica_hor_susp='S' THEN coalesce(x.ie_horario_susp,'N')  ELSE null END ,
					b.qt_volume_oral,
					b.qt_volume_sonda,
					b.qt_volume_total,
					obter_se_leite_composto(x.nr_prescricao, x.nr_sequencia, x.nr_agrupamento),
					plt_obter_compostos(x.nr_prescricao, x.nr_sequencia, x.nr_agrupamento,'LD'),
					a.ie_prescr_emergencia,
					substr(obter_pendencia_assinatura(nm_usuario_p,a.nr_prescricao,'PR'),1,1),
					substr(PLT_obter_ie_validade(PLT_obter_dt_extensao(x.dt_extensao,a.dt_validade_prescr,a.nr_horas_validade),a.dt_validade_prescr,dt_referencia_p),1,1),
					a.dt_validade_prescr,
					obter_ie_curta_duracao(a.nr_prescricao,dt_referencia_p, current_setting('plt_gerar_horarios_pck.cd_perfil_w')::perfil.cd_perfil%type, current_setting('plt_gerar_horarios_pck.cd_pessoa_usuario_w')::pessoa_fisica.cd_pessoa_fisica%type, current_setting('plt_gerar_horarios_pck.cd_especialidade_w')::especialidade_medica.cd_especialidade%type),
					a.cd_funcao_origem,
					a.ie_prescr_farm,
					coalesce(a.ie_recem_nato, 'N'),
					c.dt_horario,
					x.dt_suspensao) alias86
		where	plt_obter_se_item_periodo(	dt_validade_limite_p,		dt_fim_w,				get_ie_plano_por_setor,		dt_plano_p,			dt_horario,
											dt_inicial_horarios_p,		dt_final_horarios_p,	ie_prescr_usuario_p,		nm_usuario_p,		ie_estendidos_p,
											dt_referencia_p,			ie_edicao_p,			ie_exibir_hor_suspensos_p,	dt_suspensao,		'LD',
											nr_seq_material,			nr_prescricao,			'O') = 'S'
		group by
			CASE WHEN ie_acm_sn='S' THEN  CASE WHEN obter_se_agrupar_acm_sn_adep(nr_prescricao,nr_seq_material,ie_agrupar_acm_sn_p)='N' THEN  nr_prescricao  ELSE null END   ELSE null END ,
			CASE WHEN ie_acm_sn='S' THEN  CASE WHEN obter_se_agrupar_acm_sn_adep(nr_prescricao,nr_seq_material,ie_agrupar_acm_sn_p)='N' THEN  nr_seq_material  ELSE null END   ELSE null END ,	
			CASE WHEN ie_acm_sn='S' THEN  CASE WHEN obter_se_agrupar_acm_sn_adep(nr_prescricao,nr_seq_material,ie_agrupar_acm_sn_p)='N' THEN  nr_seq_leite_deriv  ELSE null END   ELSE null END ,
			cd_material,
			ds_material,
			ie_acm_sn,	
			cd_intervalo,
			qt_dose,
			ds_prescricao,
			CASE WHEN ie_suspenso='S' THEN  ie_suspenso  ELSE CASE WHEN ie_acm_sn='S' THEN  CASE WHEN obter_se_agrupar_acm_sn_adep(nr_prescricao,nr_seq_material,ie_agrupar_acm_sn_p)='N' THEN  CASE WHEN ie_suspenso='S' THEN  ie_suspenso  ELSE null END   ELSE null END   ELSE null END  END ,
			cd_unidade_medida_dose,
			ie_via_aplicacao,
			ds_intervalo,
			ie_lib_pend_rep,
			ie_liberado,
			ie_erro,
			dt_extensao,
			CASE WHEN ie_prescr_emergencia='N' THEN CASE WHEN ie_acm_sn='S' THEN  CASE WHEN obter_se_hor_prescr(nr_prescricao, nr_seq_material, 'M')='S' THEN 'S'  ELSE 'N' END   ELSE 'N' END   ELSE 'N' END ,
			hr_prim_horario,
			ie_plano_atual,
			ie_horario_susp,
			ds_hint,
			ie_composto,
			ds_composto,
			ie_retrogrado,
			ie_pend_assinatura,
			ie_estendido,
			dt_validade_prescr,
			ie_curta_duracao,
			cd_funcao_origem,
			ie_prescr_farm,
			ie_recem_nato;		
	end if;
	
	loop
	fetch c01 into	nr_prescricao_w,
			nr_seq_material_w,
			nr_seq_leite_deriv_w,
			cd_material_w,
			ds_material_w,
			ie_acm_sn_w,		
			cd_intervalo_w,
			qt_dose_w,
			ds_prescricao_w,
			ie_status_w,
			cd_unid_med_qtde_w,
			ie_via_administracao_w,
			ds_interv_prescr_w,
			current_setting('plt_gerar_horarios_pck.ie_lib_pend_rep_w')::varchar(15),
			ie_liberado_w,
			ie_erro_w,
			dt_extensao_w,
			ie_proximo_plano_w,
			hr_prim_horario_w,
			ie_plano_atual_w,
			ie_horario_susp_w,
			ds_hint_w,
			ie_composto_w,
			ds_composto_w,
			ie_retrogrado_w,
			ie_pend_assinatura_w,
			ie_estendido_w,
			dt_validade_prescr_w,
			ie_curta_duracao_w,
			cd_funcao_origem_w,
			ie_interv_farm_w,
			ie_recem_nato_w;
	EXIT WHEN NOT FOUND; /* apply on c01 */
		begin
		
		select	coalesce(Obter_classif_setor_atend(nr_atendimento_p),0)
		into STRICT	cd_classif_setor_w
		;
		
		if (ie_estendido_w	= 'P') and (coalesce(dt_extensao_w::text, '') = '') then
			dt_extensao_w	:= dt_validade_prescr_w;
		end if;	
		
		if (((ie_estendido_w = 'P') and
			 ((coalesce(cd_funcao_origem_w,924) <> 950) or (ie_curta_duracao_w = 'N'))) or (cd_classif_setor_w = 1)) then
			ie_estendido_w	:= 'N';
		end if;
		
		select	nextval('w_rep_t_seq')
		into STRICT	nr_seq_wadep_w
		;

		insert into w_rep_t(
			nr_sequencia,
			nm_usuario,
			ie_tipo_item,
			nr_prescricao,
			nr_seq_item,		
			cd_item,
			ds_item,
			ie_acm_sn,		
			cd_intervalo,
			qt_item,
			ds_prescricao,
			ie_status_item,
			ie_diferenciado,
			nr_seq_proc_interno,
			nr_agrupamento,
			cd_unid_med_qtde,
			ie_via_aplicacao,
			ds_interv_prescr,
			ie_pendente_liberacao,
			ie_liberado,
			ie_erro,
			ie_copiar,
			dt_extensao,
			nr_seq_leite_deriv,
			ie_proximo_plano,
			hr_prim_horario,
			ie_plano_atual,
			ie_horario_susp,
			ds_hint,
			ie_composto,
			ds_composto,
			ie_retrogrado,
			ie_pend_assinatura,
			dt_atualizacao,
			ie_estendido,
			ds_cor_titulo,
			ie_curta_duracao,
			ie_interv_farm,
			ie_item_rn)
		values (
			nr_seq_wadep_w,
			nm_usuario_p,
			'LD',
			nr_prescricao_w,
			nr_seq_material_w,
			cd_material_w,
			ds_material_w,
			ie_acm_sn_w,
			cd_intervalo_w,
			qt_dose_w,
			ds_prescricao_w,
			ie_status_w,
			'N',
			0,
			0,
			cd_unid_med_qtde_w,
			ie_via_administracao_w,
			ds_interv_prescr_w,
			current_setting('plt_gerar_horarios_pck.ie_lib_pend_rep_w')::varchar(15),
			ie_liberado_w,
			ie_erro_w,
			CASE WHEN ie_status_w='S' THEN 'N'  ELSE ie_copiar_w END ,
			dt_extensao_w,
			nr_seq_leite_deriv_w,
			ie_proximo_plano_w,
			hr_prim_horario_w,
			ie_plano_atual_w,
			ie_horario_susp_w,
			ds_hint_w,
			ie_composto_w,
			ds_composto_w,
			ie_retrogrado_w,
			ie_pend_assinatura_w,
			clock_timestamp(),
			ie_estendido_w,
			ds_cor_titulo_w,
			ie_curta_duracao_w,
			ie_interv_farm_w,
			ie_recem_nato_w);
		end;
	end loop;
	close c01;

	END;	

$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE plt_gerar_horarios_pck.plt_obter_leite ( nm_usuario_p text, nr_atendimento_p bigint, dt_inicial_horarios_p timestamp, dt_final_horarios_p timestamp, dt_validade_limite_p timestamp, ie_agrupar_acm_sn_p text, ie_prescr_usuario_p text, nr_seq_regra_p bigint, ie_edicao_p text, ie_estendidos_p bigint, dt_referencia_p timestamp, ie_exibir_hor_suspensos_p text, dt_plano_p text) FROM PUBLIC;