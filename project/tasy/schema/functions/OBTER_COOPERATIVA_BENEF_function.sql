-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_cooperativa_benef ( nr_seq_segurado_p bigint, cd_estabelecimento_p bigint) RETURNS varchar AS $body$
DECLARE


nr_seq_contrato_w		bigint;
nr_seq_intercambio_w		bigint;
cd_cooperativa_w		varchar(10);
ds_retorno_w			varchar(4);
nr_seq_congenere_w		bigint;


BEGIN

select	nr_seq_contrato,
	nr_seq_intercambio
into STRICT	nr_seq_contrato_w,
	nr_seq_intercambio_w
from	pls_segurado
where	nr_sequencia	= nr_seq_segurado_p;
if (coalesce(nr_seq_contrato_w,0) <> 0) then
	select	cd_cooperativa,
		nr_seq_congenere
	into STRICT	cd_cooperativa_w,
		nr_seq_congenere_w
	from	pls_contrato
	where	nr_sequencia	= nr_seq_contrato_w;

	if (coalesce(cd_cooperativa_w::text, '') = '') then
		select	max(a.cd_cooperativa)
		into STRICT	cd_cooperativa_w
		from	pls_congenere	a,
			pls_outorgante	b
		where	b.nr_sequencia	= (substr(pls_obter_operadora_estab(cd_estabelecimento_p),1,10))
		and	b.cd_cgc_outorgante	= a.cd_cgc;
	end if;
elsif (coalesce(nr_seq_intercambio_w,0) <> 0) then
	select	b.nr_seq_congenere
	into STRICT	nr_seq_congenere_w
	from	pls_intercambio	b
	where	b.nr_sequencia	= nr_seq_intercambio_w;

	select	max(cd_cooperativa)
	into STRICT	cd_cooperativa_w
	from	pls_congenere
	where	nr_sequencia	= nr_seq_congenere_w;
else
	select	max(a.cd_cooperativa)
	into STRICT	cd_cooperativa_w
	from	pls_congenere	a,
		pls_outorgante	b
	where	b.nr_sequencia	= (substr(pls_obter_operadora_estab(cd_estabelecimento_p),1,10))
	and	b.cd_cgc_outorgante	= a.cd_cgc;
end if;
ds_retorno_w	:= cd_cooperativa_w;

return	ds_retorno_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_cooperativa_benef ( nr_seq_segurado_p bigint, cd_estabelecimento_p bigint) FROM PUBLIC;
