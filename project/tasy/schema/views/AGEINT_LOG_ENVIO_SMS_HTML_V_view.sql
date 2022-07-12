-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';

CREATE OR REPLACE VIEW ageint_log_envio_sms_html_v (ie_tipo, ie_envio_sms, dt_envio_sms, nm_usuario, nm_pac, dt_agenda, nr_tel, ds_mensagem, dt_atualizacao, ds_forma, dt_envio, id_sms, nr_seq_ageint, ie_status, ie_transf, nr_seq_mot_transf, cd_pessoa_fisica, ds_agenda, dt_agendamento, dt_transferido, cd_estab_agenda, dt_contato, nm_usuario_contato, ds_obs_contato, nr_sequencia, cd_agenda) AS SELECT	1 ie_tipo,
		substr(obter_desc_expressao(10652501),1,100) ie_envio_sms,
		a.dt_envio dt_envio_sms,
		a.nm_usuario,
		SUBSTR(coalesce(obter_nome_pf(b.cd_pessoa_fisica), b.nm_paciente),1,200) nm_pac,
		b.dt_agenda dt_agenda,
		a.nr_telefone nr_tel,
		SUBSTR(a.ds_mensagem,1,255) ds_mensagem,
		a.dt_atualizacao,
		NULL ds_forma,
		a.dt_envio,
		a.id_sms,
		a.nr_seq_ageint,
		b.ie_status_agenda ie_status,
		substr(coalesce(ageint_sms_transf(a.nr_seq_ageint),'N'),1,10) ie_transf,
		NULL nr_seq_mot_transf,
		b.cd_pessoa_fisica,
		substr(CASE WHEN c.cd_tipo_agenda=3 THEN  obter_nome_medico_combo_agcons(c.cd_estabelecimento, c.cd_agenda, 3, 'N') WHEN c.cd_tipo_agenda=5 THEN  CASE WHEN c.ie_ordenacao IS NULL THEN  c.ds_agenda  ELSE obter_desc_agenda_servico(c.cd_estabelecimento, c.cd_agenda, c.ie_ordenacao) END  END ,1,255) ds_agenda,
		b.dt_agenda dt_agendamento,
		null dt_transferido,
		ageint_obter_estab(a.nr_seq_ageint) cd_estab_agenda,
		a.dt_contato dt_contato,
		a.nm_usuario_contato nm_usuario_contato,
		a.ds_obs_contato ds_obs_contato,
		a.nr_sequencia nr_sequencia,
		c.cd_agenda cd_agenda
FROM log_envio_sms a
LEFT OUTER JOIN agenda_consulta b ON (a.nr_seq_agenda = b.nr_sequencia)
LEFT OUTER JOIN agenda c ON (b.cd_agenda = c.cd_agenda)
WHERE a.nr_seq_agenda > 0 AND b.dt_agenda IS NOT NULL

UNION ALL

SELECT	1 ie_tipo,
		substr(obter_desc_expressao(10652501),1,100) ie_envio_sms,
		a.dt_envio dt_envio_sms,
		a.nm_usuario,
		SUBSTR(coalesce(obter_nome_pf(b.cd_pessoa_fisica), b.nm_paciente),1,200) nm_pac,
		b.hr_inicio dt_agenda,
		a.nr_telefone nr_tel,
		SUBSTR(a.ds_mensagem,1,255) ds_mensagem,
		a.dt_atualizacao,
		NULL ds_forma,
		a.dt_envio,
		a.id_sms,
		a.nr_seq_ageint,
		b.ie_status_agenda ie_status,
		substr(coalesce(ageint_sms_transf(a.nr_seq_ageint),'N'),1,10) ie_transf,
		NULL nr_seq_mot_transf,
		b.cd_pessoa_fisica,
		c.ds_agenda ds_agenda,
		b.hr_inicio dt_agendamento,
		null dt_transferido,
		ageint_obter_estab(a.nr_seq_ageint) cd_estab_agenda,
		a.dt_contato dt_contato,
		a.nm_usuario_contato nm_usuario_contato,
		a.ds_obs_contato ds_obs_contato,
		a.nr_sequencia nr_sequencia,
		c.cd_agenda cd_agenda
FROM log_envio_sms a
LEFT OUTER JOIN agenda_paciente b ON (a.nr_seq_agenda = b.nr_sequencia)
LEFT OUTER JOIN agenda c ON (b.cd_agenda = c.cd_agenda)
WHERE a.nr_seq_agenda > 0 AND b.hr_inicio IS NOT NULL
 
UNION ALL

