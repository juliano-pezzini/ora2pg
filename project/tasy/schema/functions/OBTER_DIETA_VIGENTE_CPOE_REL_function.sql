-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_dieta_vigente_cpoe_rel (nr_atendimento_p bigint, cd_pessoa_fisica_p text, dt_inicio_p timestamp, dt_fim_p timestamp) RETURNS varchar AS $body$
DECLARE


ie_dieta_vigente_w	varchar(1);


BEGIN

/**  Função criada na OS 1911755 e utilizada no relatório CATE 4565.
Tem como objetivo verificar atendimentos com dieta vigente, a partir da data informada no filtro **/
select	CASE WHEN count(*)=0 THEN  'N'  ELSE 'S' END 
into STRICT	ie_dieta_vigente_w
from	cpoe_dieta
where	((nr_atendimento = nr_atendimento_p) or (cd_pessoa_fisica = cd_pessoa_fisica_p and coalesce(nr_atendimento::text, '') = ''))
and     	(dt_liberacao IS NOT NULL AND dt_liberacao::text <> '')
and	((coalesce(cpoe_obter_dt_suspensao(nr_sequencia,'N')::text, '') = '') or (cpoe_obter_dt_suspensao(nr_sequencia,'N') >= dt_fim_p))
and	((dt_inicio between dt_inicio_p and dt_fim_p) or (dt_fim between dt_inicio_p and dt_fim_p) or (coalesce(dt_fim::text, '') = '' and dt_inicio <= dt_inicio_p));

return	ie_dieta_vigente_w;

end	;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_dieta_vigente_cpoe_rel (nr_atendimento_p bigint, cd_pessoa_fisica_p text, dt_inicio_p timestamp, dt_fim_p timestamp) FROM PUBLIC;

