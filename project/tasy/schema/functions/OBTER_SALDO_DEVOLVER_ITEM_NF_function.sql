-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_saldo_devolver_item_nf ( nr_sequencia_p bigint, nr_item_nf_p bigint) RETURNS bigint AS $body$
DECLARE


qt_saldo_w		double precision;
qt_item_nf_w		double precision;
qt_item_nf_devolvido_w	double precision;



BEGIN
qt_saldo_w := 0;

select	coalesce(sum(qt_item_nf),0)
into STRICT	qt_item_nf_w
from	nota_fiscal_item
where	nr_sequencia = nr_sequencia_p
and	nr_item_nf = nr_item_nf_p;

select	coalesce(sum(b.qt_item_nf),0)
into STRICT	qt_item_nf_devolvido_w
from	nota_fiscal a,
	nota_fiscal_item b
where	a.nr_sequencia = b.nr_sequencia
and	(a.dt_atualizacao_estoque IS NOT NULL AND a.dt_atualizacao_estoque::text <> '')
and	a.ie_situacao = '1'
and	b.nr_seq_nf_orig = nr_sequencia_p
and	b.nr_seq_item_nf_orig = nr_item_nf_p;

qt_saldo_w := qt_item_nf_w - qt_item_nf_devolvido_w;

return	qt_saldo_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_saldo_devolver_item_nf ( nr_sequencia_p bigint, nr_item_nf_p bigint) FROM PUBLIC;
