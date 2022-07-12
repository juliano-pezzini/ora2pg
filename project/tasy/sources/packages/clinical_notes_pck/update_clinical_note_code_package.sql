-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';




CREATE OR REPLACE PROCEDURE clinical_notes_pck.update_clinical_note_code (cd_evolucao_p bigint, cd_evolucao_w bigint) AS $body$
DECLARE

    nr_atendimento_w           bigint;
    ie_soap_data_exists_w      varchar(1) := 'N';
    c01 CURSOR FOR
    SELECT a.*,b.nr_atendimento
    FROM clinical_note_soap_data a , evolucao_paciente b
    WHERE a.cd_evolucao = b.cd_evolucao
    and b.cd_evolucao = cd_evolucao_p;


BEGIN
    select CASE WHEN count(1)=0 THEN 'N'  ELSE 'S' END  into STRICT ie_soap_data_exists_w
    from clinical_note_soap_data
    where cd_evolucao = cd_evolucao_p;
    if (ie_soap_data_exists_w = 'S') then
        for r_c01 in c01 loop
        if ( r_c01.ie_med_rec_type = 'DIAGNOSIS') then
        update diagnostico_doenca
        set cd_evolucao = cd_evolucao_w
        where cd_evolucao = cd_evolucao_p
        and nr_seq_interno = r_c01.nr_seq_med_item;
        elsif (r_c01.ie_med_rec_type = 'PROBLEM' ) then
        update lista_problema_pac
        set cd_evolucao = cd_evolucao_w
        where cd_evolucao = cd_evolucao_p
        and nr_sequencia = r_c01.nr_seq_med_item;
        elsif ( r_c01.ie_med_rec_type = 'INPATIENT' ) then
        CALL gerar_atend_pac_inf_evol(r_c01.nr_atendimento, cd_evolucao_w);
        elsif ( r_c01.ie_med_rec_type = 'DISCHARGE' ) then
        CALL gerar_atend_pac_inf_evol(r_c01.nr_atendimento, cd_evolucao_w);
        elsif ( r_c01.ie_med_rec_type = 'DEPT_TRANSFER' or r_c01.ie_med_rec_type = 'WARD_TRANSFER' or  r_c01.ie_med_rec_type = 'BED_TRANSFER') then
        update atend_paciente_unidade
        set cd_evolucao = cd_evolucao_w
        where cd_evolucao = cd_evolucao_p
        and nr_seq_interno = r_c01.nr_seq_med_item;
        elsif ( r_c01.ie_med_rec_type = 'TEMP_LEAVE' ) then
        update	atend_paciente_unidade
        set	cd_evolucao = cd_evolucao_w
        where	nr_atendimento = r_c01.nr_atendimento
        and nr_seq_interno = r_c01.nr_seq_med_item;
        elsif ( r_c01.ie_med_rec_type = 'CLNICAL_PATHWAY' ) then
        update protocolo_int_paciente
        set cd_evolucao = cd_evolucao_w
        where nr_sequencia = r_c01.nr_seq_med_item
        and cd_evolucao = cd_evolucao_p;
        elsif ( r_c01.ie_med_rec_type = 'MED_CERT' ) then
        update atestado_paciente
        set cd_evolucao = cd_evolucao_w
        where nr_sequencia = r_c01.nr_seq_med_item
        and cd_evolucao = cd_evolucao_p;
        elsif ( r_c01.ie_med_rec_type = 'CONSENT' ) then
        update pep_pac_ci
        set cd_evolucao = cd_evolucao_w
        where nr_sequencia =  r_c01.nr_seq_med_item
        and cd_evolucao = cd_evolucao_p;
        elsif ( r_c01.ie_med_rec_type = 'MED_GUIDANCE' ) then
        update medical_guidance_order
        set cd_evolucao = cd_evolucao_w
        where nr_sequencia = r_c01.nr_seq_med_item
        and cd_evolucao = cd_evolucao_p;
        elsif ( r_c01.ie_med_rec_type = 'DPC' ) then
        update patient_dpc
        set cd_evolucao = cd_evolucao_w
        where nr_sequencia = r_c01.nr_seq_med_item
        and cd_evolucao = cd_evolucao_p;
        elsif ( r_c01.ie_med_rec_type = 'DSCHRG_INSTR' ) then
        update atendimento_alta
        set cd_evolucao = cd_evolucao_w
        where nr_sequencia = r_c01.nr_seq_med_item
        and cd_evolucao = cd_evolucao_p;
        elsif ( r_c01.ie_med_rec_type = 'CARE_PLAN' ) then
        update pe_prescricao
        set cd_evolucao = cd_evolucao_w
        where  nr_sequencia = r_c01.nr_seq_med_item
        and cd_evolucao = cd_evolucao_p;
        elsif ( r_c01.ie_med_rec_type = 'SURGERY' ) then
        update cirurgia
        set cd_evolucao = cd_evolucao_w
        where nr_cirurgia = r_c01.nr_seq_med_item
        and cd_evolucao = cd_evolucao_p;
        elsif ( r_c01.ie_med_rec_type = 'INTERNAL_REF' ) then
        update parecer_medico
        set cd_evolucao = cd_evolucao_w
        where nr_seq_interno = r_c01.nr_seq_med_item
        and cd_evolucao = cd_evolucao_p;
		update parecer_medico_req
        set cd_evolucao = cd_evolucao_w
        where nr_parecer = r_c01.nr_seq_med_item
        and cd_evolucao = cd_evolucao_p;
        elsif ( r_c01.ie_med_rec_type = 'BED_RQST' ) then
        update gestao_vaga
        set cd_evolucao = cd_evolucao_w
        where nr_sequencia =r_c01.nr_seq_med_item
        and cd_evolucao = cd_evolucao_p;
        elsif ( r_c01.ie_med_rec_type = 'MED_DSCHG_REQ' ) then
        CALL gerar_atend_pac_inf_evol(r_c01.nr_atendimento, cd_evolucao_w);
        elsif ( r_c01.ie_med_rec_type = 'EMERG_SERV_CONS' ) then
        update triagem_pronto_atend
        set cd_evolucao = cd_evolucao_w
        where nr_sequencia = r_c01.nr_seq_med_item
        and cd_evolucao = cd_evolucao_p;
        elsif ( r_c01.ie_med_rec_type = 'CONS_SCHD' or r_c01.ie_med_rec_type = 'EXAM_SCHD' or r_c01.ie_med_rec_type = 'SRVC_SCHD') then
        if (r_c01.ie_med_rec_type = 'EXAM_SCHD') then
        update AGENDA_PACIENTE_INF_ADIC
        set cd_evolucao = cd_evolucao_w
        where nr_seq_agenda = r_c01.nr_seq_med_item
        and cd_evolucao = cd_evolucao_p;
        end if;
        if (r_c01.ie_med_rec_type = 'CONS_SCHD' or r_c01.ie_med_rec_type = 'SRVC_SCHD' ) then
        update agenda_consulta_adic
        set cd_evolucao = cd_evolucao_w
        where nr_seq_agenda = r_c01.nr_seq_med_item
        and cd_evolucao = cd_evolucao_p;
        end if;
        elsif ( r_c01.ie_med_rec_type = 'GNRL_INSTRCT' ) then
        update pep_orientacao_geral
        set cd_evolucao = cd_evolucao_w
        where nr_sequencia = r_c01.nr_seq_med_item
        and cd_evolucao = cd_evolucao_p;
        elsif ( r_c01.ie_med_rec_type = 'DIALYSIS_SCHD' ) then
        update hd_escala_dialise
        set cd_evolucao = cd_evolucao_w
        where nr_sequencia = r_c01.nr_seq_med_item
        and cd_evolucao = cd_evolucao_p;
        elsif ( r_c01.ie_med_rec_type = 'SURG_ACHIEVE' ) then
        update aval_pre_anestesica
        set cd_evolucao = cd_evolucao_w
        where nr_sequencia = r_c01.nr_seq_med_item
        and cd_evolucao = cd_evolucao_p;
        elsif (r_c01.ie_med_rec_type = 'IP_MED_TP' or r_c01.ie_med_rec_type = 'PD_MED_TP') then
        update med_treatment_plan
        set cd_evolucao = cd_evolucao_w
        where nr_sequencia = r_c01.nr_seq_med_item
        and  cd_evolucao = cd_evolucao_p;
		elsif (r_c01.ie_med_rec_type = 'CPOE_ITEMS' and r_c01.ie_stage = 1) then
            if ( r_c01.ie_cpoe_item_type = '0') then
                update cpoe_dieta
                set cd_evolucao = cd_evolucao_w
                where nr_sequencia = r_c01.nr_seq_med_item
                and  cd_evolucao = cd_evolucao_p;
            elsif (r_c01.ie_cpoe_item_type = '1') then
                update cpoe_material
                set cd_evolucao = cd_evolucao_w
                where nr_sequencia = r_c01.nr_seq_med_item
                and  cd_evolucao = cd_evolucao_p;
            elsif (r_c01.ie_cpoe_item_type = '2') then
                update cpoe_procedimento
                set cd_evolucao = cd_evolucao_w
                where nr_sequencia = r_c01.nr_seq_med_item
                and  cd_evolucao = cd_evolucao_p;
            elsif (r_c01.ie_cpoe_item_type = '3') then
                update cpoe_gasoterapia
                set cd_evolucao = cd_evolucao_w
                where nr_sequencia = r_c01.nr_seq_med_item
                and  cd_evolucao = cd_evolucao_p;
            elsif (r_c01.ie_cpoe_item_type = '4') then
                update cpoe_recomendacao
                set cd_evolucao = cd_evolucao_w
                where nr_sequencia = r_c01.nr_seq_med_item
                and  cd_evolucao = cd_evolucao_p;
            elsif (r_c01.ie_cpoe_item_type = '5') then
                update cpoe_hemoterapia
                set cd_evolucao = cd_evolucao_w
                where nr_sequencia = r_c01.nr_seq_med_item
                and  cd_evolucao = cd_evolucao_p;
            elsif (r_c01.ie_cpoe_item_type = '6') then
                update cpoe_dialise
                set cd_evolucao = cd_evolucao_w
                where nr_sequencia = r_c01.nr_seq_med_item
                and  cd_evolucao = cd_evolucao_p;
            elsif (r_c01.ie_cpoe_item_type = '7') then
                update cpoe_intervencao
                set cd_evolucao = cd_evolucao_w
                where nr_sequencia = r_c01.nr_seq_med_item
                and  cd_evolucao = cd_evolucao_p;
            elsif (r_c01.ie_cpoe_item_type = '8') then
                update cpoe_material
                set cd_evolucao = cd_evolucao_w
                where nr_sequencia = r_c01.nr_seq_med_item
                and  cd_evolucao = cd_evolucao_p;
            elsif (r_c01.ie_cpoe_item_type = '9') then
                update cpoe_anatomia_patologica
                set cd_evolucao = cd_evolucao_w
                where nr_sequencia = r_c01.nr_seq_med_item
                and  cd_evolucao = cd_evolucao_p;
            end if;
		elsif ( r_c01.ie_med_rec_type = 'EXT_REFERRAL' ) then
			if ( r_c01.ie_cpoe_item_type =  '2') then
                update rl_ref_from_hospital
                set cd_evolucao = cd_evolucao_w
                where nr_sequencia = r_c01.nr_seq_med_item
                and cd_evolucao = cd_evolucao_p;
                elsif ( r_c01.ie_cpoe_item_type =  '3') then
                update rl_rep_to_hospital
                set cd_evolucao = cd_evolucao_w
                where nr_sequencia = r_c01.nr_seq_med_item
                and cd_evolucao = cd_evolucao_p;
                elsif ( r_c01.ie_cpoe_item_type =  '1') then
                update rl_ref_to_hospital
                set cd_evolucao = cd_evolucao_w
                where nr_sequencia = r_c01.nr_seq_med_item
                and cd_evolucao = cd_evolucao_p;
                elsif ( r_c01.ie_cpoe_item_type =  '4') then
                update rl_rep_from_hospital
                set cd_evolucao = cd_evolucao_w
                where nr_sequencia = r_c01.nr_seq_med_item
                and cd_evolucao = cd_evolucao_p;
				end if;
		elsif ( r_c01.ie_med_rec_type = 'REHAB' ) then
			if ( r_c01.ie_cpoe_item_type =  '1') then
                update rp_paciente_reabilitacao
                set cd_evolucao = cd_evolucao_w
                where nr_sequencia = r_c01.nr_seq_med_item
                and cd_evolucao = cd_evolucao_p;
                elsif ( r_c01.ie_cpoe_item_type =  '2') then
                update rp_implementation_reab
                set cd_evolucao = cd_evolucao_w
                where nr_sequencia = r_c01.nr_seq_med_item
                and cd_evolucao = cd_evolucao_p;
                elsif ( r_c01.ie_cpoe_item_type =  '3') then
                update med_avaliacao_paciente
                set cd_evolucao = cd_evolucao_w
                where nr_sequencia = r_c01.nr_seq_med_item
                and cd_evolucao = cd_evolucao_p;
				end if;
		elsif ( r_c01.ie_med_rec_type = 'NUT_GUIDANCE' ) then
				update nut_orientacao_list
				set cd_evolucao = cd_evolucao_w
				where nr_sequencia = r_c01.nr_seq_med_item
				and cd_evolucao = cd_evolucao_p;
        elsif ( r_c01.ie_med_rec_type = 'NURSE_CARE_NEED' ) then
				update nursing_care_encounter
				set cd_evolucao = cd_evolucao_w
				where nr_sequencia = r_c01.nr_seq_med_item
				and cd_evolucao = cd_evolucao_p;
        end if;
        end loop;
    end if;
 END;

$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE clinical_notes_pck.update_clinical_note_code (cd_evolucao_p bigint, cd_evolucao_w bigint) FROM PUBLIC;