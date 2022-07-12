-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_seq_tipo_compl_pf ( cd_pessoa_fisica_p text, nr_seq_complemento_p bigint default null, ie_tipo_complemento_p bigint default null) RETURNS varchar AS $body$
DECLARE

nr_seq_retorno_w	compl_pessoa_fisica.nr_sequencia%type;

BEGIN

begin
if (nr_seq_complemento_p IS NOT NULL AND nr_seq_complemento_p::text <> '') then
	select	ie_tipo_complemento
	into STRICT	nr_seq_retorno_w
	from	compl_pessoa_fisica
	where	nr_sequencia = nr_seq_complemento_p
	and	cd_pessoa_fisica = cd_pessoa_fisica_p;
elsif (ie_tipo_complemento_p IS NOT NULL AND ie_tipo_complemento_p::text <> '') then
	select	nr_sequencia
	into STRICT	nr_seq_retorno_w
	from	compl_pessoa_fisica
	where	ie_tipo_complemento = ie_tipo_complemento_p
	and	cd_pessoa_fisica = cd_pessoa_fisica_p;
end if;
exception
when others then
nr_seq_retorno_w := null;
end;

return	nr_seq_retorno_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_seq_tipo_compl_pf ( cd_pessoa_fisica_p text, nr_seq_complemento_p bigint default null, ie_tipo_complemento_p bigint default null) FROM PUBLIC;
