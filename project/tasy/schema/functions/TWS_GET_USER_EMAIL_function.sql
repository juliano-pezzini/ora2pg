-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION tws_get_user_email (NM_USUARIO_ORIG_P text) RETURNS varchar AS $body$
DECLARE

    DS_RESULT_W WSUITE_SOLIC_INCLUSAO_PF.DS_EMAIL%type;


BEGIN
    IF (NM_USUARIO_ORIG_P IS NOT NULL AND NM_USUARIO_ORIG_P::text <> '') THEN
        SELECT
            MAX(WS.DS_EMAIL)
            INTO STRICT DS_RESULT_W
        FROM 
            WSUITE_USUARIO WU,
            WSUITE_SOLIC_INCLUSAO_PF WS
        WHERE WU.DS_LOGIN = NM_USUARIO_ORIG_P
        AND WU.NR_SEQ_INCLUSAO_PF = WS.NR_SEQUENCIA;
    END IF;
    RETURN DS_RESULT_W;
END;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION tws_get_user_email (NM_USUARIO_ORIG_P text) FROM PUBLIC;

