-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION cus_rel_obter_valor_mes ( nr_mes_p bigint, qt_mes_p bigint, nr_sequencia_p bigint) RETURNS bigint AS $body$
DECLARE


vl_mes01_w	double precision := 0;
vl_mes02_w	double precision := 0;
vl_mes03_w	double precision := 0;
vl_mes04_w	double precision := 0;
vl_mes05_w	double precision := 0;
vl_mes06_w	double precision := 0;
vl_mes07_w	double precision := 0;
vl_mes08_w	double precision := 0;
vl_mes09_w	double precision := 0;
vl_mes10_w	double precision := 0;
vl_mes11_w	double precision := 0;
vl_mes12_w	double precision := 0;

nr_retorno_w	double precision := 0;


BEGIN
select	vl_mes01,
	vl_mes02,
	vl_mes03,
	vl_mes04,
	vl_mes05,
	vl_mes06,
	vl_mes07,
	vl_mes08,
	vl_mes09,
	vl_mes10,
	vl_mes11,
	vl_mes12
into STRICT	vl_mes01_w,
	vl_mes02_w,
	vl_mes03_w,
	vl_mes04_w,
	vl_mes05_w,
	vl_mes06_w,
	vl_mes07_w,
	vl_mes08_w,
	vl_mes09_w,
	vl_mes10_w,
	vl_mes11_w,
	vl_mes12_w
from	w_result_centro_controle
where	nr_sequencia = nr_sequencia_p;

if (qt_mes_p = 1) then
	begin
	nr_retorno_w := vl_mes01_w;
	end;
elsif (qt_mes_p = 2) then
	begin
	if (nr_mes_p = 1) then
		nr_retorno_w := vl_mes02_w;
	elsif (nr_mes_p = 2) then
		nr_retorno_w := vl_mes01_w;
	end if;
	end;
elsif (qt_mes_p = 3) then
	begin
	if (nr_mes_p = 1) then
		nr_retorno_w := vl_mes03_w;
	elsif (nr_mes_p = 2) then
		nr_retorno_w := vl_mes02_w;
	elsif (nr_mes_p = 3) then
		nr_retorno_w := vl_mes01_w;
	end if;
	end;
elsif (qt_mes_p = 4) then
	begin
	if (nr_mes_p = 1) then
		nr_retorno_w := vl_mes04_w;
	elsif (nr_mes_p = 2) then
		nr_retorno_w := vl_mes03_w;
	elsif (nr_mes_p = 3) then
		nr_retorno_w := vl_mes02_w;
	elsif (nr_mes_p = 4) then
		nr_retorno_w := vl_mes01_w;
	end if;
	end;
elsif (qt_mes_p = 5) then
	begin
	if (nr_mes_p = 1) then
		nr_retorno_w := vl_mes05_w;
	elsif (nr_mes_p = 2) then
		nr_retorno_w := vl_mes04_w;
	elsif (nr_mes_p = 3) then
		nr_retorno_w := vl_mes03_w;
	elsif (nr_mes_p = 4) then
		nr_retorno_w := vl_mes02_w;
	elsif (nr_mes_p = 5) then
		nr_retorno_w := vl_mes01_w;
	end if;
	end;
elsif (qt_mes_p = 6) then
	begin
	if (nr_mes_p = 1) then
		nr_retorno_w := vl_mes06_w;
	elsif (nr_mes_p = 2) then
		nr_retorno_w := vl_mes05_w;
	elsif (nr_mes_p = 3) then
		nr_retorno_w := vl_mes04_w;
	elsif (nr_mes_p = 4) then
		nr_retorno_w := vl_mes03_w;
	elsif (nr_mes_p = 5) then
		nr_retorno_w := vl_mes02_w;
	elsif (nr_mes_p = 6) then
		nr_retorno_w := vl_mes01_w;
	end if;
	end;
elsif (qt_mes_p = 7) then
	begin
	if (nr_mes_p = 1) then
		nr_retorno_w := vl_mes07_w;
	elsif (nr_mes_p = 2) then
		nr_retorno_w := vl_mes06_w;
	elsif (nr_mes_p = 3) then
		nr_retorno_w := vl_mes05_w;
	elsif (nr_mes_p = 4) then
		nr_retorno_w := vl_mes04_w;
	elsif (nr_mes_p = 5) then
		nr_retorno_w := vl_mes03_w;
	elsif (nr_mes_p = 6) then
		nr_retorno_w := vl_mes02_w;
	elsif (nr_mes_p = 7) then
		nr_retorno_w := vl_mes01_w;
	end if;
	end;
