-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';




CREATE OR REPLACE PROCEDURE hdm_indic_pck.link_professional_with_ag_fact () AS $body$
BEGIN
		merge into hdm_indic_ft_group_act_pf y
		using(	SELECT	a.nr_sequencia nr_seq_dimension,
				x.nr_sequencia nr_seq_fact,
				x.qt_expected,
				x.qt_real
			from	hdm_indic_dm_professional a,	
				mprev_equipe_profissional c,
				mprev_atendimento d,
				mprev_participante b,    
				mprev_atend_paciente e,              
				hdm_indic_ft_group_act x,
				pessoa_fisica pf,
				mprev_funcao_colaborador fu,
				mprev_equipe eq,
				hdm_indic_dm_day y		
			where d.nr_sequencia = e.nr_seq_atendimento	
			and	y.dt_complete_date between d.dt_inicio and coalesce(d.dt_termino,d.dt_inicio)
			and	a.nm_professional = pf.nm_pessoa_fisica 
			and	pf.cd_pessoa_fisica = c.cd_pessoa_fisica
			and	a.nm_responsability = fu.nm_funcao 
			and	fu.nr_sequencia = c.nr_seq_funcao
			and	a.nm_team = eq.nm_equipe 
			and	eq.nr_sequencia = c.nr_seq_equipe
			and	e.nr_seq_participante = b.nr_sequencia
			and	c.cd_pessoa_fisica = d.cd_profissional
			and	b.cd_pessoa_fisica = x.nr_dif_person
			and	x.nr_seq_day_scheduled = y.nr_sequencia
			group by
				a.nr_sequencia,
				x.nr_sequencia,
				x.qt_expected,
				x.qt_real
			) x
		on (	y.nr_seq_fact = x.nr_seq_fact and
			y.nr_seq_dimension = x.nr_seq_dimension)
		when not matched then
			insert(y.nr_seq_fact, 
				y.nr_seq_dimension,
				y.qt_expected,
				y.qt_real)
			values (x.nr_seq_fact,
				x.nr_seq_dimension,
				x.qt_expected,
				x.qt_real);
		commit;
		
		merge into hdm_indic_ft_group_act_pf y
		using(	SELECT	0 nr_seq_dimension,
				x.nr_sequencia nr_seq_fact,
				x.qt_expected,
				x.qt_real
			from	hdm_indic_ft_group_act x
			where	not exists (select	1
						from	hdm_indic_ft_group_act_pf a
						where	a.nr_seq_fact	= x.nr_sequencia)
			) x
		on (	y.nr_seq_fact = x.nr_seq_fact and
			y.nr_seq_dimension = x.nr_seq_dimension)
		when not matched then
			insert(y.nr_seq_fact,
				y.nr_seq_dimension,
				y.qt_expected,
				y.qt_real)
			values (x.nr_seq_fact,
				x.nr_seq_dimension,
				x.qt_expected,
				x.qt_real);
		commit;
	END;	

$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE hdm_indic_pck.link_professional_with_ag_fact () FROM PUBLIC;
