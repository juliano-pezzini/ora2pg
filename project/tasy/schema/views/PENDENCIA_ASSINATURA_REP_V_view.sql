-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';

CREATE OR REPLACE VIEW pendencia_assinatura_rep_v (nr_sequencia, ds_item, nr_seq_apres, nm_usuario, nr_atendimento, nr_prescricao, cd_perfil, nr_seq_item, dt_liberacao, dt_assinatura) AS select	c.nr_sequencia,
		substr(coalesce(obter_desc_material(f.cd_material),b.ds_item_instituicao,a.ds_item_instituicao,obter_desc_expressao(a.cd_exp_desc_item,a.ds_item),c.ds_item),1,255) ds_item,
		coalesce(b.nr_seq_apres,99999) nr_seq_apres,
		c.nm_usuario,
		c.nr_atendimento,
		c.nr_prescricao,
		b.cd_perfil,
		c.nr_seq_material_rep nr_seq_item,
		null dt_liberacao,
		null dt_assinatura
FROM prescr_material f, pessoa_fisica d, pep_item_pendente c
LEFT OUTER JOIN prontuario_item a ON (c.nr_seq_item_pront = a.nr_sequencia)
LEFT OUTER JOIN atendimento_paciente e ON (c.nr_atendimento = e.nr_atendimento)
LEFT OUTER JOIN perfil_item_pront b ON (a.nr_sequencia = b.nr_seq_item_pront)
WHERE d.cd_pessoa_fisica 						= c.cd_pessoa_fisica and f.nr_sequencia							= c.nr_seq_material_rep and f.nr_prescricao							= c.nr_prescricao and c.nr_parecer							is null and c.nr_seq_perda_ganho					is null and c.nr_seq_cta_pendencia					is null and c.nr_seq_diag_doenca					is null and c.nr_seq_ehr_reg						is null and c.nr_seq_loco_reg						is null and c.nr_seq_sae							is null and c.nr_seq_sinal_vital					is null and c.nr_seq_nut_pac						is null and c.nr_seq_nut_prot						is null and c.nr_seq_solucao						is null and c.nr_seq_gasoterapia					is null and c.nr_seq_recomendacao					is null and c.ie_tipo_item_adep						is null and coalesce(c.ie_pendente_assinat_usuario,'N')	= 'N' and c.ie_tipo_pendencia 					= 'A'

union
	/* Dieta */
select	c.nr_sequencia,
		substr(coalesce(obter_desc_dieta(f.cd_dieta),b.ds_item_instituicao,a.ds_item_instituicao,obter_desc_expressao(a.cd_exp_desc_item,a.ds_item),c.ds_item),1,255) ds_item,
		coalesce(b.nr_seq_apres,99999) nr_seq_apres,
		c.nm_usuario,
		c.nr_atendimento,
		c.nr_prescricao,
		b.cd_perfil,
		c.nr_seq_dieta_rep nr_seq_item,
		null dt_liberacao,
		null dt_assinatura
FROM prescr_dieta f, pessoa_fisica d, pep_item_pendente c
LEFT OUTER JOIN prontuario_item a ON (c.nr_seq_item_pront = a.nr_sequencia)
LEFT OUTER JOIN atendimento_paciente e ON (c.nr_atendimento = e.nr_atendimento)
LEFT OUTER JOIN perfil_item_pront b ON (a.nr_sequencia = b.nr_seq_item_pront)
WHERE d.cd_pessoa_fisica 						= c.cd_pessoa_fisica and f.nr_sequencia							= c.nr_seq_dieta_rep and f.nr_prescricao							= c.nr_prescricao and c.nr_parecer							is null and c.nr_seq_perda_ganho					is null and c.nr_seq_cta_pendencia					is null and c.nr_seq_diag_doenca					is null and c.nr_seq_ehr_reg						is null and c.nr_seq_loco_reg						is null and c.nr_seq_sae							is null and c.nr_seq_sinal_vital					is null and c.nr_seq_nut_pac						is null and c.nr_seq_nut_prot						is null and c.nr_seq_solucao						is null and c.nr_seq_gasoterapia					is null and c.nr_seq_recomendacao					is null and c.ie_tipo_item_adep						is null and coalesce(c.ie_pendente_assinat_usuario,'N')	= 'N' and c.ie_tipo_pendencia 					= 'A'
 
union
	/* Procedimento */
