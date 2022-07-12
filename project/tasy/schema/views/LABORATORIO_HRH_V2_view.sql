-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';

CREATE OR REPLACE VIEW laboratorio_hrh_v2 (cd_tipo_registro, ds_amostra, ie_ident_anterior, ie_reservado, ie_repeticao, qt_diluicao, cd_agrupamento, ie_reservado2, dt_coleta, dt_prescricao, hr_prescricao, ie_prioridade, cd_material, cd_instrumento, nr_prescricao, nr_prescr_consulta, ie_origem, ds_exames, nm_paciente, dt_idade, dt_nascimento, ie_sexo, ie_cor, cd_atributo, ds, ie_digito, cd_exame, cd_parametro, ds_resultado_ant, ds_valor, ds_sigla, ie_verificacao, nr_seq_lote_externo) AS select 10 cd_tipo_registro,
	 Lab_obter_amostra_prescr(g.ie_padrao_amostra,a.nr_prescricao,a.nr_seq_exame,a.nr_sequencia) ds_amostra,
	 ' ' ie_ident_anterior,
	 ' ' ie_reservado,
	 'N' ie_repeticao,
	 ' ' qt_diluicao,
	 CASE WHEN g.ie_prescr_agrupamento='S' THEN  to_char(a.nr_prescricao)   ELSE ' ' END  cd_agrupamento,
	 ' ' ie_reservado2,
	 max(a.dt_coleta) dt_coleta,
	 null dt_prescricao,
	 null hr_prescricao,
	 CASE WHEN a.ie_urgencia='S' THEN  'U'  ELSE 'R' END  ie_prioridade,
	 CASE WHEN g.ie_gerar_result_prescr='S' THEN lab_obter_material_integracao(a.nr_prescricao, a.nr_sequencia,'C')  ELSE coalesce(d.cd_material_integracao, d.cd_material_exame) END  cd_material,
	 ' ' cd_instrumento,
 	 a.nr_prescricao,
	 CASE WHEN coalesce(g.ie_cons_pf_interf,'N')='N' THEN a.nr_prescricao  ELSE b.cd_pessoa_fisica END  nr_prescr_consulta,
	 a.cd_setor_coleta ie_origem,
	 substr(Obter_Exames_Prescr_Lab_integr(a.nr_prescricao, a.cd_setor_atendimento, a.cd_material_exame, c.nr_seq_grupo, null, 'CI8;20;;'||
	 	substr(obter_compl_desc_mat_lab(a.nr_prescricao, d.nr_sequencia, e.nr_sequencia),1,1),'',c.nr_seq_grupo_imp, nr_seq_lab, g.ie_status_envio, 'MATRIX', null,nr_seq_lote_externo), 1, 160) ds_exames,
	 '' nm_paciente,
	 '0' dt_idade,
	 LOCALTIMESTAMP dt_nascimento,
	 '' ie_sexo,
	 ''  ie_cor,
	 '' cd_atributo,
	 '' ds,
	 '10' ie_digito,
	 '' cd_exame,
	 ' ' cd_parametro,
	 '' ds_resultado_ant,
	 '' ds_valor,
	 ' ' ds_sigla,
	 ' ' ie_verificacao,
	 a.nr_seq_lote_externo
FROM 	lab_parametro g,
	prescr_proc_material e,
	material_exame_lab d,
	exame_laboratorio c,
	prescr_medica b,
	prescr_procedimento a
where a.nr_seq_exame	= c.nr_seq_exame
and a.nr_prescricao = b.nr_prescricao
and a.cd_material_exame	= d.cd_material_exame
and a.nr_prescricao 	= e.nr_prescricao
and d.nr_sequencia	= e.nr_seq_material
and g.cd_estabelecimento = b.cd_estabelecimento
and ((a.nr_seq_lab is not null) or (g.ie_padrao_amostra in ('PM','PM11','PMR11','PM13') and obter_equipamento_exame(a.nr_seq_exame,null,'MATRIX') is not null))
and g.ie_padrao_amostra NOT IN ('AMO9','AMO10','AMO11','AM10F','AM11F','AMO13')
and a.dt_integracao is null
and length(substr(Obter_Exames_Prescr_Lab_integr(a.nr_prescricao, a.cd_setor_atendimento, a.cd_material_exame, c.nr_seq_grupo, null, 'CI8;20;;'||
	 	substr(obter_compl_desc_mat_lab(a.nr_prescricao, d.nr_sequencia, e.nr_sequencia),1,1),'',c.nr_seq_grupo_imp, nr_seq_lab, g.ie_status_envio, 'MATRIX', null,nr_seq_lote_externo), 1, 160)) > 0
and coalesce(a.ie_suspenso, 'N') = 'N'
group by Lab_obter_amostra_prescr(g.ie_padrao_amostra,a.nr_prescricao,a.nr_seq_exame,a.nr_sequencia),
	CASE WHEN a.ie_urgencia='S' THEN  'U'  ELSE 'R' END ,
	CASE WHEN g.ie_gerar_result_prescr='S' THEN lab_obter_material_integracao(a.nr_prescricao, a.nr_sequencia,'C')  ELSE coalesce(d.cd_material_integracao, d.cd_material_exame) END ,
	a.nr_prescricao,
	CASE WHEN coalesce(g.ie_cons_pf_interf,'N')='N' THEN a.nr_prescricao  ELSE b.cd_pessoa_fisica END ,
	a.cd_setor_coleta,
	substr(Obter_Exames_Prescr_Lab_integr(a.nr_prescricao, a.cd_setor_atendimento,a.cd_material_exame, c.nr_seq_grupo, null, 'CI8;20;;'||
	 	substr(obter_compl_desc_mat_lab(a.nr_prescricao, d.nr_sequencia, e.nr_sequencia),1,1),'',c.nr_seq_grupo_imp, nr_seq_lab, g.ie_status_envio, 'MATRIX', null,nr_seq_lote_externo), 1, 160),
	a.nr_seq_lote_externo,
	CASE WHEN g.ie_prescr_agrupamento='S' THEN  to_char(a.nr_prescricao)   ELSE ' ' END

union

