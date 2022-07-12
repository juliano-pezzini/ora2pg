-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_uf_nascimento ( cd_pessoa_fisica_p text) RETURNS varchar AS $body$
DECLARE


nr_cep_w		varchar(15);
ds_uf_w			valor_dominio.vl_dominio%type;


BEGIN
select	max(nr_cep_cidade_nasc)
into STRICT	nr_cep_w
from	pessoa_fisica
where	cd_pessoa_fisica	= coalesce(cd_pessoa_fisica_p,'0');

if (nr_cep_w IS NOT NULL AND nr_cep_w::text <> '') then
	select	max(ds_uf)
	into STRICT	ds_uf_w
	from	Cep_Localidade_v
	where	cd_cep	= nr_cep_w;
else
	ds_uf_w	:= '';
End if;

return ds_uf_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_uf_nascimento ( cd_pessoa_fisica_p text) FROM PUBLIC;

