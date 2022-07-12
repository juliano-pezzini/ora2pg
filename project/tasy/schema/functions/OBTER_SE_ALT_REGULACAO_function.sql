-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_se_alt_regulacao (nr_sequencia_p bigint) RETURNS varchar AS $body$
DECLARE

ds_retorno_w	varchar(10);

BEGIN

if (nr_sequencia_p > 0) then
	select 	max(nm_usuario_alt)
	into STRICT	ds_retorno_w
	from	eme_regulacao
	where	nr_sequencia = nr_sequencia_p
        and     coalesce(dt_bloqueio,clock_timestamp() - interval '1 days') + 1/72 > clock_timestamp(); -- Para que o bloqueio dure 20 minutos
else
	ds_retorno_w := '';
end if;

return	ds_retorno_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_se_alt_regulacao (nr_sequencia_p bigint) FROM PUBLIC;