select 10 cd_tipo_registro,
	 lab_obter_caracteres_amostra(e.cd_barras,g.ie_padrao_amostra)  ds_amostra,
	 ' ' ie_ident_anterior,
	 ' ' ie_reservado,
	 'N' ie_repeticao,
	 ' ' qt_diluicao,
	 CASE WHEN g.ie_prescr_agrupamento='S' THEN  to_char(a.nr_prescricao)   ELSE ' ' END  cd_agrupamento,
	 ' ' ie_reservado2,
	 max(a.dt_coleta) dt_coleta,
	 null dt_prescricao,
	 null hr_prescricao,
	 CASE WHEN a.ie_urgencia='S' THEN  'U'  ELSE 'R' END  ie_prioridade,
	 CASE WHEN g.ie_gerar_result_prescr='S' THEN lab_obter_material_integracao(a.nr_prescricao, a.nr_sequencia,'C')  ELSE coalesce(d.cd_material_integracao, d.cd_material_exame) END  cd_material,
	 ' ' cd_instrumento,
  	 a.nr_prescricao,
	 CASE WHEN coalesce(g.ie_cons_pf_interf,'N')='N' THEN a.nr_prescricao  ELSE b.cd_pessoa_fisica END  nr_prescr_consulta,
	 a.cd_setor_coleta ie_origem,
	substr(obter_lab_integr_item_matrix(a.nr_prescricao,a.cd_setor_atendimento,'CI8','',
		g.ie_status_envio,'MATRIX', e.nr_sequencia,a.nr_seq_lote_externo,b.cd_estabelecimento), 1, 160) ds_exames,
	 '' nm_paciente,
	 '0' dt_idade,
	 LOCALTIMESTAMP dt_nascimento,
	 '' ie_sexo,
	 ''  ie_cor,
	 '' cd_atributo,
	 '' ds,
	 '10' ie_digito,
	 '' cd_exame,
	 ' ' cd_parametro,
	 '' ds_resultado_ant,
	 '' ds_valor,
	 ' ' ds_sigla,
	 ' ' ie_verificacao,
	 a.nr_seq_lote_externo
from 	lab_parametro g,
	prescr_proc_material e,
	material_exame_lab d,
	exame_laboratorio c,
	prescr_medica b,
	prescr_procedimento a,
	prescr_proc_mat_item f
where a.nr_seq_exame		= c.nr_seq_exame
and a.nr_prescricao = b.nr_prescricao
and a.cd_material_exame	= d.cd_material_exame
and a.dt_integracao is null
and f.nr_prescricao = a.nr_prescricao
and f.nr_seq_prescr = a.nr_sequencia
and f.dt_integracao is null
and a.nr_prescricao 	= e.nr_prescricao
and d.nr_sequencia	= e.nr_seq_material
and g.cd_estabelecimento = b.cd_estabelecimento
and g.ie_padrao_amostra IN ('AMO9','AMO10','AMO11','AM10F','AM11F','AMO13')
and coalesce(Obter_Equipamento_Exame(a.nr_seq_exame,null,'MATRIX'),c.cd_exame_integracao) is not null
and a.ie_suspenso <> 'S'
and length(substr(obter_lab_integr_item_matrix(a.nr_prescricao,a.cd_setor_atendimento,'CI8','',
		g.ie_status_envio,'MATRIX', e.nr_sequencia,a.nr_seq_lote_externo,b.cd_estabelecimento), 1, 160)) > 0
and coalesce(a.ie_suspenso, 'N') = 'N'
group by lab_obter_caracteres_amostra(e.cd_barras,g.ie_padrao_amostra),
	CASE WHEN a.ie_urgencia='S' THEN  'U'  ELSE 'R' END ,
	CASE WHEN g.ie_gerar_result_prescr='S' THEN lab_obter_material_integracao(a.nr_prescricao, a.nr_sequencia,'C')  ELSE coalesce(d.cd_material_integracao, d.cd_material_exame) END ,
	a.nr_prescricao,
	CASE WHEN coalesce(g.ie_cons_pf_interf,'N')='N' THEN a.nr_prescricao  ELSE b.cd_pessoa_fisica END ,
	a.cd_setor_coleta,
	substr(obter_lab_integr_item_matrix(a.nr_prescricao,a.cd_setor_atendimento,'CI8','',
		g.ie_status_envio,'MATRIX', e.nr_sequencia,a.nr_seq_lote_externo,b.cd_estabelecimento), 1, 160),
	a.nr_seq_lote_externo,
	CASE WHEN g.ie_prescr_agrupamento='S' THEN  to_char(a.nr_prescricao)   ELSE ' ' END 

union

select	distinct
	 11 cd_tipo_registro,
	 '0' ds_amostra,
	 ' ' ie_ident_anterior,
	 '' ie_reservado,
	 '' ie_repeticao,
	 '' qt_diluicao,
	 null cd_agrupamento,
	 '' ie_reservado2,
	 LOCALTIMESTAMP dt_coleta,
	 null dt_prescricao,
	 null hr_prescricao,
	 '' ie_prioridade,
	 '' cd_material,
	 '' cd_instrumento,
	 a.nr_prescricao,
	 CASE WHEN coalesce(g.ie_cons_pf_interf,'N')='N' THEN a.nr_prescricao  ELSE c.cd_pessoa_fisica END  nr_prescr_consulta,
	 0 ie_origem,
	 '' ds_exames,
	 c.nm_pessoa_fisica nm_paciente,
	 lpad(OBTER_IDADE(c.dt_nascimento, b.dt_prescricao,'A'),3,0)||lpad(OBTER_IDADE(c.dt_nascimento, b.dt_prescricao,'MM'),2,0)||lpad(OBTER_IDADE(c.dt_nascimento, b.dt_prescricao,'DI'),2,0) dt_idade,
	 c.dt_nascimento,
	 c.ie_sexo,
	 Matrix_Obter_Cor_Pele(c.nr_seq_cor_pele) ie_cor,
	 '' cd_atributo,
	 '' ds,
	 '11' ie_digito,
	 '' cd_exame,
	 ' ' cd_parametro,
	 '' ds_resultado_ant,
	 '' ds_valor,
	 ' ' ds_sigla,
	 ' ' ie_verificacao,
	 a.nr_seq_lote_externo
from 	lab_parametro g,
	prescr_proc_material f,
	material_exame_lab e,
	exame_laboratorio d,
	pessoa_fisica c,
	prescr_medica b,
	prescr_procedimento a
where a.nr_prescricao = b.nr_prescricao
and b.cd_pessoa_fisica = c.cd_pessoa_fisica
and a.nr_seq_exame = d.nr_seq_exame
and a.cd_material_exame = e.cd_material_exame
and a.nr_prescricao 	= f.nr_prescricao
and e.nr_sequencia	= f.nr_seq_material
and g.cd_estabelecimento = b.cd_estabelecimento
and ((a.nr_seq_lab is not null) or (g.ie_padrao_amostra in ('PM','PM11','PMR11','PM13') and obter_equipamento_exame(a.nr_seq_exame,null,'MATRIX') is not null))
and g.ie_padrao_amostra NOT IN ('AMO9','AMO10','AMO11','AM10F','AM11F','AMO13')
and a.dt_integracao is null
and length(substr(Obter_Exames_Prescr_Lab_integr(a.nr_prescricao, a.cd_setor_atendimento, a.cd_material_exame, d.nr_seq_grupo, null, 'CI8;20;;'||
	 	substr(obter_compl_desc_mat_lab(a.nr_prescricao, e.nr_sequencia, f.nr_sequencia),1,1),'',d.nr_seq_grupo_imp, nr_seq_lab, g.ie_status_envio, 'MATRIX', null,nr_seq_lote_externo), 1, 160)) > 0
