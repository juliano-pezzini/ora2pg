-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_setor_exclusivo_painel (nm_usuario_p text) RETURNS varchar AS $body$
DECLARE


ie_setor_exclusivo_w	varchar(2000);
cd_setor_atendimento_w	integer;

C01 CURSOR FOR
	SELECT 	cd_setor_atendimento||''
	FROM 	usuario_Setor_v
	WHERE 	nm_usuario = nm_usuario_p;

BEGIN

ie_setor_exclusivo_w := '';
open C01;
loop
fetch C01 into
	cd_setor_atendimento_w;
EXIT WHEN NOT FOUND; /* apply on C01 */
	begin
	if (ie_setor_exclusivo_w IS NOT NULL AND ie_setor_exclusivo_w::text <> '') then
		ie_setor_exclusivo_w := substr(ie_setor_exclusivo_w ||','|| cd_setor_atendimento_w,1,2000);
	else
		ie_setor_exclusivo_w := cd_setor_atendimento_w;
	end if;
	end;
end loop;
close C01;



return	ie_setor_exclusivo_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_setor_exclusivo_painel (nm_usuario_p text) FROM PUBLIC;