select	c.nr_sequencia,
		substr(coalesce(obter_desc_proced_prescr(c.nr_prescricao,f.nr_sequencia),b.ds_item_instituicao,a.ds_item_instituicao,obter_desc_expressao(a.cd_exp_desc_item,a.ds_item),c.ds_item),1,255) ds_item,
		coalesce(b.nr_seq_apres,99999) nr_seq_apres,
		c.nm_usuario,
		c.nr_atendimento,
		c.nr_prescricao,
		b.cd_perfil,
		c.nr_seq_proced_rep nr_seq_item ,
		null dt_liberacao,
		null dt_assinatura
FROM prescr_procedimento f, pessoa_fisica d, pep_item_pendente c
LEFT OUTER JOIN prontuario_item a ON (c.nr_seq_item_pront = a.nr_sequencia)
LEFT OUTER JOIN atendimento_paciente e ON (c.nr_atendimento = e.nr_atendimento)
LEFT OUTER JOIN perfil_item_pront b ON (a.nr_sequencia = b.nr_seq_item_pront)
WHERE d.cd_pessoa_fisica 						= c.cd_pessoa_fisica and f.nr_sequencia							= c.nr_seq_proced_rep and f.nr_prescricao							= c.nr_prescricao and c.nr_parecer							is null and c.nr_seq_perda_ganho					is null and c.nr_seq_cta_pendencia					is null and c.nr_seq_diag_doenca					is null and c.nr_seq_ehr_reg						is null and c.nr_seq_loco_reg						is null and c.nr_seq_sae							is null and c.nr_seq_sinal_vital					is null and c.nr_seq_nut_pac						is null and c.nr_seq_nut_prot						is null and c.nr_seq_solucao						is null and c.nr_seq_gasoterapia					is null and c.nr_seq_recomendacao					is null and c.ie_tipo_item_adep						is null and coalesce(c.ie_pendente_assinat_usuario,'N')	= 'N' and c.ie_tipo_pendencia 					= 'A'
 
union
	/* Solução */
select	c.nr_sequencia,
		substr(coalesce(f.ds_solucao,obter_prim_comp_sol(f.nr_prescricao,f.nr_seq_solucao),b.ds_item_instituicao,a.ds_item_instituicao,obter_desc_expressao(a.cd_exp_desc_item,a.ds_item),c.ds_item),1,255) ds_item,
		coalesce(b.nr_seq_apres,99999) nr_seq_apres,
		c.nm_usuario,
		c.nr_atendimento,
		c.nr_prescricao,
		b.cd_perfil,
		c.nr_seq_solucao nr_seq_item,
		null dt_liberacao,
		null dt_assinatura
FROM prescr_solucao f, pessoa_fisica d, pep_item_pendente c
LEFT OUTER JOIN prontuario_item a ON (c.nr_seq_item_pront = a.nr_sequencia)
LEFT OUTER JOIN atendimento_paciente e ON (c.nr_atendimento = e.nr_atendimento)
LEFT OUTER JOIN perfil_item_pront b ON (a.nr_sequencia = b.nr_seq_item_pront)
WHERE d.cd_pessoa_fisica 						= c.cd_pessoa_fisica and f.nr_prescricao							= c.nr_prescricao and f.nr_seq_solucao						= c.nr_seq_solucao and c.nr_parecer							is null and c.nr_seq_perda_ganho					is null and c.nr_seq_cta_pendencia					is null and c.nr_seq_diag_doenca					is null and c.nr_seq_ehr_reg						is null and c.nr_seq_loco_reg						is null and c.nr_seq_sae							is null and c.nr_seq_proced_rep						is null and c.nr_seq_sinal_vital					is null and c.nr_seq_dieta_rep						is null and c.nr_seq_material_rep					is null and c.nr_seq_nut_pac						is null and c.nr_seq_nut_prot						is null and c.nr_seq_gasoterapia					is null and c.nr_seq_recomendacao					is null and c.ie_tipo_item_adep						is null and coalesce(c.ie_pendente_assinat_usuario,'N')	= 'N' and c.ie_tipo_pendencia 					= 'A'
 
union
	/* Gasoterapia */
select	c.nr_sequencia,
		substr(coalesce(obter_desc_gas(f.nr_seq_gas),b.ds_item_instituicao,a.ds_item_instituicao,obter_desc_expressao(a.cd_exp_desc_item,a.ds_item),c.ds_item),1,255) ds_item,
		coalesce(b.nr_seq_apres,99999) nr_seq_apres,
		c.nm_usuario,
		c.nr_atendimento,
		c.nr_prescricao,
		b.cd_perfil,
		c.nr_seq_gasoterapia nr_seq_item,
		null dt_liberacao,
		null dt_assinatura
