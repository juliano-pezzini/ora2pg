-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_se_atend_prescr_emerg ( nr_atendimento_p bigint, dt_inicial_p timestamp, dt_final_p timestamp) RETURNS varchar AS $body$
DECLARE


ie_emergencia_w		varchar(1);


BEGIN

select	CASE WHEN count(nr_prescricao)=0 THEN 'N'  ELSE 'S' END
into STRICT	ie_emergencia_w
from	prescr_medica
where	nr_atendimento = nr_atendimento_p
and	(dt_liberacao IS NOT NULL AND dt_liberacao::text <> '')
and	coalesce(ie_lib_farm,'N') = 'S'
and	coalesce(dt_liberacao_farmacia::text, '') = ''
and	((coalesce(ie_prescr_emergencia,'N') = 'S') or (coalesce(ie_emergencia,'N') = 'S'))
and	dt_prescricao between dt_inicial_p and dt_Final_p;

return	ie_emergencia_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_se_atend_prescr_emerg ( nr_atendimento_p bigint, dt_inicial_p timestamp, dt_final_p timestamp) FROM PUBLIC;

