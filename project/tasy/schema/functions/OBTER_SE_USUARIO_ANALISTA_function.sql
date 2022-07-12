-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_se_usuario_analista (nm_usuario_p text, ie_opcao_p text) RETURNS varchar AS $body$
DECLARE


--ie_opcao:
-- "S" - Analista de Sistema
-- "M" - Analista de Manutenção
-- "N" - Analista de Negocio
--SM - Analista de sistema ou manutenção
qt_result_w		smallint;
ds_retorno_w		varchar(10);


BEGIN

if (nm_usuario_p IS NOT NULL AND nm_usuario_p::text <> '') then

	if (ie_opcao_p = 'S') then

		select count(*)
		into STRICT qt_result_w
		from USUARIO_GRUPO_DES
		where NM_USUARIO_GRUPO = nm_usuario_p
		and IE_FUNCAO_USUARIO = 'S';

	elsif (ie_opcao_p = 'M') then

		select count(*)
		into STRICT qt_result_w
		from USUARIO_GRUPO_DES
		where NM_USUARIO_GRUPO = nm_usuario_p
		and IE_FUNCAO_USUARIO = 'M';

	elsif (ie_opcao_p = 'N') then

		select count(*)
		into STRICT qt_result_w
		from USUARIO_GRUPO_DES
		where NM_USUARIO_GRUPO = nm_usuario_p
		and IE_FUNCAO_USUARIO = 'N';
	elsif (ie_opcao_p = 'SM') then
		select count(*)
		into STRICT qt_result_w
		from USUARIO_GRUPO_DES
		where NM_USUARIO_GRUPO = nm_usuario_p
		and IE_FUNCAO_USUARIO in ('S','M');

	end if;
end if;

if (qt_result_w > 0) then
	ds_retorno_w := 'S';
	else
	ds_retorno_w := 'N';
end if;

return	ds_retorno_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_se_usuario_analista (nm_usuario_p text, ie_opcao_p text) FROM PUBLIC;

