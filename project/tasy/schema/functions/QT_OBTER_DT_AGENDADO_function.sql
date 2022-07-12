-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION qt_obter_dt_agendado (nr_seq_pend_quimio_p bigint, dt_agenda_p timestamp) RETURNS timestamp AS $body$
DECLARE


dt_retorno_w	timestamp;


BEGIN

select	max(dt_agenda)
into STRICT	dt_retorno_w
from	agenda_quimio_marcacao
where	nr_seq_pend_agenda	= nr_seq_pend_quimio_p
and	trunc(dt_agenda)	= trunc(dt_agenda_p);

return	dt_retorno_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION qt_obter_dt_agendado (nr_seq_pend_quimio_p bigint, dt_agenda_p timestamp) FROM PUBLIC;

