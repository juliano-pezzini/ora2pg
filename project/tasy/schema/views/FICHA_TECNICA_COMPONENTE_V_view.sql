-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';

CREATE OR REPLACE VIEW ficha_tecnica_componente_v (nr_ficha_tecnica, nr_seq_componente, dt_alteracao, cd_estabelecimento, nm_usuario, dt_atualizacao, ie_situacao, ie_tipo_componente, cd_material, cd_procedimento, ie_origem_proced, cd_centro_controle, qt_fixa, qt_variavel, pr_quebra_variavel, qt_dose, cd_unidade_medida_dose, qt_material, ie_necessita_disp, nr_seq_exame, nr_seq_proc_interno, dt_inicio_vigencia, dt_fim_vigencia, dt_atualizacao_nrec, nm_usuario_nrec, cd_unidade_medida, cd_mat_proc_cc, ds_mat_proc_cc) AS select	a.NR_FICHA_TECNICA,a.NR_SEQ_COMPONENTE,a.DT_ALTERACAO,a.CD_ESTABELECIMENTO,a.NM_USUARIO,a.DT_ATUALIZACAO,a.IE_SITUACAO,a.IE_TIPO_COMPONENTE,a.CD_MATERIAL,a.CD_PROCEDIMENTO,a.IE_ORIGEM_PROCED,a.CD_CENTRO_CONTROLE,a.QT_FIXA,a.QT_VARIAVEL,a.PR_QUEBRA_VARIAVEL,a.QT_DOSE,a.CD_UNIDADE_MEDIDA_DOSE,a.QT_MATERIAL,a.IE_NECESSITA_DISP,a.NR_SEQ_EXAME,a.NR_SEQ_PROC_INTERNO,a.DT_INICIO_VIGENCIA,a.DT_FIM_VIGENCIA,a.DT_ATUALIZACAO_NREC,a.NM_USUARIO_NREC,
	coalesce(c.cd_unidade_medida, substr(obter_dados_material_estab(m.cd_material,a.cd_estabelecimento,'UMS'),1,30)) cd_unidade_medida,
	substr(cus_obter_componente_ficha(	a.cd_estabelecimento,
						a.nr_ficha_tecnica,
						a.nr_seq_componente,
						1),1,255) cd_mat_proc_cc,
	substr(cus_obter_componente_ficha(	a.cd_estabelecimento,
						a.nr_ficha_tecnica,
						a.nr_seq_componente,
						2),1,255) ds_mat_proc_cc
FROM ficha_tecnica_componente a
LEFT OUTER JOIN material m ON (a.cd_material = m.cd_material)
LEFT OUTER JOIN procedimento p ON (a.cd_procedimento = p.cd_procedimento AND a.ie_origem_proced = p.ie_origem_proced)
LEFT OUTER JOIN centro_controle c ON (a.cd_centro_controle = c.cd_centro_controle AND a.cd_estabelecimento = c.cd_estabelecimento);