and coalesce(a.ie_suspenso, 'N') = 'N'

union

select	distinct
	 11 cd_tipo_registro,
	 '0' ds_amostra,
	 ' ' ie_ident_anterior,
	 '' ie_reservado,
	 '' ie_repeticao,
	 '' qt_diluicao,
	 null cd_agrupamento,
	 '' ie_reservado2,
	 LOCALTIMESTAMP dt_coleta,
	 null dt_prescricao,
	 null hr_prescricao,
	 '' ie_prioridade,
	 '' cd_material,
	 '' cd_instrumento,
 	 a.nr_prescricao,
	 CASE WHEN coalesce(g.ie_cons_pf_interf,'N')='N' THEN a.nr_prescricao  ELSE c.cd_pessoa_fisica END  nr_prescr_consulta,
	 0 ie_origem,
	 '' ds_exames,
	 c.nm_pessoa_fisica nm_paciente,
	 lpad(OBTER_IDADE(c.dt_nascimento, b.dt_prescricao,'A'),3,0)||lpad(OBTER_IDADE(c.dt_nascimento, b.dt_prescricao,'MM'),2,0)||lpad(OBTER_IDADE(c.dt_nascimento, b.dt_prescricao,'DI'),2,0) dt_idade,
	 c.dt_nascimento,
	 c.ie_sexo,
	 Matrix_Obter_Cor_Pele(c.nr_seq_cor_pele) ie_cor,
	 '' cd_atributo,
	 '' ds,
	 '11' ie_digito,
	 '' cd_exame,
	 ' ' cd_parametro,
	 '' ds_resultado_ant,
	 '' ds_valor,
	 ' ' ds_sigla,
	 ' ' ie_verificacao,
	 a.nr_seq_lote_externo
from 	lab_parametro g,
	prescr_proc_material f,
	material_exame_lab e,
	exame_laboratorio d,
	pessoa_fisica c,
	prescr_medica b,
	prescr_procedimento a,
	prescr_proc_mat_item h
where a.nr_prescricao = b.nr_prescricao
and b.cd_pessoa_fisica = c.cd_pessoa_fisica
and a.nr_seq_exame = d.nr_seq_exame
and a.cd_material_exame = e.cd_material_exame
and a.nr_prescricao 	= f.nr_prescricao
and e.nr_sequencia	= f.nr_seq_material
and h.nr_prescricao = a.nr_prescricao
and h.nr_seq_prescr = a.nr_sequencia
and h.dt_integracao is null
and g.cd_estabelecimento = b.cd_estabelecimento
and coalesce(Obter_Equipamento_Exame(a.nr_seq_exame,null,'MATRIX'),d.cd_exame_integracao) is not null
and g.ie_padrao_amostra IN ('AMO9','AMO10','AMO11','AM10F','AM11F','AMO13')
and a.ie_suspenso <> 'S'
and a.dt_integracao is null
and length(substr(obter_lab_integr_item_matrix(a.nr_prescricao,a.cd_setor_atendimento,'CI8','',
		g.ie_status_envio,'MATRIX', f.nr_sequencia,a.nr_seq_lote_externo,b.cd_estabelecimento), 1, 160)) > 0
and coalesce(a.ie_suspenso, 'N') = 'N'

union

select	distinct
	 12 cd_tipo_registro,
	 Lab_obter_amostra_prescr(g.ie_padrao_amostra,a.nr_prescricao,a.nr_seq_exame,a.nr_sequencia) ds_amostra,
	 ' ' ie_ident_anterior,
	 '' ie_reservado,
	 '' ie_repeticao,
	 '' qt_diluicao,
	 null cd_agrupamento,
	 '' ie_reservado2,
	 null dt_coleta,
	 null dt_prescricao,
	 null hr_prescricao,
	 '' ie_prioridade,
	 '' cd_material,
	 '' cd_instrumento,
	 a.nr_prescricao,
	 0 nr_prescr_consulta,
	 0 ie_origem,
	 '' ds_exames,
	 '' nm_paciente,
	 null dt_idade,
	 null dt_nascimento,
	 null ie_sexo,
	 '' ie_cor,
	 'VOL' cd_atributo,
	 '' ds,
	 '12' ie_digito,
	 '' cd_exame,
	 ' ' cd_parametro,
	 '' ds_resultado_ant,
	 to_char(f.qt_volume) ds_valor,
	 ' ' ds_sigla,
	 ' ' ie_verificacao,
	 a.nr_seq_lote_externo
from 	lab_parametro g,
	prescr_proc_material f,
	material_exame_lab e,
	exame_laboratorio d,
	pessoa_fisica c,
	prescr_medica b,
	prescr_procedimento a
where a.nr_prescricao = b.nr_prescricao
and b.cd_pessoa_fisica = c.cd_pessoa_fisica
and a.nr_seq_exame = d.nr_seq_exame
and a.cd_material_exame = e.cd_material_exame
and a.nr_prescricao 	= f.nr_prescricao
and e.nr_sequencia	= f.nr_seq_material
and g.cd_estabelecimento = b.cd_estabelecimento
and ((a.nr_seq_lab is not null) or (g.ie_padrao_amostra in ('PM','PM11','PMR11','PM13') and obter_equipamento_exame(a.nr_seq_exame,null,'MATRIX') is not null))
and g.ie_padrao_amostra NOT IN ('AMO9','AMO10','AMO11','AM10F','AM11F','AMO13')
and coalesce(e.ie_volume_tempo,'N') = 'S'
and f.qt_volume > 0
and a.dt_integracao is null
and length(substr(Obter_Exames_Prescr_Lab_integr(a.nr_prescricao, a.cd_setor_atendimento, a.cd_material_exame, d.nr_seq_grupo, null, 'CI8;20;;'||
	 	substr(obter_compl_desc_mat_lab(a.nr_prescricao, e.nr_sequencia, f.nr_sequencia),1,1),'',d.nr_seq_grupo_imp, nr_seq_lab, g.ie_status_envio, 'MATRIX', null,nr_seq_lote_externo), 1, 160)) > 0
and coalesce(a.ie_suspenso, 'N') = 'N'

union

select	distinct
	 12 cd_tipo_registro,
	 lab_obter_caracteres_amostra(f.cd_barras,g.ie_padrao_amostra) ds_amostra,
	 ' ' ie_ident_anterior,
	 '' ie_reservado,
	 '' ie_repeticao,
	 '' qt_diluicao,
	 null cd_agrupamento,
	 '' ie_reservado2,
	 null dt_coleta,
	 null dt_prescricao,
	 null hr_prescricao,
	 '' ie_prioridade,
	 '' cd_material,
	 '' cd_instrumento,
 	 a.nr_prescricao,
	 0 nr_prescr_consulta,
	 0 ie_origem,
	 '' ds_exames,
	 '' nm_paciente,
	 null dt_idade,
	 null dt_nascimento,
	 '' ie_sexo,
	 '' ie_cor,
	 'VOL' cd_atributo,
	 '' ds,
	 '12' ie_digito,
	 '' cd_exame,
	 ' ' cd_parametro,
	 '' ds_resultado_ant,
	 to_char(f.qt_volume) ds_valor,
	 ' ' ds_sigla,
	 ' ' ie_verificacao,
	 a.nr_seq_lote_externo
