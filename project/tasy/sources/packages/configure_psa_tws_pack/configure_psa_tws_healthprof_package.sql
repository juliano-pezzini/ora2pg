-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';




CREATE OR REPLACE PROCEDURE configure_psa_tws_pack.configure_psa_tws_healthprof ( nm_attempts client.vl_allowed_login_attempts%type ) AS $body$
DECLARE


id_application      	application.id%type;
id_datasource       	datasource.id%type;

ds_role_physician       role.ds_role%type := 'HealthProfessional';
nm_role_physician       role.nm_role%type := 'healthprofessional';

ds_role_cli_auth_physician role.ds_role%TYPE := 'CliAuthHealthProfessional';
nm_role_cli_auth_physician role.nm_role%TYPE := 'cliAuthHealthProfessional';


BEGIN

--create application and datasouce

id_application := configure_psa_tws_pack.create_application_client( nm_attempts, 'HEALTHPROFESSIONAL', 'healthprofessional', 'WEBSUITE', 'websuite', id_application);

--Insert HEALTH PROFESSIONAL profile permissions to application

CALL CALL configure_psa_tws_pack.create_permission_role(current_setting('configure_psa_tws_pack.permission_schematic_desc')::permission.ds_tag%TYPE, current_setting('configure_psa_tws_pack.permission_schematic_tag')::permission.ds_tag%TYPE, ds_role_physician, nm_role_physician,  id_application, 'N');
CALL CALL configure_psa_tws_pack.create_permission_role(current_setting('configure_psa_tws_pack.permission_schedule_desc')::permission.ds_tag%TYPE, current_setting('configure_psa_tws_pack.permission_schedule_tag')::permission.ds_tag%TYPE, ds_role_physician, nm_role_physician,  id_application, 'N');
CALL CALL configure_psa_tws_pack.create_permission_role(current_setting('configure_psa_tws_pack.permission_email_desc')::permission.ds_tag%TYPE, current_setting('configure_psa_tws_pack.permission_email_tag')::permission.ds_tag%TYPE, ds_role_physician, nm_role_physician,  id_application, 'N');
CALL CALL configure_psa_tws_pack.create_permission_role(current_setting('configure_psa_tws_pack.permission_entity_desc')::permission.ds_tag%TYPE, current_setting('configure_psa_tws_pack.permission_entity_tag')::permission.ds_tag%TYPE, ds_role_physician, nm_role_physician,  id_application, 'N');
CALL CALL configure_psa_tws_pack.create_permission_role(current_setting('configure_psa_tws_pack.permission_professional_desc')::permission.ds_tag%TYPE, current_setting('configure_psa_tws_pack.permission_professional_tag')::permission.ds_tag%TYPE, ds_role_physician,  nm_role_physician,  id_application, 'N');
CALL CALL configure_psa_tws_pack.create_permission_role(current_setting('configure_psa_tws_pack.permission_utils_desc')::permission.ds_tag%TYPE, current_setting('configure_psa_tws_pack.permission_utils_tag')::permission.ds_tag%TYPE, ds_role_physician,  nm_role_physician,  id_application, 'N');
CALL CALL configure_psa_tws_pack.create_permission_role(current_setting('configure_psa_tws_pack.permission_person_desc')::permission.ds_tag%TYPE, current_setting('configure_psa_tws_pack.permission_person_tag')::permission.ds_tag%TYPE, ds_role_physician,  nm_role_physician,  id_application, 'N');

--Insert Client Health Professional Role profile permissions to application

CALL CALL configure_psa_tws_pack.create_permission_role( current_setting('configure_psa_tws_pack.permission_subj_create_desc')::permission.ds_tag%TYPE, current_setting('configure_psa_tws_pack.permission_subj_create_tag')::permission.ds_tag%TYPE, ds_role_cli_auth_physician, nm_role_cli_auth_physician,  id_application, 'N' );
CALL CALL configure_psa_tws_pack.create_permission_role( current_setting('configure_psa_tws_pack.permission_subj_retrie_desc')::permission.ds_tag%TYPE, current_setting('configure_psa_tws_pack.permission_subj_retrie_tag')::permission.ds_tag%TYPE, ds_role_cli_auth_physician, nm_role_cli_auth_physician,  id_application, 'N' );
CALL CALL configure_psa_tws_pack.create_permission_role( current_setting('configure_psa_tws_pack.permission_subj_cons_give_desc')::permission.ds_tag%TYPE, current_setting('configure_psa_tws_pack.permission_subj_cons_give_tag')::permission.ds_tag%TYPE, ds_role_cli_auth_physician, nm_role_cli_auth_physician,  id_application, 'N' );
CALL CALL configure_psa_tws_pack.create_permission_role( current_setting('configure_psa_tws_pack.permission_subj_acti_stat_desc')::permission.ds_tag%TYPE, current_setting('configure_psa_tws_pack.permission_subj_acti_stat_tag')::permission.ds_tag%TYPE, ds_role_cli_auth_physician, nm_role_cli_auth_physician,  id_application, 'N' );

--insert Client authorization profile

CALL configure_psa_tws_pack.create_client_role('HEALTHPROFESSIONAL',  ds_role_cli_auth_physician);
commit;

END;

$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE configure_psa_tws_pack.configure_psa_tws_healthprof ( nm_attempts client.vl_allowed_login_attempts%type ) FROM PUBLIC;
