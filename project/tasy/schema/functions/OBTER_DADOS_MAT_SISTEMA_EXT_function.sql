-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_dados_mat_sistema_ext ( cd_material_p bigint, ie_sistema_p text, ie_retorno_p text) RETURNS varchar AS $body$
DECLARE


/*'
ie_retorno_p
COD > Código externo (CD_CODIGO)
REF > Referência (CD_REFERENCIA)
'*/
material_sistema_externo_w		material_sistema_externo%rowtype;
ds_retorno_w			varchar(255);


BEGIN
begin
select	*
into STRICT	material_sistema_externo_w
from	material_sistema_externo
where	cd_material = cd_material_p
and	ie_sistema = ie_sistema_p  LIMIT 1;
exception
when others then
	material_sistema_externo_w	:=	null;
end;

if (ie_retorno_p = 'COD') then
	ds_retorno_w	:=	material_sistema_externo_w.cd_codigo;
elsif (ie_retorno_p = 'REF')	then
	ds_retorno_w	:=	material_sistema_externo_w.cd_referencia;
else
	ds_retorno_w	:=	null;
end if;

return ds_retorno_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_dados_mat_sistema_ext ( cd_material_p bigint, ie_sistema_p text, ie_retorno_p text) FROM PUBLIC;
