-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_se_medico_estab2 (cd_medico_p text, cd_estabelecimento_p bigint) RETURNS varchar AS $body$
DECLARE


ds_retorno_w	varchar(1):= 'S';
qt_reg_w	bigint;
qt_reg_estab_w	bigint;
cd_empresa_w	smallint;


BEGIN

select	count(*)
into STRICT	qt_reg_w
from	medico_estabelecimento
where	cd_pessoa_fisica = cd_medico_p;

if (qt_reg_w > 0) then

	select	coalesce(max(cd_empresa),0)
	into STRICT	cd_empresa_w
	from	estabelecimento
	where	cd_estabelecimento = cd_estabelecimento_p;

	select	count(*)
	into STRICT	qt_reg_estab_w
	from	medico_estabelecimento
	where	cd_pessoa_fisica				= cd_medico_p
	and	coalesce(cd_estabelecimento, cd_estabelecimento_p)	= cd_estabelecimento_p
	and	coalesce(cd_empresa, cd_empresa_w)			= cd_empresa_w;

	if (qt_reg_estab_w = 0) then
		ds_retorno_w := 'N';
	end if;

end if;

return	ds_retorno_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_se_medico_estab2 (cd_medico_p text, cd_estabelecimento_p bigint) FROM PUBLIC;

