-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_result_item_radio (nr_seq_item_p bigint) RETURNS varchar AS $body$
DECLARE


ds_retorno_seq_w	varchar(1000):= '';
ds_retorno_desc_w	varchar(1000):= '';
ds_retorno_w		varchar(2000):= '';
nr_sequencia_w		bigint;
ds_resultado_w		varchar(120);


c01 CURSOR FOR
	SELECT	nr_sequencia,
			ds_resultado
	from	srpa_item_result
	where	nr_seq_item = nr_seq_item_p
	order 	by	nr_sequencia;


BEGIN

open c01;
loop
fetch c01 into
	nr_sequencia_w,
	ds_resultado_w;
EXIT WHEN NOT FOUND; /* apply on c01 */
	begin
	if (coalesce(ds_retorno_seq_w::text, '') = '') then
		ds_retorno_seq_w := '(' || nr_sequencia_w;
	else
		ds_retorno_seq_w := ds_retorno_seq_w || ',' || nr_sequencia_w;
	end if;
	end;
end loop;
close c01;
ds_retorno_seq_w := ds_retorno_seq_w || ')';

open c01;
loop
fetch c01 into
	nr_sequencia_w,
	ds_resultado_w;
EXIT WHEN NOT FOUND; /* apply on c01 */
	begin
	if (coalesce(ds_retorno_desc_w::text, '') = '') then
		ds_retorno_desc_w := '(' || ds_resultado_w;
	else
		ds_retorno_desc_w := ds_retorno_desc_w || ',' || ds_resultado_w;
	end if;
	end;
end loop;
close c01;
ds_retorno_desc_w := ds_retorno_desc_w || ')';

ds_retorno_w := ds_retorno_seq_w || ds_retorno_desc_w;

return ds_retorno_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_result_item_radio (nr_seq_item_p bigint) FROM PUBLIC;
