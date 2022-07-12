-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_se_categoria_lib_perf (cd_convenio_p bigint, cd_categoria_p text, cd_perfil_p bigint) RETURNS varchar AS $body$
DECLARE


ie_liberado_w		varchar(01)	:= 'S';
qt_regra_w		bigint;


BEGIN

select	count(*)
into STRICT	qt_regra_w
from	categoria_conv_estab_perf a,
	categoria_convenio b
where	a.cd_convenio		= cd_convenio_p
and	a.cd_categoria = b.cd_categoria
and	a.cd_convenio  = b.cd_convenio
and	b.ie_situacao = 'A'
and	a.cd_perfil		= cd_perfil_p;

if (qt_regra_w	<> 0) then
	select	coalesce(max('S'), 'N')
	into STRICT	ie_liberado_w
	from	categoria_conv_estab_perf
	where	cd_convenio		= cd_convenio_p
	and	cd_categoria		= cd_categoria_p
	and	cd_perfil		= cd_perfil_p;

end if;

return	ie_liberado_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_se_categoria_lib_perf (cd_convenio_p bigint, cd_categoria_p text, cd_perfil_p bigint) FROM PUBLIC;