SELECT	1 ie_tipo,
		substr(obter_desc_expressao(10652501),1,100) ie_envio_sms,
		a.dt_envio dt_envio_sms,
		a.nm_usuario,
		SUBSTR(obter_nome_pf(b.cd_pessoa_fisica),1,200) nm_pac,
		b.dt_agenda dt_agenda,
		a.nr_telefone nr_tel,
		SUBSTR(a.ds_mensagem,1,255) ds_mensagem,
		a.dt_atualizacao,
		NULL ds_forma,
		a.dt_envio,
		a.id_sms,
		a.nr_seq_ageint,
		b.ie_status_agenda ie_status,
		substr(coalesce(ageint_sms_transf(a.nr_seq_ageint),'N'),1,10) ie_transf,
		b.nr_seq_mot_reagendamento nr_seq_mot_transf,
		b.cd_pessoa_fisica,
		c.ds_local ds_agenda,
		b.dt_agenda dt_agendamento,
		null dt_transferido,
		ageint_obter_estab(a.nr_seq_ageint) cd_estab_agenda,
		a.dt_contato dt_contato,
		a.nm_usuario_contato nm_usuario_contato,
		a.ds_obs_contato ds_obs_contato,
		a.nr_sequencia nr_sequencia,
		a.cd_agenda cd_agenda
FROM log_envio_sms a
LEFT OUTER JOIN agenda_quimio b ON (a.nr_seq_agenda = b.nr_sequencia)
LEFT OUTER JOIN qt_local c ON (b.nr_seq_local = c.nr_sequencia)
WHERE a.nr_seq_agenda > 0 AND b.dt_agenda IS NOT NULL
 
UNION ALL

SELECT	2 ie_tipo,
		substr(obter_desc_expressao(10652568),1,100) ie_envio_sms,
		a.dt_resposta dt_envio_sms,
		'Tasy' nm_usuario,
		substr(coalesce(obter_nome_pf(b.cd_pessoa_fisica), b.nm_paciente),1,200) nm_pac,
		a.dt_agendamento dt_agenda,
		a.nr_celular nr_tel,
		SUBSTR(a.ds_resposta,1,255) ds_mensagem,
		a.dt_resposta,
		NULL ds_forma,
		a.dt_resposta,
		999 id_sms,
		a.nr_seq_ageint,
		coalesce(CASE WHEN ageint_obter_status_item(c.nr_seq_agenda_int, c.nr_sequencia, 'C')='C' THEN  ageint_obter_status_item(c.nr_seq_agenda_int, c.nr_sequencia, 'C')  ELSE CASE WHEN substr(coalesce(ageint_sms_transf(b.nr_sequencia),'N'),1,1)='S' THEN  substr(coalesce(ageint_sms_transf(b.nr_sequencia),'N'),1,1)  ELSE null END  END ,'X') ie_status,
		substr(coalesce(ageint_sms_transf(b.nr_sequencia),'N'),1,10) ie_transf,
		NULL nr_seq_mot_transf,
		b.cd_pessoa_fisica,
		substr(obter_desc_expressao(10652568),1,100) ds_agenda,
		a.dt_agendamento dt_agendamento,
		CASE WHEN coalesce(ageint_sms_transf(b.nr_sequencia),'N')='S' THEN coalesce(Obter_Horario_item_Ageint(c.nr_seq_agenda_cons,c.nr_Seq_Agenda_exame,c.nr_sequencia),qt_obter_horario_agendado(c.nr_sequencia)) END  dt_transferido,
		b.cd_estabelecimento cd_estab_agenda,
		a.dt_contato dt_contato,
		null nm_usuario_contato,
		a.ds_obs_contato ds_obs_contato,
		a.nr_sequencia nr_sequencia,
		null cd_agenda
from 	log_retorno_sms a,
		agenda_integrada b,
		agenda_integrada_item c	
where 	a.nr_seq_ageint = b.nr_sequencia
and 	b.nr_sequencia 	= c.nr_seq_agenda_int
and 	coalesce(c.nr_seq_agequi,c.nr_seq_agenda_exame,c.nr_seq_agenda_cons) > 0	
and		c.nr_sequencia	= (select min(x.nr_sequencia) from agenda_integrada_item x where x.nr_seq_agenda_int = b.nr_sequencia)
and 	coalesce(Obter_Horario_item_Ageint(c.nr_seq_agenda_cons,c.nr_Seq_Agenda_exame,c.nr_sequencia),qt_obter_horario_agendado(c.nr_sequencia)) is not null
and		a.dt_agendamento is not null
and		c.nr_sequencia = (	select 	min(t.nr_sequencia)
						from	agenda_integrada_item t
						where	t.nr_seq_agenda_int = b.nr_sequencia)

