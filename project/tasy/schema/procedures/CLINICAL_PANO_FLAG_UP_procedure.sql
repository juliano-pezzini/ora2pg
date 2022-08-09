-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE clinical_pano_flag_up ( nr_atendimento_p bigint, nm_usuario_p text, option_name text, ds_comment_p text, ds_ancillarypatient_p text ) AS $body$
DECLARE


    ie_severely_injured_w       varchar(22);
    ie_required_observation_w   varchar(22);
    ie_special_attention_w      varchar(22);
    ie_attendant_w              varchar(22);
    qtd_w                       numeric(22);

BEGIN
    SELECT COUNT(MAX(1))
      INTO STRICT qtd_w
      FROM pop_over_table
     WHERE nr_atendimento = nr_atendimento_p
  GROUP BY nr_atendimento;

    IF ( qtd_w = 0 ) THEN
        INSERT INTO pop_over_table( nr_sequencia, nr_atendimento, nm_usuario, dt_atualizacao)
             VALUES ( nextval('pop_over_table_seq'), nr_atendimento_p,nm_usuario_p,clock_timestamp());
        COMMIT;

        IF ( option_name = 'IE_SEVERELY_INJURED' ) THEN
            SELECT CASE WHEN coalesce(ie_severely_injured, 'N')='S' THEN  'N'  ELSE 'S' END
              INTO STRICT ie_severely_injured_w
              FROM pop_over_table
             WHERE nr_atendimento = nr_atendimento_p  LIMIT 1;

        ELSIF ( option_name = 'IE_REQUIRED_OBSERVATION' ) THEN
            SELECT CASE WHEN coalesce(ie_required_observation, 'N')='S' THEN  'N'  ELSE 'S' END 
              INTO STRICT ie_required_observation_w
              FROM pop_over_table
             WHERE nr_atendimento = nr_atendimento_p  LIMIT 1;

        ELSIF ( option_name = 'IE_SPECIAL_ATTENTION' ) THEN
            SELECT CASE WHEN coalesce(ie_special_attention, 'N')='S' THEN  'N'  ELSE 'S' END
             INTO STRICT ie_special_attention_w
             FROM pop_over_table
            WHERE nr_atendimento = nr_atendimento_p  LIMIT 1;

        ELSIF ( option_name = 'IE_ATTENDANT' ) THEN
            SELECT CASE WHEN coalesce(ie_attendant, 'N')='S' THEN  'N'  ELSE 'S' END
              INTO STRICT ie_attendant_w
              FROM pop_over_table
             WHERE nr_atendimento = nr_atendimento_p  LIMIT 1;

        END IF;

        IF ( option_name = 'IE_SEVERELY_INJURED' ) THEN
            UPDATE pop_over_table
               SET ie_severely_injured = ie_severely_injured_w
             WHERE nr_atendimento = nr_atendimento_p;

        END IF;

        IF ( option_name = 'IE_REQUIRED_OBSERVATION' ) THEN
            UPDATE pop_over_table
            SET ie_required_observation = ie_required_observation_w
            WHERE nr_atendimento = nr_atendimento_p;

        END IF;

        IF ( option_name = 'IE_SPECIAL_ATTENTION' ) THEN
            UPDATE pop_over_table
            SET ie_special_attention = ie_special_attention_w
            WHERE nr_atendimento = nr_atendimento_p;

        END IF;

        IF ( option_name = 'IE_ATTENDANT' ) THEN
            UPDATE pop_over_table
               SET ie_attendant = ie_attendant_w
            WHERE nr_atendimento = nr_atendimento_p;

        END IF;

        IF ( option_name = 'DS_COMMENT' ) THEN
             UPDATE pop_over_table 
             SET nm_usuario = nm_usuario_p, ds_comment = ds_comment_p 
             WHERE nr_atendimento = nr_atendimento_p;
        END IF;

         IF ( option_name = 'DS_ANCILLARY_PATIENT' ) THEN
             UPDATE pop_over_table 
             SET nm_usuario = nm_usuario_p, ds_ancillary_patient = ds_ancillarypatient_p 
             WHERE nr_atendimento = nr_atendimento_p;
        END IF;

        COMMIT;
    ELSE
        IF ( option_name = 'IE_SEVERELY_INJURED' ) THEN
            SELECT CASE WHEN coalesce(ie_severely_injured, 'N')='S' THEN  'N'  ELSE 'S' END
              INTO STRICT ie_severely_injured_w
              FROM pop_over_table
            WHERE nr_atendimento = nr_atendimento_p  LIMIT 1;

        ELSIF ( option_name = 'IE_REQUIRED_OBSERVATION' ) THEN
            SELECT CASE WHEN coalesce(ie_required_observation, 'N')='S' THEN  'N'  ELSE 'S' END 
              INTO STRICT ie_required_observation_w
              FROM pop_over_table
             WHERE nr_atendimento = nr_atendimento_p  LIMIT 1;

        ELSIF ( option_name = 'IE_SPECIAL_ATTENTION' ) THEN
            SELECT CASE WHEN coalesce(ie_special_attention, 'N')='S' THEN  'N'  ELSE 'S' END
              INTO STRICT ie_special_attention_w
              FROM pop_over_table
             WHERE nr_atendimento = nr_atendimento_p  LIMIT 1;

        ELSIF ( option_name = 'IE_ATTENDANT' ) THEN
            SELECT CASE WHEN coalesce(ie_attendant, 'N')='S' THEN  'N'  ELSE 'S' END
              INTO STRICT ie_attendant_w
              FROM pop_over_table
             WHERE nr_atendimento = nr_atendimento_p  LIMIT 1;

        END IF;

        IF ( option_name = 'IE_SEVERELY_INJURED' ) THEN
            UPDATE pop_over_table
               SET ie_severely_injured = ie_severely_injured_w
             WHERE nr_atendimento = nr_atendimento_p;

        END IF;

        IF ( option_name = 'IE_REQUIRED_OBSERVATION' ) THEN
            UPDATE pop_over_table
               SET ie_required_observation = ie_required_observation_w
             WHERE nr_atendimento = nr_atendimento_p;

        END IF;

        IF ( option_name = 'IE_SPECIAL_ATTENTION' ) THEN
            UPDATE pop_over_table
               SET ie_special_attention = ie_special_attention_w
             WHERE nr_atendimento = nr_atendimento_p;

        END IF;

        IF ( option_name = 'IE_ATTENDANT' ) THEN
            UPDATE pop_over_table
               SET ie_attendant = ie_attendant_w
             WHERE nr_atendimento = nr_atendimento_p;

        END IF;

        IF ( option_name = 'DS_COMMENT' ) THEN
             UPDATE pop_over_table 
             SET nm_usuario = nm_usuario_p, ds_comment = ds_comment_p 
             WHERE nr_atendimento = nr_atendimento_p;
        END IF;

        IF ( option_name = 'DS_ANCILLARY_PATIENT' ) THEN
             UPDATE pop_over_table 
             SET nm_usuario = nm_usuario_p, ds_ancillary_patient = ds_ancillarypatient_p
             WHERE nr_atendimento = nr_atendimento_p;
        END IF;

        COMMIT;
    END IF;


END;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE clinical_pano_flag_up ( nr_atendimento_p bigint, nm_usuario_p text, option_name text, ds_comment_p text, ds_ancillarypatient_p text ) FROM PUBLIC;
