-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION sl_obter_se_regra_perfil ( nr_seq_servico_p bigint, cd_perfil_p bigint) RETURNS varchar AS $body$
DECLARE


ds_retorno_w	varchar(1)	:= 'S';
qt_regra_w	bigint;
qt_regra_perfil_w	bigint;


BEGIN

select	count(*)
into STRICT	qt_regra_w
from	sl_servico_regra_perfil
where	nr_seq_servico	= nr_seq_servico_p;

if (qt_regra_w	> 0) then
	begin
	select	count(*)
	into STRICT	qt_regra_perfil_w
	from	sl_servico_regra_perfil
	where	nr_seq_servico	= nr_seq_servico_p
	and	cd_perfil	= cd_perfil_p;

	if (qt_regra_perfil_w = 0) then
		ds_retorno_w	:= 'N';
	end if;
	end;
end if;

return	ds_retorno_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION sl_obter_se_regra_perfil ( nr_seq_servico_p bigint, cd_perfil_p bigint) FROM PUBLIC;

