-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_divergencia_cor_temp ( nr_sequencia_p bigint, qt_temp_min_p bigint, qt_temp_max_p bigint, qt_temp_ini_p bigint) RETURNS varchar AS $body$
DECLARE


ds_retorno_w	varchar(1) := 'N';
qt_temp_min_w	item_temp_regra.qt_temp_min%type;
qt_temp_max_w	item_temp_regra.qt_temp_max%type;


BEGIN
if (qt_temp_min_p IS NOT NULL AND qt_temp_min_p::text <> '') and (qt_temp_max_p IS NOT NULL AND qt_temp_max_p::text <> '') and (qt_temp_ini_p IS NOT NULL AND qt_temp_ini_p::text <> '') then
	begin
	if (coalesce(nr_sequencia_p,0) <> 0) then
		begin
		select	coalesce(b.qt_temp_min,0),
			coalesce(b.qt_temp_max,0)
		into STRICT	qt_temp_min_w,
			qt_temp_max_w
		from	item_temperatura a,
			item_temp_regra b
		where	a.nr_sequencia = b.nr_seq_item
		and		a.nr_sequencia = nr_sequencia_p
		and		b.nr_sequencia = (	SELECT	max(x.nr_sequencia)
						from	item_temp_regra x
						where	x.nr_seq_item = nr_sequencia_p);

		if (qt_temp_ini_p     > qt_temp_max_p) or (qt_temp_ini_p     < qt_temp_min_p) or (qt_temp_max_p  > qt_temp_max_w) or (qt_temp_max_p  < qt_temp_min_w) or (qt_temp_min_p   < qt_temp_min_w) or (qt_temp_min_p   > qt_temp_max_w) then
			ds_retorno_w := 'S';
		end if;
		end;
	elsif (coalesce(nr_sequencia_p,0) = 0) then
		begin
		select	coalesce(a.qt_temp_min,0),
			coalesce(a.qt_temp_max,0)
		into STRICT	qt_temp_min_w,
			qt_temp_max_w
		from	item_temperatura a
		where	a.nr_sequencia = nr_sequencia_p;

		if (qt_temp_ini_p     > qt_temp_max_p) or (qt_temp_ini_p     < qt_temp_min_p) or (qt_temp_max_p  > qt_temp_max_w) or (qt_temp_max_p  < qt_temp_min_w) or (qt_temp_min_p   < qt_temp_min_w) or (qt_temp_min_p   > qt_temp_max_w) then
			ds_retorno_w := 'S';
		end if;
		end;
	end if;
	end;
end if;
return	ds_retorno_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_divergencia_cor_temp ( nr_sequencia_p bigint, qt_temp_min_p bigint, qt_temp_max_p bigint, qt_temp_ini_p bigint) FROM PUBLIC;
