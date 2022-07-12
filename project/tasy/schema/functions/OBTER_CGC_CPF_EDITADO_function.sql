-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_cgc_cpf_editado (ds_campo_p text) RETURNS varchar AS $body$
DECLARE


ds_campo_w    	varchar(20);

BEGIN
if (length(ds_campo_p) = 14) then
	ds_campo_w		:= 	substr(ds_campo_p,1,2) || '.' ||
					substr(ds_campo_p,3,3) || '.' ||
					substr(ds_campo_p,6,3) || '/' ||
					substr(ds_campo_p,9,4) || '-' ||
					substr(ds_campo_P,13,2);
elsif (length(ds_campo_p) = 11) then
	ds_campo_w		:= 	substr(ds_campo_p,1,3) || '.' ||
					substr(ds_campo_P,4,3) || '.' ||
					substr(ds_campo_P,7,3) || '-' ||
					substr(ds_campo_P,10,2);
else
	ds_campo_w		:= ds_campo_p;
end if;

RETURN ds_Campo_w;
END;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_cgc_cpf_editado (ds_campo_p text) FROM PUBLIC;
