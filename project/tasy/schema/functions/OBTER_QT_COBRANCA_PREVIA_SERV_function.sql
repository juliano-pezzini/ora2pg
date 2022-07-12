-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_qt_cobranca_previa_serv ( nr_seq_orcamento_p bigint) RETURNS bigint AS $body$
DECLARE


qt_registros_w 	bigint;


BEGIN

select 	count(1)
into STRICT	qt_registros_w
from 	pls_cobranca_previa_serv
where 	nr_seq_orcamento = nr_seq_orcamento_p;

return	qt_registros_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_qt_cobranca_previa_serv ( nr_seq_orcamento_p bigint) FROM PUBLIC;
