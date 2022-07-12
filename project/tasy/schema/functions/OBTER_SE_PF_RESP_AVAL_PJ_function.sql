-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_se_pf_resp_aval_pj (cd_cnpj_p text, cd_pessoa_fisica_p text) RETURNS varchar AS $body$
DECLARE


ds_retorno_w			varchar(1) := 'S';
cd_cargo_w			pessoa_fisica.cd_cargo%type;
ie_avaliacao_fornecedor_w	pessoa_jur_resp.ie_avaliacao_fornecedor%type;

c01 CURSOR FOR
SELECT	a.ie_avaliacao_fornecedor
from	pessoa_jur_resp a
where	a.cd_cgc	= cd_cnpj_p
and	coalesce(a.cd_cargo,coalesce(cd_cargo_w,0)) = coalesce(cd_cargo_w,0)
and	coalesce(a.cd_pessoa_fisica,cd_pessoa_fisica_p)	= cd_pessoa_fisica_p
order by coalesce(a.cd_pessoa_fisica,'0'),
	coalesce(a.cd_cargo,0);


BEGIN

select	max(a.cd_cargo)
into STRICT	cd_cargo_w
from	pessoa_fisica a
where	a.cd_pessoa_fisica	= cd_pessoa_fisica_p;

open C01;
loop
fetch C01 into
	ie_avaliacao_fornecedor_w;
EXIT WHEN NOT FOUND; /* apply on C01 */
	begin
	ds_retorno_w	:= ie_avaliacao_fornecedor_w;
	end;
end loop;
close C01;

return	ds_retorno_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_se_pf_resp_aval_pj (cd_cnpj_p text, cd_pessoa_fisica_p text) FROM PUBLIC;
