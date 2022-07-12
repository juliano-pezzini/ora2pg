-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_qt_prescr_proc_atend (nr_prescricao_p bigint, nr_sequencia_prescr_p bigint) RETURNS bigint AS $body$
DECLARE


qt_execucao_w		bigint	:= 0;


BEGIN

select	count(*)
into STRICT	qt_execucao_w
from	procedimento_paciente
where	nr_prescricao			= nr_prescricao_p
and	nr_sequencia_prescricao		= nr_sequencia_prescr_p;

return	qt_execucao_w;


end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_qt_prescr_proc_atend (nr_prescricao_p bigint, nr_sequencia_prescr_p bigint) FROM PUBLIC;
