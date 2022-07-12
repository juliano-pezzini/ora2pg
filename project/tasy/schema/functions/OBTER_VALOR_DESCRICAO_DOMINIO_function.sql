-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_valor_descricao_dominio ( cd_dominio_p bigint, ds_dominio_p text) RETURNS bigint AS $body$
DECLARE

vl_dominio_w		bigint := null;


BEGIN

if (cd_dominio_p IS NOT NULL AND cd_dominio_p::text <> '') and (ds_dominio_p IS NOT NULL AND ds_dominio_p::text <> '') then
	begin

	select		vl_dominio
	into STRICT		vl_dominio_w
	from 		valor_dominio
	where 		cd_dominio		= cd_dominio_p
	and		ds_valor_dominio	= ds_dominio_p;

	exception
		when others then
			vl_dominio_w	:= null;
	end;
end	if;
return	vl_dominio_w;

end	;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_valor_descricao_dominio ( cd_dominio_p bigint, ds_dominio_p text) FROM PUBLIC;

