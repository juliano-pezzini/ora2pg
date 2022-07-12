-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_se_conta_anexo ( nr_interno_conta_p bigint) RETURNS varchar AS $body$
DECLARE


ds_retorno_w	varchar(1) := 'N';
qt_anexo_w	bigint;


BEGIN

if (nr_interno_conta_p IS NOT NULL AND nr_interno_conta_p::text <> '') then
	select	count(*)
	into STRICT	qt_anexo_w
	from	conta_paciente_anexo
	where	nr_interno_conta = nr_interno_conta_p;

	if (qt_anexo_w > 0) then
		ds_retorno_w := 'S';
	end if;
end if;

return	ds_retorno_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_se_conta_anexo ( nr_interno_conta_p bigint) FROM PUBLIC;

