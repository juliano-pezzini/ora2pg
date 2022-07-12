-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';




CREATE OR REPLACE PROCEDURE cpoe_gerar_registro_json_pck.cpoe_gerar_registro_sae_json ( nr_atendimento_p bigint, dt_referencia_p timestamp, nm_usuario_p text, nr_prescricao_p bigint default null) AS $body$
DECLARE


current_setting('cpoe_gerar_registro_json_pck.ds_registro_w')::text				text;
ds_json_sae_w				text;
ds_node_horarios_w			text;
current_setting('cpoe_gerar_registro_json_pck.dt_horario_w')::prescr_mat_hor.dt_horario%type				varchar(20);
current_setting('cpoe_gerar_registro_json_pck.dt_fim_horario_w')::varchar(20)			varchar(20);
current_setting('cpoe_gerar_registro_json_pck.ds_intervalo_w')::varchar(255)				varchar(255);
current_setting('cpoe_gerar_registro_json_pck.ds_hora_w')::varchar(255)					varchar(255);
current_setting('cpoe_gerar_registro_json_pck.ds_prescritor_w')::varchar(255)				varchar(255);
current_setting('cpoe_gerar_registro_json_pck.dt_prescrito_w')::varchar(255)				varchar(255);
current_setting('cpoe_gerar_registro_json_pck.ds_conselho_w')::varchar(255)				varchar(255);
ds_intervencao_ww			varchar(4000);
current_setting('cpoe_gerar_registro_json_pck.nm_usuario_descontinuacao_w')::varchar(255)	varchar(255);
current_setting('cpoe_gerar_registro_json_pck.nr_hora_w')::integer					bigint;
current_setting('cpoe_gerar_registro_json_pck.dt_inicio_grid_w')::timestamp			timestamp;
current_setting('cpoe_gerar_registro_json_pck.ds_prescritor_reval_w')::varchar(255)		varchar(255);

nr_sequencia_w				cpoe_intervencao.nr_sequencia%type;	
current_setting('cpoe_gerar_registro_json_pck.ie_administracao_w')::cpoe_dieta.ie_administracao%type			cpoe_intervencao.ie_administracao%type;	
current_setting('cpoe_gerar_registro_json_pck.ie_urgencia_w')::varchar(1)				cpoe_intervencao.ie_urgencia%type;	
current_setting('cpoe_gerar_registro_json_pck.ie_duracao_w')::cpoe_dieta.ie_duracao%type				cpoe_intervencao.ie_duracao%type;
current_setting('cpoe_gerar_registro_json_pck.nm_usuario_susp_w')::cpoe_dieta.nm_usuario_susp%type			cpoe_intervencao.nm_usuario_susp%type;

current_setting('cpoe_gerar_registro_json_pck.nr_prescricao_w')::prescr_material.nr_prescricao%type				pe_prescricao.nr_sequencia%type;

current_setting('cpoe_gerar_registro_json_pck.dt_horario_ww')::prescr_gasoterapia_hor.dt_horario%type				pe_prescr_proc_hor.dt_horario%type;
dt_horario_fim_w			pe_prescr_proc_hor.dt_horario%type;
ds_intervencao_w			pe_procedimento.ds_procedimento%type;
count_cpoe_sae_w	 	bigint;
current_setting('cpoe_gerar_registro_json_pck.nr_seq_cpoe_order_unit_w')::cpoe_order_unit.nr_sequencia%type        cpoe_order_unit.nr_sequencia%type;

