-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION pls_se_grupo_preco_operadora ( nr_seq_grupo_operadora_p bigint, nr_seq_operadora_p bigint) RETURNS varchar AS $body$
DECLARE


ds_retorno_w			varchar(10)	:= 'N';
qt_regra_w			integer;


BEGIN

select	count(1)
into STRICT	qt_regra_w
from	pls_preco_grupo_operadora	a,
	pls_preco_operadora		b
where	a.nr_sequencia		= b.nr_seq_grupo
and	a.ie_situacao		= 'A'
and	a.nr_sequencia		= nr_seq_grupo_operadora_p
and	b.nr_seq_congenere	= nr_seq_operadora_p;

if (qt_regra_w	> 0) then
	ds_retorno_w	:= 'S';
end if;

return	ds_retorno_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION pls_se_grupo_preco_operadora ( nr_seq_grupo_operadora_p bigint, nr_seq_operadora_p bigint) FROM PUBLIC;

