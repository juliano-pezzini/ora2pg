-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';




CREATE OR REPLACE PROCEDURE cpoe_overview_pck.generate_view ( nr_atendimento_p bigint, cd_pessoa_fisica_p text, dt_inicio_p timestamp, dt_fim_p timestamp, nm_usuario_p text, ie_medicamento_p text default null, ie_solucao_p text default null, ie_recomendacao_p text default null, ie_hemoterapia_p text default null, ie_procedimento_p text default null, ie_gasoterapia_p text default null, ie_dialise_p text default null, ie_dieta_p text default null, cd_material_p bigint default null, ie_administracao_p text default null, ie_view_mode_p text default null, ie_show_dates_p text default null, ie_ignore_dates_p text default null, ie_consider_encounter_p text default 'A', ie_medical_depart_p text default null, nr_tipo_pedido_filter_p text default null, ie_view_type_p text default null, ie_encounter_type_p text default null, ds_material_list_p text default null, ie_suspensao_p text default null, ie_material_p text default null, ie_anatomia_p text default null, ie_my_department_p text default 'N') AS $body$
DECLARE


	indice_w		integer;

	C01 CURSOR FOR
		SELECT	a.nr_sequencia,
			a.ie_tipo_item,
			a.ds_item,
			a.dt_fim,
			a.ds_html,
			a.ds_label_html,
			a.ds_horarios,
			a.dt_inicio,
			a.cd_material,
			a.qt_dose,
			a.cd_unidade_medida,
			a.ie_via_aplicacao,
			a.nr_seq_cpoe_rp,
			a.nr_seq_cpoe_order_unit,
			a.nr_seq_cpoe_tipo_pedido,
			a.cd_departamento,
			a.dt_lib_suspensao,
			a.cd_intervalo
		from	cpoe_overview_itens_v a
		where (a.nr_atendimento = current_setting('cpoe_overview_pck.nr_atendimento_w')::bigint or current_setting('cpoe_overview_pck.nr_atendimento_w')::coalesce(bigint::text, '') = '')
		and (a.cd_pessoa_fisica = current_setting('cpoe_overview_pck.cd_pessoa_fisica_w')::varchar(10) or current_setting('cpoe_overview_pck.cd_pessoa_fisica_w')::coalesce(varchar(10)::text, '') = '')
		and ((a.dt_inicio >= current_setting('cpoe_overview_pck.dt_inicio_w')::timestamp AND a.dt_inicio <= current_setting('cpoe_overview_pck.dt_fim_w')::timestamp) or (coalesce(a.dt_fim::text, '') = '' AND a.dt_inicio <= current_setting('cpoe_overview_pck.dt_fim_w')::timestamp))
		and ((coalesce(a.dt_lib_suspensao::text, '') = '') or (a.dt_lib_suspensao >= current_setting('cpoe_overview_pck.dt_inicio_w')::timestamp and ie_suspensao_p = 'S'))
		and	((a.ie_tipo_item	= 'M' 	and ie_medicamento_p = 'S') or (a.ie_tipo_item		= 'SOL' and ie_solucao_p = 'S') or (a.ie_tipo_item		= 'MAT' and ie_material_p = 'S') or (a.ie_tipo_item		= 'P' 	and ie_procedimento_p = 'S') or (a.ie_tipo_item		= 'R' 	and ie_recomendacao_p = 'S') or (a.ie_tipo_item		= 'G' 	and ie_gasoterapia_p = 'S') or (a.ie_tipo_item		= 'HM' 	and ie_hemoterapia_p = 'S') or (a.ie_tipo_item		= 'DI' 	and ie_dialise_p = 'S') or (a.ie_tipo_item		= 'D' 	and ie_dieta_p = 'S') or (a.ie_tipo_item		= 'AP' 	and ie_anatomia_p = 'S')
			)
		and	((coalesce(cd_material_p::text, '') = '') or (a.ie_tipo_item in ('SOL','M') and a.cd_material = cd_material_p))
		and	CASE WHEN coalesce(ds_material_list_p::text, '') = '' THEN  'S'  ELSE obter_se_contido_char(a.cd_material, ds_material_list_p) END  = 'S'
		and (coalesce(ie_encounter_type_p,0) = 0 or obter_tipo_atendimento(a.nr_atendimento) = ie_encounter_type_p)
		and CASE WHEN coalesce(ie_administracao_p::text, '') = '' THEN  'S'  ELSE obter_se_contido_char(ie_administracao, ie_administracao_p) END  = 'S'
		and CASE WHEN coalesce(ie_medical_depart_p::text, '') = '' THEN  'S'  ELSE obter_se_contido_char(cd_departamento, ie_medical_depart_p) END  = 'S'
		and CASE WHEN coalesce(nr_tipo_pedido_filter_p::text, '') = '' THEN  'S'  ELSE obter_se_contido_char(nr_seq_cpoe_tipo_pedido, nr_tipo_pedido_filter_p) END  = 'S'
		and (ie_my_department_p = 'N' or a.cd_departamento = wheb_usuario_pck.get_cd_setor_atendimento())
		order by a.ie_tipo_item, a.dt_inicio;

	
