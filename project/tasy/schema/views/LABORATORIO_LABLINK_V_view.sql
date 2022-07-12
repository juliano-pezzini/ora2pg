-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';

CREATE OR REPLACE VIEW laboratorio_lablink_v (cd_tipo_registro, ds_amostra, ie_reservado, ie_repeticao, qt_diluicao, cd_agrupamento, ie_reservado2, dt_coleta, ie_prioridade, cd_material, cd_instrumento, nr_prescricao, ie_origem, ds_ie_origem, ds_exames, nm_paciente, dt_idade, dt_nascimento, ie_sexo, ie_cor, cd_atributo, ds_valor, ie_digito, ds_sigla, cd_setor_prescr, cd_setor_proc) AS select 10 cd_tipo_registro,
	 Lab_obter_amostra_prescr_int(f.ie_padrao_amostra,a.nr_prescricao,a.nr_seq_exame,a.nr_sequencia) ds_amostra,
	 ' ' ie_reservado,
	 'N' ie_repeticao,
	 ' ' qt_diluicao,
	 ' ' cd_agrupamento,
	 ' ' ie_reservado2,
	 max(b.dt_atualizacao) dt_coleta,
	 CASE WHEN a.ie_urgencia='S' THEN  'U'  ELSE 'R' END  ie_prioridade,
	 CASE WHEN f.ie_material_equip='S' THEN coalesce(obter_cd_material_int(d.nr_sequencia, a.nr_seq_exame, 'CETUS'),			coalesce(d.cd_material_integracao, d.cd_material_exame))  ELSE coalesce(d.cd_material_integracao, d.cd_material_exame) END  cd_material,
	 ' ' cd_instrumento,
	 a.nr_prescricao,
	 a.cd_setor_coleta ie_origem,
	 substr(o.ds_origem,1,60) ds_ie_origem,
 	 SUBSTR(Obter_Exames_Prescr_Lab_integr(a.nr_prescricao, a.cd_setor_atendimento, a.cd_material_exame, c.nr_seq_grupo, NULL, 'CI8','',c.nr_seq_grupo_imp, nr_seq_lab, f.ie_status_envio, 'CETUS', null,nr_seq_lote_externo), ((x.linha-1)*160)+1, 160) ds_exames,
	 '' nm_paciente,
	 '0' dt_idade,
	 LOCALTIMESTAMP dt_nascimento,
	 '' ie_sexo,
	 0  ie_cor,
	 '' cd_atributo,
	 '' ds_valor,
	 '10' ie_digito,
	 ' ' ds_sigla,
	 e.cd_setor_atendimento cd_setor_prescr,
	 a.cd_setor_atendimento cd_setor_proc
FROM (SELECT row_number() OVER () AS linha FROM tabela_sistema x LIMIT 12) x, prescr_medica e, material_exame_lab d, exame_laboratorio c, prescr_procedimento a
LEFT OUTER JOIN prescr_proc_etapa b ON (a.nr_prescricao = b.nr_prescricao AND a.nr_sequencia = b.nr_seq_prescricao)
LEFT OUTER JOIN origem_diagnostico o ON (a.cd_setor_coleta = o.nr_sequencia)
LEFT OUTER JOIN lab_parametro f ON (b.ie_etapa = f.ie_status_envio)
WHERE a.nr_seq_exame = c.nr_seq_exame and ((a.nr_seq_lab is not null) or (f.ie_padrao_amostra in ('PM','PM11','PMR11','PM13'))) and f.ie_padrao_amostra NOT IN ('AMO9','AMO10','AMO11','AM10F','AM11F','AMO13', 'EAM10') and a.cd_material_exame = d.cd_material_exame  and a.nr_prescricao 	= e.nr_prescricao   and f.cd_estabelecimento = e.cd_estabelecimento  and a.dt_integracao is null and length(SUBSTR(Obter_Exames_Prescr_Lab_integr(a.nr_prescricao, a.cd_setor_atendimento, a.cd_material_exame, c.nr_seq_grupo, NULL, 'CI8','',c.nr_seq_grupo_imp, nr_seq_lab, f.ie_status_envio, 'CETUS', null,nr_seq_lote_externo), 1, 160)) > 0 and x.linha < (length(Obter_Exames_Prescr_Lab_integr(a.nr_prescricao, a.cd_setor_atendimento, a.cd_material_exame, c.nr_seq_grupo, NULL, 'CI8','',c.nr_seq_grupo_imp, nr_seq_lab, f.ie_status_envio, 'CETUS', null,nr_seq_lote_externo))/160)+1 and Obter_Equipamento_Exame(a.nr_seq_exame,null,'CETUS') is not null and coalesce(a.ie_suspenso, 'N') = 'N' group by  Lab_obter_amostra_prescr_int(f.ie_padrao_amostra,a.nr_prescricao,a.nr_seq_exame,a.nr_sequencia),
	CASE WHEN f.ie_material_equip='S' THEN coalesce(obter_cd_material_int(d.nr_sequencia, a.nr_seq_exame, 'CETUS'),			coalesce(d.cd_material_integracao, d.cd_material_exame))  ELSE coalesce(d.cd_material_integracao, d.cd_material_exame) END ,
	 CASE WHEN a.ie_urgencia='S' THEN  'U'  ELSE 'R' END ,
	 a.nr_prescricao,
	 a.cd_setor_coleta,
 	 SUBSTR(Obter_Exames_Prescr_Lab_integr(a.nr_prescricao, a.cd_setor_atendimento, a.cd_material_exame, c.nr_seq_grupo, NULL, 'CI8','',c.nr_seq_grupo_imp, nr_seq_lab, f.ie_status_envio, 'CETUS', null,nr_seq_lote_externo), ((x.linha-1)*160)+1, 160),
	 e.cd_setor_atendimento,
	 a.cd_setor_atendimento,
	 o.ds_origem

