-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION cih_obter_dados_contato (nr_ficha_ocorrencia_p bigint, ie_opcao_p bigint) RETURNS varchar AS $body$
DECLARE


/*
1 - data de contato
2 - check houve contato
3 - data de contato com máscara
*/
ds_retorno_w		varchar(255);
dt_contato_w		timestamp;
ie_houve_contato_w	varchar(1);

C01 CURSOR FOR
	SELECT	dt_contato,
		ie_houve_contato
	from	cih_contato
	where	nr_ficha_ocorrencia	= nr_ficha_ocorrencia_p
	order by 1;


BEGIN
open C01;
loop
fetch C01 into
	dt_contato_w,
	ie_houve_contato_w;
EXIT WHEN NOT FOUND; /* apply on C01 */
	begin
	ds_Retorno_w	:= '';
	end;
end loop;
close C01;

if (ie_opcao_p	= 1) then
	ds_retorno_w	:= dt_contato_w;
elsif (ie_opcao_p	= 2) then
	ds_retorno_w	:= ie_houve_contato_w;
elsif (ie_opcao_p	= 3) then
	ds_retorno_w	:= to_char(dt_contato_w, 'dd/mm/yyyy');

end if;

return	ds_Retorno_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION cih_obter_dados_contato (nr_ficha_ocorrencia_p bigint, ie_opcao_p bigint) FROM PUBLIC;

