-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE vipe_obter_dieta_oral ( cd_estabelecimento_p bigint, cd_setor_usuario_p bigint, cd_perfil_p bigint, nm_usuario_p text, nr_atendimento_p bigint, dt_inicial_horarios_p timestamp, dt_final_horarios_p timestamp, dt_validade_limite_p timestamp, ie_exibir_hor_realizados_p text, ie_exibir_hor_suspensos_p text, ie_regra_inclusao_p text, ie_data_lib_prescr_p text, ie_lib_pend_rep_p text, ie_exibir_suspensos_p text, ie_horarios_dietas_orais_p text, ie_exibe_sem_lib_farm_p text, ie_exibe_dietas_p text, ie_prescr_setor_p text, cd_setor_paciente_p bigint) AS $body$
DECLARE


nr_prescricao_w		bigint;
cd_refeicao_w		varchar(15);
ds_refeicao_w		varchar(255);
ie_lib_pend_rep_w	varchar(1);
nr_seq_wadep_w		bigint;
ie_status_item_w	varchar(1);
ds_inter_prescr_w	varchar(15);

c01 CURSOR FOR
SELECT	c.cd_refeicao,
	x.ds_valor_dominio,
	substr(obter_desc_intervalo_prescr(d.cd_intervalo),1,15) ds_intervalo
from	valor_dominio x,
	prescr_dieta d,
	prescr_dieta_hor c,
	prescr_medica a
where	x.vl_dominio = c.cd_refeicao
and	d.nr_prescricao = c.nr_prescricao
and	d.nr_prescricao = a.nr_prescricao
and	c.nr_prescricao = a.nr_prescricao
and	x.cd_dominio = 99
and	obter_se_exibir_rep_adep_setor(cd_setor_paciente_p,a.cd_setor_atendimento,coalesce(a.ie_adep,'S')) = 'S'
and	a.nr_atendimento = nr_atendimento_p
and	a.dt_validade_prescr > dt_validade_limite_p
and	((obter_se_prescr_lib_vipe(a.dt_liberacao_medico, a.dt_liberacao, a.dt_liberacao_farmacia, ie_data_lib_prescr_p,c.dt_lib_horario) = 'S') or
	((ie_exibe_sem_lib_farm_p = 'S') and (coalesce(a.IE_PRESCR_NUTRICAO, 'N') = 'S')))
and	((ie_exibir_suspensos_p = 'S') or (coalesce(d.dt_suspensao::text, '') = ''))
and	coalesce(c.ie_situacao,'A') = 'A'
and	c.dt_horario between dt_inicial_horarios_p and dt_final_horarios_p
and	((ie_exibir_hor_realizados_p = 'S') or (coalesce(c.dt_fim_horario::text, '') = ''))
and	((ie_exibir_hor_suspensos_p = 'S') or (coalesce(c.dt_suspensao::text, '') = ''))
and	((ie_prescr_setor_p = 'N') or (ie_prescr_setor_p = 'S' AND a.cd_setor_atendimento = cd_setor_paciente_p))
and	((ie_data_lib_prescr_p = 'M') or (Obter_se_horario_liberado(c.dt_lib_horario, c.dt_horario) = 'S'))
group by
	c.cd_refeicao,
	x.ds_valor_dominio,
	d.cd_intervalo;

c02 CURSOR FOR
SELECT	to_char(d.cd_dieta),
	x.nm_dieta,
	substr(obter_status_hor_dieta_oral(c.dt_fim_horario,d.dt_suspensao),1,1),
	substr(obter_desc_intervalo_prescr(d.cd_intervalo),1,15) ds_intervalo
from	dieta x,
	prescr_dieta d,
	prescr_dieta_hor c,
	prescr_medica a
where	x.cd_dieta = d.cd_dieta
and	d.nr_prescricao = c.nr_prescricao
and	d.nr_prescricao	= a.nr_prescricao
and	c.nr_prescricao = a.nr_prescricao
and	obter_se_exibir_rep_adep_setor(cd_setor_paciente_p,a.cd_setor_atendimento,coalesce(a.ie_adep,'S')) = 'S'
and	a.nr_atendimento = nr_atendimento_p
and	a.dt_validade_prescr > dt_validade_limite_p
and	obter_se_prescr_lib_vipe(a.dt_liberacao_medico, a.dt_liberacao, a.dt_liberacao_farmacia, ie_data_lib_prescr_p,c.dt_lib_horario) = 'S'
and	((ie_exibir_suspensos_p = 'S') or (coalesce(d.dt_suspensao::text, '') = ''))
and	coalesce(c.ie_situacao,'A') = 'A'
and	c.dt_horario between dt_inicial_horarios_p and dt_final_horarios_p
and	((ie_exibir_hor_realizados_p = 'S') or (coalesce(c.dt_fim_horario::text, '') = ''))
and	((ie_exibir_hor_suspensos_p = 'S') or (coalesce(c.dt_suspensao::text, '') = ''))
and	((ie_prescr_setor_p = 'N') or (ie_prescr_setor_p = 'S' AND a.cd_setor_atendimento = cd_setor_paciente_p))
and	Obter_se_horario_liberado(c.dt_lib_horario, c.dt_horario) = 'S'
group by
	d.cd_dieta,
	x.nm_dieta,
	c.dt_fim_horario,
	d.dt_suspensao,
	d.cd_intervalo