union

select	distinct
	 11 cd_tipo_registro,
	 Lab_obter_amostra_prescr_int(f.ie_padrao_amostra,a.nr_prescricao,a.nr_seq_exame,a.nr_sequencia) ds_amostra,
	 '' ie_reservado,
	 '' ie_repeticao,
	 '' qt_diluicao,
	 '' cd_agrupamento,
	 '' ie_reservado2,
	 LOCALTIMESTAMP dt_coleta,
	 '' ie_prioridade,
	 '' cd_material,
	 '' cd_instrumento,
	 a.nr_prescricao,
	 0 ie_origem,
	 substr(o.ds_origem,1,60) ds_ie_origem,
	 '' ds_exames,
	 c.nm_pessoa_fisica nm_paciente,
	 obter_idade(c.dt_nascimento, b.dt_prescricao, 'A') dt_idade,
	 c.dt_nascimento,
	 c.ie_sexo,
	 c.nr_seq_cor_pele ie_cor,
	 '' cd_atributo,
	 '' ds_valor,
	 '11' ie_digito,
	 '',
	 b.cd_setor_atendimento cd_setor_prescr,
	 a.cd_setor_atendimento cd_setor_proc
FROM lab_parametro f, material_exame_lab e, exame_laboratorio d, pessoa_fisica c, prescr_medica b, prescr_procedimento a
LEFT OUTER JOIN origem_diagnostico o ON (a.cd_setor_coleta = o.nr_sequencia)
WHERE a.nr_prescricao = b.nr_prescricao and b.cd_pessoa_fisica = c.cd_pessoa_fisica and f.cd_estabelecimento = b.cd_estabelecimento and a.nr_seq_exame = d.nr_seq_exame and ((a.nr_seq_lab is not null) or ( f.ie_padrao_amostra in ('PM','PM11','PMR11','PM13'))) and f.ie_padrao_amostra NOT IN ('AMO9','AMO10','AMO11','AM10F','AM11F','AMO13','EAM10') and a.cd_material_exame = e.cd_material_exame and a.dt_integracao is null  and length(SUBSTR(obter_exames_prescr_lab(a.nr_prescricao, a.cd_setor_atendimento, a.cd_material_exame, d.nr_seq_grupo, NULL, 'CI8;' || f.ie_status_envio, '', 0), 1, 160)) > 0 and Obter_Equipamento_Exame(a.nr_seq_exame,null,'CETUS') is not null and coalesce(a.ie_suspenso, 'N') = 'N'

union

select	distinct
	 11 cd_tipo_registro,
 	 lab_obter_caracteres_amostra(g.cd_barras,f.ie_padrao_amostra)  ds_amostra,
	 '' ie_reservado,
	 '' ie_repeticao,
	 '' qt_diluicao,
	 '' cd_agrupamento,
	 '' ie_reservado2,
	 LOCALTIMESTAMP dt_coleta,
	 '' ie_prioridade,
	 '' cd_material,
	 '' cd_instrumento,
	 a.nr_prescricao,
	 0 ie_origem,
	 substr(o.ds_origem,1,60) ds_ie_origem,
	 '' ds_exames,
	 c.nm_pessoa_fisica nm_paciente,
	 obter_idade(c.dt_nascimento, b.dt_prescricao, 'A') dt_idade,
	 c.dt_nascimento,
	 c.ie_sexo,
	 c.nr_seq_cor_pele ie_cor,
	 '' cd_atributo,
	 '' ds_valor,
	 '11' ie_digito,
	 '',
	 b.cd_setor_atendimento cd_setor_prescr,
	 a.cd_setor_atendimento cd_setor_proc
FROM prescr_proc_mat_item g, lab_parametro f, material_exame_lab e, exame_laboratorio d, pessoa_fisica c, prescr_medica b, prescr_procedimento a
LEFT OUTER JOIN origem_diagnostico o ON (a.cd_setor_coleta = o.nr_sequencia)
WHERE a.nr_prescricao = b.nr_prescricao and b.cd_pessoa_fisica = c.cd_pessoa_fisica and g.nr_prescricao = a.nr_prescricao and g.nr_seq_prescr = a.nr_sequencia and f.cd_estabelecimento = b.cd_estabelecimento and a.nr_seq_exame = d.nr_seq_exame and f.ie_padrao_amostra IN ('AMO9','AMO10','AMO11','AM10F','AM11F','AMO13','EAM10') and a.cd_material_exame = e.cd_material_exame and g.dt_integracao is null  and length(substr(obter_exames_lab_integr_item(a.nr_prescricao, a.cd_setor_atendimento,'CI8','',f.ie_status_envio,'CETUS', g.nr_seq_prescr_proc_mat ,a.nr_seq_lote_externo,b.cd_estabelecimento), 1, 160)) > 0 and obter_equipamento_exame(a.nr_seq_exame,null,'CETUS') is not null and coalesce(a.ie_suspenso, 'N') = 'N'
 
