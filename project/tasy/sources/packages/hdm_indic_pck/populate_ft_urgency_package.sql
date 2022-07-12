-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';

	
	/*			*
	*	URGENCIES FACTS	*
	*			*/

	
CREATE TYPE urgency_data AS (	nr_seq_bill_type	bigint,
					dt_reference		timestamp,
					cd_pessoa_fisica	pessoa_fisica.cd_pessoa_fisica%type,
					ie_sexo			pessoa_fisica.ie_sexo%type,
					nr_seq_participante	mprev_participante.nr_sequencia%type,
					dt_nascimento		pessoa_fisica.dt_nascimento%type,
					nr_seq_patient_group	bigint);


CREATE OR REPLACE PROCEDURE hdm_indic_pck.populate_ft_urgency () AS $body$
DECLARE

	i			bigint	:= 1;
	j			bigint	:= 1;
	k			bigint	:= 1;
	nr_seq_patient_group_w	bigint	:= null;
	
	vector_person_w			vector_person;
	type vector_urgency_data is table of urgency_data index by integer;
	
	vector_urgency_data_w		vector_urgency_data;
	
	c_persons CURSOR(dt_start_pc timestamp, dt_end_pc timestamp) FOR
		SELECT	/*+ USE_CONCAT */
			distinct
			/*+ USE_CONCAT */

			pf.cd_pessoa_fisica,
			pf.ie_sexo,
			pt.nr_sequencia nr_seq_participante,
			pf.dt_nascimento
		FROM pls_segurado ps, pls_conta pc, pessoa_fisica pf
LEFT OUTER JOIN mprev_participante pt ON (pf.cd_pessoa_fisica = pt.cd_pessoa_fisica)
WHERE pc.dt_atendimento_referencia between dt_start_pc and dt_end_pc and ps.nr_sequencia = pc.nr_seq_segurado and ps.cd_pessoa_fisica = pf.cd_pessoa_fisica;
		
	c_urgencies_data CURSOR(dt_start_pc timestamp, dt_end_pc timestamp, cd_pessoa_fisica_pc text) FOR
		SELECT	distinct
			pc.ie_tipo_guia si_tab_type,
			pc.ie_carater_internacao si_character_hosp,
			pc.dt_atendimento_referencia dt_reference,
			pc.nr_sequencia  nr_seq_bill
		FROM pls_segurado ps, pls_conta pc, pessoa_fisica pf
LEFT OUTER JOIN mprev_participante pt ON (pf.cd_pessoa_fisica = pt.cd_pessoa_fisica)
WHERE pc.dt_atendimento_referencia between dt_start_pc and dt_end_pc and ps.nr_sequencia = pc.nr_seq_segurado and pf.cd_pessoa_fisica = ps.cd_pessoa_fisica  and pf.cd_pessoa_fisica = cd_pessoa_fisica_pc;

	
BEGIN			
		/* Generate person vector */


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

		/* Open person vector */


		j	:= 1;
		i := vector_person_w.count;
		for k in 1.. i loop
			for	r_c_urgencies_data in c_urgencies_data(	current_setting('hdm_indic_pck.dt_start_w')::timestamp,
									current_setting('hdm_indic_pck.dt_end_w')::timestamp,
									vector_person_w[k].cd_pessoa_fisica) loop
				
				vector_urgency_data_w[j].cd_pessoa_fisica 	:= vector_person_w[k].cd_pessoa_fisica;
				vector_urgency_data_w[j].nr_seq_participante 	:= vector_person_w[k].nr_seq_participante;
				vector_urgency_data_w[j].dt_nascimento 		:= vector_person_w[k].dt_nascimento;
				vector_urgency_data_w[j].ie_sexo 		:= vector_person_w[k].ie_sexo;
				vector_urgency_data_w[j].nr_seq_patient_group 	:= vector_person_w[k].nr_seq_patient_group;	
				
				vector_urgency_data_w[j].dt_reference		:= r_c_urgencies_data.dt_reference;
				vector_urgency_data_w[j].nr_seq_bill_type	:= hdm_indic_pck.get_bill_type(r_c_urgencies_data.nr_seq_bill, r_c_urgencies_data.si_tab_type, r_c_urgencies_data.si_character_hosp);
				
				j	:= j + 1;
			end loop;
		end loop;

		-- Open urgencies data vector 

		PERFORM set_config('hdm_indic_pck.qt_record_w', 0, false);
		i := vector_urgency_data_w.count;
		
		for k in 1.. i loop
			insert into hdm_indic_ft_med_bill(	nr_sequencia,
					dt_atualizacao, 
					nm_usuario, 
					dt_atualizacao_nrec, 
					nm_usuario_nrec, 
					nr_seq_bill_type, 
					nr_seq_day, 
					nr_seq_month, 
					nr_seq_patient_group, 
					nr_dif_person,
					ds_unique)
			SELECT	nextval('hdm_indic_ft_med_bill_seq'),
				clock_timestamp(),
				current_setting('hdm_indic_pck.nm_usuario_w')::usuario.nm_usuario%type,
				clock_timestamp(),
				current_setting('hdm_indic_pck.nm_usuario_w')::usuario.nm_usuario%type,
				vector_urgency_data_w[k].nr_seq_bill_type,
				(	
					SELECT	x.nr_sequencia
					from	hdm_indic_dm_day x
					where	x.dt_complete_date = pkg_date_utils.start_of(vector_urgency_data_w[k].dt_reference, 'DD', 0)
				) nr_seq_day,
				(	
					select	x.nr_sequencia
					from	hdm_indic_dm_month x
					where	x.dt_complete_date = pkg_date_utils.start_of(vector_urgency_data_w[k].dt_reference, 'MONTH', 0)
				) nr_seq_month,
				vector_urgency_data_w[k].nr_seq_patient_group,
				vector_urgency_data_w[k].cd_pessoa_fisica,
				current_setting('hdm_indic_pck.ds_unique_w')::varchar(255)
			;
				
			if (current_setting('hdm_indic_pck.qt_record_w')::integer >= current_setting('hdm_indic_pck.qt_rec_commit_w')::integer) then
				commit;
				PERFORM set_config('hdm_indic_pck.qt_record_w', 0, false);
			end if;
			PERFORM set_config('hdm_indic_pck.qt_record_w', current_setting('hdm_indic_pck.qt_record_w')::integer + 1, false);
		end loop;
		
		commit;
		
		CALL hdm_indic_pck.link_campaign_with_ur_fact();
		CALL hdm_indic_pck.link_activ_group_with_ur_fact();
		CALL hdm_indic_pck.link_program_with_ur_fact();
		CALL hdm_indic_pck.link_risk_disease_with_ur_fact();
		
		CALL hdm_indic_pck.link_diagnosis_whit_ur_fact();
		CALL hdm_indic_pck.link_cont_group_whit_ur_fact();
	END;

$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE hdm_indic_pck.populate_ft_urgency () FROM PUBLIC;