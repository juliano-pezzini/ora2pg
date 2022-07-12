-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_ie_tipo_proc_3m ( ie_proc_princ_atend_p text ) RETURNS varchar AS $body$
DECLARE

    ie_tipo_proc_w   varchar(40);

BEGIN
    IF (ie_proc_princ_atend_p IS NOT NULL AND ie_proc_princ_atend_p::text <> '')THEN

        IF ( ie_proc_princ_atend_p = 'S' )THEN
            ie_tipo_proc_w := 'HL';
        END IF;
    END IF;

    ie_tipo_proc_w := coalesce(ie_tipo_proc_w,'');

    RETURN ie_tipo_proc_w;

END;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_ie_tipo_proc_3m ( ie_proc_princ_atend_p text ) FROM PUBLIC;

