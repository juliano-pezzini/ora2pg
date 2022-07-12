-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';

CREATE OR REPLACE VIEW adep_pend_hsl_v (nr_seq_apresent, ie_tipo_item, ds_tipo_item, ds_tipo_item_plural, ie_laboratorio, nr_atendimento, nr_prescricao, cd_prescritor, nm_prescritor, dt_prescricao, dt_inicio_prescr, dt_validade_prescr, dt_liberacao, nr_seq_item, ie_acm_sn, ie_di, cd_item, ds_item, cd_intervalo, ds_diluente, ds_topografia, ie_assoc_adep, nr_seq_horario, dt_horario, qt_pend, cd_um, qt_dose, cd_unidade_medida_dose, ie_via, cd_pessoa_evento, nm_pessoa_evento, ds_evento, ie_aprazado) AS select	1 nr_seq_apresent,
	'D' ie_tipo_item, 
	'Dieta oral' ds_tipo_item, 
	'Dietas orais' ds_tipo_item_plural, 
	'N' ie_laboratorio, 
	a.nr_atendimento, 
	a.nr_prescricao, 
	a.cd_prescritor, 
	substr(obter_nome_pf(a.cd_prescritor),1,60) nm_prescritor, 
	a.dt_prescricao, 
	a.dt_inicio_prescr, 
	a.dt_validade_prescr, 
	a.dt_liberacao, 
	-1 nr_seq_item, 
	null ie_acm_sn, 
	null ie_di, 
	c.cd_refeicao cd_item, 
	substr(obter_valor_dominio(99,c.cd_refeicao),1,240) ds_item, 
	'' cd_intervalo, 
	null ds_diluente, 
	null ds_topografia, 
	'N' ie_assoc_adep, 
	c.nr_sequencia nr_seq_horario, 
	c.dt_horario, 
	1 qt_pend, 
	'' cd_um, 
	1 qt_dose, 
	'' cd_unidade_medida_dose, 
	'' ie_via, 
	--substr(obter_resp_atend_data_opcao(a.nr_atendimento,c.dt_horario,'C'),1,10) cd_pessoa_evento, 
	--substr(obter_resp_atend_data_opcao(a.nr_atendimento,c.dt_horario,'N'),1,60) nm_pessoa_evento 
	'' cd_pessoa_evento, 
	'' nm_pessoa_evento, 
	null ds_evento, 
	c.ie_aprazado 
FROM	prescr_dieta_hor c, 
		prescr_medica a 
where	c.nr_prescricao = a.nr_prescricao 
and	c.dt_fim_horario is null 
and	c.dt_suspensao is null 
and	coalesce(c.ie_situacao,'A') = 'A' 
and	coalesce(a.ie_adep,'S') = 'S' 
and	Obter_se_horario_liberado(c.dt_lib_horario, c.dt_horario) = 'S' 

union all
 
select	2 nr_seq_apresent, 
	'S' ie_tipo_item, 
	'Suplemento oral' ds_tipo_item, 
	'Suplementos orais' ds_tipo_item_plural, 
	'N' ie_laboratorio, 
	a.nr_atendimento, 
	a.nr_prescricao, 
	a.cd_prescritor, 
	substr(obter_nome_pf(a.cd_prescritor),1,60) nm_prescritor, 
	a.dt_prescricao, 
	a.dt_inicio_prescr, 
	a.dt_validade_prescr, 
	a.dt_liberacao, 
	b.nr_sequencia nr_seq_item, 
	CASE WHEN coalesce(b.ie_acm,'N')='S' THEN  'S'  ELSE CASE WHEN coalesce(b.ie_se_necessario,'N')='S' THEN  'S'  ELSE 'N' END  END  ie_acm_sn, 
	coalesce(b.ie_bomba_infusao,'N') ie_di, 
	to_char(b.cd_material) cd_item, 
	substr(obter_desc_material(b.cd_material),1,240) ds_item, 
	b.cd_intervalo cd_intervalo, 
	null ds_diluente, 
	null ds_topografia, 
	'N' ie_assoc_adep, 
	c.nr_sequencia nr_seq_horario, 
	c.dt_horario, 
	c.qt_dispensar_hor qt_pend, 
	c.cd_unidade_medida cd_um, 
	c.qt_dose, 
	c.cd_unidade_medida_dose, 
	b.ie_via_aplicacao ie_via, 
	--substr(obter_resp_atend_data_opcao(a.nr_atendimento,c.dt_horario,'C'),1,10) cd_pessoa_evento, 
	--substr(obter_resp_atend_data_opcao(a.nr_atendimento,c.dt_horario,'N'),1,60) nm_pessoa_evento 
	'' cd_pessoa_evento, 
	'' nm_pessoa_evento, 
	null ds_evento, 
	c.ie_aprazado 
