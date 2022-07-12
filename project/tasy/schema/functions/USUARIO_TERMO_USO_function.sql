-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION usuario_termo_uso ( nm_usuario_p text ) RETURNS varchar AS $body$
DECLARE

    ie_termo_uso_w   varchar(10);

BEGIN
    IF (nm_usuario_p IS NOT NULL AND nm_usuario_p::text <> '')
    THEN
        BEGIN
            SELECT
                ie_termo_uso
            INTO STRICT
                ie_termo_uso_w
            FROM
                usuario
            WHERE
                nm_usuario = nm_usuario_p;

        END;
    END IF;

    RETURN ie_termo_uso_w;
END;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION usuario_termo_uso ( nm_usuario_p text ) FROM PUBLIC;
