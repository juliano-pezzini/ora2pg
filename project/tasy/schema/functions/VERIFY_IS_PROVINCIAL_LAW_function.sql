-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION verify_is_provincial_law ( nr_interno_conta_p CONTA_PACIENTE.NR_INTERNO_CONTA%type ) RETURNS varchar AS $body$
DECLARE


ds_return_w varchar(1);


BEGIN

    IF (PKG_I18N.GET_USER_LOCALE = 'es_AR') THEN
        SELECT CASE WHEN COUNT(1)=0 THEN  'N'  ELSE 'S' END 
        INTO STRICT   ds_return_w
        FROM   conta_paciente    
        WHERE  nr_conta_lei_prov = nr_interno_conta_p;
    ELSE
        ds_return_w := 'N';
    END IF;

    RETURN ds_return_w;
END;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION verify_is_provincial_law ( nr_interno_conta_p CONTA_PACIENTE.NR_INTERNO_CONTA%type ) FROM PUBLIC;

