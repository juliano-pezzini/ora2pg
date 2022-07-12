-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION sus_obter_procedimento_editado (cd_procedimento_p bigint) RETURNS varchar AS $body$
DECLARE


ds_campo_w    		varchar(20);
cd_procedimento_w	varchar(15);

BEGIN
if (cd_procedimento_p IS NOT NULL AND cd_procedimento_p::text <> '') then
	cd_procedimento_w	:=	lpad(cd_procedimento_p,10,0);

	ds_campo_w		:= 	substr(cd_procedimento_w,1,2) || '.' ||
				   	substr(cd_procedimento_w,3,2) || '.' ||
					substr(cd_procedimento_w,5,2) || '.' ||
					substr(cd_procedimento_w,7,3) || '-' ||
					substr(cd_procedimento_w,10,1);

end if;
return ds_campo_w;

END;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION sus_obter_procedimento_editado (cd_procedimento_p bigint) FROM PUBLIC;
