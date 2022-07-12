-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_se_exibe_prescr_gpfc ( nr_prescricao_p bigint, ie_restringe_estab_p text, cd_estabelecimento_p bigint, ie_exibe_dialise_p text, ie_motivo_prescricao_p text, ie_liberacao_p bigint, cd_setor_atendimento_p bigint, ie_status_farm_p bigint, nr_seq_classif_transcr_p bigint, ie_intervencao_farm_p text, cd_grupo_material_p bigint, cd_subgrupo_material_p bigint, cd_classe_material_p bigint, cd_material_p bigint, ie_nao_padronizado_p text, ie_quimio_p text, ie_alto_risco_p text, ie_alta_vigilancia_p text, ie_medic_alto_custo_p text, ie_medic_paciente_p text, ie_dispensacao_p bigint, ie_tipo_item_p bigint, ie_prescritor_p bigint, ie_urgencia_p bigint, cd_intervalo_p text, qt_minutos_agora_p bigint, ie_restrito_p text, ie_vaga_solicitada_p text, ie_prescr_nao_atend_p text) RETURNS varchar AS $body$
DECLARE

 
ie_exibe_w			varchar(1) := 'N';
cd_estabelecimento_w		smallint;
ie_hemodialise_w		varchar(1);
ie_motivo_prescricao_w		varchar(3);
dt_liberacao_farmacia_w		timestamp;
cd_setor_atendimento_w		integer;
nr_seq_status_farm_w		bigint;
nr_seq_classif_transcr_w	bigint;
ie_prescr_farm_w		varchar(1);
ie_alta_vigilancia_w		varchar(1);
ie_medic_alto_custo_w		varchar(1);
ie_dispensacao_w		varchar(1) := 'S';
ds_itens_prescr_w		varchar(1000);
ie_tipo_item_w			varchar(1) := 'S';
cd_prescritor_w			varchar(10);
cd_medico_w			varchar(10);
ie_apresenta_urg_w		varchar(1) := 'S';
nr_seq_classif_trasncr_w	bigint;
nr_atendimento_w		bigint;
ie_apres_nao_atend_w		varchar(1) := 'S';
			

BEGIN 
 
select	max(cd_estabelecimento), 
	max(ie_hemodialise), 
	max(dt_liberacao_farmacia), 
	max(cd_setor_atendimento), 
	max(nr_seq_status_farm), 
	max(obter_dados_transcricao(nr_seq_transcricao, 'CL')), 
	max(ie_prescr_farm), 
	max(ie_motivo_prescricao), 
	upper(max(obter_itens_prescr(nr_prescricao,DS_ITENS_PRESCR))), 
	max(cd_prescritor), 
	max(cd_medico), 
	max(nr_atendimento) 
into STRICT	cd_estabelecimento_w, 
	ie_hemodialise_w, 
	dt_liberacao_farmacia_w, 
	cd_setor_atendimento_w, 
	nr_Seq_status_farm_w, 
	nr_seq_classif_trasncr_w, 
	ie_prescr_farm_w, 
	ie_motivo_prescricao_w, 
	ds_itens_prescr_w, 
	cd_prescritor_w, 
	cd_medico_w, 
	nr_atendimento_w 
from	prescr_medica 
where	nr_prescricao	= nr_prescricao_p;
 
if (ie_alta_vigilancia_p	= 'S') then 
 
	select	coalesce(max('S'),'N') 
	into STRICT	ie_alta_vigilancia_w 
	from	material a, 
		prescr_material b 
	where	b.cd_material 	= a.cd_material 
	and	b.nr_prescricao = nr_prescricao_p 
	and	a.ie_alta_vigilancia = 'S' 
	and	coalesce(b.ie_suspenso,'N') 	<> 'S';
 
end if;
 
