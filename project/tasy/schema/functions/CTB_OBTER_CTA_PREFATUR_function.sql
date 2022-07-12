-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION ctb_obter_cta_prefatur ( cd_empresa_p bigint, cd_estabelecimento_p bigint, cd_conta_contabil_p text, dt_vigencia_p timestamp) RETURNS varchar AS $body$
DECLARE


cd_conta_prefatur_w		varchar(20);
dt_vigencia_w			timestamp;

c01 CURSOR FOR
SELECT	a.cd_conta_prefatur
from	ctb_regra_cta_prefatur a
where	a.cd_empresa	= cd_empresa_p
and	a.cd_conta_contabil = cd_conta_contabil_p
and (a.dt_vigencia_inicial <= dt_vigencia_w and a.dt_vigencia_final >= dt_vigencia_w)
order by a.dt_vigencia_inicial;


BEGIN

dt_vigencia_w	:= trunc(coalesce(dt_vigencia_p,clock_timestamp()),'dd');

open C01;
loop
fetch C01 into
	cd_conta_prefatur_w;
EXIT WHEN NOT FOUND; /* apply on C01 */
	begin
	cd_conta_prefatur_w	:= cd_conta_prefatur_w;
	end;
end loop;
close C01;

return	coalesce(cd_conta_prefatur_w,cd_conta_contabil_p);

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION ctb_obter_cta_prefatur ( cd_empresa_p bigint, cd_estabelecimento_p bigint, cd_conta_contabil_p text, dt_vigencia_p timestamp) FROM PUBLIC;