from 	lab_parametro g,
	prescr_proc_material f,
	material_exame_lab e,
	exame_laboratorio d,
	pessoa_fisica c,
	prescr_medica b,
	prescr_procedimento a,
	prescr_proc_mat_item h
where a.nr_prescricao = b.nr_prescricao
and b.cd_pessoa_fisica = c.cd_pessoa_fisica
and a.nr_seq_exame = d.nr_seq_exame
and a.cd_material_exame = e.cd_material_exame
and a.nr_prescricao 	= f.nr_prescricao
and e.nr_sequencia	= f.nr_seq_material
and h.nr_prescricao = a.nr_prescricao
and h.nr_seq_prescr = a.nr_sequencia
and h.dt_integracao is null
and g.cd_estabelecimento = b.cd_estabelecimento
and coalesce(Obter_Equipamento_Exame(a.nr_seq_exame,null,'MATRIX'),d.cd_exame_integracao) is not null
and g.ie_padrao_amostra IN ('AMO9','AMO10','AMO11','AM10F','AM11F','AMO13')
and a.ie_suspenso <> 'S'
and coalesce(e.ie_volume_tempo,'N') = 'S'
and f.qt_volume > 0
and a.dt_integracao is null
and length(substr(obter_lab_integr_item_matrix(a.nr_prescricao,a.cd_setor_atendimento,'CI8','',
		g.ie_status_envio,'MATRIX', f.nr_sequencia,a.nr_seq_lote_externo,b.cd_estabelecimento), 1, 160)) > 0
and coalesce(a.ie_suspenso, 'N') = 'N'

union

select	distinct
	 12 cd_tipo_registro,
	 Lab_obter_amostra_prescr(g.ie_padrao_amostra,a.nr_prescricao,a.nr_seq_exame,a.nr_sequencia) ds_amostra,
	 ' ' ie_ident_anterior,
	 '' ie_reservado,
	 '' ie_repeticao,
	 '' qt_diluicao,
	 null cd_agrupamento,
	 '' ie_reservado2,
	 null dt_coleta,
	 null dt_prescricao,
	 null hr_prescricao,
	 '' ie_prioridade,
	 '' cd_material,
	 '' cd_instrumento,
	 a.nr_prescricao,
	 0 nr_prescr_consulta,
	 0 ie_origem,
	 '' ds_exames,
	 '' nm_paciente,
	 null dt_idade,
	 null dt_nascimento,
	 null ie_sexo,
	 '' ie_cor,
	 'ALTURA' cd_atributo,
	 '' ds,
	 '12' ie_digito,
	 '' cd_exame,
	 ' ' cd_parametro,
	 '' ds_resultado_ant,
	 to_char(coalesce(b.qt_altura_cm,c.qt_altura_cm)) ds_valor,
	 ' ' ds_sigla,
	 ' ' ie_verificacao,
	 a.nr_seq_lote_externo
from 	lab_parametro g,
	prescr_proc_material f,
	material_exame_lab e,
	exame_laboratorio d,
	pessoa_fisica c,
	prescr_medica b,
	prescr_procedimento a
where a.nr_prescricao = b.nr_prescricao
and b.cd_pessoa_fisica = c.cd_pessoa_fisica
and a.nr_seq_exame = d.nr_seq_exame
and a.cd_material_exame = e.cd_material_exame
and a.nr_prescricao 	= f.nr_prescricao
and e.nr_sequencia	= f.nr_seq_material
and g.cd_estabelecimento = b.cd_estabelecimento
and ((a.nr_seq_lab is not null) or (g.ie_padrao_amostra in ('PM','PM11','PMR11','PM13') and obter_equipamento_exame(a.nr_seq_exame,null,'MATRIX') is not null))
and g.ie_padrao_amostra NOT IN ('AMO9','AMO10','AMO11','AM10F','AM11F','AMO13')
and	coalesce(b.qt_altura_cm,c.qt_altura_cm) is not null
and a.dt_integracao is null
and length(substr(Obter_Exames_Prescr_Lab_integr(a.nr_prescricao, a.cd_setor_atendimento, a.cd_material_exame, d.nr_seq_grupo, null, 'CI8;20;;'||
	 	substr(obter_compl_desc_mat_lab(a.nr_prescricao, e.nr_sequencia, f.nr_sequencia),1,1),'',d.nr_seq_grupo_imp, nr_seq_lab, g.ie_status_envio, 'MATRIX', null,nr_seq_lote_externo), 1, 160)) > 0
and coalesce(a.ie_suspenso, 'N') = 'N'

union

select	distinct
	 12 cd_tipo_registro,
	 lab_obter_caracteres_amostra(f.cd_barras,g.ie_padrao_amostra) ds_amostra,
	 ' ' ie_ident_anterior,
	 '' ie_reservado,
	 '' ie_repeticao,
	 '' qt_diluicao,
	 null cd_agrupamento,
	 '' ie_reservado2,
	 null dt_coleta,
	 null dt_prescricao,
	 null hr_prescricao,
	 '' ie_prioridade,
	 '' cd_material,
	 '' cd_instrumento,
 	 a.nr_prescricao,
	 0 nr_prescr_consulta,
	 0 ie_origem,
	 '' ds_exames,
	 '' nm_paciente,
	 null dt_idade,
	 null dt_nascimento,
	 '' ie_sexo,
	 '' ie_cor,
	 'ALTURA' cd_atributo,
	 '' ds,
	 '12' ie_digito,
	 '' cd_exame,
	 ' ' cd_parametro,
	 '' ds_resultado_ant,
	 to_char(coalesce(b.qt_altura_cm,c.qt_altura_cm)) ds_valor,
	 ' ' ds_sigla,
	 ' ' ie_verificacao,
	 a.nr_seq_lote_externo
from 	lab_parametro g,
	prescr_proc_material f,
	material_exame_lab e,
	exame_laboratorio d,
	pessoa_fisica c,
	prescr_medica b,
	prescr_procedimento a,
	prescr_proc_mat_item h
