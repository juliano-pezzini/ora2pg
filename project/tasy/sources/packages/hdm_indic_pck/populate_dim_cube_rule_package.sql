-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';




CREATE OR REPLACE PROCEDURE hdm_indic_pck.populate_dim_cube_rule () AS $body$
BEGIN
		merge into hdm_indic_dm_search_rule y	
		using(	SELECT	a.nm_regra nm_rule,
				'N' si_default
			from	mprev_regra_cubo a
			
union

			SELECT	obter_desc_expressao(705006),
				'S' si_default
			) x
		on (	y.nm_rule = x.nm_rule)
		when not matched then 
			insert(y.nr_sequencia,
				y.dt_atualizacao,
				y.nm_usuario,
				y.dt_atualizacao_nrec,
				y.nm_usuario_nrec,
				y.nm_rule)
			values (CASE WHEN x.si_default='S' THEN  0  ELSE nextval('hdm_indic_dm_search_rule_seq') END ,
				clock_timestamp(),
				current_setting('hdm_indic_pck.nm_usuario_w')::usuario.nm_usuario%type,
				clock_timestamp(),
				current_setting('hdm_indic_pck.nm_usuario_w')::usuario.nm_usuario%type,
				x.nm_rule);
		commit;
	END;

$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE hdm_indic_pck.populate_dim_cube_rule () FROM PUBLIC;