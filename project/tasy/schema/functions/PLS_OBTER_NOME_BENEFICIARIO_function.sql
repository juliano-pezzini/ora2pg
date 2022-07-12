-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION pls_obter_nome_beneficiario (nr_seq_segurado_p pls_segurado.nr_sequencia%type) RETURNS varchar AS $body$
DECLARE


--Esta function foi criada para tratar a questão do nome social da pessoa fisica.
cd_pessoa_fisica_w	pessoa_fisica.cd_pessoa_fisica%type;
nm_beneficiario_w	varchar(255);


BEGIN

if (nr_seq_segurado_p IS NOT NULL AND nr_seq_segurado_p::text <> '') then
	select	max(cd_pessoa_fisica)
	into STRICT	cd_pessoa_fisica_w
	from	pls_segurado
	where	nr_sequencia = nr_seq_segurado_p;

	if (cd_pessoa_fisica_w IS NOT NULL AND cd_pessoa_fisica_w::text <> '') then
		nm_beneficiario_w	:= obter_nome_pf(cd_pessoa_fisica_w);
	end if;
end if;

return	nm_beneficiario_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION pls_obter_nome_beneficiario (nr_seq_segurado_p pls_segurado.nr_sequencia%type) FROM PUBLIC;
