-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE generate_qhapdc_adm_content ( nr_seq_dataset_p bigint, nm_usuario_p text, returned_value_p INOUT bigint, other_exception_p INOUT text) AS $body$
DECLARE


  ds_segment_w varchar(32767);

  ds_segment_clob_w text              := '';

  is_clob_insertion_successful bigint := 0;

  excp_caught_dataset_clob_ins varchar(500 );


BEGIN

  BEGIN

    SELECT 'N' --Record Identifier
      || Lpad(nr_atendimento, 12, '0')

      || Lpad(Obter_pessoa_atendimento(nr_atendimento, 'C'), 8, '0')

      || Lpad(nr_atendimento, 12, '0')

      || CASE WHEN coalesce(DT_INCIDENT::text, '') = '' THEN  '        '   ELSE TO_CHAR(dt_entry, 'yyyymmdd') END 

      || CASE WHEN coalesce(DT_INCIDENT::text, '') = '' THEN  '    '   ELSE TO_CHAR(dt_entry_time, 'hhmm') END 

      || Lpad(' ',12, ' ')

      || CASE WHEN coalesce(ie_chargeable_statue::text, '') = '' THEN  '1'   ELSE Lpad(trim(both ie_chargeable_statue),1,'1') END 

      || CASE WHEN coalesce(nr_seq_care_type::text, '') = '' THEN  '  '   ELSE Lpad(nr_seq_care_type, 2, '0') END 

      || CASE WHEN coalesce(CD_BAND::text, '') = '' THEN  '8'   ELSE Lpad(trim(both ie_compensable_status),1,'8') END 

      || CASE WHEN coalesce(CD_BAND::text, '') = '' THEN  '  '   ELSE Lpad(trim(both CD_BAND), 2, '0') END 

      || CASE WHEN coalesce(cd_admission_detail::text, '') = '' THEN  '  '   ELSE Lpad(cd_admission_detail, 2, '0') END 

	    || CASE WHEN coalesce(CD_FACILITY_FROM::text, '') = '' THEN  '     '   ELSE Lpad(trim(both CD_FACILITY_FROM), 5, '0') END 

      || CASE WHEN coalesce(nr_hosp_insurance::text, '') = '' THEN  '8'   ELSE Lpad(trim(both nr_hosp_insurance),1,'8') END 

      || CASE WHEN coalesce(DT_INCIDENT::text, '') = '' THEN  '        '   ELSE TO_CHAR(dt_discharge, 'yyyymmdd') END 

      || CASE WHEN coalesce(DT_INCIDENT::text, '') = '' THEN  '    '   ELSE TO_CHAR(dt_discharge_time, 'hhmm') END 

      || CASE WHEN coalesce(cd_sepration_mode::text, '') = '' THEN  '01'   ELSE Lpad(cd_sepration_mode, 2, '0') END 

      || CASE WHEN coalesce(CD_FACILITY_TO::text, '') = '' THEN  '     '   ELSE Lpad(trim(both CD_FACILITY_TO), 5, '0') END 

      || Lpad(' ', 8, ' ') 

      || CASE WHEN coalesce(NR_BABY_ADMIN_WEIG::text, '') = '' THEN  '    '   ELSE Lpad(trim(both NR_BABY_ADMIN_WEIG), 4, '0') END  

      || CASE WHEN coalesce(CD_ADMITING_WARD::text, '') = '' THEN  '      '   ELSE Lpad(CD_ADMITING_WARD, 6, ' ') END 

      || CASE WHEN coalesce(CD_ADMITTING_UNIT::text, '') = '' THEN  '    '   ELSE Lpad(trim(both CD_ADMITTING_UNIT), 4, ' ') END 

      || CASE WHEN coalesce(CD_STNDRD_UNIT_CODE::text, '') = '' THEN  '    '   ELSE Lpad(CD_STNDRD_UNIT_CODE, 4, ' ') END 

      || CASE WHEN coalesce(CD_PHYSICIAN_RESP::text, '') = '' THEN  '      '   ELSE Lpad(trim(both CD_PHYSICIAN_RESP), 6, ' ') END 

      || CASE WHEN coalesce(IE_SAME_DAY::text, '') = '' THEN  'N'   ELSE Lpad(trim(both IE_SAME_DAY),1,'N') END 

      || CASE WHEN coalesce(IE_ENCOUNTER_NATURE::text, '') = '' THEN  '3'   ELSE Lpad(trim(both IE_ENCOUNTER_NATURE),1,'3') END 

      || CASE WHEN coalesce(CD_QUALIFICATION_STATUS::text, '') = '' THEN  ' '   ELSE Lpad(trim(both CD_QUALIFICATION_STATUS), 1, ' ') END 

      || CASE WHEN coalesce(CD_STNRD_WARD_CODE::text, '') = '' THEN  '    '   ELSE Lpad(trim(both CD_STNRD_WARD_CODE), 4, ' ') END  -- CD_STNRD_WARD_CODE

    --|| lpad(' ',1,' ')
      || CASE WHEN coalesce(ie_contract_role::text, '') = '' THEN ' '  ELSE lpad(trim(both ie_contract_role),1,' ') END        --IE_CONTRACT_ROLE
      || CASE WHEN coalesce(CD_CONTRACT_TYPE::text, '') = '' THEN  ' '   ELSE Lpad(trim(both CD_CONTRACT_TYPE), 1, ' ') END        --CD_CONTRACT_TYPE
      || CASE WHEN coalesce(CD_FUNDING_SOURCE::text, '') = '' THEN  '  '   ELSE Lpad(trim(both CD_FUNDING_SOURCE), 2, '0') END   --CD_FUNDING_SOURCE
      || CASE WHEN coalesce(DT_INCIDENT::text, '') = '' THEN  '        '   ELSE TO_CHAR(DT_INCIDENT, 'yyyymmdd') END   --DT_INCIDENT
      || CASE WHEN coalesce(CD_INCIDENT_FLAG::text, '') = '' THEN  ' '   ELSE Lpad(trim(both CD_INCIDENT_FLAG), 1, ' ') END   --CD_INCIDENT_FLAG  
      || 'U'                                                                         --CD_WORKCONER_QUEENSLAND
      || CASE WHEN coalesce(CD_MOTOR_ACC_INC::text, '') = '' THEN  'U'   ELSE Lpad(trim(both CD_MOTOR_ACC_INC), 1, ' ') END   --CD_MOTOR_ACC_INC    
      || CASE WHEN coalesce(CD_DVA::text, '') = '' THEN  'U'   ELSE Lpad(trim(both CD_DVA), 1, ' ') END   --CD_DVA                        DEpartement of veterans affairs  
      || CASE WHEN coalesce(CD_DDC::text, '') = '' THEN  'U'   ELSE Lpad(trim(both CD_DDC), 1, ' ') END  --  CD_DDC,
      || CASE WHEN coalesce(NR_LANGUAGE::text, '') = '' THEN  '    '   ELSE Lpad(trim(both NR_LANGUAGE), 4, ' ') END  -- NR_LANGUAGE,
      || CASE WHEN coalesce(IE_INTERPRETER_REQ::text, '') = '' THEN  ' '   ELSE Lpad(trim(both IE_INTERPRETER_REQ), 1, ' ') END  -- IE_INTERPRETER_REQ,
      || Lpad(' ',4, ' ') 

      || CASE WHEN coalesce(NR_QAS_NUMBER::text, '') = '' THEN  '            '   ELSE Lpad(trim(both NR_QAS_NUMBER), 12, ' ') END  -- NR_QAS_NUMBER,
      || CASE WHEN coalesce(NR_PROVIDER_IDENTIFIER::text, '') = '' THEN  '     '   ELSE Lpad(trim(both NR_PROVIDER_IDENTIFIER), 5, '0') END  --  NR_PROVIDER_IDENTIFIER,  
      || Lpad(' ',6, ' ') -- Filler                    
      || CASE WHEN coalesce(QT_INTENSE_CARE::text, '') = '' THEN  '       '   ELSE Lpad(trim(both QT_INTENSE_CARE), 7, '0') END  -- QT_INTENSE_CARE,
      || CASE WHEN coalesce(QT_VENTILATORY_SUPPORT::text, '') = '' THEN  '       '   ELSE Lpad(trim(both QT_VENTILATORY_SUPPORT), 7, '0') END  -- QT_VENTILATORY_SUPPORT,
      
      || chr(10)

    INTO STRICT ds_segment_w

    FROM qhapdc_segment_adm

    WHERE nr_dataset = nr_seq_dataset_p;

  EXCEPTION

  WHEN OTHERS THEN

    ds_segment_w := NULL;

  END;

  SELECT Concat(ds_segment_clob_w, ds_segment_w)

  INTO STRICT ds_segment_clob_w

;

  SELECT * FROM Insert_dataset_content(nm_usuario_p, nr_seq_dataset_p, ds_segment_clob_w, is_clob_insertion_successful, excp_caught_dataset_clob_ins) INTO STRICT is_clob_insertion_successful, excp_caught_dataset_clob_ins;

  IF ( is_clob_insertion_successful = 1 ) THEN

    returned_value_p              :=1;

    other_exception_p             :=NULL;

  ELSE

    IF (excp_caught_dataset_clob_ins IS NOT NULL AND excp_caught_dataset_clob_ins::text <> '') THEN

      returned_value_p               :=0;

      other_exception_p              := excp_caught_dataset_clob_ins;

    END IF;

  END IF;

END;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE generate_qhapdc_adm_content ( nr_seq_dataset_p bigint, nm_usuario_p text, returned_value_p INOUT bigint, other_exception_p INOUT text) FROM PUBLIC;

