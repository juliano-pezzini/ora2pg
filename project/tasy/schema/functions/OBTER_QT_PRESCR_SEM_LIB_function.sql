-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_qt_prescr_sem_lib (nr_atendimento_p bigint) RETURNS bigint AS $body$
DECLARE


qt_retorno_w		integer;


BEGIN

Select	count(*)
into STRICT	qt_retorno_w
from	prescr_medica
where	nr_atendimento	= nr_atendimento_p
and	(dt_liberacao_medico IS NOT NULL AND dt_liberacao_medico::text <> '')
and	coalesce(dt_liberacao::text, '') = ''
and	dt_liberacao_medico between clock_timestamp() - interval '1 days' and clock_timestamp() + interval '2 days'
and	dt_prescricao between clock_timestamp() - interval '7 days' and clock_timestamp() + interval '2 days';

return qt_retorno_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_qt_prescr_sem_lib (nr_atendimento_p bigint) FROM PUBLIC;

