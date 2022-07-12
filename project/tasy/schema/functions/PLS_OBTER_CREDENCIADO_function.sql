-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION pls_obter_credenciado ( cd_pessoa_fisica_p text, cd_estabelecimento_p bigint) RETURNS varchar AS $body$
DECLARE


nr_seq_prestador_w	bigint;


BEGIN

select	coalesce(max(a.nr_seq_prestador),0)
into STRICT	nr_seq_prestador_w
from	pls_prestador		b,
	pls_prestador_medico	a
where	a.nr_seq_prestador	= b.nr_sequencia
and	a.cd_medico		= cd_pessoa_fisica_p
and	a.ie_tipo_vinculo	= 'C'
and	b.cd_estabelecimento	= cd_estabelecimento_p
and	a.ie_situacao		= 'A'
and	trunc(clock_timestamp(),'dd') between trunc(coalesce(a.dt_inclusao,clock_timestamp()),'dd') and  fim_dia(coalesce(a.dt_exclusao,clock_timestamp()));

if (nr_seq_prestador_w	= 0) then
	select	coalesce(max(nr_sequencia),0)
	into STRICT	nr_seq_prestador_w
	from	pls_prestador
	where	cd_pessoa_fisica	= cd_pessoa_fisica_p
	and	ie_tipo_vinculo		= 'C'
	and	cd_estabelecimento	= cd_estabelecimento_p;
end if;

return	nr_seq_prestador_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION pls_obter_credenciado ( cd_pessoa_fisica_p text, cd_estabelecimento_p bigint) FROM PUBLIC;
