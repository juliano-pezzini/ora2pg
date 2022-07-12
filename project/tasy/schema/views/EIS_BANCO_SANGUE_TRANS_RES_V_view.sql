-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';

CREATE OR REPLACE VIEW eis_banco_sangue_trans_res_v (ie_tipo, ie_tipo_union, dt_referencia, nm_usuario, ds_setor, ds_convenio, nm_medico_requisitante, ds_especialidade_medico, cd_especialidade_medico, ie_status, qt_total_1, qt_total_2, hr_referencia, cd_setor_atendimento, ds_atend_tempo, cd_atend_tempo, ds_derivado, nr_seq_derivado, cd_medico_requisitante, ds_estabelecimento, cd_estabelecimento, nr_seq_reserva, nr_seq_transfusao) AS select 	1 ie_tipo, /* Reserva */
	'T' ie_tipo_union, 
	trunc(a.dt_reserva) dt_referencia, 
	a.nm_usuario, 
	obter_nome_setor(obter_setor_atend_data_ent(a.nr_atendimento,a.dt_reserva)) ds_setor, 
	substr(obter_nome_convenio(a.cd_convenio),1,200) ds_convenio, 
	substr(obter_nome_pf(a.CD_MEDICO_REQUISITANTE),1,50) nm_medico_requisitante, 
	substr(obter_especialidade_medico(a.cd_medico_requisitante,'D'),1,40) ds_especialidade_medico, 
	substr(obter_especialidade_medico(a.cd_medico_requisitante,'C'),1,5) cd_especialidade_medico, 
	CASE WHEN a.ie_status='S' THEN 'Solicitada' WHEN a.ie_status='R' THEN 'Reservada' WHEN a.ie_status='L' THEN 'Liberada' WHEN a.ie_status='T' THEN 'Transfundida' WHEN a.ie_status='C' THEN 'Cancelada' WHEN a.ie_status='A' THEN 'Amostra'  ELSE null END  ie_status, 
	count(*) qt_total_1, 
	0 qt_total_2, 
	to_char(a.dt_reserva,'hh24') hr_referencia, 
	obter_setor_atend_data_ent(a.nr_atendimento,a.dt_reserva) cd_setor_atendimento, 
	substr(obter_prescr_solic_bco_sangue(a.nr_prescricao,'TIPOA',null),1,255) ds_atend_tempo, 
	SUBSTR(coalesce(obter_valor_prescr_solic(nr_prescricao),0),1,255) cd_atend_tempo, 
	null ds_derivado, 
	null nr_seq_derivado, 
	a.CD_MEDICO_REQUISITANTE, 
	substr(obter_nome_estabelecimento(a.cd_estabelecimento),1,80) ds_estabelecimento, 
	a.cd_estabelecimento, 
	a.nr_sequencia nr_seq_reserva, 
	null nr_seq_transfusao 
FROM 	san_reserva a 
group by trunc(a.dt_reserva), 
	obter_setor_atend_data_ent(a.nr_atendimento,a.dt_reserva), 
	a.CD_MEDICO_REQUISITANTE, 
	a.cd_convenio, 
	a.ie_status, 
	a.nm_usuario, 
	to_char(a.dt_reserva,'hh24'), 
	obter_setor_atend_data_ent(a.nr_atendimento,a.dt_reserva), 
	substr(obter_prescr_solic_bco_sangue(a.nr_prescricao,'TIPOA',null),1,255), 
	SUBSTR(coalesce(obter_valor_prescr_solic(a.nr_prescricao),0),1,255), 
	substr(obter_nome_estabelecimento(a.cd_estabelecimento),1,80), 
	a.cd_estabelecimento, 
	a.nr_sequencia 

union
 
