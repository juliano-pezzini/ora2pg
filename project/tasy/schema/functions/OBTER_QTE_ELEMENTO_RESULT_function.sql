-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_qte_elemento_result (nr_sequencia_p bigint) RETURNS bigint AS $body$
DECLARE


qt_reg_w	smallint;


BEGIN

select	count(*)
into STRICT	qt_reg_w
from	ehr_elemento_result
where	nr_seq_elemento = nr_sequencia_p;

return	qt_reg_w;

end	;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_qte_elemento_result (nr_sequencia_p bigint) FROM PUBLIC;

