-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_se_prescr_erro ( nr_prescricao_p bigint) RETURNS varchar AS $body$
DECLARE


ie_prescr_erro_w	char(1)	:= 'N';


BEGIN

if (nr_prescricao_p IS NOT NULL AND nr_prescricao_p::text <> '') then

	select	coalesce(max('S'),'N')
	into STRICT	ie_prescr_erro_w
	from	prescr_medica_erro where		nr_prescricao = nr_prescricao_p LIMIT 1;

end if;

return ie_prescr_erro_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_se_prescr_erro ( nr_prescricao_p bigint) FROM PUBLIC;
