-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_conta_financ_regra_fc (cd_empresa_p bigint, ie_regra_p text, cd_cgc_p text, cd_convenio_p bigint, dt_referencia_p timestamp, cd_estabelecimento_p bigint) RETURNS bigint AS $body$
DECLARE


cd_conta_financ_w		bigint := null;
cd_cgc_w		varchar(20);
cd_tipo_pessoa_w		bigint;
dt_referencia_w		timestamp;
ie_regra_w		varchar(1);

c01 CURSOR FOR
SELECT	cd_conta_financeira
from	regra_conta_financ_fc
where	coalesce(cd_estabelecimento,coalesce(cd_estabelecimento_p,0)) = coalesce(cd_estabelecimento_p,0)
and	cd_empresa			= cd_empresa_p
and	coalesce(cd_tipo_pessoa, cd_tipo_pessoa_w)	= cd_tipo_pessoa_w
and	coalesce(cd_cgc, cd_cgc_w)		= cd_cgc_w
and	coalesce(cd_convenio,coalesce(cd_convenio_p,0))	= coalesce(cd_convenio_p,0)
and	ie_regra				= ie_regra_p
and	ie_situacao			= 'A'
and	dt_referencia_w between
	coalesce(dt_inicio_vigencia,dt_referencia_w) and coalesce(dt_fim_vigencia,dt_referencia_w)
order by	coalesce(cd_tipo_pessoa,0),
	coalesce(cd_convenio,0),
	coalesce(cd_cgc,0);


BEGIN

dt_referencia_w	:= trunc(dt_referencia_p,'dd');

begin
select	'S'
into STRICT	ie_regra_w
from	regra_conta_financ_fc
where	ie_regra = ie_regra_p  LIMIT 1;
exception
when others then
	ie_regra_w := 'N';
end;

if (ie_regra_w = 'S') then
	begin
	select	coalesce(max(cd_cgc),'X'),
		coalesce(max(cd_tipo_pessoa),0)
	into STRICT	cd_cgc_w,
		cd_tipo_pessoa_w
	from	pessoa_juridica
	where	cd_cgc		= cd_cgc_p;

	open c01;
	loop
	fetch c01 into
		cd_conta_financ_w;
	EXIT WHEN NOT FOUND; /* apply on c01 */
	end loop;
	close c01;
	end;
end if;

return	cd_conta_financ_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_conta_financ_regra_fc (cd_empresa_p bigint, ie_regra_p text, cd_cgc_p text, cd_convenio_p bigint, dt_referencia_p timestamp, cd_estabelecimento_p bigint) FROM PUBLIC;