select 	2 ie_tipo, /* Transfusão */
 
	'T' ie_tipo_union, 
	trunc(c.dt_transfusao) dt_referencia, 
	c.nm_usuario, 
	obter_nome_setor(obter_setor_atend_data_ent(c.nr_atendimento,c.dt_transfusao)) ds_setor, 
	substr(obter_nome_convenio(obter_convenio_atendimento(c.nr_atendimento)),1,200) ds_convenio, 
	substr(obter_nome_pf(c.CD_MEDICO_REQUISITANTE),1,50) nm_medico_requisitante, 
	substr(obter_especialidade_medico(c.cd_medico_requisitante,'D'),1,40) ds_especialidade_medico, 
	substr(obter_especialidade_medico(c.cd_medico_requisitante,'C'),1,5) cd_especialidade_medico, 
	coalesce(CASE WHEN c.ie_status='C' THEN 'Cancelada'  ELSE CASE WHEN c.ie_status='F' THEN 'Finalizada'  ELSE CASE WHEN c.ie_status='A' THEN 'Aberta'  ELSE null END  END  END ,null) ie_status, 
	0 qt_total_1, 
	count(*) qt_total_2, 
	to_char(c.dt_transfusao, 'hh24') hr_referencia, 
	obter_setor_atend_data_ent(c.nr_atendimento,c.dt_transfusao) cd_setor_atendimento, 
	substr(Obter_Descricao_Dominio(1223,c.IE_TIPO_TRANSFUSAO),1,255) ds_atend_tempo, 
	substr(c.IE_TIPO_TRANSFUSAO,1,255) cd_atend_tempo, 
	null ds_derivado, 
	null nr_seq_derivado, 
	c.CD_MEDICO_REQUISITANTE, 
	substr(obter_nome_estabelecimento(c.cd_estabelecimento),1,80) ds_estabelecimento, 
	c.cd_estabelecimento, 
	null nr_seq_reserva, 
	c.nr_sequencia nr_seq_transfusao 
from 	san_transfusao c 
group by trunc(c.dt_transfusao), 
	c.nm_usuario, 
	c.CD_MEDICO_REQUISITANTE, 
	c.ie_status, 
	c.nr_atendimento, 
	obter_setor_atend_data_ent(c.nr_atendimento,c.dt_transfusao), 
	to_char(c.dt_transfusao, 'hh24'), 
	obter_setor_atend_data_ent(c.nr_atendimento,c.dt_transfusao), 
	substr(Obter_Descricao_Dominio(1223,c.IE_TIPO_TRANSFUSAO),1,255), 
	substr(c.IE_TIPO_TRANSFUSAO,1,255), 
	substr(obter_nome_estabelecimento(c.cd_estabelecimento),1,80), 
	c.cd_estabelecimento, 
	c.nr_sequencia 

union
 
select 	distinct 
	1 ie_tipo, /* Reserva */
 
	'H' ie_tipo_union, 
	trunc(a.dt_reserva) dt_referencia, 
	a.nm_usuario, 
	obter_nome_setor(obter_setor_atend_data_ent(a.nr_atendimento,a.dt_reserva)) ds_setor, 
	substr(obter_nome_convenio(a.cd_convenio),1,200) ds_convenio, 
	substr(obter_nome_pf(a.CD_MEDICO_REQUISITANTE),1,50) nm_medico_requisitante, 
	substr(obter_especialidade_medico(a.cd_medico_requisitante,'D'),1,40) ds_especialidade_medico, 
	substr(obter_especialidade_medico(a.cd_medico_requisitante,'C'),1,5) cd_especialidade_medico, 
	CASE WHEN a.ie_status='C' THEN 'Cancelada'  ELSE CASE WHEN a.ie_status='R' THEN 'Reservada'  ELSE CASE WHEN a.ie_status='T' THEN 'Transfundida'  ELSE null END  END  END  ie_status, 
	count(*) qt_total_1, 
	0 qt_total_2, 
	to_char(a.dt_reserva,'hh24') hr_referencia, 
	obter_setor_atend_data_ent(a.nr_atendimento,a.dt_reserva) cd_setor_atendimento, 
	substr(obter_prescr_solic_bco_sangue(a.nr_prescricao,'TIPOA',null),1,255) ds_atend_tempo, 
	SUBSTR(coalesce(obter_valor_prescr_solic(nr_prescricao),0),1,255) cd_atend_tempo, 
	c.ds_derivado, 
	c.nr_seq_derivado, 
	a.CD_MEDICO_REQUISITANTE, 
	substr(obter_nome_estabelecimento(a.cd_estabelecimento),1,80) ds_estabelecimento, 
	a.cd_estabelecimento, 
	a.nr_sequencia nr_seq_reserva, 
	null nr_seq_transfusao 
