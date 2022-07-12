-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION reg_obter_desc_externo (nm_tabela_p text, cd_externo_p text) RETURNS varchar AS $body$
DECLARE

ds_retorno_w	varchar(255);

BEGIN
if	(nm_tabela_p IS NOT NULL AND nm_tabela_p::text <> '' AND cd_externo_p IS NOT NULL AND cd_externo_p::text <> '') then

	if (nm_tabela_p = 'MOTIVO_ALTA') then

		select	substr(obter_valor_dominio(7228, cd_externo_p),1,255)
		into STRICT	ds_retorno_w
		;

	elsif (nm_tabela_p = 'MOTIVO_TRANSFERENCIA') then

		select	substr(obter_valor_dominio(7231, cd_externo_p),1,255)
		into STRICT	ds_retorno_w
		;

	elsif (nm_tabela_p = 'CLASSIF_UNIDADE_ATEND') then

		select	substr(obter_valor_dominio(7229, cd_externo_p),1,255)
		into STRICT	ds_retorno_w
		;

	elsif (nm_tabela_p = 'ESPECIALIDADE_LEITO') then

		select	substr(obter_valor_dominio(7232, cd_externo_p),1,255)
		into STRICT	ds_retorno_w
		;

	end if;

end if;
return	ds_retorno_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION reg_obter_desc_externo (nm_tabela_p text, cd_externo_p text) FROM PUBLIC;
