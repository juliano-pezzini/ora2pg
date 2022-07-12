-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_se_envio_laudo_integr ( cd_convenio_p bigint, cd_setor_atendimento_p bigint) RETURNS varchar AS $body$
DECLARE


ie_integra_w 	varchar(1);


BEGIN

select	CASE WHEN count(*)=0 THEN 'N'  ELSE 'S' END
into STRICT	ie_integra_w
from	regra_envio_laudo_integr
where	coalesce(cd_convenio,cd_convenio_p)	= cd_convenio_p
and	coalesce(cd_setor_atendimento,cd_setor_atendimento_p) = cd_setor_atendimento_p;

return	ie_integra_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_se_envio_laudo_integr ( cd_convenio_p bigint, cd_setor_atendimento_p bigint) FROM PUBLIC;
