-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_funcionarios_comunicacao () RETURNS varchar AS $body$
DECLARE


ds_retorno_w	varchar(4000) := '';
nm_usuario_w	varchar(15);

C01 CURSOR FOR
	SELECT	obter_usuario_pf(cd_pessoa_fisica)
	from	pessoa_fisica
	where	ie_funcionario  = 'S'
	and	(obter_usuario_pf(cd_pessoa_fisica) IS NOT NULL AND (obter_usuario_pf(cd_pessoa_fisica))::text <> '');


BEGIN

open C01;
loop
fetch C01 into
	nm_usuario_w;
EXIT WHEN NOT FOUND; /* apply on C01 */
	begin
	if (coalesce(nm_usuario_w,' ') <> ' ') then
		ds_retorno_w := substr(ds_retorno_w || nm_usuario_w || ',',1,4000);
	end if;
	end;
end loop;
close C01;

return ds_retorno_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_funcionarios_comunicacao () FROM PUBLIC;

