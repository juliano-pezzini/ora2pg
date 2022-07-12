-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION paf_obter_dados_pj ( cd_cgc_p text, ie_opcao_p text) RETURNS varchar AS $body$
DECLARE


/* utilizar sql's distintos para reduzir consumo de memoria

ie_opcao_p
E - endereco
EN - enderero + numero

*/
ds_retorno_w	varchar(255);


BEGIN

begin

	if (ie_opcao_p = 'E') then
		begin
		select	substr(ds_endereco, 1, 255)
		into STRICT	ds_retorno_w
		from	pessoa_juridica
		where	cd_cgc = cd_cgc_p;
		end;
	elsif (ie_opcao_p = 'EN') then
		begin
		select	substr(ds_endereco || CASE WHEN coalesce(nr_endereco::text, '') = '' THEN  ''  ELSE ', ' || to_char(nr_endereco) END , 1, 255)
		into STRICT	ds_retorno_w
		from	pessoa_juridica
		where	cd_cgc = cd_cgc_p;
		end;
	end if;

exception
when others then
	ds_retorno_w := '';
end;

return	ds_retorno_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION paf_obter_dados_pj ( cd_cgc_p text, ie_opcao_p text) FROM PUBLIC;

