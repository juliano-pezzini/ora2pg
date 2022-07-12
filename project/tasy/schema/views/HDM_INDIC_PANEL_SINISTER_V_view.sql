-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';

CREATE OR REPLACE VIEW hdm_indic_panel_sinister_v (nr_seq_fact, nm_person, qt_age, si_sex, dt_inclusion, ds_programs, pr_sinister_year, pr_sinister_semester, pr_sinister_quarter, pr_sinister_month, pr_sinister_year_before, si_participant) AS SELECT	a.nr_sequencia nr_seq_fact,
	a.nm_person,
	a.qt_age,
	a.si_sex,
	to_char(a.dt_inclusion, 'dd/mm/yyyy') dt_inclusion,
	a.ds_programs,
	a.pr_sinister_year,
	a.pr_sinister_semester,
	a.pr_sinister_quarter,
	a.pr_sinister_month,
	a.pr_sinister_year_before,
	a.si_participant
FROM	hdm_indic_ft_panel_sinist a;
