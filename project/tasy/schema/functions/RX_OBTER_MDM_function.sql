-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION rx_obter_mdm ( cd_pessoa_fisica_p text, nr_seq_rxt_tumor_p bigint, nm_usuario_lib_p text) RETURNS varchar AS $body$
DECLARE


dt_nascimento_w					varchar(16);
family_name_patient_w         	varchar(100);
given_name_patient_w          	varchar(100);
middleinitialorname_patient_w 	varchar(100);
patient_class_w					varchar(20);
facility_w 						varchar(100);
id_doctor_w 					varchar(10);
family_name_doctor_pep_w 		varchar(100);
given_name_doctor_pep_w 		varchar(100);
middlename_doctor_pep_w 		varchar(100);
dt_message_w                	varchar(14);
hl7_itens_varian_seq_w			numeric(38);
nr_prontuario_w 				bigint;


BEGIN

declare
	json_aux_w   philips_json;
	ds_message_w text;


begin
	json_aux_w := philips_json();

	select 	to_char(obter_data_nascto_pf(cd_pessoa_fisica_p), 'yyyymmdd'),
		substr(elimina_acentuacao(obter_parte_nome_pf(obter_nome_pf(cd_pessoa_fisica_p),'sobrenome')), 1, 100) family_name_patient,
		substr(elimina_acentuacao(obter_parte_nome_pf(obter_nome_pf(cd_pessoa_fisica_p),'nome')), 1, 100) given_name_patient, 
		substr(elimina_acentuacao(obter_parte_nome_pf(obter_nome_pf(cd_pessoa_fisica_p),'restonome')), 1, 100) middleinitialorname_patient
	into STRICT	dt_nascimento_w,
		family_name_patient_w,
		given_name_patient_w,
		middleinitialorname_patient_w
	;

	select	'I' ,
		substr(elimina_acentuacao(a.facility),1,255),   
		cd_medico,   
		substr(elimina_acentuacao(obter_parte_nome_pf(a.nome_medico_pf_pep,'sobrenome')), 1, 64),    
		substr(elimina_acentuacao(obter_parte_nome_pf(a.nome_medico_pf_pep,'nome')), 1, 64),    
		substr(elimina_acentuacao(obter_parte_nome_pf(a.nome_medico_pf_pep,'restonome')), 1, 64)
	into STRICT 	patient_class_w,
		facility_w,
		id_doctor_w,
		family_name_doctor_pep_w,
		given_name_doctor_pep_w,
		middlename_doctor_pep_w
	from (SELECT b.nr_sequencia,    
		obter_desc_setor_atend(obter_setor_atendimento(b.nr_atendimento)) point_of_care,    
		obter_unidade_atendimento(b.nr_atendimento, 'A', 'U') room,    
		obter_unidade_atendimento(b.nr_atendimento, 'A', 'UC') bed,    
		b.cd_estabelecimento facility,    
		obter_nome_pf(b.cd_medico) nome_medico_pf_pep,    
		obter_nome_pf(c.cd_medico_resp) nome_medico_pf_eup,    
		b.nr_atendimento, 
		b.cd_medico   
	FROM rxt_tumor b
LEFT OUTER JOIN atendimento_paciente c ON (b.nr_atendimento = c.nr_atendimento) ) a    
	where	a.nr_sequencia = nr_seq_rxt_tumor_p;

	select	to_char(clock_timestamp(), 'YYYYMMDDHH24MISS')
	into STRICT	dt_message_w
	;

	select	nextval('hl7_itens_varian_seq')
	into STRICT	hl7_itens_varian_seq_w
	;

	select	max(nr_prontuario)
	into STRICT	nr_prontuario_w
	from	pessoa_fisica
	where	cd_pessoa_fisica = cd_pessoa_fisica_p;

	json_aux_w.put('PatientIDNumber', cd_pessoa_fisica_p);	
	json_aux_w.put('DateTimeofBirth', dt_nascimento_w);	
	json_aux_w.put('PatientSurname',family_name_patient_w);				
	json_aux_w.put('PatientGivenName',given_name_patient_w);	
	json_aux_w.put('SecondAndFurtherGivenNames',middleinitialorname_patient_w);	
	json_aux_w.put('Facility',coalesce(facility_w,''));
	json_aux_w.put('AttendingDoctorID',coalesce(id_doctor_w,''));
	json_aux_w.put('AttendingDoctorSurname',coalesce(family_name_doctor_pep_w,''));
	json_aux_w.put('AttendingDoctorGivenName',coalesce(given_name_doctor_pep_w,''));
	json_aux_w.put('SecondAndFurtherGivenNamesDoctor',coalesce(middlename_doctor_pep_w,''));
	json_aux_w.put('PatientClass',coalesce(patient_class_w,''));
	json_aux_w.put('AssignedDocumentAuthenticatorGivenName',coalesce(NM_USUARIO_LIB_P,''));
	json_aux_w.put('EntityIdentifier','RXT_TRATAMENTO_' || nr_seq_rxt_tumor_p);
	json_aux_w.put('DateTimeOfMessage', dt_message_w);
	json_aux_w.put('MessageControlID', hl7_itens_varian_seq_w);
	json_aux_w.put('IDNumber', nr_prontuario_w);

	dbms_lob.createtemporary(ds_message_w, TRUE);
	json_aux_w.(ds_message_w);

	return ds_message_w;
	end;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION rx_obter_mdm ( cd_pessoa_fisica_p text, nr_seq_rxt_tumor_p bigint, nm_usuario_lib_p text) FROM PUBLIC;

