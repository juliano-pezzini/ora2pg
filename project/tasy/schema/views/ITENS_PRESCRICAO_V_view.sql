-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';

CREATE OR REPLACE VIEW itens_prescricao_v (ds_tipo_item, ie_origem_inf, nr_sequencia, nr_agrupamento, nr_prescricao, ds_material, ie_via_aplicacao, cd_unidade_medida_dose, qt_dose, cd_intervalo, ds_observacao, ie_agrupador, nr_seq_gasoterapia, ds_horarios, hr_prim_horario, nr_seq_kit, nr_seq_aux, dt_suspensao, nm_usuario_susp, ie_urgencia) AS SELECT	obter_desc_expressao(293070) ds_tipo_item, --'Medicamento'
	50 ie_origem_inf,
	a.nr_sequencia,
	a.nr_agrupamento,
	a.nr_prescricao,
	SUBSTR(obter_descricao_mat_prescr(a.cd_material),1,80) ds_material,
	a.ie_via_aplicacao,
	a.cd_unidade_medida_dose,
	a.qt_dose,
	a.cd_intervalo,
	SUBSTR(a.ds_observacao, 1, 150) ds_observacao,
	a.ie_agrupador,
	0 NR_SEQ_GASOTERAPIA,
	a.ds_horarios,
	a.hr_prim_horario,
	a.nr_seq_kit,
	0 nr_seq_aux,
	dt_suspensao,
	nm_usuario_susp,
	NULL ie_urgencia
FROM	prescr_material a
WHERE	a.ie_agrupador = 1

UNION ALL

SELECT	obter_desc_expressao(292952) ds_tipo_item, --'Material'
	60 ie_origem_inf,
	a.nr_sequencia,
	a.nr_agrupamento,
	a.nr_prescricao,
	SUBSTR(obter_descricao_mat_prescr(a.cd_material),1,80) ds_material,
	a.ie_via_aplicacao,
	a.cd_unidade_medida_dose,
	a.qt_dose,
	a.cd_intervalo,
	SUBSTR(a.ds_observacao, 1, 150),
	a.ie_agrupador,
	0 NR_SEQ_GASOTERAPIA,
	a.ds_horarios,
	a.hr_prim_horario,
	a.nr_seq_kit,
	0 nr_seq_aux,
	dt_suspensao,
	nm_usuario_susp,
	NULL ie_urgencia
FROM	prescr_material a
WHERE	a.ie_agrupador = 2

UNION ALL

SELECT	obter_desc_expressao(493523) ds_tipo_item, --'Suporte nutricional'
	30 ie_origem_inf,
	a.nr_sequencia,
	a.nr_agrupamento,
	a.nr_prescricao,
	SUBSTR(obter_descricao_mat_prescr(a.cd_material),1,80) ds_material,
	a.ie_via_aplicacao,
	a.cd_unidade_medida_dose,
	a.qt_dose,
	a.cd_intervalo,
	SUBSTR(a.ds_observacao, 1, 150),
	a.ie_agrupador,
	0 NR_SEQ_GASOTERAPIA,
	a.ds_horarios,
	a.hr_prim_horario,
	a.nr_seq_kit,
	0 nr_seq_aux,
	dt_suspensao,
	nm_usuario_susp,
	NULL ie_urgencia
FROM	prescr_material a
WHERE	a.ie_agrupador = 8

UNION ALL

    SELECT	obter_desc_expressao(326182) ds_tipo_item, --'Proced/Exame'
	70 ie_origem_inf,
	a.nr_sequencia,
	a.nr_agrupamento,
	a.nr_prescricao,
	SUBSTR(coalesce(ds_rotina, obter_desc_prescr_proc(cd_procedimento,ie_origem_proced, nr_seq_proc_interno)),1,240) ds_material,
	NULL ie_via_aplicacao,
	NULL cd_unidade_medida_dose,
	a.qt_procedimento,
	a.cd_intervalo,
	SUBSTR(a.ds_observacao, 1, 150),
	NULL ie_agrupador,
	0 NR_SEQ_GASOTERAPIA,
	a.ds_horarios,
	NULL hr_prim_horario,
	NULL nr_seq_kit,
	0 nr_seq_aux,
	dt_suspensao,
	nm_usuario_susp,
	CASE WHEN a.ie_urgencia='S' THEN  obter_desc_expressao(327113, null)  ELSE obter_desc_expressao(327114, null) END  ie_urgencia
FROM	prescr_procedimento a
WHERE	a.nr_seq_origem IS NULL
AND	a.nr_seq_derivado IS NULL
AND	Obter_se_exibe_proced(a.nr_prescricao,a.nr_sequencia,a.ie_tipo_proced,'O') = 'S'