union

select 10 cd_tipo_registro,
 	 lab_obter_caracteres_amostra(g.cd_barras,f.ie_padrao_amostra)  ds_amostra,
	 ' ' ie_reservado,
	 'N' ie_repeticao,
	 ' ' qt_diluicao,
	 ' ' cd_agrupamento,
	 ' ' ie_reservado2,
	 max(a.dt_coleta) dt_coleta,
	 CASE WHEN a.ie_urgencia='S' THEN  'U'  ELSE 'R' END  ie_prioridade,
	 CASE WHEN f.ie_material_equip='S' THEN coalesce(obter_cd_material_int(d.nr_sequencia, a.nr_seq_exame, 'CETUS'),			coalesce(d.cd_material_integracao, d.cd_material_exame))  ELSE coalesce(d.cd_material_integracao, d.cd_material_exame) END  cd_material,
	 ' ' cd_instrumento,
	 a.nr_prescricao,
	 a.cd_setor_coleta ie_origem,
	 substr(o.ds_origem,1,60) ds_ie_origem,
 	 substr(obter_exames_lab_integr_item(a.nr_prescricao, a.cd_setor_atendimento,'CI8','',f.ie_status_envio,'CETUS', g.nr_seq_prescr_proc_mat ,a.nr_seq_lote_externo,e.cd_estabelecimento), ((x.linha-1)*160)+1, 160) ds_exames,
	 '' nm_paciente,
	 '0' dt_idade,
	 LOCALTIMESTAMP dt_nascimento,
	 '' ie_sexo,
	 0  ie_cor,
	 '' cd_atributo,
	 '' ds_valor,
	 '10' ie_digito,
	 ' ' ds_sigla,
	 e.cd_setor_atendimento cd_setor_prescr,
	 a.cd_setor_atendimento cd_setor_proc
FROM (SELECT row_number() OVER () AS linha FROM tabela_sistema x LIMIT 12) x, prescr_proc_mat_item g, lab_parametro f, prescr_medica e, material_exame_lab d, exame_laboratorio c, prescr_procedimento a
LEFT OUTER JOIN origem_diagnostico o ON (a.cd_setor_coleta = o.nr_sequencia)
WHERE a.nr_seq_exame = c.nr_seq_exame and f.ie_padrao_amostra IN ('AMO9','AMO10','AMO11','AM10F','AM11F','AMO13','EAM10') and a.cd_material_exame = d.cd_material_exame and a.nr_prescricao 	= e.nr_prescricao and f.cd_estabelecimento = e.cd_estabelecimento and a.nr_prescricao 	= e.nr_prescricao and g.dt_integracao is null  and g.nr_prescricao = a.nr_prescricao and g.nr_seq_prescr = a.nr_sequencia and length(substr(obter_exames_lab_integr_item(a.nr_prescricao, a.cd_setor_atendimento,'CI8','',f.ie_status_envio,'CETUS', g.nr_seq_prescr_proc_mat ,a.nr_seq_lote_externo,e.cd_estabelecimento), 1, 160)) > 0 and x.linha < (length(obter_exames_lab_integr_item(a.nr_prescricao, a.cd_setor_atendimento,'CI8','',f.ie_status_envio,'CETUS', g.nr_seq_prescr_proc_mat ,a.nr_seq_lote_externo,e.cd_estabelecimento))/160)+1 and obter_equipamento_exame(a.nr_seq_exame,null,'CETUS') is not null and coalesce(a.ie_suspenso, 'N') = 'N' group by   	 g.cd_barras,
 	 lab_obter_caracteres_amostra(g.cd_barras,f.ie_padrao_amostra),
	 CASE WHEN f.ie_material_equip='S' THEN coalesce(obter_cd_material_int(d.nr_sequencia, a.nr_seq_exame, 'CETUS'),			coalesce(d.cd_material_integracao, d.cd_material_exame))  ELSE coalesce(d.cd_material_integracao, d.cd_material_exame) END ,
	 CASE WHEN a.ie_urgencia='S' THEN  'U'  ELSE 'R' END ,
	 a.nr_prescricao,
	 a.cd_setor_coleta,
 	 substr(obter_exames_lab_integr_item(a.nr_prescricao, a.cd_setor_atendimento,'CI8','',f.ie_status_envio,'CETUS', g.nr_seq_prescr_proc_mat ,a.nr_seq_lote_externo,e.cd_estabelecimento), ((x.linha-1)*160)+1, 160),
	 e.cd_setor_atendimento,
	 a.cd_setor_atendimento,
	 o.ds_origem;
