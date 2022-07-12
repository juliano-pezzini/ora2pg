-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_valor_tributo_tit_pagar (nr_titulo_p bigint, nr_bordero_p bigint, nr_seq_baixa_p bigint) RETURNS bigint AS $body$
DECLARE


vl_imposto_w	double precision;


BEGIN

select	coalesce(sum(b.vl_imposto),0)
into STRICT	vl_imposto_w
from	titulo_pagar_imposto b,
	titulo_pagar a
where	a.nr_titulo	= b.nr_titulo
and	b.nr_titulo	= nr_titulo_p
and	a.nr_bordero	= nr_bordero_p
and	b.ie_pago_prev	= 'V';

return vl_imposto_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_valor_tributo_tit_pagar (nr_titulo_p bigint, nr_bordero_p bigint, nr_seq_baixa_p bigint) FROM PUBLIC;

