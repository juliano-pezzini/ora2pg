-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';



CREATE TYPE t_seq_diag_row AS (
	nr_seq_old	pe_prescr_diag.nr_sequencia%type,
	nr_seq_new	pe_prescr_diag.nr_sequencia%type);
CREATE TYPE t_seq_care_plan_row AS (
	nr_seq_old	patient_care_plan.nr_sequencia%type,
	nr_seq_new	patient_care_plan.nr_sequencia%type);
CREATE TYPE t_seq_indic_plan_row AS (
	nr_seq_old	patient_cp_indic_plan.nr_sequencia%type,
	nr_seq_new	patient_cp_indic_plan.nr_sequencia%type);


CREATE OR REPLACE PROCEDURE gerar_plano_cuidado_vigente ( nr_seq_prescricao_p bigint, ie_inativar_p text) AS $body$
DECLARE


ie_processo_plano_w	varchar(5);

nr_seq_prescricao_w	pe_prescricao.nr_sequencia%type;
cd_paciente_w	pe_prescricao.cd_pessoa_fisica%type;
nr_seq_prescr_w	pe_prescricao.nr_sequencia%type;

nr_seq_diag_new_w	pe_prescr_diag.nr_sequencia%type;
nr_seq_plan_new_w	patient_care_plan.nr_sequencia%type;
nr_seq_indic_new_w	patient_cp_indic_plan.nr_sequencia%type;
type t_seq_diag_data is table of t_seq_diag_row index by integer;
seq_diag_row_w	t_seq_diag_data;
type t_seq_care_plan_data is table of t_seq_care_plan_row index by integer;
seq_care_plan_row_w	t_seq_care_plan_data;
type t_seq_indic_plan_data is table of t_seq_indic_plan_row index by integer;
seq_indic_plan_row_w	t_seq_indic_plan_data;

procedure copiar_intervencao(
	nr_seq_prescr_p	bigint) is;
BEGIN
insert into pe_prescr_proc(
	nr_sequencia,
	dt_atualizacao,
	nm_usuario,
	nr_seq_proc,
	nr_seq_prescr,
	qt_pontuacao,
	ds_origem,
	nr_seq_apres,
	cd_intervalo,
	ds_horarios,
	qt_intervencao,
	hr_prim_horario,
	ie_se_necessario,
	ds_observacao,
	dt_atualizacao_nrec,
	nm_usuario_nrec,
	ie_suspenso,
	ie_adep,
	nr_seq_topografia,
	dt_suspensao,
	nm_usuario_susp,
	ie_lado,
	nr_ocorrencia,
	ie_permite_exclusao,
	ie_agora,
	nr_seq_prot_proc,
	hr_horario_espec,
	ie_interv_espec_agora,
	nr_seq_diag,
	nr_seq_item,
	nr_seq_result,
	ie_acm,
	cd_responsavel,
	ie_faose,
	ie_profissional,
	ie_auxiliar,
	ie_encaminhar,
	ie_fazer,
	ie_orientar,
	ie_supervisionar,
	ie_confirmada,
	ds_justificativa,
	nr_seq_cpoe_interv,
	dt_fim,
	dt_inicio,
	dt_primeiro_horario,
	dt_horario_espec,
	nr_seq_pat_cp_interv,
	nr_seq_pat_cp_problem,
	nr_seq_rel_diag,
	ie_related_problem,
	ds_display_name,
	ie_classif_ote,
	ie_free_item,
	nr_prescr_orig,
	nr_seq_atend_disp,
	nr_seq_cur_ferida )
SELECT	nextval('pe_prescr_proc_seq'),
	clock_timestamp(),
	wheb_usuario_pck.get_nm_usuario,
	a.nr_seq_proc,
	nr_seq_prescricao_w,
	a.qt_pontuacao,
	a.ds_origem,
	a.nr_seq_apres,
	a.cd_intervalo,
	a.ds_horarios,
	a.qt_intervencao,
	a.hr_prim_horario,
	a.ie_se_necessario,
	a.ds_observacao,
	a.dt_atualizacao_nrec,
	a.nm_usuario_nrec,
	a.ie_suspenso,
	a.ie_adep,
	a.nr_seq_topografia,
	a.dt_suspensao,
	a.nm_usuario_susp,
	a.ie_lado,
	a.nr_ocorrencia,
	a.ie_permite_exclusao,
	a.ie_agora,
	a.nr_seq_prot_proc,
	a.hr_horario_espec,
	a.ie_interv_espec_agora,
	a.nr_seq_diag,
	a.nr_seq_item,
	a.nr_seq_result,
	a.ie_acm,
	a.cd_responsavel,
	a.ie_faose,
	a.ie_profissional,
	a.ie_auxiliar,
	a.ie_encaminhar,
	a.ie_fazer,
	a.ie_orientar,
	a.ie_supervisionar,
	a.ie_confirmada,
	a.ds_justificativa,
	a.nr_seq_cpoe_interv,
	a.dt_fim,
	a.dt_inicio,
	a.dt_primeiro_horario,
	a.dt_horario_espec,
	a.nr_seq_pat_cp_interv,
	a.nr_seq_pat_cp_problem,
	a.nr_seq_rel_diag,
	a.ie_related_problem,
	a.ds_display_name,
	a.ie_classif_ote,
	a.ie_free_item,
	a.nr_seq_prescr,
	a.nr_seq_atend_disp,
	a.nr_seq_cur_ferida
from	pe_prescr_proc a
where	a.nr_seq_prescr = nr_seq_prescr_p
and	((a.nr_seq_pat_cp_problem IS NOT NULL AND a.nr_seq_pat_cp_problem::text <> '') or (ie_processo_plano_w = 'E'));
end;

procedure gerar_pat_interv_plan(
	nr_seq_pat_care_plan_p	number,
	nr_seq_cp_problem_old_p	number,
	nr_seq_pat_cp_problem_p	number,
	nr_seq_prescr_diag_old_p	number,
	nr_seq_prescr_diag_p	number) is

nr_seq_pat_cp_interv_plan_w	patient_cp_intervention.nr_sequencia%type;
nr_seq_pat_cp_int_plan_new_w	patient_cp_intervention.nr_sequencia%type;

