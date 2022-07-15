-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';



--
-- dblink wrapper to call function patient_swap_tie as an autonomous transaction
--
CREATE EXTENSION IF NOT EXISTS dblink;

CREATE OR REPLACE PROCEDURE patient_swap_tie ( nm_usuario_p text, nr_atendimento_p bigint, nr_atendimento_troca_p bigint) AS $body$
DECLARE
	-- Change this to reflect the dblink connection string
	v_conn_str  text := format('port=%s dbname=%s user=%s', current_setting('port'), current_database(), current_user);
	v_query     text;

BEGIN
	v_query := 'CALL patient_swap_tie_atx ( ' || quote_nullable(nm_usuario_p) || ',' || quote_nullable(nr_atendimento_p) || ',' || quote_nullable(nr_atendimento_troca_p) || ' )';
	PERFORM * FROM dblink(v_conn_str, v_query) AS p (ret boolean);

END;
$body$ LANGUAGE plpgsql SECURITY DEFINER;




CREATE OR REPLACE PROCEDURE patient_swap_tie_atx ( nm_usuario_p text, nr_atendimento_p bigint, nr_atendimento_troca_p bigint) AS $body$
DECLARE


cd_setor_atendimento_w		SETOR_ATENDIMENTO.DS_SETOR_ATENDIMENTO%type;
cd_unidade_basica_w		UNIDADE_ATENDIMENTO.cd_unidade_basica%type;	
cd_unidade_compl_w		UNIDADE_ATENDIMENTO.cd_unidade_compl%type;	
cd_setor_atendimento_troca_w	SETOR_ATENDIMENTO.DS_SETOR_ATENDIMENTO%type;
cd_unidade_basica_troca_w	UNIDADE_ATENDIMENTO.cd_unidade_basica%type;	
cd_unidade_compl_troca_w	UNIDADE_ATENDIMENTO.cd_unidade_compl%type;	
cd_pessoa_fisica_w		atendimento_paciente.cd_pessoa_fisica%type;	
cd_pessoa_fisica_w2		atendimento_paciente.cd_pessoa_fisica%type;	
cd_estabelecimento_w2	atendimento_paciente.cd_estabelecimento%type;
nr_seq_atepacu_atend_w		bigint;
nr_seq_atepacu_atend_troca_w	bigint;
json_w        philips_json;
json_w2        philips_json;
json_data_w   text;
jobno bigint;
nm_event varchar(50) := 'patient.swap.monitor';

medical_record_id_w pessoa_fisica.nr_prontuario%type;
patient_name_w pessoa_fisica.nm_pessoa_fisica%type;
patient_given_name_w pessoa_fisica.nm_pessoa_fisica%type;
patient_last_name_w pessoa_fisica.nm_pessoa_fisica%type;
patient_middle_name_w pessoa_fisica.nm_pessoa_fisica%type;

c01 CURSOR FOR
SELECT	a.nr_prontuario medical_record_id,
    obter_dados_pf(a.cd_pessoa_fisica,'PNC') patient_name,
    obter_dados_pf(a.cd_pessoa_fisica,'PNG') patient_given_name,
    obter_dados_pf(a.cd_pessoa_fisica,'PNL') patient_last_name,
    obter_dados_pf(a.cd_pessoa_fisica,'PNM') patient_middle_name,
    substr(obter_compl_pf(a.cd_pessoa_fisica,'5','N'),1,60) mother_name,
    substr(obter_parte_nome_pf(obter_compl_pf(a.cd_pessoa_fisica,'5','N'), 'nome'), 1, 60) mother_given_name,
    substr(obter_parte_nome_pf(obter_compl_pf(a.cd_pessoa_fisica,'5','N'), 'sobrenome'), 1, 60) mother_last_name,
	substr(obter_parte_nome_pf(obter_compl_pf(a.cd_pessoa_fisica,'5','N'), 'restonome'), 1, 60) mother_middle_name,
	a.ie_sexo sex_id,
    to_char(a.dt_nascimento,'YYYY-MM-DD') date_of_birth