union

select	to_char(d.cd_dieta),
	x.nm_dieta,
	substr(obter_status_hor_dieta_oral(null,d.dt_suspensao),1,1),
	substr(obter_desc_intervalo_prescr(d.cd_intervalo),1,15) ds_intervalo
from	dieta x,
	prescr_dieta d,
	prescr_medica a
where	x.cd_dieta = d.cd_dieta
and	d.nr_prescricao	= a.nr_prescricao
and	obter_se_exibir_rep_adep_setor(cd_setor_paciente_p,a.cd_setor_atendimento,coalesce(a.ie_adep,'S')) = 'S'
and	a.nr_atendimento = nr_atendimento_p
and	a.dt_validade_prescr > dt_validade_limite_p
and	((ie_exibir_suspensos_p = 'S') or (coalesce(d.dt_suspensao::text, '') = ''))
and	((ie_exibir_hor_suspensos_p = 'S') or (coalesce(d.dt_suspensao::text, '') = ''))
and	(a.dt_liberacao_medico IS NOT NULL AND a.dt_liberacao_medico::text <> '' AND a.dt_liberacao IS NOT NULL AND a.dt_liberacao::text <> '')
and	not exists (
		SELECT	1
		from	prescr_dieta_hor c
		where	c.nr_prescricao = d.nr_prescricao
		and	c.nr_prescricao = a.nr_prescricao
		and	Obter_se_horario_liberado(c.dt_lib_horario, c.dt_horario) = 'S')
and	ie_exibe_dietas_p = 'S'
and	((ie_prescr_setor_p = 'N') or (ie_prescr_setor_p = 'S' AND a.cd_setor_atendimento = cd_setor_paciente_p))
group by
	d.cd_dieta,
	x.nm_dieta,
	d.dt_suspensao,
	d.cd_intervalo;

c03 CURSOR FOR
SELECT	a.nr_prescricao,
	to_char(d.cd_dieta),
	x.nm_dieta,
	substr(adep_obter_lib_pend_rep_gestao(a.dt_liberacao_medico,a.dt_liberacao,a.dt_liberacao_farmacia),1,1) ie_lib_pend_rep,
	substr(obter_desc_intervalo_prescr(d.cd_intervalo),1,15) ds_intervalo
from	dieta x,
	prescr_dieta d,
	prescr_medica a
where	x.cd_dieta = d.cd_dieta
and	d.nr_prescricao	= a.nr_prescricao
and	obter_se_exibir_rep_adep_setor(cd_setor_paciente_p,a.cd_setor_atendimento,coalesce(a.ie_adep,'S')) = 'S'
and	a.nr_atendimento = nr_atendimento_p
and	a.dt_validade_prescr > dt_validade_limite_p
--and	obter_se_prescr_lib_adep(a.dt_liberacao_medico, a.dt_liberacao, a.dt_liberacao_farmacia, ie_data_lib_prescr_p) = 'S'
and	obter_se_prescr_vig_adep(a.dt_inicio_prescr,a.dt_validade_prescr,dt_inicial_horarios_p,dt_final_horarios_p) = 'S'
and	((ie_exibir_suspensos_p = 'S') or (coalesce(d.dt_suspensao::text, '') = ''))
and	((ie_prescr_setor_p = 'N') or (ie_prescr_setor_p = 'S' AND a.cd_setor_atendimento = cd_setor_paciente_p))
and	not exists (
		SELECT	1
		from	prescr_dieta_hor c
		where	c.nr_prescricao = d.nr_prescricao
		and	c.nr_prescricao = a.nr_prescricao
		and	Obter_se_horario_liberado(c.dt_lib_horario, c.dt_horario) = 'S')
and	((ie_exibe_dietas_p = 'N') or ((ie_exibe_dietas_p = 'S') and ((coalesce(a.dt_liberacao_medico::text, '') = '') or (coalesce(dt_liberacao::text, '') = ''))))
group by
	a.nr_prescricao,
	d.cd_dieta,
	x.nm_dieta,
	a.dt_liberacao_medico,
	a.dt_liberacao,
	a.dt_liberacao_farmacia,
	d.cd_intervalo;