UNION ALL

SELECT	obter_desc_expressao(326182) ds_tipo_item, --'Proced/Exame'
	72 ie_origem_inf,
	a.nr_sequencia,
	a.nr_agrupamento,
	a.nr_prescricao,
	SUBSTR(obter_desc_prescr_proc(cd_procedimento,ie_origem_proced, nr_seq_proc_interno),1,240) ds_material,
	NULL ie_via_aplicacao,
	NULL cd_unidade_medida_dose,
	a.qt_procedimento,
	a.cd_intervalo,
	SUBSTR(a.ds_observacao, 1, 150),
	NULL ie_agrupador,
	0 NR_SEQ_GASOTERAPIA,
	a.ds_horarios,
	NULL hr_prim_horario,
	NULL nr_seq_kit,
	0 nr_seq_aux,
	dt_suspensao,
	nm_usuario_susp,
	CASE WHEN a.ie_urgencia='S' THEN  obter_desc_expressao(327113, null)  ELSE obter_desc_expressao(327114, null) END  ie_urgencia
FROM	prescr_procedimento a
WHERE	a.nr_seq_origem IS NULL
AND	a.nr_seq_derivado IS NULL
AND	Obter_se_exibe_proced(a.nr_prescricao,a.nr_sequencia,a.ie_tipo_proced,'AP') = 'S'

UNION ALL

SELECT	obter_desc_expressao(290567) ds_tipo_item, --'Gasoterapia'
	100 ie_origem_inf,
	a.nr_sequencia,
	a.nr_sequencia nr_agrupamento,
	a.nr_prescricao,
	SUBSTR(obter_descricao_padrao('GAS', 'DS_GAS', nr_seq_gas),1,254) ds_material,
	NULL ie_via_aplicacao,
	ie_unidade_medida cd_unidade_medida_dose,
	a.qt_gasoterapia,
	a.cd_intervalo cd_intervalo,
	SUBSTR(a.ds_observacao, 1, 150),
	NULL ie_agrupador,
	a.nr_sequencia,
	NULL ds_horarios,
	NULL hr_prim_horario,
	NULL nr_seq_kit,
	0 nr_seq_aux,
	dt_suspensao,
	NULL nm_usuario_susp,
	NULL ie_urgencia
FROM	prescr_gasoterapia a

UNION ALL

SELECT	obter_desc_expressao(287913) ds_tipo_item, --'Dieta oral'
	10 ie_origem_inf,
	a.nr_sequencia,
	a.nr_prescricao nr_agrupamento,
	a.nr_prescricao,
	SUBSTR(obter_nome_dieta(CD_DIETA),1,80) ds_material,
	NULL ie_via_aplicacao,
	NULL cd_unidade_medida_dose,
	NULL qt_dose,
	a.cd_intervalo,
	SUBSTR(a.ds_observacao, 1, 150),
	NULL ie_agrupador,
	0 NR_SEQ_GASOTERAPIA,
	a.ds_horarios,
	NULL hr_prim_horario,
	NULL nr_seq_kit,
	0 nr_seq_aux,
	dt_suspensao,
	nm_usuario_susp,
	NULL ie_urgencia
FROM	prescr_dieta a

UNION ALL

SELECT	obter_desc_expressao(304828) ds_tipo_item, --'Jejum'
	290 ie_origem_inf,
	a.nr_sequencia,
	a.nr_prescricao nr_agrupamento,
	a.nr_prescricao,
	substr(obter_desc_tipo_jejum(nr_seq_tipo),1,80) ds_material,
	null ie_via_aplicacao,
	null cd_unidade_medida_dose,
	null qt_dose,
	null cd_intervalo,
	substr(a.ds_observacao, 1, 150),
	null ie_agrupador,
	0 nr_seq_gasoterapia,
	NULL ds_horarios,
	to_char(a.dt_inicio, 'hh:mi') hr_prim_horario,
	null nr_seq_kit,
	null nr_seq_aux,
	null dt_suspensao,
	null nm_usuario_susp,
	NULL ie_urgencia
FROM	rep_jejum a

UNION ALL

SELECT	obter_desc_expressao(314221) ds_tipo_item, --'Suplemen/Modul/Pediat'
	20 ie_origem_inf,
	a.nr_sequencia,
	a.nr_agrupamento,
	a.nr_prescricao,
	SUBSTR(obter_descricao_mat_prescr(a.cd_material),1,80) ds_material,
	a.ie_via_aplicacao,
	a.cd_unidade_medida_dose,
	a.qt_dose,
	a.cd_intervalo,
	SUBSTR(a.ds_observacao, 1, 150) ds_observacao,
	a.ie_agrupador,
	0 NR_SEQ_GASOTERAPIA,
	a.ds_horarios,
	a.hr_prim_horario,
	a.nr_seq_kit,
	0 nr_seq_aux,
	dt_suspensao,
	nm_usuario_susp,
	NULL ie_urgencia
