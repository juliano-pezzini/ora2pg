-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';

	
	/*				*
	*	PARTICIPANTS FACTS		*
	*				*/

	
CREATE TYPE person_partic AS (	cd_pessoa_fisica	pessoa_fisica.cd_pessoa_fisica%type,
					ie_sexo			pessoa_fisica.ie_sexo%type,
					nr_seq_participante	mprev_participante.nr_sequencia%type,
					dt_nascimento		pessoa_fisica.dt_nascimento%type,
					nr_seq_patient_group	bigint,
					si_beneficiary		varchar(1));
CREATE TYPE partic_data AS (	nr_seq_partic_det	bigint,
					si_beneficiary		varchar(1),
					dt_reference		timestamp,
					cd_pessoa_fisica	pessoa_fisica.cd_pessoa_fisica%type,
					ie_sexo			pessoa_fisica.ie_sexo%type,
					nr_seq_participante	mprev_participante.nr_sequencia%type,
					dt_nascimento		pessoa_fisica.dt_nascimento%type,
					nr_seq_patient_group	bigint);


CREATE OR REPLACE PROCEDURE hdm_indic_pck.populate_ft_participant () AS $body$
DECLARE

	i			bigint	:= 1;
	j			bigint	:= 1;
	k			bigint	:= 1;
	nr_seq_patient_group_w	bigint	:= null;
	type vector_person is table of person_partic index by integer;
	
	vector_person_w			vector_person;
	type vector_partic_data is table of partic_data index by integer;
	
	vector_partic_data_w		vector_partic_data;
	
	c_persons CURSOR(dt_start_pc timestamp, dt_end_pc timestamp) FOR
		SELECT	/*+ USE_CONCAT */
			distinct
			/*+ USE_CONCAT */

			pf.cd_pessoa_fisica,
			pf.ie_sexo,
			pt.nr_sequencia nr_seq_participante,
			pf.dt_nascimento,
			(SELECT	CASE WHEN count(1)=0 THEN 'N'  ELSE 'S' END
			 from	pls_segurado ps
			 where	ps.dt_liberacao <= pr.dt_inclusao 
			 and (ps.dt_rescisao > pr.dt_inclusao or coalesce(ps.dt_rescisao::text, '') = '') 
			 and	pf.cd_pessoa_fisica = ps.cd_pessoa_fisica) si_beneficiary
		FROM mprev_programa_partic pr, pessoa_fisica pf
LEFT OUTER JOIN mprev_participante pt ON (pf.cd_pessoa_fisica = pt.cd_pessoa_fisica)
WHERE pr.dt_inclusao between dt_start_pc and dt_end_pc and pr.nr_seq_participante = pt.nr_sequencia;
		
	c_partic_data CURSOR(dt_start_pc timestamp, dt_end_pc timestamp, cd_pessoa_fisica_pc text) FOR
		SELECT	coalesce(pt.ie_status,'0') si_status,
			coalesce(pt.ie_situacao,'0') si_situation,
			pr.dt_inclusao dt_reference
		FROM mprev_programa_partic pr, pessoa_fisica pf
LEFT OUTER JOIN mprev_participante pt ON (pf.cd_pessoa_fisica = pt.cd_pessoa_fisica)
WHERE pr.dt_inclusao between dt_start_pc and dt_end_pc and pr.nr_seq_participante = pt.nr_sequencia  and pf.cd_pessoa_fisica = cd_pessoa_fisica_pc;
	