C_interv_plan CURSOR FOR
	SELECT	a.nr_sequencia,
		a.dt_atualizacao,
		a.nm_usuario,
		a.dt_atualizacao_nrec,
		a.nm_usuario_nrec,
		a.nr_seq_pat_care_plan,
		a.nr_seq_interv_plan,
		a.dt_start,
		a.dt_end,
		a.dt_release,
		a.si_selected,
		a.nr_seq_pat_cp_problem,
		a.nr_seq_prescr_diag,
		a.nr_seq_int_pla_diag
	from	patient_cp_interv_plan a
	where	((a.nr_seq_pat_cp_problem = nr_seq_cp_problem_old_p)
	or (a.nr_seq_prescr_diag = nr_seq_prescr_diag_old_p));

C_cp_intervention CURSOR FOR
	SELECT	a.nr_sequencia,
		a.dt_atualizacao,
		a.nm_usuario,
		a.dt_atualizacao_nrec,
		a.nm_usuario_nrec,
		a.nr_seq_cp_intervention,
		a.nr_seq_pat_care_plan,
		a.dt_start,
		a.dt_end,
		a.dt_release,
		a.si_selected,
		a.nr_seq_pat_cp_interv_plan,
		a.ds_alternative_name,
		a.nr_seq_prescr_diag
	from	patient_cp_intervention a
	where	a.nr_seq_pat_cp_interv_plan = nr_seq_pat_cp_interv_plan_w;

begin
if ((nr_seq_pat_cp_problem_p IS NOT NULL AND nr_seq_pat_cp_problem_p::text <> '') or
	(nr_seq_prescr_diag_p IS NOT NULL AND nr_seq_prescr_diag_p::text <> '')) then
	begin
	for r_C_interv_plan in C_interv_plan
		loop
		nr_seq_pat_cp_interv_plan_w := r_C_interv_plan.nr_sequencia;

		select	nextval('patient_cp_interv_plan_seq')
		into STRICT	nr_seq_pat_cp_int_plan_new_w
		;

		insert into patient_cp_interv_plan(
			nr_sequencia,
			dt_atualizacao,
			nm_usuario,
			dt_atualizacao_nrec,
			nm_usuario_nrec,
			nr_seq_pat_care_plan,
			nr_seq_interv_plan,
			dt_start,
			dt_end,
			dt_release,
			si_selected,
			nr_seq_pat_cp_problem,
			nr_seq_prescr_diag,
			nr_seq_int_pla_diag)
		values (
			nr_seq_pat_cp_int_plan_new_w,
			clock_timestamp(),
			wheb_usuario_pck.get_nm_usuario,
			r_C_interv_plan.dt_atualizacao_nrec,
			r_C_interv_plan.nm_usuario_nrec,
			nr_seq_pat_care_plan_p,
			r_C_interv_plan.nr_seq_interv_plan,
			r_C_interv_plan.dt_start,
			r_C_interv_plan.dt_end,
			r_C_interv_plan.dt_release,
			r_C_interv_plan.si_selected,
			nr_seq_pat_cp_problem_p,
			nr_seq_prescr_diag_p,
			r_C_interv_plan.nr_seq_int_pla_diag);

		for r_C_cp_intervention in C_cp_intervention
			loop
			insert into patient_cp_intervention(
				nr_sequencia,
				dt_atualizacao,
				nm_usuario,
				dt_atualizacao_nrec,
				nm_usuario_nrec,
				nr_seq_cp_intervention,
				nr_seq_pat_care_plan,
				dt_start,
				dt_end,
				dt_release,
				si_selected,
				nr_seq_pat_cp_interv_plan,
				ds_alternative_name,
				nr_seq_prescr_diag)
			values (
				nextval('patient_cp_intervention_seq'),
				clock_timestamp(),
				wheb_usuario_pck.get_nm_usuario,
				r_C_cp_intervention.dt_atualizacao_nrec,
				r_C_cp_intervention.nm_usuario_nrec,
				r_C_cp_intervention.nr_seq_cp_intervention,
				nr_seq_pat_care_plan_p,
				r_C_cp_intervention.dt_start,
				r_C_cp_intervention.dt_end,
				r_C_cp_intervention.dt_release,
				r_C_cp_intervention.si_selected,
				nr_seq_pat_cp_int_plan_new_w,
				r_C_cp_intervention.ds_alternative_name,
				nr_seq_prescr_diag_p);
			end loop;
		end loop;
	end;
end if;
end;

procedure copiar_problema(
	nr_seq_prescr_p	number) is
begin
insert into pe_prescr_problem(
	nr_sequencia,
	dt_atualizacao,
	nm_usuario,
	dt_atualizacao_nrec,
	nm_usuario_nrec,
	nr_seq_prescr,
	nr_seq_pat_cp_problem,
	nr_prioridade,
	ie_reocorrencia)
SELECT	nextval('pe_prescr_problem_seq'),
	clock_timestamp(),
	wheb_usuario_pck.get_nm_usuario,
	a.dt_atualizacao_nrec,
	a.nm_usuario_nrec,
	nr_seq_prescricao_w,
	a.nr_seq_pat_cp_problem,
	a.nr_prioridade,
	a.ie_reocorrencia
from	pe_prescr_problem a
where	a.nr_seq_prescr = nr_seq_prescr_p;
end;

procedure copiar_prescr_diag(
	nr_seq_prescr_p	number) is

nr_seq_diag_new	pe_prescr_diag.nr_sequencia%type;

C_prescr_diag CURSOR FOR
	SELECT	row_number() OVER () AS ind,
		a.nr_sequencia,
		a.dt_atualizacao,
		a.nm_usuario,
		a.nr_seq_diag,
		a.nr_seq_prescr,
		a.dt_atualizacao_nrec,
		a.nm_usuario_nrec,
		a.nr_seq_evolucao_diag,
		a.qt_pontuacao,
		a.pr_likert,
		a.qt_ponto_atual,
		a.qt_ponto_total,
		a.dt_confirmacao_noc,
		a.ie_origem,
		a.ds_observacao,
		a.ds_observacao_noc,
		a.qt_horas_reaval_noc,
		a.ds_motivo,
		a.dt_cancelamento,
		a.dt_start,
		a.dt_end,
		a.ie_recorrencia,
		a.nr_seq_ordenacao,
		a.nr_prioridade,
		a.ie_diag_colab,
		a.ie_free_item
	from	pe_prescr_diag a
	where	nr_seq_prescr = nr_seq_prescr_p
	and	coalesce(a.dt_end::text, '') = '';

