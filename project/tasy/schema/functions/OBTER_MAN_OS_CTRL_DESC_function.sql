-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_man_os_ctrl_desc (nr_sequencia_p bigint) RETURNS bigint AS $body$
DECLARE


qt_ordem_w	bigint;
retorno_w		bigint;


BEGIN


select	count(*)
into STRICT	qt_ordem_w
from	man_os_ctrl_desc
where	nr_sequencia = nr_sequencia_p;

if (qt_ordem_w > 0) then

	select	max(nr_seq_ordem_serv)
	into STRICT	retorno_w
	from	man_os_ctrl_desc
	where	nr_sequencia = nr_sequencia_p;

end if;

return	retorno_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_man_os_ctrl_desc (nr_sequencia_p bigint) FROM PUBLIC;