where a.nr_prescricao = b.nr_prescricao
and b.cd_pessoa_fisica = c.cd_pessoa_fisica
and a.nr_seq_exame = d.nr_seq_exame
and a.cd_material_exame = e.cd_material_exame
and a.nr_prescricao 	= f.nr_prescricao
and e.nr_sequencia	= f.nr_seq_material
and h.nr_prescricao = a.nr_prescricao
and h.nr_seq_prescr = a.nr_sequencia
and h.dt_integracao is null
and g.cd_estabelecimento = b.cd_estabelecimento
and coalesce(Obter_Equipamento_Exame(a.nr_seq_exame,null,'MATRIX'),d.cd_exame_integracao) is not null
and g.ie_padrao_amostra IN ('AMO9','AMO10','AMO11','AM10F','AM11F','AMO13')
and a.ie_suspenso <> 'S'
and	coalesce(b.qt_altura_cm,c.qt_altura_cm) is not null
and a.dt_integracao is null
and length(substr(obter_lab_integr_item_matrix(a.nr_prescricao,a.cd_setor_atendimento,'CI8','',
		g.ie_status_envio,'MATRIX', f.nr_sequencia,a.nr_seq_lote_externo,b.cd_estabelecimento), 1, 160)) > 0
and coalesce(a.ie_suspenso, 'N') = 'N'

union

select	distinct
	 12 cd_tipo_registro,
	 Lab_obter_amostra_prescr(g.ie_padrao_amostra,a.nr_prescricao,a.nr_seq_exame,a.nr_sequencia) ds_amostra,
	 ' ' ie_ident_anterior,
	 '' ie_reservado,
	 '' ie_repeticao,
	 '' qt_diluicao,
	 null cd_agrupamento,
	 '' ie_reservado2,
	 null dt_coleta,
	 null dt_prescricao,
	 null hr_prescricao,
	 '' ie_prioridade,
	 '' cd_material,
	 '' cd_instrumento,
	 a.nr_prescricao,
	 0 nr_prescr_consulta,
	 0 ie_origem,
	 '' ds_exames,
	 '' nm_paciente,
	 null dt_idade,
	 null dt_nascimento,
	 null ie_sexo,
	 '' ie_cor,
	 'PESO'  cd_atributo,
	 '' ds,
	 '12' ie_digito,
	 '' cd_exame,
	 ' ' cd_parametro,
	 '' ds_resultado_ant,
	 to_char(coalesce(b.qt_peso,c.qt_peso)) ds_valor,
	 ' ' ds_sigla,
	 ' ' ie_verificacao,
	 a.nr_seq_lote_externo
from 	lab_parametro g,
	prescr_proc_material f,
	material_exame_lab e,
	exame_laboratorio d,
	pessoa_fisica c,
	prescr_medica b,
	prescr_procedimento a
where a.nr_prescricao = b.nr_prescricao
and b.cd_pessoa_fisica = c.cd_pessoa_fisica
and a.nr_seq_exame = d.nr_seq_exame
and a.cd_material_exame = e.cd_material_exame
and a.nr_prescricao 	= f.nr_prescricao
and e.nr_sequencia	= f.nr_seq_material
and g.cd_estabelecimento = b.cd_estabelecimento
and ((a.nr_seq_lab is not null) or (g.ie_padrao_amostra in ('PM','PM11','PMR11','PM13') and obter_equipamento_exame(a.nr_seq_exame,null,'MATRIX') is not null))
and g.ie_padrao_amostra NOT IN ('AMO9','AMO10','AMO11','AM10F','AM11F','AMO13')
and coalesce(b.qt_peso,c.qt_peso) is not null
and a.dt_integracao is null
and length(substr(Obter_Exames_Prescr_Lab_integr(a.nr_prescricao, a.cd_setor_atendimento, a.cd_material_exame, d.nr_seq_grupo, null, 'CI8;20;;'||
	 	substr(obter_compl_desc_mat_lab(a.nr_prescricao, e.nr_sequencia, f.nr_sequencia),1,1),'',d.nr_seq_grupo_imp, nr_seq_lab, g.ie_status_envio, 'MATRIX', null,nr_seq_lote_externo), 1, 160)) > 0
and coalesce(a.ie_suspenso, 'N') = 'N'

union

select	distinct
	 12 cd_tipo_registro,
	 lab_obter_caracteres_amostra(f.cd_barras,g.ie_padrao_amostra) ds_amostra,
	 ' ' ie_ident_anterior,
	 '' ie_reservado,
	 '' ie_repeticao,
	 '' qt_diluicao,
	 null cd_agrupamento,
	 '' ie_reservado2,
	 null dt_coleta,
	 null dt_prescricao,
	 null hr_prescricao,
	 '' ie_prioridade,
	 '' cd_material,
	 '' cd_instrumento,
 	 a.nr_prescricao,
	 0 nr_prescr_consulta,
	 0 ie_origem,
	 '' ds_exames,
	 '' nm_paciente,
	 null dt_idade,
	 null dt_nascimento,
	 '' ie_sexo,
	 '' ie_cor,
	 'PESO' cd_atributo,
	 '' ds,
	 '12' ie_digito,
	 '' cd_exame,
	 ' ' cd_parametro,
	 '' ds_resultado_ant,
	 to_char(coalesce(b.qt_peso,c.qt_peso)) ds_valor,
	 ' ' ds_sigla,
	 ' ' ie_verificacao,
	 a.nr_seq_lote_externo
from 	lab_parametro g,
	prescr_proc_material f,
	material_exame_lab e,
	exame_laboratorio d,
	pessoa_fisica c,
	prescr_medica b,
	prescr_procedimento a,
	prescr_proc_mat_item h
where a.nr_prescricao = b.nr_prescricao
and b.cd_pessoa_fisica = c.cd_pessoa_fisica
and a.nr_seq_exame = d.nr_seq_exame
and a.cd_material_exame = e.cd_material_exame
and a.nr_prescricao 	= f.nr_prescricao
and e.nr_sequencia	= f.nr_seq_material
and h.nr_prescricao = a.nr_prescricao
and h.nr_seq_prescr = a.nr_sequencia
and h.dt_integracao is null
and g.cd_estabelecimento = b.cd_estabelecimento
and coalesce(Obter_Equipamento_Exame(a.nr_seq_exame,null,'MATRIX'),d.cd_exame_integracao) is not null
and g.ie_padrao_amostra IN ('AMO9','AMO10','AMO11','AM10F','AM11F','AMO13')
and a.ie_suspenso <> 'S'
and coalesce(b.qt_peso,c.qt_peso) is not null
and a.dt_integracao is null
and length(substr(obter_lab_integr_item_matrix(a.nr_prescricao,a.cd_setor_atendimento,'CI8','',
		g.ie_status_envio,'MATRIX', f.nr_sequencia,a.nr_seq_lote_externo,b.cd_estabelecimento), 1, 160)) > 0

union

