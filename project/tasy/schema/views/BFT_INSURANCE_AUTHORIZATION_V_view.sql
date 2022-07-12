-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';

CREATE OR REPLACE VIEW bft_insurance_authorization_v (authorization_id, authorization_stage_id, doctor_authorization_id, dc_doctor_id, surgery_schedule_id, service_schedule_id, internal_procedure_code, main_procedure_code, establishment_id, encounter_id, patient_id, dc_client_id, ie_tipo_guia, ie_tipo_autorizacao, cd_autorizacao, nr_seq_classif, dc_appointment_id, user_name, comments, rate_id, invoice_type_id, charge_gap, benefit_level_id, is_emergency_anaesthesia, pre_existing, same_day, compensation_claim, length_of_stay, insurance_code) AS select a.nr_sequencia authorization_id,
        a.nr_seq_estagio authorization_stage_id,
        a.cd_medico_solicitante doctor_authorization_id,
        obter_conversao_externa_int(null, 'MEDICO','CD_PESSOA_FISICA', a.cd_medico_solicitante, 'DC') dc_doctor_id,
        a.nr_sequencia surgery_schedule_id, -- Surgery Schedule ID AGENDA_PACIENTE
        null service_schedule_id, -- Service Schedule ID  AGENDA_CONSULTA
        a.nr_seq_proc_interno internal_procedure_code,
        a.cd_procedimento_principal main_procedure_code, --MBS code
        a.cd_estabelecimento establishment_id, --businessLocationId (hardcode 9 in the flow)
        a.nr_atendimento encounter_id,
        a.cd_pessoa_fisica patient_id,
        dc_obter_conversao_externa_int(null, 'PESSOA_FISICA','CD_PESSOA_FISICA', a.cd_pessoa_fisica, 'DC') dc_client_id,
        a.ie_tipo_guia, -- Type of form (Admission, Consultation, OutPatient, Exams/Test, ..)
        a.ie_tipo_autorizacao, -- type of authorization (Admission, Admission extend, Consultation, Procedures, Surgery,..)
        a.cd_autorizacao, -- InvoiceID from DC
        a.nr_seq_classif, -- Select the classification of the authorization Depends on table: Classification for Insurance authorization CLASSIF_AUTORIZACAO Function: Core Tables Settings of Tasy >Main Application > Encounter > Classification for Insurance authorization
        dc_obter_conversao_externa_int(null, 'AUTORIZACAO_CONVENIO','NR_SEQ_AGENDA', a.nr_sequencia, 'DC') dc_appointment_id, 
        'doctor' user_name,
        'comments' comments,
        CASE WHEN b.ie_tipo_convenio=2 THEN 6 WHEN b.ie_tipo_convenio=12 THEN 6 WHEN b.ie_tipo_convenio=13 THEN 5 END  rate_id,
        1 invoice_type_id,
        'false' charge_gap,
        3 benefit_level_id,
        'false' is_emergency_anaesthesia,
        'false' pre_existing,
        'false' same_day,
        'true' compensation_claim,
        a.qt_dia_solicitado length_of_stay,
		a.cd_convenio insurance_code
FROM	autorizacao_convenio a,
		convenio b
where	a.cd_convenio = b.cd_convenio;

