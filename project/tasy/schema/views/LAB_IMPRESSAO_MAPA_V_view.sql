-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';

CREATE OR REPLACE VIEW lab_impressao_mapa_v (ie_tipo_atendimento, nr_seq_grupo_imp, qtdade_exames, cd_estabelecimento, ie_urgencia) AS SELECT	  	distinct p.ie_tipo_atendimento,
		a.nr_seq_grup_imp NR_SEQ_GRUPO_IMP, 
		COUNT(distinct a.nr_prescricao) QTDADE_EXAMES, 
		coalesce(a.cd_estabelecimento,lab_obter_cd_estab_setor(r.cd_setor_atendimento)) cd_estabelecimento, 
		CASE WHEN coalesce((Obter_Valor_Param_Usuario(10209, 7, obter_perfil_ativo, wheb_usuario_pck.get_nm_usuario, coalesce(wheb_usuario_pck.get_cd_estabelecimento, 1)))::numeric  ,0)=p.ie_tipo_atendimento THEN r.ie_urgencia  ELSE 'N' END 	ie_urgencia 
FROM	  	lab_impressao_mapa a, prescr_medica m, atendimento_paciente p, prescr_procedimento r 
WHERE	  	p.nr_atendimento = m.nr_atendimento 
AND		a.nr_prescricao = m.nr_prescricao 
AND 	a.nr_prescricao = r.nr_prescricao 
and 	a.nr_seq_prescr = r.nr_sequencia 
AND		a.ie_status = 10 
GROUP BY  	p.ie_tipo_atendimento, a.nr_seq_grup_imp,coalesce(a.cd_estabelecimento,lab_obter_cd_estab_setor(r.cd_setor_atendimento)), ie_urgencia 
ORDER BY  	p.ie_tipo_atendimento, a.nr_seq_grup_imp;

