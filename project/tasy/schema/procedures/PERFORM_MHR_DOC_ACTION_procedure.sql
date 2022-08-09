-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';



--
-- dblink wrapper to call function perform_mhr_doc_action as an autonomous transaction
--
CREATE EXTENSION IF NOT EXISTS dblink;

CREATE OR REPLACE PROCEDURE perform_mhr_doc_action ( nr_seq_mhr_doc_p mhr_doc_meta.nr_sequencia%TYPE default null, cd_pessoa_fisica_p mhr_doc_meta.cd_pessoa_fisica%TYPE  DEFAULT NULL, nr_atendimento_p mhr_doc_meta.nr_atendimento%TYPE  DEFAULT NULL, nm_usuario_p mhr_doc_meta.nm_usuario%TYPE default null, ie_doc_type_p mhr_doc_meta.ie_doc_type%TYPE default null, cd_doc_tasy_p mhr_doc_meta.cd_doc_tasy%TYPE default null, ds_justificativa_p mhr_doc_meta.ds_justificativa%type default null, ie_action_p text  DEFAULT NULL, ds_other_params_p text default null) AS $body$
DECLARE
	-- Change this to reflect the dblink connection string
	v_conn_str  text := format('port=%s dbname=%s user=%s', current_setting('port'), current_database(), current_user);
	v_query     text;

BEGIN
	v_query := 'CALL perform_mhr_doc_action_atx ( ' || quote_nullable(nr_seq_mhr_doc_p) || ',' || quote_nullable(cd_pessoa_fisica_p) || ',' || quote_nullable(nr_atendimento_p) || ',' || quote_nullable(nm_usuario_p) || ',' || quote_nullable(ie_doc_type_p) || ',' || quote_nullable(cd_doc_tasy_p) || ',' || quote_nullable(ds_justificativa_p) || ',' || quote_nullable(ie_action_p) || ',' || quote_nullable(ds_other_params_p) || ' )';
	PERFORM * FROM dblink(v_conn_str, v_query) AS p (ret boolean);

END;
$body$ LANGUAGE plpgsql SECURITY DEFINER;




CREATE OR REPLACE PROCEDURE perform_mhr_doc_action_atx ( nr_seq_mhr_doc_p mhr_doc_meta.nr_sequencia%TYPE default null, cd_pessoa_fisica_p mhr_doc_meta.cd_pessoa_fisica%TYPE  DEFAULT NULL, nr_atendimento_p mhr_doc_meta.nr_atendimento%TYPE  DEFAULT NULL, nm_usuario_p mhr_doc_meta.nm_usuario%TYPE default null, ie_doc_type_p mhr_doc_meta.ie_doc_type%TYPE default null, cd_doc_tasy_p mhr_doc_meta.cd_doc_tasy%TYPE default null, ds_justificativa_p mhr_doc_meta.ds_justificativa%type default null, ie_action_p text  DEFAULT NULL, ds_other_params_p text default null) AS $body$
DECLARE


ie_status_w					mhr_doc_meta.ie_status%TYPE;
ie_origin_mhr_w				mhr_doc_meta.ie_origin_mhr%TYPE;
cd_doc_mhr_w				mhr_doc_meta.cd_doc_mhr%TYPE;
ie_upload_w					mhr_doc_meta.ie_upload%TYPE;
cd_version_w				mhr_doc_meta.cd_version%TYPE;
ie_doc_type_w				mhr_doc_meta.ie_doc_type%TYPE;
ds_params_w					varchar(5000);
nr_atendimento_w			mhr_doc_meta.nr_atendimento%TYPE;
nr_seq_mhr_doc_w			mhr_doc_meta.nr_sequencia%TYPE;

nr_seq_person_ihi_w			mhr_access_record.nr_seq_person_ihi%TYPE;
dt_last_access_w			mhr_access_record.dt_last_access%TYPE;

nr_person_ihi_w				person_ihi.nr_ihi%TYPE;
nr_provider_hpi_w			person_ihi.nr_ihi%TYPE;
dt_ihi_atualizacao_w		person_ihi.dt_atualizacao%TYPE;

nm_provider_name_w			varchar(100);
cd_estabelecimento_w		smallint;

ds_parameters_w				varchar(1000);
cd_integration_w			bigint;