UNION ALL

SELECT	2 ie_tipo,
		substr(obter_desc_expressao(10652568),1,100) ie_envio_sms,
		a.dt_resposta dt_envio_sms,
		'Tasy' nm_usuario,
		substr(coalesce(obter_nome_pf(b.cd_pessoa_fisica), b.nm_paciente),1,200) nm_pac,
		to_Date(substr(coalesce(Obter_Horario_item_Ageint(c.nr_seq_agenda_cons,c.nr_Seq_Agenda_exame,c.nr_sequencia),qt_obter_horario_agendado(c.nr_sequencia)),1,20),'dd/mm/yyyy hh24:mi:ss') dt_agenda,
		a.nr_celular nr_tel,
		SUBSTR(a.ds_resposta,1,255) ds_mensagem,
		a.dt_resposta,
		NULL ds_forma,
		a.dt_resposta,
		999 id_sms,
		a.nr_seq_ageint,
		--ageint_obter_status_item(c.nr_seq_agenda_int, c.nr_sequencia, 'C') ie_status,

		coalesce(CASE WHEN ageint_obter_status_item(c.nr_seq_agenda_int, c.nr_sequencia, 'C')='C' THEN  ageint_obter_status_item(c.nr_seq_agenda_int, c.nr_sequencia, 'C')  ELSE CASE WHEN substr(coalesce(ageint_sms_transf(b.nr_sequencia),'N'),1,1)='S' THEN  substr(coalesce(ageint_sms_transf(b.nr_sequencia),'N'),1,1)  ELSE null END  END ,'X') ie_status,
		substr(coalesce(ageint_sms_transf(b.nr_sequencia),'N'),1,10) ie_transf,
		NULL nr_seq_mot_transf,
		b.cd_pessoa_fisica,
		substr(obter_desc_expressao(10652568),1,100) ds_agenda,
		to_date(coalesce(Obter_Horario_item_Ageint(c.nr_seq_agenda_cons,c.nr_Seq_Agenda_exame,c.nr_sequencia),qt_obter_horario_agendado(c.nr_sequencia))) dt_agendamento,
		CASE WHEN coalesce(ageint_sms_transf(b.nr_sequencia),'N')='S' THEN coalesce(Obter_Horario_item_Ageint(c.nr_seq_agenda_cons,c.nr_Seq_Agenda_exame,c.nr_sequencia),qt_obter_horario_agendado(c.nr_sequencia)) END  dt_transferido,
		b.cd_estabelecimento cd_estab_agenda,
		a.dt_contato dt_contato,
		null nm_usuario_contato,
		a.ds_obs_contato ds_obs_contato,
		a.nr_sequencia nr_sequencia,
		null cd_agenda
from 	log_retorno_sms a,
		agenda_integrada b,
		agenda_integrada_item c	
where 	a.nr_seq_ageint = b.nr_sequencia
and 	b.nr_sequencia 	= c.nr_seq_agenda_int
and 	coalesce(c.nr_seq_agequi,c.nr_seq_agenda_exame,c.nr_seq_agenda_cons) > 0	
and		c.nr_sequencia	= (select min(x.nr_sequencia) from agenda_integrada_item x where x.nr_seq_agenda_int = b.nr_sequencia)
and 	coalesce(Obter_Horario_item_Ageint(c.nr_seq_agenda_cons,c.nr_Seq_Agenda_exame,c.nr_sequencia),qt_obter_horario_agendado(c.nr_sequencia)) is not null
and		dt_agendamento is null
and		c.nr_sequencia = (	select 	min(t.nr_sequencia)
						from	agenda_integrada_item t
						where	t.nr_seq_agenda_int = b.nr_sequencia)

UNION ALL

SELECT	2 ie_tipo,
		substr(obter_desc_expressao(10652568),1,100) ie_envio_sms,
		a.dt_resposta dt_envio_sms,
		coalesce(a.nm_sms_sent_user, 'Tasy') nm_usuario,
		substr(coalesce(obter_nome_pf(c.cd_pessoa_fisica), b.nm_paciente),1,200) nm_pac,
		b.dt_agenda dt_agenda,
		a.nr_celular nr_tel,
		SUBSTR(a.ds_resposta,1,255) ds_mensagem,
		a.dt_resposta,
		NULL ds_forma,
		a.dt_resposta,
		999 id_sms,
		a.nr_seq_agenda_cons,
		b.ie_status_agenda ie_status,
		b.ie_transferido ie_transf,
		NULL nr_seq_mot_transf,
		coalesce(c.cd_pessoa_fisica, b.cd_pessoa_fisica) cd_pessoa_fisica,
		substr(CASE WHEN c.cd_tipo_agenda=3 THEN  obter_nome_medico_combo_agcons(c.cd_estabelecimento, c.cd_agenda, 3, 'N') WHEN c.cd_tipo_agenda=5 THEN  CASE WHEN c.ie_ordenacao IS NULL THEN  c.ds_agenda  ELSE obter_desc_agenda_servico(c.cd_estabelecimento, c.cd_agenda, c.ie_ordenacao) END  END ,1,255) ds_agenda,
		a.dt_agendamento dt_agendamento,
		CASE WHEN coalesce(b.ie_transferido,'N')='S' THEN b.dt_agenda END  dt_transferido,
		c.cd_estabelecimento cd_estab_agenda,
		a.dt_contato,
		null nm_usuario_contato,
		a.ds_obs_contato,
		a.nr_sequencia,
		c.cd_agenda cd_agenda
