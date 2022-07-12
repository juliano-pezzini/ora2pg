-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';




CREATE OR REPLACE PROCEDURE nais_mla_prescription.unexecutedorder_prescription ( nr_prescricao_p bigint, processing_classication_p text, ds_file_output_p INOUT text ) AS $body$
DECLARE

	nm_usuario_w     varchar(10);
    cd_department_w  varchar(10);
    ds_file_output_p_h1_w           text;
    ds_file_output_p_h2_w           text;
    ds_file_output_p_h3_w           text;
    ds_file_output_p_h4_w           text;
    ds_file_output_p_h5_w           text;
    h1_count_w                     bigint;
    h3_count_w                     bigint;
    hj_count_w                     bigint;
    h8_count_w                     bigint;
    h0_count_w                     bigint;
    ds_file_output_p_final_w        text;
    c_order_unit_w                  varchar(100);
    json_output_w                   philips_json;
    message_count_w                 bigint := 0;
    diff_w                          bigint :=1;
    current_setting('nais_mla_prescription.json_output_list_w')::philips_json_list              philips_json_list;
    l_len_w                         bigint;
    initial_value_w                 bigint;
    val_w                           varchar(10000);
    type_of_prescription_w          varchar(10);
    ward_code_w      nais_conversion_master%rowtype;

        c04 CURSOR FOR                
                SELECT         
                distinct a.nr_order_unit order_unit,
                         a.si_type_of_prescription si_type_prescription
                from    prescr_material   p,
                        cpoe_material     c,
                        bft_encounter_v   b,
                        cpoe_order_unit   a,
                        cpoe_tipo_pedido  cp,	
                        cpoe_rp           d
                where   p.nr_prescricao                 = nr_prescricao_p
                        and b.encounter_id              = c.nr_atendimento
                        and p.nr_seq_mat_cpoe           = c.nr_sequencia
                        and a.nr_seq_cpoe_tipo_pedido   = cp.nr_sequencia
                        and c.nr_seq_cpoe_order_unit    = a.nr_sequencia
                        and  d.nr_sequencia             = c.nr_seq_cpoe_rp;
        r4_count C04%rowtype;

                 
