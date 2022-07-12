-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';




CREATE OR REPLACE PROCEDURE configura_psa_tws_pack.configure_psa_tws_beneficiary ( nm_attempts datasource.vl_allowed_login_attempts%type, nm_email_admin subject.ds_email%type) AS $body$
DECLARE

/* +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
Finalidade: Create user BENEFICIARY this user is used in the Insurance Plan
-------------------------------------------------------------------------------------------------------------------
Locais de chamada direta:
[  ]  Objetos do dicionário [ ] Tasy (Delphi/Java) [  ] Portal [  ]  Relatórios [ ] Outros:
 ------------------------------------------------------------------------------------------------------------------
Caution
++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++ */
id_application      	application.id%type;
id_datasource       	datasource.id%type;

ds_role_proposalHpms	role.ds_role%TYPE := 'ProposalHpms';
nm_role_proposalHpms	role.nm_role%TYPE := 'proposalHpms';

ds_role_beneficiary	role.ds_role%TYPE := 'Beneficiary';
nm_role_beneficiary	role.nm_role%TYPE := 'beneficiary';

ds_role_guest           role.ds_role%TYPE := 'Guest';
nm_role_guest           role.nm_role%TYPE := 'guest';


BEGIN

/*++++++++++++++++++++++++++++++++++++++++++++++ create application and datasouce to PROPORSALHPMS +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++*/
SELECT * FROM configura_psa_tws_pack.create_application_datasouce( nm_attempts, nm_email_admin, 'PROPOSALHPMS', 'proposal_hpms', id_application, id_datasource ) INTO STRICT id_application, id_datasource;

--Create USERPROPOSALHPMS
CALL CALL configura_psa_tws_pack.create_permission_role( current_setting('configura_psa_tws_pack.permission_email_desc')::permission.ds_tag%TYPE, current_setting('configura_psa_tws_pack.permission_email_tag')::permission.ds_tag%TYPE, ds_role_proposalHpms, nm_role_proposalHpms, id_datasource, id_application, 'N');
CALL CALL configura_psa_tws_pack.create_permission_role( current_setting('configura_psa_tws_pack.permission_location_desc')::permission.ds_tag%TYPE, current_setting('configura_psa_tws_pack.permission_location_tag')::permission.ds_tag%TYPE, ds_role_proposalHpms, nm_role_proposalHpms, id_datasource, id_application, 'N' );
CALL CALL configura_psa_tws_pack.create_permission_role( current_setting('configura_psa_tws_pack.permission_hpmsproduct_desc')::permission.ds_tag%TYPE, current_setting('configura_psa_tws_pack.permission_hpmsproduct_tag')::permission.ds_tag%TYPE, ds_role_proposalHpms, nm_role_proposalHpms, id_datasource, id_application, 'N' );
CALL CALL configura_psa_tws_pack.create_permission_role( current_setting('configura_psa_tws_pack.permission_hpmspricesimul_desc')::permission.ds_tag%TYPE, current_setting('configura_psa_tws_pack.permission_hpmspricesimul_tag')::permission.ds_tag%TYPE, ds_role_proposalHpms, nm_role_proposalHpms, id_datasource, id_application, 'N' );
CALL CALL configura_psa_tws_pack.create_permission_role( current_setting('configura_psa_tws_pack.permission_hpmsproppur_desc')::permission.ds_tag%TYPE, current_setting('configura_psa_tws_pack.permission_hpmsproppur_tag')::permission.ds_tag%TYPE, ds_role_proposalHpms, nm_role_proposalHpms, id_datasource, id_application, 'N' );
CALL CALL configura_psa_tws_pack.create_permission_role(current_setting('configura_psa_tws_pack.permission_utils_desc')::permission.ds_tag%TYPE, current_setting('configura_psa_tws_pack.permission_utils_tag')::permission.ds_tag%TYPE, ds_role_proposalHpms,  nm_role_proposalHpms, id_datasource, id_application, 'N');

