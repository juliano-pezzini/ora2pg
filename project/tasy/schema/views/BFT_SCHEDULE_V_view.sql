-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';

CREATE OR REPLACE VIEW bft_schedule_v (authorization_id, authorization_stage_id, doctor_authorization_id, dc_doctor_id, surgery_schedule_id, service_schedule_id, internal_procedure_code, main_procedure_code, establishment_id, encounter_id, referred_doctor_provider_num, referred_doctor_given_name, referred_doctor_last_name, referred_doctor_middle_name, referral_date, validity_date, patient_id, dc_client_id, ie_tipo_guia, ie_tipo_autorizacao, cd_autorizacao, nr_seq_classif, dc_appointment_id, rate_id, invoice_type_id, charge_gap, benefit_level_id, is_emergency_anaesthesia, pre_existing, same_day, compensation_claim, type_schedule_id, external_schedule_id, schedule_date, doctor_id, start_time, end_time, appointment_priority_id, user_name, referrer_firstname, comments, minutes_duration, schedule_id, schedule_status_id, cd_anestesista, cd_medico, ie_carater_cirurgia, ie_tipo_atendimento, cd_estabelecimento) AS select 	a.nr_sequencia authorization_id,
        a.NR_SEQ_ESTAGIO authorization_stage_id,
        a.cd_medico_solicitante doctor_authorization_id,
        dc_obter_conversao_externa_int(null, 'MEDICO','CD_PESSOA_FISICA', a.cd_medico_solicitante, 'DC') dc_doctor_id,
        a.nr_seq_agenda surgery_schedule_id, -- Surgery Schedule ID AGENDA_PACIENTE
        a.nr_seq_agenda_consulta service_schedule_id, -- Service Schedule ID  AGENDA_CONSULTA
        a.nr_seq_proc_interno internal_procedure_code,
        a.cd_procedimento_principal main_procedure_code, --MBS code
        a.cd_estabelecimento establishment_id, --businessLocationId (hardcode 9 in the flow)
        a.nr_atendimento encounter_id,
        get_provider_details(obter_nome_medico_referido(a.nr_atendimento), a.cd_estabelecimento, null) referred_doctor_provider_num,
        obter_dados_pf(obter_nome_medico_referido(a.nr_atendimento),'PNG') referred_Doctor_Given_Name,
        obter_dados_pf(obter_nome_medico_referido(a.nr_atendimento),'PNL') referred_Doctor_Last_Name,
        obter_dados_pf(obter_nome_medico_referido(a.nr_atendimento),'PNM') referred_Doctor_Middle_Name,
        get_referral_letter_details(1, a.nr_atendimento) referral_date,
        get_referral_letter_details(2, a.nr_atendimento) validity_date,
        a.cd_pessoa_fisica patient_id,
        dc_obter_conversao_externa_int(null, 'PESSOA_FISICA','CD_PESSOA_FISICA', a.cd_pessoa_fisica, 'DC') dc_client_id,
        a.IE_TIPO_GUIA, -- Type of form (Admission, Consultation, OutPatient, Exams/Test, ..)
        a.IE_TIPO_AUTORIZACAO, -- type of authorization (Admission, Admission extend, Consultation, Procedures, Surgery,..)
        a.CD_AUTORIZACAO, -- InvoiceID from DC
        a.NR_SEQ_CLASSIF, -- Select the classification of the authorization Depends on table: Classification for Insurance authorization CLASSIF_AUTORIZACAO Function: Core Tables Settings of Tasy >Main Application > Encounter > Classification for Insurance authorization
        dc_obter_conversao_externa_int(null, 'AUTORIZACAO_CONVENIO','NR_SEQ_AGENDA', a.nr_sequencia, 'DC') dc_appointment_id, 
        3 rate_id,
        1 invoice_type_id,
        'false' charge_gap,
        1 benefit_level_id,
        'false' is_emergency_anaesthesia,
        'false' pre_existing,
        'false' same_day,
        'true' compensation_claim,
        1 type_schedule_id,
        a.nr_seq_agenda external_schedule_id,
        a.dt_entrada_prevista schedule_date,
        a.cd_medico_solicitante doctor_id,
        TO_CHAR(a.dt_entrada_prevista , 'HH24:MI') start_time,
        TO_CHAR((a.dt_entrada_prevista + (1/1440*15)), 'HH24:MI') end_time,
        100 appointment_priority_id,
        'doctor' user_name,
        'firstName' referrer_firstName,
        'comments' comments,
        15 minutes_duration    ,
        a.nr_sequencia schedule_id,
        null schedule_status_id,
        null cd_anestesista,
        a.cd_medico_solicitante cd_medico,
        null ie_carater_cirurgia,
        null ie_tipo_Atendimento,
        a.cd_estabelecimento
