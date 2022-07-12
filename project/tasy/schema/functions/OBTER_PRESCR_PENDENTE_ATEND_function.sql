-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_prescr_pendente_atend (nr_atendimento_p bigint) RETURNS varchar AS $body$
DECLARE


qt_prescr_w	varchar(1);


BEGIN

select	CASE WHEN count(*)=0 THEN 'N'  ELSE 'S' END
into STRICT	qt_prescr_w
from	prescr_medica a
where	a.nr_atendimento	= nr_atendimento_p
and	coalesce(cd_motivo_baixa,0) = 0
and	(coalesce(a.dt_liberacao, a.dt_liberacao_medico) IS NOT NULL AND (coalesce(a.dt_liberacao, a.dt_liberacao_medico))::text <> '')
and	coalesce(dt_suspensao::text, '') = '';

return	qt_prescr_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_prescr_pendente_atend (nr_atendimento_p bigint) FROM PUBLIC;