FROM	prescr_material a
WHERE	a.ie_agrupador = 12

UNION ALL

SELECT	obter_desc_expressao(298694) ds_tipo_item, --'Solucoes'
	40 ie_origem_inf,
	a.nr_seq_solucao,
	a.nr_agrupamento,
	a.nr_prescricao,
	SUBSTR(coalesce(obter_desc_solucao_rep(a.nr_prescricao, a.nr_seq_solucao),obter_desc_expressao(787677)),1,80) ds_material, --'Sem titulo'
	a.ie_via_aplicacao,
	a.ie_tipo_dosagem cd_unidade_medida_dose,
	a.qt_solucao_total qt_dose,
	NULL cd_intervalo,
	SUBSTR(a.ds_orientacao, 1, 150) ds_observacao,
	NULL ie_agrupador,
	0 NR_SEQ_GASOTERAPIA,
	a.ds_horarios,
	a.hr_prim_horario,
	NULL nr_seq_kit,
	0 nr_seq_aux,
	dt_suspensao,
	nm_usuario_susp,
	NULL ie_urgencia
FROM	prescr_solucao a
WHERE	coalesce(a.ie_hemodialise,'N') = 'N'

UNION ALL

SELECT	obter_desc_expressao(298683) ds_tipo_item, --'Solucao'
	45 ie_origem_inf,
	a.nr_sequencia_solucao,
	a.nr_agrupamento,
	a.nr_prescricao,
	SUBSTR(obter_descricao_mat_prescr(a.cd_material),1,80) ds_material,
	a.ie_via_aplicacao,
	a.cd_unidade_medida_dose,
	a.qt_dose,
	a.cd_intervalo,
	SUBSTR(a.ds_observacao, 1, 150) ds_observacao,
	a.ie_agrupador,
	0 NR_SEQ_GASOTERAPIA,
	a.ds_horarios,
	a.hr_prim_horario,
	a.nr_seq_kit,
	0 nr_seq_aux,
	dt_suspensao,
	nm_usuario_susp,
	NULL ie_urgencia
FROM	prescr_material a
WHERE	a.ie_agrupador = 4

UNION ALL

SELECT	obter_desc_expressao(297341) ds_tipo_item, --'Recomendacao'
	130 ie_origem_inf,
	a.nr_sequencia,
	a.nr_sequencia nr_agrupamento,
	a.nr_prescricao,
	SUBSTR(CASE WHEN a.cd_recomendacao IS NULL THEN  a.ds_recomendacao  ELSE Obter_Rec_Prescricao(a.nr_sequencia, a.nr_prescricao) END ,1,80) ds_material,
	NULL ie_via_aplicacao,
	NULL ie_tipo_dosagem,
	1,
	a.cd_intervalo,
	SUBSTR(a.ds_recomendacao, 1, 150),
	NULL ie_agrupador,
	0 NR_SEQ_GASOTERAPIA,
	a.ds_horarios,
	a.hr_prim_horario,
	NULL nr_seq_kit,
	0 nr_seq_aux,
	dt_suspensao,
	nm_usuario_susp,
	NULL ie_urgencia
FROM	prescr_recomendacao a

UNION ALL

SELECT	obter_desc_expressao(317084) ds_tipo_item, --'Mat/Med Associados'
	80	ie_origem_inf,
	a.nr_sequencia,
	a.nr_agrupamento,
	a.nr_prescricao,
	SUBSTR(obter_descricao_mat_prescr(a.cd_material),1,80) ds_material,
	a.ie_via_aplicacao,
	a.cd_unidade_medida_dose,
	a.qt_dose,
	a.cd_intervalo,
	SUBSTR(a.ds_observacao, 1, 150) ds_observacao,
	a.ie_agrupador,
	0 NR_SEQ_GASOTERAPIA,
	a.ds_horarios,
	a.hr_prim_horario,
	a.nr_seq_kit,
	0 nr_seq_aux,
	dt_suspensao,
	nm_usuario_susp,
	NULL ie_urgencia
FROM	prescr_material a
WHERE	a.ie_agrupador = 5

UNION ALL

