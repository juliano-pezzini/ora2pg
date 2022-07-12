-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_nr_notas_emitidas ( dt_inicio_p timestamp, dt_final_p timestamp) RETURNS varchar AS $body$
DECLARE


ds_notas_w     		varchar(4000);
nr_nota_fiscal_w   		varchar(255);

C01 CURSOR FOR
	SELECT nr_nota_fiscal
	FROM nota_fiscal
	where dt_emissao between dt_inicio_p and dt_final_p;


BEGIN

ds_notas_w	:= '';

open c01;
loop
fetch c01 into
	nr_nota_fiscal_w;
EXIT WHEN NOT FOUND; /* apply on c01 */
	ds_notas_w := ds_notas_w || nr_nota_fiscal_w || ', ';
end loop;
close c01;


return	ds_notas_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_nr_notas_emitidas ( dt_inicio_p timestamp, dt_final_p timestamp) FROM PUBLIC;