if (ie_medic_alto_custo_p	= 'S') then 
 
	select	coalesce(max('S'),'N') 
	into STRICT	ie_medic_alto_custo_w 
	from	material a, 
		prescr_material b, 
		material_estab c 
	WHERE	a.cd_material = b.cd_material 
	AND	a.cd_material = c.cd_material 
	AND	c.cd_estabelecimento = cd_estabelecimento_p 
	AND	c.ie_classif_custo	= 'A' 
	AND	b.nr_prescricao = nr_prescricao_p 
	AND 	coalesce(b.ie_suspenso,'N') <> 'S';
	 
end if;
 
if (ie_dispensacao_p = 0) then 
 
	select	coalesce(max('S'),'N') 
	into STRICT	ie_dispensacao_w 
	from	prescr_material x 
	where	x.nr_prescricao = nr_prescricao_p 
	and	x.ie_regra_disp = 'U';
 
elsif (ie_dispensacao_p = 1) then	 
	 
	select	coalesce(max('N'),'S') 
	into STRICT	ie_dispensacao_w 
	from	prescr_material x 
	where	x.nr_prescricao = nr_prescricao_p 
	and	x.ie_regra_disp = 'U';	
 
end if;
 
if (ie_tipo_item_p = 0) then 
	if (ds_itens_prescr_w not like('%MEDIC%')) then 
		ie_tipo_item_w := 'N';
	end if;
elsif (ie_tipo_item_p = 1) then 
	if (ds_itens_prescr_w not like('%SOL%')) then 
		ie_tipo_item_w := 'N';
	end if;
elsif (ie_tipo_item_p = 2) then 
	if (ds_itens_prescr_w not like('%SNE%')) then 
		ie_tipo_item_w := 'N';
	end if;
elsif (ie_tipo_item_p = 3) then 
	if (ds_itens_prescr_w not like('%NPTA%')) and (ds_itens_prescr_w not like('%NPTN%')) and (ds_itens_prescr_w not like('%NPTP%')) then 
		ie_tipo_item_w := 'N';
	end if;	
end if;
 
if (ie_urgencia_p	= 0) then 
	if	((cd_intervalo_p IS NOT NULL AND cd_intervalo_p::text <> '') and (obter_se_prescr_agora(nr_prescricao_p,qt_minutos_agora_p,cd_intervalo_p) = 'N')) or 
		((coalesce(cd_intervalo_p::text, '') = '') and (obter_se_prescr_agora(nr_prescricao_p,qt_minutos_agora_p,null) = 'N')) then 
		ie_apresenta_urg_w	 := 'N';
	end if;
elsif (ie_urgencia_p	= 1) then	 
	if	((cd_intervalo_p IS NOT NULL AND cd_intervalo_p::text <> '') and (obter_se_prescr_agora(nr_prescricao_p,qt_minutos_agora_p,cd_intervalo_p) = 'S')) or 
		((coalesce(cd_intervalo_p::text, '') = '') and (obter_se_prescr_agora(nr_prescricao_p,qt_minutos_agora_p,null) = 'S')) then 
		ie_apresenta_urg_w	 := 'N';
	end if;
end if;
 
if (ie_prescr_nao_atend_p = 'S') then 
	 
	select	coalesce(max('S'),'N') 
	into STRICT	ie_apres_nao_atend_w 
	from	prescr_material 
	where	nr_prescricao = nr_prescricao_p 
	and	coalesce(cd_motivo_baixa, 0) = 0;
	 
end if;
 
