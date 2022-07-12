-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';

CREATE OR REPLACE VIEW laboratorio_nefrodata_v (cd_tipo_registro, nr_prontuario, nm_paciente, ie_sexo, nr_cpf, dt_nascimento, ds_endereco, ds_bairro, nr_telefone, ds_municipio, ds_uf, nr_cep, nr_identidade, ds_estado_civil, ie_sangue, ie_fator_rh, nr_prescricao, dt_prescricao, cd_exame, nr_seq_lote_externo) AS select 	01 cd_tipo_registro,
	g.nr_prontuario nr_prontuario, 
	substr(g.nm_pessoa_fisica,1,100) nm_paciente, 
	substr(g.ie_sexo,1,1) ie_sexo, 
	substr(g.nr_cpf,1,11) nr_cpf, 
	substr(to_char(g.dt_nascimento,'dd/mm/yyyy'),1,10) dt_nascimento, 
	substr(obter_compl_pf(g.cd_pessoa_fisica, 1, 'E'),1,100) ds_endereco, 
	substr(obter_compl_pf(g.cd_pessoa_fisica, 1, 'B'),1,50) ds_bairro, 
	substr(obter_compl_pf(g.cd_pessoa_fisica, 1, 'T'),1,12) nr_telefone, 
	substr(obter_compl_pf(g.cd_pessoa_fisica, 1, 'CI'),1,30) ds_municipio, 
	substr(obter_compl_pf(g.cd_pessoa_fisica, 1, 'UF'),1,2) ds_uf, 
	substr(obter_compl_pf(g.cd_pessoa_fisica, 1, 'CEP'),1,8) nr_cep, 
	substr(g.nr_identidade,1,13) nr_identidade, 
	substr(obter_valor_dominio(5,g.ie_estado_civil),1,11) ds_estado_civil, 
	substr(obter_valor_dominio(1173,g.ie_tipo_sangue),1,2) ie_sangue, 
	substr(obter_valor_dominio(1174,g.ie_fator_rh),1,1) ie_fator_rh, 
	e.nr_prescricao nr_prescricao, 
	null dt_prescricao, 
	null cd_exame, 
	a.nr_seq_lote_externo nr_seq_lote_externo 
FROM pessoa_fisica g, prescr_medica e, material_exame_lab d, exame_laboratorio c, prescr_procedimento a
LEFT OUTER JOIN prescr_proc_etapa b ON (a.nr_prescricao = b.nr_prescricao AND a.nr_sequencia = b.nr_seq_prescricao)
LEFT OUTER JOIN lab_parametro f ON (b.ie_etapa = f.ie_status_envio)
WHERE a.nr_seq_exame = c.nr_seq_exame and ((a.nr_seq_lab is not null) or (f.ie_padrao_amostra in ('PM','PM11','PM13'))) and a.cd_material_exame = d.cd_material_exame  and a.nr_prescricao = e.nr_prescricao   and f.cd_estabelecimento = e.cd_estabelecimento and a.nr_prescricao = e.nr_prescricao and e.cd_pessoa_fisica 	= g.cd_pessoa_fisica and length(SUBSTR(Obter_Exames_Prescr_Lab_integr(a.nr_prescricao, a.cd_setor_atendimento, a.cd_material_exame, c.nr_seq_grupo, NULL, 'CE8','',c.nr_seq_grupo_imp, nr_seq_lab, null, 'NEFRO', null, nr_seq_lote_externo), 1, 160)) > 0 and exists (select distinct 1 
	from lab_exame_equip 
	where nr_seq_exame = c.nr_seq_exame 
	and ie_padrao = 'S' 
	and obter_equipamento_exame(nr_seq_exame,cd_equipamento,'S') = 'NEFRO') 
 
union
 
