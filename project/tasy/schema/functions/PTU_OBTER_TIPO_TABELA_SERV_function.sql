-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION ptu_obter_tipo_tabela_serv ( cd_servico_p text, ie_tipo_servico_p text) RETURNS varchar AS $body$
DECLARE


ds_retorno_w		varchar(2);
ie_classificacao_w	smallint;
ie_tipo_despesa_w	smallint;


BEGIN

if (ie_tipo_servico_p	= 'P') then
	select	max(ie_classificacao)
	into STRICT	ie_classificacao_w
	from	procedimento
	where	cd_procedimento	= cd_servico_p;

	if (ie_classificacao_w	= 1) then
		ds_retorno_w	:= '0';
	elsif (ie_classificacao_w	= 2) then
		ds_retorno_w	:= '1';
	elsif (ie_classificacao_w	= 3) then
		ds_retorno_w	:= '1';
	else
		ds_retorno_w	:= '0';
	end if;
elsif (ie_tipo_servico_p	= 'M') then
	select	coalesce(ie_tipo_despesa,0)
	into STRICT	ie_tipo_despesa_w
	from	pls_material
	where	cd_material_ops	= cd_servico_p;

	if (ie_tipo_despesa_w	= 2) then
		ds_retorno_w	:= '3';
	elsif (ie_tipo_despesa_w	= 3) then
		ds_retorno_w	:= '2';
	elsif (ie_tipo_despesa_w	= 7) then
		ds_retorno_w	:= '3';
	end if;
end if;

return	ds_retorno_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION ptu_obter_tipo_tabela_serv ( cd_servico_p text, ie_tipo_servico_p text) FROM PUBLIC;