begin
for r_C_prescr_diag in C_prescr_diag
	loop
	select	nextval('pe_prescr_diag_seq')
	into STRICT	nr_seq_diag_new
	;

	seq_diag_row_w[r_C_prescr_diag.ind].nr_seq_old := r_C_prescr_diag.nr_sequencia;
	seq_diag_row_w[r_C_prescr_diag.ind].nr_seq_new := nr_seq_diag_new;

	insert into pe_prescr_diag(
		nr_sequencia,
		dt_atualizacao,
		nm_usuario,
		nr_seq_diag,
		nr_seq_prescr,
		dt_atualizacao_nrec,
		nm_usuario_nrec,
		nr_seq_evolucao_diag,
		qt_pontuacao,
		pr_likert,
		qt_ponto_atual,
		qt_ponto_total,
		dt_confirmacao_noc,
		ie_origem,
		ds_observacao,
		ds_observacao_noc,
		qt_horas_reaval_noc,
		ds_motivo,
		dt_cancelamento,
		dt_start,
		dt_end,
		ie_recorrencia,
		nr_seq_ordenacao,
		nr_prioridade,
		ie_diag_colab,
		ie_free_item)
	values (
		nr_seq_diag_new,
		clock_timestamp(),
		wheb_usuario_pck.get_nm_usuario,
		r_C_prescr_diag.nr_seq_diag,
		nr_seq_prescricao_w,
		r_C_prescr_diag.dt_atualizacao_nrec,
		r_C_prescr_diag.nm_usuario_nrec,
		r_C_prescr_diag.nr_seq_evolucao_diag,
		r_C_prescr_diag.qt_pontuacao,
		r_C_prescr_diag.pr_likert,
		r_C_prescr_diag.qt_ponto_atual,
		r_C_prescr_diag.qt_ponto_total,
		r_C_prescr_diag.dt_confirmacao_noc,
		r_C_prescr_diag.ie_origem,
		r_C_prescr_diag.ds_observacao,
		r_C_prescr_diag.ds_observacao_noc,
		r_C_prescr_diag.qt_horas_reaval_noc,
		r_C_prescr_diag.ds_motivo,
		r_C_prescr_diag.dt_cancelamento,
		r_C_prescr_diag.dt_start,
		r_C_prescr_diag.dt_end,
		r_C_prescr_diag.ie_recorrencia,
		r_C_prescr_diag.nr_seq_ordenacao,
		r_C_prescr_diag.nr_prioridade,
		r_C_prescr_diag.ie_diag_colab,
		r_C_prescr_diag.ie_free_item);

	gerar_pat_interv_plan(null, null, null, seq_diag_row_w[r_C_prescr_diag.ind].nr_seq_old, nr_seq_diag_new);
	end loop;
end;

procedure copiar_meta_cuidado(
	nr_seq_prescr_p	number) is

nr_seq_pat_care_plan_w	patient_care_plan.nr_sequencia%type;
nr_seq_pat_care_plan_new_w	patient_care_plan.nr_sequencia%type;
nr_seq_problem_plan_w	patient_cp_problem.nr_sequencia%type;
nr_seq_problem_plan_new_w	patient_cp_problem.nr_sequencia%type;
nr_seq_goal_plan_w		patient_cp_goal.nr_sequencia%type;
nr_seq_goal_plan_new_w	patient_cp_goal.nr_sequencia%type;
nr_seq_indicator_w		patient_cp_indicator.nr_sequencia%type;
nr_seq_indicator_new_w	patient_cp_indicator.nr_sequencia%type;
nr_seq_indic_plan_new_w	patient_cp_indic_plan.nr_sequencia%type;

C_care_plan CURSOR FOR
	SELECT	row_number() OVER () AS ind,
		a.nr_sequencia,
		a.dt_atualizacao,
		a.nm_usuario,
		a.dt_atualizacao_nrec,
		a.nm_usuario_nrec,
		a.nr_seq_care_plan,
		a.nr_atendimento,
		a.dt_start,
		a.dt_end,
		a.dt_release,
		a.cd_pessoa_fisica,
		a.nr_seq_prescr,
		a.si_selected,
		a.ie_situacao
	from	patient_care_plan a
	where	a.nr_seq_prescr = nr_seq_prescr_p
	and	coalesce(a.dt_end::text, '') = '';

C_cp_problem CURSOR FOR
	SELECT	a.nr_sequencia,
		a.dt_atualizacao,
		a.nm_usuario,
		a.dt_atualizacao_nrec,
		a.nm_usuario_nrec,
		a.nr_seq_pat_care_plan,
		a.nr_seq_cp_problem,
		a.dt_start,
		a.dt_end,
		a.dt_release,
		a.si_selected
	from	patient_cp_problem a
	where	a.nr_seq_pat_care_plan = nr_seq_pat_care_plan_w
	and	coalesce(a.dt_end::text, '') = '';

C_cp_goal CURSOR FOR
	SELECT	a.nr_sequencia,
		a.dt_atualizacao,
		a.nm_usuario,
		a.dt_atualizacao_nrec,
		a.nm_usuario_nrec,
		a.nr_seq_pat_care_plan,
		a.nr_seq_cp_goal,
		a.dt_start,
		a.dt_end,
		a.dt_release,
		a.si_selected,
		a.nr_seq_pat_cp_problem,
		a.nr_seq_prescr_diag,
		a.ie_free_item
	from	patient_cp_goal a
	where	a.nr_seq_pat_cp_problem = nr_seq_problem_plan_w
	and	coalesce(a.dt_end::text, '') = '';

C_cp_indicator CURSOR FOR
	SELECT	a.nr_sequencia,
		a.dt_atualizacao,
		a.nm_usuario,
		a.dt_atualizacao_nrec,
		a.nm_usuario_nrec,
		a.nr_seq_cp_indicator,
		a.nr_seq_pat_care_plan,
		a.dt_start,
		a.dt_end,
		a.dt_release,
		a.si_selected,
		a.nr_seq_pat_cp_goal,
		a.ie_free_item
	from	patient_cp_indicator a
	where	a.nr_seq_pat_cp_goal = nr_seq_goal_plan_w
	and	coalesce(a.dt_end::text, '') = '';

