-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION pls_obter_se_categoria_plano ( nr_seq_plano_p bigint, nr_seq_categoria_p bigint) RETURNS varchar AS $body$
DECLARE


ds_retorno_w			varchar(255);
nr_seq_tipo_acomod_benef_w	bigint;
nr_seq_categoria_w		bigint;
nr_seq_categoria_acomod_w	bigint;

C01 CURSOR FOR
	SELECT	nr_seq_tipo_acomodacao,
		nr_seq_categoria
	from 	pls_plano_acomodacao
	where	nr_seq_plano = nr_seq_plano_p;

C02 CURSOR FOR
	SELECT	nr_seq_categoria
	from	pls_regra_categoria
	where	nr_seq_tipo_acomodacao	= nr_seq_tipo_acomod_benef_w;


BEGIN

ds_retorno_w	:= 'N';

open C01;
loop
fetch C01 into
	nr_seq_tipo_acomod_benef_w,
	nr_seq_categoria_w;
EXIT WHEN NOT FOUND; /* apply on C01 */
	begin
	if (coalesce(nr_seq_tipo_acomod_benef_w,0) > 0) then
		open C02;
		loop
		fetch C02 into
			nr_seq_categoria_acomod_w;
		EXIT WHEN NOT FOUND; /* apply on C02 */
			begin
			if (nr_seq_categoria_acomod_w = nr_seq_categoria_p) then
				ds_retorno_w	:= 'S';
			end if;
			end;
		end loop;
		close C02;
	elsif (coalesce(nr_seq_categoria_w,0) > 0) and (nr_seq_categoria_w = nr_seq_categoria_p) then
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
-- REVOKE ALL ON FUNCTION pls_obter_se_categoria_plano ( nr_seq_plano_p bigint, nr_seq_categoria_p bigint) FROM PUBLIC;

