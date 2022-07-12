-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';




CREATE OR REPLACE PROCEDURE nais_mla_pathology_pck.send_pathology_data (( nr_seq_interno_p bigint, file_output_p out text )as cd_departamento_w atend_paciente_unidade.cd_departamento%type) AS $body$
DECLARE

        PERFORM '01'      process_classif, -- Mandatory (2)
				order_class_w    order_class,               -- Mandatory (2)
				coalesce(cu.nr_order_patient_seq, 0)     order_number,              -- Mandatory (8)
                coalesce(obter_prontuario_paciente(obter_dados_prescricao(a.nr_prescricao , 'P' )), 0)        patient_identifier,        -- Mandatory (10)
				coalesce(to_char(a.dt_inicio, 'YYYYMMDD'),' ') consultation_date,-- Mandatory (8)
                 case when (cu.cd_especialidade_med IS NOT NULL AND cu.cd_especialidade_med::text <> '') then
                         coalesce(nais_mla_pathology_pck.get_affairs_code('OS', 'ESPECIALIDADE_MEDICA', 'CD_ESPECIALIDADE', cu.cd_especialidade_med), ' ') 
                    when (cu.cd_departamento_med IS NOT NULL AND cu.cd_departamento_med::text <> '') then 
                        coalesce(nais_mla_pathology_pck.get_affairs_code('OS', 'DEPARTAMENTO_MEDICO', 'CD_DEPARTAMENTO', cu.CD_DEPARTAMENTO_MED), ' ')   
                    else '00'
                    end as department_code, -- Mandatory (2)
				CASE WHEN get_patient_type(b.encounter_id, NULL)='IN' THEN  2 WHEN get_patient_type(b.encounter_id, NULL)='OP' THEN  1 END  					patient_classification,
				CASE WHEN get_patient_type(b.encounter_id, NULL)='IN' THEN  coalesce(b.bed_id,'0') WHEN get_patient_type(b.encounter_id, NULL)='OP' THEN  ' ' END  	ward_code,
				CASE WHEN get_patient_type(b.encounter_id, NULL)='IN' THEN  coalesce(b.room_id,'0') WHEN get_patient_type(b.encounter_id, NULL)='OP' THEN  ' ' END  room_code,
				'1' blood_tranfusion_type,     -- Mandatory (1)
				coalesce(nais_mla_pathology_pck.get_insurance_number(cu.nr_seq_nais_insurance),00)  insurance_number  ,        -- Mandatory (2)            
				coalesce(p.cd_medico,' ')  doctor_code,             -- Mandatory (8)
				' ' patient_newborn,           -- Not Used  (1)
				' ' prescription_classfication,-- Not Used  (1)
				' ' requestor_code,            -- Optional  (3)   
				' ' mutual_exclusion_rule,     -- Not Used  (1)
				' ' division_number,           -- Mandatory (4)
				' ' blank_one,                 -- ALL SPACE (1)
				' ' blank_two                   -- ALL SPACE (1)
        from    cpoe_anatomia_patologica  cp,
				prescr_procedimento a,
				proc_interno c,
				procedimento d , 
				prescr_medica p ,           
				bft_encounter_v b,
				cpoe_order_unit cu
           
        where  cp.nr_sequencia = a.nr_seq_proc_cpoe
        and    c.nr_sequencia = a.nr_seq_proc_interno
        and    c.cd_procedimento = d.cd_procedimento  
        and    c.ie_origem_proced = d.ie_origem_proced 
        and    a.nr_prescricao=p.nr_prescricao 
        and    p.nr_atendimento= b.encounter_id 
        and    cp.nr_seq_cpoe_order_unit = cu.nr_sequencia
        and    a.nr_seq_interno= nr_seq_interno_p;
    --  End of Accounting Information
        c02 CURSOR FOR
			SELECT
					' ' execution_classification,   -- Not Used  (1)
					to_char(a.dt_inicio, 'YYYYMMDD') execution_date,             -- Mandatory (8 - Get Only Date) 
					to_char(a.dt_inicio, 'HH24MI') execution_time,            -- Optional  (4 - Get time in HHMM)
					'   ' execution_op_code,          -- Not Used  (3)
					' ' execution_up_flag,          -- Not Used  (1)
					'000000' execution_weight,           -- Not Used  (6)
					' ' out_of_hours_flag,          -- Optional  (1)
					' ' execution_blank              -- ALL SPACE (8)
			from    cpoe_anatomia_patologica  cp,
					prescr_procedimento a,
					proc_interno c,
					procedimento d,
					cpoe_order_unit cu		

			where   cp.nr_sequencia = a.nr_seq_proc_cpoe
			and     c.nr_sequencia = a.nr_seq_proc_interno
			and     c.cd_procedimento = d.cd_procedimento
			and     c.ie_origem_proced = d.ie_origem_proced 
			and     cp.nr_seq_cpoe_order_unit = cu.nr_sequencia		
			and     a.nr_seq_interno= nr_seq_interno_p;
    -- End of Execution Information
     c03 CURSOR FOR
			SELECT
					count(*) over () count_medi_details,
					'   ' slip_code,
					'01' nr_data_class,					
				    nais_mla_pathology_pck.get_affairs_code('P', 'PROC_INTERNO', 'NR_SEQUENCIA',c.nr_seq_proc_interno) internal_code,					
                    (coalesce(count_orgaos_w, 0))::numeric   * 1000 dosage,
					' ' unit,
					1 times_num,
					0 free_input_flag,
					' ' free_comments,
					' ' med_change_impossible_flg,
					' ' general_name_med_flg,
					0 days,
					0 times_num_04,
					0 days_num,
					1 digit_times_num,
					1 digit_days_num,
					' ' medi_blank,
					' ' eot
				from
						cpoe_anatomia_patologica  cp,                 
						prescr_procedimento   c,
						proc_interno a,
						cpoe_order_unit cu	
				where   cp.nr_sequencia           = c.nr_seq_proc_cpoe
				and     a.nr_sequencia            = c.nr_seq_proc_interno
				and     cp.nr_seq_cpoe_order_unit = cu.nr_sequencia		
				and     c.nr_seq_interno          = nr_seq_interno_p 

	    
