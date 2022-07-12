-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';




CREATE OR REPLACE PROCEDURE hdm_indic_pck.populate_dim_red_cost_range () AS $body$
BEGIN
		merge into hdm_indic_dm_cost_range y
		using(	SELECT	a.nm_range || chr(13) || chr(10) || '(' || a.pr_minimum || ' ~ ' || a.pr_maximum || ')' nm_range,
				a.pr_minimum pr_minimum,
				a.pr_maximum pr_maximum,
				'N' si_without_range
			from 	hdm_indic_sinister_range a
			where	a.ie_situacao = 'A'
			
union alL

			/* Without range */


			SELECT	wheb_mensagem_pck.get_texto(358141) nm_range,
				null pr_minimum,
				null pr_maximum,
				'S' si_without_range
			
			) x
		on (	(x.nm_range = x.nm_range and
			x.pr_minimum = x.pr_minimum and
			x.pr_maximum = x.pr_maximum) or (y.nr_sequencia = 0))
		when not matched then
			insert(y.nr_sequencia, 
				y.dt_atualizacao, 
				y.nm_usuario, 
				y.dt_atualizacao_nrec, 
				y.nm_usuario_nrec, 
				y.nm_range,
				y.pr_minimum, 
				y.pr_maximum)
			values (CASE WHEN x.si_without_range='S' THEN  0  ELSE nextval('hdm_indic_dm_cost_range_seq') END ,
				clock_timestamp(),
				current_setting('hdm_indic_pck.nm_usuario_w')::usuario.nm_usuario%type,
				clock_timestamp(),
				current_setting('hdm_indic_pck.nm_usuario_w')::usuario.nm_usuario%type,
				x.nm_range,
				x.pr_minimum, 
				x.pr_maximum);
		commit;
	END;

$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE hdm_indic_pck.populate_dim_red_cost_range () FROM PUBLIC;