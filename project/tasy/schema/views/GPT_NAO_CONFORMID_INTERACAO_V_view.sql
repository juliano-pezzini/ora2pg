-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';

CREATE OR REPLACE VIEW gpt_nao_conformid_interacao_v (nr_sequencia, ds_material, ie_libera, ds_erro_compl, ds_dose_intervalo, ds_justificativa, ds_observacao, ds_orientacao, dt_prescricao, ds_incons_farmacia, nr_prescricao, ie_ciente, ds_motivo, cd_material, nr_atendimento, cd_pessoa_fisica, ie_tipo_perfil, ie_cpoe, ie_quimio, dt_confirmacao, nm_usuario_ciente, nr_seq_mat_cpoe, ie_origem_informacao, ds_origem_informacao) AS select
	b.nr_sequencia nr_sequencia,
	substr(obter_desc_material(b.cd_material_interacao), 1, 255) ds_material,
	'S' ie_libera,
	GPT_obter_nome_api('MDX', b.cd_api) ds_erro_compl,
	substr(obter_um_dosagem_prescr(c.nr_prescricao, c.nr_sequencia), 1, 100) ds_dose_intervalo,
	b.ds_justificativa,
	null ds_observacao,
	b.ds_resultado_curto ds_orientacao,
	a.dt_atualizacao_nrec dt_prescricao,
	null ds_incons_farmacia,
	cpoe_obter_prescr_original(a.nr_sequencia, 'M', a.nr_atendimento) nr_prescricao,
	coalesce(b.ie_ciente, 'N') ie_ciente,
	null ds_motivo,
	cast(b.cd_material_interacao as varchar(10)) cd_material,
	a.nr_atendimento,
	a.cd_pessoa_fisica,
	'A' ie_tipo_perfil,
	'S' ie_cpoe,
	'N' ie_quimio,
	b.dt_confirmacao,
	b.nm_usuario_ciente,
	c.nr_seq_mat_cpoe,
	'MDX' ie_origem_informacao,
	obter_desc_expressao(348528) ds_origem_informacao
FROM
	cpoe_material 			a,
	cpoe_justif_interacao	b,
	prescr_material 		c
where (a.nr_sequencia = b.nr_seq_cpoe_princ or a.nr_seq_procedimento = b.nr_seq_proc_princ)
	and to_char(a.cd_material) = b.cd_material_interacao
	and c.nr_seq_mat_cpoe = a.nr_sequencia
	and c.nr_prescricao = cpoe_obter_prescr_original(a.nr_sequencia, 'M', a.nr_atendimento)
	and c.cd_material = a.cd_material
	and (a.dt_lib_suspensao is null or a.dt_suspensao > LOCALTIMESTAMP)
	and b.ie_integracao = 'MDX'

union all

select
	b.nr_sequencia nr_sequencia,
	substr(obter_desc_material(b.cd_material_interacao), 1, 255) ds_material,
	'S' ie_libera,
	GPT_obter_nome_api('MDX', b.cd_api) ds_erro_compl,
	substr(obter_um_dosagem_prescr(c.nr_prescricao, c.nr_sequencia), 1, 100) ds_dose_intervalo,
	b.ds_justificativa,
	null ds_observacao,
	b.ds_resultado_curto ds_orientacao,
	a.dt_atualizacao_nrec dt_prescricao,
	null ds_incons_farmacia,
	cpoe_obter_prescr_original(a.nr_sequencia, 'M', a.nr_atendimento) nr_prescricao,
	coalesce(b.ie_ciente, 'N') ie_ciente,
	null ds_motivo,
	cast(b.cd_material_interacao as varchar(10)) cd_material,
	a.nr_atendimento,
	a.cd_pessoa_fisica,
	'A' ie_tipo_perfil,
	'S' ie_cpoe,
	'N' ie_quimio,
	b.dt_confirmacao,
	b.nm_usuario_ciente,
	c.nr_seq_mat_cpoe,
	'MDX' ie_origem_informacao,
	obter_desc_expressao(348528) ds_origem_informacao
from
	cpoe_material 			a,
	cpoe_justif_interacao	b,
	prescr_material 		c
where (a.nr_sequencia = b.nr_seq_cpoe_princ or a.nr_seq_procedimento = b.nr_seq_proc_princ)
	and to_char(a.cd_mat_comp1) = b.cd_material_interacao
	and c.nr_seq_mat_cpoe = a.nr_sequencia
	and c.nr_prescricao = cpoe_obter_prescr_original(a.nr_sequencia, 'M', a.nr_atendimento)
	and c.cd_material = a.cd_mat_comp1
	and (a.dt_lib_suspensao is null or a.dt_suspensao > LOCALTIMESTAMP)
	and b.ie_integracao = 'MDX'

