-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION pls_obter_se_benef_cooperativa ( nr_seq_segurado_p bigint, cd_cooperativa_p text, cd_estabelecimento_p bigint) RETURNS varchar AS $body$
DECLARE


ds_retorno_w			varchar(1)	:= 'N';
cd_cooperativa_w		varchar(10);
nr_seq_congenere_w		bigint;


BEGIN

begin
	select	b.cd_cooperativa,
		a.nr_seq_congenere
	into STRICT	cd_cooperativa_w,
		nr_seq_congenere_w
	from	pls_segurado	a,
		pls_contrato	b
	where	b.nr_sequencia	= a.nr_seq_contrato
	and	a.nr_sequencia	= nr_seq_segurado_p;
exception
when others then
	begin
	select	b.nr_seq_congenere
	into STRICT	nr_seq_congenere_w
	from	pls_segurado	a,
		pls_intercambio	b
	where	b.nr_sequencia	= a.nr_seq_intercambio
	and	a.nr_sequencia	= nr_seq_segurado_p;
	exception
	when others then
		if (coalesce(nr_seq_congenere_w::text, '') = '') then
			select	a.nr_seq_congenere
			into STRICT	nr_seq_congenere_w
			from	pls_segurado	a
			where	a.nr_sequencia	= nr_seq_segurado_p;
		end if;
	end;
	cd_cooperativa_w	:= null;
end;

if (cd_cooperativa_w	= cd_cooperativa_p) then
	ds_retorno_w	:= 'S';
elsif (coalesce(cd_cooperativa_w::text, '') = '') and (coalesce(nr_seq_congenere_w::text, '') = '') then
	select	max(a.cd_cooperativa)
	into STRICT	cd_cooperativa_w
	from	pls_congenere	a,
		pls_outorgante	b
	where	b.nr_sequencia	= (substr(pls_obter_operadora_estab(cd_estabelecimento_p),1,10))
	and	b.cd_cgc_outorgante	= a.cd_cgc;

	if (cd_cooperativa_p	= cd_cooperativa_w) then
		ds_retorno_w	:= 'S';
	end if;
elsif (nr_seq_congenere_w IS NOT NULL AND nr_seq_congenere_w::text <> '') then
	select	max(cd_cooperativa)
	into STRICT	cd_cooperativa_w
	from	pls_congenere
	where	nr_sequencia	= nr_seq_congenere_w;

	if (cd_cooperativa_w	= cd_cooperativa_p) then
		ds_retorno_w	:= 'S';
	end if;
end if;

return	ds_retorno_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION pls_obter_se_benef_cooperativa ( nr_seq_segurado_p bigint, cd_cooperativa_p text, cd_estabelecimento_p bigint) FROM PUBLIC;