BEGIN
        json_output_w       := philips_json();
        PERFORM set_config('nais_mla_prescription.json_output_list_w', philips_json_list(), false);

	select      COUNT(CASE a.si_type_of_prescription  WHEN 'INPR'  THEN 1 END)+
			    COUNT(CASE a.si_type_of_prescription  WHEN 'INPT'  THEN 1 END)+
			    COUNT(CASE a.si_type_of_prescription  WHEN 'INPI'  THEN 1 END)+
			    COUNT(CASE a.si_type_of_prescription  WHEN 'INPAT' THEN 1 END),
			    COUNT(CASE a.si_type_of_prescription  WHEN 'INPDP' THEN 1 END),
			    COUNT(CASE a.si_type_of_prescription  WHEN 'BRME'  THEN 1 END),
			    COUNT(CASE a.si_type_of_prescription  WHEN 'OPIHO'  THEN 1 END),
			    COUNT(CASE a.si_type_of_prescription  WHEN 'OPOOH'  THEN 1 END)
	into STRICT        h1_count_w,
				h3_count_w,
				hj_count_w,
				h8_count_w,
				h0_count_w
    from        prescr_material     p,
                cpoe_material       c,
                bft_encounter_v     b,
                cpoe_order_unit     a,
                cpoe_tipo_pedido    cp,	
                cpoe_rp             d
    where       p.nr_prescricao                 = nr_prescricao_p
    and         b.encounter_id              = c.nr_atendimento
	and 		p.nr_seq_mat_cpoe           = c.nr_sequencia
	and 		a.nr_seq_cpoe_tipo_pedido   = cp.nr_sequencia
	and 		c.nr_seq_cpoe_order_unit    = a.nr_sequencia
	and 		d.nr_sequencia             = c.nr_seq_cpoe_rp
	and 		a.si_type_of_prescription in ('INPR','INPT','INPI','INPAT','INPDP','BRME','OPIHO','OPOOH')
	and 		cp.nr_seq_sub_grp            = 'ME'
				and (case 
                          when(processing_classication_p = 'unexecutedOrderMessageCancelPrescription') and  p.ie_suspenso ='S' THEN (1)
                          when(processing_classication_p = 'unexecutedOrderMessageRequestPrescription') and  p.ie_suspenso ='N' THEN (1)
                          else 0
                     end) = 1;
                     
      
                
            if h1_count_w >  0 then 
                open c04;
                    loop
                        fetch c04 into r4_count;
                            EXIT WHEN NOT FOUND; /* apply on c04 */

                            if (r4_count.si_type_prescription  in ('INPR','INPT','INPI','INPAT')) then 
                             
                                ds_file_output_p_h1_w := nais_mla_prescription.send_inoutpatient_presc_data(nr_prescricao_p, r4_count.order_unit, 'H1', processing_classication_p);
                                ds_file_output_p_final_w:=ds_file_output_p_final_w ||ds_file_output_p_h1_w;
                            end if;
                    end loop;
                close c04;
            end if;

                
            if h3_count_w >  0 then 
                open c04;
                    loop
                        fetch c04 into r4_count;
                            EXIT WHEN NOT FOUND; /* apply on c04 */
                            if (r4_count.si_type_prescription  in ('INPDP')) then
                            EXIT WHEN NOT FOUND; /* apply on c04 */
								ds_file_output_p_h1_w := nais_mla_prescription.send_inoutpatient_presc_data(nr_prescricao_p, r4_count.order_unit, 'H3', processing_classication_p);
								ds_file_output_p_final_w:=ds_file_output_p_final_w ||ds_file_output_p_h1_w;
							end if;
                    end loop;
                close c04;
            end if;

                
            if hj_count_w >  0 then 
                open c04;
                    loop
                        fetch c04 into r4_count;
                            EXIT WHEN NOT FOUND; /* apply on c04 */

                            if (r4_count.si_type_prescription  in ('BRME')) then 
                            EXIT WHEN NOT FOUND; /* apply on c04 */
								ds_file_output_p_h1_w := nais_mla_prescription.send_inoutpatient_presc_data(nr_prescricao_p, r4_count.order_unit, 'HJ', processing_classication_p);
								ds_file_output_p_final_w:=ds_file_output_p_final_w ||ds_file_output_p_h1_w;
							end if;
                    end loop;
                close c04;
            end if;

            if h8_count_w >  0 then 
                open c04;
                    loop
                        fetch c04 into r4_count;
                            EXIT WHEN NOT FOUND; /* apply on c04 */

                            if (r4_count.si_type_prescription  in ('OPIHO')) then 
                            EXIT WHEN NOT FOUND; /* apply on c04 */
								ds_file_output_p_h1_w := nais_mla_prescription.send_inoutpatient_presc_data(nr_prescricao_p, r4_count.order_unit, 'H0', processing_classication_p);
								ds_file_output_p_final_w:=ds_file_output_p_final_w ||ds_file_output_p_h1_w;
                        end if;
                    end loop;
                close c04;
            end if;

                
            if h0_count_w >  0 then 
                open c04;
                    loop
                        fetch c04 into r4_count;
                            EXIT WHEN NOT FOUND; /* apply on c04 */

                            if (r4_count.si_type_prescription  in ('OPOOH')) then 
                            EXIT WHEN NOT FOUND; /* apply on c04 */
								ds_file_output_p_h1_w := nais_mla_prescription.send_inoutpatient_presc_data(nr_prescricao_p, r4_count.order_unit, 'H8', processing_classication_p);
								ds_file_output_p_final_w:=ds_file_output_p_final_w ||ds_file_output_p_h1_w;
							end if;
                    end loop;
                close c04;
            end if;

                
            SELECT sum(length(ds_file_output_p_final_w) - length(replace(ds_file_output_p_final_w, ',', '')) ) into STRICT message_count_w
;
    if message_count_w >= 1 then
         for i in 1..message_count_w loop 
             begin
               if i = 1 then
                             
                              
                            select instr(ds_file_output_p_final_w, ',', 1, diff_w) into STRICT  l_len_w;
                            initial_value_w := l_len_w - 1;

                            select   substr(ds_file_output_p_final_w, 0, l_len_w - 1) into STRICT val_w;
               else

                            diff_w := diff_w + 1;
                            select instr(ds_file_output_p_final_w, ',', 1, diff_w) into STRICT l_len_w;
                            if l_len_w = 0 then
                                select
                                    substr(ds_file_output_p_final_w, initial_value_w , length(ds_file_output_p_final_w) - initial_value_w + 1) into STRICT val_w;
                            else

                                select
                                    replace(substr(ds_file_output_p_final_w, initial_value_w+1, l_len_w - initial_value_w),',','') into STRICT val_w;
                            end if;

                           initial_value_w := l_len_w - 1;

               end if;
                            json_output_w := nais_mla_prescription.add_json_value(json_output_w, 'message', replace(val_w, chr(13), ''));
                            current_setting('nais_mla_prescription.json_output_list_w')::philips_json_list.append(json_output_w.to_json_value());
            end;
        end loop;
    end if;
    dbms_lob.createtemporary( ds_file_output_p, true);
    current_setting('nais_mla_prescription.json_output_list_w')::philips_json_list.(ds_file_output_p);

    record_integration_call_log(coalesce(wheb_usuario_pck.get_nm_usuario , 'NAIS'), 'NAIS', clock_timestamp(), processing_classication_p, processing_classication_p , 'T', 'E', null, 'MJ', ds_file_output_p,null, 0,current_setting('nais_mla_prescription.nr_seq_int_call_log_w')::bigint, to_char(nr_prescricao_p), 944,'S');

	
END;

$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE nais_mla_prescription.unexecutedorder_prescription ( nr_prescricao_p bigint, processing_classication_p text, ds_file_output_p INOUT text ) FROM PUBLIC;
