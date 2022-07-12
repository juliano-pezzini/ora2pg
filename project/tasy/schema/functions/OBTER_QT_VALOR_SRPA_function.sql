-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_qt_valor_srpa (nr_sequencia_p bigint) RETURNS bigint AS $body$
DECLARE


qt_resultado_p double precision;


BEGIN
select 	sum(qt_result)
into STRICT 		qt_resultado_p
from 		srpa_aval_item
where 	nr_seq_item = nr_sequencia_p;

return	qt_resultado_p;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_qt_valor_srpa (nr_sequencia_p bigint) FROM PUBLIC;
