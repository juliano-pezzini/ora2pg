-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE send_sms_audit ( SENDER_PARAM text , RECIPIENT_PARAM text , MESSAGE_PARAM text , SERVER_PROXY_PARAM text , USER_PROXY_PARAM text , PASSWORD_PROXY_PARAM text , SMS_ID_PARAM bigint ) AS $body$
DECLARE


    REQ utl_http.req;
    RES utl_http.resp;
    CONTENT_DATA text;
    SMS_ID varchar(1000);
    SENDER varchar(1000);
    RECIPIENT varchar(1000);
    MESSAGE varchar(1000);
    SERVER_PROXY varchar(1000);
    USER_PROXY varchar(1000);
    PASSWORD_PROXY varchar(1000);
    USER_ID varchar(1000);
    USER_FULLNAME varchar(1000);
    ESTABLISHMENT_CODE varchar(1000);
    ESTABLISHMENT_NAME varchar(1000);
    ADDRESS_SERVER varchar(255);

BEGIN

    SMS_ID := AE_FORMAT_JSON_NUMBER(SMS_ID_PARAM);
    SENDER := AE_FORMAT_JSON_STRING(SENDER_PARAM);
    RECIPIENT := AE_FORMAT_JSON_STRING(RECIPIENT_PARAM);
    MESSAGE := AE_FORMAT_JSON_STRING(MESSAGE_PARAM);
    SERVER_PROXY := AE_FORMAT_JSON_STRING(SERVER_PROXY_PARAM);
    USER_PROXY := AE_FORMAT_JSON_STRING(USER_PROXY_PARAM);
    PASSWORD_PROXY := AE_FORMAT_JSON_STRING(PASSWORD_PROXY_PARAM);
    USER_ID := AE_FORMAT_JSON_STRING(wheb_usuario_pck.get_nm_usuario);
    USER_FULLNAME := AE_FORMAT_JSON_STRING(null);
    ESTABLISHMENT_CODE := AE_FORMAT_JSON_NUMBER(wheb_usuario_pck.get_cd_estabelecimento);
    ESTABLISHMENT_NAME := AE_FORMAT_JSON_STRING(null);

    CONTENT_DATA := '{
        "smsId": ' || SMS_ID || ',
        "sender": ' || SENDER || ',
        "recipient": ' || RECIPIENT || ',
        "message": ' || MESSAGE || ',
        "serverProxy": ' || SERVER_PROXY || ',
        "userProxy": ' || USER_PROXY || ',
        "passwordProxy": ' || PASSWORD_PROXY || ',
        "userId": ' || USER_ID || ',
        "userFullName": ' || USER_FULLNAME || ',
        "establishmentCode": ' || ESTABLISHMENT_CODE || ',
        "establishmentName": ' || ESTABLISHMENT_NAME || '
        }';

    ADDRESS_SERVER := obter_valor_param_usuario(0, 227, 0, wheb_usuario_pck.get_nm_usuario, wheb_usuario_pck.get_cd_estabelecimento);

    IF (ADDRESS_SERVER IS NOT NULL AND ADDRESS_SERVER::text <> '') THEN
        REQ := utl_http.begin_request(ADDRESS_SERVER || '/javaproc/rest/br/com/wheb/funcoes/sms/audit', 'POST',' HTTP/1.1');
        utl_http.set_header(REQ, 'content-type', 'application/json');
        utl_http.set_header(REQ, 'Content-Length', LENGTH(CONTENT_DATA));

        utl_http.write_text(REQ, CONTENT_DATA);

        RES := utl_http.get_response(REQ);

        BEGIN
            utl_http.end_response(RES);
        EXCEPTION
            WHEN utl_http.end_of_body THEN
                utl_http.end_response(RES);
        END;
    END IF;

END;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE send_sms_audit ( SENDER_PARAM text , RECIPIENT_PARAM text , MESSAGE_PARAM text , SERVER_PROXY_PARAM text , USER_PROXY_PARAM text , PASSWORD_PROXY_PARAM text , SMS_ID_PARAM bigint ) FROM PUBLIC;
