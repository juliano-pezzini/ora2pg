-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION pls_obter_local_prest_prot ( nr_seq_prestador_p pls_protocolo_conta.nr_seq_prestador%type, ie_tipo_retorno_p text) RETURNS varchar AS $body$
DECLARE


--ie_tipo_retorno p
--'UF' então retorna a UF do prestador do protocolo
--'cidade_ibge' então retorna municipio do prestador do protocolo
ds_retorno_w	varchar(50);
sg_estado_w		pessoa_juridica.sg_estado%type;
cd_municipio_ibge_w	pessoa_juridica.cd_municipio_ibge%type;

BEGIN

select	max(b.sg_estado),
	max(b.cd_municipio_ibge)
into STRICT	sg_estado_w,
	cd_municipio_ibge_w
from	pls_prestador	a,
	pessoa_juridica	b
where	a.nr_sequencia 		= nr_seq_prestador_p
and	b.cd_cgc		= a.cd_cgc;

if (coalesce(sg_estado_w::text, '') = '' and coalesce(cd_municipio_ibge_w::text, '') = '') then
	select	max(c.sg_estado),
		max(c.cd_municipio_ibge)
	into STRICT	sg_estado_w,
		cd_municipio_ibge_w
	from	pls_prestador		a,
		pessoa_fisica		b,
		compl_pessoa_fisica	c
	where	a.nr_sequencia 		= nr_seq_prestador_p
	and	b.cd_pessoa_fisica	= a.cd_pessoa_fisica
	and	c.cd_pessoa_fisica	= b.cd_pessoa_fisica
	and	c.ie_tipo_complemento	= 1;
end if;

case(ie_tipo_retorno_p)
	when 'uf' then
		ds_retorno_w := sg_estado_w;
	when 'cidade_ibge' then
		ds_retorno_w := cd_municipio_ibge_w;
	else
		ds_retorno_w := null;
end case;

return	ds_retorno_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION pls_obter_local_prest_prot ( nr_seq_prestador_p pls_protocolo_conta.nr_seq_prestador%type, ie_tipo_retorno_p text) FROM PUBLIC;