C_cp_indic_plan CURSOR FOR
	SELECT	row_number() OVER () AS ind,
		a.nr_sequencia,
		a.dt_atualizacao,
		a.nm_usuario,
		a.dt_atualizacao_nrec,
		a.nm_usuario_nrec,
		a.nr_seq_pat_cp_ind,
		a.dt_evaluation,
		a.nr_seq_measure,
		a.nr_score,
		a.ie_evaluation,
		a.nm_usuario_lib,
		a.ds_note,
		a.nr_seq_assinatura,
		a.nr_seq_cp_indicator,
		a.nr_seq_prescr,
		a.nr_seq_measure_goal,
		a.dt_evaluation_goal,
		a.dt_liberacao
	from	patient_cp_indic_plan a
	where	a.nr_seq_prescr = nr_seq_prescr_p
	and	a.nr_seq_pat_cp_ind = nr_seq_indicator_w;

C_cp_indic_measure CURSOR FOR
	SELECT	a.nr_sequencia,
		a.dt_atualizacao,
		a.nm_usuario,
		a.dt_atualizacao_nrec,
		a.nm_usuario_nrec,
		a.nr_seq_pat_cp_ind,
		a.dt_evaluation,
		a.nr_seq_measure,
		a.nr_score,
		a.ie_evolution,
		a.ds_note,
		a.nr_seq_assinatura,
		a.dt_liberacao,
		a.nm_usuario_lib,
		a.nr_seq_cp_indicator,
		a.nr_seq_prescr,
		a.ie_measure,
		a.nr_seq_plan_indic
	from	patient_cp_indic_measure a
	where	a.nr_seq_prescr = nr_seq_prescr_p
	and	a.nr_seq_pat_cp_ind = nr_seq_indicator_w
	order by	dt_evaluation;

C_prescr_indicator CURSOR FOR
	SELECT	a.nr_sequencia,
		a.dt_atualizacao,
		a.nm_usuario,
		a.dt_atualizacao_nrec,
		a.nm_usuario_nrec,
		a.nr_seq_prescr,
		a.nr_seq_pat_cp_indicator
	from	pe_prescr_indicator a
	where	a.nr_seq_pat_cp_indicator = nr_seq_indicator_w;

