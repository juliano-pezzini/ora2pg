-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE generate_qhapdc_act_content ( nr_seq_dataset_p bigint, nm_usuario_p text, returned_value_p INOUT bigint, other_exception_p INOUT text) AS $body$
DECLARE


  ds_segment_w varchar(32767);

  ds_segment_clob_w text              := '';

  is_clob_insertion_successful bigint := 0;

  excp_caught_dataset_clob_ins varchar(500 );


BEGIN

  BEGIN

    SELECT 'N' -- Record Identifier
      || Lpad(nr_atendimento, 12, '0') -- Unique Number 
      || Lpad(Obter_pessoa_atendimento(nr_atendimento, 'C'), 8, '0') --Patient Identifier 
      || Lpad(nr_atendimento, 12, '0') -- Admission Number
      || 'W'                           -- Activity Code
      || CASE WHEN coalesce(cd_department_encounter::text, '') = '' THEN  '000000'   ELSE Lpad(cd_department_encounter, 6, '0') END      -- Ward
      || CASE WHEN coalesce(cd_basic_care_unit::text, '') = '' THEN  '    '   ELSE Lpad(trim(both cd_basic_care_unit),4,'0') END

      || CASE WHEN coalesce(cd_standard_unit_code::text, '') = '' THEN  '0000'   ELSE Lpad(trim(both cd_standard_unit_code),4,'0') END   -- Standard Unit Code
      || CASE WHEN coalesce(dt_dept_entry::text, '') = '' THEN  '        '   ELSE TO_CHAR(dt_dept_entry, 'yyyymmdd') END    

      || CASE WHEN coalesce(dt_dept_entry::text, '') = '' THEN  '    '   ELSE TO_CHAR(dt_dept_entry, 'hhmm') END 

      || Lpad(' ', 4, ' ') --Standard Ward Code
      
      || chr(10)

    INTO STRICT ds_segment_w

    FROM qhapdc_segment_act

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
-- REVOKE ALL ON PROCEDURE generate_qhapdc_act_content ( nr_seq_dataset_p bigint, nm_usuario_p text, returned_value_p INOUT bigint, other_exception_p INOUT text) FROM PUBLIC;
