-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';

CREATE OR REPLACE VIEW adep_hem_v (nr_atendimento, nr_prescricao, cd_prescritor, nm_prescritor, dt_prescricao, dt_inicio_prescr, dt_validade_prescr, dt_liberacao, ie_tipo_solucao, nr_seq_solucao, ie_acm, ds_solucao, ie_via, ie_bi, ie_unidade_veloc, nr_etapas_suspensa, nr_etapas_adep, nr_etapas, qt_volume_original, qt_velocidade_original, qt_volume_suspenso, qt_volume_infundido, qt_volume_desprezado, qt_volume_pendente, qt_velocidade_atual, ie_status, ds_status, dt_status, nr_seq_evento, ie_evento, dt_evento, cd_pessoa_evento, nm_pessoa_evento, ie_evento_valido) AS select	a.nr_atendimento,
	a.nr_prescricao, 
	a.cd_prescritor, 
	substr(obter_nome_pf(a.cd_prescritor),1,60) nm_prescritor, 
	a.dt_prescricao, 
	a.dt_inicio_prescr, 
	a.dt_validade_prescr, 
	a.dt_liberacao, 
	c.ie_tipo_solucao ie_tipo_solucao, 
	b.nr_sequencia nr_seq_solucao, 
	b.ie_acm ie_acm, 
	substr(obter_desc_san_derivado(b.nr_seq_derivado),1,240) ds_solucao, 
	--substr(obter_componentes_solucao(b.nr_prescricao,b.nr_sequencia,'N'),1,2000) ds_componentes, 
	'IV' ie_via, 
	'N' ie_bi, 
	b.cd_unid_med_sangue ie_unidade_veloc, 
	--b.qt_tempo_aplicacao qt_tempo_solucao, 
	b.nr_etapas_suspensa, 
	obter_etapas_adep_sol(3,b.nr_prescricao,b.nr_sequencia) nr_etapas_adep, 
	b.qt_procedimento nr_etapas, 
	--b.qt_volume qt_volume_etapa, 
	--b.qt_hora_fase qt_tempo_etapa, 
	b.qt_vol_hemocomp qt_volume_original, 
	b.qt_veloc_inf_hemo qt_velocidade_original, 
	coalesce(b.qt_volume_suspenso,0) qt_volume_suspenso, 
	obter_dados_solucao(3,b.nr_prescricao,b.nr_sequencia,'VI') qt_volume_infundido, 
	obter_dados_solucao(3,b.nr_prescricao,b.nr_sequencia,'VD') qt_volume_desprezado, 
	obter_dados_solucao(3,b.nr_prescricao,b.nr_sequencia,'VR') qt_volume_pendente, 
	coalesce(obter_dados_solucao(3,b.nr_prescricao,b.nr_sequencia,'VA'),b.qt_veloc_inf_hemo) qt_velocidade_atual, 
	b.ie_status, 
	CASE WHEN b.ie_status='N' THEN 'Normal' WHEN b.ie_status='I' THEN 'Em andamento' WHEN b.ie_status='INT' THEN 'Interrompida' WHEN b.ie_status='T' THEN 'Encerrada' WHEN b.ie_status='V' THEN 'Vencida' END  ds_status, 
	b.dt_status, 
	c.nr_sequencia nr_seq_evento, 
	c.ie_alteracao ie_evento, 
	c.dt_alteracao dt_evento, 
	c.cd_pessoa_fisica cd_pessoa_evento, 
	substr(obter_nome_pf(c.cd_pessoa_fisica),1,60) nm_pessoa_evento, 
	c.ie_evento_valido 
FROM	prescr_solucao_evento c, 
	prescr_procedimento b, 
	prescr_medica a 
where	c.nr_seq_procedimento = b.nr_sequencia 
and	c.nr_prescricao = b.nr_prescricao 
and	b.nr_prescricao = a.nr_prescricao 
and	c.ie_tipo_solucao = 3 
and	b.nr_seq_solic_sangue is not null 
and	b.nr_seq_derivado is not null 
and	a.nr_atendimento is not null;