begin
for r_C_care_plan in C_care_plan
	loop
	nr_seq_pat_care_plan_w := r_C_care_plan.nr_sequencia;

	select	nextval('patient_care_plan_seq')
	into STRICT	nr_seq_pat_care_plan_new_w
	;

	seq_care_plan_row_w[r_C_care_plan.ind].nr_seq_old := r_C_care_plan.nr_sequencia;
	seq_care_plan_row_w[r_C_care_plan.ind].nr_seq_new := nr_seq_pat_care_plan_new_w;

	insert into patient_care_plan(
		nr_sequencia,
		dt_atualizacao,
		nm_usuario,
		dt_atualizacao_nrec,
		nm_usuario_nrec,
		nr_seq_care_plan,
		nr_atendimento,
		dt_start,
		dt_end,
		dt_release,
		cd_pessoa_fisica,
		nr_seq_prescr,
		si_selected,
		ie_situacao)
	values (
		nr_seq_pat_care_plan_new_w,
		clock_timestamp(),
		wheb_usuario_pck.get_nm_usuario,
		r_C_care_plan.dt_atualizacao_nrec,
		r_C_care_plan.nm_usuario_nrec,
		r_C_care_plan.nr_seq_care_plan,
		r_C_care_plan.nr_atendimento,
		r_C_care_plan.dt_start,
		r_C_care_plan.dt_end,
		r_C_care_plan.dt_release,
		r_C_care_plan.cd_pessoa_fisica,
		nr_seq_prescricao_w,
		r_C_care_plan.si_selected,
		r_C_care_plan.ie_situacao);

	for r_C_cp_problem in C_cp_problem
		loop
		nr_seq_problem_plan_w := r_C_cp_problem.nr_sequencia;

		select	nextval('patient_cp_problem_seq')
		into STRICT	nr_seq_problem_plan_new_w
		;

		insert into patient_cp_problem(
			nr_sequencia,
			dt_atualizacao,
			nm_usuario,
			dt_atualizacao_nrec,
			nm_usuario_nrec,
			nr_seq_pat_care_plan,
			nr_seq_cp_problem,
			dt_start,
			dt_end,
			dt_release,
			si_selected)
		values (
			nr_seq_problem_plan_new_w,
			clock_timestamp(),
			wheb_usuario_pck.get_nm_usuario,
			r_C_cp_problem.dt_atualizacao_nrec,
			r_C_cp_problem.nm_usuario_nrec,
			nr_seq_pat_care_plan_new_w,
			r_C_cp_problem.nr_seq_cp_problem,
			r_C_cp_problem.dt_start,
			r_C_cp_problem.dt_end,
			r_C_cp_problem.dt_release,
			r_C_cp_problem.si_selected);

		gerar_pat_interv_plan(nr_seq_pat_care_plan_new_w, nr_seq_problem_plan_w, nr_seq_problem_plan_new_w, null, null);

		for r_C_cp_goal in C_cp_goal
			loop
			nr_seq_goal_plan_w := r_C_cp_goal.nr_sequencia;

			select	nextval('patient_cp_goal_seq')
			into STRICT	nr_seq_goal_plan_new_w
			;

			nr_seq_diag_new_w := null;

			if (seq_diag_row_w.first IS NOT NULL AND seq_diag_row_w.first::text <> '') then
				for i in seq_diag_row_w.first .. seq_diag_row_w.last
					loop
					if (seq_diag_row_w[i].nr_seq_old = r_C_cp_goal.nr_seq_prescr_diag) then
						nr_seq_diag_new_w := seq_diag_row_w[i].nr_seq_new;
					end if;
					end loop;
			end if;

			insert into patient_cp_goal(
				nr_sequencia,
				dt_atualizacao,
				nm_usuario,
				dt_atualizacao_nrec,
				nm_usuario_nrec,
				nr_seq_pat_care_plan,
				nr_seq_cp_goal,
				dt_start,
				dt_end,
				dt_release,
				si_selected,
				nr_seq_pat_cp_problem,
				nr_seq_prescr_diag,
				ie_free_item)
			values (
				nr_seq_goal_plan_new_w,
				clock_timestamp(),
				wheb_usuario_pck.get_nm_usuario,
				r_C_cp_goal.dt_atualizacao_nrec,
				r_C_cp_goal.nm_usuario_nrec,
				nr_seq_pat_care_plan_new_w,
				r_C_cp_goal.nr_seq_cp_goal,
				r_C_cp_goal.dt_start,
				r_C_cp_goal.dt_end,
				r_C_cp_goal.dt_release,
				r_C_cp_goal.si_selected,
				nr_seq_problem_plan_new_w,
				nr_seq_diag_new_w,
				r_C_cp_goal.ie_free_item);

			for r_C_cp_indicator in C_cp_indicator
				loop
				nr_seq_indicator_w := r_C_cp_indicator.nr_sequencia;

				select	nextval('patient_cp_indicator_seq')
				into STRICT	nr_seq_indicator_new_w
				;

				insert into patient_cp_indicator(
					nr_sequencia,
					dt_atualizacao,
					nm_usuario,
					dt_atualizacao_nrec,
					nm_usuario_nrec,
					nr_seq_cp_indicator,
					nr_seq_pat_care_plan,
					dt_start,
					dt_end,
					dt_release,
					si_selected,
					nr_seq_pat_cp_goal,
					ie_free_item)
				values (
					nr_seq_indicator_new_w,
					clock_timestamp(),
					wheb_usuario_pck.get_nm_usuario,
					r_C_cp_indicator.dt_atualizacao_nrec,
					r_C_cp_indicator.nm_usuario_nrec,
					r_C_cp_indicator.nr_seq_cp_indicator,
					nr_seq_pat_care_plan_new_w,
					r_C_cp_indicator.dt_start,
					r_C_cp_indicator.dt_end,
					r_C_cp_indicator.dt_release,
					r_C_cp_indicator.si_selected,
					nr_seq_goal_plan_new_w,
					r_C_cp_indicator.ie_free_item);

				for r_C_cp_indic_plan in C_cp_indic_plan
					loop
					select	nextval('patient_cp_indic_plan_seq')
					into STRICT	nr_seq_indic_plan_new_w
					;

					seq_indic_plan_row_w[r_C_cp_indic_plan.ind].nr_seq_old := r_C_cp_indic_plan.nr_sequencia;
					seq_indic_plan_row_w[r_C_cp_indic_plan.ind].nr_seq_new := nr_seq_indic_plan_new_w;

					insert into patient_cp_indic_plan(
						nr_sequencia,
						dt_atualizacao,
						nm_usuario,
						dt_atualizacao_nrec,
						nm_usuario_nrec,
						nr_seq_pat_cp_ind,
						dt_evaluation,
						nr_seq_measure,
						nr_score,
						ie_evaluation,
						nm_usuario_lib,
						ds_note,
						nr_seq_assinatura,
						nr_seq_cp_indicator,
						nr_seq_prescr,
						nr_seq_measure_goal,
						dt_evaluation_goal,
						dt_liberacao)
					values (
						nr_seq_indic_plan_new_w,
						clock_timestamp(),
						wheb_usuario_pck.get_nm_usuario,
						r_C_cp_indic_plan.dt_atualizacao_nrec,
						r_C_cp_indic_plan.nm_usuario_nrec,
						nr_seq_indicator_new_w,
						r_C_cp_indic_plan.dt_evaluation,
						r_C_cp_indic_plan.nr_seq_measure,
						r_C_cp_indic_plan.nr_score,
						r_C_cp_indic_plan.ie_evaluation,
						r_C_cp_indic_plan.nm_usuario_lib,
						r_C_cp_indic_plan.ds_note,
						r_C_cp_indic_plan.nr_seq_assinatura,
						r_C_cp_indic_plan.nr_seq_cp_indicator,
						nr_seq_prescricao_w,
						r_C_cp_indic_plan.nr_seq_measure_goal,
						r_C_cp_indic_plan.dt_evaluation_goal,
						r_C_cp_indic_plan.dt_liberacao);
					end loop;

				for r_C_cp_indic_measure in C_cp_indic_measure
					loop
					nr_seq_indic_new_w := null;

					if (seq_indic_plan_row_w.first IS NOT NULL AND seq_indic_plan_row_w.first::text <> '') then
						for i in seq_indic_plan_row_w.first .. seq_indic_plan_row_w.last
							loop
							if (seq_indic_plan_row_w[i].nr_seq_old = r_C_cp_indic_measure.nr_seq_plan_indic) then
								nr_seq_indic_new_w := seq_indic_plan_row_w[i].nr_seq_new;
							end if;
							end loop;
					end if;

					insert into patient_cp_indic_measure(
						nr_sequencia,
						dt_atualizacao,
						nm_usuario,
						dt_atualizacao_nrec,
						nm_usuario_nrec,
						nr_seq_pat_cp_ind,
						dt_evaluation,
						nr_seq_measure,
						nr_score,
						ie_evolution,
						ds_note,
						nr_seq_assinatura,
						dt_liberacao,
						nm_usuario_lib,
						nr_seq_cp_indicator,
						nr_seq_prescr,
						ie_measure,
						nr_seq_plan_indic)
					values (
						nextval('patient_cp_indic_measure_seq'),
						clock_timestamp(),
						wheb_usuario_pck.get_nm_usuario,
						r_C_cp_indic_measure.dt_atualizacao_nrec,
						r_C_cp_indic_measure.nm_usuario_nrec,
						nr_seq_indicator_new_w,
						r_C_cp_indic_measure.dt_evaluation,
						r_C_cp_indic_measure.nr_seq_measure,
						r_C_cp_indic_measure.nr_score,
						r_C_cp_indic_measure.ie_evolution,
						r_C_cp_indic_measure.ds_note,
						r_C_cp_indic_measure.nr_seq_assinatura,
						r_C_cp_indic_measure.dt_liberacao,
						r_C_cp_indic_measure.nm_usuario_lib,
						r_C_cp_indic_measure.nr_seq_cp_indicator,
						nr_seq_prescricao_w,
						r_C_cp_indic_measure.ie_measure,
						nr_seq_indic_new_w);
					end loop;

				for r_C_prescr_indicator in C_prescr_indicator
					loop
					insert into pe_prescr_indicator(
						nr_sequencia,
						dt_atualizacao,
						nm_usuario,
						dt_atualizacao_nrec,
						nm_usuario_nrec,
						nr_seq_prescr,
						nr_seq_pat_cp_indicator)
					values (
						nextval('pe_prescr_indicator_seq'),
						clock_timestamp(),
						wheb_usuario_pck.get_nm_usuario,
						r_C_prescr_indicator.dt_atualizacao_nrec,
						r_C_prescr_indicator.nm_usuario_nrec,
						nr_seq_prescricao_w,
						nr_seq_indicator_new_w);
					end loop;
				end loop;
			end loop;
		end loop;
	end loop;
end;

procedure copiar_meta_educacional(
	nr_seq_prescr_p	number) is

