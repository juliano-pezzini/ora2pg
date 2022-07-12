-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION pls_obter_seq_prestador_partic ( cd_pessoa_fisica_p text, nr_seq_prestador_p bigint, cd_estabelecimento_p bigint) RETURNS bigint AS $body$
DECLARE


nr_retorno_w		bigint;
nr_seq_prestador_w	bigint;


BEGIN

begin
	select 	nr_seq_prestador_ref
	into STRICT	nr_seq_prestador_w
	from 	pls_prestador_medico
	where	nr_seq_prestador = nr_seq_prestador_p
	and	cd_medico = cd_pessoa_fisica_p;
exception
when others then
	nr_seq_prestador_w := 0;
end;

if (nr_seq_prestador_w > 0) then
	nr_retorno_w := nr_seq_prestador_w;
else
	nr_retorno_w := nr_seq_prestador_p;
end if;



return	nr_retorno_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION pls_obter_seq_prestador_partic ( cd_pessoa_fisica_p text, nr_seq_prestador_p bigint, cd_estabelecimento_p bigint) FROM PUBLIC;

