-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_se_sne_continua2 ( nr_prescricao_p bigint, cd_material_p bigint, qt_dose_p bigint, cd_unidade_medida_p text, cd_intervalo_p text, ie_via_aplicacao_p text, dt_inicio_p timestamp, dt_fim_p timestamp, dt_ini_validade_p timestamp, dt_fim_validade_p timestamp, ie_sne_horario_p text ) RETURNS varchar AS $body$
DECLARE


ie_retorno_w			varchar(1) := 'N';
nr_seq_solucao_w		integer;
ie_status_w				varchar(3);
nr_atendimento_w		bigint;
nr_prescricao_w			bigint;

c01 CURSOR FOR
SELECT
		substr(plt_obter_status_solucao(2,a.nr_prescricao,a.nr_sequencia),1,3),
		a.nr_prescricao
FROM prescr_medica b, prescr_material a
LEFT OUTER JOIN prescr_mat_hor h ON (a.nr_prescricao = h.nr_prescricao AND a.nr_sequencia = h.nr_seq_material)
WHERE a.nr_prescricao	= b.nr_prescricao and b.nr_atendimento = nr_atendimento_w and a.cd_material	= cd_material_p and coalesce(a.qt_dose,coalesce(qt_dose_p,0))	= coalesce(qt_dose_p,0) and coalesce(a.cd_unidade_medida_dose,coalesce(cd_unidade_medida_p,'XPTO'))	= coalesce(cd_unidade_medida_p,'XPTO') and coalesce(a.cd_intervalo,coalesce(cd_intervalo_p,'XPTO'))	= coalesce(cd_intervalo_p,'XPTO') and coalesce(a.ie_via_aplicacao,coalesce(ie_via_aplicacao_p,'XPTO'))	= coalesce(ie_via_aplicacao_p,'XPTO') and a.ie_agrupador	= 8 and b.dt_validade_prescr between dt_ini_validade_p and dt_fim_validade_p and b.nr_prescricao > nr_prescricao_p and coalesce(a.ie_suspenso,'N') = 'N' and ((ie_sne_horario_p = 'S') or (a.ie_status in ('I','INT','P', 'T')) or
		 ((Obter_se_acm_sn_agora_especial(a.ie_acm, a.ie_se_necessario, a.ie_urgencia, h.ie_dose_especial) = 'N') and (a.dt_status between dt_inicio_p and dt_fim_p)) or
		 ((Obter_se_acm_sn_agora_especial(a.ie_acm, a.ie_se_necessario, a.ie_urgencia, h.ie_dose_especial) = 'S') and (obter_se_prescr_vig_adep(b.dt_prescricao,b.dt_validade_prescr,dt_inicio_p,dt_fim_p) = 'S'))) and ((ie_sne_horario_p <> 'S') or
		 ((Obter_se_acm_sn_agora_especial(a.ie_acm, a.ie_se_necessario, a.ie_urgencia, h.ie_dose_especial) = 'S') and (obter_se_prescr_vig_adep(b.dt_prescricao,b.dt_validade_prescr,dt_inicio_p,dt_fim_p) = 'S')) or
		 (ie_sne_horario_p = 'S' AND h.dt_horario between dt_inicio_p and dt_fim_p)) order by 	b.dt_validade_prescr desc;


BEGIN

select	max(nr_atendimento)
into STRICT	nr_atendimento_w
from	prescr_medica
where	nr_prescricao	= nr_prescricao_p;

open C01;
loop
fetch C01 into
	ie_status_w,
	nr_prescricao_w;
EXIT WHEN NOT FOUND; /* apply on C01 */
	begin
	if (ie_status_w <> 'T') then
		ie_retorno_w	:= 'S';
	else
		ie_retorno_w := 'N';
	end if;
	end;
end loop;
close C01;

return	ie_retorno_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_se_sne_continua2 ( nr_prescricao_p bigint, cd_material_p bigint, qt_dose_p bigint, cd_unidade_medida_p text, cd_intervalo_p text, ie_via_aplicacao_p text, dt_inicio_p timestamp, dt_fim_p timestamp, dt_ini_validade_p timestamp, dt_fim_validade_p timestamp, ie_sne_horario_p text ) FROM PUBLIC;
