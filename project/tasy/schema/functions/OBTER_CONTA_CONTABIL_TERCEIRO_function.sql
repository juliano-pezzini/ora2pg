-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_conta_contabil_terceiro ( nr_seq_terceiro_p bigint, cd_cgc_p text, cd_pessoa_fisica_p text, dt_vigencia_p timestamp, ie_opcao_p text) RETURNS varchar AS $body$
DECLARE


cd_conta_contabil_cr_w		varchar(20);
cd_conta_contabil_w		varchar(20);
cd_conta_retorno_w		varchar(20);
dt_vigencia_w			timestamp;

c01 CURSOR FOR
SELECT	a.cd_conta_contabil,
	a.cd_conta_contabil_cr
from	terceiro a
where	a.nr_sequencia	= nr_seq_terceiro_p
and	coalesce(a.dt_inicio_vigencia, dt_vigencia_w) >= dt_vigencia_w
and	coalesce(a.dt_fim_vigencia, dt_vigencia_w) <= dt_vigencia_w

union all

select	a.cd_conta_contabil,
	a.cd_conta_contabil_cr
from	terceiro a
where	coalesce(cd_pessoa_fisica,cd_cgc) = coalesce(cd_pessoa_fisica_p,cd_cgc_p)
and	coalesce(a.dt_inicio_vigencia, dt_vigencia_w) >= dt_vigencia_w
and	coalesce(a.dt_fim_vigencia, dt_vigencia_w) <= dt_vigencia_w
and	coalesce(nr_seq_terceiro_p,0) = 0;


BEGIN

dt_vigencia_w	:= coalesce(dt_vigencia_p, clock_timestamp());

open C01;
loop
fetch C01 into
	cd_conta_contabil_w,
	cd_conta_contabil_cr_w;
EXIT WHEN NOT FOUND; /* apply on C01 */
	begin

	if (ie_opcao_p = 'CP') then
		cd_conta_retorno_w	:= cd_conta_contabil_w;
	elsif (ie_opcao_p = 'CR') then
		cd_conta_retorno_w	:= cd_conta_contabil_cr_w;
	end if;

	end;
end loop;
close C01;

return	cd_conta_retorno_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_conta_contabil_terceiro ( nr_seq_terceiro_p bigint, cd_cgc_p text, cd_pessoa_fisica_p text, dt_vigencia_p timestamp, ie_opcao_p text) FROM PUBLIC;