current_setting('cpoe_gerar_registro_json_pck.c01')::CURSOR CURSOR FOR  -- SAE
	SELECT	distinct a.nr_seq_proc nr_seq_proc_w,
		a.cd_intervalo current_setting('cpoe_gerar_registro_json_pck.cd_intervalo_w')::prescr_gasoterapia.cd_intervalo%type,
		a.nr_sequencia nr_sequencia_w,
		a.nr_seq_topografia nr_seq_topografia_w,
		a.hr_prim_horario current_setting('cpoe_gerar_registro_json_pck.hr_prim_horario_w')::varchar(5),
		coalesce(a.ie_se_necessario,'N') current_setting('cpoe_gerar_registro_json_pck.ie_se_necessario_w')::varchar(1),
		coalesce(a.ie_acm,'N') current_setting('cpoe_gerar_registro_json_pck.ie_acm_w')::varchar(1),
		coalesce(a.ie_urgencia,'N') ie_agora_w,
		a.ie_lado ie_lado_w,
		a.ds_horarios current_setting('cpoe_gerar_registro_json_pck.ds_horarios_w')::prescr_gasoterapia.ds_horarios%type,
		a.ds_observacao current_setting('cpoe_gerar_registro_json_pck.ds_observacao_w')::prescr_gasoterapia.ds_observacao%type,
		a.dt_suspensao current_setting('cpoe_gerar_registro_json_pck.dt_suspensao_w')::varchar(20),
		a.dt_lib_suspensao current_setting('cpoe_gerar_registro_json_pck.dt_lib_suspensao_w')::cpoe_dieta.dt_lib_suspensao%type,
		a.dt_liberacao current_setting('cpoe_gerar_registro_json_pck.dt_liberacao_w')::prescr_medica.dt_liberacao%type,
		a.dt_atualizacao current_setting('cpoe_gerar_registro_json_pck.dt_atualizacao_w')::prescr_gasoterapia.dt_atualizacao%type,
		a.dt_atualizacao_nrec current_setting('cpoe_gerar_registro_json_pck.dt_atualizacao_nrec_w')::prescr_gasoterapia_evento.dt_atualizacao_nrec%type,
		a.nm_usuario current_setting('cpoe_gerar_registro_json_pck.nm_usuario_w')::prescr_gasoterapia.nm_usuario%type,
		a.nm_usuario_nrec current_setting('cpoe_gerar_registro_json_pck.nm_usuario_nrec_w')::prescr_gasoterapia_evento.nm_usuario_nrec%type,
		a.cd_prescritor cd_prescritor_w,
		a.dt_prescricao dt_prescricao_w,
		a.cd_pessoa_fisica cd_pessoa_fisica_w,
		a.cd_perfil_ativo cd_perfil_ativo_w,
		a.dt_inicio current_setting('cpoe_gerar_registro_json_pck.dt_inicio_w')::cpoe_dieta.dt_inicio%type,
		a.dt_fim current_setting('cpoe_gerar_registro_json_pck.dt_fim_w')::cpoe_dieta.dt_fim%type,
		a.nr_seq_cpoe_order_unit current_setting('cpoe_gerar_registro_json_pck.nr_seq_cpoe_order_unit_w')::cpoe_order_unit.nr_sequencia%type
	from	cpoe_intervencao a,
		pe_prescr_proc b,
		pe_prescr_proc_hor c,
		pe_prescricao d
	where	a.nr_atendimento = nr_atendimento_p
	and	a.dt_inicio > current_setting('cpoe_gerar_registro_json_pck.dt_hora_formatada_w')::timestamp - 1
	and	a.nr_sequencia = b.nr_seq_cpoe_interv
	and	(a.dt_liberacao IS NOT NULL AND a.dt_liberacao::text <> '')
	and  ((a.dt_fim > current_setting('cpoe_gerar_registro_json_pck.dt_hora_formatada_w')::timestamp) or (coalesce(a.dt_fim::text, '') = ''))
	and	b.nr_seq_prescr = c.nr_seq_pe_prescr
	and	b.nr_sequencia = c.nr_seq_pe_proc
	and	b.nr_seq_prescr = d.nr_sequencia
	and	c.nr_seq_pe_prescr = d.nr_sequencia
	and	d.nr_atendimento = a.nr_atendimento
	and ((coalesce(nr_prescricao_p,0) = 0)  or (d.nr_prescricao = nr_prescricao_p))
	and c.dt_horario between current_setting('cpoe_gerar_registro_json_pck.dt_hora_formatada_w')::timestamp and current_setting('cpoe_gerar_registro_json_pck.dt_hora_fim_formatada_w')::timestamp
	order by	a.nr_sequencia;

current_setting('cpoe_gerar_registro_json_pck.c02')::CURSOR CURSOR FOR
	SELECT	coalesce(to_char(b.dt_horario,'dd/mm/yyyy hh24:mi'),'null'),
			coalesce(to_char(b.dt_fim_horario,'dd/mm/yyyy hh24:mi'),'null'),
			b.dt_suspensao,
			b.dt_horario
	from	pe_prescr_proc a,
			pe_prescr_proc_hor b
	where	a.nr_sequencia = b.nr_seq_pe_proc
	and		a.nr_seq_cpoe_interv = nr_sequencia_w
	and		b.dt_horario between current_setting('cpoe_gerar_registro_json_pck.dt_hora_formatada_w')::timestamp	and	current_setting('cpoe_gerar_registro_json_pck.dt_hora_fim_formatada_w')::timestamp
	order by b.dt_horario;

