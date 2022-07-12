-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_data_max_vig_brasindice (cd_estabelecimento_p bigint) RETURNS varchar AS $body$
DECLARE


ds_retorno_w		varchar(20) := '';
dt_incio_w		timestamp;
dt_fim_w		timestamp;
i			bigint;
qt_reg_w		smallint;

c01 CURSOR(dt_inicio_p timestamp, dt_fim_p timestamp) FOR
	SELECT	dt_inicio_vigencia
	from	brasindice_preco
	where	coalesce(cd_estabelecimento, cd_estabelecimento_p) = cd_estabelecimento_p
	and	dt_inicio_vigencia between dt_inicio_p and dt_fim_p
	order by	dt_inicio_vigencia desc;



BEGIN

begin
select 	1
into STRICT	qt_reg_w
from 	brasindice_preco
where 	coalesce(cd_estabelecimento, cd_estabelecimento_p) = cd_estabelecimento_p  LIMIT 1;
exception
when others then
	qt_reg_w := 0;
end;

if (qt_reg_w > 0) then
	begin

	dt_incio_w := clock_timestamp() - interval '30 days';
	dt_fim_w   := clock_timestamp();
	i	   := 1;

	while coalesce(ds_retorno_w::text, '') = '' loop

	   i := i + 1;

	   open C01(dt_incio_w, dt_fim_w);
	   loop
	   fetch C01 into
		ds_retorno_w;
	   EXIT WHEN NOT FOUND; /* apply on C01 */
		begin
		ds_retorno_w 	:= ds_retorno_w;
		exit;
		end;
	   end loop;
	   close C01;

	   dt_incio_w := clock_timestamp() - (30 * i);

	end loop;

	end;
end if;

return 	ds_retorno_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_data_max_vig_brasindice (cd_estabelecimento_p bigint) FROM PUBLIC;