FROM prescr_gasoterapia f, pessoa_fisica d, pep_item_pendente c
LEFT OUTER JOIN prontuario_item a ON (c.nr_seq_item_pront = a.nr_sequencia)
LEFT OUTER JOIN atendimento_paciente e ON (c.nr_atendimento = e.nr_atendimento)
LEFT OUTER JOIN perfil_item_pront b ON (a.nr_sequencia = b.nr_seq_item_pront)
WHERE d.cd_pessoa_fisica 						= c.cd_pessoa_fisica and f.nr_prescricao							= c.nr_prescricao and f.nr_sequencia							= c.nr_seq_gasoterapia and c.nr_parecer							is null and c.nr_seq_perda_ganho					is null and c.nr_seq_cta_pendencia					is null and c.nr_seq_diag_doenca					is null and c.nr_seq_ehr_reg						is null and c.nr_seq_loco_reg						is null and c.nr_seq_sae							is null and c.nr_seq_proced_rep						is null and c.nr_seq_sinal_vital					is null and c.nr_seq_dieta_rep						is null and c.nr_seq_material_rep					is null and c.nr_seq_nut_pac						is null and c.nr_seq_nut_prot						is null and c.nr_seq_solucao						is null and c.nr_seq_recomendacao					is null and c.ie_tipo_item_adep						is null and coalesce(c.ie_pendente_assinat_usuario,'N')	= 'N' and c.ie_tipo_pendencia 					= 'A'
 
union
	/* NPT Neonatal */
select	c.nr_sequencia,
		substr(coalesce('NPT Neonatal',b.ds_item_instituicao,a.ds_item_instituicao,obter_desc_expressao(a.cd_exp_desc_item,a.ds_item),c.ds_item),1,255) ds_item,
		coalesce(b.nr_seq_apres,99999) nr_seq_apres,
		c.nm_usuario,
		c.nr_atendimento,
		c.nr_prescricao,
		b.cd_perfil,
		c.nr_seq_nut_prot nr_seq_item,
		null dt_liberacao,
		null dt_assinatura
FROM nut_pac f, pessoa_fisica d, pep_item_pendente c
LEFT OUTER JOIN prontuario_item a ON (c.nr_seq_item_pront = a.nr_sequencia)
LEFT OUTER JOIN atendimento_paciente e ON (c.nr_atendimento = e.nr_atendimento)
LEFT OUTER JOIN perfil_item_pront b ON (a.nr_sequencia = b.nr_seq_item_pront)
WHERE d.cd_pessoa_fisica 						= c.cd_pessoa_fisica and f.nr_prescricao							= c.nr_prescricao and f.nr_sequencia							= c.nr_seq_nut_prot and f.ie_npt_adulta							= 'N' and c.nr_parecer							is null and c.nr_seq_perda_ganho					is null and c.nr_seq_cta_pendencia					is null and c.nr_seq_diag_doenca					is null and c.nr_seq_ehr_reg						is null and c.nr_seq_loco_reg						is null and c.nr_seq_sae							is null and c.nr_seq_proced_rep						is null and c.nr_seq_sinal_vital					is null and c.nr_seq_dieta_rep						is null and c.nr_seq_material_rep					is null and c.nr_seq_nut_pac						is null and c.nr_seq_gasoterapia					is null and c.nr_seq_solucao						is null and c.nr_seq_recomendacao					is null and c.ie_tipo_item_adep						is null and coalesce(c.ie_pendente_assinat_usuario,'N')	= 'N' and c.ie_tipo_pendencia 					= 'A'
 
union
	/* NPT Pediátrica */
select	c.nr_sequencia,
		substr(coalesce('NPT Pediátrica',b.ds_item_instituicao,a.ds_item_instituicao,obter_desc_expressao(a.cd_exp_desc_item,a.ds_item),c.ds_item),1,255) ds_item,
		coalesce(b.nr_seq_apres,99999) nr_seq_apres,
		c.nm_usuario,
		c.nr_atendimento,
		c.nr_prescricao,
		b.cd_perfil,
		c.nr_seq_nut_prot nr_seq_item,
		null dt_liberacao,
		null dt_assinatura
