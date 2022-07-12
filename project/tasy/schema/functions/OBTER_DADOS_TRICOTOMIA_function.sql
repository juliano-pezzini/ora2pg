-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_dados_tricotomia ( nr_sequencia_p bigint, ie_equip_mat_p text, ie_opcao_p text ) RETURNS varchar AS $body$
DECLARE


ds_retorno_w	varchar(255);


BEGIN

if (ie_equip_mat_p = 'E') and (ie_opcao_p = 'D') then
	select	substr(obter_desc_equipamento(cd_equipamento),1,100)
	into STRICT	ds_retorno_w
	from 	equipamento_tricotomia
	where	nr_sequencia	=	nr_sequencia_p;

elsif (ie_equip_mat_p = 'M') and (ie_opcao_p = 'D') then
	select	substr(obter_desc_material(cd_material),1,100)
	into STRICT	ds_retorno_w
	from	material_tricotomia
	where	nr_sequencia	=	nr_sequencia_p;
end if;

return	ds_retorno_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_dados_tricotomia ( nr_sequencia_p bigint, ie_equip_mat_p text, ie_opcao_p text ) FROM PUBLIC;

