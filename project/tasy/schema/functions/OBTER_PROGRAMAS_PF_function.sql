-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_programas_pf ( cd_pessoa_fisica_p text) RETURNS varchar AS $body$
DECLARE


ds_retorno_w	varchar(4000);


BEGIN

if (cd_pessoa_fisica_p IS NOT NULL AND cd_pessoa_fisica_p::text <> '') then
	begin
	select	obter_select_concatenado_bv(
		'select	distinct ' ||
		'	a.nm_programa ' ||
		'from	mprev_programa a, ' ||
		'	mprev_programa_partic b, ' ||
		'	mprev_participante c ' ||
		'where	a.nr_sequencia = b.nr_seq_programa ' ||
		'and	c.nr_sequencia = b.nr_seq_participante ' ||
		'and	c.cd_pessoa_fisica = :cd_pessoa_fisica ' ||
		'order by	1 ',
		'cd_pessoa_fisica=' || cd_pessoa_fisica_p,
		', ')
	into STRICT	ds_retorno_w
	;
	end;
end if;

return	ds_retorno_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_programas_pf ( cd_pessoa_fisica_p text) FROM PUBLIC;