FROM nut_pac f, pessoa_fisica d, pep_item_pendente c
LEFT OUTER JOIN prontuario_item a ON (c.nr_seq_item_pront = a.nr_sequencia)
LEFT OUTER JOIN atendimento_paciente e ON (c.nr_atendimento = e.nr_atendimento)
LEFT OUTER JOIN perfil_item_pront b ON (a.nr_sequencia = b.nr_seq_item_pront)
WHERE d.cd_pessoa_fisica 						= c.cd_pessoa_fisica and f.nr_prescricao							= c.nr_prescricao and f.nr_sequencia							= c.nr_seq_nut_prot and f.ie_npt_adulta							= 'P' and c.nr_parecer							is null and c.nr_seq_perda_ganho					is null and c.nr_seq_cta_pendencia					is null and c.nr_seq_diag_doenca					is null and c.nr_seq_ehr_reg						is null and c.nr_seq_loco_reg						is null and c.nr_seq_sae							is null and c.nr_seq_proced_rep						is null and c.nr_seq_sinal_vital					is null and c.nr_seq_dieta_rep						is null and c.nr_seq_material_rep					is null and c.nr_seq_nut_pac						is null and c.nr_seq_gasoterapia					is null and c.nr_seq_solucao						is null and c.nr_seq_recomendacao					is null and c.ie_tipo_item_adep						is null and coalesce(c.ie_pendente_assinat_usuario,'N')	= 'N' and c.ie_tipo_pendencia 					= 'A'
 
union
	/* NPT Adulto Protocolo */
select	c.nr_sequencia,
		substr(coalesce('NPT Adulta Protocolo',b.ds_item_instituicao,a.ds_item_instituicao,obter_desc_expressao(a.cd_exp_desc_item,a.ds_item),c.ds_item),1,255) ds_item,
		coalesce(b.nr_seq_apres,99999) nr_seq_apres,
		c.nm_usuario,
		c.nr_atendimento,
		c.nr_prescricao,
		b.cd_perfil,
		c.nr_seq_nut_prot nr_seq_item,
		null dt_liberacao,
		null dt_assinatura
FROM nut_pac f, pessoa_fisica d, pep_item_pendente c
LEFT OUTER JOIN prontuario_item a ON (c.nr_seq_item_pront = a.nr_sequencia)
LEFT OUTER JOIN atendimento_paciente e ON (c.nr_atendimento = e.nr_atendimento)
LEFT OUTER JOIN perfil_item_pront b ON (a.nr_sequencia = b.nr_seq_item_pront)
WHERE d.cd_pessoa_fisica 						= c.cd_pessoa_fisica and f.nr_prescricao							= c.nr_prescricao and f.nr_sequencia							= c.nr_seq_nut_prot and f.ie_npt_adulta							= 'S' and c.nr_parecer							is null and c.nr_seq_perda_ganho					is null and c.nr_seq_cta_pendencia					is null and c.nr_seq_diag_doenca					is null and c.nr_seq_ehr_reg						is null and c.nr_seq_loco_reg						is null and c.nr_seq_sae							is null and c.nr_seq_proced_rep						is null and c.nr_seq_sinal_vital					is null and c.nr_seq_dieta_rep						is null and c.nr_seq_material_rep					is null and c.nr_seq_nut_pac						is null and c.nr_seq_gasoterapia					is null and c.nr_seq_solucao						is null and c.nr_seq_recomendacao					is null and c.ie_tipo_item_adep						is null and coalesce(c.ie_pendente_assinat_usuario,'N')	= 'N' and c.ie_tipo_pendencia 					= 'A'
 
union
	/* NPT Adulto */
select	c.nr_sequencia,
		substr(coalesce('NPT Adulta',b.ds_item_instituicao,a.ds_item_instituicao,obter_desc_expressao(a.cd_exp_desc_item,a.ds_item),c.ds_item),1,255) ds_item,
		coalesce(b.nr_seq_apres,99999) nr_seq_apres,
		c.nm_usuario,
		c.nr_atendimento,
		c.nr_prescricao,
		b.cd_perfil,
		c.nr_seq_nut_pac nr_seq_item,
		null dt_liberacao,
		null dt_assinatura
FROM nut_paciente f, pessoa_fisica d, pep_item_pendente c
LEFT OUTER JOIN prontuario_item a ON (c.nr_seq_item_pront = a.nr_sequencia)
LEFT OUTER JOIN atendimento_paciente e ON (c.nr_atendimento = e.nr_atendimento)
LEFT OUTER JOIN perfil_item_pront b ON (a.nr_sequencia = b.nr_seq_item_pront)
WHERE d.cd_pessoa_fisica 						= c.cd_pessoa_fisica and f.nr_prescricao							= c.nr_prescricao and f.nr_sequencia							= c.nr_seq_nut_pac and c.nr_parecer							is null and c.nr_seq_perda_ganho					is null and c.nr_seq_cta_pendencia					is null and c.nr_seq_diag_doenca					is null and c.nr_seq_ehr_reg						is null and c.nr_seq_loco_reg						is null and c.nr_seq_sae							is null and c.nr_seq_proced_rep						is null and c.nr_seq_sinal_vital					is null and c.nr_seq_dieta_rep						is null and c.nr_seq_material_rep					is null and c.nr_seq_nut_prot						is null and c.nr_seq_gasoterapia					is null and c.nr_seq_solucao						is null and c.nr_seq_recomendacao					is null and c.ie_tipo_item_adep						is null and coalesce(c.ie_pendente_assinat_usuario,'N')	= 'N' and c.ie_tipo_pendencia 					= 'A'
 
