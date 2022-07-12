-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION pls_obter_seq_prestador_pf ( cd_pessoa_fisica_p text, cd_estabelecimento_p bigint, nr_seq_prestador_atual_p pls_conta.nr_seq_prestador_exec%type default null) RETURNS bigint AS $body$
DECLARE


nr_retorno_w	bigint;
qt_reg_w	integer;


BEGIN

select	count(1)
into STRICT	qt_reg_w
from	pls_prestador
where	cd_pessoa_fisica 	= cd_pessoa_fisica_p
and	cd_estabelecimento 	= cd_estabelecimento_p
and	ie_situacao 		= 'A'
and	nr_sequencia		= nr_seq_prestador_atual_p;

if (qt_reg_w	> 0) then
	nr_retorno_w	:= nr_seq_prestador_atual_p;
else
	select	max(nr_sequencia)
	into STRICT	nr_retorno_w
	from	pls_prestador
	where	cd_pessoa_fisica = cd_pessoa_fisica_p
	and	cd_estabelecimento = cd_estabelecimento_p
	and	ie_situacao = 'A';
end if;

return	nr_retorno_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION pls_obter_seq_prestador_pf ( cd_pessoa_fisica_p text, cd_estabelecimento_p bigint, nr_seq_prestador_atual_p pls_conta.nr_seq_prestador_exec%type default null) FROM PUBLIC;