--resultados anteriores
select	distinct
	 14 cd_tipo_registro,
	 Lab_obter_amostra_prescr(g.ie_padrao_amostra,a.nr_prescricao,a.nr_seq_exame,a.nr_sequencia) ds_amostra,
	 ' ' ie_ident_anterior,
	 '' ie_reservado,
	 substr(obter_lab_integr_item_matrix(a.nr_prescricao,a.cd_setor_atendimento,'CI8','',
		g.ie_status_envio,'MATRIX', e.nr_sequencia,a.nr_seq_lote_externo,b.cd_estabelecimento), 1, 160) ie_repeticao,
	 '' qt_diluicao,
	 null cd_agrupamento,
	 '' ie_reservado2,
	 null dt_coleta,
	 to_date(to_char(b.dt_prescricao,'ddmmyyyy'),'ddmmyyyy') dt_prescricao,
 	 to_date(to_char(b.dt_prescricao,'hh24mi'),'hh24mi') hr_prescricao,
	 '' ie_prioridade,
	 '' cd_material,
	 '' cd_instrumento,
	 a.nr_prescricao,
	 null nr_prescr_consulta,
	 0 ie_origem,
	 '' ds_exames,
	 c.nm_pessoa_fisica nm_paciente,
	 null dt_idade,
	 c.dt_nascimento,
	 c.ie_sexo,
	 '' ie_cor,
	 '' cd_atributo,
	 '' ds,
	 '14' ie_digito,
	 coalesce(d.cd_exame_integracao,d.cd_exame) cd_exame,
	 ' ' cd_parametro,
	 lab_obter_result_ant_seq(a.nr_prescricao,d.nr_seq_exame,'R',1) ds_resultado_ant,
	 '' ds_valor,
	 ' ' ds_sigla,
	 ' ' ie_verificacao,
	 a.nr_seq_lote_externo
FROM exame_lab_format_item n, exame_lab_format m, lab_parametro g, prescr_proc_material f, material_exame_lab e, exame_laboratorio d, pessoa_fisica c, prescr_procedimento a, prescr_medica b
LEFT OUTER JOIN exame_lab_resultado i ON (b.nr_prescricao = i.nr_prescricao)
WHERE a.nr_prescricao = b.nr_prescricao and b.cd_pessoa_fisica = c.cd_pessoa_fisica and a.nr_seq_exame = d.nr_seq_exame and n.nr_seq_exame = d.nr_seq_exame and a.cd_material_exame = e.cd_material_exame and a.nr_prescricao 	= f.nr_prescricao and e.nr_sequencia	= f.nr_seq_material  and m.ie_padrao = 'S' and m.ie_mapa_laudo = 'L' and n.nr_seq_formato = m.nr_seq_formato and m.nr_seq_exame = d.nr_seq_exame and g.cd_estabelecimento = b.cd_estabelecimento and coalesce(Obter_Equipamento_Exame(a.nr_seq_exame,null,'MATRIX'),d.cd_exame_integracao) is not null and ((a.nr_seq_lab is not null) or (g.ie_padrao_amostra in ('PM','PM11','PMR11','PM13'))) and g.ie_padrao_amostra NOT IN ('AMO9','AMO10','AMO11','AM10F','AM11F','AMO13') and a.ie_suspenso <> 'S' and a.dt_integracao is null and lab_obter_result_ant_seq(a.nr_prescricao,a.nr_seq_exame,'DH',1) is not null and m.dt_atualizacao     = (select max(dt_atualizacao)
		from   exame_lab_format
		where  ie_padrao = 'S'
		and    ie_mapa_laudo = 'L'
		and    nr_seq_exame = d.nr_seq_exame)
 
union

select	distinct
	 14 cd_tipo_registro,
	 Lab_obter_amostra_prescr(g.ie_padrao_amostra,a.nr_prescricao,a.nr_seq_exame,a.nr_sequencia) ds_amostra,
	 ' ' ie_ident_anterior,
	 '' ie_reservado,
	 substr(obter_lab_integr_item_matrix(a.nr_prescricao,a.cd_setor_atendimento,'CI8','',
		g.ie_status_envio,'MATRIX', e.nr_sequencia,a.nr_seq_lote_externo,b.cd_estabelecimento), 1, 160) ie_repeticao,
	 '' qt_diluicao,
	 null cd_agrupamento,
	 '' ie_reservado2,
	 null dt_coleta,
	 to_date(to_char(b.dt_prescricao,'ddmmyyyy'),'ddmmyyyy') dt_prescricao,
 	 to_date(to_char(b.dt_prescricao,'hh24mi'),'hh24mi') hr_prescricao,
	 '' ie_prioridade,
	 '' cd_material,
	 '' cd_instrumento,
	 a.nr_prescricao,
	 null nr_prescr_consulta,
	 0 ie_origem,
	 '' ds_exames,
	 c.nm_pessoa_fisica nm_paciente,
	 null dt_idade,
	 c.dt_nascimento,
	 c.ie_sexo,
	 '' ie_cor,
	 '' cd_atributo,
	 '' ds,
	 '14' ie_digito,
	 coalesce(d.cd_exame_integracao,d.cd_exame) cd_exame,
	 ' ' cd_parametro,
	 lab_obter_result_ant_seq(a.nr_prescricao,d.nr_seq_exame,'R',1) ds_resultado_ant,
	 '' ds_valor,
	 ' ' ds_sigla,
	 ' ' ie_verificacao,
	 a.nr_seq_lote_externo
from 	lab_parametro g,
	prescr_proc_material f,
	material_exame_lab e,
	exame_laboratorio d,
	pessoa_fisica c,
	exame_lab_format_item n,
	exame_lab_format m,
	exame_lab_resultado i,
	prescr_medica b,
	prescr_procedimento a,
	prescr_proc_mat_item h
where a.nr_prescricao = b.nr_prescricao
and b.cd_pessoa_fisica = c.cd_pessoa_fisica
and a.nr_seq_exame = d.nr_seq_exame
and a.cd_material_exame = e.cd_material_exame
and	n.nr_seq_exame = d.nr_seq_exame
and a.nr_prescricao 	= f.nr_prescricao
and e.nr_sequencia	= f.nr_seq_material
and h.nr_prescricao = a.nr_prescricao
and h.nr_seq_prescr = a.nr_sequencia
and m.ie_padrao = 'S'
and m.ie_mapa_laudo = 'L'
and n.nr_seq_formato = m.nr_seq_formato
and m.nr_seq_exame = d.nr_seq_exame
and h.dt_integracao is null
and g.cd_estabelecimento = b.cd_estabelecimento
and coalesce(Obter_Equipamento_Exame(a.nr_seq_exame,null,'MATRIX'),d.cd_exame_integracao) is not null
and g.ie_padrao_amostra IN ('AMO9','AMO10','AMO11','AM10F','AM11F','AMO13')
and a.ie_suspenso <> 'S'
and a.dt_integracao is null
and m.dt_atualizacao     = (select max(dt_atualizacao)
		from   exame_lab_format
		where  ie_padrao = 'S'
		and    ie_mapa_laudo = 'L'
		and    nr_seq_exame = d.nr_seq_exame)

union