select 	02 cd_tipo_registro, 
	null, 
	null, 
	null, 
	null, 
	null, 
	'', 
	'', 
	'', 
	'', 
	'', 
	'', 
	'', 
	'', 
	'', 
	'', 
	e.nr_prescricao, 
	substr(to_char(e.dt_prescricao,'dd/mm/yyyy'),1,10) dt_prescricao, 
	null, 
	a.nr_seq_lote_externo 
FROM pessoa_fisica g, prescr_medica e, material_exame_lab d, exame_laboratorio c, prescr_procedimento a
LEFT OUTER JOIN prescr_proc_etapa b ON (a.nr_prescricao = b.nr_prescricao AND a.nr_sequencia = b.nr_seq_prescricao)
LEFT OUTER JOIN lab_parametro f ON (b.ie_etapa = f.ie_status_envio)
WHERE a.nr_seq_exame = c.nr_seq_exame and ((a.nr_seq_lab is not null) or (f.ie_padrao_amostra in ('PM','PM11','PM13'))) and a.cd_material_exame = d.cd_material_exame  and a.nr_prescricao = e.nr_prescricao   and f.cd_estabelecimento = e.cd_estabelecimento and a.nr_prescricao = e.nr_prescricao and e.cd_pessoa_fisica 	= g.cd_pessoa_fisica and length(SUBSTR(Obter_Exames_Prescr_Lab_integr(a.nr_prescricao, a.cd_setor_atendimento, a.cd_material_exame, c.nr_seq_grupo, NULL, 'CE8','',c.nr_seq_grupo_imp, nr_seq_lab, null, 'NEFRO', null, nr_seq_lote_externo), 1, 160)) > 0 and exists (select distinct 1 
	from lab_exame_equip 
	where nr_seq_exame = c.nr_seq_exame 
	and ie_padrao = 'S' 
	and obter_equipamento_exame(nr_seq_exame,cd_equipamento,'S') = 'NEFRO') 
 
union
 
select 	03 cd_tipo_registro, 
	null, 
	null, 
	null, 
	null, 
	null, 
	'', 
	'', 
	'', 
	'', 
	'', 
	'', 
	'', 
	'', 
	'', 
	'', 
	e.nr_prescricao, 
	null, 
	substr(coalesce(coalesce(obter_equipamento_exame_integr(a.nr_seq_exame,'NEFRO'),c.cd_exame_integracao), c.cd_exame),1,10) cd_exame, 
	a.nr_seq_lote_externo 
FROM pessoa_fisica g, prescr_medica e, material_exame_lab d, exame_laboratorio c, prescr_procedimento a
LEFT OUTER JOIN prescr_proc_etapa b ON (a.nr_prescricao = b.nr_prescricao AND a.nr_sequencia = b.nr_seq_prescricao)
LEFT OUTER JOIN lab_parametro f ON (b.ie_etapa = f.ie_status_envio)
WHERE a.nr_seq_exame = c.nr_seq_exame and ((a.nr_seq_lab is not null) or (f.ie_padrao_amostra in ('PM','PM11','PM13'))) and a.cd_material_exame = d.cd_material_exame  and a.nr_prescricao = e.nr_prescricao   and f.cd_estabelecimento = e.cd_estabelecimento and a.nr_prescricao = e.nr_prescricao and e.cd_pessoa_fisica 	= g.cd_pessoa_fisica and length(SUBSTR(Obter_Exames_Prescr_Lab_integr(a.nr_prescricao, a.cd_setor_atendimento, a.cd_material_exame, c.nr_seq_grupo, NULL, 'CE8','',c.nr_seq_grupo_imp, nr_seq_lab, null, 'NEFRO', null, nr_seq_lote_externo), 1, 160)) > 0 and exists (select distinct 1 
	from lab_exame_equip 
	where nr_seq_exame = c.nr_seq_exame 
	and ie_padrao = 'S' 
	and obter_equipamento_exame(nr_seq_exame,cd_equipamento,'S') = 'NEFRO') order by nr_prescricao, cd_tipo_registro;

