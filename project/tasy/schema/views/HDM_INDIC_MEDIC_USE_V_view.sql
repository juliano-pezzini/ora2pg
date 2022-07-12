-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';

CREATE OR REPLACE VIEW hdm_indic_medic_use_v (nr_day_of_week, nr_day, si_holiday, si_weekend, dt_day_start, dt_day_end, ds_day_of_week, nr_year, nr_month, nr_semester, nr_quarter, dt_month_start, dt_month_end, nr_seq_patient_group, si_sex, ds_sex, nm_age_range, ds_participant, nr_seq_dm_program, nr_seq_program, nm_program, nm_program_module, nr_seq_campaign, nm_campaign, nr_seq_dm_group, nm_group, nm_group_class, nr_seq_turma, nr_seq_disease_risk, nm_disease_risk, nm_medication, si_registrated, ds_registrated, nr_seq_fact, ds_unique, nr_dif_person, nr_seq_day_start, nr_seq_day_end) AS SELECT	/* Dados dia */
	c.nr_day_of_week,
	c.nr_day,
	c.si_holiday,
	c.si_weekend,
	c.dt_complete_date dt_day_start,
	c2.dt_complete_date dt_day_end,
	c.ds_day_of_week,
	/* Dados mês */

	b.nr_year,
	b.nr_month,
	b.nr_semester,
	b.nr_quarter,
	b.dt_complete_date dt_month_start,
	b2.dt_complete_date dt_month_end,
	/* Dados grupo paciente */

	a.nr_seq_patient_group,
	d.si_sex,
	d.ds_sex,
	d.nm_age_range,
	d.ds_participant,
	/* Dados programa */

	e.nr_sequencia nr_seq_dm_program,
	e.nr_seq_program nr_seq_program,
	e.nm_program,
	e.nm_program_module nm_program_module,
	/* Dados campanha */

	g.nr_sequencia nr_seq_campaign,
	g.nm_campaign,
	/* Dados grupo atividade */

	i.nr_sequencia nr_seq_dm_group,
	i.nm_group,
	i.nm_class nm_group_class,
	i.nr_seq_turma,
	/* Patologia */

	n.nr_sequencia nr_seq_disease_risk,
	n.nm_disease_risk,
	/* Dados doença*/

	k.nm_medication,
	k.si_registrated,
	k.ds_registrated,
	/* Dados fato */

	a.nr_sequencia nr_seq_fact,
	OBTER_DESC_EXPRESSAO(303885) ds_unique,
	a.nr_dif_person,
	a.nr_seq_day_start,
	a.nr_seq_day_end
FROM hdm_indic_ft_medication_rd o, hdm_indic_dm_risk_disease n, hdm_indic_dm_medication k, hdm_indic_ft_medication_ag j, hdm_indic_dm_activ_group i, hdm_indic_ft_medication_cp h, hdm_indic_dm_campaign g, hdm_indic_ft_medication_pr f, hdm_indic_dm_program e, hdm_indic_dm_patient_group d, hdm_indic_dm_day c, hdm_indic_dm_month b, hdm_indic_ft_medication a
LEFT OUTER JOIN hdm_indic_dm_month b2 ON (a.nr_seq_month_end = b2.nr_sequencia)
LEFT OUTER JOIN hdm_indic_dm_day c2 ON (a.nr_seq_day_end = c2.nr_sequencia)
, pessoa_fisica pf
LEFT OUTER JOIN hdm_indic_ft_medication a ON (pf.cd_pessoa_fisica = a.nr_dif_person)
WHERE 1 = 1 AND f.nr_seq_dimensao = e.nr_sequencia AND h.nr_seq_dimension = g.nr_sequencia AND j.nr_seq_dimension = i.nr_sequencia AND o.nr_seq_dimension = n.nr_sequencia AND a.nr_sequencia = f.nr_seq_fact AND a.nr_sequencia = h.nr_seq_fact AND a.nr_sequencia = j.nr_seq_fact AND a.nr_sequencia = o.nr_seq_fact AND a.nr_seq_medication = k.nr_sequencia AND a.nr_seq_patient_group = d.nr_sequencia AND b.nr_sequencia = a.nr_seq_month_start  AND c.nr_sequencia = a.nr_seq_day_start;