nr_seq_care_plan_w		patient_care_plan.nr_sequencia%type;
nr_seq_cp_goal_w		patient_cp_goal.nr_sequencia%type;
nr_seq_cp_goal_new_w	patient_cp_goal.nr_sequencia%type;
nr_seq_cp_indicator_new_w	patient_cp_indicator.nr_sequencia%type;
nr_seq_cp_meas_eg_w		pat_cp_ind_measure_eg.nr_sequencia%type;
nr_seq_cp_meas_eg_new_w	pat_cp_ind_measure_eg.nr_sequencia%type;

qt_reg_indicator_w		number(10);

C_pat_cp_goal CURSOR FOR
	SELECT	a.nr_sequencia,
		a.dt_atualizacao,
		a.nm_usuario,
		a.dt_atualizacao_nrec,
		a.nm_usuario_nrec,
		a.nr_seq_pat_care_plan,
		a.nr_seq_cp_goal,
		a.dt_start,
		a.dt_end,
		a.dt_release,
		a.si_selected,
		a.nr_seq_pat_cp_problem,
		a.nr_seq_prescr_diag,
		a.ie_free_item
	from	patient_cp_goal a
	where	a.nr_seq_pat_care_plan = nr_seq_care_plan_w
	and	coalesce(a.nr_seq_pat_cp_problem::text, '') = ''
	and	coalesce(a.dt_end::text, '') = '';

C_pat_cp_measure CURSOR FOR
	SELECT	a.nr_sequencia,
		a.dt_atualizacao,
		a.nm_usuario,
		a.dt_atualizacao_nrec,
		a.nm_usuario_nrec,
		a.nr_seq_pat_cp_goal,
		a.dt_evaluation,
		a.dt_liberacao,
		a.nm_usuario_lib,
		a.nr_seq_assinatura
	from	pat_cp_ind_measure_eg a
	where	nr_seq_pat_cp_goal = nr_seq_cp_goal_w;

C_pat_measure_ind CURSOR FOR
	SELECT	c.dt_atualizacao dt_atualizacao_i,
		c.nm_usuario nm_usuario_i,
		c.dt_atualizacao_nrec dt_atualizacao_nrec_i,
		c.nm_usuario_nrec nm_usuario_nrec_i,
		c.nr_seq_cp_indicator,
		c.nr_seq_pat_care_plan,
		c.dt_start,
		c.dt_end,
		c.dt_release,
		c.si_selected,
		c.nr_seq_pat_cp_goal,
		c.ie_free_item,
		a.dt_atualizacao dt_atualizacao_m,
		a.nm_usuario nm_usuario_m,
		a.dt_atualizacao_nrec dt_atualizacao_nrec_m,
		a.nm_usuario_nrec nm_usuario_nrec_m,
		a.nr_seq_ind_measure_eg,
		a.nr_seq_pat_cp_indic,
		a.nr_seq_measure,
		a.ds_note,
		a.ie_component
	from	pat_cp_ind_measure_eg_item a,
		patient_cp_indicator c
	where	c.nr_sequencia = a.nr_seq_pat_cp_indic
	and	a.nr_seq_ind_measure_eg = nr_seq_cp_meas_eg_w;

begin
if (seq_care_plan_row_w.first IS NOT NULL AND seq_care_plan_row_w.first::text <> '') then
	for i in seq_care_plan_row_w.first .. seq_care_plan_row_w.last
		loop
		nr_seq_care_plan_w := seq_care_plan_row_w[i].nr_seq_old;

		for r_C_pat_cp_goal in C_pat_cp_goal
			loop
			nr_seq_diag_new_w := null;

			if (seq_diag_row_w.first IS NOT NULL AND seq_diag_row_w.first::text <> '') then
				for j in seq_diag_row_w.first .. seq_diag_row_w.last
					loop
					if (seq_diag_row_w[j].nr_seq_old = r_C_pat_cp_goal.nr_seq_prescr_diag) then
						nr_seq_diag_new_w := seq_diag_row_w[j].nr_seq_new;
					end if;
					end loop;
			end if;

			nr_seq_cp_goal_w := r_C_pat_cp_goal.nr_sequencia;

			select	nextval('patient_cp_goal_seq')
			into STRICT	nr_seq_cp_goal_new_w
			;

			insert into patient_cp_goal(
				nr_sequencia,
				dt_atualizacao,
				nm_usuario,
				dt_atualizacao_nrec,
				nm_usuario_nrec,
				nr_seq_pat_care_plan,
				nr_seq_cp_goal,
				dt_start,
				dt_end,
				dt_release,
				si_selected,
				nr_seq_pat_cp_problem,
				nr_seq_prescr_diag,
				ie_free_item)
			values (
				nr_seq_cp_goal_new_w,
				clock_timestamp(),
				wheb_usuario_pck.get_nm_usuario,
				r_C_pat_cp_goal.dt_atualizacao_nrec,
				r_C_pat_cp_goal.nm_usuario_nrec,
				seq_care_plan_row_w[i].nr_seq_new,
				r_C_pat_cp_goal.nr_seq_cp_goal,
				r_C_pat_cp_goal.dt_start,
				r_C_pat_cp_goal.dt_end,
				r_C_pat_cp_goal.dt_release,
				r_C_pat_cp_goal.si_selected,
				r_C_pat_cp_goal.nr_seq_pat_cp_problem,
				nr_seq_diag_new_w,
				r_C_pat_cp_goal.ie_free_item);

			for r_C_pat_cp_measure in C_pat_cp_measure
				loop
				nr_seq_cp_meas_eg_w := r_C_pat_cp_measure.nr_sequencia;

				select	nextval('pat_cp_ind_measure_eg_seq')
				into STRICT	nr_seq_cp_meas_eg_new_w
				;

				insert into pat_cp_ind_measure_eg(
					nr_sequencia,
					dt_atualizacao,
					nm_usuario,
					dt_atualizacao_nrec,
					nm_usuario_nrec,
					nr_seq_pat_cp_goal,
					dt_evaluation,
					dt_liberacao,
					nm_usuario_lib,
					nr_seq_assinatura)
				values (
					nr_seq_cp_meas_eg_new_w,
					clock_timestamp(),
					wheb_usuario_pck.get_nm_usuario,
					r_C_pat_cp_measure.dt_atualizacao_nrec,
					r_C_pat_cp_measure.nm_usuario_nrec,
					nr_seq_cp_goal_new_w,
					r_C_pat_cp_measure.dt_evaluation,
					r_C_pat_cp_measure.dt_liberacao,
					r_C_pat_cp_measure.nm_usuario_lib,
					r_C_pat_cp_measure.nr_seq_assinatura);

				for r_C_pat_measure_ind in C_pat_measure_ind
					loop
					select	count(*)
					into STRICT	qt_reg_indicator_w
					from	patient_cp_indicator a
					where	a.nr_seq_pat_cp_goal = nr_seq_cp_goal_new_w
					and	a.nr_seq_cp_indicator = r_C_pat_measure_ind.nr_seq_cp_indicator;

					if (qt_reg_indicator_w = 0) then
						begin
						select	nextval('patient_cp_indicator_seq')
						into STRICT	nr_seq_cp_indicator_new_w
						;

						insert into patient_cp_indicator(
							nr_sequencia,
							dt_atualizacao,
							nm_usuario,
							dt_atualizacao_nrec,
							nm_usuario_nrec,
							nr_seq_cp_indicator,
							nr_seq_pat_care_plan,
							dt_start,
							dt_end,
							dt_release,
							si_selected,
							nr_seq_pat_cp_goal,
							ie_free_item)
						values (
							nr_seq_cp_indicator_new_w,
							clock_timestamp(),
							wheb_usuario_pck.get_nm_usuario,
							r_C_pat_measure_ind.dt_atualizacao_nrec_i,
							r_C_pat_measure_ind.nm_usuario_nrec_i,
							r_C_pat_measure_ind.nr_seq_cp_indicator,
							seq_care_plan_row_w[i].nr_seq_new,
							r_C_pat_measure_ind.dt_start,
							r_C_pat_measure_ind.dt_end,
							r_C_pat_measure_ind.dt_release,
							r_C_pat_measure_ind.si_selected,
							nr_seq_cp_goal_new_w,
							r_C_pat_measure_ind.ie_free_item);
						end;
					end if;

					insert into pat_cp_ind_measure_eg_item(
						nr_sequencia,
						dt_atualizacao,
						nm_usuario,
						dt_atualizacao_nrec,
						nm_usuario_nrec,
						nr_seq_ind_measure_eg,
						nr_seq_pat_cp_indic,
						nr_seq_measure,
						ds_note,
						ie_component)
					values (
						nextval('pat_cp_ind_measure_eg_item_seq'),
						clock_timestamp(),
						wheb_usuario_pck.get_nm_usuario,
						r_C_pat_measure_ind.dt_atualizacao_nrec_m,
						r_C_pat_measure_ind.nm_usuario_nrec_m,
						nr_seq_cp_meas_eg_new_w,
						nr_seq_cp_indicator_new_w,
						r_C_pat_measure_ind.nr_seq_measure,
						r_C_pat_measure_ind.ds_note,
						r_C_pat_measure_ind.ie_component);
					end loop;
				end loop;
			end loop;
		end loop;
