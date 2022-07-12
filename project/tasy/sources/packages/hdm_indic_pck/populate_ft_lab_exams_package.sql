-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';

	
	/*			*
	*	EXAMS FACTS	*
	*			*/

	
CREATE TYPE exam_data AS (nr_seq_exame		exame_lab_result_item.nr_seq_exame%type,
				nr_seq_dm_exam		bigint,
				cd_pessoa_fisica	pessoa_fisica.cd_pessoa_fisica%type,
				ie_sexo			pessoa_fisica.ie_sexo%type,
				nr_seq_participante	mprev_participante.nr_sequencia%type,
				dt_nascimento		pessoa_fisica.dt_nascimento%type,
				nr_seq_patient_group	bigint);


CREATE OR REPLACE PROCEDURE hdm_indic_pck.populate_ft_lab_exams () AS $body$
DECLARE

	
	i			bigint	:= 1;
	j			bigint	:= 1;
	k			bigint	:= 1;
	nr_seq_patient_group_w	bigint	:= null;
	
	vector_person_w			vector_person;
	type vector_exam_data is table of exam_data index by integer;
	
	vector_exam_data_w		vector_exam_data;
	
	c_persons CURSOR(dt_start_pc timestamp, dt_end_pc timestamp) FOR
		SELECT	/*+ USE_CONCAT */
			distinct
			/*+ USE_CONCAT */

			pf.cd_pessoa_fisica,
			pf.ie_sexo,
			pt.nr_sequencia nr_seq_participante,
			pf.dt_nascimento
		FROM exame_lab_result_item resit, prescr_medica presc, prescr_procedimento pp, exame_lab_resultado lab, pessoa_fisica pf