BEGIN
if (ie_horarios_dietas_orais_p <> 'N') then
	begin
	open c01;
	loop
	fetch c01 into	cd_refeicao_w,
			ds_refeicao_w,
			ds_inter_prescr_w;
	EXIT WHEN NOT FOUND; /* apply on c01 */
		begin
		select	nextval('w_vipe_t_seq')
		into STRICT	nr_seq_wadep_w
		;

		insert into w_vipe_t(
			nr_sequencia,
			nm_usuario,
			ie_tipo_item,
			cd_item,
			ds_item,
			ie_acm_sn,
			ie_diferenciado,
			nr_seq_proc_interno,
			nr_agrupamento,
			ds_interv_prescr
			)
		values (
			nr_seq_wadep_w,
			nm_usuario_p,
			'D',
			cd_refeicao_w,
			ds_refeicao_w,
			'N',
			'N',
			0,
			0,
			ds_inter_prescr_w
			);
		end;
	end loop;
	close c01;

	if (ie_lib_pend_rep_p = 'S') then
		begin
		open c03;
		loop
		fetch c03 into	nr_prescricao_w,
				cd_refeicao_w,
				ds_refeicao_w,
				ie_lib_pend_rep_w,
				ds_inter_prescr_w;
		EXIT WHEN NOT FOUND; /* apply on c03 */
			begin
			select	nextval('w_vipe_t_seq')
			into STRICT	nr_seq_wadep_w
			;

			insert into w_vipe_t(
				nr_sequencia,
				nm_usuario,
				ie_tipo_item,
				cd_item,
				ds_item,
				ie_acm_sn,
				ie_diferenciado,
				nr_seq_proc_interno,
				nr_agrupamento,
				ie_pendente_liberacao,
				nr_prescricao,
				ds_interv_prescr)
			values (
				nr_seq_wadep_w,
				nm_usuario_p,
				'D',
				cd_refeicao_w,
				ds_refeicao_w,
				'N',
				'N',
				0,
				0,
				ie_lib_pend_rep_w,
				nr_prescricao_w,
				ds_inter_prescr_w);
			end;
		end loop;
		close c03;
		end;
	end if;
	end;
else
	begin
	open c02;
	loop
	fetch c02 into	cd_refeicao_w,
			ds_refeicao_w,
			ie_status_item_w,
			ds_inter_prescr_w;
	EXIT WHEN NOT FOUND; /* apply on c02 */
		begin
		select	nextval('w_vipe_t_seq')
		into STRICT	nr_seq_wadep_w
		;

		insert into w_vipe_t(
			nr_sequencia,
			nm_usuario,
			ie_tipo_item,
			cd_item,
			ds_item,
			ie_acm_sn,
			ie_diferenciado,
			nr_seq_proc_interno,
			nr_agrupamento,
			ie_status_item,
			ds_interv_prescr)
		values (
			nr_seq_wadep_w,
			nm_usuario_p,
			'D',
			cd_refeicao_w,
			ds_refeicao_w,
			'N',
			'N',
			0,
			0,
			ie_status_item_w,
			ds_inter_prescr_w);
		end;
	end loop;
	close c02;

	if (ie_lib_pend_rep_p = 'S') then
		begin
		open c03;
		loop
		fetch c03 into	nr_prescricao_w,
				cd_refeicao_w,
				ds_refeicao_w,
				ie_lib_pend_rep_w,
				ds_inter_prescr_w;
		EXIT WHEN NOT FOUND; /* apply on c03 */
			begin
			select	nextval('w_vipe_t_seq')
			into STRICT	nr_seq_wadep_w
			;

			insert into w_vipe_t(
				nr_sequencia,
				nm_usuario,
				ie_tipo_item,
				cd_item,
				ds_item,
				ie_acm_sn,
				ie_diferenciado,
				nr_seq_proc_interno,
				nr_agrupamento,
				ie_pendente_liberacao,
				nr_prescricao,
				ds_interv_prescr)
			values (
				nr_seq_wadep_w,
				nm_usuario_p,
				'D',
				cd_refeicao_w,
				ds_refeicao_w,
				'N',
				'N',
				0,
				0,
				ie_lib_pend_rep_w,
				nr_prescricao_w,
				ds_inter_prescr_w);
			end;
		end loop;
		close c03;
		end;
	end if;
	end;
end if;
end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE vipe_obter_dieta_oral ( cd_estabelecimento_p bigint, cd_setor_usuario_p bigint, cd_perfil_p bigint, nm_usuario_p text, nr_atendimento_p bigint, dt_inicial_horarios_p timestamp, dt_final_horarios_p timestamp, dt_validade_limite_p timestamp, ie_exibir_hor_realizados_p text, ie_exibir_hor_suspensos_p text, ie_regra_inclusao_p text, ie_data_lib_prescr_p text, ie_lib_pend_rep_p text, ie_exibir_suspensos_p text, ie_horarios_dietas_orais_p text, ie_exibe_sem_lib_farm_p text, ie_exibe_dietas_p text, ie_prescr_setor_p text, cd_setor_paciente_p bigint) FROM PUBLIC;

