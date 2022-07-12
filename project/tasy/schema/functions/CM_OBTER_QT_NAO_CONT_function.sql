-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION cm_obter_qt_nao_cont ( nr_seq_conjunto_p bigint) RETURNS bigint AS $body$
DECLARE


qt_retorno_w		bigint;


BEGIN

select	count(*)
into STRICT	qt_retorno_w
from	cm_conjunto_cont
where	nr_seq_conjunto = nr_seq_conjunto_p
and	coalesce(ie_situacao,'A') = 'A'
and	((ie_status_conjunto <> 2 and
	coalesce(dt_validade::text, '') = '') or (ie_status_conjunto <> 2 and
	(dt_validade IS NOT NULL AND dt_validade::text <> '') and
	trunc(dt_validade) > trunc(clock_timestamp())));

return	qt_retorno_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION cm_obter_qt_nao_cont ( nr_seq_conjunto_p bigint) FROM PUBLIC;
