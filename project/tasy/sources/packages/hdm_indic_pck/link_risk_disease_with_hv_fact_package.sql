-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';




CREATE OR REPLACE PROCEDURE hdm_indic_pck.link_risk_disease_with_hv_fact () AS $body$
BEGIN
		merge into hdm_indic_ft_habit_rd y
		using(	SELECT	a.nr_sequencia nr_seq_dimension,
				x.nr_sequencia nr_seq_fact
			FROM hdm_indic_dm_day y, paciente_antec_clinico b, hdm_indic_dm_risk_disease a, hdm_indic_ft_habit x
LEFT OUTER JOIN hdm_indic_dm_day z ON (x.nr_seq_day_end = z.nr_sequencia)
WHERE (b.dt_liberacao IS NOT NULL AND b.dt_liberacao::text <> '') and coalesce(b.dt_inativacao::text, '') = '' and y.dt_complete_date <= coalesce(b.dt_fim,y.dt_complete_date) and (z.dt_complete_date > b.dt_fim or coalesce(z.dt_complete_date::text, '') = '') and a.ds_icd_list like '%,'||to_char(b.cd_doenca)||',%' and y.nr_sequencia = x.nr_seq_day_start  and b.cd_pessoa_fisica = x.nr_dif_person group by
				a.nr_sequencia,
				x.nr_sequencia
			) x
		on (	y.nr_seq_fact = x.nr_seq_fact and
			y.nr_seq_dimension = x.nr_seq_dimension)
		when not matched then
			insert(y.nr_seq_fact, 
				y.nr_seq_dimension)
			values (x.nr_seq_fact,
				x.nr_seq_dimension);
		commit;
		
		merge into hdm_indic_ft_habit_rd y
		using(	SELECT	0 nr_seq_dimension,
				x.nr_sequencia nr_seq_fact
			from	hdm_indic_ft_habit x
			where	not exists (select	1
						from	hdm_indic_ft_habit_rd a
						where	a.nr_seq_fact	= x.nr_sequencia)
			) x
		on (	y.nr_seq_fact = x.nr_seq_fact and
			y.nr_seq_dimension = x.nr_seq_dimension)
		when not matched then
			insert(y.nr_seq_fact, 
				y.nr_seq_dimension)
			values (x.nr_seq_fact,
				x.nr_seq_dimension);
		commit;
	END;

$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE hdm_indic_pck.link_risk_disease_with_hv_fact () FROM PUBLIC;