elsif (qt_mes_p = 8) then
	begin
	if (nr_mes_p = 1) then
		nr_retorno_w := vl_mes08_w;
	elsif (nr_mes_p = 2) then
		nr_retorno_w := vl_mes07_w;
	elsif (nr_mes_p = 3) then
		nr_retorno_w := vl_mes06_w;
	elsif (nr_mes_p = 4) then
		nr_retorno_w := vl_mes05_w;
	elsif (nr_mes_p = 5) then
		nr_retorno_w := vl_mes04_w;
	elsif (nr_mes_p = 6) then
		nr_retorno_w := vl_mes03_w;
	elsif (nr_mes_p = 7) then
		nr_retorno_w := vl_mes02_w;
	elsif (nr_mes_p = 8) then
		nr_retorno_w := vl_mes01_w;
	end if;
	end;
elsif (qt_mes_p = 9) then
	begin
	if (nr_mes_p = 1) then
		nr_retorno_w := vl_mes09_w;
	elsif (nr_mes_p = 2) then
		nr_retorno_w := vl_mes08_w;
	elsif (nr_mes_p = 3) then
		nr_retorno_w := vl_mes07_w;
	elsif (nr_mes_p = 4) then
		nr_retorno_w := vl_mes06_w;
	elsif (nr_mes_p = 5) then
		nr_retorno_w := vl_mes05_w;
	elsif (nr_mes_p = 6) then
		nr_retorno_w := vl_mes04_w;
	elsif (nr_mes_p = 7) then
		nr_retorno_w := vl_mes03_w;
	elsif (nr_mes_p = 8) then
		nr_retorno_w := vl_mes02_w;
	elsif (nr_mes_p = 9) then
		nr_retorno_w := vl_mes01_w;
	end if;
	end;
elsif (qt_mes_p = 10) then
	begin
	if (nr_mes_p = 1) then
		nr_retorno_w := vl_mes10_w;
	elsif (nr_mes_p = 2) then
		nr_retorno_w := vl_mes09_w;
	elsif (nr_mes_p = 3) then
		nr_retorno_w := vl_mes08_w;
	elsif (nr_mes_p = 4) then
		nr_retorno_w := vl_mes07_w;
	elsif (nr_mes_p = 5) then
		nr_retorno_w := vl_mes06_w;
	elsif (nr_mes_p = 6) then
		nr_retorno_w := vl_mes05_w;
	elsif (nr_mes_p = 7) then
		nr_retorno_w := vl_mes04_w;
	elsif (nr_mes_p = 8) then
		nr_retorno_w := vl_mes03_w;
	elsif (nr_mes_p = 9) then
		nr_retorno_w := vl_mes02_w;
	elsif (nr_mes_p = 10) then
		nr_retorno_w := vl_mes01_w;
	end if;
	end;
elsif (qt_mes_p = 11) then
	begin
	if (nr_mes_p = 1) then
		nr_retorno_w := vl_mes11_w;
	elsif (nr_mes_p = 2) then
		nr_retorno_w := vl_mes10_w;
	elsif (nr_mes_p = 3) then
		nr_retorno_w := vl_mes09_w;
	elsif (nr_mes_p = 4) then
		nr_retorno_w := vl_mes08_w;
	elsif (nr_mes_p = 5) then
		nr_retorno_w := vl_mes07_w;
	elsif (nr_mes_p = 6) then
		nr_retorno_w := vl_mes06_w;
	elsif (nr_mes_p = 7) then
		nr_retorno_w := vl_mes05_w;
	elsif (nr_mes_p = 8) then
		nr_retorno_w := vl_mes04_w;
	elsif (nr_mes_p = 9) then
		nr_retorno_w := vl_mes03_w;
	elsif (nr_mes_p = 10) then
		nr_retorno_w := vl_mes02_w;
	elsif (nr_mes_p = 11) then
		nr_retorno_w := vl_mes01_w;
	end if;
	end;
elsif (qt_mes_p = 12) then
	begin
	if (nr_mes_p = 1) then
		nr_retorno_w := vl_mes12_w;
	elsif (nr_mes_p = 2) then
		nr_retorno_w := vl_mes11_w;
	elsif (nr_mes_p = 3) then
		nr_retorno_w := vl_mes10_w;
	elsif (nr_mes_p = 4) then
		nr_retorno_w := vl_mes09_w;
	elsif (nr_mes_p = 5) then
		nr_retorno_w := vl_mes08_w;
	elsif (nr_mes_p = 6) then
		nr_retorno_w := vl_mes07_w;
	elsif (nr_mes_p = 7) then
		nr_retorno_w := vl_mes06_w;
	elsif (nr_mes_p = 8) then
		nr_retorno_w := vl_mes05_w;
	elsif (nr_mes_p = 9) then
		nr_retorno_w := vl_mes04_w;
	elsif (nr_mes_p = 10) then
		nr_retorno_w := vl_mes03_w;
	elsif (nr_mes_p = 11) then
		nr_retorno_w := vl_mes02_w;
	elsif (nr_mes_p = 12) then
		nr_retorno_w := vl_mes01_w;
	end if;
	end;
end if;

return	nr_retorno_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION cus_rel_obter_valor_mes ( nr_mes_p bigint, qt_mes_p bigint, nr_sequencia_p bigint) FROM PUBLIC;
