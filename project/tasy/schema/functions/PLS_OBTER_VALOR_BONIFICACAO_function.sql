-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION pls_obter_valor_bonificacao ( nr_seq_mensalidade_p bigint) RETURNS bigint AS $body$
DECLARE


vl_bonificacao_w	double precision;


BEGIN

select	sum(vl_item)
into STRICT	vl_bonificacao_w
from	pls_mensalidade_seg_item	c,
	pls_mensalidade_segurado	b,
	pls_mensalidade			a
where	c.nr_seq_mensalidade_seg	= b.nr_sequencia
and	b.nr_seq_mensalidade		= a.nr_sequencia
and	a.nr_sequencia			= nr_seq_mensalidade_p
and	c.ie_tipo_item			= 14;

return	vl_bonificacao_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION pls_obter_valor_bonificacao ( nr_seq_mensalidade_p bigint) FROM PUBLIC;

