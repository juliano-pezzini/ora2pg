-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_se_atend_tem_prescr (nr_atendimento_p bigint) RETURNS varchar AS $body$
DECLARE


ie_tem_prescr_w	varchar(1);


BEGIN

select	coalesce(max('S'),'N')
into STRICT	ie_tem_prescr_w
from	prescr_medica
where	nr_atendimento = nr_atendimento_p;

return	ie_tem_prescr_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_se_atend_tem_prescr (nr_atendimento_p bigint) FROM PUBLIC;
