-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_tipo_atend_lib_categoria (cd_convenio_p bigint, cd_categoria_p text, ie_tipo_atendimento_p text, cd_estabelecimento_p bigint, dt_atendimento_p timestamp) RETURNS varchar AS $body$
DECLARE


ie_liberado_w		varchar(01)	:= 'S';
qt_regra_w		bigint;
dt_atendimento_w	timestamp;


BEGIN

dt_atendimento_w	:= trunc(dt_atendimento_p);

select	count(*)
into STRICT	qt_regra_w
from	categoria_tipo_atend
where	cd_convenio	= cd_convenio_p
and	cd_categoria	= cd_categoria_p
and	ie_situacao	= 'A';

if (qt_regra_w > 0) then

	select	coalesce(max('S'), 'N')
	into STRICT	ie_liberado_w
	from	categoria_tipo_atend
	where	cd_convenio	= cd_convenio_p
	and	cd_categoria	= cd_categoria_p
	and	ie_tipo_atendimento	= ie_tipo_atendimento_p
	and	ie_situacao	= 'A'
	and coalesce(cd_estabelecimento, cd_estabelecimento_p) = cd_estabelecimento_p;
	/* Possível Futuro Tratamento */

	--and	dt_atendimento_w between nvl(dt_inicio_vigencia,dt_atendimento_w) and nvl(DT_FINAL_VIGENCIA,dt_atendimento_w)
end if;

return	ie_liberado_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_tipo_atend_lib_categoria (cd_convenio_p bigint, cd_categoria_p text, ie_tipo_atendimento_p text, cd_estabelecimento_p bigint, dt_atendimento_p timestamp) FROM PUBLIC;