BEGIN

	PERFORM set_config('cpoe_overview_pck.nm_usuario_w', nm_usuario_p, false);
	PERFORM set_config('cpoe_overview_pck.ie_view_mode_w', ie_view_mode_p, false);
	PERFORM set_config('cpoe_overview_pck.ie_show_dates_w', ie_show_dates_p, false);
	PERFORM set_config('cpoe_overview_pck.ie_ignore_dates_w', ie_ignore_dates_p, false);
	PERFORM set_config('cpoe_overview_pck.ie_consider_encounter_w', ie_consider_encounter_p, false);
	PERFORM set_config('cpoe_overview_pck.ie_view_type_w', ie_view_type_p, false);

	if (current_setting('cpoe_overview_pck.ie_ignore_dates_w')::varchar(1) = 'S') then

		if (current_setting('cpoe_overview_pck.ie_consider_encounter_w')::varchar(1) = 'P') then

			PERFORM set_config('cpoe_overview_pck.dt_inicio_w', trunc(obter_dt_prim_atend_pac(obter_cd_pes_fis_atend(nr_atendimento_p))), false);
			PERFORM set_config('cpoe_overview_pck.dt_fim_w', fim_dia(clock_timestamp() + interval '1 days'), false);
			
		else

			select  min(a.dt_prescricao)
			into STRICT	current_setting('cpoe_overview_pck.dt_prim_prescr_w')::timestamp
			from   	prescr_medica a
			where   (a.dt_liberacao IS NOT NULL AND a.dt_liberacao::text <> '')
			and 	coalesce(a.dt_suspensao::text, '') = ''
			and     a.nr_atendimento = nr_atendimento_p;
			
			PERFORM set_config('cpoe_overview_pck.dt_inicio_w', trunc(current_setting('cpoe_overview_pck.dt_prim_prescr_w')::timestamp), false);
			PERFORM set_config('cpoe_overview_pck.dt_fim_w', fim_dia(clock_timestamp() + interval '1 days'), false);
		
		end if;

	else

		PERFORM set_config('cpoe_overview_pck.dt_inicio_w', trunc(dt_inicio_p), false);
		PERFORM set_config('cpoe_overview_pck.dt_fim_w', fim_dia(dt_fim_p), false);

	end if;

	if (current_setting('cpoe_overview_pck.ie_consider_encounter_w')::varchar(1) = 'P') then

		PERFORM set_config('cpoe_overview_pck.cd_pessoa_fisica_w', coalesce(cd_pessoa_fisica_p, obter_cd_pes_fis_atend(nr_atendimento_p)), false);
			
	elsif (current_setting('cpoe_overview_pck.ie_consider_encounter_w')::varchar(1) = 'A') then
			
		PERFORM set_config('cpoe_overview_pck.nr_atendimento_w', nr_atendimento_p, false);
		
	end if;

	delete	from cpoe_overview_item
	where	dt_atualizacao < clock_timestamp() - interval '12 days'/24;

	delete 	FROM cpoe_overview_item
	where	nm_usuario = current_setting('cpoe_overview_pck.nm_usuario_w')::varchar(15)
	and (coalesce(nr_atendimento, nr_atendimento_p) = nr_atendimento_p or coalesce(nr_atendimento_p::text, '') = '')
	and (coalesce(cd_pessoa_fisica, cd_pessoa_fisica_p) = cd_pessoa_fisica_p or coalesce(cd_pessoa_fisica_p::text, '') = '');

	commit;

	current_setting('cpoe_overview_pck.vetoritemprescricao_w')::vetorItemPrescricao.delete;

	for r_c01 in c01 loop
		begin


		indice_w	:= current_setting('cpoe_overview_pck.vetoritemprescricao_w')::vetorItemPrescricao.count + 1;

		current_setting('cpoe_overview_pck.vetoritemprescricao_w')::vetorItemPrescricao[indice_w].ds_item				:= r_c01.ds_item;
		current_setting('cpoe_overview_pck.vetoritemprescricao_w')::vetorItemPrescricao[indice_w].nr_seq_item_cpoe		:= r_c01.nr_sequencia;
		current_setting('cpoe_overview_pck.vetoritemprescricao_w')::vetorItemPrescricao[indice_w].ie_tipo_item			:= r_c01.ie_tipo_item;
		current_setting('cpoe_overview_pck.vetoritemprescricao_w')::vetorItemPrescricao[indice_w].dt_fim				:= r_c01.dt_fim;
		current_setting('cpoe_overview_pck.vetoritemprescricao_w')::vetorItemPrescricao[indice_w].dt_inicio			:= r_c01.dt_inicio;
		current_setting('cpoe_overview_pck.vetoritemprescricao_w')::vetorItemPrescricao[indice_w].ds_html				:= r_c01.ds_html;
		current_setting('cpoe_overview_pck.vetoritemprescricao_w')::vetorItemPrescricao[indice_w].ds_label_html			:= r_c01.ds_label_html;
		current_setting('cpoe_overview_pck.vetoritemprescricao_w')::vetorItemPrescricao[indice_w].ds_horarios			:= r_c01.ds_horarios;
		current_setting('cpoe_overview_pck.vetoritemprescricao_w')::vetorItemPrescricao[indice_w].cd_material			:= r_c01.cd_material;
		current_setting('cpoe_overview_pck.vetoritemprescricao_w')::vetorItemPrescricao[indice_w].qt_dose				:= r_c01.qt_dose;
		current_setting('cpoe_overview_pck.vetoritemprescricao_w')::vetorItemPrescricao[indice_w].cd_unidade_medida		:= r_c01.cd_unidade_medida;
		current_setting('cpoe_overview_pck.vetoritemprescricao_w')::vetorItemPrescricao[indice_w].ie_via_aplicacao		:= r_c01.ie_via_aplicacao;
		current_setting('cpoe_overview_pck.vetoritemprescricao_w')::vetorItemPrescricao[indice_w].nr_seq_cpoe_rp			:= r_c01.nr_seq_cpoe_rp;
		current_setting('cpoe_overview_pck.vetoritemprescricao_w')::vetorItemPrescricao[indice_w].nr_seq_cpoe_order_unit		:= r_c01.nr_seq_cpoe_order_unit;
		current_setting('cpoe_overview_pck.vetoritemprescricao_w')::vetorItemPrescricao[indice_w].nr_seq_cpoe_tipo_pedido		:= r_c01.nr_seq_cpoe_tipo_pedido;
		current_setting('cpoe_overview_pck.vetoritemprescricao_w')::vetorItemPrescricao[indice_w].cd_departamento			:= r_c01.cd_departamento;
		current_setting('cpoe_overview_pck.vetoritemprescricao_w')::vetorItemPrescricao[indice_w].dt_lib_suspensao		:= r_c01.dt_lib_suspensao;
		current_setting('cpoe_overview_pck.vetoritemprescricao_w')::vetorItemPrescricao[indice_w].cd_intervalo			:= r_c01.cd_intervalo;
				current_setting('cpoe_overview_pck.vetoritemprescricao_w')::vetorItemPrescricao(indice_w)  := cpoe_overview_pck.gerar_horarios(		current_setting('cpoe_overview_pck.vetoritemprescricao_w')::vetorItemPrescricao(indice_w) );

		end;
	end loop;


	END;

$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE cpoe_overview_pck.generate_view ( nr_atendimento_p bigint, cd_pessoa_fisica_p text, dt_inicio_p timestamp, dt_fim_p timestamp, nm_usuario_p text, ie_medicamento_p text default null, ie_solucao_p text default null, ie_recomendacao_p text default null, ie_hemoterapia_p text default null, ie_procedimento_p text default null, ie_gasoterapia_p text default null, ie_dialise_p text default null, ie_dieta_p text default null, cd_material_p bigint default null, ie_administracao_p text default null, ie_view_mode_p text default null, ie_show_dates_p text default null, ie_ignore_dates_p text default null, ie_consider_encounter_p text default 'A', ie_medical_depart_p text default null, nr_tipo_pedido_filter_p text default null, ie_view_type_p text default null, ie_encounter_type_p text default null, ds_material_list_p text default null, ie_suspensao_p text default null, ie_material_p text default null, ie_anatomia_p text default null, ie_my_department_p text default 'N') FROM PUBLIC;