-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';

	
	/*			*
	*	HABITS FACTS	*
	*			*/
	
	
CREATE TYPE habit_data AS (nr_seq_habit		bigint,
				dt_start_adjusted	timestamp,
				dt_end_adjusted		timestamp,
				cd_pessoa_fisica	pessoa_fisica.cd_pessoa_fisica%type,
				ie_sexo			pessoa_fisica.ie_sexo%type,
				nr_seq_participante	mprev_participante.nr_sequencia%type,
				dt_nascimento		pessoa_fisica.dt_nascimento%type,
				nr_seq_patient_group	bigint);


CREATE OR REPLACE PROCEDURE hdm_indic_pck.populate_ft_habits () AS $body$
DECLARE
	
	i			bigint	:= 1;
	j			bigint	:= 1;
	k			bigint	:= 1;
	nr_seq_patient_group_w	bigint	:= null;	
	vector_person_w			vector_person;
	type vector_habit_data is table of habit_data index by integer;
	
	vector_habit_data_w		vector_habit_data;
	dt_last_start_w			timestamp;
	dt_last_end_w			timestamp;
	si_last_freq_w			varchar(1);
	si_last_habit_w			varchar(10);
	
	c_persons CURSOR(dt_start_pc timestamp, dt_end_pc timestamp) FOR
		SELECT	/*+ USE_CONCAT */
			distinct
			/*+ USE_CONCAT */

			pf.cd_pessoa_fisica,
			pf.ie_sexo,
			pt.nr_sequencia nr_seq_participante,
			pf.dt_nascimento
		FROM paciente_habito_vicio hv, pessoa_fisica pf
LEFT OUTER JOIN mprev_participante pt ON (pf.cd_pessoa_fisica = pt.cd_pessoa_fisica)
WHERE hv.dt_liberacao between dt_start_pc and dt_end_pc and (hv.ie_classificacao IS NOT NULL AND hv.ie_classificacao::text <> '') and hv.cd_pessoa_fisica = pf.cd_pessoa_fisica;
		
	c_habit_data CURSOR(dt_start_pc timestamp, dt_end_pc timestamp, cd_pessoa_fisica_pc text, dt_nascimento_p timestamp) FOR
		SELECT	distinct
			hv.ie_classificacao si_habit,
			coalesce(hv.ie_frequencia,0) si_frequency,
			hdm_indic_pck.get_date_start_habit(hv.dt_inicio, dt_nascimento_p, hv.qt_idade_exp, hv.qt_idade_reg, hv.dt_liberacao) dt_start_adjusted,
			coalesce(hv.dt_inativacao,hv.dt_fim) dt_end_adjusted,
			row_number() over (order by hv.ie_classificacao, hdm_indic_pck.get_date_start_habit(hv.dt_inicio, dt_nascimento_p, hv.qt_idade_exp, hv.qt_idade_reg, hv.dt_liberacao)) rn,
			count(1) over () cnt
		from	paciente_habito_vicio hv
		where	hv.dt_liberacao between dt_start_pc and dt_end_pc
		and	(hv.ie_classificacao IS NOT NULL AND hv.ie_classificacao::text <> '')
		and	hv.cd_pessoa_fisica	= cd_pessoa_fisica_pc
		order by
			si_habit,
			dt_start_adjusted;

	c_habit_no_data CURSOR(dt_start_pc timestamp, dt_end_pc timestamp, cd_pessoa_fisica_pc text) FOR
		SELECT	vd.vl_dominio si_habit,
			0 si_frequency,
			to_date('01/01/1900') dt_start_adjusted,
			null dt_end_adjusted
		from	valor_dominio_v vd
		where	vd.cd_dominio = 1335
		and	not exists (	SELECT	1
					from	paciente_habito_vicio hv
					where	hv.dt_liberacao between dt_start_pc and dt_end_pc
					and	hv.ie_classificacao = vd.vl_dominio
					and	hv.cd_pessoa_fisica	= cd_pessoa_fisica_pc);
	
