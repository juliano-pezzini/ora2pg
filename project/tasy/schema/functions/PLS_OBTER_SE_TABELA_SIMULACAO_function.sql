-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION pls_obter_se_tabela_simulacao (nr_seq_tabela_p bigint) RETURNS varchar AS $body$
DECLARE


ds_retorno_w		varchar(1);
dt_inicio_vigencia_w	timestamp;
dt_fim_vigencia_w	timestamp;
dt_liberacao_w		timestamp;
dt_atual_w		timestamp;

C01 CURSOR FOR
	SELECT	trunc(dt_inicio_vigencia,'dd'),
		trunc(dt_fim_vigencia,'dd'),
		trunc(dt_liberacao,'dd')
	from	pls_regra_simulador_web
	where	nr_seq_tabela	= nr_seq_tabela_p
	and	ds_retorno_w	= 'N'
	order by dt_inicio_vigencia desc;


BEGIN

ds_retorno_w	:= 'N';
dt_atual_w	:= trunc(clock_timestamp(),'dd');

open C01;
loop
fetch C01 into
	dt_inicio_vigencia_w,
	dt_fim_vigencia_w,
	dt_liberacao_w;
EXIT WHEN NOT FOUND; /* apply on C01 */
	begin
	if (dt_atual_w between dt_inicio_vigencia_w and coalesce(dt_fim_vigencia_w,dt_atual_w)) and (dt_atual_w >= dt_liberacao_w) then
		ds_retorno_w	:= 'S';
	end if;
	end;
end loop;
close C01;

return	ds_retorno_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION pls_obter_se_tabela_simulacao (nr_seq_tabela_p bigint) FROM PUBLIC;
