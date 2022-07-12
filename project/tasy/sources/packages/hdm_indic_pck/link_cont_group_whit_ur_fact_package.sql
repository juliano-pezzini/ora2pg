-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';




CREATE OR REPLACE PROCEDURE hdm_indic_pck.link_cont_group_whit_ur_fact () AS $body$
BEGIN
		merge into hdm_indic_ft_med_bill_cg y
		using(	SELECT	a.nr_sequencia nr_seq_dimension,
				x.nr_sequencia nr_seq_fact
			from	hdm_indic_dm_control_group a,
				mprev_grupo_cont_pessoa c,
				mprev_grupo_controle d,
				hdm_indic_ft_med_bill x,
				hdm_indic_dm_day y
			where	y.dt_complete_date between c.dt_inclusao and coalesce(c.dt_exclusao,y.dt_complete_date)
			and	a.nm_group = d.nm_grupo
			and	c.nr_seq_grupo_controle = d.nr_sequencia
			and	c.cd_pessoa_fisica = x.nr_dif_person
			and	x.nr_seq_day	= y.nr_sequencia
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
		
		merge into hdm_indic_ft_med_bill_cg y
		using(	SELECT	0 nr_seq_dimension,
				x.nr_sequencia nr_seq_fact
			from	hdm_indic_ft_med_bill x
			where	not exists (select	1
						from	hdm_indic_ft_med_bill_cg a
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
-- REVOKE ALL ON PROCEDURE hdm_indic_pck.link_cont_group_whit_ur_fact () FROM PUBLIC;
