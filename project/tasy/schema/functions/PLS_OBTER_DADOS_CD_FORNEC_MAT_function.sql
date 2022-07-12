-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION pls_obter_dados_cd_fornec_mat ( cd_fornecedor_p text, ie_opcao_p text) RETURNS varchar AS $body$
DECLARE


ds_retorno_w		varchar(4000);

/*
ie_opcao_p
'S' -> Situação fornecedor
*/
BEGIN
if (cd_fornecedor_p IS NOT NULL AND cd_fornecedor_p::text <> '') and (ie_opcao_p IS NOT NULL AND ie_opcao_p::text <> '') then
	if (ie_opcao_p = 'S') then
		select	max(ie_situacao)
		into STRICT	ds_retorno_w
		from	pls_fornec_mat_fed_sc
		where	cd_fornecedor = cd_fornecedor_p;
	end if;
end if;

return	ds_retorno_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION pls_obter_dados_cd_fornec_mat ( cd_fornecedor_p text, ie_opcao_p text) FROM PUBLIC;
