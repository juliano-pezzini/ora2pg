-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_libaracao_interna ( cd_codigo_alt_p bigint, nm_usuario_p text) RETURNS varchar AS $body$
DECLARE


ds_retorno_w	varchar(1) := 'S';
qt_total_w		bigint;


BEGIN

select	count(*)
into STRICT 	qt_total_w
from	cadastro_controle_interno
where	cd_codigo_alt = cd_codigo_alt_p;

if (qt_total_w > 0) then
	select coalesce(max('S'),'N')
	into STRICT 	ds_retorno_w
	from	cadastro_controle_interno
	where	cd_codigo_alt = cd_codigo_alt_p
	and		((nm_usuario_lib = nm_usuario_p) or (coalesce(ie_todos_lib, 'N') = 'S'));
end if;

return	ds_retorno_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_libaracao_interna ( cd_codigo_alt_p bigint, nm_usuario_p text) FROM PUBLIC;