from	prescr_mat_hor c, 
		prescr_material b, 
		prescr_medica a 
where	c.nr_seq_material = b.nr_sequencia 
and	c.nr_prescricao = b.nr_prescricao 
and	b.nr_prescricao = a.nr_prescricao 
and	c.dt_fim_horario is null 
and	c.dt_suspensao is null 
and	coalesce(c.ie_situacao,'A') = 'A' 
--and	nvl(c.ie_horario_especial,'N') <> 'S' 
and	b.ie_agrupador = 12 
and	coalesce(a.ie_adep,'S') = 'S' 
and	Obter_se_horario_liberado(c.dt_lib_horario, c.dt_horario) = 'S' 

union all
 
select	3 nr_seq_apresent, 
	'M' ie_tipo_item, 
	'Medicamento' ds_tipo_item, 
	'Medicamentos' ds_tipo_item_plural, 
	'N' ie_laboratorio, 
	a.nr_atendimento, 
	a.nr_prescricao, 
	a.cd_prescritor, 
	substr(obter_nome_pf(a.cd_prescritor),1,60) nm_prescritor, 
	a.dt_prescricao, 
	a.dt_inicio_prescr, 
	a.dt_validade_prescr, 
	a.dt_liberacao, 
	b.nr_sequencia nr_seq_item, 
	CASE WHEN coalesce(b.ie_acm,'N')='S' THEN  'S'  ELSE CASE WHEN coalesce(b.ie_se_necessario,'N')='S' THEN  'S'  ELSE 'N' END  END  ie_acm_sn, 
	coalesce(b.ie_bomba_infusao,'N') ie_di, 
	to_char(b.cd_material) cd_item, 
	substr(obter_desc_material(b.cd_material),1,240) ds_item, 
	b.cd_intervalo cd_intervalo, 
	substr(obter_diluicao_medic_adep(c.nr_sequencia),1,240) ds_diluente, 
	null ds_topografia, 
	'N' ie_assoc_adep, 
	c.nr_sequencia nr_seq_horario, 
	c.dt_horario, 
	c.qt_dispensar_hor qt_pend, 
	c.cd_unidade_medida cd_um, 
	c.qt_dose, 
	c.cd_unidade_medida_dose, 
	b.ie_via_aplicacao ie_via, 
	--substr(obter_resp_atend_data_opcao(a.nr_atendimento,c.dt_horario,'C'),1,10) cd_pessoa_evento, 
	--substr(obter_resp_atend_data_opcao(a.nr_atendimento,c.dt_horario,'N'),1,60) nm_pessoa_evento 
	'' cd_pessoa_evento, 
	'' nm_pessoa_evento, 
	null ds_evento, 
	c.ie_aprazado 
from	prescr_mat_hor c, 
		prescr_material b, 
		prescr_medica a 
where	c.nr_seq_material = b.nr_sequencia 
and	c.nr_prescricao = b.nr_prescricao 
and	b.nr_prescricao = a.nr_prescricao 
and	c.dt_fim_horario is null 
and	c.dt_suspensao is null 
and	coalesce(c.ie_situacao,'A') = 'A' 
and	coalesce(c.ie_adep,'S') = 'S' 
--and	nvl(c.ie_horario_especial,'N') <> 'S' 
and	b.ie_agrupador = 1 
and	coalesce(a.ie_adep,'S') = 'S' 
and	Obter_se_horario_liberado(c.dt_lib_horario, c.dt_horario) = 'S' 

union all
 