union all


		SELECT distinct
				count(*) over () count_medi_details,
				'000' slip_code,
				'01' nr_data_class,
				nais_mla_pathology_pck.get_affairs_code('P', 'TIPO_ORGAO', 'NR_SEQUENCIA',torg.nr_sequencia) internal_code,							
				(coalesce(1, 0))::numeric  * 1000 dosage,
				' ' unit,
				1 times_num,
				0 free_input_flag,
				' ' free_comments,
				' ' med_change_impossible_flg,
				' ' general_name_med_flg,
				0 days,
				0 times_num_04,
				0 days_num,
				1 digit_times_num,
				1 digit_days_num,
				' ' medi_blank,
				' ' eot
        from    tipo_orgao torg,              
                tipo_org_topografia top
        where   top.nr_seq_orgao = torg.nr_sequencia 
        and     top.nr_seq_topografia in (
                    select  cp.cd_topografia
                    from 	cpoe_anatomia_patologica c ,
                            cpoe_prescr_proc_peca cp,
                            prescr_procedimento  pp			
                    where  c.nr_sequencia = cp.nr_seq_cpoe_proc  
                    and    c.nr_sequencia = pp.nr_seq_proc_cpoe
                    and    pp.nr_seq_interno = nr_seq_interno_p);

                    
        c05 CURSOR FOR        
             SELECT
                distinct(g.nr_sequencia),
                substr(obter_conversao_externa_int(null,'CPOE_STD_COMMENT','CD_EXTERNAL', coalesce(h.cd_external,' '), current_setting('nais_mla_pathology_pck.nm_usuario_w')::varchar(20) ),1,6)
				from  
						cpoe_anatomia_patologica  cp,                 
						prescr_procedimento   c,
						proc_interno a,
						cpoe_order_unit cu	,
                        cpoe_comment_linkage    g,
                        cpoe_std_comment    h
				where   cp.nr_sequencia           = c.nr_seq_proc_cpoe
				and     a.nr_sequencia            = c.nr_seq_proc_interno
				and     cp.nr_seq_cpoe_order_unit = cu.nr_sequencia	
                and    cu.nr_sequencia = g.nr_seq_cpoe_order_unit
                and     g.nr_seq_std_comment = h.nr_sequencia
                and     h.si_medical_account = 'Y'
                and     (h.cd_external IS NOT NULL AND h.cd_external::text <> '')
				and     c.nr_seq_interno          = nr_seq_interno_p;


    -- End of Medical treatment details
        r_c03                 c03%rowtype;

        r_c01_w               accinforectyp;
        r_c02_w               execinforedtyp;
        r_c03_w               medtreatmentinforedtyp;
        cd_contin_flag_w      varchar(1) := 'C';
        loop_count_w          smallint := 0;
        inside_loop_count_w   smallint := 1;
        shruthi_count_w   smallint := 0;
        counter_w               smallint := 0;
        pathology_route_w			 nais_conversion_master%rowtype;
        json_output_w		    philips_json;
        json_output_list_w  philips_json_list;
        r_acct nais_conversion_master%rowtype;
        cd_external_w                cpoe_std_comment.cd_external%type;
        nr_linkage_sequencia_w       cpoe_comment_linkage.nr_sequencia%type;