ds_params_supersede_w		varchar(5000);
ds_param_validate_w     varchar(20);

nr_resp_medico_hpi_w    person_ihi.nr_ihi%type;
dt_assignment_ihi_w     person_ihi.dt_atualizacao%type;
dt_assignment_hpi_w     person_ihi.dt_atualizacao%type;
nr_seq_mhr_doc_supersede_w	mhr_doc_meta.nr_sequencia%TYPE;
dt_assignment_resp_hpi_w   person_ihi.dt_atualizacao%type;
cd_pessoa_logged_user_w    mhr_doc_meta.cd_pessoa_fisica%type;
nr_seq_person_hpi_w        mhr_access_record.nr_seq_person_ihi%type;

cd_medico_resp_user_w     mhr_doc_meta.cd_pessoa_fisica%type;
nr_seq_person_resp_hpi_w  mhr_access_record.nr_seq_person_ihi%type;

ie_person_hpi_valid_w     bigint := 1;
ie_person_ihi_valid_w     bigint := 1;
ie_mhr_withdrawn_consent  varchar(20);
BEGIN

/*
ie_action_p - values
	UP - Upload
	DN - Download
	RM - Remove from MHR
	SC - Supercede
	CF - Create report file
	RF - Refresh / Sync with MHR
	PE - PECHR exist in MHR
	VI - Validate IHI and HPI
*/


	-- check for mandatory inputs.
	if (cd_pessoa_fisica_p IS NOT NULL AND cd_pessoa_fisica_p::text <> '') and (nm_usuario_p IS NOT NULL AND nm_usuario_p::text <> '') and (ie_action_p IS NOT NULL AND ie_action_p::text <> '') then

		-- Get IHI number for selected patient
        select  max(nr_sequencia),
                max(nr_ihi),
                max(dt_atualizacao),
                max(dt_assignment)
		into STRICT    nr_seq_person_ihi_w,
                nr_person_ihi_w,
                dt_ihi_atualizacao_w,
                dt_assignment_ihi_w
        from    person_ihi
        where   cd_pessoa_fisica = cd_pessoa_fisica_p
                and ie_situacao        = 'A'
                and ie_data_type       = 'I'
                and ie_record_status   = 'V'
                and ie_conflict       <> 'S';
		
		
		-- Get HPI-I number, establishment and name for logged in user
        select  get_person_ihi(obter_pf_usuario(nm_usuario_p, 'C'), 'P'),
                obter_pf_usuario(nm_usuario_p, 'N'),
                wheb_usuario_pck.get_cd_estabelecimento(),
                obter_pf_usuario(nm_usuario_p, 'C')
          into STRICT  nr_provider_hpi_w,
                nm_provider_name_w,
                cd_estabelecimento_w,
                cd_pessoa_logged_user_w
