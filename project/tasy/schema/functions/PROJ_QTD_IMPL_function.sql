-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION proj_qtd_impl ( cd_pessoa_fisica_p text) RETURNS bigint AS $body$
DECLARE


qt_retorno_w		bigint;


BEGIN
select	count(distinct s.nr_seq_proj)
into STRICT	qt_retorno_w
from	proj_equipe s,
	proj_equipe_papel t
where	s.nr_sequencia		= t.nr_seq_equipe
and	t.cd_pessoa_fisica	= cd_pessoa_fisica_p
and	coalesce(t.ie_situacao,'A')	= 'A';

return	qt_retorno_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION proj_qtd_impl ( cd_pessoa_fisica_p text) FROM PUBLIC;
