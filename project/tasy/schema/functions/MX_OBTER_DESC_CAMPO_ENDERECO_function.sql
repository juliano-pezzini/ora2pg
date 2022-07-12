-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION mx_obter_desc_campo_endereco (nome_campo_p text) RETURNS varchar AS $body$
DECLARE

 retorno_w 	varchar(255);
 cd_expressao_w	valor_dominio_v.cd_exp_valor_dominio%type;

BEGIN
	retorno_w := '';

	Select cd_exp_valor_dominio
	into STRICT cd_expressao_w
	from valor_dominio_v
	where cd_dominio = 8959
	and vl_dominio = nome_campo_p;

	if (coalesce(cd_expressao_w, 0) > 0) then
		Select get_expression(cd_expressao_w, replace(pkg_i18n.get_estab_locale,'_','-'))
		into STRICT retorno_w
		;
	end if;

	return retorno_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION mx_obter_desc_campo_endereco (nome_campo_p text) FROM PUBLIC;
