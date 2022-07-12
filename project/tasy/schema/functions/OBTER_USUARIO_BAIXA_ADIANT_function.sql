-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_usuario_baixa_adiant ( nr_adiantamento_p bigint, dt_referencia_p timestamp) RETURNS varchar AS $body$
DECLARE


ds_retorno_w	varchar(255);
nm_usuario_w	varchar(15);

c01 CURSOR FOR
SELECT	a.nm_usuario
from	adiantamento_baixa_v a
where	a.dt_baixa		<= dt_referencia_p
and	a.nr_adiantamento	= nr_adiantamento_p;


BEGIN

open	c01;
loop
fetch	c01 into
	nm_usuario_w;
EXIT WHEN NOT FOUND; /* apply on c01 */

	if (coalesce(ds_retorno_w::text, '') = '') then

		ds_retorno_w	:= nm_usuario_w;

	elsif (position(nm_usuario_w || ', ' in ds_retorno_w || ', ')	= 0) then

		ds_retorno_w	:= substr(ds_retorno_w || ', ' || nm_usuario_w,1,255);

	end if;

end	loop;
close	c01;

RETURN ds_retorno_w;

END;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_usuario_baixa_adiant ( nr_adiantamento_p bigint, dt_referencia_p timestamp) FROM PUBLIC;