BEGIN		
		-- Generate person vector 

		i	:= 1;
		for r_c_persons in c_persons(current_setting('hdm_indic_pck.dt_start_w')::timestamp, current_setting('hdm_indic_pck.dt_end_w')::timestamp) loop
			nr_seq_patient_group_w	:= hdm_indic_pck.get_patient_group(	r_c_persons.cd_pessoa_fisica,
									r_c_persons.nr_seq_participante,
									r_c_persons.dt_nascimento,
									r_c_persons.ie_sexo);
									
			vector_person_w[i].cd_pessoa_fisica 		:= r_c_persons.cd_pessoa_fisica;
			vector_person_w[i].nr_seq_participante 		:= r_c_persons.nr_seq_participante;
			vector_person_w[i].dt_nascimento 		:= r_c_persons.dt_nascimento;
			vector_person_w[i].ie_sexo 			:= r_c_persons.ie_sexo;
			vector_person_w[i].si_beneficiary		:= r_c_persons.si_beneficiary;
			vector_person_w[i].nr_seq_patient_group 	:= nr_seq_patient_group_w;
			i	:= i + 1;
		end loop;

		-- Open person vector 

		j	:= 1;
		i := vector_person_w.count;
		for k in 1.. i loop
			for r_c_partic_data in c_partic_data(	current_setting('hdm_indic_pck.dt_start_w')::timestamp,
								current_setting('hdm_indic_pck.dt_end_w')::timestamp,
								vector_person_w[k].cd_pessoa_fisica) loop							
				vector_partic_data_w[j].nr_seq_participante 	:= vector_person_w[k].nr_seq_participante;
				vector_partic_data_w[j].cd_pessoa_fisica	:= vector_person_w[k].cd_pessoa_fisica;
				vector_partic_data_w[j].dt_nascimento 		:= vector_person_w[k].dt_nascimento;
				vector_partic_data_w[j].ie_sexo 		:= vector_person_w[k].ie_sexo;
				vector_partic_data_w[j].si_beneficiary		:= vector_person_w[k].si_beneficiary;
				vector_partic_data_w[j].nr_seq_patient_group 	:= vector_person_w[k].nr_seq_patient_group;	
		
				vector_partic_data_w[j].nr_seq_partic_det	:= hdm_indic_pck.get_partic_det(r_c_partic_data.si_status, r_c_partic_data.si_situation);
				vector_partic_data_w[j].dt_reference		:= r_c_partic_data.dt_reference;
				j	:= j + 1;
			end loop;
		end loop;

		-- Open partic data vector 

		PERFORM set_config('hdm_indic_pck.qt_record_w', 0, false);
		i := vector_partic_data_w.count;
		for k in 1.. i loop
			insert into hdm_indic_ft_partic(	nr_sequencia,
					dt_atualizacao, 
					nm_usuario, 
					dt_atualizacao_nrec, 
					nm_usuario_nrec, 
					nr_seq_partic_det, 
					nr_seq_month, 
					nr_seq_patient_group, 
					ds_unique,
					nr_dif_person,
					si_beneficiary)
			SELECT	nextval('hdm_indic_ft_partic_seq'),
				clock_timestamp(),
				current_setting('hdm_indic_pck.nm_usuario_w')::usuario.nm_usuario%type,
				clock_timestamp(),
				current_setting('hdm_indic_pck.nm_usuario_w')::usuario.nm_usuario%type,
				vector_partic_data_w[k].nr_seq_partic_det,
				(	SELECT	x.nr_sequencia                    
					from	hdm_indic_dm_month x              
					where	x.dt_complete_date = pkg_date_utils.start_of(vector_partic_data_w[k].dt_reference,'MONTH', 0)) nr_seq_month,
				vector_partic_data_w[k].nr_seq_patient_group,
				current_setting('hdm_indic_pck.ds_unique_w')::varchar(255),
				vector_partic_data_w[k].cd_pessoa_fisica,
				vector_partic_data_w[k].si_beneficiary
			;
			
			if (current_setting('hdm_indic_pck.qt_record_w')::integer >= current_setting('hdm_indic_pck.qt_rec_commit_w')::integer) then
				commit;
				PERFORM set_config('hdm_indic_pck.qt_record_w', 0, false);
			end if;
			PERFORM set_config('hdm_indic_pck.qt_record_w', current_setting('hdm_indic_pck.qt_record_w')::integer + 1, false);
		end loop;
		
		commit;

		CALL hdm_indic_pck.link_campaign_with_pt_fact();
		CALL hdm_indic_pck.link_activ_group_with_pt_fact();
		CALL hdm_indic_pck.link_program_with_pt_fact();
		CALL hdm_indic_pck.link_risk_disease_with_pt_fact();
		
		CALL hdm_indic_pck.link_professional_with_pt_fact();
		CALL hdm_indic_pck.link_search_rule_with_pt_fact();
	END;

$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE hdm_indic_pck.populate_ft_participant () FROM PUBLIC;