--Insert Guest profile permissions to application
CALL CALL configura_psa_tws_pack.create_permission_role( current_setting('configura_psa_tws_pack.permission_subj_create_desc')::permission.ds_tag%TYPE, current_setting('configura_psa_tws_pack.permission_subj_create_tag')::permission.ds_tag%TYPE, ds_role_guest, nm_role_guest, id_datasource, id_application, 'N' );
CALL CALL configura_psa_tws_pack.create_permission_role( current_setting('configura_psa_tws_pack.permission_subj_retrie_desc')::permission.ds_tag%TYPE, current_setting('configura_psa_tws_pack.permission_subj_retrie_tag')::permission.ds_tag%TYPE, ds_role_guest, nm_role_guest, id_datasource, id_application, 'N' );
CALL CALL configura_psa_tws_pack.create_permission_role( current_setting('configura_psa_tws_pack.permission_subj_cons_give_desc')::permission.ds_tag%TYPE, current_setting('configura_psa_tws_pack.permission_subj_cons_give_tag')::permission.ds_tag%TYPE, ds_role_guest, nm_role_guest, id_datasource, id_application, 'N' );
CALL CALL configura_psa_tws_pack.create_permission_role( current_setting('configura_psa_tws_pack.permission_subj_acti_stat_desc')::permission.ds_tag%TYPE, current_setting('configura_psa_tws_pack.permission_subj_acti_stat_tag')::permission.ds_tag%TYPE, ds_role_guest, nm_role_guest, id_datasource, id_application, 'N' );

--Create user DEAFAULT
CALL configura_psa_tws_pack.create_subject_default(id_datasource, id_application);

commit;


/*++++++++++++++++++++++++++++++++++++++++++++++ Create application and datasouce to BENEFICIARY +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++*/
SELECT * FROM configura_psa_tws_pack.create_application_datasouce( nm_attempts, nm_email_admin, 'BENEFICIARY', 'beneficiary', id_application, id_datasource ) INTO STRICT id_application, id_datasource;

--Create BENEFICIARY
CALL CALL configura_psa_tws_pack.create_permission_role( current_setting('configura_psa_tws_pack.permission_email_desc')::permission.ds_tag%TYPE, current_setting('configura_psa_tws_pack.permission_email_tag')::permission.ds_tag%TYPE, ds_role_beneficiary, nm_role_beneficiary, id_datasource, id_application, 'N');
CALL CALL configura_psa_tws_pack.create_permission_role( current_setting('configura_psa_tws_pack.permission_location_desc')::permission.ds_tag%TYPE, current_setting('configura_psa_tws_pack.permission_location_tag')::permission.ds_tag%TYPE, ds_role_beneficiary, nm_role_beneficiary, id_datasource, id_application, 'N' );
CALL CALL configura_psa_tws_pack.create_permission_role( current_setting('configura_psa_tws_pack.permission_hpmsproduct_desc')::permission.ds_tag%TYPE, current_setting('configura_psa_tws_pack.permission_hpmsproduct_tag')::permission.ds_tag%TYPE, ds_role_beneficiary, nm_role_beneficiary, id_datasource, id_application, 'N' );
CALL CALL configura_psa_tws_pack.create_permission_role( current_setting('configura_psa_tws_pack.permission_reports_desc')::permission.ds_tag%TYPE, current_setting('configura_psa_tws_pack.permission_reports_tag')::permission.ds_tag%TYPE, ds_role_beneficiary, nm_role_beneficiary, id_datasource, id_application, 'N' );
CALL CALL configura_psa_tws_pack.create_permission_role( current_setting('configura_psa_tws_pack.permission_notification_desc')::permission.ds_tag%TYPE, current_setting('configura_psa_tws_pack.permission_notification_tag')::permission.ds_tag%TYPE, ds_role_beneficiary, nm_role_beneficiary, id_datasource, id_application, 'N' );
CALL CALL configura_psa_tws_pack.create_permission_role( current_setting('configura_psa_tws_pack.permission_utils_desc')::permission.ds_tag%TYPE, current_setting('configura_psa_tws_pack.permission_utils_tag')::permission.ds_tag%TYPE, ds_role_beneficiary,  nm_role_beneficiary, id_datasource, id_application, 'N');

commit;

END;

$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE configura_psa_tws_pack.configure_psa_tws_beneficiary ( nm_attempts datasource.vl_allowed_login_attempts%type, nm_email_admin subject.ds_email%type) FROM PUBLIC;