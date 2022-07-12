-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_se_prescricao_liberada ( nr_prescricao_p bigint, ie_liberacao_p text) RETURNS varchar AS $body$
DECLARE


ie_liberada_w	varchar(1) := 'N';


BEGIN
if (nr_prescricao_p IS NOT NULL AND nr_prescricao_p::text <> '') and (ie_liberacao_p IS NOT NULL AND ie_liberacao_p::text <> '') then

	select	CASE WHEN count(*)=0 THEN 'N'  ELSE 'S' END
	into STRICT	ie_liberada_w
	from	prescr_medica
	where	nr_prescricao = nr_prescricao_p
	and	coalesce(dt_suspensao::text, '') = ''
	and	((ie_liberacao_p = 'M' AND dt_liberacao_medico IS NOT NULL AND dt_liberacao_medico::text <> '')
	or	 (ie_liberacao_p = 'E' AND dt_liberacao IS NOT NULL AND dt_liberacao::text <> '')
	or	 (ie_liberacao_p = 'F' AND dt_liberacao_farmacia IS NOT NULL AND dt_liberacao_farmacia::text <> ''));

end if;

return ie_liberada_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_se_prescricao_liberada ( nr_prescricao_p bigint, ie_liberacao_p text) FROM PUBLIC;