end if;
end;

procedure copiar_prescr_plano(
	nr_seq_prescr_p	number) is

C_prescr_plano CURSOR FOR
	SELECT	a.nr_sequencia,
		a.dt_atualizacao,
		a.nm_usuario,
		a.dt_atualizacao_nrec,
		a.nm_usuario_nrec,
		a.nr_seq_pat_care_plan,
		a.nr_seq_prescr
	from	pe_prescr_care_plan a
	where	a.nr_seq_prescr = nr_seq_prescr_p;

begin
for r_C_prescr_plano in C_prescr_plano
	loop
	nr_seq_plan_new_w := null;

	if (seq_care_plan_row_w.first IS NOT NULL AND seq_care_plan_row_w.first::text <> '') then

	for i in seq_care_plan_row_w.first .. seq_care_plan_row_w.last
		loop
		if (seq_care_plan_row_w[i].nr_seq_old = r_C_prescr_plano.nr_seq_pat_care_plan) then
			nr_seq_plan_new_w := seq_care_plan_row_w[i].nr_seq_new;
		end if;
		end loop;

	insert into pe_prescr_care_plan(
		nr_sequencia,
		dt_atualizacao,
		nm_usuario,
		dt_atualizacao_nrec,
		nm_usuario_nrec,
		nr_seq_pat_care_plan,
		nr_seq_prescr)
	values (
		nextval('pe_prescr_care_plan_seq'),
		clock_timestamp(),
		wheb_usuario_pck.get_nm_usuario,
		r_C_prescr_plano.dt_atualizacao_nrec,
		r_C_prescr_plano.nm_usuario_nrec,
		nr_seq_plan_new_w,
		nr_seq_prescricao_w);

	end if;
	end loop;
end;

procedure copiar_plano_anterior(
	nr_seq_prescr_p	number,
	nr_seq_novo_p	number) is

ds_observacao_w	pe_prescricao.ds_observacao%type;

