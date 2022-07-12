-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_se_conv_lib_check_up ( cd_estabelecimento_p bigint, cd_convenio_p bigint, cd_funcao_p bigint, cd_perfil_p bigint, dt_referencia_p timestamp) RETURNS varchar AS $body$
DECLARE


ie_permite_w		varchar(1);
ds_retorno_w		varchar(01)	:= 'S';
qt_regra_w		bigint;
dt_referencia_w		timestamp;
qt_convenio_w		bigint;

c01 CURSOR FOR
	SELECT	coalesce(a.ie_permite_convenio,'S')
	from	conveio_estab_func_lib a
	where	a.cd_estabelecimento		= cd_estabelecimento_p
	and	a.cd_funcao			= cd_funcao_p
	and	a.cd_convenio			= cd_convenio_p
	and (coalesce(a.dt_inicio_regra,dt_referencia_w)		<= dt_referencia_w)
	and	coalesce(a.cd_perfil, cd_perfil_p)	= cd_perfil_p
	order by coalesce(a.cd_perfil,999);


BEGIN

dt_referencia_w	:= coalesce(dt_referencia_p,clock_timestamp());

select	count(*)
into STRICT	qt_regra_w
from	conveio_estab_func_lib a
where	a.cd_estabelecimento		= cd_estabelecimento_p
and	a.cd_funcao			= cd_funcao_p
and	a.cd_convenio			= cd_convenio_p
and (coalesce(a.dt_inicio_regra,dt_referencia_w)		<= dt_referencia_w)  LIMIT 1;

if (qt_regra_w	> 0) then
	open c01;
	loop
	fetch c01 into
		ie_permite_w;
	EXIT WHEN NOT FOUND; /* apply on c01 */
		begin
		ds_retorno_w	:= ie_permite_w;
		end;
	end loop;
	close c01;
end if;

return	ds_retorno_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_se_conv_lib_check_up ( cd_estabelecimento_p bigint, cd_convenio_p bigint, cd_funcao_p bigint, cd_perfil_p bigint, dt_referencia_p timestamp) FROM PUBLIC;
