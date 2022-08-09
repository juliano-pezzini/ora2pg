-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE generate_undo_discharge ( nr_episode_p bigint, ie_discharge_p text, --indicates if it is generating the discharge ('A') or undoing it ('E') 
 cd_discharge_process_p bigint, cd_discharge_reason_p bigint, dt_discharge_p timestamp, nm_user_p text, ds_error_p INOUT text, nr_seq_transfer_reason_p bigint, cd_destination_hospital_p text, ds_note_p text, cd_transport_company_p text default null, cd_death_department_p bigint DEFAULT NULL, ie_necropsy_p text DEFAULT NULL, ie_disclose_death_p text DEFAULT NULL, cd_reason_prolonged_stay_p bigint DEFAULT NULL, nm_external_physician_p text DEFAULT NULL, crm_extern_physician_p text DEFAULT NULL) AS $body$
DECLARE

 
cd_department_w			setor_atendimento.cd_setor_atendimento%type;
cd_basic_unit_w			unidade_atendimento.cd_unidade_basica%type;
cd_compl_unit_w			unidade_atendimento.cd_unidade_compl%type;
ds_error_w			varchar(10000);


BEGIN 
if (nr_episode_p IS NOT NULL AND nr_episode_p::text <> '') and (nm_user_p IS NOT NULL AND nm_user_p::text <> '') then 
	 
	-- Generate the discharge 
	ds_error_w := gerar_estornar_alta(	nr_episode_p, ie_discharge_p, cd_discharge_process_p, cd_discharge_reason_p, dt_discharge_p, nm_user_p, ds_error_w, nr_seq_transfer_reason_p, cd_destination_hospital_p, ds_note_p, cd_transport_company_p);
	 
	ds_error_p := ds_error_w;
	 
	-- If there's no erros in the transfer, set the rest of the information 
	if (coalesce(ds_error_w::text, '') = '') then 
		 
	 
		if (ie_necropsy_p IS NOT NULL AND ie_necropsy_p::text <> '') then 
			update	atendimento_paciente 
			set	ie_necropsia	= ie_necropsy_p, 
				nm_usuario	= nm_user_p 
			where	nr_atendimento	= nr_episode_p;
		end if;
		 
		if (ie_disclose_death_p IS NOT NULL AND ie_disclose_death_p::text <> '') then 
			update	atendimento_paciente 
			set	ie_divulgar_obito	= ie_disclose_death_p, 
				nm_usuario		= nm_user_p 
			where	nr_atendimento		= nr_episode_p;
		end if;
		 
		if (cd_death_department_p IS NOT NULL AND cd_death_department_p::text <> '') then 
			update	atendimento_paciente 
			set	cd_setor_obito		= cd_death_department_p, 
				nm_usuario		= nm_user_p 
			where	nr_atendimento		= nr_episode_p;
		end if;
		 
		if (cd_reason_prolonged_stay_p IS NOT NULL AND cd_reason_prolonged_stay_p::text <> '') then 
			cd_department_w	:= obter_unidade_atendimento(nr_episode_p,'A','CS');
			cd_basic_unit_w	:= obter_unidade_atendimento(nr_episode_p,'A','UB');
			cd_compl_unit_w	:= obter_unidade_atendimento(nr_episode_p,'A','UC');
			 
			CALL inserir_motivo_permanencia( 
				nm_user_p, 
				nr_episode_p, 
				cd_department_w, 
				cd_basic_unit_w, 
				cd_compl_unit_w, 
				cd_reason_prolonged_stay_p);
		end if;
		 
		if (nm_external_physician_p IS NOT NULL AND nm_external_physician_p::text <> '') and (crm_extern_physician_p IS NOT NULL AND crm_extern_physician_p::text <> '')then 
			CALL atualiza_medico_externo(nm_external_physician_p, 
						crm_extern_physician_p, 
						nr_episode_p, 
						nm_user_p);
		end if;	
	end if;
end if;
 
commit;
 
end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE generate_undo_discharge ( nr_episode_p bigint, ie_discharge_p text, cd_discharge_process_p bigint, cd_discharge_reason_p bigint, dt_discharge_p timestamp, nm_user_p text, ds_error_p INOUT text, nr_seq_transfer_reason_p bigint, cd_destination_hospital_p text, ds_note_p text, cd_transport_company_p text default null, cd_death_department_p bigint DEFAULT NULL, ie_necropsy_p text DEFAULT NULL, ie_disclose_death_p text DEFAULT NULL, cd_reason_prolonged_stay_p bigint DEFAULT NULL, nm_external_physician_p text DEFAULT NULL, crm_extern_physician_p text DEFAULT NULL) FROM PUBLIC;
