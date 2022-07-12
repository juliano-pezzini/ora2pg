-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';




CREATE OR REPLACE PROCEDURE hdm_indic_pck.link_search_rule_with_pt_fact () AS $body$
BEGIN
		merge into hdm_indic_ft_partic_sr y
		using(	SELECT	a.nr_sequencia nr_seq_dimension,
				x.nr_sequencia nr_seq_fact
			from	hdm_indic_dm_search_rule a,
				mprev_regra_cubo c,
				mprev_populacao_alvo mpa,
				mprev_pop_alvo_pessoa mpap,
				mprev_participante d,
				hdm_indic_ft_partic x,
				hdm_indic_dm_month y
			where	y.dt_complete_date between pkg_date_utils.start_of(mpa.dt_inicio_geracao,'MONTH', 0) and pkg_date_utils.start_of(coalesce(mpa.dt_fim_geracao,mpa.dt_inicio_geracao),'MONTH', 0)
			and	a.nm_rule = c.nm_regra
			and	c.nr_sequencia = mpa.nr_seq_regra_cubo
			and	mpa.nr_sequencia = mpap.nr_seq_populacao_alvo
			and	mpap.cd_pessoa_fisica = d.cd_pessoa_fisica
			and	d.cd_pessoa_fisica = x.nr_dif_person
			and	x.nr_seq_month	= y.nr_sequencia
			group by
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

		merge into hdm_indic_ft_partic_sr y
		using(	SELECT	0 nr_seq_dimension,
				x.nr_sequencia nr_seq_fact
			from	hdm_indic_ft_partic x
			where	not exists (select	1
						from	hdm_indic_ft_partic_sr a
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
-- REVOKE ALL ON PROCEDURE hdm_indic_pck.link_search_rule_with_pt_fact () FROM PUBLIC;