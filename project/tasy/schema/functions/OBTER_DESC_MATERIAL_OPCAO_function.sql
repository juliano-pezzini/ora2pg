-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_desc_material_opcao ( cd_material_p bigint, ie_opcao_p text) RETURNS varchar AS $body$
DECLARE


ds_retorno_w		varchar(255);
ds_material_w		varchar(255);
ds_reduzida_w		varchar(255);
ds_material_sem_acento_w	varchar(255);
ds_mat_codigo_w			varchar(255);

/*	D	- Descrição do material
	DSA	- Descrição do material sem acento
	DSR	- Descrição reduzida
	DMC	- Descrição do material + Código material
*/
BEGIN

select	substr(max(ds_material),1,100),
	substr(max(ds_material_sem_acento),1,100),
	substr(max(ds_reduzida),1,100),
	substr(max(ds_material || ' (' || cd_material || ')'),1,255)
into STRICT	ds_material_w,
	ds_material_sem_acento_w,
	ds_reduzida_w,
	ds_mat_codigo_w
from	material
where	cd_material = cd_material_p;

if (ie_opcao_p = 'DSA') then
	ds_retorno_w	:= ds_material_sem_acento_w;
elsif (ie_opcao_p = 'DSR') then
	ds_retorno_w	:= ds_reduzida_w;
elsif (ie_opcao_p = 'DMC') then
	ds_retorno_w	:= ds_mat_codigo_w;
elsif (ie_opcao_p = 'D') then
	ds_retorno_w	:= ds_material_w;
end if;

RETURN ds_retorno_w;
END;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_desc_material_opcao ( cd_material_p bigint, ie_opcao_p text) FROM PUBLIC;
