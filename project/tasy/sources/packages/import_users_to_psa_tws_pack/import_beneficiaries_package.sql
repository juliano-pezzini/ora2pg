-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';




CREATE OR REPLACE PROCEDURE import_users_to_psa_tws_pack.import_beneficiaries () AS $body$
DECLARE


v_id_application   application.id%TYPE;
v_id_datasource    datasource.id%TYPE;
v_id_client        client.id%TYPE;
v_id_role          role.id%TYPE;

  rc_hpms_pls_segurado_web RECORD;

BEGIN
SELECT * FROM import_users_to_psa_tws_pack.load_beneficiary_parameters(v_id_application, v_id_datasource, v_id_client, v_id_role) INTO STRICT v_id_application, v_id_datasource, v_id_client, v_id_role;
	
FOR rc_hpms_pls_segurado_web IN (
	SELECT	spsw.*
	from	hpms_pls_segurado_web spsw
	where	coalesce(import_users_to_psa_tws_pack.retrive_beneficiary(spsw.cd_carteira_atual,spsw.cd_carteira_anterior)::text, '') = ''
	and	spsw.ie_situacao <> 'P'

) LOOP
	CALL import_users_to_psa_tws_pack.insert_beneficiary(rc_hpms_pls_segurado_web,v_id_application,v_id_datasource,v_id_client,v_id_role);
END LOOP;

END;

$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE import_users_to_psa_tws_pack.import_beneficiaries () FROM PUBLIC;