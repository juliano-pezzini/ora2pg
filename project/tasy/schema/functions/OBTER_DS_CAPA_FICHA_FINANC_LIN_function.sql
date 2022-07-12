-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_ds_capa_ficha_financ_lin ( nr_seq_linha_p bigint) RETURNS varchar AS $body$
DECLARE



ds_linha_w	varchar(255);
nr_seq_superior_w	bigint;
qt_nivel_w	bigint	:= 0;
i		bigint;

ds_retorno_w	varchar(255);


BEGIN
begin
select	ds_linha,
	nr_seq_superior
into STRICT	ds_linha_w,
	nr_seq_superior_w
from	capa_ficha_financ_lin
where	nr_sequencia = nr_seq_linha_p;
exception
when others then
	ds_linha_w	:= null;
end;

if (ds_linha_w IS NOT NULL AND ds_linha_w::text <> '') then
	begin
	select	count(*)
	into STRICT	qt_nivel_w
	from	capa_ficha_financ_lin
	where	nr_seq_superior = nr_seq_linha_p;

	if (qt_nivel_w > 0) then
		ds_linha_w := substr('+ '||ds_linha_w,1,255);
	else
		ds_linha_w := substr('    '||ds_linha_w,1,255);
	end if;

	qt_nivel_w	:= 0;

	while(nr_seq_superior_w IS NOT NULL AND nr_seq_superior_w::text <> '') loop
		begin
		select	nr_seq_superior
		into STRICT	nr_seq_superior_w
		from	capa_ficha_financ_lin
		where	nr_sequencia = nr_seq_superior_w;

		qt_nivel_w := qt_nivel_w + 1;
		end;
	end loop;

	for i in 1..qt_nivel_w loop
		begin
		ds_linha_w := substr('    ' || ds_linha_w,1,255);
		end;
	end loop;
	end;
end if;

ds_retorno_w := ds_linha_w;

return	ds_retorno_w;
end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_ds_capa_ficha_financ_lin ( nr_seq_linha_p bigint) FROM PUBLIC;
