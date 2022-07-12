-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_menor_codigo_relat (ie_classif_relat_p text) RETURNS bigint AS $body$
DECLARE

 
cd_relatorio_w		integer;
cd_relatorio_old_w	integer;
cd_retorno_w		integer;
ie_classif_w		varchar(1);

C01 CURSOR FOR 
	SELECT	cd_relatorio 
	from	relatorio 
	where	substr(cd_classif_relat,1,1) <> ie_classif_w 
	AND	cd_relatorio > 0 
	order by 1;


BEGIN 
 
if (ie_classif_relat_p = 'C') then 
	ie_classif_w	:= 'W';
else 
	ie_classif_w	:= 'C';
end	if;
 
open C01;
loop 
	fetch C01 into 
		cd_relatorio_w;
	EXIT WHEN NOT FOUND; /* apply on c01 */
	begin 
		if	(cd_relatorio_w > (cd_relatorio_old_w + 1)) then 
			cd_retorno_w	:= 	(cd_relatorio_old_w + 1);
			exit;
		end	if;
		cd_relatorio_old_w	:= cd_relatorio_w;
	end;
end loop;
close C01;
 
Return	cd_retorno_w;
 
end	;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_menor_codigo_relat (ie_classif_relat_p text) FROM PUBLIC;
