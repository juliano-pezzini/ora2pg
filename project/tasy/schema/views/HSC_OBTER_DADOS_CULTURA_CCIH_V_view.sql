-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';

CREATE OR REPLACE VIEW hsc_obter_dados_cultura_ccih_v (nr_prescricao, nr_atendimento, cd_procedimento, ds_procedimento, ds_setor_atendimento, cd_exame, nm_exame, nr_seq_resultado, nr_sequencia, ds_resultado, cd_microorganismo, ds_microorganismo, qt_microorganismo, ds_material_exame, dt_resultado) AS select 	distinct
	p.nr_prescricao,
	p.nr_atendimento,
	r.cd_procedimento,
	substr(obter_desc_prescr_proc(r.cd_procedimento,r.ie_origem_proced, r.nr_seq_proc_interno),1,240) ds_procedimento,
	substr(obter_nome_setor(r.cd_setor_atendimento),1,60) ds_setor_atendimento,
	e.cd_exame,
	e.nm_exame,
	i.nr_seq_resultado,
	i.nr_sequencia,
	substr(Obter_Resultado_Exame_Ext(i.NR_SEQ_RESULTADO, i.NR_SEQUENCIA),1,255) ds_resultado,
	a.cd_microorganismo,
	substr(obter_cih_microorganismo(a.cd_microorganismo),1,255) ds_microorganismo,
	a.qt_microorganismo,
	substr(Obter_Desc_Material_Exame_Lab(r.cd_material_exame),1,255) ds_material_exame,
	l.dt_resultado
FROM prescr_procedimento r, prescr_medica p, exame_lab_resultado l, exame_laboratorio e, exame_lab_result_item i
LEFT OUTER JOIN exame_lab_result_antib a ON (i.nr_sequencia = a.nr_seq_result_item AND i.nr_seq_resultado = a.nr_seq_resultado)
WHERE r.nr_prescricao      	= p.nr_prescricao and i.nr_seq_prescr         = r.nr_sequencia and i.nr_seq_exame       	= e.nr_seq_exame and l.nr_prescricao      	= p.nr_prescricao and l.nr_seq_resultado   	= i.nr_seq_resultado   and p.dt_liberacao 		   is not null and p.ie_origem_inf 	      = '1' and e.ie_formato_resultado 	= 'SM';
