-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_se_adm_funcao (cd_pessoa_fisica_p text) RETURNS varchar AS $body$
DECLARE


ds_retorno_w			varchar(2);
qt_regra_w				bigint;


BEGIN
ds_retorno_w	:=	'N';

select  count(*)
into STRICT	qt_regra_w
from	aplicacao_soft_mod_resp a,
		func_mod_software b,
		aplicacao_soft_mod_resp c
where	c.cd_pessoa_fisica 	= cd_pessoa_fisica_p
and		b.nr_seq_modulo  	= a.nr_seq_modulo
and		c.nr_seq_modulo  	= a.nr_seq_modulo
and		cd_funcao 	 		= 7027;

if (qt_regra_w > 0) then
	ds_retorno_w	:=	'S';
end if;

return	ds_retorno_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_se_adm_funcao (cd_pessoa_fisica_p text) FROM PUBLIC;
