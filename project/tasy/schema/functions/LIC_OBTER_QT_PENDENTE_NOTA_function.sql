-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION lic_obter_qt_pendente_nota (nr_seq_item_p bigint) RETURNS bigint AS $body$
DECLARE


qt_item_w		double precision;
qt_nota_w		double precision;
qt_retorno_w		double precision;


BEGIN

select	coalesce(qt_item, 0)
into STRICT	qt_item_w
from	lic_item
where	nr_sequencia = nr_seq_item_p;

select	coalesce(sum(QT_ITEM_NF), 0)
into STRICT	qt_nota_w
from	nota_fiscal_item
where	nr_seq_lic_item = nr_seq_item_p;

qt_retorno_w := qt_item_w - qt_nota_w;
return qt_retorno_w;
end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION lic_obter_qt_pendente_nota (nr_seq_item_p bigint) FROM PUBLIC;
