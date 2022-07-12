-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_se_prescr_alterada ( nr_prescricao_p bigint) RETURNS varchar AS $body$
DECLARE

ie_alterada_w				varchar(1);
DT_ATUALIZACAO_W			prescr_medica.dt_atualizacao%type;
DT_BAIXA_w					prescr_medica.DT_BAIXA%type;
DT_INICIO_ANALISE_FARM_w	prescr_medica.DT_INICIO_ANALISE_FARM%type;
DT_LIBERACAO_FARMACIA_w		prescr_medica.DT_LIBERACAO_FARMACIA%type;
DT_LIBERACAO_PARC_FARM_w	prescr_medica.DT_LIBERACAO_PARC_FARM%type;
DT_REVISAO_w				prescr_medica.DT_REVISAO%type;
DT_SUSPENSAO_w				prescr_medica.DT_SUSPENSAO%type;
DT_liberacao_w				prescr_medica.DT_liberacao%type;
dt_liberacao_medico_w		prescr_medica.dt_liberacao_medico%type;
dt_lib_w					timestamp;


BEGIN

select	max(dt_atualizacao),
		max(dt_baixa),
		max(dt_inicio_analise_farm),
		max(dt_liberacao_farmacia),
		max(dt_liberacao_parc_farm),
		max(dt_revisao),
		max(dt_suspensao),
		max(dt_liberacao),
		max(dt_liberacao_medico),
		coalesce(max(dt_liberacao_medico),max(dt_liberacao))
into STRICT	DT_ATUALIZACAO_W,
		DT_BAIXA_w,
		DT_INICIO_ANALISE_FARM_w,
		DT_LIBERACAO_FARMACIA_w,
		DT_LIBERACAO_PARC_FARM_w,
		DT_REVISAO_w,
		DT_SUSPENSAO_w,
		DT_liberacao_w,
		dt_liberacao_medico_w,
		dt_lib_w
from	prescr_medica
where	nr_prescricao = nr_prescricao_p;		

if (DT_ATUALIZACAO_W	> dt_lib_w) or (DT_BAIXA_w			> dt_lib_w) or (DT_INICIO_ANALISE_FARM_w	> dt_lib_w) or (DT_LIBERACAO_FARMACIA_w	> dt_lib_w) or (DT_LIBERACAO_PARC_FARM_w	> dt_lib_w) or (DT_REVISAO_w	> dt_lib_w) or
	(DT_liberacao_w	> dt_lib_w AND DT_liberacao_medico_w IS NOT NULL AND DT_liberacao_medico_w::text <> '') or (DT_SUSPENSAO_w	> dt_lib_w) then

	ie_alterada_w	:= 'S';
	
else
	
	ie_alterada_w	:= 'N';
	
end if;	

RETURN ie_alterada_w;

END;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_se_prescr_alterada ( nr_prescricao_p bigint) FROM PUBLIC;
