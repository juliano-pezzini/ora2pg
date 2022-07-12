-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION pls_obter_se_benef_elegivel ( nr_seq_analise_p pls_analise_conta.nr_sequencia%type, nr_seq_segurado_p pls_conta.nr_seq_segurado%type) RETURNS varchar AS $body$
DECLARE


ds_retorno_w	varchar(100);
qt_benef_w	integer;


BEGIN

select	count(1)
into STRICT	qt_benef_w
from	PLS_ANALISE_INF_CONTA_INT
where	nr_seq_analise		= nr_seq_analise_p
and	nr_seq_segurado		= nr_seq_segurado_p;

if (qt_benef_w	> 0) then
	select	CASE WHEN ie_situacao_origem=1 THEN 'S' WHEN ie_situacao_origem=2 THEN 'beneficiário inelegível'  ELSE 'Operadora origem offline' END
	into STRICT	ds_retorno_w
	from	PLS_ANALISE_INF_CONTA_INT a
	where	nr_seq_analise		= nr_seq_analise_p
	and	nr_seq_segurado		= nr_seq_segurado_p
	and	a.nr_sequencia	=	(SELECT max(b.nr_sequencia)
					 from	PLS_ANALISE_INF_CONTA_INT b
					 where	b.nr_seq_analise	= nr_seq_analise_p
					 and	b.nr_seq_segurado	= nr_seq_segurado_p );
else
	ds_retorno_w	:= 'Beneficiário não consultado';
end if;

return	ds_retorno_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION pls_obter_se_benef_elegivel ( nr_seq_analise_p pls_analise_conta.nr_sequencia%type, nr_seq_segurado_p pls_conta.nr_seq_segurado%type) FROM PUBLIC;