SELECT 	obter_desc_expressao(699150)  ds_tipo_item, --Oxigenoterapia
	90 ie_origem_inf,
	a.nr_sequencia,
	a.nr_agrupamento,
	a.nr_prescricao,
	SUBSTR(Obter_Desc_Prescr_Proc(a.cd_procedimento,a.ie_origem_proced, a.nr_seq_proc_interno),1,240) ds_material,
	NULL ie_via_aplicacao,
	'H' cd_unidade_medida_dose,
	a.qt_procedimento,
	NULL cd_intervalo,
	SUBSTR(a.ds_observacao, 1, 150) ds_observacao,
	NULL ie_agrupador,
	0 NR_SEQ_GASOTERAPIA,
	a.ds_horarios,
	NULL hr_prim_horario,
	NULL nr_seq_kit,
	0 nr_seq_aux,
	dt_suspensao,
	nm_usuario_susp,
	NULL ie_urgencia
FROM	PRESCR_PROCEDIMENTO a
WHERE	Obter_se_exibe_proced(a.nr_prescricao,a.nr_sequencia,a.ie_tipo_proced, 'G') = 'S'

UNION ALL

SELECT 	obter_desc_expressao(291246) ds_tipo_item, --'Hemoderivados'
	120	 ie_origem_inf,
	a.nr_sequencia,
	a.nr_agrupamento,
	a.nr_prescricao,
	SUBSTR(Obter_desc_san_derivado(NR_SEQ_DERIVADO),1,80) ds_material,
	ie_via_aplicacao,
	NULL cd_unidade_medida_dose,
	a.qt_procedimento,
	a.cd_intervalo,
	SUBSTR(a.ds_observacao, 1, 150) ds_observacao,
	NULL ie_agrupador,
	0 NR_SEQ_GASOTERAPIA,
	a.ds_horarios,
	NULL hr_prim_horario,
	NULL nr_seq_kit,
	0 nr_seq_aux,
	dt_suspensao,
	nm_usuario_susp,
	NULL ie_urgencia
FROM	prescr_procedimento a
WHERE	Obter_se_exibe_proced(a.nr_prescricao,a.nr_sequencia,a.ie_tipo_proced,'BSHE') = 'S'
AND	nr_seq_derivado IS NOT NULL

UNION ALL

SELECT	obter_desc_expressao(631406) ds_tipo_item, --'Mat/Med Associados - Gasoterapia'
	110	 ie_origem_inf,
	a.nr_sequencia,
	a.nr_agrupamento,
	a.nr_prescricao,
	SUBSTR(obter_descricao_mat_prescr(a.cd_material),1,80) ds_material,
	a.ie_via_aplicacao,
	a.cd_unidade_medida_dose,
	a.qt_dose,
	a.cd_intervalo,
	SUBSTR(a.ds_observacao, 1, 150) ds_observacao,
	a.ie_agrupador,
	a.NR_SEQ_GASOTERAPIA,
	a.ds_horarios,
	a.hr_prim_horario,
	a.nr_seq_kit,
	0 nr_seq_aux,
	dt_suspensao,
	nm_usuario_susp,
	NULL ie_urgencia
FROM	prescr_material a
WHERE	a.ie_agrupador = 15

UNION ALL

SELECT	obter_desc_expressao(315230) ds_tipo_item, --'NPT Adulta Protocolo'
	31	 ie_origem_inf,
	a.nr_sequencia,
	a.nr_sequencia nr_agrupamento,
	a.nr_prescricao,
	SUBSTR(CASE WHEN a.ie_forma='P' THEN  obter_desc_expressao(296585) || ' ' || b.ds_npt  ELSE obter_valor_dominio(1988,a.ie_forma) END ,1,80) ds_material, --Protocolo
	a.ie_via_administracao ie_via_aplicacao,
	NULL cd_unidade_medida_dose,
	NULL qt_dose,
	b.cd_intervalo,
	NULL ds_observacao,
	NULL ie_agrupador,
	0 NR_SEQ_GASOTERAPIA,
	NULL ds_horarios,
	a.hr_prim_horario hr_prim_horario,
	NULL nr_seq_kit,
	0 nr_seq_aux,
	a.dt_suspensao,
	a.nm_usuario_susp,
	NULL ie_urgencia
FROM nut_pac a
LEFT OUTER JOIN protocolo_npt b ON (a.nr_seq_protocolo = b.nr_sequencia)
WHERE a.ie_npt_adulta = 'S'
UNION ALL

SELECT	obter_desc_expressao(607186) ds_tipo_item, --'NPT Adulta'
	260	 ie_origem_inf,
	a.nr_sequencia,
	a.nr_sequencia nr_agrupamento,
	a.nr_prescricao,
	substr(obter_desc_expressao(607186),1,80) ds_material,
	NULL ie_via_aplicacao,
	NULL cd_unidade_medida_dose,
	NULL qt_dose,
	NULL cd_intervalo,
	NULL ds_observacao,
	NULL ie_agrupador,
	0 NR_SEQ_GASOTERAPIA,
	NULL ds_horarios,
	a.hr_prim_horario hr_prim_horario,
	NULL nr_seq_kit,
	0 nr_seq_aux,
	dt_suspensao,
	nm_usuario_susp,
	NULL ie_urgencia
