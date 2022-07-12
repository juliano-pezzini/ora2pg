-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';

CREATE OR REPLACE VIEW materiais_dispensados_v (cd_estabelecimento, ds_estabelecimento, cd_material, ds_material, cd_medico, nm_medico, qt_total_dispensar, qt_material, dt_prescricao, horario_dispensado, qt_dias_prescr_disp) AS select distinct
	c.cd_estabelecimento, 
	UPPER(trim(both substr(obter_nome_estabelecimento(c.cd_estabelecimento),1,200))) ds_estabelecimento, 
	x.cd_material, 
	UPPER(trim(both x.ds_material)) ds_material, 
	a.cd_medico, 
	UPPER(trim(both p.nm_pessoa_fisica)) nm_medico, 
	d.qt_total_dispensar, 
	d.qt_material, 
 a.dt_prescricao, 
 h.dt_horario horario_dispensado, 
 (trunc(coalesce(h.dt_horario, LOCALTIMESTAMP)) - trunc(coalesce(a.dt_prescricao,h.dt_horario))) qt_dias_prescr_disp 
FROM  prescr_medica a, 
    atendimento_paciente c, 
    prescr_material d, 
    material x, 
    pessoa_fisica p, 
    prescr_mat_hor h 
where a.nr_atendimento = c.nr_atendimento 
	and a.nr_prescricao = d.nr_prescricao 
	and d.cd_material = x.cd_material 
 and a.cd_medico = p.cd_pessoa_fisica 
 and h.nr_prescricao = d.nr_prescricao 
	and h.nr_seq_material = d.nr_seq_material;
