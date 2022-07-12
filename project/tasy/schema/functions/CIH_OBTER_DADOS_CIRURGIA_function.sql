-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION cih_obter_dados_cirurgia (nr_ficha_ocorrencia_p bigint, ie_opcao_p bigint) RETURNS varchar AS $body$
DECLARE


ds_retorno_w		varchar(255);
cd_procedimento_w	bigint;
ie_origem_proced_w	bigint;

C01 CURSOR FOR
	SELECT	cd_procedimento,
		ie_origem_proced
	from	cih_cirurgia
	where	nr_ficha_ocorrencia	= nr_ficha_ocorrencia_p
	order by 1;


BEGIN
open C01;
loop
fetch C01 into
	cd_procedimento_w,
	ie_origem_proced_w;
EXIT WHEN NOT FOUND; /* apply on C01 */
	begin
	ds_Retorno_w	:= '';
	end;
end loop;
close C01;

if (ie_opcao_p	= 1) then
	ds_retorno_w	:= cd_procedimento_w;
elsif (ie_opcao_p	= 2) then
	ds_retorno_w	:= ie_origem_proced_w;
elsif (ie_opcao_p	= 3) then
	ds_retorno_w	:= substr(OBTER_DESCRICAO_PROCEDIMENTO(cd_procedimento_w,ie_origem_proced_w),1,255);

end if;


return	ds_Retorno_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION cih_obter_dados_cirurgia (nr_ficha_ocorrencia_p bigint, ie_opcao_p bigint) FROM PUBLIC;