BEGIN		
		-- Generate person vector 

		i	:= 1;
		for r_c_persons in c_persons(current_setting('hdm_indic_pck.dt_start_w')::timestamp,current_setting('hdm_indic_pck.dt_end_w')::timestamp) loop
			nr_seq_patient_group_w	:= hdm_indic_pck.get_patient_group(	r_c_persons.cd_pessoa_fisica,
									r_c_persons.nr_seq_participante,
									r_c_persons.dt_nascimento,
									r_c_persons.ie_sexo);
									
			vector_person_w[i].cd_pessoa_fisica 		:= r_c_persons.cd_pessoa_fisica;
			vector_person_w[i].nr_seq_participante 		:= r_c_persons.nr_seq_participante;
			vector_person_w[i].dt_nascimento 		:= r_c_persons.dt_nascimento;
			vector_person_w[i].ie_sexo 			:= r_c_persons.ie_sexo;
			vector_person_w[i].nr_seq_patient_group 	:= nr_seq_patient_group_w;
			i	:= i + 1;
		end loop;

		si_last_habit_w	:= null;
		-- Open person vector 

		j	:= 1;
		i := vector_person_w.count;
		for k in 1.. i loop
			for r_c_habit_data in c_habit_data(	current_setting('hdm_indic_pck.dt_start_w')::timestamp,
								current_setting('hdm_indic_pck.dt_end_w')::timestamp,
								vector_person_w[k].cd_pessoa_fisica,
								vector_person_w[k].dt_nascimento) loop
								
				if (r_c_habit_data.dt_start_adjusted IS NOT NULL AND r_c_habit_data.dt_start_adjusted::text <> '') then	
					/* Generate data for non existent habit */


					/* Always need to generate a non existent habit before */


					vector_habit_data_w[j].cd_pessoa_fisica 	:= vector_person_w[k].cd_pessoa_fisica;
					vector_habit_data_w[j].nr_seq_participante 	:= vector_person_w[k].nr_seq_participante;
					vector_habit_data_w[j].dt_nascimento 		:= vector_person_w[k].dt_nascimento;
					vector_habit_data_w[j].ie_sexo 			:= vector_person_w[k].ie_sexo;
					vector_habit_data_w[j].nr_seq_patient_group 	:= vector_person_w[k].nr_seq_patient_group;	
					
					vector_habit_data_w[j].nr_seq_habit		:= hdm_indic_pck.get_habit(r_c_habit_data.si_habit, r_c_habit_data.si_frequency, 'N');
					if (dt_last_end_w IS NOT NULL AND dt_last_end_w::text <> '') and (r_c_habit_data.si_habit = si_last_habit_w) then
						vector_habit_data_w[j].dt_start_adjusted	:= dt_last_end_w + 1;
						vector_habit_data_w[j].dt_end_adjusted		:= r_c_habit_data.dt_start_adjusted - 1;
					else
						vector_habit_data_w[j].dt_start_adjusted	:= to_date('01/01/1900', 'dd/mm/yyyy');
						vector_habit_data_w[j].dt_end_adjusted		:= r_c_habit_data.dt_start_adjusted - 1;
					end if;
					j	:= j + 1;
					
					if (r_c_habit_data.si_habit <> si_last_habit_w) and (dt_last_end_w IS NOT NULL AND dt_last_end_w::text <> '') then				
						/* Generate data for non existent habit */


						/* When there is no end date, there is a need to generate no existent habit after */


						vector_habit_data_w[j].cd_pessoa_fisica 	:= vector_person_w[k].cd_pessoa_fisica;
						vector_habit_data_w[j].nr_seq_participante 	:= vector_person_w[k].nr_seq_participante;
						vector_habit_data_w[j].dt_nascimento 		:= vector_person_w[k].dt_nascimento;
						vector_habit_data_w[j].ie_sexo 			:= vector_person_w[k].ie_sexo;
						vector_habit_data_w[j].nr_seq_patient_group 	:= vector_person_w[k].nr_seq_patient_group;	
						
						vector_habit_data_w[j].nr_seq_habit		:= hdm_indic_pck.get_habit(si_last_habit_w, si_last_freq_w, 'N');
						vector_habit_data_w[j].dt_start_adjusted	:= dt_last_end_w + 1;
						vector_habit_data_w[j].dt_end_adjusted		:= null;

						j	:= j + 1;
						
						dt_last_start_w	:= null;
						dt_last_end_w	:= null;
					end if;
					
					
					/* With habit in period */


					vector_habit_data_w[j].cd_pessoa_fisica 	:= vector_person_w[k].cd_pessoa_fisica;
					vector_habit_data_w[j].nr_seq_participante 	:= vector_person_w[k].nr_seq_participante;
					vector_habit_data_w[j].dt_nascimento 		:= vector_person_w[k].dt_nascimento;
					vector_habit_data_w[j].ie_sexo 			:= vector_person_w[k].ie_sexo;
					vector_habit_data_w[j].nr_seq_patient_group 	:= vector_person_w[k].nr_seq_patient_group;	
					
					vector_habit_data_w[j].nr_seq_habit		:= hdm_indic_pck.get_habit(r_c_habit_data.si_habit, r_c_habit_data.si_frequency, 'S');
					vector_habit_data_w[j].dt_start_adjusted	:= r_c_habit_data.dt_start_adjusted;
					vector_habit_data_w[j].dt_end_adjusted		:= r_c_habit_data.dt_end_adjusted;
					
					j	:= j + 1;
					
					si_last_habit_w	:= r_c_habit_data.si_habit;
					dt_last_start_w	:= r_c_habit_data.dt_start_adjusted;
					dt_last_end_w	:= r_c_habit_data.dt_end_adjusted;
					si_last_freq_w	:= r_c_habit_data.si_frequency;
					
					/* Condition to create a future period without the habit */


					if (dt_last_end_w IS NOT NULL AND dt_last_end_w::text <> '') and (r_c_habit_data.rn = r_c_habit_data.cnt) then
						vector_habit_data_w[j].cd_pessoa_fisica 	:= vector_person_w[k].cd_pessoa_fisica;
						vector_habit_data_w[j].nr_seq_participante 	:= vector_person_w[k].nr_seq_participante;
						vector_habit_data_w[j].dt_nascimento 		:= vector_person_w[k].dt_nascimento;
						vector_habit_data_w[j].ie_sexo 			:= vector_person_w[k].ie_sexo;
						vector_habit_data_w[j].nr_seq_patient_group 	:= vector_person_w[k].nr_seq_patient_group;	
						
						vector_habit_data_w[j].nr_seq_habit		:= hdm_indic_pck.get_habit(si_last_habit_w, si_last_freq_w, 'N');
						vector_habit_data_w[j].dt_start_adjusted	:= dt_last_end_w + 1;
						vector_habit_data_w[j].dt_end_adjusted		:= null;

						j	:= j + 1;
						
						dt_last_start_w	:= null;
						dt_last_end_w	:= null;
					end if;
					
				end if;
			end loop;
			/* Cursor to populate the facts that no exists habits to this person */


			for	r_c_habit_no_data in c_habit_no_data(	current_setting('hdm_indic_pck.dt_start_w')::timestamp,
									current_setting('hdm_indic_pck.dt_end_w')::timestamp,
									vector_person_w[k].cd_pessoa_fisica) loop
				vector_habit_data_w[j].cd_pessoa_fisica 	:= vector_person_w[k].cd_pessoa_fisica;
				vector_habit_data_w[j].nr_seq_participante 	:= vector_person_w[k].nr_seq_participante;
				vector_habit_data_w[j].dt_nascimento 		:= vector_person_w[k].dt_nascimento;
				vector_habit_data_w[j].ie_sexo 			:= vector_person_w[k].ie_sexo;
				vector_habit_data_w[j].nr_seq_patient_group 	:= vector_person_w[k].nr_seq_patient_group;	
				
				vector_habit_data_w[j].nr_seq_habit		:= hdm_indic_pck.get_habit(r_c_habit_no_data.si_habit, r_c_habit_no_data.si_frequency, 'N');
				vector_habit_data_w[j].dt_start_adjusted	:= r_c_habit_no_data.dt_start_adjusted;
				vector_habit_data_w[j].dt_end_adjusted		:= r_c_habit_no_data.dt_end_adjusted;
				
				j	:= j + 1;
			end loop;
		end loop;

		-- Open vital sign data vector 

		PERFORM set_config('hdm_indic_pck.qt_record_w', 0, false);
		i := vector_habit_data_w.count;
		for k in 1.. i loop
			
			insert into hdm_indic_ft_habit(	nr_sequencia,
					dt_atualizacao, 
					nm_usuario, 
					dt_atualizacao_nrec, 
					nm_usuario_nrec, 
					nr_seq_habit, 
					nr_dif_person, 
					nr_seq_day_start, 
					nr_seq_month_start, 
					nr_seq_day_end, 
					nr_seq_month_end, 
					nr_seq_patient_group)
			SELECT	nextval('hdm_indic_ft_habit_seq'),
				clock_timestamp(),
				current_setting('hdm_indic_pck.nm_usuario_w')::usuario.nm_usuario%type,
				clock_timestamp(),
				current_setting('hdm_indic_pck.nm_usuario_w')::usuario.nm_usuario%type,
				vector_habit_data_w[k].nr_seq_habit,
				vector_habit_data_w[k].cd_pessoa_fisica,
				(	SELECT	max(x.nr_sequencia)
					from	hdm_indic_dm_day x
					where	x.dt_complete_date = pkg_date_utils.start_of(vector_habit_data_w[k].dt_start_adjusted,'DD', 0)) nr_seq_day_start,
				(	select	max(x.nr_sequencia)
					from	hdm_indic_dm_month x
					where	x.dt_complete_date = pkg_date_utils.start_of(vector_habit_data_w[k].dt_start_adjusted,'MONTH', 0)) nr_seq_month_start,
				(	select	max(x.nr_sequencia)
					from	hdm_indic_dm_day x
					where	x.dt_complete_date = pkg_date_utils.start_of(vector_habit_data_w[k].dt_end_adjusted,'DD', 0)) nr_seq_day_end,
				(	select	max(x.nr_sequencia)
					from	hdm_indic_dm_month x
					where	x.dt_complete_date = pkg_date_utils.start_of(vector_habit_data_w[k].dt_end_adjusted,'MONTH', 0)) nr_seq_month_end,
				vector_habit_data_w[k].nr_seq_patient_group
			;
			
			if (current_setting('hdm_indic_pck.qt_record_w')::integer >= current_setting('hdm_indic_pck.qt_rec_commit_w')::integer) then
				commit;
				PERFORM set_config('hdm_indic_pck.qt_record_w', 0, false);
			end if;
			PERFORM set_config('hdm_indic_pck.qt_record_w', current_setting('hdm_indic_pck.qt_record_w')::integer + 1, false);
			
		end loop;
		
		commit;
		
		CALL hdm_indic_pck.link_campaign_with_hv_fact();
		CALL hdm_indic_pck.link_activ_group_with_hv_fact();
		CALL hdm_indic_pck.link_program_with_hv_fact();
		CALL hdm_indic_pck.link_risk_disease_with_hv_fact();
		
	END;

$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE hdm_indic_pck.populate_ft_habits () FROM PUBLIC;