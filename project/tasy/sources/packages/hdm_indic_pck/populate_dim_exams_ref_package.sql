-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';




CREATE OR REPLACE PROCEDURE hdm_indic_pck.populate_dim_exams_ref () AS $body$
BEGIN
		merge into hdm_indic_dm_reference y
		using(	-- Above reference
			SELECT	wheb_mensagem_pck.get_texto(359886) nm_range,
				'>' si_reference,
				'N' si_default
			
			
union all

			-- Between reference

			SELECT	wheb_mensagem_pck.get_texto(359887) nm_range, 
				'=' si_reference,
				'N' si_default
			
			
union all

			-- Below reference

			select	wheb_mensagem_pck.get_texto(359885) nm_range,
				'<' si_reference,
				'N' si_default
			
			
union all

			-- Default

			select	wheb_mensagem_pck.get_texto(358141) nm_range, 
				' ' si_reference,
				'S' si_default
			
			) x
		on (	y.nm_range = x.nm_range and
			y.si_reference = x.si_reference)
		when not matched then
			insert(y.nr_sequencia, 
				y.dt_atualizacao, 
				y.nm_usuario, 
				y.dt_atualizacao_nrec, 
				y.nm_usuario_nrec, 
				y.nm_range, 
				y.si_reference)
			values (CASE WHEN x.si_default='S' THEN  0  ELSE nextval('hdm_indic_dm_reference_seq') END ,
				clock_timestamp(),
				current_setting('hdm_indic_pck.nm_usuario_w')::usuario.nm_usuario%type,
				clock_timestamp(),
				current_setting('hdm_indic_pck.nm_usuario_w')::usuario.nm_usuario%type,
				x.nm_range,
				x.si_reference);
		commit;
	END;

$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE hdm_indic_pck.populate_dim_exams_ref () FROM PUBLIC;