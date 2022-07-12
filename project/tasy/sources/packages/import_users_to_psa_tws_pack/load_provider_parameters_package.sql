-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';




CREATE OR REPLACE PROCEDURE import_users_to_psa_tws_pack.load_provider_parameters ( id_hpms_application_p INOUT application.id%TYPE, id_hpms_datasource_p INOUT datasource.id%TYPE, id_provider_client_p INOUT client.id%TYPE, id_provider_role_p INOUT role.id%TYPE, should_validate_p boolean DEFAULT true) AS $body$
DECLARE

					
const_try_configuration_first   CONSTANT varchar(100) := 'Try to execute configure_psa_tws_pack.configure_psa_tws_provider first.';


BEGIN

id_hpms_application_p := NULL;
id_hpms_datasource_p := NULL;
id_provider_client_p := NULL;
id_provider_role_p := NULL;

SELECT	id
INTO STRICT 	id_hpms_application_p
FROM	application
WHERE	nm_application = 'hpms';

SELECT	id
INTO STRICT 	id_hpms_datasource_p
FROM	datasource
WHERE	nm_datasource = 'WTASY'
AND 	id_application = id_hpms_application_p;

SELECT	id
INTO STRICT 	id_provider_client_p
FROM	client
WHERE	nm_client = 'providerHpms'
AND 	id_application = id_hpms_application_p;

SELECT	id
INTO STRICT 	id_provider_role_p
FROM	role
WHERE	nm_role = 'providerHpms'
AND	id_application = id_hpms_application_p;
EXCEPTION
WHEN 	no_data_found THEN

IF
	coalesce(id_hpms_application_p::text, '') = '' AND should_validate_p
THEN
	CALL wheb_mensagem_pck.exibir_mensagem_abort('HPMS application is null. ' || const_try_configuration_first);
END IF;

IF
	coalesce(id_hpms_datasource_p::text, '') = '' AND should_validate_p
THEN
	CALL wheb_mensagem_pck.exibir_mensagem_abort('HPMS datasource is null. ' || const_try_configuration_first);
END IF;

IF
	coalesce(id_provider_client_p::text, '') = '' AND should_validate_p
THEN
	CALL wheb_mensagem_pck.exibir_mensagem_abort('HPMS provider client is null. ' || const_try_configuration_first);
END IF;

IF
	(id_provider_role_p IS NOT NULL AND id_provider_role_p::text <> '') AND should_validate_p
THEN
	CALL wheb_mensagem_pck.exibir_mensagem_abort('HPMS provider role is null. ' || const_try_configuration_first);
END IF;

END;

$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE import_users_to_psa_tws_pack.load_provider_parameters ( id_hpms_application_p INOUT application.id%TYPE, id_hpms_datasource_p INOUT datasource.id%TYPE, id_provider_client_p INOUT client.id%TYPE, id_provider_role_p INOUT role.id%TYPE, should_validate_p boolean DEFAULT true) FROM PUBLIC;