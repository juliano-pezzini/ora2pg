-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION pls_obter_dados_fornecedor_mat ( nr_seq_fornecedor_p bigint, ie_opcao_p text) RETURNS varchar AS $body$
DECLARE


/* ie_opcao
	'CO' 	= DS_CONTATO
	'TE' 	= DS_TELEFONE
	'DD' 	= DS_DDD
	'CD_CGC'	= CD_CGC
*/
ds_retorno_w			varchar(255);


BEGIN


if (ie_opcao_p = 'CO') then

	select	max(nm_contato)
	into STRICT	ds_retorno_w
	from	pls_fornecedor_material
	where	nr_sequencia = nr_seq_fornecedor_p;

	if (coalesce(ds_retorno_w::text, '') = '') then
		select	max(c.nm_pessoa_contato)
		into STRICT	ds_retorno_w
		from	pls_fornecedor_material	b,
			pessoa_juridica_estab	c,
			pessoa_juridica		a
		where	a.cd_cgc	= b.cd_cgc
		and	a.cd_cgc	= c.cd_cgc
		and	b.nr_sequencia	= nr_seq_fornecedor_p;
	end if;

elsif (ie_opcao_p = 'TE') then

	select	max(nr_telefone)
	into STRICT	ds_retorno_w
	from	pls_fornecedor_material
	where	nr_sequencia = nr_seq_fornecedor_p;

	if (coalesce(ds_retorno_w::text, '') = '') then
		select	max(a.nr_telefone)
		into STRICT	ds_retorno_w
		from	pls_fornecedor_material	b,
			pessoa_juridica		a
		where	a.cd_cgc	= b.cd_cgc
		and	b.nr_sequencia	= nr_seq_fornecedor_p;
	end if;

elsif (ie_opcao_p = 'DD') then

	select	max(nr_ddd_telefone)
	into STRICT	ds_retorno_w
	from	pls_fornecedor_material
	where	nr_sequencia = nr_seq_fornecedor_p;

elsif (ie_opcao_p = 'CD_CGC') then

	select	max(CD_CGC)
	into STRICT	ds_retorno_w
	from	pls_fornecedor_material
	where	nr_sequencia = nr_seq_fornecedor_p;

end if;

return	ds_retorno_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION pls_obter_dados_fornecedor_mat ( nr_seq_fornecedor_p bigint, ie_opcao_p text) FROM PUBLIC;
