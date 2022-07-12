-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';

	
	/*			*
	*	COSTS FACTS	*
	*			*/

	
CREATE TYPE cost_data AS (	nr_seq_cost_range	bigint,
					nr_seq_cost_type	bigint,
					vl_cost			hdm_indic_ft_cost.vl_cost%type,
					pr_risk			hdm_indic_ft_cost.pr_risk%type,
					dt_reference		timestamp,
					cd_pessoa_fisica	pessoa_fisica.cd_pessoa_fisica%type,
					ie_sexo			pessoa_fisica.ie_sexo%type,
					nr_seq_participante	mprev_participante.nr_sequencia%type,
					dt_nascimento		pessoa_fisica.dt_nascimento%type,
					nr_seq_patient_group	bigint);


CREATE OR REPLACE PROCEDURE hdm_indic_pck.populate_ft_red_cost () AS $body$
DECLARE

	i			bigint	:= 1;
	j			bigint	:= 1;
	k			bigint	:= 1;
	nr_seq_patient_group_w	bigint	:= null;
	
	vector_person_w			vector_person;
	type vector_cost_data is table of cost_data index by integer;
	
	vector_cost_data_w		vector_cost_data;
	
	c_persons CURSOR(dt_start_pc timestamp, dt_end_pc timestamp) FOR
		SELECT	/*+ USE_CONCAT */
			distinct
			/*+ USE_CONCAT */

			pf.cd_pessoa_fisica,
			pf.ie_sexo,
			pt.nr_sequencia nr_seq_participante,
			pf.dt_nascimento
		FROM pls_ar_dados_v pv, pls_segurado ps, pessoa_fisica pf
LEFT OUTER JOIN mprev_participante pt ON (pf.cd_pessoa_fisica = pt.cd_pessoa_fisica)
WHERE pv.dt_mes_competencia between dt_start_pc and dt_end_pc and ps.nr_sequencia = pv.nr_seq_segurado and ps.cd_pessoa_fisica = pf.cd_pessoa_fisica;
		
	c_cost_data CURSOR(dt_start_pc timestamp, dt_end_pc timestamp, cd_pessoa_fisica_pc text) FOR
		SELECT	coalesce(pv.vl_assist,0) vl_cost,
			coalesce(pv.pr_sinistralidade,0) pr_risk,
			pv.dt_mes_competencia dt_reference,
			ps.nr_sequencia nr_seq_segurado
		from	pls_segurado ps,
			(	SELECT	round((pr_sinistralidade)::numeric,2) pr_sinistralidade,
					nr_seq_segurado,
					vl_assist,
					dt_mes_competencia
				from (	select (vl_assist / vl_receitas) * 100 pr_sinistralidade,
							nr_seq_segurado,
							vl_assist,
							dt_mes_competencia
						from (	select  sum(coalesce(vl_mensalidade,0)) + sum(coalesce(vl_faturado,0)) + sum(coalesce(vl_taxa,0)) vl_receitas,
									sum(coalesce(vl_conta,0)) + sum(coalesce(vl_ressarcir,0)) + sum(coalesce(vl_recurso,0)) vl_assist,
									a.nr_seq_segurado nr_seq_segurado,
									a.dt_mes_competencia
								from    pls_ar_dados_v a
								group by a.nr_seq_segurado,
									 a.dt_mes_competencia
							) alias18
						where	vl_assist > 0 and vl_receitas > 0 
					) alias19
				where	pr_sinistralidade > 0) pv
		where	pv.dt_mes_competencia between dt_start_pc and dt_end_pc
		and	ps.nr_sequencia = pv.nr_seq_segurado   
		and	ps.cd_pessoa_fisica = cd_pessoa_fisica_pc;
		
	
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
			for	r_c_cost_data in c_cost_data(	current_setting('hdm_indic_pck.dt_start_w')::timestamp,
								current_setting('hdm_indic_pck.dt_end_w')::timestamp,
								vector_person_w[k].cd_pessoa_fisica) loop
				
				vector_cost_data_w[j].cd_pessoa_fisica 		:= vector_person_w[k].cd_pessoa_fisica;
				vector_cost_data_w[j].nr_seq_participante 	:= vector_person_w[k].nr_seq_participante;
				vector_cost_data_w[j].dt_nascimento 		:= vector_person_w[k].dt_nascimento;
				vector_cost_data_w[j].ie_sexo 			:= vector_person_w[k].ie_sexo;
				vector_cost_data_w[j].nr_seq_patient_group 	:= vector_person_w[k].nr_seq_patient_group;	

				vector_cost_data_w[j].dt_reference		:= r_c_cost_data.dt_reference;
				vector_cost_data_w[j].nr_seq_cost_range		:= hdm_indic_pck.get_cost_range(r_c_cost_data.pr_risk);
				vector_cost_data_w[j].nr_seq_cost_type		:= hdm_indic_pck.get_cost_type(r_c_cost_data.nr_seq_segurado);
				vector_cost_data_w[j].vl_cost		        := r_c_cost_data.vl_cost;
				vector_cost_data_w[j].pr_risk		        := r_c_cost_data.pr_risk;
						
				j	:= j + 1;
			end loop;
		end loop;

		-- Open costs data vector 

		PERFORM set_config('hdm_indic_pck.qt_record_w', 0, false);
		i := vector_cost_data_w.count;
		
		for k in 1.. i loop
			insert into hdm_indic_ft_cost(	nr_sequencia,
					dt_atualizacao, 
					nm_usuario, 
					dt_atualizacao_nrec, 
					nm_usuario_nrec, 
					nr_seq_cost_range, 
					nr_seq_month, 
					nr_seq_patient_group, 
					vl_cost, 
					pr_risk, 
					nr_dif_person, 
					nr_seq_cost_type,
					ds_unique)
			SELECT	nextval('hdm_indic_ft_cost_seq'),
				clock_timestamp(),
				current_setting('hdm_indic_pck.nm_usuario_w')::usuario.nm_usuario%type,
				clock_timestamp(),
				current_setting('hdm_indic_pck.nm_usuario_w')::usuario.nm_usuario%type,
				vector_cost_data_w[k].nr_seq_cost_range,
				(	
					SELECT	x.nr_sequencia
					from	hdm_indic_dm_month x
					where	x.dt_complete_date = pkg_date_utils.start_of(vector_cost_data_w[k].dt_reference, 'MONTH', 0)
				) nr_seq_month,
				vector_cost_data_w[k].nr_seq_patient_group,
				vector_cost_data_w[k].vl_cost,
				vector_cost_data_w[k].pr_risk,
				vector_cost_data_w[k].cd_pessoa_fisica,
				vector_cost_data_w[k].nr_seq_cost_type,
				current_setting('hdm_indic_pck.ds_unique_w')::varchar(255)
			;
				
			if (current_setting('hdm_indic_pck.qt_record_w')::integer >= current_setting('hdm_indic_pck.qt_rec_commit_w')::integer) then
				commit;
				PERFORM set_config('hdm_indic_pck.qt_record_w', 0, false);
			end if;
			PERFORM set_config('hdm_indic_pck.qt_record_w', current_setting('hdm_indic_pck.qt_record_w')::integer + 1, false);
		end loop;
		
		commit;
		
		CALL hdm_indic_pck.link_campaign_with_co_fact();
		CALL hdm_indic_pck.link_activ_group_with_co_fact();
		CALL hdm_indic_pck.link_program_with_co_fact();
		
		CALL hdm_indic_pck.link_cont_group_whit_co_fact();
		
	END;

$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE hdm_indic_pck.populate_ft_red_cost () FROM PUBLIC;