union all

select
	b.nr_sequencia nr_sequencia,
	substr(obter_desc_material(b.cd_material_interacao), 1, 255) ds_material,
	'S' ie_libera,
	GPT_obter_nome_api('MDX', b.cd_api) ds_erro_compl,
	substr(obter_um_dosagem_prescr(c.nr_prescricao, c.nr_sequencia), 1, 100) ds_dose_intervalo,
	b.ds_justificativa,
	null ds_observacao,
	b.ds_resultado_curto ds_orientacao,
	a.dt_atualizacao_nrec dt_prescricao,
	null ds_incons_farmacia,
	cpoe_obter_prescr_original(a.nr_sequencia, 'M', a.nr_atendimento) nr_prescricao,
	coalesce(b.ie_ciente, 'N') ie_ciente,
	null ds_motivo,
	cast(b.cd_material_interacao as varchar(10)) cd_material,
	a.nr_atendimento,
	a.cd_pessoa_fisica,
	'A' ie_tipo_perfil,
	'S' ie_cpoe,
	'N' ie_quimio,
	b.dt_confirmacao,
	b.nm_usuario_ciente,
	c.nr_seq_mat_cpoe,
	'MDX' ie_origem_informacao,
	obter_desc_expressao(348528) ds_origem_informacao
from
	cpoe_material 			a,
	cpoe_justif_interacao	b,
	prescr_material 		c
where (a.nr_sequencia = b.nr_seq_cpoe_princ or a.nr_seq_procedimento = b.nr_seq_proc_princ)
	and to_char(a.cd_mat_comp2) = b.cd_material_interacao
	and c.nr_seq_mat_cpoe = a.nr_sequencia
	and c.nr_prescricao = cpoe_obter_prescr_original(a.nr_sequencia, 'M', a.nr_atendimento)
	and c.cd_material = a.cd_mat_comp2
	and (a.dt_lib_suspensao is null or a.dt_suspensao > LOCALTIMESTAMP)
	and b.ie_integracao = 'MDX'

union all

select
	b.nr_sequencia nr_sequencia,
	substr(obter_desc_material(b.cd_material_interacao), 1, 255) ds_material,
	'S' ie_libera,
	GPT_obter_nome_api('MDX', b.cd_api) ds_erro_compl,
	substr(obter_um_dosagem_prescr(c.nr_prescricao, c.nr_sequencia), 1, 100) ds_dose_intervalo,
	b.ds_justificativa,
	null ds_observacao,
	b.ds_resultado_curto ds_orientacao,
	a.dt_atualizacao_nrec dt_prescricao,
	null ds_incons_farmacia,
	cpoe_obter_prescr_original(a.nr_sequencia, 'M', a.nr_atendimento) nr_prescricao,
	coalesce(b.ie_ciente, 'N') ie_ciente,
	null ds_motivo,
	cast(b.cd_material_interacao as varchar(10)) cd_material,
	a.nr_atendimento,
	a.cd_pessoa_fisica,
	'A' ie_tipo_perfil,
	'S' ie_cpoe,
	'N' ie_quimio,
	b.dt_confirmacao,
	b.nm_usuario_ciente,
	c.nr_seq_mat_cpoe,
	'MDX' ie_origem_informacao,
	obter_desc_expressao(348528) ds_origem_informacao
from
	cpoe_material 			a,
	cpoe_justif_interacao	b,
	prescr_material 		c
where (a.nr_sequencia = b.nr_seq_cpoe_princ or a.nr_seq_procedimento = b.nr_seq_proc_princ)
	and to_char(a.cd_mat_comp3) = b.cd_material_interacao
	and c.nr_seq_mat_cpoe = a.nr_sequencia
	and c.nr_prescricao = cpoe_obter_prescr_original(a.nr_sequencia, 'M', a.nr_atendimento)
	and c.cd_material = a.cd_mat_comp3
	and (a.dt_lib_suspensao is null or a.dt_suspensao > LOCALTIMESTAMP)
	and b.ie_integracao = 'MDX'

union all

