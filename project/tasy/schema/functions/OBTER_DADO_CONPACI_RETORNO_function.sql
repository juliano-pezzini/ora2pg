-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_dado_conpaci_retorno ( nr_interno_conta_p bigint, nm_campo_p text) RETURNS varchar AS $body$
DECLARE


ds_retorno_w		varchar(100);


BEGIN

if (upper(nm_campo_p) = 'DT_INICIAL') then
	select max(to_char(dt_inicial, 'dd/mm/yyyy hh24:mi:ss'))
	into STRICT ds_retorno_w
	from conta_paciente_retorno
	where nr_interno_conta = nr_interno_conta_p;
end if;

return ds_retorno_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_dado_conpaci_retorno ( nr_interno_conta_p bigint, nm_campo_p text) FROM PUBLIC;

