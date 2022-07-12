-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION rxt_obter_qt_agendamentos (dt_agenda_p timestamp, nr_seq_equipamento_p bigint, qt_duracao_p bigint) RETURNS bigint AS $body$
DECLARE


qt_retorno_w	bigint;


BEGIN


select	count(*)
into STRICT	qt_retorno_w
from 	rxt_agenda
where 	nr_seq_equipamento	= nr_seq_equipamento_p
and	dt_agenda between dt_agenda_p and trunc(dt_agenda_p,'mi') + qt_duracao_p/1440
and	ie_status_agenda not in ('C','L');

return	qt_retorno_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION rxt_obter_qt_agendamentos (dt_agenda_p timestamp, nr_seq_equipamento_p bigint, qt_duracao_p bigint) FROM PUBLIC;

