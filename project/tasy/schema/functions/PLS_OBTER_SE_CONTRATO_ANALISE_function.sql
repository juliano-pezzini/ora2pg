-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION pls_obter_se_contrato_analise ( nr_seq_analise_p bigint, nr_contrato_p bigint) RETURNS varchar AS $body$
DECLARE


ds_retorno_w		varchar(1);
nr_seq_segurado_w	bigint;


BEGIN

select	nr_seq_segurado
into STRICT	nr_seq_segurado_w
from	pls_analise_conta
where	nr_sequencia = nr_seq_analise_p;

select	CASE WHEN a.nr_seq_contrato=nr_contrato_p THEN  'S'  ELSE 'N' END
into STRICT	ds_retorno_w
from	pls_segurado a,
	pls_contrato b
where	a.nr_sequencia = nr_seq_segurado_w
and	b.nr_sequencia  = a.nr_seq_contrato;

return	ds_retorno_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION pls_obter_se_contrato_analise ( nr_seq_analise_p bigint, nr_contrato_p bigint) FROM PUBLIC;