select
	b.nr_sequencia nr_sequencia,
	substr(obter_desc_material(b.cd_material_interacao), 1, 255) ds_material,
	'S' ie_libera,
	GPT_obter_nome_api('MDX', b.cd_api) ds_erro_compl,
	substr(obter_um_dosagem_prescr(c.nr_prescricao, c.nr_sequencia), 1, 100) ds_dose_intervalo,
	b.ds_justificativa,
	null ds_observacao,
	b.ds_resultado_curto ds_orientacao,
	a.dt_atualizacao_nrec dt_prescricao,
	null ds_incons_farmacia,
	cpoe_obter_prescr_original(a.nr_sequencia, 'M', a.nr_atendimento) nr_prescricao,
	coalesce(b.ie_ciente, 'N') ie_ciente,
	null ds_motivo,
	cast(b.cd_material_interacao as varchar(10)) cd_material,
	a.nr_atendimento,
	a.cd_pessoa_fisica,
	'A' ie_tipo_perfil,
	'S' ie_cpoe,
	'N' ie_quimio,
	b.dt_confirmacao,
	b.nm_usuario_ciente,
	c.nr_seq_mat_cpoe,
	'MDX' ie_origem_informacao,
	obter_desc_expressao(348528) ds_origem_informacao
from
	cpoe_material 			a,
	cpoe_justif_interacao	b,
	prescr_material 		c
where (a.nr_sequencia = b.nr_seq_cpoe_princ or a.nr_seq_procedimento = b.nr_seq_proc_princ)
	and to_char(a.cd_mat_comp4) = b.cd_material_interacao
	and c.nr_seq_mat_cpoe = a.nr_sequencia
	and c.nr_prescricao = cpoe_obter_prescr_original(a.nr_sequencia, 'M', a.nr_atendimento)
	and c.cd_material = a.cd_mat_comp4
	and (a.dt_lib_suspensao is null or a.dt_suspensao > LOCALTIMESTAMP)
	and b.ie_integracao = 'MDX'

union all

select
	b.nr_sequencia nr_sequencia,
	substr(obter_desc_material(b.cd_material_interacao), 1, 255) ds_material,
	'S' ie_libera,
	GPT_obter_nome_api('MDX', b.cd_api) ds_erro_compl,
	substr(obter_um_dosagem_prescr(c.nr_prescricao, c.nr_sequencia), 1, 100) ds_dose_intervalo,
	b.ds_justificativa,
	null ds_observacao,
	b.ds_resultado_curto ds_orientacao,
	a.dt_atualizacao_nrec dt_prescricao,
	null ds_incons_farmacia,
	cpoe_obter_prescr_original(a.nr_sequencia, 'M', a.nr_atendimento) nr_prescricao,
	coalesce(b.ie_ciente, 'N') ie_ciente,
	null ds_motivo,
	cast(b.cd_material_interacao as varchar(10)) cd_material,
	a.nr_atendimento,
	a.cd_pessoa_fisica,
	'A' ie_tipo_perfil,
	'S' ie_cpoe,
	'N' ie_quimio,
	b.dt_confirmacao,
	b.nm_usuario_ciente,
	c.nr_seq_mat_cpoe,
	'MDX' ie_origem_informacao,
	obter_desc_expressao(348528) ds_origem_informacao
from
	cpoe_material 			a,
	cpoe_justif_interacao	b,
	prescr_material 		c
where (a.nr_sequencia = b.nr_seq_cpoe_princ or a.nr_seq_procedimento = b.nr_seq_proc_princ)
	and to_char(a.cd_mat_comp5) = b.cd_material_interacao
	and c.nr_seq_mat_cpoe = a.nr_sequencia
	and c.nr_prescricao = cpoe_obter_prescr_original(a.nr_sequencia, 'M', a.nr_atendimento)
	and c.cd_material = a.cd_mat_comp5
	and (a.dt_lib_suspensao is null or a.dt_suspensao > LOCALTIMESTAMP)
	and b.ie_integracao = 'MDX'

union all

select
	b.nr_sequencia nr_sequencia,
	substr(obter_desc_material(b.cd_material_interacao), 1, 255) ds_material,
	'S' ie_libera,
	GPT_obter_nome_api('MDX', b.cd_api) ds_erro_compl,
	substr(obter_um_dosagem_prescr(c.nr_prescricao, c.nr_sequencia), 1, 100) ds_dose_intervalo,
	b.ds_justificativa,
	null ds_observacao,
	b.ds_resultado_curto ds_orientacao,
	a.dt_atualizacao_nrec dt_prescricao,
	null ds_incons_farmacia,
	cpoe_obter_prescr_original(a.nr_sequencia, 'M', a.nr_atendimento) nr_prescricao,
	coalesce(b.ie_ciente, 'N') ie_ciente,
	null ds_motivo,
	cast(b.cd_material_interacao as varchar(10)) cd_material,
	a.nr_atendimento,
	a.cd_pessoa_fisica,
	'A' ie_tipo_perfil,
	'S' ie_cpoe,
	'N' ie_quimio,
	b.dt_confirmacao,
	b.nm_usuario_ciente,
	c.nr_seq_mat_cpoe,
	'MDX' ie_origem_informacao,
	obter_desc_expressao(348528) ds_origem_informacao