FROM	nut_paciente a
WHERE	a.ie_npt_adulta = 'S'

UNION ALL

SELECT	obter_desc_expressao(305334) ds_tipo_item, --'NPT Neonatal'
	270	 ie_origem_inf,
	a.nr_sequencia,
	a.nr_sequencia nr_agrupamento,
	a.nr_prescricao,
	substr(obter_desc_expressao(305334),1,80) ds_material,
	NULL ie_via_aplicacao,
	NULL cd_unidade_medida_dose,
	NULL qt_dose,
	NULL cd_intervalo,
	NULL ds_observacao,
	NULL ie_agrupador,
	0 NR_SEQ_GASOTERAPIA,
	NULL ds_horarios,
	a.hr_prim_horario hr_prim_horario,
	NULL nr_seq_kit,
	0 nr_seq_aux,
	dt_suspensao,
	nm_usuario_susp,
	NULL ie_urgencia
FROM	nut_pac a
WHERE	a.ie_npt_adulta = 'N'

UNION ALL

SELECT	obter_desc_expressao(305336) ds_tipo_item, --'NPT Pediatrica'
	280	 ie_origem_inf,
	a.nr_sequencia,
	a.nr_sequencia nr_agrupamento,
	a.nr_prescricao,
	substr(obter_desc_expressao(305336),1,80) ds_material, 
	NULL ie_via_aplicacao,
	NULL cd_unidade_medida_dose,
	NULL qt_dose,
	NULL cd_intervalo,
	NULL ds_observacao,
	NULL ie_agrupador,
	0 NR_SEQ_GASOTERAPIA,
	NULL ds_horarios,
	a.hr_prim_horario hr_prim_horario,
	NULL nr_seq_kit,
	0 nr_seq_aux,
	dt_suspensao,
	nm_usuario_susp,
	NULL ie_urgencia
FROM	nut_pac a
WHERE	a.ie_npt_adulta = 'P'

UNION ALL

SELECT obter_desc_expressao(314495) ds_tipo_item, --'Cadeira de rodas' 
	150	 ie_origem_inf,
	a.nr_sequencia,
	NULL nr_agrupamento,
	a.nr_prescricao,
	substr(obter_desc_expressao(314495),1,80) ds_material,
	NULL ie_via_aplicacao,
	NULL cd_unidade_medida_dose,
	NULL qt_dose,
	NULL cd_intervalo,
	SUBSTR(a.ds_observacao, 1, 150) ds_observacao,
	NULL ie_agrupador,
	0 NR_SEQ_GASOTERAPIA,
	NULL ds_horarios,
	NULL hr_prim_horario,
	NULL nr_seq_kit,
	0 nr_seq_aux,
	dt_suspensao,
	NULL nm_usuario_susp,
	NULL ie_urgencia
FROM 	PRESCR_OPME a

UNION ALL

SELECT obter_desc_expressao(314495) ds_tipo_item, --'Protese membros superiores'
	160	 ie_origem_inf,
	a.nr_sequencia,
	NULL nr_agrupamento,
	a.nr_prescricao,
	substr(obter_desc_expressao(314495),1,80) ds_material,
	NULL ie_via_aplicacao,
	NULL cd_unidade_medida_dose,
	NULL qt_dose,
	NULL cd_intervalo,
	SUBSTR(a.ds_observacao, 1, 150) ds_observacao,
	NULL ie_agrupador,
	0 NR_SEQ_GASOTERAPIA,
	NULL ds_horarios,
	NULL hr_prim_horario,
	NULL nr_seq_kit,
	0 nr_seq_aux,
	NULL dt_suspensao,
	NULL nm_usuario_susp,
	NULL ie_urgencia
FROM 	PRESCR_PROTESE_MS a

UNION ALL

SELECT obter_desc_expressao(314494) ds_tipo_item, --'Protese membros inferiores'
	170	 ie_origem_inf,
	a.nr_sequencia,
	NULL nr_agrupamento,
	a.nr_prescricao,
	substr(obter_desc_expressao(314494),1,80) ds_material,
	NULL ie_via_aplicacao,
	NULL cd_unidade_medida_dose,
	NULL qt_dose,
	NULL cd_intervalo,
	SUBSTR(a.ds_observacao, 1, 150) ds_observacao,
	NULL ie_agrupador,
	0 NR_SEQ_GASOTERAPIA,
	NULL ds_horarios,
	NULL hr_prim_horario,
	NULL nr_seq_kit,
	0 nr_seq_aux,
	dt_suspensao,
	NULL nm_usuario_susp,
	NULL ie_urgencia
