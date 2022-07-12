-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';

CREATE OR REPLACE VIEW eis_tempo_medio_agend_v (cd_agenda, ds_agenda, cd_pessoa_fisica, nm_paciente, cd_setor_exclusivo, ds_setor_exclusivo, dt_agendamento, dt_final_agendamento, dt_referencia, hr_diferenca, cd_estabelecimento) AS select	a.cd_agenda,
	substr(obter_nome_agenda(a.cd_agenda),1,100) ds_agenda, 
	b.cd_pessoa_fisica, 
	b.nm_paciente, 
	a.cd_setor_exclusivo, 
	substr(obter_nome_setor(a.cd_setor_exclusivo),1,100) ds_setor_exclusivo, 
	b.dt_agendamento, 
	b.dt_final_agendamento, 
	trunc(dt_agenda) dt_referencia, 
	(dt_final_agendamento - dt_agendamento) * 1440 hr_diferenca, 
	a.cd_estabelecimento 
FROM	agenda a, 
	agenda_paciente b 
where	a.cd_agenda = b.cd_agenda 
and	b.ie_status_agenda <> 'L' 
and	a.cd_tipo_agenda = 2 
and	b.dt_final_agendamento is not null;

