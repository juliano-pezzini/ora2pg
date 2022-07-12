-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_codigo_agenda (nr_seq_agenda_p bigint) RETURNS bigint AS $body$
DECLARE


vl_retorno_w		bigint;


BEGIN

select	cd_agenda
into STRICT	vl_retorno_w
from	agenda_consulta
where	nr_sequencia = nr_seq_agenda_p;

return	vl_retorno_w;

end	;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_codigo_agenda (nr_seq_agenda_p bigint) FROM PUBLIC;

