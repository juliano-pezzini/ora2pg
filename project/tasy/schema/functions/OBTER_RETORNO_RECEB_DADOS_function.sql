-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_retorno_receb_dados ( nr_seq_retorno_p bigint, ie_opcao_p bigint) RETURNS varchar AS $body$
DECLARE


nr_Seq_receb_w			bigint;
dt_recebimento_w			timestamp;
ds_data_receb_w			varchar(2000) := '';
ds_retorno_w			varchar(2000);

c01 CURSOR FOR
	SELECT 	nr_Seq_receb,
		dt_recebimento
	from	cONVENIO_RET_RECEB a,
		convenio_receb b
	where	a.nr_Seq_receb = b.nr_sequencia
	and 	nr_seq_retorno = nr_Seq_retorno_p;


BEGIN

open c01;
loop
fetch c01 into
	nr_seq_receb_w,
	dt_recebimento_w;
EXIT WHEN NOT FOUND; /* apply on c01 */
	begin

	if	((coalesce(ds_data_receb_w,'X') = 'X') or (length(ds_data_receb_w) < 1970)) then
		if (ie_opcao_p = 0) then
			ds_data_receb_w	:= substr(ds_data_receb_w || to_char(dt_recebimento_w,'dd/mm/yyyy') || ',',1,2000);
		elsif (ie_opcao_p = 1) then
			ds_data_receb_w	:= substr(ds_data_receb_w || nr_seq_receb_w || ',',1,2000);
		end if;
	end if;

	end;
end loop;
close c01;

ds_retorno_w	:= substr(ds_data_receb_w,1,length(ds_data_receb_w)-1);

return ds_retorno_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_retorno_receb_dados ( nr_seq_retorno_p bigint, ie_opcao_p bigint) FROM PUBLIC;