BEGIN

    begin
        select  c.nr_seq_status_pato,
				c.nr_prescricao,
				c.nr_seq_proc_cpoe              
        into STRICT    nr_seq_status_pato_w,
                nr_prescricao_w , 
                nr_seq_proc_cpoe_w             
        from    prescr_procedimento c
        where   c.nr_seq_interno = nr_seq_interno_p;
        exception
		when no_data_found then
		       nr_seq_status_pato_w := null;
               nr_prescricao_w  := null;
               nr_seq_proc_cpoe_w  := null;
		end;

        begin
			select  c.nr_atendimento,
            c.nm_usuario
			into STRICT    nr_atendiment_w,
            current_setting('nais_mla_pathology_pck.nm_usuario_w')::varchar(20)
			from    prescr_procedimento a,
					cpoe_anatomia_patologica c
			where   a.nr_seq_proc_cpoe = c.nr_sequencia
			and     a.nr_seq_interno = nr_seq_interno_p;
        exception
		when   no_data_found then
		       nr_atendiment_w := null;
		end;

        begin
			select  ie_status_patologia
			into STRICT     ie_status_patologia_w
			from     proced_patologia_status
			where    nr_sequencia = nr_seq_status_pato_w;
        exception
		when  no_data_found then
		      ie_status_patologia_w:= null;

		end;


        begin
			select count(*) count_orgaos
			into STRICT    count_orgaos_w
			from 	cpoe_anatomia_patologica c ,
					cpoe_prescr_proc_peca cp,
					prescr_procedimento  p
			where   c.nr_sequencia=cp.nr_seq_cpoe_proc
			and     c.nr_sequencia = p.nr_seq_proc_cpoe 
			and     nr_prescricao = nr_prescricao_w
			and     p.nr_seq_interno = nr_seq_interno_p;
            exception
			when   no_data_found then
				   count_orgaos_w:= null;				
			end;

        if (ie_status_patologia_w = 'PA') then   
			PERFORM set_config('nais_mla_pathology_pck.ds_line_w', null, false);
			counter_w := 0;
			inside_loop_count_w :=0;
			PERFORM set_config('nais_mla_pathology_pck.index_counter_w', 0, false);
			loop_count_w := 0;
			json_output_w   := philips_json();
			json_output_list_w	:= philips_json_list();

        open c03;
			loop
				fetch c03 into r_c03_w;
				EXIT WHEN NOT FOUND; /* apply on c03 */
			    if  c03%rowcount = 1 then
					current_setting('nais_mla_pathology_pck.ds_line_w')::varchar(32767) := nais_mla_pathology_pck.get_action_code_med_detail(order_class_w, r_c03_w, current_setting('nais_mla_pathology_pck.ds_line_w')::varchar(32767));
					CALL CALL CALL CALL nais_mla_pathology_pck.add_med_treatment_detail_array(current_setting('nais_mla_pathology_pck.ds_line_w')::varchar(32767), current_setting('nais_mla_pathology_pck.index_counter_w')::smallint);			
				end if;
					CALL CALL CALL CALL nais_mla_pathology_pck.common_med_treatment_info(r_c03_w);
					CALL CALL CALL CALL nais_mla_pathology_pck.add_med_treatment_detail_array(current_setting('nais_mla_pathology_pck.ds_line_w')::varchar(32767), current_setting('nais_mla_pathology_pck.index_counter_w')::smallint);				
			    end loop;
       begin
                open c05;
                loop
                fetch c05 into
                    nr_linkage_sequencia_w,
                    cd_external_w;
                    EXIT WHEN NOT FOUND; /* apply on c05 */
                        CALL CALL nais_mla_pathology_pck.process_receipt_comments(r_c03_w, cd_external_w, nr_linkage_sequencia_w);
                end loop;
                close c05;
            exception
            when others then
                PERFORM set_config('nais_mla_pathology_pck.ds_error_w', current_setting('nais_mla_pathology_pck.ds_error_w')::varchar(2000)||' An error occured while forming the Medical treatment information for comments and additional text '||sqlerrm, false);
            end;

                    current_setting('nais_mla_pathology_pck.ds_line_w')::varchar(32767) := nais_mla_pathology_pck.add_date_class_med_detail('L5', r_c03_w, current_setting('nais_mla_pathology_pck.ds_line_w')::varchar(32767));
                    CALL CALL CALL CALL nais_mla_pathology_pck.add_med_treatment_detail_array(current_setting('nais_mla_pathology_pck.ds_line_w')::varchar(32767), current_setting('nais_mla_pathology_pck.index_counter_w')::smallint);
        close c03;

        loop_count_w := ceil(current_setting('nais_mla_pathology_pck.index_counter_w')::smallint / 10);
        for i in 1..loop_count_w loop begin
            if ( i = loop_count_w ) then
                cd_contin_flag_w := 'E';
            end if;
            CALL CALL CALL CALL CALL CALL CALL nais_mla_pathology_pck.nais_common_header('KK', nr_seq_interno_p, '01', cd_contin_flag_w, 1,
                               810,current_setting('nais_mla_pathology_pck.nm_usuario_w')::varchar(20));
         begin
              open c01;
                    loop

                        fetch c01 into r_c01_w;
                       EXIT WHEN NOT FOUND; /* apply on c01 */
                        CALL CALL CALL CALL CALL nais_mla_pathology_pck.common_accounting_info(r_c01_w);
                    end loop;
                    close c01;
                     exception
            when others then
                PERFORM set_config('nais_mla_pathology_pck.ds_error_w', current_setting('nais_mla_pathology_pck.ds_error_w')::varchar(2000)||' An error occured while forming the Common Accounting information for '||nr_seq_interno_p||' '||sqlerrm, false);
            end;


