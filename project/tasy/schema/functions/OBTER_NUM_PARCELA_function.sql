-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_num_parcela (nr_titulo_p bigint, nr_sequencia_p bigint) RETURNS bigint AS $body$
DECLARE


nr_sequencia_w     integer;
qt_estornadas_w    integer;
qt_nota_credito_w  integer;

BEGIN

nr_sequencia_w := nr_sequencia_p;

select  count(*)
into STRICT    qt_estornadas_w
from    titulo_receber_liq a,
        titulo_receber b
where   a.vl_recebido < 0
and     a.nr_titulo = b.nr_titulo
and     b.nr_titulo = nr_titulo_p
and     (a.nr_seq_liq_origem IS NOT NULL AND a.nr_seq_liq_origem::text <> '')
and     a.nr_sequencia < nr_sequencia_p;

select  count(*)
into STRICT    qt_nota_credito_w
from    titulo_receber_liq a,
        titulo_receber b
where   a.vl_nota_credito > 0
and     a.nr_titulo = b.nr_titulo
and     b.nr_titulo = nr_titulo_p
and     (a.nr_tit_pagar IS NOT NULL AND a.nr_tit_pagar::text <> '')
and     a.nr_sequencia < nr_sequencia_p;

nr_sequencia_w := ((nr_sequencia_w - qt_estornadas_w) - qt_nota_credito_w);

return	nr_sequencia_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_num_parcela (nr_titulo_p bigint, nr_sequencia_p bigint) FROM PUBLIC;