select	--4 nr_seq_apresent, 
	--'P' ie_tipo_item, 
	--'Procedimento' ds_tipo_item, 
	--'Procedimentos' ds_tipo_item_plural, 
	CASE WHEN b.nr_seq_exame IS NULL THEN  4  ELSE 7 END  nr_seq_apresent, 
	CASE WHEN b.nr_seq_exame IS NULL THEN  'P'  ELSE 'L' END  ie_tipo_item, 
	CASE WHEN b.nr_seq_exame IS NULL THEN  'Procedimento'  ELSE 'Coleta' END  ds_tipo_item, 
	CASE WHEN b.nr_seq_exame IS NULL THEN  'Procedimentos'  ELSE 'Coletas' END  ds_tipo_item_plural, 
	CASE WHEN b.nr_seq_exame IS NULL THEN  'N'  ELSE 'S' END  ie_laboratorio, 
	a.nr_atendimento, 
	a.nr_prescricao, 
	a.cd_prescritor, 
	substr(obter_nome_pf(a.cd_prescritor),1,60) nm_prescritor, 
	a.dt_prescricao, 
	a.dt_inicio_prescr, 
	a.dt_validade_prescr, 
	a.dt_liberacao, 
	b.nr_sequencia nr_seq_item, 
	CASE WHEN coalesce(b.ie_acm,'N')='S' THEN  'S'  ELSE CASE WHEN coalesce(b.ie_se_necessario,'N')='S' THEN  'S'  ELSE 'N' END  END  ie_acm_sn, 
	'N' ie_di, 
	to_char(b.cd_procedimento) cd_item, 
	substr(obter_desc_prescr_proc(b.cd_procedimento, b.ie_origem_proced, b.nr_seq_proc_interno),1,240) ds_item, 
	b.cd_intervalo cd_intervalo, 
	null ds_diluente, 
	substr(obter_desc_topografia_dor(b.nr_seq_topografia),1,60) ds_topografia, 
	substr(obter_se_assoc_proc_adep(b.cd_procedimento,b.ie_origem_proced),1,1) ie_assoc_adep, 
	c.nr_sequencia nr_seq_horario, 
	c.dt_horario, 
	1 qt_pend, 
	'' cd_um, 
	1 qt_dose, 
	'' cd_unidade_medida_dose, 
	'' ie_via, 
	--substr(obter_resp_atend_data_opcao(a.nr_atendimento,c.dt_horario,'C'),1,10) cd_pessoa_evento, 
	--substr(obter_resp_atend_data_opcao(a.nr_atendimento,c.dt_horario,'N'),1,60) nm_pessoa_evento 
	'' cd_pessoa_evento, 
	'' nm_pessoa_evento, 
	null ds_evento, 
	c.ie_aprazado 
from	prescr_proc_hor c, 
	prescr_procedimento b, 
	prescr_medica a 
where	c.nr_seq_procedimento = b.nr_sequencia 
and	c.nr_prescricao = b.nr_prescricao 
and	b.nr_prescricao = a.nr_prescricao 
and	c.dt_fim_horario is null 
and	c.dt_suspensao is null 
and	coalesce(c.ie_situacao,'A') = 'A' 
--and	nvl(c.ie_horario_especial,'N') <> 'S' 
and	b.nr_seq_solic_sangue is null 
and	b.nr_seq_derivado is null 
and	b.nr_seq_prot_glic is null 
and	((b.nr_seq_proc_interno is null) or (obter_ctrl_glic_proc(b.nr_seq_proc_interno) = 'NC')) 
and	coalesce(a.ie_adep,'S') = 'S' 
and	Obter_se_horario_liberado(c.dt_lib_horario, c.dt_horario) = 'S' 

union all
 