from 	log_retorno_sms a,
		agenda_consulta b,
		agenda c
where 	a.nr_seq_agenda_cons	= b.nr_sequencia
and 	b.cd_agenda		= c.cd_agenda
and 	coalesce(a.nr_seq_agenda_cons, 0) > 0
and 	b.dt_agenda		is not null
and	a.dt_agendamento	is not null

UNION ALL

SELECT	2 ie_tipo,
		substr(obter_desc_expressao(10652568),1,100) ie_envio_sms,
		a.dt_resposta dt_envio_sms,
		coalesce(a.nm_sms_sent_user, 'Tasy') nm_usuario,
		substr(coalesce(obter_nome_pf(c.cd_pessoa_fisica), b.nm_paciente),1,200) nm_pac,
		b.dt_agenda dt_agenda,
		a.nr_celular nr_tel,
		SUBSTR(a.ds_resposta,1,255) ds_mensagem,
		a.dt_resposta,
		NULL ds_forma,
		a.dt_resposta,
		999 id_sms,
		a.nr_seq_agenda_cons,
		b.ie_status_agenda ie_status,
		b.ie_transferido ie_transf,
		NULL nr_seq_mot_transf,
		coalesce(c.cd_pessoa_fisica, b.cd_pessoa_fisica) cd_pessoa_fisica,
		substr(CASE WHEN c.cd_tipo_agenda=3 THEN  obter_nome_medico_combo_agcons(c.cd_estabelecimento, c.cd_agenda, 3, 'N') WHEN c.cd_tipo_agenda=5 THEN  CASE WHEN c.ie_ordenacao IS NULL THEN  c.ds_agenda  ELSE obter_desc_agenda_servico(c.cd_estabelecimento, c.cd_agenda, c.ie_ordenacao) END  END ,1,255) ds_agenda,
		a.dt_agendamento dt_agendamento,
		CASE WHEN coalesce(b.ie_transferido,'N')='S' THEN b.dt_agenda END  dt_transferido,
		c.cd_estabelecimento cd_estab_agenda,
		a.dt_contato dt_contato,
		null nm_usuario_contato,
		a.ds_obs_contato,
		a.nr_sequencia,
		c.cd_agenda cd_agenda
from 	log_retorno_sms a,
		agenda_consulta b,
		agenda c
where 	a.nr_seq_agenda_cons	= b.nr_sequencia
and 	b.cd_agenda		= c.cd_agenda
and 	coalesce(a.nr_seq_agenda_cons, 0) > 0
and 	b.dt_agenda		is null
and	a.dt_agendamento	is null

UNION ALL

SELECT	2 ie_tipo,
		substr(obter_desc_expressao(10652568),1,100) ie_envio_sms,
		a.dt_resposta dt_envio_sms,
		coalesce(a.nm_sms_sent_user, 'Tasy') nm_usuario,
		null nm_pac,
		null dt_agenda,
		a.nr_celular nr_tel,
		SUBSTR(a.ds_resposta,1,255) ds_mensagem,
		a.dt_resposta,
		NULL ds_forma,
		a.dt_resposta,
		999 id_sms,
		a.nr_seq_ageint,
		null ie_status,
		null ie_transf,
		NULL nr_seq_mot_transf,
		null cd_pessoa_fisica,
		substr(obter_desc_expressao(10652568),1,100) ds_agenda,
		null dt_agendamento,
		null dt_transferido,
		null cd_estab_agenda,
		a.dt_contato dt_contato,
		null nm_usuario_contato,
		a.ds_obs_contato ds_obs_contato,
		a.nr_sequencia nr_sequencia,
		null cd_agenda
from 	log_retorno_sms a	
where 	a.nr_seq_ageint is null
and		a.dt_agendamento is null;