;

         select max(nr_sequencia),
                max(nr_ihi),
                max(dt_assignment)
         into STRICT   nr_seq_person_hpi_w,
                nr_provider_hpi_w,
                dt_assignment_hpi_w
         from   person_ihi
         where nr_ihi         = nr_provider_hpi_w
               and ie_situacao      = 'A'
               and ie_data_type     = 'P'
               and ie_conflict     <> 'S';
               
        -- Get HPI number of Responsible Physician of Encounter to download/sync with MHR after creating encounter
        if (ie_action_p = 'RF' and ds_other_params_p = 'RFPR'  
            and coalesce(nr_provider_hpi_w::text, '') = '' ) then
            
            select  max(nr_ihi) ,
                    max(cd_pessoa_fisica),
                    max(nr_sequencia),
                    max(dt_assignment)
             into STRICT   nr_resp_medico_hpi_w ,
                    cd_medico_resp_user_w ,
                    nr_seq_person_resp_hpi_w,
                    dt_assignment_resp_hpi_w
             from   person_ihi
             where  cd_pessoa_fisica =( SELECT cd_medico_resp
                                          from atendimento_paciente
                                          where nr_atendimento = nr_atendimento_p
                                       )
                    and ie_situacao      = 'A'
                    and ie_data_type     = 'P'
                    and ie_conflict     <> 'S';
         end if;

		-- pre condition check before proceed

		--Getting the patient withdrawn consent
        select get_mhr_withdraw_consent(nr_atendimento_p) into STRICT ie_mhr_withdrawn_consent;

        if ((nr_seq_mhr_doc_p IS NOT NULL AND nr_seq_mhr_doc_p::text <> '') and ie_mhr_withdrawn_consent = 'S' and (ie_action_p = 'UP' or ie_action_p = 'SC')) then
          CALL insert_mhr_audit_log( nm_usuario_p , cd_pessoa_fisica_p, nr_seq_person_ihi_w , 
                                'N' , 'F' , 'OT', 'ITI-41 Provide & Register Document Set-b', 
                                'The patient does not allow to upload data to My Health Record.'|| chr(10) || 
                                'Patient has added withdrawn consent.'|| chr(10) || 'Please verify with patient.', 
                                null , 'TASY_ERROR_PAITIENT_CONSENT' , 
                                obter_desc_exp_idioma(967072,wheb_usuario_pck.get_nr_seq_idioma()), nr_seq_mhr_doc_p );
			if (ie_action_p = 'UP') then
				CALL withdraw_mhr_doc(nr_seq_mhr_doc_p,obter_desc_exp_idioma(967072,wheb_usuario_pck.get_nr_seq_idioma()), 'S');
			elsif (ie_action_p = 'SC') then
            CALL wheb_mensagem_pck.exibir_mensagem_abort(1114167);
			end if;
			commit;return;

        elsif (ie_action_p = 'RF' or ie_action_p = 'PE') then
           CALL update_mhr_access_record(nm_usuario_p, cd_pessoa_fisica_p, nr_seq_person_ihi_w, 'P', 'OT');
        end if;
	
	    -- Obtaining the value for valid HPI and IHI number
        ds_param_validate_w := obter_param_usuario(281, 1565, obter_perfil_ativo, nm_usuario_p, wheb_usuario_pck.get_cd_estabelecimento(), ds_param_validate_w);

        -- Validating IHI 
        if(coalesce(nr_person_ihi_w::text, '') = '' or length(nr_person_ihi_w) <> 16 or 
            ((dt_assignment_ihi_w + (ds_param_validate_w/24)) < clock_timestamp())) then
          
            ie_person_ihi_valid_w := 0;
        end if;

        if((((nr_seq_mhr_doc_p IS NOT NULL AND nr_seq_mhr_doc_p::text <> '')  and ie_action_p <> 'CF') or ie_action_p = 'RF' or ie_action_p = 'VI') and 
            ie_person_ihi_valid_w = 0 and coalesce(ds_other_params_p,'NULL') <>'RFPR') then 
            
            CALL wheb_mensagem_pck.exibir_mensagem_abort(1108691);
            commit;return;
            
        elsif ((coalesce(ds_other_params_p,'NULL') ='RFPR' or ie_action_p = 'PE') and 
              ie_person_ihi_valid_w = 0) then
              
              CALL insert_mhr_audit_log( nm_usuario_p , cd_pessoa_fisica_p, nr_seq_person_ihi_w , 
                                    'N' , 'F' , 'OT', 
                                    'DownloadDocument:ITI-43 Retrieve Document Set', 
                                    'Selected Patient does not have valid IHI (Individual Health Identifier) number.'|| chr(10) || 
                                    'Please validate the Patient details in Mater person index and validate the IHI number.'|| chr(10) ||
                                    'Please make sure the IHI number is validated recently and doesn''t have any conflicts'|| chr(10) ||
                                    'Patient Code-'|| cd_pessoa_fisica_p|| chr(10) ||
                                    'Patient IHI-' || nr_person_ihi_w,
                                     null , 'TASY_ERROR_IHI' , 
                                     obter_desc_exp_idioma(962755,wheb_usuario_pck.get_nr_seq_idioma()), 
                                     nr_seq_mhr_doc_p );
              commit; return;
        end if;

        -- Validating HPI value
        if((coalesce(nr_provider_hpi_w::text, '') = '' or length(nr_provider_hpi_w) <> 16 or 
             (dt_assignment_hpi_w + (ds_param_validate_w/24)) < clock_timestamp() ) or 
           (coalesce(ds_other_params_p,'NULL') ='RFPR' and 
             (coalesce(nr_resp_medico_hpi_w::text, '') = '' or length(nr_resp_medico_hpi_w) <> 16 or 
               (dt_assignment_resp_hpi_w + (ds_param_validate_w/24)) < clock_timestamp()))) then
          
            ie_person_hpi_valid_w := 0;
        end if;

        if((((nr_seq_mhr_doc_p IS NOT NULL AND nr_seq_mhr_doc_p::text <> '')  and ie_action_p <> 'CF') or ie_action_p = 'RF' or ie_action_p = 'VI') 
              and ie_person_hpi_valid_w = 0 and coalesce(ds_other_params_p,'NULL') <>'RFPR') then 
             
           CALL wheb_mensagem_pck.exibir_mensagem_abort(1108692);
           commit;return;

        elsif ((coalesce(ds_other_params_p,'NULL') ='RFPR' or ie_action_p = 'PE') and ie_person_hpi_valid_w = 0) then
        
              CALL insert_mhr_audit_log(nm_usuario_p , cd_pessoa_fisica_p, nr_seq_person_ihi_w , 
                                    'N' , 'F' , 'OT', 
                                    'DownloadDocument:ITI-43 Retrieve Document Set', 
                                     'Selected Physician/ Logged-in User does not have valid HPI-I (Healthcare Provider Identifier - Individual) number.'|| chr(10) || 
                                     'Please validate the Physician''s details in Provider Records function, and validate the HPI-I number.'|| chr(10) ||
                                     'Please make sure that the HPI-I number is validated recently and doesn''t have any conflicts' || chr(10) ||
                                     'Physician Code-'|| coalesce(cd_pessoa_logged_user_w,cd_medico_resp_user_w )|| chr(10) ||
                                     'Physician HPI-' || coalesce(nr_seq_person_hpi_w,nr_seq_person_resp_hpi_w), 
                                     null, 'TASY_ERROR_IHI' , 
                                     obter_desc_exp_idioma(962757,wheb_usuario_pck.get_nr_seq_idioma()), nr_seq_mhr_doc_p );
               commit; return;
        end if;	

	    --- initiate the procedure	
		if ((nr_seq_mhr_doc_p IS NOT NULL AND nr_seq_mhr_doc_p::text <> '') and nr_seq_mhr_doc_p <> 0) then
		-- if mhr_doc_meta record is created, use the params from that record to call bifrost.
			select	ie_status,
					nr_atendimento,
					ie_origin_mhr,
					cd_doc_mhr,
					ie_upload,
					cd_version,
					ie_doc_type,
					ds_params
			into STRICT	ie_status_w,
					nr_atendimento_w,
					ie_origin_mhr_w,
					cd_doc_mhr_w,
					ie_upload_w,
					cd_version_w,
					ie_doc_type_w,
					ds_params_w
			from	mhr_doc_meta
			where	nr_sequencia = nr_seq_mhr_doc_p
			and 	cd_pessoa_fisica = cd_pessoa_fisica_p;


			-- perform checks based on specified action.
			CASE ie_action_p

				when 'UP' then
					BEGIN
						if (ie_status_w = 'RU' or ie_status_w = 'ER') and (ie_doc_type_w = 'DS' or ie_doc_type_w = 'ES') and (ie_origin_mhr_w = 'N') and (ie_upload_w = 'S') then

								if (ie_doc_type_w = 'DS') then
									cd_integration_w := 170;
								elsif (ie_doc_type_w = 'ES') then
									cd_integration_w := 172;
								end if;

						end if;
					END;

				when 'RM' then
					BEGIN

						if (coalesce(ds_justificativa_p::text, '') = '') then
							CALL Wheb_mensagem_pck.exibir_mensagem_abort(1092252);
							commit;return;
						end if;
						
						if (ie_status_w <> 'UP') and (ie_status_w <> 'SC') and (coalesce(cd_doc_mhr_w::text, '') = '') then

							-- If the document is not uploaded to MHR yet, then just inactivate the document and return.
							update 		mhr_doc_meta
							set  		ds_justificativa 	 = ds_justificativa_p,
										ie_status = 'IA'
							where		nr_sequencia 		 = nr_seq_mhr_doc_p;
							
							commit;return;
							
						else
						
							update 		mhr_doc_meta
							set  		ds_justificativa 	 = ds_justificativa_p
							where		nr_sequencia 		 = nr_seq_mhr_doc_p;

							commit;
					
						end if;

						if (ie_status_w = 'UP' or ie_status_w = 'SC' or ie_status_w = 'ER') and (ie_doc_type_w = 'DS' or ie_doc_type_w = 'ES') and (ie_origin_mhr_w = 'N') and (ie_upload_w = 'S') then

								cd_integration_w := 180;

						end if;
					END;

				when 'SC' then
					BEGIN

						if (coalesce(ds_justificativa_p::text, '') = '') then
							CALL Wheb_mensagem_pck.exibir_mensagem_abort(1092252);
							commit;return;
						else
							update 		mhr_doc_meta
							set  		ds_justificativa 	 = ds_justificativa_p
							where		nr_sequencia 		 = nr_seq_mhr_doc_p;

							commit;
						end if;

						if (ie_status_w = 'UP' or ie_status_w = 'SC' or ie_status_w = 'ER') and (ie_doc_type_w = 'DS' or ie_doc_type_w = 'ES') and (ie_origin_mhr_w = 'N') and (ie_upload_w = 'S') then

								if (ie_doc_type_w = 'DS') then
									cd_integration_w := 182;
								elsif (ie_doc_type_w = 'ES') then
									cd_integration_w := 184;
								end if;						

						end if;
					END;

				when 'DN' then
					BEGIN
						if (ie_status_w = 'ER') and (ie_upload_w = 'N') then

								cd_integration_w := 174;

						end if;
					END;

				when 'CF' then
					BEGIN
						if (ie_status_w = 'IN') and (ie_doc_type_w = 'DS' or ie_doc_type_w = 'ES') and (ie_origin_mhr_w = 'N') and (ie_upload_w = 'S') then

								if (ie_doc_type_w = 'DS') then
									cd_integration_w := 175;
								elsif (ie_doc_type_w = 'ES') then
									cd_integration_w := 176;
								end if;

						end if;
					END;

			END CASE;

			-- if params and integration code is not populated, then abort.
			if (coalesce(cd_integration_w::text, '') = '') then
				CALL Wheb_mensagem_pck.exibir_mensagem_abort(1092252);
				commit;return;
			end if;

			-- change the doc status as processing
			CALL update_mhr_doc_status(nm_usuario_p, 'PR', cd_pessoa_fisica_p, nr_seq_mhr_doc_p, null, null);

			if (ie_action_p = 'SC') 	then
			-- If the action is to supersede the document, then get the details of the other document as well.
			
				nr_seq_mhr_doc_supersede_w := ds_other_params_p;
				
				select	ds_params
				into STRICT	ds_params_supersede_w
				from	mhr_doc_meta
				where	nr_sequencia = nr_seq_mhr_doc_supersede_w
				and 	cd_pessoa_fisica = cd_pessoa_fisica_p;	
				
				-- change the doc status as processing
				CALL update_mhr_doc_status(nm_usuario_p, 'PR', cd_pessoa_fisica_p, nr_seq_mhr_doc_supersede_w, null, null);
				
				ds_params_supersede_w := 	'{'
											|| '"newDocumentParams" : "' || ds_params_supersede_w || '"' || ', '
											|| '"oldDocumentParams" : "' || ds_params_w || '"' || ', '
											|| '"oldDocumentStatus" : "' || ie_status_w || '"' || ', '
											|| '"oldDocumentVersion" : "' || cd_version_w || '"' || ', '
											|| '"oldDocumentSequenceNumber" : ' || nr_seq_mhr_doc_p ||', '
                      || '"ieWithdrawnConsent" : "' || ie_mhr_withdrawn_consent || '"' || ', '
                      || '"IeValidIHI" : ' || ie_person_ihi_valid_w || ', '
                      || '"IeValidHPI" : ' || ie_person_hpi_valid_w || ''
											|| ' }';
				
				ds_parameters_w := '{'
									|| '"patientId" : "' || cd_pessoa_fisica_p || '"' || ' , '
									|| '"userName" : "' || nm_usuario_p || '"' || ' , '
									|| '"establishment" : "' || cd_estabelecimento_w || '"' || ' , '
									|| '"personIhiSequence" : "' || nr_seq_person_ihi_w || '"' || ' , '
									|| '"patientIhiNumber" : "' || nr_person_ihi_w || '"' || ' , '
									|| '"ihiLastValidatedDate" : "' || to_char(dt_ihi_atualizacao_w, 'yyyy-mm-dd') || '"' || ' , '
									|| '"providerIhiNumber" : "' || nr_provider_hpi_w || '"' || ' , '
									|| '"providerName" : "' || nm_provider_name_w || '"' || ' , '
									|| '"mhrDocId" : "' || cd_doc_mhr_w || '"' || ' , '			-- Doc Id of the original document
									|| '"encounterId" : ' || nr_atendimento_w || ' , '
									|| '"sequenceNumber" : ' || nr_seq_mhr_doc_supersede_w || ' , '		-- Sequence Number of the record, which will supersede the original document
									|| '"justification" : "' || ds_justificativa_p || '"' || ' , '
									|| '"mhrQuote" : ' || ds_params_supersede_w || ''
									|| ' }';
				
			else
          if (ie_doc_type_w    = 'DS') then
              ds_parameters_w := '{'
                        || '"patientId" : "' || cd_pessoa_fisica_p || '"' || ' , '
                        || '"userName" : "' || nm_usuario_p || '"' || ' , '
                        || '"establishment" : "' || cd_estabelecimento_w || '"' || ' , '
                        || '"personIhiSequence" : "' || nr_seq_person_ihi_w || '"' || ' , '
                        || '"patientIhiNumber" : "' || nr_person_ihi_w || '"' || ' , '
                        || '"ihiLastValidatedDate" : "' || to_char(dt_ihi_atualizacao_w, 'yyyy-mm-dd') || '"' || ' , '
                        || '"providerIhiNumber" : "' || nr_provider_hpi_w || '"' || ' , '
                        || '"providerName" : "' || nm_provider_name_w || '"' || ' , '
                        || '"mhrDocId" : "' || cd_doc_mhr_w || '"' || ' , '
                        || '"encounterId" : ' || nr_atendimento_w || ' , '
                        || '"sequenceNumber" : ' || nr_seq_mhr_doc_p || ' , '
                        || '"justification" : "' || ds_justificativa_p || '"' || ' , '
                        || '"mhrQuote" : "' || ds_params_w ||'"' || ', '
                        || '"ieWithdrawnConsent" : "' || ie_mhr_withdrawn_consent || '"' ||' , '
                        || '"ValidIHI" : ' || ie_person_ihi_valid_w || ', '
                        || '"ValidHPI" : ' || ie_person_hpi_valid_w || ', '
                        || '"oldDocumentStatus" : "' || ie_status_w ||'"'
                        || ' }';
          else       
              ds_params_w := '{ ' 
                        || '"ieWithdrawnConsent" : "' || ie_mhr_withdrawn_consent || '"' ||' , '
                        || '"ValidIHI" : ' || ie_person_ihi_valid_w || ', '
                        || '"ValidHPI" : ' || ie_person_hpi_valid_w 
                        || ' }';

              ds_parameters_w := '{'
                        || '"patientId" : "' || cd_pessoa_fisica_p || '"' || ' , '
                        || '"userName" : "' || nm_usuario_p || '"' || ' , '
                        || '"establishment" : "' || cd_estabelecimento_w || '"' || ' , '
                        || '"personIhiSequence" : "' || nr_seq_person_ihi_w || '"' || ' , '
                        || '"patientIhiNumber" : "' || nr_person_ihi_w || '"' || ' , '
                        || '"ihiLastValidatedDate" : "' || to_char(dt_ihi_atualizacao_w, 'yyyy-mm-dd') || '"' || ' , '
                        || '"providerIhiNumber" : "' || nr_provider_hpi_w || '"' || ' , '
                        || '"providerName" : "' || nm_provider_name_w || '"' || ' , '
                        || '"mhrDocId" : "' || cd_doc_mhr_w || '"' || ' , '
                        || '"encounterId" : ' || nr_atendimento_w || ' , '
                        || '"sequenceNumber" : ' || nr_seq_mhr_doc_p || ' , '
                        || '"justification" : "' || ds_justificativa_p || '"' || ' , '
                        || '"mhrQuote" : ' || ds_params_w || ''
                        || ' }';
          end if;
			
			end if;

			-- initiate Bifrost call to process the integration
			CALL execute_bifrost_integration(cd_integration_w, ds_parameters_w);
			commit;return;

		elsif (ie_action_p = 'RF' or ie_action_p = 'PE') then
		-- For Refresh action mhr_doc_meta record is not required.
		
			select	max(dt_last_access)
			into STRICT	dt_last_access_w
			from 	mhr_access_record
			where	cd_pessoa_fisica = cd_pessoa_fisica_p;
			
			-- If last access date is not available, use patient DoB as last access date
			if (coalesce(dt_last_access_w::text, '') = '')	then
				select 	obter_data_nascto_pf(cd_pessoa_fisica_p)
				into STRICT 	dt_last_access_w
				;
			end if;
			
			-- If last access date is still not available, use two year old date as last access date
			if (coalesce(dt_last_access_w::text, '') = '')	then
				select (clock_timestamp() - interval '730 days')
				into STRICT 	dt_last_access_w
				;
			end if;

			-- if IHI is not available for the patient, then HI services shall be called (in bifrost flow) to obtain the IHI number.
			CALL update_mhr_access_record(nm_usuario_p, cd_pessoa_fisica_p, nr_seq_person_ihi_w, 'P', 'OT');
			
			ds_params_w := ds_other_params_p;
			if (coalesce(ds_params_w::text, '') = '') 	then
				ds_params_w := '""';
			end if;
			
			ds_parameters_w := '{'
								|| '"patientId" : "' || cd_pessoa_fisica_p || '"' || ' , '
								|| '"userName" : "' || nm_usuario_p || '"' || ' , '
								|| '"establishment" : "' || cd_estabelecimento_w || '"' || ' , '
								|| '"personIhiSequence" : "' || nr_seq_person_ihi_w || '"' || ' , '
								|| '"patientIhiNumber" : "' || nr_person_ihi_w || '"' || ' , '
								|| '"ihiLastValidatedDate" : "' || to_char(dt_ihi_atualizacao_w, 'yyyy-mm-dd')|| '"' || ' , '
								|| '"providerIhiNumber" : "' || nr_provider_hpi_w || '"' || ' , '
								|| '"providerName" : "' || nm_provider_name_w || '"' || ' , '
								|| '"lastAccessDate" : "' || to_char(dt_last_access_w, 'yyyy-mm-dd') || '"' || ' , '
								|| '"justification" : "' || ds_justificativa_p || '"' || ' , '
								|| '"mhrQuote" : ' || ds_params_w || ''
								|| ' }';

			-- initiate Bifrost call to process the integration
			if (ie_action_p = 'RF') then
				CALL execute_bifrost_integration(178, ds_parameters_w);
			else
				CALL execute_bifrost_integration(185, ds_parameters_w);
			end if;
			commit;return;

		elsif (ie_action_p = 'CF' or ie_action_p = 'UP') then
		-- For upload and create file action, create a record in mhr_doc_meta, and use the input params to call bifrost.
			if (ie_action_p = 'CF' and ie_doc_type_p = 'DS') then
				cd_integration_w := 175;
			elsif (ie_action_p = 'CF' and ie_doc_type_p = 'ES') then
				cd_integration_w := 176;
			elsif (ie_action_p = 'UP' and ie_doc_type_p = 'DS') then
				cd_integration_w := 170;
			elsif (ie_action_p = 'UP' and ie_doc_type_p = 'ES') then
				cd_integration_w := 172;
			end if;

			-- if params and integration code is not populated, then abort.
			if (coalesce(cd_integration_w::text, '') = '') then
				CALL Wheb_mensagem_pck.exibir_mensagem_abort(1092252);
				commit;return;
			end if;

			-- create the doc with status as draft
			nr_seq_mhr_doc_w := create_mhr_doc_meta(nm_usuario_p, cd_pessoa_fisica_p, nr_atendimento_p, ie_doc_type_p, 'S', 'IN', 'N', clock_timestamp(), null, cd_doc_tasy_p, null, null, null, 'N', null, null, null, nm_usuario_p, ds_other_params_p, nr_seq_mhr_doc_w);

      if (cd_integration_w = 172 or cd_integration_w = 176) then 
        ds_params_w := '{ '
                || '"ieWithdrawnConsent" : "' || ie_mhr_withdrawn_consent || '"' ||' , '
                || '"ValidIHI" : ' || ie_person_ihi_valid_w || ', '
                || '"ValidHPI" : ' || ie_person_hpi_valid_w 
                || ' }';

        ds_parameters_w := '{'
								|| '"patientId" : "' || cd_pessoa_fisica_p || '"' || ' , '
								|| '"userName" : "' || nm_usuario_p || '"' || ' , '
								|| '"establishment" : "' || cd_estabelecimento_w || '"' || ' , '
								|| '"personIhiSequence" : "' || nr_seq_person_ihi_w || '"' || ' , '
								|| '"patientIhiNumber" : "' || nr_person_ihi_w || '"' || ' , '
								|| '"ihiLastValidatedDate" : "' || trunc(dt_ihi_atualizacao_w) || '"' || ' , '
								|| '"providerIhiNumber" : "' || nr_provider_hpi_w || '"' || ' , '
								|| '"providerName" : "' || nm_provider_name_w || '"' || ' , '
								|| '"encounterId" : ' || nr_atendimento_p || ' , '
								|| '"sequenceNumber" : ' || nr_seq_mhr_doc_w || ' , '
								|| '"justification" : "' || ds_justificativa_p || '"' || ' , '
								|| '"mhrQuote" : ' || ds_params_w || ''
								|| ' }';

      else
        ds_parameters_w := '{'
								|| '"patientId" : "' || cd_pessoa_fisica_p || '"' || ' , '
								|| '"userName" : "' || nm_usuario_p || '"' || ' , '
								|| '"establishment" : "' || cd_estabelecimento_w || '"' || ' , '
								|| '"personIhiSequence" : "' || nr_seq_person_ihi_w || '"' || ' , '
								|| '"patientIhiNumber" : "' || nr_person_ihi_w || '"' || ' , '
								|| '"ihiLastValidatedDate" : "' || trunc(dt_ihi_atualizacao_w) || '"' || ' , '
								|| '"providerIhiNumber" : "' || nr_provider_hpi_w || '"' || ' , '
								|| '"providerName" : "' || nm_provider_name_w || '"' || ' , '
								|| '"encounterId" : ' || nr_atendimento_p || ' , '
								|| '"sequenceNumber" : ' || nr_seq_mhr_doc_w || ' , '
								|| '"justification" : "' || ds_justificativa_p || '"' || ' , '
								|| '"mhrQuote" : "' || ds_other_params_p || '"' || ', '
                || '"ieWithdrawnConsent" : "' || ie_mhr_withdrawn_consent || '"' ||' , '
                || '"ValidIHI" : ' || ie_person_ihi_valid_w || ', '
                || '"ValidHPI" : ' || ie_person_hpi_valid_w || ''
								|| ' }';
      end if;

			-- initiate Bifrost call to process the integration
			CALL execute_bifrost_integration(cd_integration_w, ds_parameters_w);
			commit;return;

		end if;

	end if;
	