from
	cpoe_material 			a,
	cpoe_justif_interacao	b,
	prescr_material 		c
where (a.nr_sequencia = b.nr_seq_cpoe_princ or a.nr_seq_procedimento = b.nr_seq_proc_princ)
	and to_char(a.cd_mat_comp6) = b.cd_material_interacao
	and c.nr_seq_mat_cpoe = a.nr_sequencia
	and c.nr_prescricao = cpoe_obter_prescr_original(a.nr_sequencia, 'M', a.nr_atendimento)
	and c.cd_material = a.cd_mat_comp6
	and (a.dt_lib_suspensao is null or a.dt_suspensao > LOCALTIMESTAMP)
	and b.ie_integracao = 'MDX'

union all

select
	b.nr_sequencia nr_sequencia,
	substr(obter_desc_material(b.cd_material_interacao), 1, 255) ds_material,
	'S' ie_libera,
	GPT_obter_nome_api('MDX', b.cd_api) ds_erro_compl,
	substr(obter_um_dosagem_prescr(c.nr_prescricao, c.nr_sequencia), 1, 100) ds_dose_intervalo,
	b.ds_justificativa,
	null ds_observacao,
	b.ds_resultado_curto ds_orientacao,
	a.dt_atualizacao_nrec dt_prescricao,
	null ds_incons_farmacia,
	cpoe_obter_prescr_original(a.nr_sequencia, 'M', a.nr_atendimento) nr_prescricao,
	coalesce(b.ie_ciente, 'N') ie_ciente,
	null ds_motivo,
	cast(b.cd_material_interacao as varchar(10)) cd_material,
	a.nr_atendimento,
	a.cd_pessoa_fisica,
	'A' ie_tipo_perfil,
	'S' ie_cpoe,
	'N' ie_quimio,
	b.dt_confirmacao,
	b.nm_usuario_ciente,
	c.nr_seq_mat_cpoe,
	'MDX' ie_origem_informacao,
	obter_desc_expressao(348528) ds_origem_informacao
from
	cpoe_material 			a,
	cpoe_justif_interacao	b,
	prescr_material 		c
where (a.nr_sequencia = b.nr_seq_cpoe_princ or a.nr_seq_procedimento = b.nr_seq_proc_princ)
	and to_char(a.cd_mat_comp7) = b.cd_material_interacao
	and c.nr_seq_mat_cpoe = a.nr_sequencia
	and c.nr_prescricao = cpoe_obter_prescr_original(a.nr_sequencia, 'M', a.nr_atendimento)
	and c.cd_material = a.cd_mat_comp7
	and (a.dt_lib_suspensao is null or a.dt_suspensao > LOCALTIMESTAMP)
	and b.ie_integracao = 'MDX'

union all

select
	d.nr_sequencia nr_sequencia,
	substr(obter_desc_material(d.cd_material), 1, 255) ds_material,
	'S' ie_libera,
	GPT_obter_nome_api('LXC', d.cd_api) ds_erro_compl,
	substr(obter_um_dosagem_prescr(c.nr_prescricao, c.nr_sequencia), 1, 100) ds_dose_intervalo,
	b.ds_justificativa,
	null ds_observacao,
	coalesce(d.ds_resultado_curto, b.ds_resultado_curto) ds_orientacao,
	a.dt_atualizacao_nrec dt_prescricao,
	null ds_incons_farmacia,
	cpoe_obter_prescr_original(a.nr_sequencia, 'M', a.nr_atendimento) nr_prescricao,
	coalesce(d.ie_ciente, 'N') ie_ciente,
	null ds_motivo,
	cast(d.cd_material as varchar(10)) cd_material,
	a.nr_atendimento,
	a.cd_pessoa_fisica,
	'A' ie_tipo_perfil,
	'S' ie_cpoe,
	'N' ie_quimio,
	b.dt_confirmacao,
	b.nm_usuario_ciente,
	c.nr_seq_mat_cpoe,
	'LXC' ie_origem_informacao,
	obter_desc_expressao(1037238) ds_origem_informacao
