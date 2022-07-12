-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_origem_proced_cat ( cd_estabelecimento_p bigint, ie_tipo_atendimento_p bigint, ie_tipo_convenio_p bigint, cd_convenio_p bigint, cd_categoria_p text) RETURNS bigint AS $body$
DECLARE


ie_origem_proced_w	bigint;
qt_reg_sus_unif_w	smallint	:= 0;

c01 CURSOR FOR
SELECT	ie_origem_proced
from 	regra_origem_proced
where 	coalesce(ie_tipo_convenio, coalesce(ie_tipo_convenio_p,0))		= coalesce(ie_tipo_convenio_p,0)
and 	coalesce(ie_tipo_atendimento, coalesce(ie_tipo_atendimento_p,0)) 	= coalesce(ie_tipo_atendimento_p,0)
and 	coalesce(cd_convenio, coalesce(cd_convenio_p,0)) 		= coalesce(cd_convenio_p,0)
and 	coalesce(cd_categoria, coalesce(cd_categoria_p,0)) 		= coalesce(cd_categoria_p,0)
and	cd_estabelecimento					= coalesce(cd_estabelecimento_p, cd_estabelecimento)
order by
	coalesce(cd_categoria,0),
	coalesce(cd_convenio,0),
	coalesce(ie_tipo_convenio,0),
	coalesce(ie_tipo_atendimento,0);


BEGIN

ie_origem_proced_w	:= 1;

if (coalesce(ie_tipo_convenio_p, 2) = 3) then
	select	count(*)
	into STRICT	qt_reg_sus_unif_w
	from	regra_origem_proced
	where	ie_origem_proced	= 7
	and	coalesce(ie_tipo_convenio, coalesce(ie_tipo_convenio_p,0))		= coalesce(ie_tipo_convenio_p,0)
	and 	coalesce(ie_tipo_atendimento, coalesce(ie_tipo_atendimento_p,0)) 	= coalesce(ie_tipo_atendimento_p,0)
	and 	coalesce(cd_convenio, coalesce(cd_convenio_p,0)) 		= coalesce(cd_convenio_p,0)
	and 	coalesce(cd_categoria, coalesce(cd_categoria_p,0)) 		= coalesce(cd_categoria_p,0);

	if (qt_reg_sus_unif_w	> 0) then
		ie_origem_proced_w	:= 7;
	elsif (coalesce(ie_tipo_atendimento_p, 1) = 1) then
		ie_origem_proced_w	:= 2;
	else
		ie_origem_proced_w	:= 3;
	end if;
else
	open c01;
	loop
	fetch c01 into
		ie_origem_proced_w;
	EXIT WHEN NOT FOUND; /* apply on c01 */
		ie_origem_proced_w	:= ie_origem_proced_w;
	end loop;
	close c01;
end if;

return ie_origem_proced_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_origem_proced_cat ( cd_estabelecimento_p bigint, ie_tipo_atendimento_p bigint, ie_tipo_convenio_p bigint, cd_convenio_p bigint, cd_categoria_p text) FROM PUBLIC;