select	5 nr_seq_apresent, 
	'R' ie_tipo_item, 
	'Recomendação' ds_tipo_item, 
	'Recomendações' ds_tipo_item_plural, 
	'N' ie_laboratorio, 
	a.nr_atendimento, 
	a.nr_prescricao, 
	a.cd_prescritor, 
	substr(obter_nome_pf(a.cd_prescritor),1,60) nm_prescritor, 
	a.dt_prescricao, 
	a.dt_inicio_prescr, 
	a.dt_validade_prescr, 
	a.dt_liberacao, 
	b.nr_sequencia nr_seq_item, 
	CASE WHEN padroniza_horario(b.ds_horarios)='' THEN  'S'  ELSE 'N' END  ie_acm_sn, 
	'N' ie_di, 
	to_char(b.cd_recomendacao) cd_item, 
	substr(obter_rec_prescricao(b.nr_sequencia, b.nr_prescricao),1,240) ds_item, 
	b.cd_intervalo cd_intervalo, 
	null ds_diluente, 
	null ds_topografia, 
	'N' ie_assoc_adep, 
	c.nr_sequencia nr_seq_horario, 
	c.dt_horario, 
	1 qt_pend, 
	'' cd_um, 
	1 qt_dose, 
	'' cd_unidade_medida_dose, 
	'' ie_via, 
	--substr(obter_resp_atend_data_opcao(a.nr_atendimento,c.dt_horario,'C'),1,10) cd_pessoa_evento, 
	--substr(obter_resp_atend_data_opcao(a.nr_atendimento,c.dt_horario,'N'),1,60) nm_pessoa_evento 
	'' cd_pessoa_evento, 
	'' nm_pessoa_evento, 
	null ds_evento, 
	c.ie_aprazado 
from	prescr_rec_hor c, 
	prescr_recomendacao b, 
	prescr_medica a 
where	c.nr_seq_recomendacao = b.nr_sequencia 
and	c.nr_prescricao = b.nr_prescricao 
and	b.nr_prescricao = a.nr_prescricao 
and	c.dt_fim_horario is null 
and	c.dt_suspensao is null 
and	coalesce(c.ie_situacao,'A') = 'A' 
--and	nvl(c.ie_horario_especial,'N') <> 'S' 
and	coalesce(a.ie_adep,'S') = 'S' 
and	Obter_se_horario_liberado(c.dt_lib_horario, c.dt_horario) = 'S' 

union all
 
select	6 nr_seq_apresent, 
	'E' ie_tipo_item, 
	'SAE' ds_tipo_item, 
	'SAE' ds_tipo_item_plural, 
	'N' ie_laboratorio, 
	a.nr_atendimento, 
	a.nr_sequencia, 
	a.cd_prescritor, 
	substr(obter_nome_pf(a.cd_prescritor),1,60) nm_prescritor, 
	a.dt_prescricao, 
	a.dt_inicio_prescr, 
	a.dt_validade_prescr, 
	a.dt_liberacao, 
	b.nr_sequencia nr_seq_item, 
	CASE WHEN coalesce(b.ie_se_necessario,'N')='S' THEN  'S'  ELSE CASE WHEN padroniza_horario(b.ds_horarios)='' THEN  'S'  ELSE 'N' END  END  ie_acm_sn, 
	'N' ie_di, 
	to_char(b.nr_seq_proc) cd_item, 
	substr(obter_desc_intervencoes(b.nr_seq_proc),1,240) ds_item, 
	b.cd_intervalo cd_intervalo, 
	null ds_diluente, 
	substr(obter_desc_topografia_dor(b.nr_seq_topografia),1,60) ds_topografia, 
	'S' ie_assoc_adep, 
	c.nr_sequencia nr_seq_horario, 
	c.dt_horario, 
	1 qt_pend, 
	'' cd_um, 
	1 qt_dose, 
	'' cd_unidade_medida_dose, 
	'' ie_via, 
	--substr(obter_resp_atend_data_opcao(a.nr_atendimento,c.dt_horario,'C'),1,10) cd_pessoa_evento, 
	--substr(obter_resp_atend_data_opcao(a.nr_atendimento,c.dt_horario,'N'),1,60) nm_pessoa_evento 
	'' cd_pessoa_evento, 
	'' nm_pessoa_evento, 
	null ds_evento, 
	c.ie_aprazado 
from	pe_prescr_proc_hor c, 
	pe_prescr_proc b, 
	pe_prescricao a 
where	c.nr_seq_pe_proc = b.nr_sequencia 
and	c.nr_seq_pe_prescr = b.nr_seq_prescr 
and	b.nr_seq_prescr = a.nr_sequencia 
and	c.dt_fim_horario is null 
and	c.dt_suspensao is null 
and	coalesce(c.ie_situacao,'A') = 'A' 
--and	nvl(c.ie
;

