-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_result_diag_concat (nr_sequencia_p bigint) RETURNS varchar AS $body$
DECLARE


ds_retorno_w	varchar(255) := '';			
nr_seq_diag_w	bigint;
ds_resul_esp_w	varchar(255);

C01 CURSOR FOR
	SELECT c.ds_result_esperado
	from   pe_prescr_diag_res_esp a,
	       pe_resultado_esperado c
	where  a.nr_seq_diag_result = c.nr_sequencia
	and    a.nr_seq_diag = nr_sequencia_p;
			

BEGIN


open C01;
loop
fetch C01 into	
	ds_resul_esp_w;
EXIT WHEN NOT FOUND; /* apply on C01 */
begin
	ds_retorno_w := substr(ds_retorno_w||ds_resul_esp_w||' / ',1,255);
end;
end loop;
close C01;

ds_retorno_w	:= substr(ds_retorno_w,1,length(ds_retorno_w)-2);


return	ds_retorno_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_result_diag_concat (nr_sequencia_p bigint) FROM PUBLIC;
