-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_amostras_frasco ( nr_seq_frasco_pato_loc_p bigint) RETURNS varchar AS $body$
DECLARE

ds_retorno_w		varchar(2000);
ds_amostra_w		varchar(100);

C01 CURSOR FOR
	SELECT   ds_amostra
	from     frasco_pato_loc_amost a,
		 tipo_amostra_patologia b
	where    a.nr_seq_tipo_amostra_pato = b.nr_sequencia
	and	 a.nr_seq_frasco_pato_loc = nr_seq_frasco_pato_loc_p
	order 	 by 1;

BEGIN
ds_retorno_w := '';
open C01;
loop
fetch C01 into
	ds_amostra_w;
EXIT WHEN NOT FOUND; /* apply on C01 */
	begin
	ds_retorno_w := substr(ds_retorno_w || ds_amostra_w,1,1998) || ', ';
	end;
end loop;
close C01;

ds_retorno_w := substr(ds_retorno_w,1,length(ds_retorno_w)-2);

return	ds_retorno_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_amostras_frasco ( nr_seq_frasco_pato_loc_p bigint) FROM PUBLIC;
