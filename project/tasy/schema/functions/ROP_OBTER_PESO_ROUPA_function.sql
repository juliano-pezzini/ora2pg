-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION rop_obter_peso_roupa ( nr_seq_roupa_p bigint) RETURNS bigint AS $body$
DECLARE


qt_peso_w		double precision;


BEGIN

select	a.qt_peso
into STRICT	qt_peso_w
from	rop_lote_roupa a,
	rop_roupa b
where	a.nr_sequencia = b.nr_seq_lote_roupa
and	b.nr_sequencia = nr_seq_roupa_p;

return	qt_peso_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION rop_obter_peso_roupa ( nr_seq_roupa_p bigint) FROM PUBLIC;

