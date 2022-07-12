-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_desc_parent_odontoprev (nr_seq_segurado_p pls_segurado.nr_sequencia%type) RETURNS varchar AS $body$
DECLARE


ds_retorno_w		varchar(255);
ie_grau_parentesco_w	grau_parentesco.ie_grau_parentesco%type;
nr_seq_titular_w	pls_segurado.nr_seq_titular%type;
nr_seq_parentesco_w	grau_parentesco.nr_sequencia%type;
ie_sexo_w		pessoa_fisica.ie_sexo%type;


BEGIN
if (coalesce(nr_seq_segurado_p,0) > 0) then
	select 	b.nr_seq_titular,
		b.nr_seq_parentesco,
		a.ie_sexo
	into STRICT	nr_seq_titular_w,
		nr_seq_parentesco_w,
		ie_sexo_w
	from	pls_segurado b,
		pessoa_fisica a
	where 	a.cd_pessoa_fisica 	= b.cd_pessoa_fisica
	and 	b.nr_sequencia 		= nr_seq_segurado_p;

	select 	max(ie_grau_parentesco)
	into STRICT	ie_grau_parentesco_w
	from 	grau_parentesco
	where 	nr_sequencia = nr_seq_parentesco_w;

	if (coalesce(nr_seq_titular_w::text, '') = '')then
		ds_retorno_w := obter_desc_expressao(300089);
	elsif (ie_grau_parentesco_w = '3' )then
		if (ie_sexo_w = 'M')then
			ds_retorno_w := obter_desc_expressao(290085);
		elsif (ie_sexo_w = 'F')then
			ds_retorno_w := obter_desc_expressao(486611);
		end if;
	elsif (ie_grau_parentesco_w = '4' )then
		ds_retorno_w := obter_desc_expressao(285704);
	else
		ds_retorno_w := obter_desc_expressao(489954);
	end if;
end if;

return	ds_retorno_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_desc_parent_odontoprev (nr_seq_segurado_p pls_segurado.nr_sequencia%type) FROM PUBLIC;