FROM 	PRESCR_PROTESE_MI a

UNION ALL

SELECT obter_desc_expressao(314497) ds_tipo_item, --'Ortese para membros superiores'
	180	 ie_origem_inf,
	a.nr_sequencia,
	NULL nr_agrupamento,
	a.nr_prescricao,
    substr(obter_desc_expressao(314497),1,80) ds_material,
	NULL ie_via_aplicacao,
	NULL cd_unidade_medida_dose,
	NULL qt_dose,
	NULL cd_intervalo,
	SUBSTR(a.ds_observacao, 1, 150) ds_observacao,
	NULL ie_agrupador,
	0 NR_SEQ_GASOTERAPIA,
	NULL ds_horarios,
	NULL hr_prim_horario,
	NULL nr_seq_kit,
	0 nr_seq_aux,
	dt_suspensao,
	NULL nm_usuario_susp,
	NULL ie_urgencia
FROM 	PRESCR_ORTESE_MS a

UNION ALL

SELECT obter_desc_expressao(314498) ds_tipo_item, -- 'Ortese para membros inferiores'
	190	 ie_origem_inf,
	a.nr_sequencia,
	NULL nr_agrupamento,
	a.nr_prescricao,
	substr(obter_desc_expressao(314498),1,80) ds_material,
	NULL ie_via_aplicacao,
	NULL cd_unidade_medida_dose,
	NULL qt_dose,
	NULL cd_intervalo,
	SUBSTR(a.ds_observacao, 1, 150) ds_observacao,
	NULL ie_agrupador,
	0 NR_SEQ_GASOTERAPIA,
	NULL ds_horarios,
	NULL hr_prim_horario,
	NULL nr_seq_kit,
	0 nr_seq_aux,
	dt_suspensao,
	NULL nm_usuario_susp,
	NULL ie_urgencia
FROM 	PRESCR_ORTESE_MI a

UNION ALL

SELECT obter_desc_expressao(314499) ds_tipo_item, --'Meios auxiliares de locomocao'
	200	 ie_origem_inf,
	a.nr_sequencia,
	NULL nr_agrupamento,
	a.nr_prescricao,
	substr(obter_desc_expressao(314499),1,80) ds_material,
	NULL ie_via_aplicacao,
	NULL cd_unidade_medida_dose,
	NULL qt_dose,
	NULL cd_intervalo,
	SUBSTR(a.ds_observacao, 1, 150) ds_observacao,
	NULL ie_agrupador,
	0 NR_SEQ_GASOTERAPIA,
	NULL ds_horarios,
	NULL hr_prim_horario,
	NULL nr_seq_kit,
	0 nr_seq_aux,
	dt_suspensao,
	NULL nm_usuario_susp,
	NULL ie_urgencia
FROM 	PRESCR_MEIO_LOCOMOCAO a

UNION ALL

SELECT obter_desc_expressao(886863) ds_tipo_item, --'Complemento' 
	210  ie_origem_inf,
	a.nr_sequencia,
	NULL nr_agrupamento,
	a.nr_prescricao,
	substr(obter_desc_expressao(886863),1,80) ds_material,
	NULL ie_via_aplicacao,
	NULL cd_unidade_medida_dose,
	NULL qt_dose,
	NULL cd_intervalo,
	SUBSTR(a.ds_observacao, 1, 150) ds_observacao,
	NULL ie_agrupador,
	0 NR_SEQ_GASOTERAPIA,
	NULL ds_horarios,
	NULL hr_prim_horario,
	NULL nr_seq_kit,
	0 nr_seq_aux,
	NULL dt_suspensao,
	NULL nm_usuario_susp,
	NULL ie_urgencia
FROM 	PRESCR_COMPL_OPM a

UNION ALL

SELECT obter_desc_expressao(496081) ds_tipo_item, -- 'Ortese de coluna'
	220  ie_origem_inf,
	a.nr_sequencia,
	NULL nr_agrupamento,
	a.nr_prescricao,
	substr(obter_desc_expressao(496081),1,80) ds_material,
	NULL ie_via_aplicacao,
	NULL cd_unidade_medida_dose,
	NULL qt_dose,
	NULL cd_intervalo,
	SUBSTR(a.ds_observacao, 1, 150) ds_observacao,
	NULL ie_agrupador,
	0 NR_SEQ_GASOTERAPIA,
	NULL ds_horarios,
	NULL hr_prim_horario,
	NULL nr_seq_kit,
	0 nr_seq_aux,
	dt_suspensao,
	NULL nm_usuario_susp,
	NULL ie_urgencia
FROM 	PRESCR_ORTESE_COLUNA a

