-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_se_proc_odontologia ( cd_procedimento_p bigint, ie_origem_proced_p bigint, nr_proc_interno_p bigint) RETURNS varchar AS $body$
DECLARE


cd_tipo_procedimento_w	procedimento.cd_tipo_procedimento%type := 0;
ds_retorno_w			varchar(1) := 'N';		


BEGIN

if (coalesce(cd_procedimento_p, 0) > 0) and (coalesce(ie_origem_proced_p, 0) > 0) then

	select 	coalesce(max(cd_tipo_procedimento), 0)
	into STRICT 	cd_tipo_procedimento_w
	from 	procedimento
	where 	cd_procedimento = cd_procedimento_p
	and 	ie_origem_proced = ie_origem_proced_p;

end if;

if (cd_tipo_procedimento_w = 0) and (coalesce(nr_proc_interno_p, 0) > 0) then

	select 	coalesce(max(cd_tipo_procedimento), 0)
	into STRICT 	cd_tipo_procedimento_w
	from 	procedimento
	where 	nr_proc_interno = to_char(nr_proc_interno_p);

end if;

if (cd_tipo_procedimento_w = 158) then

	ds_retorno_w := 'S';

end if;

return	ds_retorno_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_se_proc_odontologia ( cd_procedimento_p bigint, ie_origem_proced_p bigint, nr_proc_interno_p bigint) FROM PUBLIC;
