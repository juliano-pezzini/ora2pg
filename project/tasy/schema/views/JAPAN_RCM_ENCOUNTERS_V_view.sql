-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';

CREATE OR REPLACE VIEW japan_rcm_encounters_v (nr_sequencia, ds_status, ds_questionnaire, nr_atendimento, cd_estabelecimento, cd_pessoa_fisica, cd_departamento, cd_medico_atendimento, cd_bed, cd_dpc_amount, estimated_days, cd_department, cd_medical_department_code, cd_room, nm_patient, qt_age, si_sex, nr_medical_record, nm_medical_department, nm_physician, si_category, cd_dpc, nm_dpc, nm_disease, dt_entrada, dt_previsto_alta, dt_alta, ds_care_type, qt_length_stay, ie_tipo_atendimento, si_dpc_not_created, si_dpc_not_defined, si_general_dpc_defined, si_special_dpc_defined, ds_term_1, ds_term_2, ds_term_3, si_questionnaire_status, fee_service, update_date, user_last_change, remaining_days, si_doctor_complete, si_nurse_complete, si_med_office_complete) AS select distinct
    null nr_sequencia,
    null ds_status,
    (SELECT max(b.si_status)FROM PATIENT_DPC a inner join PATIENT_DPC_QUESTIONNAIRE b on a.nr_sequencia=b.NR_SEQ_PATIENT_DPC where a.nr_atendimento=a.nr_atendimento) ds_questionnaire,
    a.nr_atendimento,
    a.cd_estabelecimento,
    a.cd_pessoa_fisica,
   (select dm.ds_departamento from DEPARTAMENTO_MEDICO dm where dm.cd_departamento =(select b.cd_departamento  from patient_dpc b where b.nr_sequencia= (select max(pd.nr_sequencia) from patient_dpc pd where  pd.nr_atendimento=a.nr_atendimento))) cd_departamento,
    a.cd_medico_atendimento,
    obter_unidade_atendimento(a.nr_atendimento,'A','UC') cd_bed,
    (Select count(*) from patient_Dpc b where nr_atendimento=a.nr_atendimento) cd_dpc_amount,
    a.QT_DIAS_PREV_INTER estimated_days,
    obter_unidade_atendimento(a.nr_atendimento,'A','S') CD_DEPARTMENT,
	obter_departamento_atual_atend(a.nr_atendimento) CD_MEDICAL_DEPARTMENT_CODE,
    obter_unidade_atendimento(a.nr_atendimento,'A','U') CD_ROOM,
    obter_nome_paciente(a.nr_atendimento) NM_PATIENT,
    obter_dados_pf(a.cd_pessoa_fisica,'I') QT_AGE,
    obter_dados_pf(a.cd_pessoa_fisica,'SE') SI_SEX,
    obter_dados_pf(a.cd_pessoa_fisica,'NP') NR_MEDICAL_RECORD,
    obter_nome_departamento_medico(obter_departamento_atual_atend(a.nr_atendimento)) NM_MEDICAL_DEPARTMENT,
    obter_medico_resp_atend(a.nr_atendimento,'N') NM_PHYSICIAN,
    Obter_Valor_Dominio(9603, (select max(b.si_category) from patient_dpc b where b.nr_sequencia= (select max(nr_sequencia) from patient_dpc where nr_atendimento=a.nr_atendimento))) SI_CATEGORY,
    (select c.cd_dpc  from patient_dpc b, dpc_score c where b.nr_sequencia= (select max(nr_sequencia) from patient_dpc where  nr_atendimento=a.nr_atendimento) and  b.nr_seq_dpc_score = c.nr_sequencia)cd_dpc,
    (select c.nm_dpc  from patient_dpc b, dpc_score c where b.nr_sequencia= (select max(nr_sequencia) from patient_dpc where  nr_atendimento=a.nr_atendimento) and  b.nr_seq_dpc_score = c.nr_sequencia)nm_dpc, 
    (select max(b.cd_icd_code) ||' - '|| max(b.ds_disease_name)from diagnostico_doenca a, icd_codes_main_jpn b where a.nr_seq_interno = (select nr_seq_most_exp_diagnosis from patient_dpc b where b.nr_sequencia =(select max(nr_sequencia) from patient_dpc where nr_atendimento = a.nr_atendimento)) and b.nr_disease_number = a.NR_SEQ_DISEASE_NUMBER) NM_DISEASE,
    a.dt_entrada,
    a.dt_previsto_alta,
    a.dt_alta,
    obter_valor_dominio(12, a.ie_tipo_atendimento) ds_care_type,
    obter_dias_internacao(a.nr_atendimento) qt_length_stay,
    a.ie_tipo_atendimento IE_TIPO_ATENDIMENTO,         
    (select CASE WHEN count(*)=0 THEN 'S'  ELSE 'N' END  from patient_dpc p where a.nr_atendimento = p.nr_atendimento) si_dpc_not_created, 
    (select CASE WHEN count(*)=0 THEN  'N'  ELSE 'S' END  from patient_dpc p where p.nr_atendimento = a.nr_atendimento and p.nr_seq_dpc_score is null and not exists (select 1 from patient_dpc x where x.nr_atendimento = a.nr_atendimento and nr_seq_dpc_score is not null)) si_dpc_not_defined,
    (select CASE WHEN count(*)=0 THEN  'N'  ELSE 'S' END  from patient_dpc p where p.nr_atendimento = a.nr_atendimento and p.nr_seq_dpc_score is not null and p.si_category = '00' and not exists (select 1 from patient_dpc x where x.nr_atendimento = a.nr_atendimento and p.si_category <> '00')) si_general_dpc_defined,
   (select CASE WHEN count(*)=0 THEN  'N'  ELSE 'S' END  from patient_dpc p where p.nr_atendimento = a.nr_atendimento and p.nr_seq_dpc_score is not null and p.si_category <> '00') si_special_dpc_defined,
   CASE WHEN (select c.qt_days_hosp_1  from patient_dpc b, dpc_score c where b.nr_sequencia= (select max(nr_sequencia) from patient_dpc where  nr_atendimento=a.nr_atendimento) and  b.nr_seq_dpc_score = c.nr_sequencia) ='' THEN ''  ELSE '(' || (select c.qt_days_hosp_1  from patient_dpc b, dpc_score c where b.nr_sequencia= (select max(nr_sequencia) from patient_dpc where  nr_atendimento=a.nr_atendimento) and  b.nr_seq_dpc_score = c.nr_sequencia) || ') ' || to_char(dt_entrada,pkg_date_formaters.localize_mask('shortDate', pkg_date_formaters.getUserLanguageTag(wheb_usuario_pck.get_cd_estabelecimento, wheb_usuario_pck.get_nm_usuario))) END  ds_term_1,
    CASE WHEN (select c.qt_days_hosp_2  from patient_dpc b, dpc_score c where b.nr_sequencia= (select max(nr_sequencia) from patient_dpc where  nr_atendimento=a.nr_atendimento) and  b.nr_seq_dpc_score = c.nr_sequencia)='' THEN ''  ELSE '(' || (select c.qt_days_hosp_2  from patient_dpc b, dpc_score c where b.nr_sequencia= (select max(nr_sequencia) from patient_dpc where  nr_atendimento=a.nr_atendimento) and  b.nr_seq_dpc_score = c.nr_sequencia) || ') ' || to_char(dt_entrada + coalesce((select c.qt_days_hosp_1  from patient_dpc b, dpc_score c where b.nr_sequencia= (select max(nr_sequencia) from patient_dpc where  nr_atendimento=a.nr_atendimento) and  b.nr_seq_dpc_score = c.nr_sequencia),0),pkg_date_formaters.localize_mask('shortDate', pkg_date_formaters.getUserLanguageTag(wheb_usuario_pck.get_cd_estabelecimento, wheb_usuario_pck.get_nm_usuario))) END  ds_term_2,
    CASE WHEN (select c.qt_days_hosp_3  from patient_dpc b, dpc_score c where b.nr_sequencia= (select max(nr_sequencia) from patient_dpc where  nr_atendimento=a.nr_atendimento) and  b.nr_seq_dpc_score = c.nr_sequencia)='' THEN ''  ELSE '(' || (select c.qt_days_hosp_3  from patient_dpc b, dpc_score c where b.nr_sequencia= (select max(nr_sequencia) from patient_dpc where nr_atendimento=a.nr_atendimento) and  b.nr_seq_dpc_score = c.nr_sequencia) || ') ' || to_char(dt_entrada + coalesce((select c.qt_days_hosp_1  from patient_dpc b, dpc_score c where b.nr_sequencia= (select max(nr_sequencia) from patient_dpc where  nr_atendimento=a.nr_atendimento) and  b.nr_seq_dpc_score = c.nr_sequencia),0) + coalesce((select c.qt_days_hosp_2  from patient_dpc b, dpc_score c where b.nr_sequencia= (select max(nr_sequencia) from patient_dpc where  nr_atendimento=a.nr_atendimento) and  b.nr_seq_dpc_score = c.nr_sequencia),0),pkg_date_formaters.localize_mask('shortDate', pkg_date_formaters.getUserLanguageTag(wheb_usuario_pck.get_cd_estabelecimento, wheb_usuario_pck.get_nm_usuario))) END  ds_term_3,
    dpc_pkg.get_dpc_questionnaire_status((select b.nr_sequencia from patient_dpc b where b.nr_sequencia= (select max(nr_sequencia) from patient_dpc where  nr_atendimento=a.nr_atendimento))) si_questionnaire_status,
   to_char(a.dt_entrada + coalesce((select c.qt_days_hosp_1 from patient_dpc b inner join dpc_score c on b.nr_seq_dpc_score = c.nr_sequencia where b.nr_sequencia= (select max(pd.nr_sequencia) from patient_dpc pd where pd.nr_atendimento=a.nr_atendimento)),0) + coalesce((select c.qt_days_hosp_2 from patient_dpc pd inner join dpc_score c on pd.nr_seq_dpc_score = c.nr_sequencia where pd.nr_sequencia= (select max(pd.nr_sequencia) from patient_dpc pd where pd.nr_atendimento=a.nr_atendimento)),0) + coalesce((select c.qt_days_hosp_3 from patient_dpc b inner join dpc_score c on b.nr_seq_dpc_score = c.nr_sequencia where b.nr_sequencia= (select max(pd.nr_sequencia) from patient_dpc pd where pd.nr_atendimento=a.nr_atendimento)),0) + 1, pkg_date_formaters.localize_mask('shortDate', pkg_date_formaters.getUserLanguageTag(wheb_usuario_pck.get_cd_estabelecimento, wheb_usuario_pck.get_nm_usuario))) FEE_SERVICE,
   (coalesce((select b.dt_atualizacao from patient_dpc b where b.nr_sequencia= (select max(nr_sequencia) from patient_dpc where  nr_atendimento=a.nr_atendimento)), a.dt_atualizacao)) update_date,
   (coalesce((select b.nm_usuario  from patient_dpc b where b.nr_sequencia= (select max(nr_sequencia) from patient_dpc where  nr_atendimento=a.nr_atendimento)), a.nm_usuario)) user_last_change,
    (CASE WHEN a.dt_alta IS NULL THEN  round((a.dt_previsto_alta - LOCALTIMESTAMP)::numeric, 1)  ELSE 0 END ) remaining_days,
	(select max(si_physician_complete) from patient_dpc_questionnaire pq,patient_dpc pd where pq.nr_seq_patient_dpc = pd.nr_sequencia and pd.nr_atendimento = a.nr_atendimento and pq.ie_situacao = 'A') as si_doctor_complete,
    (select max(si_nurse_complete) from patient_dpc_questionnaire pq,patient_dpc pd where pq.nr_seq_patient_dpc = pd.nr_sequencia and pd.nr_atendimento = a.nr_atendimento and pq.ie_situacao = 'A') as si_nurse_complete,
    (select max(si_med_office_complete) from patient_dpc_questionnaire pq,patient_dpc pd where pq.nr_seq_patient_dpc = pd.nr_sequencia and pd.nr_atendimento = a.nr_atendimento and pq.ie_situacao = 'A') as si_med_office_complete
	
from    
 atendimento_paciente a
where   
    1 = 1  
order by 
    a.dt_entrada;
