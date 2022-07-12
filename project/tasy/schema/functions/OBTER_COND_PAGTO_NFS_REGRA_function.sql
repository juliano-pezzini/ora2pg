-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_cond_pagto_nfs_regra ( cd_estabelecimento_p bigint, cd_convenio_p bigint, dt_parametro_p timestamp) RETURNS bigint AS $body$
DECLARE


cd_condicao_pagamento_w	bigint;

BEGIN

select	coalesce(max(cd_condicao_pagamento),0)
into STRICT	cd_condicao_pagamento_w
from 	convenio_regra_venc
where	coalesce(clock_timestamp(), clock_timestamp()) between trunc(coalesce(dt_inicio_vigencia, clock_timestamp() - interval '1 days'), 'dd') and fim_dia(coalesce(dt_fim_vigencia, clock_timestamp() + interval '1 days'))
and	(to_char(coalesce(clock_timestamp(), clock_timestamp()), 'dd'))::numeric  between coalesce(qt_dia_mes_inicial, 1) and coalesce(qt_dia_mes_final, 31)
and	cd_convenio = cd_convenio_p
and	cd_estabelecimento = cd_estabelecimento_p;

if (cd_condicao_pagamento_w = 0) then
	select	coalesce(max(cd_condicao_pagamento),0)
	into STRICT	cd_condicao_pagamento_w
	from 	parametro_nfs
	where	cd_convenio = cd_convenio_p
	and	coalesce(cd_estabelecimento,cd_estabelecimento_p) = cd_estabelecimento_p;
end if;

if (cd_condicao_pagamento_w = 0) then
	cd_condicao_pagamento_w := null;
end if;

return	cd_condicao_pagamento_w;
end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_cond_pagto_nfs_regra ( cd_estabelecimento_p bigint, cd_convenio_p bigint, dt_parametro_p timestamp) FROM PUBLIC;
