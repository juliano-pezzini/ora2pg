-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_se_atend_laboratorio (nr_atendimento_p bigint, qt_horas_apos_validade_p bigint) RETURNS varchar AS $body$
DECLARE

 
ie_laboratorio_w	varchar(1) := 'N';
dt_validade_prescr_w	timestamp;


BEGIN 
if (nr_atendimento_p IS NOT NULL AND nr_atendimento_p::text <> '') then 
	dt_validade_prescr_w := clock_timestamp() - (coalesce(qt_horas_apos_validade_p, 0)/24);
 
	/* pendentes */
 
	select	CASE WHEN count(*)=0 THEN  'N'  ELSE 'S' END  
	into STRICT	ie_laboratorio_w 
	from	adep_pend_v 
	where	(dt_liberacao IS NOT NULL AND dt_liberacao::text <> '') 
	and		dt_validade_prescr > dt_validade_prescr_w 
	and	coalesce(ie_laboratorio,'N') = 'S' 
	and	nr_atendimento = nr_atendimento_p;
 
	/* administrados */
 
	if (ie_laboratorio_w = 'N') then 
		select	CASE WHEN count(*)=0 THEN  'N'  ELSE 'S' END  
		into STRICT	ie_laboratorio_w 
		from	adep_adm_v 
		where	(dt_liberacao IS NOT NULL AND dt_liberacao::text <> '') 
		and		dt_validade_prescr > dt_validade_prescr_w 
		and	coalesce(ie_laboratorio,'N') = 'S' 
		and	nr_atendimento = nr_atendimento_p;
	end if;
 
	/* suspensos */
 
	if (ie_laboratorio_w = 'N') then 
		select	CASE WHEN count(*)=0 THEN  'N'  ELSE 'S' END  
		into STRICT	ie_laboratorio_w 
		from	adep_susp_v 
		where	(dt_liberacao IS NOT NULL AND dt_liberacao::text <> '') 
		and		dt_validade_prescr > dt_validade_prescr_w 
		and	coalesce(ie_laboratorio,'N') = 'S' 
		and	nr_atendimento = nr_atendimento_p;
	end if;
 
	/* vigentes sem horarios */
 
	if (ie_laboratorio_w = 'N') then 
		select	CASE WHEN count(*)=0 THEN  'N'  ELSE 'S' END  
		into STRICT	ie_laboratorio_w 
		from	adep_item_prescr_v 
		where	(dt_liberacao IS NOT NULL AND dt_liberacao::text <> '') 
		and		dt_validade_prescr > dt_validade_prescr_w 
		--and	nvl(ie_laboratorio,'N') = 'S' 
		and	coalesce(ie_tipo_item,'P') = 'L' 
		and	nr_atendimento = nr_atendimento_p;
	end if;
	 
end if;
 
return ie_laboratorio_w;
 
end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_se_atend_laboratorio (nr_atendimento_p bigint, qt_horas_apos_validade_p bigint) FROM PUBLIC;