union
	/* Recomendação */
select	c.nr_sequencia,
		substr(coalesce(Obter_desc_tipo_recomendacao(f.cd_recomendacao),f.ds_recomendacao,b.ds_item_instituicao,a.ds_item_instituicao,obter_desc_expressao(a.cd_exp_desc_item,a.ds_item),c.ds_item),1,255) ds_item,
		coalesce(b.nr_seq_apres,99999) nr_seq_apres,
		c.nm_usuario,
		c.nr_atendimento,
		c.nr_prescricao,
		b.cd_perfil,
		c.nr_seq_recomendacao nr_seq_item,
		null dt_liberacao,
		null dt_assinatura
FROM prescr_recomendacao f, pessoa_fisica d, pep_item_pendente c
LEFT OUTER JOIN prontuario_item a ON (c.nr_seq_item_pront = a.nr_sequencia)
LEFT OUTER JOIN atendimento_paciente e ON (c.nr_atendimento = e.nr_atendimento)
LEFT OUTER JOIN perfil_item_pront b ON (a.nr_sequencia = b.nr_seq_item_pront)
WHERE d.cd_pessoa_fisica 						= c.cd_pessoa_fisica and f.nr_prescricao							= c.nr_prescricao and f.nr_sequencia							= c.nr_seq_recomendacao and c.nr_parecer							is null and c.nr_seq_perda_ganho					is null and c.nr_seq_cta_pendencia					is null and c.nr_seq_diag_doenca					is null and c.nr_seq_ehr_reg						is null and c.nr_seq_loco_reg						is null and c.nr_seq_sae							is null and c.nr_seq_proced_rep						is null and c.nr_seq_sinal_vital					is null and c.nr_seq_dieta_rep						is null and c.nr_seq_material_rep					is null and c.nr_seq_nut_prot						is null and c.nr_seq_gasoterapia					is null and c.nr_seq_solucao						is null and c.nr_seq_nut_pac						is null and c.ie_tipo_item_adep						is null and coalesce(c.ie_pendente_assinat_usuario,'N')	= 'N' and c.ie_tipo_pendencia 					= 'A'
 
union
	/* Prescrição */
select	c.nr_sequencia,
		('Prescrição: ' || f.nr_prescricao) ds_item,
		coalesce(b.nr_seq_apres,99999) nr_seq_apres,
		c.nm_usuario,
		c.nr_atendimento,
		c.nr_prescricao,
		b.cd_perfil,
		null nr_seq_item,
		null dt_liberacao,
		null dt_assinatura
FROM prescr_medica f, pessoa_fisica d, pep_item_pendente c
LEFT OUTER JOIN prontuario_item a ON (c.nr_seq_item_pront = a.nr_sequencia)
LEFT OUTER JOIN atendimento_paciente e ON (c.nr_atendimento = e.nr_atendimento)
LEFT OUTER JOIN perfil_item_pront b ON (a.nr_sequencia = b.nr_seq_item_pront)
WHERE d.cd_pessoa_fisica 						= c.cd_pessoa_fisica and f.nr_prescricao							= c.nr_prescricao and c.nr_parecer							is null and c.nr_seq_perda_ganho					is null and c.nr_seq_cta_pendencia					is null and c.nr_seq_diag_doenca					is null and c.nr_seq_ehr_reg						is null and c.nr_seq_loco_reg						is null and c.nr_seq_sae							is null and c.nr_seq_proced_rep						is null and c.nr_seq_sinal_vital					is null and c.nr_seq_dieta_rep						is null and c.nr_seq_material_rep					is null and c.nr_seq_nut_pac						is null and c.nr_seq_nut_prot						is null and c.nr_seq_solucao						is null and c.nr_seq_gasoterapia					is null and c.nr_seq_recomendacao					is null and c.ie_tipo_item_adep						is null and coalesce(c.ie_pendente_assinat_usuario,'N')	= 'N' and c.ie_tipo_pendencia 					= 'A';