UNION ALL

SELECT  obter_desc_expressao(294823) ds_tipo_item, -- 'OPM'
	230  ie_origem_inf,
	a.nr_sequencia,
	NULL nr_agrupamento,
	a.nr_prescricao,
	substr( obter_desc_expressao(294823) || ' - ' || obter_valor_dominio(4301,IE_TIPO),1,255) ds_material,
	NULL ie_via_aplicacao,
	NULL cd_unidade_medida_dose,
	NULL qt_dose,
	NULL cd_intervalo,
	SUBSTR(a.ds_observacao, 1, 150) ds_observacao,
	NULL ie_agrupador,
	0 NR_SEQ_GASOTERAPIA,
	NULL ds_horarios,
	NULL hr_prim_horario,
	NULL nr_seq_kit,
	0 nr_seq_aux,
	NULL dt_suspensao,
	NULL nm_usuario_susp,
	NULL ie_urgencia
FROM 	PRESCR_OPM a

UNION ALL

SELECT  obter_desc_expressao(770401) ds_tipo_item, --'Leites e derivados (Dispositivo)'
	240  ie_origem_inf,
	a.nr_sequencia,
	NULL nr_agrupamento,
	a.nr_prescricao,
	substr(Obter_desc_disp_succao(nr_seq_disp_succao),1,255) ds_material,
	a.ie_via_aplicacao,
	NULL cd_unidade_medida_dose,
	a.qt_volume_total qt_dose,
	a.cd_intervalo,
	NULL ds_observacao,
	NULL ie_agrupador,
	0 nr_seq_gasoterapia,
	a.ds_horarios,
	a.hr_prim_horario,
	NULL nr_seq_kit,
	0 nr_seq_aux,
	NULL dt_suspensao,
	NULL nm_usuario_susp,
	NULL ie_urgencia
FROM 	prescr_leite_deriv a

union all

SELECT	obter_desc_expressao(770411) ds_tipo_item, --'Leites e derivados (Produtos)'
	250	 ie_origem_inf,
	a.nr_sequencia,
	a.nr_agrupamento,
	a.nr_prescricao,
	SUBSTR(obter_descricao_mat_prescr(a.cd_material),1,80) ds_material,
	a.ie_via_aplicacao,
	a.cd_unidade_medida_dose,
	a.qt_dose,
	a.cd_intervalo,
	SUBSTR(a.ds_observacao, 1, 150) ds_observacao,
	a.ie_agrupador,
	0 NR_SEQ_GASOTERAPIA,
	a.ds_horarios,
	a.hr_prim_horario,
	a.nr_seq_kit,
	a.nr_seq_leite_deriv,
	dt_suspensao,
	nm_usuario_susp,
	NULL ie_urgencia
FROM	prescr_material a
WHERE	a.ie_agrupador in (16,17)

UNION ALL

SELECT	obter_desc_expressao(291247) ds_tipo_item, -- 'Hemodialise'
		300  ie_origem_inf,
		a.nr_sequencia,
		NULL nr_agrupamento,
		a.nr_prescricao,
		substr(obter_desc_expressao(291247),1,255) ds_material,
		NULL ie_via_aplicacao,
		NULL cd_unidade_medida_dose,
		NULL qt_dose,
		NULL cd_intervalo,
		SUBSTR(a.ds_observacao, 1, 150) ds_observacao,
		NULL ie_agrupador,
		0 NR_SEQ_GASOTERAPIA,
		NULL ds_horarios,
		NULL hr_prim_horario,
		NULL nr_seq_kit,
		0 nr_seq_aux,
		NULL dt_suspensao,
		NULL nm_usuario_susp,
		NULL ie_urgencia
FROM	hd_prescricao a
where 	coalesce(ie_tipo_dialise,'N') = 'H'

UNION ALL

SELECT	obter_desc_expressao(682928) ds_tipo_item,
		305  ie_origem_inf,
		a.nr_seq_solucao,
		a.nr_agrupamento,
		a.nr_prescricao,
		substr(SUBSTR(coalesce(obter_desc_solucao_rep(a.nr_prescricao, a.nr_seq_solucao),obter_desc_expressao(331616)),1,70)||' '||obter_desc_expressao(291247),1,255)  ds_material,
		a.ie_via_aplicacao,
		a.ie_tipo_dosagem cd_unidade_medida_dose,
		a.qt_solucao_total qt_dose,
		NULL cd_intervalo,
		SUBSTR(a.ds_orientacao, 1, 150) ds_observacao,
		NULL ie_agrupador,
		0 NR_SEQ_GASOTERAPIA,
		a.ds_horarios,
		a.hr_prim_horario,
		NULL nr_seq_kit,
		0 nr_seq_aux,
		dt_suspensao,
		nm_usuario_susp,
		NULL ie_urgencia
