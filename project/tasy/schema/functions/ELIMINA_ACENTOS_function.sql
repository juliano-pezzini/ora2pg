-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION elimina_acentos ( ds_campo_p text, ie_remove_cedilha text default 'N') RETURNS varchar AS $body$
DECLARE

ds_campo_w    	varchar(2000);

BEGIN
    select Elimina_Acentos_longo(ds_campo_p, ie_remove_cedilha)
    into STRICT ds_campo_w
;

    RETURN ds_Campo_w;
END;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION elimina_acentos ( ds_campo_p text, ie_remove_cedilha text default 'N') FROM PUBLIC;