commit;

END;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE perform_mhr_doc_action ( nr_seq_mhr_doc_p mhr_doc_meta.nr_sequencia%TYPE default null, cd_pessoa_fisica_p mhr_doc_meta.cd_pessoa_fisica%TYPE  DEFAULT NULL, nr_atendimento_p mhr_doc_meta.nr_atendimento%TYPE  DEFAULT NULL, nm_usuario_p mhr_doc_meta.nm_usuario%TYPE default null, ie_doc_type_p mhr_doc_meta.ie_doc_type%TYPE default null, cd_doc_tasy_p mhr_doc_meta.cd_doc_tasy%TYPE default null, ds_justificativa_p mhr_doc_meta.ds_justificativa%type default null, ie_action_p text  DEFAULT NULL, ds_other_params_p text default null) FROM PUBLIC; -- REVOKE ALL ON PROCEDURE perform_mhr_doc_action_atx ( nr_seq_mhr_doc_p mhr_doc_meta.nr_sequencia%TYPE default null, cd_pessoa_fisica_p mhr_doc_meta.cd_pessoa_fisica%TYPE  DEFAULT NULL, nr_atendimento_p mhr_doc_meta.nr_atendimento%TYPE  DEFAULT NULL, nm_usuario_p mhr_doc_meta.nm_usuario%TYPE default null, ie_doc_type_p mhr_doc_meta.ie_doc_type%TYPE default null, cd_doc_tasy_p mhr_doc_meta.cd_doc_tasy%TYPE default null, ds_justificativa_p mhr_doc_meta.ds_justificativa%type default null, ie_action_p text  DEFAULT NULL, ds_other_params_p text default null) FROM PUBLIC;
