-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';



	/**
	+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
	Common header used for carestream outbound message
	+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
	**/
CREATE OR REPLACE PROCEDURE carestream_japan_l10n_pck.carestream_header (unique_key_p text, message_type_p text, receiver_code_p text , processing_type_p text, message_data_p INOUT text, patient_id_p INOUT text , encounter_id_p INOUT text, proc_hor_sequence_p bigint, procedimento_sequence_p bigint ) AS $body$
DECLARE


    	c01 CURSOR FOR
        SELECT  a.dt_horario  release_date,
                obter_dados_prescricao(a.nr_prescricao , 'A' ) encounter_id,
                obter_dados_prescricao(a.nr_prescricao , 'P' ) patient_id
        from prescr_proc_hor a
        where a.nr_prescricao = unique_key_p 
        and a.nr_sequencia = proc_hor_sequence_p
        and a.nr_seq_procedimento = procedimento_sequence_p  LIMIT 1;

		c12 CURSOR FOR
        SELECT  a.dt_atualizacao update_date,
				m.encounter_id  encounter_id
		from pessoa_fisica a ,
			(SELECT max(nr_atendimento) encounter_id 
			from atendimento_paciente 
			where  cd_pessoa_fisica = unique_key_p) m
		where a.cd_pessoa_fisica = unique_key_p  LIMIT 1;
	
BEGIN
		PERFORM set_config('carestream_japan_l10n_pck.ds_line_w', null, false);
		CALL CALL CALL CALL CALL CALL CALL CALL CALL CALL carestream_japan_l10n_pck.append_text(message_type_p,2,'L'); --DENBUN_SYBT
		CALL CALL CALL CALL CALL CALL CALL CALL CALL CALL carestream_japan_l10n_pck.append_text(to_char(clock_timestamp(),'YYYYMMDD'),8,'L'); --SAKUSEI_DATE
		CALL CALL CALL CALL CALL CALL CALL CALL CALL CALL carestream_japan_l10n_pck.append_text(to_char(clock_timestamp(),'HH24MISS'),6,'L'); --SAKUSEI_TIME
		CALL CALL CALL CALL CALL CALL CALL CALL CALL CALL carestream_japan_l10n_pck.append_text('AB',2,'L'); --S_SYS_CD
		CALL CALL CALL CALL CALL CALL CALL CALL CALL CALL carestream_japan_l10n_pck.append_text(receiver_code_p,2,'L'); --S_SYS_CD
		CALL CALL CALL CALL CALL CALL CALL CALL CALL CALL carestream_japan_l10n_pck.append_text(1,8,'L','0');
		CALL CALL CALL CALL CALL CALL CALL CALL CALL CALL carestream_japan_l10n_pck.append_text(processing_type_p,1,'R',0); --SYORI_KBN
		if (message_type_p in ('1D', '3E', '3F')) then
			for r_c01 in c01 loop
				begin
					encounter_id_p := r_c01.encounter_id;
					patient_id_p := r_c01.patient_id;
					CALL CALL CALL CALL CALL CALL CALL CALL CALL CALL carestream_japan_l10n_pck.append_text(to_char(r_c01.release_date,'YYYYMMDD'), 8); --SYORI_DATE
					CALL CALL CALL CALL CALL CALL CALL CALL CALL CALL carestream_japan_l10n_pck.append_text(to_char(r_c01.release_date,'HH24MISS'), 6); --SYORI_TIME
				end;
			end loop;

		elsif (message_type_p in ('3G', '1G')) then
			for r_c12 in c12 loop
				begin
					encounter_id_p := r_c12.encounter_id;
					patient_id_p := unique_key_p;
					CALL CALL CALL CALL CALL CALL CALL CALL CALL CALL carestream_japan_l10n_pck.append_text(to_char(r_c12.update_date,'YYYYMMDD'), 8); --SYORI_DATE
					CALL CALL CALL CALL CALL CALL CALL CALL CALL CALL carestream_japan_l10n_pck.append_text(to_char(r_c12.update_date,'HH24MISS'), 6); --SYORI_TIME
				end;
			end loop;
		end if;

		message_data_p := current_setting('carestream_japan_l10n_pck.ds_line_w')::varchar(32767);

	END;

$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE carestream_japan_l10n_pck.carestream_header (unique_key_p text, message_type_p text, receiver_code_p text , processing_type_p text, message_data_p INOUT text, patient_id_p INOUT text , encounter_id_p INOUT text, proc_hor_sequence_p bigint, procedimento_sequence_p bigint ) FROM PUBLIC;