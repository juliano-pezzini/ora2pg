-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';




CREATE OR REPLACE PROCEDURE hdm_indic_pck.populate_dim_activ_group () AS $body$
BEGIN
		merge into hdm_indic_dm_activ_group y
		using(	SELECT	a.nr_sequencia nr_seq_turma,
				c.nm_grupo nm_group,
				c.nm_grupo || ' / ' || a.nm_turma nm_class,
				'N' si_without_group
			from	mprev_grupo_coletivo c,
				mprev_grupo_col_turma a
			where	a.nr_seq_grupo_coletivo = c.nr_sequencia
			/* Without group */


			
union all

			SELECT	0 nr_seq_turma,
				wheb_mensagem_pck.get_texto(358217) nm_group,
				wheb_mensagem_pck.get_texto(358217) || ' / ' || wheb_mensagem_pck.get_texto(358218) nm_class,
				'S' si_without_group
			) x
		on (	y.nr_seq_turma = x.nr_seq_turma and
			y.nm_group = x.nm_group and
			y.nm_class = x.nm_class)
		when not matched then
			insert(y.nr_sequencia,
				y.dt_atualizacao, 
				y.nm_usuario, 
				y.dt_atualizacao_nrec, 
				y.nm_usuario_nrec, 
				y.nm_class, 
				y.nm_group, 
				y.nr_seq_turma) 
			values (CASE WHEN x.si_without_group='S' THEN  0  ELSE nextval('hdm_indic_dm_activ_group_seq') END ,
				clock_timestamp(),
				current_setting('hdm_indic_pck.nm_usuario_w')::usuario.nm_usuario%type,
				clock_timestamp(),
				current_setting('hdm_indic_pck.nm_usuario_w')::usuario.nm_usuario%type,
				substr(x.nm_class,1,255),
				x.nm_group,
				x.nr_seq_turma);
		commit;
	END;

$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE hdm_indic_pck.populate_dim_activ_group () FROM PUBLIC;