if	((ie_restringe_estab_p	= 'N') or (cd_estabelecimento_p = cd_estabelecimento_w)) and 
	((ie_exibe_dialise_p	= 'S') or (coalesce(ie_hemodialise_w::text, '') = '')) and 
	((coalesce(ie_motivo_prescricao_p::text, '') = '') or (ie_motivo_prescricao_p = ie_motivo_prescricao_w)) and 
	((ie_liberacao_p not in (2,1)) or 
	 ((ie_liberacao_p = 2) and (coalesce(dt_liberacao_farmacia_w::text, '') = '')) or 
	 (ie_liberacao_p = 1 AND dt_liberacao_farmacia_w IS NOT NULL AND dt_liberacao_farmacia_w::text <> '')) and 
	((coalesce(cd_setor_atendimento_p::text, '') = '') or (cd_setor_atendimento_p = cd_setor_atendimento_w)) and 
	(((ie_status_farm_p = 0) and (coalesce(nr_seq_status_farm_w::text, '') = '')) or (nr_seq_status_farm_w = ie_status_farm_p) or (coalesce(ie_status_farm_p::text, '') = '')) and 
	((coalesce(nr_seq_classif_transcr_p::text, '') = '') or (nr_Seq_classif_transcr_p = nr_seq_classif_transcr_w)) and 
	((coalesce(ie_intervencao_farm_p::text, '') = '') or (ie_prescr_farm_w = ie_intervencao_farm_p)) and 
	(((coalesce(cd_grupo_material_p::text, '') = '') and (coalesce(cd_subgrupo_material_p::text, '') = '') and (coalesce(cd_classe_material_p::text, '') = '')) or (coalesce(obter_se_mat_estrutura(cd_grupo_material_p, cd_subgrupo_material_p, cd_classe_material_p, nr_prescricao_p),'S') = 'S')) and 
	((coalesce(cd_material_p::text, '') = '') or (coalesce(obter_se_prescricao_material(nr_prescricao_p,cd_material_p),'S') = 'S')) and 
	((ie_nao_padronizado_p = 'N') or (coalesce(obter_se_medic_padronizado(nr_prescricao_p),'S') = 'N')) and 
	((ie_quimio_p = 'N') or (coalesce(obter_se_prescricao_quimio(nr_prescricao_p) ,'N') = 'S')) and 
	((ie_alto_risco_p = 'N') or (obter_se_medic_alto_risco(nr_prescricao_p) = 'S')) and 
	((coalesce(ie_alta_vigilancia_p,'N')	= 'N') or (ie_alta_vigilancia_p = ie_alta_vigilancia_w)) and 
	((ie_medic_alto_custo_p = 'N') or (ie_medic_alto_custo_p = ie_medic_alto_custo_w)) and 
	((ie_medic_paciente_p = 'N') or (obter_se_medic_paciente(nr_prescricao_p) = 'S')) and 
	((ie_restrito_p = 'N') or (obter_se_possui_medic_restrito(nr_prescricao_p) = 'S')) and 
	((ie_vaga_solicitada_p = 'N') or (obter_solic_vaga_atend(nr_atendimento_w, 'IE') = 'S')) and (ie_dispensacao_w	= 'S') and (ie_tipo_item_w		= 'S') and 
	((ie_prescritor_p = 0 AND cd_prescritor_w = cd_medico_w) or 
	 (ie_prescritor_p = 1 AND cd_prescritor_w <> cd_medico_w) or (ie_prescritor_p = 2)) and (ie_apresenta_urg_w = 'S') and (ie_apres_nao_atend_w = 'S') then 
	 
	ie_exibe_w := 'S';
	 
end if;
 
return	ie_exibe_w;
 
end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_se_exibe_prescr_gpfc ( nr_prescricao_p bigint, ie_restringe_estab_p text, cd_estabelecimento_p bigint, ie_exibe_dialise_p text, ie_motivo_prescricao_p text, ie_liberacao_p bigint, cd_setor_atendimento_p bigint, ie_status_farm_p bigint, nr_seq_classif_transcr_p bigint, ie_intervencao_farm_p text, cd_grupo_material_p bigint, cd_subgrupo_material_p bigint, cd_classe_material_p bigint, cd_material_p bigint, ie_nao_padronizado_p text, ie_quimio_p text, ie_alto_risco_p text, ie_alta_vigilancia_p text, ie_medic_alto_custo_p text, ie_medic_paciente_p text, ie_dispensacao_p bigint, ie_tipo_item_p bigint, ie_prescritor_p bigint, ie_urgencia_p bigint, cd_intervalo_p text, qt_minutos_agora_p bigint, ie_restrito_p text, ie_vaga_solicitada_p text, ie_prescr_nao_atend_p text) FROM PUBLIC;

