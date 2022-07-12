-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_se_somente_ponto_numero ( ds_campo_p text) RETURNS varchar AS $body$
DECLARE


i		integer;
ie_status_w	varchar(1);


BEGIN

ie_status_w := 'A';

if (ds_campo_p IS NOT NULL AND ds_campo_p::text <> '') then
	begin
	for i in 1 .. length(ds_campo_p) loop
		begin
		if (ie_status_w = 'A') then
			if	not(substr(ds_campo_p,i,1) in ('1','2','3','4','5','6','7','8','9','0','.')) then
				ie_status_w := 'I';
			else
				ie_status_w := 'A';
			end if;
		end if;
		end;
	end loop;
	end;
end if;

return ie_status_w;
end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_se_somente_ponto_numero ( ds_campo_p text) FROM PUBLIC;