--resultados anteriores analitos
select	distinct
	 14 cd_tipo_registro,
	 Lab_obter_amostra_prescr(g.ie_padrao_amostra,a.nr_prescricao,a.nr_seq_exame,a.nr_sequencia) ds_amostra,
	 ' ' ie_ident_anterior,
	 '' ie_reservado,
	 substr(obter_lab_integr_item_matrix(a.nr_prescricao,a.cd_setor_atendimento,'CI8','',
		g.ie_status_envio,'MATRIX', e.nr_sequencia,a.nr_seq_lote_externo,b.cd_estabelecimento), 1, 160) ie_repeticao,
	 '' qt_diluicao,
	 null cd_agrupamento,
	 '' ie_reservado2,
	 null dt_coleta,
	 to_date(to_char(b.dt_prescricao,'ddmmyyyy'),'ddmmyyyy') dt_prescricao,
 	 to_date(to_char(b.dt_prescricao,'hh24mi'),'hh24mi') hr_prescricao,
	 '' ie_prioridade,
	 '' cd_material,
	 '' cd_instrumento,
	 a.nr_prescricao,
	 null nr_prescr_consulta,
	 0 ie_origem,
	 '' ds_exames,
	 c.nm_pessoa_fisica nm_paciente,
	 null dt_idade,
	 c.dt_nascimento,
	 c.ie_sexo,
	 '' ie_cor,
	 '' cd_atributo,
	 '' ds,
	 '14' ie_digito,
	 coalesce(d.cd_exame_integracao,d.cd_exame) cd_exame,
	 ' ' cd_parametro,
	 lab_obter_result_ant_seq(a.nr_prescricao,n.nr_seq_exame,'R',1) ds_resultado_ant,
	 '' ds_valor,
	 ' ' ds_sigla,
	 ' ' ie_verificacao,
	 a.nr_seq_lote_externo
FROM exame_lab_format_item n, exame_lab_format m, lab_parametro g, prescr_proc_material f, material_exame_lab e, exame_laboratorio d, pessoa_fisica c, prescr_procedimento a, prescr_medica b
LEFT OUTER JOIN exame_lab_resultado i ON (b.nr_prescricao = i.nr_prescricao)
WHERE a.nr_prescricao = b.nr_prescricao and b.cd_pessoa_fisica = c.cd_pessoa_fisica and a.nr_seq_exame = d.nr_seq_exame and n.nr_seq_exame = d.nr_seq_exame and a.cd_material_exame = e.cd_material_exame and a.nr_prescricao 	= f.nr_prescricao and e.nr_sequencia	= f.nr_seq_material  and m.ie_padrao = 'S' and m.ie_mapa_laudo = 'L' and n.nr_seq_formato = m.nr_seq_formato and m.nr_seq_exame = d.nr_seq_exame and g.cd_estabelecimento = b.cd_estabelecimento and coalesce(Obter_Equipamento_Exame(n.nr_seq_exame,null,'MATRIX'),d.cd_exame_integracao) is not null and ((a.nr_seq_lab is not null) or (g.ie_padrao_amostra in ('PM','PM11','PMR11','PM13'))) and g.ie_padrao_amostra NOT IN ('AMO9','AMO10','AMO11','AM10F','AM11F','AMO13') and a.ie_suspenso <> 'S' and a.dt_integracao is null and d.nr_seq_superior is not null and lab_obter_result_ant_seq(a.nr_prescricao,n.nr_seq_exame,'DH',1) is not null and m.dt_atualizacao     = (select max(dt_atualizacao)
		from   exame_lab_format
		where  ie_padrao = 'S'
		and    ie_mapa_laudo = 'L'
		and    nr_seq_exame = d.nr_seq_exame)
 
union

select	distinct
	 14 cd_tipo_registro,
	 Lab_obter_amostra_prescr(g.ie_padrao_amostra,a.nr_prescricao,a.nr_seq_exame,a.nr_sequencia) ds_amostra,
	 ' ' ie_ident_anterior,
	 '' ie_reservado,
	 substr(obter_lab_integr_item_matrix(a.nr_prescricao,a.cd_setor_atendimento,'CI8','',
		g.ie_status_envio,'MATRIX', e.nr_sequencia,a.nr_seq_lote_externo,b.cd_estabelecimento), 1, 160) ie_repeticao,
	 '' qt_diluicao,
	 null cd_agrupamento,
	 '' ie_reservado2,
	 null dt_coleta,
	 to_date(to_char(b.dt_prescricao,'ddmmyyyy'),'ddmmyyyy') dt_prescricao,
 	 to_date(to_char(b.dt_prescricao,'hh24mi'),'hh24mi') hr_prescricao,
	 '' ie_prioridade,
	 '' cd_material,
	 '' cd_instrumento,
	 a.nr_prescricao,
	 null nr_prescr_consulta,
	 0 ie_origem,
	 '' ds_exames,
	 c.nm_pessoa_fisica nm_paciente,
	 null dt_idade,
	 c.dt_nascimento,
	 c.ie_sexo,
	 '' ie_cor,
	 '' cd_atributo,
	 '' ds,
	 '14' ie_digito,
	 coalesce(d.cd_exame_integracao,d.cd_exame) cd_exame,
	 ' ' cd_parametro,
	 lab_obter_result_ant_seq(a.nr_prescricao,d.nr_seq_exame,'R',1) ds_resultado_ant,
	 '' ds_valor,
	 ' ' ds_sigla,
	 ' ' ie_verificacao,
	 a.nr_seq_lote_externo
from 	lab_parametro g,
	prescr_proc_material f,
	material_exame_lab e,
	exame_laboratorio d,
	pessoa_fisica c,
	exame_lab_format_item n,
	exame_lab_format m,
	exame_lab_resultado i,
	prescr_medica b,
	prescr_procedimento a,
	prescr_proc_mat_item h
where a.nr_prescricao = b.nr_prescricao
and b.cd_pessoa_fisica = c.cd_pessoa_fisica
and a.nr_seq_exame = d.nr_seq_exame
and a.cd_material_exame = e.cd_material_exame
and	n.nr_seq_exame = d.nr_seq_exame
and n.nr_seq_formato = m.nr_seq_formato
and a.nr_prescricao 	= f.nr_prescricao
and e.nr_sequencia	= f.nr_seq_material
and h.nr_prescricao = a.nr_prescricao
and h.nr_seq_prescr = a.nr_sequencia
and m.ie_padrao = 'S'
and m.ie_mapa_laudo = 'L'
and m.nr_seq_exame = d.nr_seq_exame
and h.dt_integracao is null
and g.cd_estabelecimento = b.cd_estabelecimento
and coalesce(Obter_Equipamento_Exame(n.nr_seq_exame,null,'MATRIX'),d.cd_exame_integracao) is not null
and g.ie_padrao_amostra IN ('AMO9','AMO10','AMO11','AM10F','AM11F','AMO13')
and a.ie_suspenso <> 'S'
and a.dt_integracao is null
and d.nr_seq_superior is not null
and m.dt_atualizacao     = (select max(dt_atualizacao)
		from   exame_lab_format
		where  ie_padrao = 'S'
		and    ie_mapa_laudo = 'L'
		and    nr_seq_exame = d.nr_seq_exame)

union