begin
       open c02;
            loop
                fetch c02 into r_c02_w;
                EXIT WHEN NOT FOUND; /* apply on c02 */
                CALL CALL CALL CALL CALL nais_mla_pathology_pck.common_execution_info(r_c02_w);
            end loop;

            close c02;
     exception
            when others then
                PERFORM set_config('nais_mla_pathology_pck.ds_error_w', current_setting('nais_mla_pathology_pck.ds_error_w')::varchar(2000)||' An error occured while forming the Common execution information for '||nr_seq_interno_p||' '||sqlerrm, false);
            end;

          
          
          open c03;
            fetch c03 into r_c03;
            select sum(r_c03.count_medi_details)
            into STRICT  shruthi_count_w
;
            RAISE NOTICE 'shruthi_count_w%', shruthi_count_w;
            CALL CALL CALL CALL CALL CALL CALL CALL CALL CALL nais_mla_pathology_pck.append_text(r_c03.slip_code, 3, 'L');
            close c03;

            PERFORM set_config('nais_mla_pathology_pck.med_treatment_count_w', mod(current_setting('nais_mla_pathology_pck.index_counter_w')::smallint,10), false);
            if (cd_contin_flag_w = 'C' or (cd_contin_flag_w = 'E' and current_setting('nais_mla_pathology_pck.med_treatment_count_w')::smallint = 0)) then
                CALL CALL CALL CALL CALL CALL CALL CALL CALL CALL nais_mla_pathology_pck.append_text(10, 2, 'L', '0');
            else
                CALL CALL CALL CALL CALL CALL CALL CALL CALL CALL nais_mla_pathology_pck.append_text(current_setting('nais_mla_pathology_pck.med_treatment_count_w')::smallint, 2, 'L', '0');
            end if;
            inside_loop_count_w := counter_w + 1;

            for x in inside_loop_count_w..inside_loop_count_w + 9 loop
                counter_w := counter_w + 1;
                current_setting('nais_mla_pathology_pck.med_treamtent')::med_treamtent_array.extend;

                if ( cd_contin_flag_w = 'E' and current_setting('nais_mla_pathology_pck.med_treamtent')::coalesce(med_treamtent_array(x)::text, '') = '' ) then
                    CALL CALL CALL CALL CALL CALL CALL CALL CALL CALL nais_mla_pathology_pck.append_text(' ', 64);
                else
                    CALL CALL CALL CALL CALL CALL CALL CALL CALL CALL nais_mla_pathology_pck.append_text(current_setting('nais_mla_pathology_pck.med_treamtent')::med_treamtent_array(x), 64, 'L', ' ');
                end if;

            end loop;

            open c03;
            fetch c03 into r_c03;
            CALL CALL CALL CALL CALL CALL CALL CALL CALL CALL nais_mla_pathology_pck.append_text(r_c03.medi_blank, 4, 'R', ' ');
            CALL CALL CALL CALL CALL CALL CALL CALL CALL CALL nais_mla_pathology_pck.append_text(r_c03.eot, 1, 'L');
            close c03;
            json_output_w := nais_mla_pathology_pck.add_json_value(json_output_w, 'message', current_setting('nais_mla_pathology_pck.ds_line_w')::varchar(32767));
            json_output_list_w.append(json_output_w.to_json_value());
        end;
        end loop;
        dbms_lob.createtemporary( file_output_p, true);
        json_output_list_w.(file_output_p);

        open c03;
			loop
			fetch c03 into r_c03_w;
			EXIT WHEN NOT FOUND; /* apply on c03 */

			update prescr_procedimento
			set dt_integracao = clock_timestamp()
			where nr_prescricao=nr_prescricao_w
			and nr_seq_interno =nr_seq_interno_p;
			commit;
			end loop;
		close c03;		
    end if;
   if current_setting('nais_mla_pathology_pck.ds_error_w')::(varchar(2000) IS NOT NULL AND (varchar(2000))::text <> '') then
               if length(current_setting('nais_mla_pathology_pck.ds_error_w')::varchar(2000)) < 500 then
                            record_integration_call_log(wheb_usuario_pck.get_nm_usuario, 'NAIS', clock_timestamp(), 'nais.pathology.info', 'nais.pathology.info' ,
                                        'E', 'E', null, 'KK', null,current_setting('nais_mla_pathology_pck.ds_error_w')::varchar(2000), 0,current_setting('nais_mla_pathology_pck.nr_seq_int_call_log_w')::integration_message_log.nr_seq_int_call_log%type, nr_prescricao_w, 944,'E');
                            else
                            record_integration_call_log(wheb_usuario_pck.get_nm_usuario, 'NAIS', clock_timestamp(),'nais.pathology.info', 'nais.pathology.info' , 
                                        'E', 'E', null, 'KK', null,substr(current_setting('nais_mla_pathology_pck.ds_error_w')::varchar(2000),1,499), 0,current_setting('nais_mla_pathology_pck.nr_seq_int_call_log_w')::integration_message_log.nr_seq_int_call_log%type, nr_prescricao_w, 944,'E');
                            end if;
        end if;

   END;

$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE nais_mla_pathology_pck.send_pathology_data (( nr_seq_interno_p bigint, file_output_p out text )as cd_departamento_w atend_paciente_unidade.cd_departamento%type) FROM PUBLIC;