FROM    autorizacao_convenio a

union all

select  null authorization_id,
        null    authorization_stage_id,
        a.cd_medico_resp     doctor_authorization_id,
        dc_obter_conversao_externa_int(null, 'MEDICO','CD_PESSOA_FISICA', a.cd_medico_resp, 'DC') dc_doctor_id,
        null surgery_schedule_id,
        null service_schedule_id,
        null internal_procedure_code,
        null main_procedure_code,
        a.cd_estabelecimento establishment_id,
        a.nr_atendimento encounter_id,
		get_provider_details(a.cd_medico_referido, a.cd_estabelecimento, c.cd_setor_atendimento) referred_doctor_provider_num,
		obter_dados_pf(a.cd_medico_referido,'PNG') referred_Doctor_Given_Name,
		obter_dados_pf(a.cd_medico_referido,'PNL') referred_Doctor_Last_Name,
		obter_dados_pf(a.cd_medico_referido,'PNM') referred_Doctor_Middle_Name,
        get_referral_letter_details(1, a.nr_atendimento) referral_date,
        get_referral_letter_details(2, a.nr_atendimento) validity_date,
        a.cd_pessoa_fisica patient_id,
        dc_obter_conversao_externa_int(null, 'PESSOA_FISICA','CD_PESSOA_FISICA', a.cd_pessoa_fisica, 'DC') dc_client_id,
        null,
        null,
        null,
        null,
        null dc_appointment_id,
        3 rate_id,
        1 invoice_type_id,
        'false' charge_gap,
        1 benefit_level_id,
        'false' is_emergency_anaesthesia,
        'false' pre_existing,
        'false' same_day,
        'true' compensation_claim,
        null type_schedule_id,
        null external_schedule_id,
        a.DT_ENTRADA schedule_date,
        a.cd_medico_resp doctor_id,
        TO_CHAR(a.DT_ENTRADA , 'HH24:MI') start_time,
        TO_CHAR((a.DT_ENTRADA + (1/1440*15)), 'HH24:MI') end_time,
        100 appointment_priority_id,
        'doctor' user_name,
        'firstName' referrer_firstName,
        'comments' comments,
        15 minutes_duration,
        null schedule_id,
        null schedule_status_id,
        null cd_anestesista,
        a.CD_MEDICO_RESP cd_medico,
        null ie_carater_cirurgia,
        a.ie_tipo_atendimento ie_tipo_Atendimento,
        a.cd_estabelecimento
from    setor_atendimento e,
        convenio d,
        atend_paciente_unidade c,
        atend_categoria_convenio b,
        atendimento_paciente a
where   a.nr_atendimento = c.nr_atendimento
and     c.nr_seq_interno =  ( select    coalesce(max(x.nr_seq_interno),0)
            from     atend_paciente_unidade x
            where    x.nr_atendimento = a.nr_atendimento
            and     coalesce(x.dt_saida_unidade, x.dt_entrada_unidade + 9999)  =
        (select max(coalesce(v.dt_saida_unidade, v.dt_entrada_unidade + 9999))
        from atend_paciente_unidade v
        where v.nr_atendimento = a.nr_atendimento))
and     a.nr_atendimento    = b.nr_atendimento
and     b.nr_seq_interno    = (    select coalesce(max(nr_seq_interno),0)
                from     atend_categoria_convenio z
                where    z.nr_atendimento = a.nr_atendimento
                and     z.dt_inicio_vigencia    =
                (select    max(x.dt_inicio_vigencia)
                from     atend_categoria_convenio x
                where     x.nr_atendimento = a.nr_atendimento))
and     c.cd_setor_atendimento    = e.cd_setor_atendimento
and     b.cd_convenio        = d.cd_convenio;
