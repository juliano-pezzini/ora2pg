-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_se_conv_ret ( cd_setor_p bigint, cd_estabelecimento_p bigint, cd_convenio_p bigint) RETURNS varchar AS $body$
DECLARE


qt_permissoes_w	bigint;
qt_w		bigint;
ie_permissao_w	varchar(1);


BEGIN

select	count(*)
into STRICT	qt_permissoes_w
from	convenio_ret_setor
where	cd_estabelecimento	= cd_estabelecimento_p
and	cd_convenio		= cd_convenio_p;

ie_permissao_w := 'S';

if (qt_permissoes_w > 0) then

	select 	count(*)
	into STRICT 	qt_w
	from	convenio_ret_setor
	where	cd_estabelecimento	= cd_estabelecimento_p
	and	cd_setor_atendimento	= cd_setor_p
	and	cd_convenio		= cd_convenio_p;
end if;

if (qt_w <= 0) then
	ie_permissao_w := 'N';
end if;

return	ie_permissao_w;

END;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_se_conv_ret ( cd_setor_p bigint, cd_estabelecimento_p bigint, cd_convenio_p bigint) FROM PUBLIC;
