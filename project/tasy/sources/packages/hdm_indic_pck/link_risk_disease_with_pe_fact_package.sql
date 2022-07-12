-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';




CREATE OR REPLACE PROCEDURE hdm_indic_pck.link_risk_disease_with_pe_fact () AS $body$
BEGIN
		merge into hdm_indic_ft_permanence_rd y
		using(	SELECT	a.nr_sequencia nr_seq_dimension,
				x.nr_days_permanence,
				x.nr_months_permanence,
				x.nr_sequencia nr_seq_fact
			from	hdm_indic_dm_risk_disease a,
				paciente_antec_clinico b,
				hdm_indic_ft_permanence x,
				hdm_indic_dm_month y
			where	(b.dt_liberacao IS NOT NULL AND b.dt_liberacao::text <> '')
			and	coalesce(b.dt_inativacao::text, '') = ''
			and (y.dt_complete_date between pkg_date_utils.start_of(b.dt_inicio,'MONTH', 0) and pkg_date_utils.start_of(coalesce(b.dt_fim,y.dt_complete_date),'MONTH', 0) or coalesce(b.dt_inicio::text, '') = '')
			and	a.ds_icd_list   like '%,'||to_char(b.cd_doenca)||',%'
			and	b.cd_pessoa_fisica = x.nr_dif_person
			and	x.nr_seq_month	= y.nr_sequencia
			group by
				a.nr_sequencia,
				x.nr_sequencia,
				x.nr_days_permanence,
				x.nr_months_permanence
			) x
		on (	y.nr_seq_fact = x.nr_seq_fact and
			y.nr_seq_dimension = x.nr_seq_dimension)
		when not matched then
			insert(y.nr_seq_fact,
				y.nr_seq_dimension,
				y.nr_days_permanence,
				y.nr_months_permanence)
			values (x.nr_seq_fact,
				x.nr_seq_dimension,
				x.nr_days_permanence,
				x.nr_months_permanence);
		commit;

		merge into hdm_indic_ft_permanence_rd y
		using(	SELECT	0 nr_seq_dimension,
				x.nr_days_permanence,
				x.nr_months_permanence,
				x.nr_sequencia nr_seq_fact
			from	hdm_indic_ft_permanence x
			where	not exists (select	1
						from	hdm_indic_ft_permanence_rd a
						where	a.nr_seq_fact	= x.nr_sequencia)
			) x
		on (	y.nr_seq_fact = x.nr_seq_fact and
			y.nr_seq_dimension = x.nr_seq_dimension)
		when not matched then
			insert(y.nr_seq_fact,
				y.nr_seq_dimension,
				y.nr_days_permanence,
				y.nr_months_permanence)
			values (x.nr_seq_fact,
				x.nr_seq_dimension,
				x.nr_days_permanence,
				x.nr_months_permanence);
		commit;
	END;

$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE hdm_indic_pck.link_risk_disease_with_pe_fact () FROM PUBLIC;
