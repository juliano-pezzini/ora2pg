-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';




CREATE OR REPLACE PROCEDURE dpc_pkg.generate_pat_dpc_diag (nr_seq_patient_dpc_p bigint, nm_usuario_p text) AS $body$
DECLARE


nr_seq_interno_w 	bigint;
cd_icd_w 		varchar(10);
cd_icd2_w 		varchar(10);
nr_seq_pat_w 		bigint;
nr_atendimento_w	numeric(22);
nr_seq_pat_dpc_w 	bigint;
nr_disease_number_w             icd_codes_main_jpn.nr_disease_number%type;
si_main_w                       patient_dpc_diagnosis.si_main%type;
si_for_hospitalization_w        patient_dpc_diagnosis.si_for_hospitalization%type;

c01 CURSOR FOR
	SELECT  a.cd_doenca cd_icd,
		a.nr_seq_interno,
                a.nr_seq_disease_number nr_disease_number,
                CASE WHEN ie_diag_princ_depart='S' THEN  'Y'  ELSE 'N' END  si_main,
                CASE WHEN ie_diag_admissao='S' THEN  'Y'  ELSE 'N' END  si_for_hospitalization
	from    diagnostico_doenca a
	where   a.nr_atendimento    = nr_atendimento_w
	and    	(a.dt_liberacao IS NOT NULL AND a.dt_liberacao::text <> '')
	and    	coalesce(a.ie_situacao,'A') = 'A';
c02 CURSOR FOR
	SELECT  b.cd_doenca cd_icd_2,
		a.nr_sequencia nr_seq_pat
	from    patient_dpc_diagnosis a,
		diagnostico_doenca b
	where   a.nr_seq_patient_dpc    = nr_seq_patient_dpc_p
	and    	b.nr_seq_interno     = a.nr_seq_diagnosis
	and    	a.nr_sequencia <> nr_seq_pat_dpc_w;


BEGIN

select 	nr_atendimento
into STRICT 	nr_atendimento_w
from 	patient_dpc
where   nr_sequencia = nr_seq_patient_dpc_p;

	open c01;
	loop
	fetch c01 into
	cd_icd_w,nr_seq_interno_w,nr_disease_number_w,si_main_w,si_for_hospitalization_w;
	EXIT WHEN NOT FOUND; /* apply on c01 */

	if (cd_icd_w IS NOT NULL AND cd_icd_w::text <> '') then
		begin
			select nextval('patient_dpc_diagnosis_seq')
			into STRICT nr_seq_pat_dpc_w	
			;
			
			insert into patient_dpc_diagnosis(nr_sequencia,
				dt_atualizacao,
				nm_usuario,
				nr_seq_patient_dpc,
				nr_seq_diagnosis,
				si_main,
				si_for_hospitalization,
				si_second_most_expensive,
				si_sub_disease,
				si_comorbidity_before,
				si_after_admission,
				si_psychosomatic_disorder,
				si_cause_of_death,
                                nr_disease_number,
                                cd_icd_sub_icd)
				VALUES (	nr_seq_pat_dpc_w,
					clock_timestamp(),
					nm_usuario_p,
					nr_seq_patient_dpc_p,
					nr_seq_interno_w,
					si_main_w,
					si_for_hospitalization_w,
					'N',
					'N',
					'N',
					'N',
					'N',
					'N',
                                        nr_disease_number_w,
                                        to_char(nr_disease_number_w) || '-1');
		
			open c02;
			loop
			fetch c02 into
			cd_icd2_w,nr_seq_pat_w;
			EXIT WHEN NOT FOUND; /* apply on c02 */
			if (cd_icd2_w = cd_icd_w) then
			
					delete from patient_dpc_diagnosis where nr_sequencia = nr_seq_pat_w;
			
			end if;	
			end loop;
			close c02;
		end;
	end if;

    end loop;
    close c01;
commit;

end;


$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE dpc_pkg.generate_pat_dpc_diag (nr_seq_patient_dpc_p bigint, nm_usuario_p text) FROM PUBLIC;