begin
if (nr_seq_prescr_p IS NOT NULL AND nr_seq_prescr_p::text <> '' AND nr_seq_novo_p IS NOT NULL AND nr_seq_novo_p::text <> '') then
	begin
	select	wheb_mensagem_pck.get_texto(1184087,
			';SEQ_REG='||a.nr_sequencia||
			';USUARIO_INAT='||a.nm_usuario_inativacao||
			';DATA_INAT='||pkg_date_formaters.to_varchar(
				a.dt_inativacao,
				'timestamp',
				wheb_usuario_pck.get_cd_estabelecimento,
				wheb_usuario_pck.get_nm_usuario))
	into STRICT	ds_observacao_w
	from	pe_prescricao a
	where	a.nr_sequencia = nr_seq_prescricao_p;

	if ((trim(both ds_observacao_w) IS NOT NULL AND (trim(both ds_observacao_w))::text <> '')) then
		ds_observacao_w := ds_observacao_w || chr(13) || chr(10);
	end if;

	insert into pe_prescricao(
		nr_sequencia,
		dt_atualizacao,
		nm_usuario,
		dt_prescricao,
		cd_prescritor,
		nr_atendimento,
		cd_pessoa_fisica,
		dt_liberacao,
		dt_atualizacao_nrec,
		nm_usuario_nrec,
		dt_inicio_prescr,
		dt_validade_prescr,
		nr_prescricao,
		nr_seq_modelo,
		nr_cirurgia,
		nr_seq_saep,
		ie_situacao,
		dt_inativacao,
		nm_usuario_inativacao,
		ds_justificativa,
		cd_perfil_ativo,
		dt_suspensao,
		nm_usuario_susp,
		cd_setor_atendimento,
		nr_seq_assinatura,
		nr_sae_origem,
		ie_rn,
		qt_horas_validade,
		dt_primeiro_horario,
		ie_agora,
		ie_estender_validade,
		nr_seq_triagem,
		nr_recem_nato,
		ie_tipo,
		nr_seq_assinat_inativacao,
		nr_seq_pend_pac_acao,
		dt_rep_pt,
		dt_rep_pt2,
		nr_seq_reg_elemento,
		nr_seq_motivo_susp,
		ds_observacao,
		ds_utc,
		ie_horario_verao,
		ds_protocolo,
		ds_utc_atualizacao,
		ds_nivel_complexidade,
		ie_nivel_compl,
		ie_avaliador_aux,
		dt_liberacao_aux,
		cd_avaliador_aux,
		nm_usuario_aux,
		dt_liberacao_plano,
		nr_seq_disp_pac,
		ie_nivel_atencao,
		nr_seq_nais_insurance,
		nr_seq_prev_prescr,
		cd_evolucao,
		cd_especialidade_med,
		cd_departamento_med)
	SELECT	nr_seq_novo_p,
		a.dt_atualizacao,
		a.nm_usuario,
		a.dt_prescricao,
		a.cd_prescritor,
		a.nr_atendimento,
		a.cd_pessoa_fisica,
		a.dt_liberacao,
		clock_timestamp(),
		a.nm_usuario_nrec,
		a.dt_inicio_prescr,
		a.dt_validade_prescr,
		a.nr_prescricao,
		a.nr_seq_modelo,
		a.nr_cirurgia,
		a.nr_seq_saep,
		a.ie_situacao,
		a.dt_inativacao,
		a.nm_usuario_inativacao,
		a.ds_justificativa,
		a.cd_perfil_ativo,
		null,
		null,
		a.cd_setor_atendimento,
		a.nr_seq_assinatura,
		a.nr_sae_origem,
		a.ie_rn,
		a.qt_horas_validade,
		a.dt_primeiro_horario,
		a.ie_agora,
		a.ie_estender_validade,
		a.nr_seq_triagem,
		a.nr_recem_nato,
		a.ie_tipo,
		a.nr_seq_assinat_inativacao,
		a.nr_seq_pend_pac_acao,
		a.dt_rep_pt,
		a.dt_rep_pt2,
		a.nr_seq_reg_elemento,
		null,
		substr(ds_observacao_w||a.ds_observacao,1,255),
		a.ds_utc,
		a.ie_horario_verao,
		a.ds_protocolo,
		a.ds_utc_atualizacao,
		a.ds_nivel_complexidade,
		a.ie_nivel_compl,
		a.ie_avaliador_aux,
		a.dt_liberacao_aux,
		a.cd_avaliador_aux,
		a.nm_usuario_aux,
		a.dt_liberacao_plano,
		a.nr_seq_disp_pac,
		a.ie_nivel_atencao,
		a.nr_seq_nais_insurance,
		a.nr_seq_prev_prescr,
		a.cd_evolucao,
		a.cd_especialidade_med,
		a.cd_departamento_med
	from	pe_prescricao a
	where	a.nr_sequencia = nr_seq_prescr_p;
	
	update 	pe_prescricao a
	set		a.dt_inativacao = clock_timestamp(),
			a.ds_justificativa = obter_desc_expressao(1073046) || ' ' || nr_seq_novo_p
	where 	a.nr_sequencia = nr_seq_prescr_p;
	
	end;
end if;
end;

begin
if (nr_seq_prescricao_p IS NOT NULL AND nr_seq_prescricao_p::text <> '') then
	begin
	select	max(a.cd_pessoa_fisica)
	into STRICT	cd_paciente_w
	from	pe_prescricao a
	where	a.nr_sequencia = nr_seq_prescricao_p;

	ie_processo_plano_w := obter_param_usuario(281, 1614, obter_perfil_ativo, wheb_usuario_pck.get_nm_usuario, wheb_usuario_pck.get_cd_estabelecimento, ie_processo_plano_w);

	if (coalesce(ie_inativar_p,'N') = 'S') then
		begin
		select	max(a.nr_sequencia)
		into STRICT	nr_seq_prescr_w
		from	pe_prescricao a
		where	a.ie_tipo = 'CP'
		and		(a.dt_liberacao IS NOT NULL AND a.dt_liberacao::text <> '')
		and		coalesce(a.dt_inativacao::text, '') = ''
		and 	a.dt_validade_prescr > clock_timestamp()
		and		a.cd_pessoa_fisica = cd_paciente_w;

		select	nextval('pe_prescricao_seq')
		into STRICT	nr_seq_prescricao_w
		;
		
		if (nr_seq_prescr_w IS NOT NULL AND nr_seq_prescr_w::text <> '') then
			copiar_plano_anterior(nr_seq_prescr_w, nr_seq_prescricao_w);
		end if;

		end;
	else
		begin
		select	max(a.nr_sequencia)
		into STRICT	nr_seq_prescr_w
		from	pe_prescricao a
		where	a.ie_tipo = 'CP'
		and	coalesce(a.dt_suspensao::text, '') = ''
		and	(a.dt_liberacao IS NOT NULL AND a.dt_liberacao::text <> '')
		and	coalesce(a.dt_inativacao::text, '') = ''
		and	a.cd_pessoa_fisica = cd_paciente_w;

		nr_seq_prescricao_w := nr_seq_prescricao_p;

		update	pe_prescricao a
		set	a.nr_sae_origem = nr_seq_prescr_w
		where	a.nr_sequencia = nr_seq_prescricao_w;
		end;
	end if;

	if (nr_seq_prescricao_w IS NOT NULL AND nr_seq_prescricao_w::text <> '') then
		begin
		if (nr_seq_prescr_w IS NOT NULL AND nr_seq_prescr_w::text <> '') then
			begin
			copiar_intervencao(nr_seq_prescr_w);
			copiar_problema(nr_seq_prescr_w);
			copiar_prescr_diag(nr_seq_prescr_w);
			copiar_meta_cuidado(nr_seq_prescr_w);
			copiar_meta_educacional(nr_seq_prescr_w);
			copiar_prescr_plano(nr_seq_prescr_w);
			end;
		end if;
		end;
	end if;
	end;
end if;

commit;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE gerar_plano_cuidado_vigente ( nr_seq_prescricao_p bigint, ie_inativar_p text) FROM PUBLIC;