from pessoa_fisica a
where a.cd_pessoa_fisica = cd_pessoa_fisica_w2;
BEGIN

		select max(cd_pessoa_fisica)
		into STRICT cd_pessoa_fisica_w
		from atendimento_paciente
		where nr_atendimento = nr_atendimento_p;

		select max(cd_pessoa_fisica), max(cd_estabelecimento)
		into STRICT cd_pessoa_fisica_w2, cd_estabelecimento_w2
		from atendimento_paciente
		where nr_atendimento = nr_atendimento_troca_p;

		nr_seq_atepacu_atend_w :=	coalesce(obter_atepacu_paciente(nr_atendimento_p, 'A'),-1);
		nr_seq_atepacu_atend_troca_w := coalesce(obter_atepacu_paciente(nr_atendimento_troca_p, 'A'),-1);
	
		begin
			select replace(coalesce(Obter_point_of_care(a.cd_setor_atendimento,a.cd_unidade_basica,a.cd_unidade_compl),'Sem unidade'),'''','"'),
				a.cd_unidade_basica,
				a.cd_unidade_compl
			into STRICT	cd_setor_atendimento_w,
				cd_unidade_basica_w,
				cd_unidade_compl_w
			from	atend_paciente_unidade a
			where	a.nr_seq_interno = nr_seq_atepacu_atend_w;
		exception when no_data_found or too_many_rows then
				raise;
		end;
		
		begin
			select 	replace(coalesce(Obter_point_of_care(a.cd_setor_atendimento,a.cd_unidade_basica,a.cd_unidade_compl), 'Sem unidade'),'''','"'),
					a.cd_unidade_basica,
					a.cd_unidade_compl
			into STRICT	cd_setor_atendimento_troca_w,
					cd_unidade_basica_troca_w,
					cd_unidade_compl_troca_w
			from	atend_paciente_unidade a
			where	a.nr_seq_interno = nr_seq_atepacu_atend_troca_w;
			exception when no_data_found or too_many_rows then
				raise;
		end;

	begin
	select	a.nr_prontuario medical_record_id,
				obter_dados_pf(a.cd_pessoa_fisica,'PNC') patient_name,
				obter_dados_pf(a.cd_pessoa_fisica,'PNG') patient_given_name,
				obter_dados_pf(a.cd_pessoa_fisica,'PNL') patient_last_name,
				obter_dados_pf(a.cd_pessoa_fisica,'PNM') patient_middle_name
				into STRICT medical_record_id_w,
					patient_name_w,
					patient_given_name_w,
					patient_last_name_w,
					patient_middle_name_w
			from pessoa_fisica a
			where a.cd_pessoa_fisica = cd_pessoa_fisica_w;
	exception when no_data_found or too_many_rows then
		raise;
	end;

		for c01_w in c01 loop
			json_w := philips_json();
			json_w.put('patientId', cd_pessoa_fisica_w2);
			json_w.put('medicalRecordId', c01_w.medical_record_id);
			json_w.put('patientName', c01_w.patient_name);
			json_w.put('patientGivenName', c01_w.patient_given_name);
			json_w.put('patientLastName', c01_w.patient_last_name);
			json_w.put('patientMiddleName', c01_w.patient_middle_name);
			json_w.put('motherName', c01_w.mother_name);
			json_w.put('motherGivenName', c01_w.mother_given_name);
			json_w.put('motherMiddleName', c01_w.mother_last_name);
			json_w.put('motherLastName', c01_w.mother_middle_name);
			json_w.put('sexId', c01_w.sex_id);
			json_w.put('dateOfBirth', c01_w.date_of_birth);
			json_w.put('encounterId', nr_atendimento_troca_p);
			json_w.put('typeEncounterId', obter_tipo_atendimento(nr_atendimento_troca_p));
			json_w.put('pointOfCare2',cd_setor_atendimento_troca_w );
			json_w.put('roomId2', cd_unidade_basica_troca_w);
			json_w.put('bedId2', cd_unidade_compl_troca_w);
			json_w.put('establishmentId', cd_estabelecimento_w2);

			json_w.put('patientId2', cd_pessoa_fisica_w);
			json_w.put('encounterId2', nr_atendimento_p);
			json_w.put('medicalRecordId2', medical_record_id_w);
			json_w.put('patientName2', patient_name_w);
			json_w.put('patientGivenName2', patient_given_name_w);
			json_w.put('patientLastName2', patient_last_name_w);
			json_w.put('patientMiddleName2', patient_middle_name_w);
			json_w.put('pointOfCare', cd_setor_atendimento_w);
			json_w.put('roomId', cd_unidade_basica_w);
			json_w.put('bedId', cd_unidade_compl_w);

			json_w2 := philips_json();
			json_w2.PUT('patientVisit', json_w);
			dbms_lob.createtemporary(json_data_w, true);
			json_w2.(json_data_w);
			
		end loop;

		dbms_job.submit(jobno, 'declare results clob; begin results := bifrost.send_integration_content('''|| nm_event || ''', ''' || json_data_w || ''', ''' || nm_usuario_p ||'''); end;');

commit;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE patient_swap_tie ( nm_usuario_p text, nr_atendimento_p bigint, nr_atendimento_troca_p bigint) FROM PUBLIC; -- REVOKE ALL ON PROCEDURE patient_swap_tie_atx ( nm_usuario_p text, nr_atendimento_p bigint, nr_atendimento_troca_p bigint) FROM PUBLIC;

