-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';




CREATE OR REPLACE FUNCTION bifrost.gettenanttoken () RETURNS varchar AS $body$
DECLARE

    keycloak_params varchar(1024);
    keycloak_url varchar(1000);
    keycloak_grant_type varchar(100);
    keycloak_client_id varchar(100);
    keycloak_username varchar(100);
    keycloak_password varchar(100);
    keycloak_config_exists integer := 0;
    request   UTL_HTTP.REQ;
    response  UTL_HTTP.RESP;
    resultValue varchar(5000);
    resultBuffer varchar(5000);
	accessToken varchar(2000);

BEGIN

    SELECT COALESCE(
        (SELECT 1
            WHERE EXISTS (SELECT 1 FROM ENVIRONMENT_CONFIGURATIONS WHERE configuration_key = 'philips.cloud.keycloak.url')
            AND   EXISTS (SELECT 1 FROM ENVIRONMENT_CONFIGURATIONS WHERE configuration_key = 'philips.cloud.keycloak.grant_type')
            AND   EXISTS (SELECT 1 FROM ENVIRONMENT_CONFIGURATIONS WHERE configuration_key = 'philips.cloud.keycloak.client_id')
            AND   EXISTS (SELECT 1 FROM ENVIRONMENT_CONFIGURATIONS WHERE configuration_key = 'philips.cloud.keycloak.username')
            AND   EXISTS (SELECT 1 FROM ENVIRONMENT_CONFIGURATIONS WHERE configuration_key = 'philips.cloud.keycloak.password')
        ),0
    ) INTO STRICT keycloak_config_exists;

    if keycloak_config_exists = 1 then

        select configuration_value into STRICT keycloak_url from ENVIRONMENT_CONFIGURATIONS where configuration_key = 'philips.cloud.keycloak.url';
        select configuration_value into STRICT keycloak_grant_type from ENVIRONMENT_CONFIGURATIONS where configuration_key = 'philips.cloud.keycloak.grant_type';
        select configuration_value into STRICT keycloak_client_id from ENVIRONMENT_CONFIGURATIONS where configuration_key = 'philips.cloud.keycloak.client_id';
        select configuration_value into STRICT keycloak_username from ENVIRONMENT_CONFIGURATIONS where configuration_key = 'philips.cloud.keycloak.username';
        select configuration_value into STRICT keycloak_password from ENVIRONMENT_CONFIGURATIONS where configuration_key = 'philips.cloud.keycloak.password';

        keycloak_params := 'grant_type=' || keycloak_grant_type || chr(38) || 'client_id=' || keycloak_client_id || chr(38) || 'username=' || keycloak_username || chr(38) || 'password=' || keycloak_password;

        request := UTL_HTTP.BEGIN_REQUEST(keycloak_url, 'POST', 'HTTP/1.1');

        UTL_HTTP.SET_HEADER(r      => request,
                             name   => 'Content-Type', 
                             value  => 'application/x-www-form-urlencoded');

        UTL_HTTP.SET_HEADER(r      => request,
                             name   => 'Content-Length', 
                             value  => length(keycloak_params));

        UTL_HTTP.WRITE_TEXT(r      =>   request,
                             data   =>   keycloak_params);

        response := UTL_HTTP.GET_RESPONSE(request);

        begin

            loop
                utl_http.read_line(response, resultBuffer, true);
                resultValue := resultValue || resultBuffer;
            end loop;

            utl_http.end_response(response);

        exception
        when utl_http.end_of_body then
            utl_http.end_response(response);

        end;

        accessToken := regexp_substr(resultValue,'"access_token"[^,]+');
        accessToken := substr(accessToken,position(':' in accessToken)+1);
        accessToken := trim(both '"' from trim(both accessToken));

		return accessToken;

    else

        return null;

    end if;

exception when no_data_found then

    return null;

END;

$body$
LANGUAGE PLPGSQL
;
-- REVOKE ALL ON FUNCTION bifrost.gettenanttoken () FROM PUBLIC;
