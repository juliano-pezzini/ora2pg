-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';




CREATE OR REPLACE FUNCTION encounter_json_pck.get_encounter ( nr_atendimento_p bigint) RETURNS PHILIPS_JSON AS $body$
DECLARE

	json_encounter_w		philips_json;
	
	
	C01 CURSOR FOR
		SELECT	*
		from	bft_encounter_v
		where	nr_atendimento = nr_atendimento_p;
	
BEGIN
	
	json_encounter_w	:= philips_json();
	
	for r_c01 in c01 loop
		begin
		json_encounter_w := encounter_json_pck.add_json_value(json_encounter_w, 'encounterId', r_c01.encounter_id);
		json_encounter_w := encounter_json_pck.add_json_value(json_encounter_w, 'patientId', r_c01.patient_id);
		json_encounter_w := encounter_json_pck.add_json_value(json_encounter_w, 'encounterDoctorId', r_c01.encounter_doctor_id);
		json_encounter_w := encounter_json_pck.add_json_value(json_encounter_w, 'encounterDoctorProviderNum', r_c01.encounter_doctor_provider_num);
		json_encounter_w := encounter_json_pck.add_json_value(json_encounter_w, 'encounterDoctorGivenName', r_c01.encounter_doctor_given_name);
		json_encounter_w := encounter_json_pck.add_json_value(json_encounter_w, 'encounterDoctorLastName', r_c01.encounter_doctor_last_name);
		json_encounter_w := encounter_json_pck.add_json_value(json_encounter_w, 'encounterDoctorMiddleName', r_c01.encounter_doctor_middle_name);
		json_encounter_w := encounter_json_pck.add_json_value(json_encounter_w, 'referredDoctorDoctorId', r_c01.referred_doctor_doctor_id);
		json_encounter_w := encounter_json_pck.add_json_value(json_encounter_w, 'referredDoctorProviderNum', r_c01.referred_doctor_provider_num);
		json_encounter_w := encounter_json_pck.add_json_value(json_encounter_w, 'referredDoctorGivenName', r_c01.referred_doctor_given_name);
		json_encounter_w := encounter_json_pck.add_json_value(json_encounter_w, 'referredDoctorLastName', r_c01.referred_doctor_last_name);
		json_encounter_w := encounter_json_pck.add_json_value(json_encounter_w, 'referredDoctorMiddleName', r_c01.referred_doctor_middle_name);
		json_encounter_w := encounter_json_pck.add_json_value(json_encounter_w, 'referralDate', r_c01.referral_date);
		json_encounter_w := encounter_json_pck.add_json_value(json_encounter_w, 'validityDate', r_c01.validity_date);
		json_encounter_w := encounter_json_pck.add_json_value(json_encounter_w, 'typeEncounterId', r_c01.type_encounter_id);
		json_encounter_w := encounter_json_pck.add_json_value(json_encounter_w, 'patientClass', r_c01.patient_class);
		json_encounter_w := encounter_json_pck.add_json_value(json_encounter_w, 'ICD', r_c01.ICD);
		json_encounter_w := encounter_json_pck.add_json_value(json_encounter_w, 'clinicId', r_c01.clinic_id);
		json_encounter_w := encounter_json_pck.add_json_value(json_encounter_w, 'encouterAdmitDate', r_c01.encouter_admit_date);
		json_encounter_w := encounter_json_pck.add_json_value(json_encounter_w, 'encounterDischargeDate', r_c01.encounter_discharge_date);
		json_encounter_w := encounter_json_pck.add_json_value(json_encounter_w, 'typeDischargeDate', r_c01.type_discharge_date);
		json_encounter_w := encounter_json_pck.add_json_value(json_encounter_w, 'priorLocationId', r_c01.prior_location_id);
		json_encounter_w := encounter_json_pck.add_json_value(json_encounter_w, 'typeHealthInsuranceId', r_c01.type_health_insurance_id);
		json_encounter_w := encounter_json_pck.add_json_value(json_encounter_w, 'establishmentId', r_c01.establishment_id);
		json_encounter_w := encounter_json_pck.add_json_value(json_encounter_w, 'establishmentName', r_c01.establishment_name);
		json_encounter_w := encounter_json_pck.add_json_value(json_encounter_w, 'establishmentPhone', r_c01.establishment_phone);
		json_encounter_w := encounter_json_pck.add_json_value(json_encounter_w, 'healthInsuranceId', r_c01.health_insurance_id);
		json_encounter_w := encounter_json_pck.add_json_value(json_encounter_w, 'insuranceCategoryId', r_c01.insurance_category_id);
		json_encounter_w := encounter_json_pck.add_json_value(json_encounter_w, 'insurancePlanId', r_c01.insurance_plan_id);
		json_encounter_w := encounter_json_pck.add_json_value(json_encounter_w, 'insuranceName', r_c01.insurance_name);
		json_encounter_w := encounter_json_pck.add_json_value(json_encounter_w, 'validityInsuranceStartDate', r_c01.validity_insurance_start_date);
		json_encounter_w := encounter_json_pck.add_json_value(json_encounter_w, 'effectiveInsuranceEndDate', r_c01.effective_insurance_end_date);
		json_encounter_w := encounter_json_pck.add_json_value(json_encounter_w, 'departmentId', r_c01.department_id);
		json_encounter_w := encounter_json_pck.add_json_value(json_encounter_w, 'roomId', r_c01.room_id);
		json_encounter_w := encounter_json_pck.add_json_value(json_encounter_w, 'bedId', r_c01.bed_id);
		json_encounter_w := encounter_json_pck.add_json_value(json_encounter_w, 'prevUnit', r_c01.previous_unit);
		json_encounter_w := encounter_json_pck.add_json_value(json_encounter_w, 'prevComplUnit', r_c01.previous_complement_unit);
		json_encounter_w := encounter_json_pck.add_json_value(json_encounter_w, 'prevPointOfCare', r_c01.previous_point_of_care);
		json_encounter_w := encounter_json_pck.add_json_value(json_encounter_w, 'integrationBedCode', r_c01.integration_bed_code);
		json_encounter_w := encounter_json_pck.add_json_value(json_encounter_w, 'departmentName', r_c01.department_name);
		json_encounter_w := encounter_json_pck.add_json_value(json_encounter_w, 'externalDepartmentId', r_c01.external_department_id);
		json_encounter_w := encounter_json_pck.add_json_value(json_encounter_w, 'insuranceDocumentNumber', r_c01.insurance_document_number);
		json_encounter_w := encounter_json_pck.add_json_value(json_encounter_w, 'userInsuranceCode', r_c01.user_insurance_code);
		json_encounter_w := encounter_json_pck.add_json_value(json_encounter_w, 'insurancePassword', r_c01.insurance_password);
		json_encounter_w := encounter_json_pck.add_json_value(json_encounter_w, 'insuranceCardValidityDate', r_c01.insurance_card_validity_date);
		json_encounter_w := encounter_json_pck.add_json_value(json_encounter_w, 'mainInsuranceDocumentNumber', r_c01.main_insurance_document_number);
		json_encounter_w := encounter_json_pck.add_json_value(json_encounter_w, 'complaintId', r_c01.complaint_id);
		json_encounter_w := encounter_json_pck.add_json_value(json_encounter_w, 'encounterClassificationId', r_c01.encounter_classification_id);
		json_encounter_w := encounter_json_pck.add_json_value(json_encounter_w, 'reAdmissionIndicator', r_c01.re_admission_indicator);
		json_encounter_w := encounter_json_pck.add_json_value(json_encounter_w, 'admissionType', r_c01.admission_type);
		json_encounter_w := encounter_json_pck.add_json_value(json_encounter_w, 'departmentAdmitDate', r_c01.department_admit_date);
		json_encounter_w := encounter_json_pck.add_json_value(json_encounter_w, 'departmentExitDate', r_c01.department_exit_date);
		json_encounter_w := encounter_json_pck.add_json_value(json_encounter_w, 'dischargeDoctorDate', r_c01.discharge_doctor_date);
		json_encounter_w := encounter_json_pck.add_json_value(json_encounter_w, 'encounterStartDate', r_c01.encounter_start_date);
		json_encounter_w := encounter_json_pck.add_json_value(json_encounter_w, 'triageEndDate', r_c01.triage_end_date);
		json_encounter_w := encounter_json_pck.add_json_value(json_encounter_w, 'edLocation', r_c01.ed_location);
		json_encounter_w := encounter_json_pck.add_json_value(json_encounter_w, 'departmentClassificationId', r_c01.department_classification_id);
		json_encounter_w := encounter_json_pck.add_json_value(json_encounter_w, 'encounterCancelationDate', r_c01.encounter_cancelation_date);
		json_encounter_w := encounter_json_pck.add_json_value(json_encounter_w, 'companyId', r_c01.company_id);
		json_encounter_w := encounter_json_pck.add_json_value(json_encounter_w, 'roomBedId', r_c01.room_bed_id);
		json_encounter_w := encounter_json_pck.add_json_value(json_encounter_w, 'roomInternalSequence', r_c01.room_name);
		json_encounter_w := encounter_json_pck.add_json_value(json_encounter_w, 'departmentBuilding', r_c01.department_building);
		json_encounter_w := encounter_json_pck.add_json_value(json_encounter_w, 'departmenFloor', r_c01.departmen_floor);
		json_encounter_w := encounter_json_pck.add_json_value(json_encounter_w, 'pointOfCare', r_c01.point_of_care);
		json_encounter_w := encounter_json_pck.add_json_value(json_encounter_w, 'nrAtendimento', r_c01.nr_atendimento);
		json_encounter_w := encounter_json_pck.add_json_value(json_encounter_w, 'typeScheduleId', r_c01.type_schedule_id);
		json_encounter_w := encounter_json_pck.add_json_value(json_encounter_w, 'scheduleStatusId', r_c01.schedule_status_id);
		json_encounter_w := encounter_json_pck.add_json_value(json_encounter_w, 'notes', r_c01.notes);
		json_encounter_w := encounter_json_pck.add_json_value(json_encounter_w, 'reasonForEncounter', r_c01.reason_for_encounter);
		json_encounter_w := encounter_json_pck.add_json_value(json_encounter_w, 'patientSymptoms', r_c01.patient_symptoms);
		json_encounter_w := encounter_json_pck.add_json_value(json_encounter_w, 'insuranceCompanyId', r_c01.insurance_company_id);
		json_encounter_w := encounter_json_pck.add_json_value(json_encounter_w, 'patientPregnant', r_c01.patient_pregnant);
		json_encounter_w := encounter_json_pck.add_json_value(json_encounter_w, 'patientFasting', r_c01.patient_fasting);
		json_encounter_w := encounter_json_pck.add_json_value(json_encounter_w, 'unitAdmissionNumber', r_c01.unit_admission_number);
		json_encounter_w := encounter_json_pck.add_json_value(json_encounter_w, 'displayedInEpimedView', r_c01.displayed_in_epimed_view);
		json_encounter_w := encounter_json_pck.add_json_value(json_encounter_w, 'lastMenstruationPeriod', r_c01.last_menstruation_period);
		json_encounter_w := encounter_json_pck.add_json_value(json_encounter_w, 'interfaceBedName', r_c01.interface_bed_name);
		json_encounter_w := encounter_json_pck.add_json_value(json_encounter_w, 'doctorCode', r_c01.doctor_code);
		json_encounter_w := encounter_json_pck.add_json_value(json_encounter_w, 'visitNumber', r_c01.visit_number);
		json_encounter_w := encounter_json_pck.add_json_value(json_encounter_w, 'medicalRecordId', r_c01.medical_record_id);
		end;
	end loop;
	
	return json_encounter_w;
	
	END;

$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON FUNCTION encounter_json_pck.get_encounter ( nr_atendimento_p bigint) FROM PUBLIC;