BEGIN

for c01_sae_w in current_setting('cpoe_gerar_registro_json_pck.c01')::loop CURSOR
	nr_sequencia_w := c01_sae_w.nr_sequencia_w;
	c01_sae_w.dt_suspensao_w := cpoe_gerar_registro_json_pck.regra_data_susp(c01_sae_w.dt_suspensao_w);
	c01_sae_w.dt_lib_suspensao_w := cpoe_gerar_registro_json_pck.regra_data_susp(c01_sae_w.dt_lib_suspensao_w);
	ds_intervencao_w := obter_desc_intervencoes(c01_sae_w.nr_seq_proc_w);

	select count(*)
	into STRICT   count_cpoe_sae_w
	from   cpoe_intervencao
	where  nr_sequencia = c01_sae_w.nr_sequencia_w;

	if (count_cpoe_sae_w > 0) then

		select substr(obter_desc_intervalo_prescr(cd_intervalo),1,255) ds_intervalo,
			obter_initcap(obter_nome_pessoa_fisica(cd_prescritor, null)) ds_prescritor,
			cpoe_obter_tempo_prescrito(dt_prescricao) dt_prescrito,
			cpoe_obter_data_hora_form(dt_prescricao,hr_prim_horario) dt_inicio_grid,
			substr(obter_dados_pf(cd_prescritor,'COPR'),1,255) ds_conselho,
			CASE WHEN coalesce(cpoe_gerar_registro_json_pck.regra_data_susp(dt_suspensao)::text, '') = '' THEN  null  ELSE nm_usuario_susp END ,
			CASE WHEN coalesce(cpoe_gerar_registro_json_pck.regra_data_susp(dt_suspensao)::text, '') = '' THEN  null  ELSE cpoe_obter_info_suspensao(nr_sequencia,'I','N') END  nm_usuario_descontinuacao,
			obter_pf_usuario(coalesce(nm_usuario, nm_usuario_nrec),'N') ds_prescritor_reval
		into STRICT   current_setting('cpoe_gerar_registro_json_pck.ds_intervalo_w')::varchar(255),
			current_setting('cpoe_gerar_registro_json_pck.ds_prescritor_w')::varchar(255),
			current_setting('cpoe_gerar_registro_json_pck.dt_prescrito_w')::varchar(255),
			current_setting('cpoe_gerar_registro_json_pck.dt_inicio_grid_w')::timestamp,
			current_setting('cpoe_gerar_registro_json_pck.ds_conselho_w')::varchar(255),
			current_setting('cpoe_gerar_registro_json_pck.nm_usuario_susp_w')::cpoe_dieta.nm_usuario_susp%type,
			current_setting('cpoe_gerar_registro_json_pck.nm_usuario_descontinuacao_w')::varchar(255),
			current_setting('cpoe_gerar_registro_json_pck.ds_prescritor_reval_w')::varchar(255)
		from   cpoe_intervencao
		where  nr_sequencia = c01_sae_w.nr_sequencia_w;

	end if;

	ds_intervencao_ww := ds_intervencao_w;
	CALL cpoe_gerar_registro_json_pck.cpoe_limpar_valores_horas();

	c01_sae_w.dt_inicio_w := current_setting('cpoe_gerar_registro_json_pck.dt_inicio_grid_w')::timestamp;
	PERFORM set_config('cpoe_gerar_registro_json_pck.ie_duracao_w', 'P', false);
	PERFORM set_config('cpoe_gerar_registro_json_pck.ie_administracao_w', 'P', false);
	PERFORM set_config('cpoe_gerar_registro_json_pck.ie_urgencia_w', '', false);

	if (c01_sae_w.ie_agora_w = 'S') then
		PERFORM set_config('cpoe_gerar_registro_json_pck.ie_urgencia_w', '0', false);
	elsif (c01_sae_w.ie_acm_w = 'S') then
		PERFORM set_config('cpoe_gerar_registro_json_pck.ie_administracao_w', 'C', false);
		c01_sae_w.ds_horarios_w := '';
	elsif (c01_sae_w.ie_se_necessario_w = 'S') then
		PERFORM set_config('cpoe_gerar_registro_json_pck.ie_administracao_w', 'N', false);
		c01_sae_w.ds_horarios_w := '';
	end if;	

	open current_setting('cpoe_gerar_registro_json_pck.c02')::CURSOR;
	loop
	fetch current_setting('cpoe_gerar_registro_json_pck.c02')::into CURSOR
		current_setting('cpoe_gerar_registro_json_pck.dt_horario_w')::prescr_mat_hor.dt_horario%type,
		current_setting('cpoe_gerar_registro_json_pck.dt_fim_horario_w')::varchar(20),
		c01_sae_w.dt_suspensao_w,
		current_setting('cpoe_gerar_registro_json_pck.dt_horario_ww')::prescr_gasoterapia_hor.dt_horario%type;
	EXIT WHEN NOT FOUND; /* apply on current_setting('cpoe_gerar_registro_json_pck.c02')::CURSOR */

		PERFORM set_config('cpoe_gerar_registro_json_pck.nr_hora_w', to_char(current_setting('cpoe_gerar_registro_json_pck.dt_horario_ww')::prescr_gasoterapia_hor.dt_horario%type,'hh24'), false);
		PERFORM set_config('cpoe_gerar_registro_json_pck.ds_hora_w', 'P', false);

		if (current_setting('cpoe_gerar_registro_json_pck.dt_fim_horario_w')::varchar(20) <> 'null') then
			PERFORM set_config('cpoe_gerar_registro_json_pck.ds_hora_w', 'S', false);
		end if;	

		if (c01_sae_w.dt_suspensao_w IS NOT NULL AND c01_sae_w.dt_suspensao_w::text <> '') then
			PERFORM set_config('cpoe_gerar_registro_json_pck.ds_hora_w', 'N', false);
		end if;

		CALL cpoe_gerar_registro_json_pck.cpoe_seta_status_horario(current_setting('cpoe_gerar_registro_json_pck.nr_hora_w')::integer, current_setting('cpoe_gerar_registro_json_pck.ds_hora_w')::varchar(255));

		if ((c01_sae_w.dt_fim_w IS NOT NULL AND c01_sae_w.dt_fim_w::text <> '') and (c01_sae_w.dt_fim_w between current_setting('cpoe_gerar_registro_json_pck.dt_hora_formatada_w')::timestamp	and	current_setting('cpoe_gerar_registro_json_pck.dt_hora_fim_formatada_w')::timestamp)) then
			begin
			CALL cpoe_gerar_registro_json_pck.cpoe_seta_status_fim_validade(c01_sae_w.dt_fim_w);
			end;
		end if;

	end loop;
	close current_setting('cpoe_gerar_registro_json_pck.c02')::CURSOR;

	if ((c01_sae_w.dt_inicio_w IS NOT NULL AND c01_sae_w.dt_inicio_w::text <> '') and (c01_sae_w.dt_inicio_w between current_setting('cpoe_gerar_registro_json_pck.dt_hora_formatada_w')::timestamp	and	current_setting('cpoe_gerar_registro_json_pck.dt_hora_fim_formatada_w')::timestamp)) then
		begin
		CALL cpoe_gerar_registro_json_pck.cpoe_seta_status_ini_validade(c01_sae_w.dt_inicio_w);
		end;
	end if;

	if (coalesce(c01_sae_w.dt_lib_suspensao_w::text, '') = '')  then
		c01_sae_w.dt_suspensao_w := null;
	end if;

	ds_json_sae_w := ds_json_sae_w || '{' ||
					format_array_json('NR_SEQ_PROC', c01_sae_w.nr_seq_proc_w,1)  ||
					format_array_json('DS_INTERVENCAO', cpoe_gerar_registro_json_pck.remove_aspas(ds_intervencao_w),1) ||
					format_array_json('DS_ITEM', ds_intervencao_ww,1) ||
					format_array_json('CD_INTERVALO',c01_sae_w.cd_intervalo_w,1)  ||
					format_array_json('NR_SEQ_TOPOGRAFIA', c01_sae_w.nr_seq_topografia_w,1) ||
					format_array_json('IE_LADO', c01_sae_w.ie_lado_w,1) ||
					format_array_json('IE_ADMINISTRACAO', current_setting('cpoe_gerar_registro_json_pck.ie_administracao_w')::cpoe_dieta.ie_administracao%type,1) ||
					format_array_json('IE_ACM', c01_sae_w.ie_acm_w,1) ||
					format_array_json('IE_SE_NECESSARIO', c01_sae_w.ie_se_necessario_w,1) ||
					format_array_json('DT_INICIO', to_char(c01_sae_w.dt_inicio_w, 'dd/mm/yyyy hh24:mi:ss'),1) ||
					format_array_json('DT_INICIO_GRID', to_char(current_setting('cpoe_gerar_registro_json_pck.dt_inicio_grid_w')::timestamp, 'dd/mm/yyyy hh24:mi:ss'),1) ||
					format_array_json('HR_PRIM_HORARIO', c01_sae_w.hr_prim_horario_w,1) ||
					format_array_json('IE_URGENCIA', current_setting('cpoe_gerar_registro_json_pck.ie_urgencia_w')::varchar(1),1) ||
					format_array_json('DS_HORARIOS', c01_sae_w.ds_horarios_w,1) ||
					format_array_json('IE_DURACAO', current_setting('cpoe_gerar_registro_json_pck.ie_duracao_w')::cpoe_dieta.ie_duracao%type,1) ||
					format_array_json('DT_FIM', to_char(c01_sae_w.dt_fim_w, 'dd/mm/yyyy hh24:mi:ss'),1) ||
					format_array_json('DS_OBSERVACAO', c01_sae_w.ds_observacao_w,1) ||
					format_array_json('DT_LIBERACAO', to_char(c01_sae_w.dt_liberacao_w, 'dd/mm/yyyy hh24:mi:ss'),1) ||
					format_array_json('DT_SUSPENSAO', to_char(c01_sae_w.dt_suspensao_w, 'dd/mm/yyyy hh24:mi:ss'),1) ||
					format_array_json('DT_LIB_SUSPENSAO', to_char(c01_sae_w.dt_lib_suspensao_w, 'dd/mm/yyyy hh24:mi:ss'),1) ||
					format_array_json('DT_DESCONTINUACAO', to_char(c01_sae_w.dt_suspensao_w, 'dd/mm/yyyy hh24:mi:ss'),1) ||
					format_array_json('NM_USUARIO_SUSP', current_setting('cpoe_gerar_registro_json_pck.nm_usuario_susp_w')::cpoe_dieta.nm_usuario_susp%type,1) ||
					format_array_json('NM_USUARIO_DESCONTINUACAO', current_setting('cpoe_gerar_registro_json_pck.nm_usuario_descontinuacao_w')::varchar(255),1) ||
					format_array_json('NR_ATENDIMENTO', nr_atendimento_p,1) ||
					format_array_json('NR_PRESCRICAO', current_setting('cpoe_gerar_registro_json_pck.nr_prescricao_w')::prescr_material.nr_prescricao%type,1) ||
					format_array_json('NR_SEQ_SAE_CPOE', c01_sae_w.nr_sequencia_w,1) ||
					format_array_json('NM_USUARIO', c01_sae_w.nm_usuario_w,1) ||
					format_array_json('NM_USUARIO_NREC', c01_sae_w.nm_usuario_nrec_w,1) ||
					format_array_json('DT_ATUALIZACAO', c01_sae_w.dt_atualizacao_w,1) ||
					format_array_json('DT_ATUALIZACAO_NREC', c01_sae_w.dt_atualizacao_nrec_w,1) ||
					format_array_json('DS_PRESCRITOR_DETALHE', cpoe_gerar_registro_json_pck.remove_aspas(current_setting('cpoe_gerar_registro_json_pck.ds_prescritor_w')::varchar(255)),1) ||
					format_array_json('DT_PRESCRITA_DETALHE', current_setting('cpoe_gerar_registro_json_pck.dt_prescrito_w')::varchar(255),1) ||
					format_array_json('DS_CONSELHO', cpoe_gerar_registro_json_pck.remove_aspas(current_setting('cpoe_gerar_registro_json_pck.ds_conselho_w')::varchar(255)),1) ||	
					format_array_json('DS_PRESCRITOR', cpoe_gerar_registro_json_pck.remove_aspas(current_setting('cpoe_gerar_registro_json_pck.ds_prescritor_w')::varchar(255)),1) ||
					format_array_json('DS_PRESCRITOR_REVAL', cpoe_gerar_registro_json_pck.remove_aspas(current_setting('cpoe_gerar_registro_json_pck.ds_prescritor_reval_w')::varchar(255)),1) ||
					format_array_json('NR_SEQ_VISAO', 26028,1) ||
					format_array_json('DS_HORA_00',current_setting('cpoe_gerar_registro_json_pck.ds_hora_00_w')::varchar(50),1)	||
					format_array_json('DS_HORA_01',current_setting('cpoe_gerar_registro_json_pck.ds_hora_01_w')::varchar(50),1)  ||
					format_array_json('DS_HORA_02',current_setting('cpoe_gerar_registro_json_pck.ds_hora_02_w')::varchar(50),1)  ||
					format_array_json('DS_HORA_03',current_setting('cpoe_gerar_registro_json_pck.ds_hora_03_w')::varchar(50),1)  ||
					format_array_json('DS_HORA_04',current_setting('cpoe_gerar_registro_json_pck.ds_hora_04_w')::varchar(50),1)  ||
					format_array_json('DS_HORA_05',current_setting('cpoe_gerar_registro_json_pck.ds_hora_05_w')::varchar(50),1)  ||
					format_array_json('DS_HORA_06',current_setting('cpoe_gerar_registro_json_pck.ds_hora_06_w')::varchar(50),1)  ||
					format_array_json('DS_HORA_07',current_setting('cpoe_gerar_registro_json_pck.ds_hora_07_w')::varchar(50),1)  ||
					format_array_json('DS_HORA_08',current_setting('cpoe_gerar_registro_json_pck.ds_hora_08_w')::varchar(50),1)  ||
					format_array_json('DS_HORA_09',current_setting('cpoe_gerar_registro_json_pck.ds_hora_09_w')::varchar(50),1)  ||
					format_array_json('DS_HORA_10',current_setting('cpoe_gerar_registro_json_pck.ds_hora_10_w')::varchar(50),1)  ||
					format_array_json('DS_HORA_11',current_setting('cpoe_gerar_registro_json_pck.ds_hora_11_w')::varchar(50),1)  ||
					format_array_json('DS_HORA_12',current_setting('cpoe_gerar_registro_json_pck.ds_hora_12_w')::varchar(50),1)  ||
					format_array_json('DS_HORA_13',current_setting('cpoe_gerar_registro_json_pck.ds_hora_13_w')::varchar(50),1)  ||
					format_array_json('DS_HORA_14',current_setting('cpoe_gerar_registro_json_pck.ds_hora_14_w')::varchar(50),1)  ||
					format_array_json('DS_HORA_15',current_setting('cpoe_gerar_registro_json_pck.ds_hora_15_w')::varchar(50),1)  ||
					format_array_json('DS_HORA_16',current_setting('cpoe_gerar_registro_json_pck.ds_hora_16_w')::varchar(50),1)  ||
					format_array_json('DS_HORA_17',current_setting('cpoe_gerar_registro_json_pck.ds_hora_17_w')::varchar(50),1)  ||
					format_array_json('DS_HORA_18',current_setting('cpoe_gerar_registro_json_pck.ds_hora_18_w')::varchar(50),1)  ||
					format_array_json('DS_HORA_19',current_setting('cpoe_gerar_registro_json_pck.ds_hora_19_w')::varchar(50),1)  ||
					format_array_json('DS_HORA_20',current_setting('cpoe_gerar_registro_json_pck.ds_hora_20_w')::varchar(50),1)  ||
					format_array_json('DS_HORA_21',current_setting('cpoe_gerar_registro_json_pck.ds_hora_21_w')::varchar(50),1)  ||
					format_array_json('DS_HORA_22',current_setting('cpoe_gerar_registro_json_pck.ds_hora_22_w')::varchar(50),1)  ||
					format_array_json('DS_HORA_23',current_setting('cpoe_gerar_registro_json_pck.ds_hora_23_w')::varchar(50),1) ||
					format_array_json('NR_SEQ_CPOE_ORDER_UNIT', c01_sae_w.nr_seq_cpoe_order_unit_w, 1);

	ds_json_sae_w := substr(ds_json_sae_w,1,length(ds_json_sae_w)-2) || '},';

end loop;

	if (ds_json_sae_w IS NOT NULL AND ds_json_sae_w::text <> '') then
		begin
		PERFORM set_config('cpoe_gerar_registro_json_pck.ds_registro_w', format_json('DS_SAE', ds_json_sae_w), false);

		CALL cpoe_gerar_registro_json_pck.cpoe_salvar_json( 	nr_atendimento_p,
							dt_referencia_p,
							nm_usuario_p,
							'I',
							current_setting('cpoe_gerar_registro_json_pck.ds_registro_w')::text);
		end;
	end if;

commit;

END;

$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE cpoe_gerar_registro_json_pck.cpoe_gerar_registro_sae_json ( nr_atendimento_p bigint, dt_referencia_p timestamp, nm_usuario_p text, nr_prescricao_p bigint default null) FROM PUBLIC;
