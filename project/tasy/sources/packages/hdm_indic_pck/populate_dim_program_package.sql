-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';

	
	/*---------------------------------------------------------------------------------------------------------------------------------------------
	|			DIMENSIONS						    |
	*/

	


CREATE OR REPLACE PROCEDURE hdm_indic_pck.populate_dim_program () AS $body$
BEGIN
		merge into hdm_indic_dm_program y
		using(	/* Programs with modules defined */

			SELECT	distinct
				c.nr_sequencia nr_seq_program,
				c.nm_programa nm_program,
				b.nr_sequencia nr_seq_module,
				c.nm_programa || ' / ' || b.ds_modulo nm_program_module,
				'N' si_without_program
			from	mprev_programa c,
				mprev_modulo_atend b,
				mprev_programa_modulo a
			where	a.nr_seq_modulo = b.nr_sequencia
			and	a.nr_seq_programa = c.nr_sequencia
			/* Programs without modules defined */


			
union all

			SELECT	c.nr_sequencia nr_seq_program,
				c.nm_programa nm_program,
				0 nr_seq_module,
				c.nm_programa || ' / ' || wheb_mensagem_pck.get_texto(358368) nm_program_module,
				'N' si_without_program
			from	mprev_programa c
			/* Without program */


			
union all

			select	0 nr_seq_program,
				wheb_mensagem_pck.get_texto(358369) nm_program,
				0 nr_seq_module,
				wheb_mensagem_pck.get_texto(358369) || ' / ' ||  wheb_mensagem_pck.get_texto(358368) nm_program_module,
				'S' si_without_program
			) x
		on (	y.nr_seq_program = x.nr_seq_program and
			y.nr_seq_module = x.nr_seq_module)
		when not matched then
			insert(y.nr_sequencia,
				y.dt_atualizacao, 
				y.nm_usuario, 
				y.dt_atualizacao_nrec, 
				y.nm_usuario_nrec, 
				y.nm_program_module, 
				y.nm_program, 
				y.nr_seq_program, 
				y.nr_seq_module)
			values (CASE WHEN x.si_without_program='S' THEN  0  ELSE nextval('hdm_indic_dm_program_seq') END ,
				clock_timestamp(),
				current_setting('hdm_indic_pck.nm_usuario_w')::usuario.nm_usuario%type,
				clock_timestamp(),
				current_setting('hdm_indic_pck.nm_usuario_w')::usuario.nm_usuario%type,
				x.nm_program_module,
				x.nm_program,
				x.nr_seq_program,
				x.nr_seq_module);
		commit;
	END;

$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE hdm_indic_pck.populate_dim_program () FROM PUBLIC;