LEFT OUTER JOIN mprev_participante pt ON (pf.cd_pessoa_fisica = pt.cd_pessoa_fisica)
WHERE lab.dt_resultado between dt_start_pc and dt_end_pc and resit.nr_seq_resultado 	= lab.nr_seq_resultado and lab.nr_prescricao	= presc.nr_prescricao and pp.nr_prescricao	= presc.nr_prescricao and pp.nr_sequencia		= resit.nr_seq_prescr and presc.cd_pessoa_fisica = pf.cd_pessoa_fisica  and ((resit.qt_resultado IS NOT NULL AND resit.qt_resultado::text <> '') or (resit.pr_resultado IS NOT NULL AND resit.pr_resultado::text <> '') or (resit.ds_resultado IS NOT NULL AND resit.ds_resultado::text <> ''));
		
		
	c_exams_data CURSOR(dt_start_pc timestamp, dt_end_pc timestamp, cd_pessoa_fisica_pc text) FOR
		SELECT	distinct
			resit.nr_seq_exame nr_seq_exame
		from	prescr_procedimento pp,
			prescr_medica presc,
			exame_lab_result_item resit,
			exame_lab_resultado lab
		where	lab.dt_resultado between dt_start_pc and dt_end_pc
		and	resit.nr_seq_resultado 	= lab.nr_seq_resultado
		and	lab.nr_prescricao	= presc.nr_prescricao
		and	pp.nr_prescricao	= presc.nr_prescricao
		and	pp.nr_sequencia		= resit.nr_seq_prescr
		and	presc.cd_pessoa_fisica	= cd_pessoa_fisica_pc
		and ((resit.qt_resultado IS NOT NULL AND resit.qt_resultado::text <> '') or (resit.pr_resultado IS NOT NULL AND resit.pr_resultado::text <> '') or (resit.ds_resultado IS NOT NULL AND resit.ds_resultado::text <> ''));

	
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
			for r_c_exam_data in c_exams_data(	current_setting('hdm_indic_pck.dt_start_w')::timestamp,
								current_setting('hdm_indic_pck.dt_end_w')::timestamp,
								vector_person_w[k].cd_pessoa_fisica) loop
				
				vector_exam_data_w[j].cd_pessoa_fisica 		:= vector_person_w[k].cd_pessoa_fisica;
				vector_exam_data_w[j].nr_seq_participante 	:= vector_person_w[k].nr_seq_participante;
				vector_exam_data_w[j].dt_nascimento 		:= vector_person_w[k].dt_nascimento;
				vector_exam_data_w[j].ie_sexo 			:= vector_person_w[k].ie_sexo;
				vector_exam_data_w[j].nr_seq_patient_group 	:= vector_person_w[k].nr_seq_patient_group;	
				
				vector_exam_data_w[j].nr_seq_dm_exam		:= hdm_indic_pck.get_exam(r_c_exam_data.nr_seq_exame);
				vector_exam_data_w[j].nr_seq_exame		:= r_c_exam_data.nr_seq_exame;
				j	:= j + 1;
			end loop;
		end loop;

		/* Open exams data vector */


		PERFORM set_config('hdm_indic_pck.qt_record_w', 0, false);
		i := vector_exam_data_w.count;
		for k in 1.. i loop
			insert into hdm_indic_ft_exam(	nr_sequencia,
					dt_atualizacao, 
					nm_usuario, 
					dt_atualizacao_nrec, 
					nm_usuario_nrec, 
					nr_dif_person,
					nr_seq_day,
					nr_seq_month,
					nr_seq_patient_group,
					qt_result, 
					vl_avg_result, 
					vl_med_result, 
					nr_seq_reference, 
					nr_seq_exam)
			SELECT	nextval('hdm_indic_ft_exam_seq'),
				clock_timestamp(),
				current_setting('hdm_indic_pck.nm_usuario_w')::usuario.nm_usuario%type,
				clock_timestamp(),
				current_setting('hdm_indic_pck.nm_usuario_w')::usuario.nm_usuario%type,
				vector_exam_data_w[k].cd_pessoa_fisica,
				(SELECT	max(x.nr_sequencia)
				from	hdm_indic_dm_day x
				where	x.dt_complete_date = ft.dt_day) nr_seq_day,
				(select	max(x.nr_sequencia)
				from	hdm_indic_dm_month x
				where	x.dt_complete_date = ft.dt_month) nr_seq_month,
				vector_exam_data_w[k].nr_seq_patient_group,
				ft.qt_result,
				ft.vl_avg_result,
				ft.vl_med_result,
				ft.nr_seq_reference,
				vector_exam_data_w[k].nr_seq_dm_exam
			from	(select	pkg_date_utils.start_of(lab.dt_resultado,'DD', 0) dt_day,
					pkg_date_utils.start_of(lab.dt_resultado,'MONTH', 0) dt_month,
					count(1) qt_result,
					(
						hdm_indic_pck.get_reference(coalesce(resit.qt_resultado,resit.pr_resultado), coalesce(resit.qt_minima,resit.pr_minimo), coalesce(resit.qt_maxima,resit.pr_maximo)) 
					) nr_seq_reference,
					resit.pr_resultado vl_avg_result,
					resit.qt_resultado vl_med_result
				from	prescr_medica presc,
					exame_lab_result_item resit,
					exame_lab_resultado lab
				where	lab.dt_resultado between current_setting('hdm_indic_pck.dt_start_w')::timestamp and current_setting('hdm_indic_pck.dt_end_w')::timestamp
				and	resit.nr_seq_resultado 	= lab.nr_seq_resultado
				and	lab.nr_prescricao	= presc.nr_prescricao
				and	presc.cd_pessoa_fisica	= vector_exam_data_w[k].cd_pessoa_fisica
				and	resit.nr_seq_exame	= vector_exam_data_w[k].nr_seq_exame
				and ((resit.qt_resultado IS NOT NULL AND resit.qt_resultado::text <> '') or (resit.pr_resultado IS NOT NULL AND resit.pr_resultado::text <> '') or (resit.ds_resultado IS NOT NULL AND resit.ds_resultado::text <> ''))
				group by
					pkg_date_utils.start_of(lab.dt_resultado,'DD', 0),
					pkg_date_utils.start_of(lab.dt_resultado,'MONTH', 0),
					hdm_indic_pck.get_reference(coalesce(resit.qt_resultado,resit.pr_resultado), coalesce(resit.qt_minima,resit.pr_minimo), coalesce(resit.qt_maxima,resit.pr_maximo)),
					resit.pr_resultado,
					resit.qt_resultado,
					resit.nr_seq_resultado,
					resit.nr_sequencia
				) ft;
				if (current_setting('hdm_indic_pck.qt_record_w')::integer >= current_setting('hdm_indic_pck.qt_rec_commit_w')::integer) then
					commit;
					PERFORM set_config('hdm_indic_pck.qt_record_w', 0, false);
				end if;
				PERFORM set_config('hdm_indic_pck.qt_record_w', current_setting('hdm_indic_pck.qt_record_w')::integer + 1, false);
		end loop;
		
		commit;
		
		CALL hdm_indic_pck.link_campaign_with_ex_fact();
		CALL hdm_indic_pck.link_activ_group_with_ex_fact();
		CALL hdm_indic_pck.link_program_with_ex_fact();
		CALL hdm_indic_pck.link_risk_disease_with_ex_fact();
		
	END;

$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE hdm_indic_pck.populate_ft_lab_exams () FROM PUBLIC;