FROM prescr_material c, cpoe_material a, alerta_api d
LEFT OUTER JOIN cpoe_justif_interacao b ON (d.nr_seq_cpoe = b.nr_seq_cpoe_princ AND d.cd_api = b.cd_api AND d.nr_gravidade = b.nr_gravidade AND d.ds_resultado_curto = b.ds_resultado_curto)
, coalesce(d
LEFT OUTER JOIN coalesce(b ON (coalesce(d.ds_sub_tipo_api, 'XPTO') = coalesce(b.ds_sub_tipo_api, 'XPTO'))
WHERE to_char(a.cd_material) = b.cd_material_interacao and c.nr_seq_mat_cpoe = a.nr_sequencia and c.nr_prescricao = cpoe_obter_prescr_original(a.nr_sequencia, 'M', a.nr_atendimento) and c.cd_material = a.cd_material and a.nr_sequencia = d.nr_seq_cpoe and a.cd_material = d.cd_material     and (a.dt_lib_suspensao is null or a.dt_suspensao > LOCALTIMESTAMP) and coalesce(d.ie_status_requisicao, 'XPTO')  = 'XPTO'

union all

select
	d.nr_sequencia nr_sequencia,
	substr(obter_desc_material(d.cd_material), 1, 255) ds_material,
	'S' ie_libera,
	GPT_obter_nome_api('LXC', d.cd_api) ds_erro_compl,
	substr(obter_um_dosagem_prescr(c.nr_prescricao, c.nr_sequencia), 1, 100) ds_dose_intervalo,
	b.ds_justificativa,
	null ds_observacao,
	coalesce(d.ds_resultado_curto, b.ds_resultado_curto) ds_orientacao,
	a.dt_atualizacao_nrec dt_prescricao,
	null ds_incons_farmacia,
	cpoe_obter_prescr_original(a.nr_sequencia, 'M', a.nr_atendimento) nr_prescricao,
	coalesce(d.ie_ciente, 'N') ie_ciente,
	null ds_motivo,
	cast(d.cd_material as varchar(10)) cd_material,
	a.nr_atendimento,
	a.cd_pessoa_fisica,
	'A' ie_tipo_perfil,
	'S' ie_cpoe,
	'N' ie_quimio,
	b.dt_confirmacao,
	b.nm_usuario_ciente,
	c.nr_seq_mat_cpoe,
	'LXC' ie_origem_informacao,
	obter_desc_expressao(1037238) ds_origem_informacao
FROM prescr_material c, cpoe_material a, alerta_api d
LEFT OUTER JOIN cpoe_justif_interacao b ON (d.nr_seq_cpoe = b.nr_seq_cpoe_princ AND d.cd_api = b.cd_api AND d.nr_gravidade = b.nr_gravidade AND d.ds_resultado_curto = b.ds_resultado_curto)
, coalesce(d
LEFT OUTER JOIN coalesce(b ON (coalesce(d.ds_sub_tipo_api, 'XPTO') = coalesce(b.ds_sub_tipo_api, 'XPTO'))
WHERE to_char(a.cd_mat_comp1) = b.cd_material_interacao and c.nr_seq_mat_cpoe = a.nr_sequencia and c.nr_prescricao = cpoe_obter_prescr_original(a.nr_sequencia, 'M', a.nr_atendimento) and c.cd_material = a.cd_mat_comp1 and a.nr_sequencia = d.nr_seq_cpoe and a.cd_mat_comp1 = d.cd_material     and (a.dt_lib_suspensao is null or a.dt_suspensao > LOCALTIMESTAMP) and coalesce(d.ie_status_requisicao, 'XPTO')  = 'XPTO'
 
union all

select
	d.nr_sequencia nr_sequencia,
	substr(obter_desc_material(d.cd_material), 1, 255) ds_material,
	'S' ie_libera,
	GPT_obter_nome_api('LXC', d.cd_api) ds_erro_compl,
	substr(obter_um_dosagem_prescr(c.nr_prescricao, c.nr_sequencia), 1, 100) ds_dose_intervalo,
	b.ds_justificativa,
	null ds_observacao,
	coalesce(d.ds_resultado_curto, b.ds_resultado_curto) ds_orientacao,
	a.dt_atualizacao_nrec dt_prescricao,
	null ds_incons_farmacia,
	cpoe_obter_prescr_original(a.nr_sequencia, 'M', a.nr_atendimento) nr_prescricao,
	coalesce(d.ie_ciente, 'N') ie_ciente,
	null ds_motivo,
	cast(d.cd_material as varchar(10)) cd_material,
	a.nr_atendimento,
	a.cd_pessoa_fisica,
	'A' ie_tipo_perfil,
	'S' ie_cpoe,
	'N' ie_quimio,
	b.dt_confirmacao,
	b.nm_usuario_ciente,
	c.nr_seq_mat_cpoe,
	'LXC' ie_origem_informacao,
	obter_desc_expressao(1037238) ds_origem_informacao
FROM prescr_material c, cpoe_material a, alerta_api d
LEFT OUTER JOIN cpoe_justif_interacao b ON (d.nr_seq_cpoe = b.nr_seq_cpoe_princ AND d.cd_api = b.cd_api AND d.nr_gravidade = b.nr_gravidade AND d.ds_resultado_curto = b.ds_resultado_curto)
, coalesce(d
LEFT OUTER JOIN coalesce(b ON (coalesce(d.ds_sub_tipo_api, 'XPTO') = coalesce(b.ds_sub_tipo_api, 'XPTO'))
WHERE to_char(a.cd_mat_comp2) = b.cd_material_interacao and c.nr_seq_mat_cpoe = a.nr_sequencia and c.nr_prescricao = cpoe_obter_prescr_original(a.nr_sequencia, 'M', a.nr_atendimento) and c.cd_material = a.cd_mat_comp2 and a.nr_sequencia = d.nr_seq_cpoe and a.cd_mat_comp2 = d.cd_material     and (a.dt_lib_suspensao is null or a.dt_suspensao > LOCALTIMESTAMP) and coalesce(d.ie_status_requisicao, 'XPTO')  = 'XPTO'
 
union all

select
	d.nr_sequencia nr_sequencia,
	substr(obter_desc_material(d.cd_material), 1, 255) ds_material,
	'S' ie_libera,
	GPT_obter_nome_api('LXC', d.cd_api) ds_erro_compl,
	substr(obter_um_dosagem_prescr(c.nr_prescricao, c.nr_sequencia), 1, 100) ds_dose_intervalo,
	b.ds_justificativa,
	null ds_observacao,
	coalesce(d.ds_resultado_curto, b.ds_resultado_curto) ds_orientacao,
	a.dt_atualizacao_nrec dt_prescricao,
	null ds_incons_farmacia,
	cpoe_obter_prescr_original(a.nr_sequencia, 'M', a.nr_atendimento) nr_prescricao,
	coalesce(d.ie_ciente, 'N') ie_ciente,
	null ds_motivo,
	cast(d.cd_material as varchar(10)) cd_material,
	a.nr_atendimento,
	a.cd_pessoa_fisica,
	'A' ie_tipo_perfil,
	'S' ie_cpoe,
	'N' ie_quimio,
	b.dt_confirmacao,
	b.nm_usuario_ciente,
	c.nr_seq_mat_cpoe,
	'LXC' ie_origem_informacao,
	obter_desc_expressao(1037238) ds_origem_informacao
FROM prescr_material c, cpoe_material a, alerta_api d
LEFT OUTER JOIN cpoe_justif_interacao b ON (d.nr_seq_cpoe = b.nr_seq_cpoe_princ AND d.cd_api = b.cd_api AND d.nr_gravidade = b.nr_gravidade AND d.ds_resultado_curto = b.ds_resultado_curto)
, coalesce(d
LEFT OUTER JOIN coalesce(b ON (coalesce(d.ds_sub_tipo_api, 'XPTO') = coalesce(b.ds_sub_tipo_api, 'XPTO'))
WHERE to_char(a.cd_mat_comp3) = b.cd_material_interacao and c.nr_seq_mat_cpoe = a.nr_sequencia and c.nr_prescricao = cpoe_obter_prescr_original(a.nr_sequencia, 'M', a.nr_atendimento) and c.cd_material = a.cd_mat_comp3 and a.nr_sequencia = d.nr_seq_cpoe and a.cd_mat_comp3 = d.cd_material     and (a.dt_lib_suspensao is null or a.dt_suspensao > LOCALTIMESTAMP) and coalesce(d.ie_status_requisicao, 'XPTO')  = 'XPTO'
 
union all

select
	d.nr_sequencia nr_sequencia,
	substr(obter_desc_material(d.cd_material), 1, 255) ds_material,
	'S' ie_libera,
	GPT_obter_nome_api('LXC', d.cd_api) ds_erro_compl,
	substr(obter_um_dosagem_prescr(c.nr_prescricao, c.nr_sequencia), 1, 100) ds_dose_intervalo,
	b.ds_justificativa,
	null ds_observacao,
	coalesce(d.ds_resultado_curto, b.ds_resultado_curto) ds_orientacao,
	a.dt_atualizacao_nrec dt_prescricao,
	null ds_incons_farmacia,
	cpoe_obter_prescr_original(a.nr_sequencia, 'M', a.nr_atendimento) nr_prescricao,
	coalesce(d.ie_ciente, 'N') ie_ciente,
	null ds_motivo,
	cast(d.cd_material as varchar(10)) cd_material,
	a.nr_atendimento,
	a.cd_pessoa_fisica,
	'A' ie_tipo_perfil,
	'S' ie_cpoe,
	'N' ie_quimio,
	b.dt_confirmacao,
	b.nm_usuario_ciente,
	c.nr_seq_mat_cpoe,
	'LXC' ie_origem_informacao,
	obter_desc_expressao(1037238) ds_origem_informacao
FROM prescr_material c, cpoe_material a, alerta_api d
LEFT OUTER JOIN cpoe_justif_interacao b ON (d.nr_seq_cpoe = b.nr_seq_cpoe_princ AND d.cd_api = b.cd_api AND d.nr_gravidade = b.nr_gravidade AND d.ds_resultado_curto = b.ds_resultado_curto)
, coalesce(d
LEFT OUTER JOIN coalesce(b ON (coalesce(d.ds_sub_tipo_api, 'XPTO') = coalesce(b.ds_sub_tipo_api, 'XPTO'))
WHERE to_char(a.cd_mat_comp4) = b.cd_material_interacao and c.nr_seq_mat_cpoe = a.nr_sequencia and c.nr_prescricao = cpoe_obter_prescr_original(a.nr_sequencia, 'M', a.nr_atendimento) and c.cd_material = a.cd_mat_comp4 and a.nr_sequencia = d.nr_seq_cpoe and a.cd_mat_comp4 = d.cd_material     and (a.dt_lib_suspensao is null or a.dt_suspensao > LOCALTIMESTAMP) and coalesce(d.ie_status_requisicao, 'XPTO')  = 'XPTO'
 
union all

select
	d.nr_sequencia nr_sequencia,
	substr(obter_desc_material(d.cd_material), 1, 255) ds_material,
	'S' ie_libera,
	GPT_obter_nome_api('LXC', d.cd_api) ds_erro_compl,
	substr(obter_um_dosagem_prescr(c.nr_prescricao, c.nr_sequencia), 1, 100) ds_dose_intervalo,
	b.ds_justificativa,
	null ds_observacao,
	coalesce(d.ds_resultado_curto, b.ds_resultado_curto) ds_orientacao,
	a.dt_atualizacao_nrec dt_prescricao,
	null ds_incons_farmacia,
	cpoe_obter_prescr_original(a.nr_sequencia, 'M', a.nr_atendimento) nr_prescricao,
	coalesce(d.ie_ciente, 'N') ie_ciente,
	null ds_motivo,
	cast(d.cd_material as varchar(10)) cd_material,
	a.nr_atendimento,
	a.cd_pessoa_fisica,
	'A' ie_tipo_perfil,
	'S' ie_cpoe,
	'N' ie_quimio,
	b.dt_confirmacao,
	b.nm_usuario_ciente,
	c.nr_seq_mat_cpoe,
	'LXC' ie_origem_informacao,
	obter_desc_expressao(1037238) ds_origem_informacao
FROM prescr_material c, cpoe_material a, alerta_api d
LEFT OUTER JOIN cpoe_justif_interacao b ON (d.nr_seq_cpoe = b.nr_seq_cpoe_princ AND d.cd_api = b.cd_api AND d.nr_gravidade = b.nr_gravidade AND d.ds_resultado_curto = b.ds_resultado_curto)
, coalesce(d
LEFT OUTER JOIN coalesce(b ON (coalesce(d.ds_sub_tipo_api, 'XPTO') = coalesce(b.ds_sub_tipo_api, 'XPTO'))
WHERE to_char(a.cd_mat_comp5) = b.cd_material_interacao and c.nr_seq_mat_cpoe = a.nr_sequencia and c.nr_prescricao = cpoe_obter_prescr_original(a.nr_sequencia, 'M', a.nr_atendimento) and c.cd_material = a.cd_mat_comp5 and a.nr_sequencia = d.nr_seq_cpoe and a.cd_mat_comp5 = d.cd_material     and (a.dt_lib_suspensao is null or a.dt_suspensao > LOCALTIMESTAMP) and coalesce(d.ie_status_requisicao, 'XPTO')  = 'XPTO'
 
union all

select
	d.nr_sequencia nr_sequencia,
	substr(obter_desc_material(d.cd_material), 1, 255) ds_material,
	'S' ie_libera,
	GPT_obter_nome_api('LXC', d.cd_api) ds_erro_compl,
	substr(obter_um_dosagem_prescr(c.nr_prescricao, c.nr_sequencia), 1, 100) ds_dose_intervalo,
	b.ds_justificativa,
	null ds_observacao,
	coalesce(d.ds_resultado_curto, b.ds_resultado_curto) ds_orientacao,
	a.dt_atualizacao_nrec dt_prescricao,
	null ds_incons_farmacia,
	cpoe_obter_prescr_original(a.nr_sequencia, 'M', a.nr_atendimento) nr_prescricao,
	coalesce(d.ie_ciente, 'N') ie_ciente,
	null ds_motivo,
	cast(d.cd_material as varchar(10)) cd_material,
	a.nr_atendimento,
	a.cd_pessoa_fisica,
	'A' ie_tipo_perfil,
	'S' ie_cpoe,
	'N' ie_quimio,
	b.dt_confirmacao,
	b.nm_usuario_ciente,
	c.nr_seq_mat_cpoe,
	'LXC' ie_origem_informacao,
	obter_desc_expressao(1037238) ds_origem_informacao
FROM prescr_material c, cpoe_material a, alerta_api d
LEFT OUTER JOIN cpoe_justif_interacao b ON (d.nr_seq_cpoe = b.nr_seq_cpoe_princ AND d.cd_api = b.cd_api AND d.nr_gravidade = b.nr_gravidade AND d.ds_resultado_curto = b.ds_resultado_curto)
, coalesce(d
LEFT OUTER JOIN coalesce(b ON (coalesce(d.ds_sub_tipo_api, 'XPTO') = coalesce(b.ds_sub_tipo_api, 'XPTO'))
WHERE to_char(a.cd_mat_comp6) = b.cd_material_interacao and c.nr_seq_mat_cpoe = a.nr_sequencia and c.nr_prescricao = cpoe_obter_prescr_original(a.nr_sequencia, 'M', a.nr_atendimento) and c.cd_material = a.cd_mat_comp6 and a.nr_sequencia = d.nr_seq_cpoe and a.cd_mat_comp6 = d.cd_material     and (a.dt_lib_suspensao is null or a.dt_suspensao > LOCALTIMESTAMP) and coalesce(d.ie_status_requisicao, 'XPTO')  = 'XPTO'
 
union all

select
	d.nr_sequencia nr_sequencia,
	substr(obter_desc_material(d.cd_material), 1, 255) ds_material,
	'S' ie_libera,
	GPT_obter_nome_api('LXC', d.cd_api) ds_erro_compl,
	substr(obter_um_dosagem_prescr(c.nr_prescricao, c.nr_sequencia), 1, 100) ds_dose_intervalo,
	b.ds_justificativa,
	null ds_observacao,
	coalesce(d.ds_resultado_curto, b.ds_resultado_curto) ds_orientacao,
	a.dt_atualizacao_nrec dt_prescricao,
	null ds_incons_farmacia,
	cpoe_obter_prescr_original(a.nr_sequencia, 'M', a.nr_atendimento) nr_prescricao,
	coalesce(d.ie_ciente, 'N') ie_ciente,
	null ds_motivo,
	cast(d.cd_material as varchar(10)) cd_material,
	a.nr_atendimento,
	a.cd_pessoa_fisica,
	'A' ie_tipo_perfil,
	'S' ie_cpoe,
	'N' ie_quimio,
	b.dt_confirmacao,
	b.nm_usuario_ciente,
	c.nr_seq_mat_cpoe,
	'LXC' ie_origem_informacao,
	obter_desc_expressao(1037238) ds_origem_informacao
FROM prescr_material c, cpoe_material a, alerta_api d
LEFT OUTER JOIN cpoe_justif_interacao b ON (d.nr_seq_cpoe = b.nr_seq_cpoe_princ AND d.cd_api = b.cd_api AND d.nr_gravidade = b.nr_gravidade AND d.ds_resultado_curto = b.ds_resultado_curto)
, coalesce(d
LEFT OUTER JOIN coalesce(b ON (coalesce(d.ds_sub_tipo_api, 'XPTO') = coalesce(b.ds_sub_tipo_api, 'XPTO'))
WHERE to_char(a.cd_mat_comp7) = b.cd_material_interacao and c.nr_seq_mat_cpoe = a.nr_sequencia and c.nr_prescricao = cpoe_obter_prescr_original(a.nr_sequencia, 'M', a.nr_atendimento) and c.cd_material = a.cd_mat_comp7 and a.nr_sequencia = d.nr_seq_cpoe and a.cd_mat_comp7 = d.cd_material     and (a.dt_lib_suspensao is null or a.dt_suspensao > LOCALTIMESTAMP) and coalesce(d.ie_status_requisicao, 'XPTO')  = 'XPTO';