FROM san_reserva a
LEFT OUTER JOIN san_reserva_prod b ON (a.nr_sequencia = b.nr_seq_reserva)
LEFT OUTER JOIN san_producao_v c ON (b.nr_seq_producao = c.nr_sequencia) group BY trunc(a.dt_reserva), 
	obter_setor_atend_data_ent(a.nr_atendimento,a.dt_reserva), 
	a.CD_MEDICO_REQUISITANTE, 
	a.cd_convenio, 
	a.ie_status, 
	a.nm_usuario, 
	to_char(a.dt_reserva,'hh24'), 
	obter_setor_atend_data_ent(a.nr_atendimento,a.dt_reserva), 
	substr(obter_prescr_solic_bco_sangue(a.nr_prescricao,'TIPOA',null),1,255), 
	SUBSTR(coalesce(obter_valor_prescr_solic(a.nr_prescricao),0),1,255), 
	c.ds_derivado, 
	c.nr_seq_derivado, 
	substr(obter_nome_estabelecimento(a.cd_estabelecimento),1,80), 
	a.cd_estabelecimento, 
	a.nr_sequencia 

union
 
select 	distinct 
	2 ie_tipo, /* Transfusão */
 
	'H' ie_tipo_union, 
	trunc(c.dt_transfusao) dt_referencia, 
	c.nm_usuario, 
	obter_nome_setor(obter_setor_atend_data_ent(c.nr_atendimento,c.dt_transfusao)) ds_setor, 
	substr(obter_nome_convenio(obter_convenio_atendimento(c.nr_atendimento)),1,200) ds_convenio, 
	substr(obter_nome_pf(c.CD_MEDICO_REQUISITANTE),1,50) nm_medico_requisitante, 
	substr(obter_especialidade_medico(c.cd_medico_requisitante,'D'),1,40) ds_especialidade_medico, 
	substr(obter_especialidade_medico(c.cd_medico_requisitante,'C'),1,5) cd_especialidade_medico, 
	coalesce(CASE WHEN c.ie_status='C' THEN 'Cancelada'  ELSE CASE WHEN c.ie_status='F' THEN 'Finalizada'  ELSE CASE WHEN c.ie_status='A' THEN 'Aberta'  ELSE null END  END  END ,null) ie_status, 
	0 qt_total_1, 
	count(*) qt_total_2, 
	to_char(c.dt_transfusao, 'hh24') hr_referencia, 
	obter_setor_atend_data_ent(c.nr_atendimento,c.dt_transfusao) cd_setor_atendimento, 
	substr(Obter_Descricao_Dominio(1223,c.IE_TIPO_TRANSFUSAO),1,255) ds_atend_tempo, 
	substr(c.IE_TIPO_TRANSFUSAO,1,255) cd_atend_tempo, 
	d.ds_derivado, 
	d.nr_seq_derivado, 
	c.CD_MEDICO_REQUISITANTE, 
	substr(obter_nome_estabelecimento(c.cd_estabelecimento),1,80) ds_estabelecimento, 
	c.cd_estabelecimento, 
	null nr_seq_reserva, 
	c.nr_sequencia nr_seq_transfusao 
FROM san_transfusao c
LEFT OUTER JOIN san_producao_v d ON (c.nr_sequencia = d.nr_seq_transfusao) group BY trunc(c.dt_transfusao), 
	c.nm_usuario, 
	c.CD_MEDICO_REQUISITANTE, 
	c.ie_status, 
	c.nr_atendimento, 
	obter_setor_atend_data_ent(c.nr_atendimento,c.dt_transfusao), 
	to_char(c.dt_transfusao, 'hh24'), 
	obter_setor_atend_data_ent(c.nr_atendimento,c.dt_transfusao), 
	substr(Obter_Descricao_Dominio(1223,c.IE_TIPO_TRANSFUSAO),1,255), 
	substr(c.IE_TIPO_TRANSFUSAO,1,255), 
	d.ds_derivado, 
	d.nr_seq_derivado, 
	substr(obter_nome_estabelecimento(c.cd_estabelecimento),1,80), 
	c.cd_estabelecimento, 
	c.nr_sequencia;

