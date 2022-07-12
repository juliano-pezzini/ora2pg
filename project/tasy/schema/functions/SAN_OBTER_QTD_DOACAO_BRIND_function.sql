-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION san_obter_qtd_doacao_brind ( cd_pessoa_fisica_p text, nr_seq_tipo_p bigint) RETURNS bigint AS $body$
DECLARE


qt_retorno_w	bigint;


BEGIN

if (cd_pessoa_fisica_p IS NOT NULL AND cd_pessoa_fisica_p::text <> '') then

	select	count(*)
	into STRICT	qt_retorno_w
	from	san_doacao
	where	cd_pessoa_fisica = cd_pessoa_fisica_p
	and	nr_seq_tipo	= coalesce(nr_seq_tipo_p,nr_seq_tipo)
	and	ie_avaliacao_final = 'A';

end if;

return	qt_retorno_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION san_obter_qtd_doacao_brind ( cd_pessoa_fisica_p text, nr_seq_tipo_p bigint) FROM PUBLIC;