FROM	prescr_solucao a
where	coalesce(ie_hemodialise,'N') = 'S'

UNION ALL

select	obter_desc_expressao(682928) ds_tipo_item,
		310 ie_origem_inf,
		a.nr_sequencia,
		a.nr_agrupamento,
		a.nr_prescricao,
		substr(substr(obter_desc_material(a.cd_material),1,70)||' '||obter_desc_expressao(291247),1,255) ds_material,
		a.ie_via_aplicacao,
		a.cd_unidade_medida_dose cd_unidade_medida_dose,
		a.qt_dose qt_dose,
		null cd_intervalo,
		substr(a.ds_observacao, 1, 150) ds_observacao,
		null ie_agrupador,
		0 nr_seq_gasoterapia,
		a.ds_horarios,
		a.hr_prim_horario,
		null nr_seq_kit,
		0 nr_seq_aux,
		dt_suspensao,
		nm_usuario_susp,
		NULL ie_urgencia
from	prescr_material a
where	ie_agrupador = 13
and	exists (select 	1
			from 	prescr_solucao b
			where 	b.nr_seq_solucao = a.nr_sequencia_solucao
			and		b.nr_prescricao = a.nr_prescricao
			and		coalesce(b.ie_hemodialise,'N') = 'S')

UNION ALL

SELECT	obter_desc_expressao(314156) ds_tipo_item, -- 'Dialise peritoneal'
		320  ie_origem_inf,
		a.nr_sequencia,
		NULL nr_agrupamento,
		a.nr_prescricao,
		substr(obter_desc_expressao(314156),1,255) ds_material,
		NULL ie_via_aplicacao,
		NULL cd_unidade_medida_dose,
		NULL qt_dose,
		NULL cd_intervalo,
		SUBSTR(a.ds_observacao, 1, 150) ds_observacao,
		NULL ie_agrupador,
		0 NR_SEQ_GASOTERAPIA,
		NULL ds_horarios,
		to_char(dt_inicio_dialise,'hh24:mi') hr_prim_horario,
		NULL nr_seq_kit,
		0 nr_seq_aux,
		NULL dt_suspensao,
		NULL nm_usuario_susp,
		NULL ie_urgencia
FROM	hd_prescricao a
where 	coalesce(ie_tipo_dialise,'N') = 'P'

UNION ALL

SELECT	obter_desc_expressao(682930) ds_tipo_item,
		325  ie_origem_inf,
		a.nr_seq_solucao,
		a.nr_agrupamento,
		a.nr_prescricao,
		substr(SUBSTR(coalesce(obter_desc_solucao_rep(a.nr_prescricao, a.nr_seq_solucao),obter_desc_expressao(331616)),1,70)||' '||obter_desc_expressao(295526),1,255) ds_material,
		a.ie_via_aplicacao,
		a.ie_tipo_dosagem cd_unidade_medida_dose,
		a.qt_solucao_total qt_dose,
		NULL cd_intervalo,
		SUBSTR(a.ds_orientacao, 1, 150) ds_observacao,
		NULL ie_agrupador,
		0 NR_SEQ_GASOTERAPIA,
		a.ds_horarios,
		a.hr_prim_horario,
		NULL nr_seq_kit,
		0 nr_seq_aux,
		dt_suspensao,
		nm_usuario_susp,
		NULL ie_urgencia
FROM	prescr_solucao a
where	coalesce(ie_hemodialise,'N') = 'P'

UNION ALL

select	obter_desc_expressao(682930) ds_tipo_item,
		330 ie_origem_inf,
		a.nr_sequencia,
		a.nr_agrupamento,
		a.nr_prescricao,
		substr(substr(obter_desc_material(a.cd_material),1,70)||' '||obter_desc_expressao(295526),1,255) ds_material,
		a.ie_via_aplicacao,
		a.cd_unidade_medida_dose cd_unidade_medida_dose,
		a.qt_dose qt_dose,
		null cd_intervalo,
		substr(a.ds_observacao, 1, 150) ds_observacao,
		null ie_agrupador,
		0 nr_seq_gasoterapia,
		a.ds_horarios,
		a.hr_prim_horario,
		null nr_seq_kit,
		0 nr_seq_aux,
		dt_suspensao,
		nm_usuario_susp,
		NULL ie_urgencia
from	prescr_material a
where	ie_agrupador = 13
and	exists (select 	1
			from 	prescr_solucao b
			where 	b.nr_seq_solucao = a.nr_sequencia_solucao
			and		b.nr_prescricao = a.nr_prescricao
			and		coalesce(b.ie_hemodialise,'N') = 'P');

