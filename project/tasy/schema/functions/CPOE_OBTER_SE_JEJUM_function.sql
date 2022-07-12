-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION cpoe_obter_se_jejum (nr_atendimento_p bigint, cd_pessoa_fisica_p text) RETURNS varchar AS $body$
DECLARE


ie_jejum_vigente	varchar(1);


BEGIN

select	CASE WHEN count(*)=0 THEN  'N'  ELSE 'S' END 
into STRICT	ie_jejum_vigente
from	cpoe_dieta
where	ie_tipo_dieta = 'J'
and		((nr_atendimento = nr_atendimento_p) or (cd_pessoa_fisica = cd_pessoa_fisica_p and coalesce(nr_atendimento::text, '') = ''))
and     	(dt_liberacao IS NOT NULL AND dt_liberacao::text <> '')
and	((coalesce(cpoe_obter_dt_suspensao(nr_sequencia,'N')::text, '') = '') or (cpoe_obter_dt_suspensao(nr_sequencia,'N') >= clock_timestamp()))
and (coalesce(dt_fim::text, '') = '' or dt_fim >= clock_timestamp())
and (dt_inicio <= clock_timestamp());

return	ie_jejum_vigente;

end	;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION cpoe_obter_se_jejum (nr_atendimento_p bigint, cd_pessoa_fisica_p text) FROM PUBLIC;

