-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_conta_particular_aberta ( nr_atendimento_p bigint) RETURNS varchar AS $body$
DECLARE


nr_conta_w	bigint;
ds_retorno_w	varchar(255);

C01 CURSOR FOR
	SELECT	a.nr_interno_conta
	from	conta_paciente a,
		convenio b
	where	a.cd_convenio_parametro = b.cd_convenio
	and	a.nr_atendimento = nr_atendimento_p
	and	a.ie_status_acerto = 1
	and	b.ie_tipo_convenio = 1;

BEGIN

for r_c01 in c01 loop
	begin
	ds_retorno_w := substr(ds_retorno_w || r_c01.nr_interno_conta || ', ',1,255);
	end;
end loop;

ds_retorno_w := substr(ds_retorno_w,1,length(trim(both ds_retorno_w))-1);

return	ds_retorno_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_conta_particular_aberta ( nr_atendimento_p bigint) FROM PUBLIC;

