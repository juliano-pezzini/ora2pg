-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_titulos_pendentes (nr_atendimento_p bigint) RETURNS varchar AS $body$
DECLARE


nr_titulo_retorno_w	varchar(255) := null;
nr_titulo_w		bigint;
dt_vencimento_w		timestamp;

c01 CURSOR FOR
	SELECT	b.nr_titulo nr_titulo
	from	titulo_receber b
	where	b.nr_atendimento = nr_atendimento_p
	and	b.ie_situacao 	 = '1'
	and	b.dt_vencimento  < clock_timestamp();


BEGIN

open	c01;
loop
fetch	c01	into nr_titulo_w;
EXIT WHEN NOT FOUND; /* apply on c01 */
	begin

	nr_titulo_retorno_w	:= nr_titulo_retorno_w || nr_titulo_w || ',';

	end;
end loop;
close c01;

RETURN	nr_titulo_retorno_w;

END	;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_titulos_pendentes (nr_atendimento_p bigint) FROM PUBLIC;