--atributos
select	distinct
	 15 cd_tipo_registro,
	 Lab_obter_amostra_prescr(g.ie_padrao_amostra,a.nr_prescricao,a.nr_seq_exame,a.nr_sequencia) ds_amostra,
	 ' ' ie_ident_anterior,
	 '' ie_reservado,
	 substr(obter_lab_integr_item_matrix(a.nr_prescricao,a.cd_setor_atendimento,'CI8','',
		g.ie_status_envio,'MATRIX', e.nr_sequencia,a.nr_seq_lote_externo,b.cd_estabelecimento), 1, 160) ie_repeticao,
	 '' qt_diluicao,
	 null cd_agrupamento,
	 '' ie_reservado2,
	 null dt_coleta,
	 to_date(to_char(b.dt_prescricao,'ddmmyyyy'),'ddmmyyyy') dt_prescricao,
 	 to_date(to_char(b.dt_prescricao,'hh24mi'),'hh24mi') hr_prescricao,
	 '' ie_prioridade,
	 '' cd_material,
	 '' cd_instrumento,
	 a.nr_prescricao,
	 null nr_prescr_consulta,
	 0 ie_origem,
	 '' ds_exames,
	 c.nm_pessoa_fisica nm_paciente,
	 null dt_idade,
	 c.dt_nascimento,
	 c.ie_sexo,
	 '' ie_cor,
	 ' ' cd_atributo,
	 '' dsd,
	 '15' ie_digito,
	 coalesce(d.cd_exame_integracao,d.cd_exame) cd_exame,
	 ' ' cd_parametro,
	 '' ds_resultado_ant,
	 ' ' ds_valor,
	 ' ' ds_sigla,
	 ' ' ie_verificacao,
	 a.nr_seq_lote_externo
FROM exame_lab_format_item n, exame_lab_format m, lab_parametro g, prescr_proc_material f, material_exame_lab e, exame_laboratorio d, pessoa_fisica c, prescr_procedimento a, prescr_medica b
LEFT OUTER JOIN exame_lab_resultado i ON (b.nr_prescricao = i.nr_prescricao)
WHERE a.nr_prescricao = b.nr_prescricao and b.cd_pessoa_fisica = c.cd_pessoa_fisica and a.nr_seq_exame = d.nr_seq_exame and n.nr_seq_exame = d.nr_seq_exame and a.cd_material_exame = e.cd_material_exame and a.nr_prescricao 	= f.nr_prescricao and e.nr_sequencia	= f.nr_seq_material  and m.ie_padrao = 'S' and m.ie_mapa_laudo = 'L' and n.nr_seq_formato = m.nr_seq_formato and m.nr_seq_exame = d.nr_seq_exame and g.cd_estabelecimento = b.cd_estabelecimento and coalesce(Obter_Equipamento_Exame(a.nr_seq_exame,null,'MATRIX'),d.cd_exame_integracao) is not null and ((a.nr_seq_lab is not null) or (g.ie_padrao_amostra in ('PM','PM11','PMR11','PM13'))) and g.ie_padrao_amostra NOT IN ('AMO9','AMO10','AMO11','AM10F','AM11F','AMO13') and a.ie_suspenso <> 'S' and a.dt_integracao is null and lab_obter_result_ant_seq(a.nr_prescricao,a.nr_seq_exame,'DH',1) is not null and m.dt_atualizacao     = (select max(dt_atualizacao)
		from   exame_lab_format
		where  ie_padrao = 'S'
		and    ie_mapa_laudo = 'L'
		and    nr_seq_exame = d.nr_seq_exame)
 
union

select	distinct
	 15 cd_tipo_registro,
	 Lab_obter_amostra_prescr(g.ie_padrao_amostra,a.nr_prescricao,a.nr_seq_exame,a.nr_sequencia) ds_amostra,
	 ' ' ie_ident_anterior,
	 '' ie_reservado,
	 substr(obter_lab_integr_item_matrix(a.nr_prescricao,a.cd_setor_atendimento,'CI8','',
		g.ie_status_envio,'MATRIX', e.nr_sequencia,a.nr_seq_lote_externo,b.cd_estabelecimento), 1, 160) ie_repeticao,
	 '' qt_diluicao,
	 null cd_agrupamento,
	 '' ie_reservado2,
	 null dt_coleta,
	 to_date(to_char(b.dt_prescricao,'ddmmyyyy'),'ddmmyyyy') dt_prescricao,
 	 to_date(to_char(b.dt_prescricao,'hh24mi'),'hh24mi') hr_prescricao,
	 '' ie_prioridade,
	 '' cd_material,
	 '' cd_instrumento,
	 a.nr_prescricao,
	 null nr_prescr_consulta,
	 0 ie_origem,
	 '' ds_exames,
	 c.nm_pessoa_fisica nm_paciente,
	 null dt_idade,
	 c.dt_nascimento,
	 c.ie_sexo,
	 '' ie_cor,
	 ' ' cd_atributo,
	 ' ' ds_valor,
	 '15' ie_digito,
	 coalesce(d.cd_exame_integracao,d.cd_exame) cd_exame,
	 ' ' cd_parametro,
	 '' ds_resultado_ant,
	 '' ds,
	 ' ' ds_sigla,
	 ' ' ie_verificacao,
	 a.nr_seq_lote_externo
from 	lab_parametro g,
	prescr_proc_material f,
	material_exame_lab e,
	exame_laboratorio d,
	pessoa_fisica c,
	exame_lab_format_item n,
	exame_lab_format m,
	exame_lab_resultado i,
	prescr_medica b,
	prescr_procedimento a,
	prescr_proc_mat_item h
where a.nr_prescricao = b.nr_prescricao
and b.cd_pessoa_fisica = c.cd_pessoa_fisica
and a.nr_seq_exame = d.nr_seq_exame
and a.cd_material_exame = e.cd_material_exame
and n.nr_seq_exame = d.nr_seq_exame
and a.nr_prescricao 	= f.nr_prescricao
and e.nr_sequencia	= f.nr_seq_material
and h.nr_prescricao = a.nr_prescricao
and h.nr_seq_prescr = a.nr_sequencia
and m.ie_padrao = 'S'
and m.ie_mapa_laudo = 'L'
and n.nr_seq_formato = m.nr_seq_formato
and m.nr_seq_exame = d.nr_seq_exame
and h.dt_integracao is null
and g.cd_estabelecimento = b.cd_estabelecimento
and coalesce(Obter_Equipamento_Exame(a.nr_seq_exame,null,'MATRIX'),d.cd_exame_integracao) is not null
and g.ie_padrao_amostra IN ('AMO9','AMO10','AMO11','AM10F','AM11F','AMO13')
and a.ie_suspenso <> 'S'
and a.dt_integracao is null
and m.dt_atualizacao     = (select max(dt_atualizacao)
		from   exame_lab_format
		where  ie_padrao = 'S'
		and    ie_mapa_laudo = 'L'
		and    nr_seq_exame = d.nr_seq_exame);

