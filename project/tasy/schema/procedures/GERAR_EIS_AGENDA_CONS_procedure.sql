-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE gerar_eis_agenda_cons ( dt_parametro_P timestamp, nm_usuario_p text) AS $body$
DECLARE

 
dt_parametro_fim_w		timestamp;
dt_parametro_w			timestamp;
cd_estabelecimento_w		integer;
cd_convenio_w			integer;
cd_medico_w			varchar(10);
cd_agenda_w			bigint;
cd_tipo_agenda_w		bigint;
ie_status_agenda_w		varchar(03);
hr_inicio_w			smallint;
cd_motivo_canc_w		varchar(03);
qt_min_duracao_w		bigint;
qt_agenda_w			bigint;
nr_sequencia_w			bigint;

 
CD_SETOR_ATENDIMENTO_W       integer;

 

BEGIN 
 
 
nr_sequencia_w := Gravar_Log_Indicador(444, wheb_mensagem_pck.get_texto(160577), clock_timestamp(), trunc(dt_parametro_p), nm_usuario_p, nr_sequencia_w);
 
dt_parametro_fim_w	:= (last_day(trunc(dt_parametro_p, 'dd')) + 1) - (1/86400);
dt_parametro_w		:= trunc(dt_parametro_p,'month');
 
delete from eis_agenda 
where dt_referencia 	between dt_parametro_w and dt_parametro_fim_w 
and	cd_tipo_agenda	in (3,4,5);
 
 
delete from eis_agenda_consulta_prof 
where dt_referencia 	between dt_parametro_w and dt_parametro_fim_w;
 
insert into Eis_Agenda( 
	dt_referencia, 
	cd_estabelecimento, 
	cd_tipo_agenda, 
	cd_agenda, 
	ie_status_agenda, 
	hr_inicio, 
	cd_motivo_canc, 
	cd_medico, 
	cd_convenio, 
	qt_min_duracao, 
	qt_agenda, 
	cd_setor_atendimento, 
	nm_usuario_agenda, 
	IE_CLASSIF_AGENDA, 
	CD_SETOR_EXECUCAO, 
	nr_seq_sala, 
	ie_tipo_proc_agenda, 
	nm_usuario_original, 
	nr_seq_indicacao, 
	qt_aguardando, 
	qt_consulta, 
	nr_seq_proc_interno, 
	qt_atendimento, 
	cd_setor_exclusivo, 
	qt_procedimento, 
	ie_forma_agendamento, 
	nm_usuario_confirm, 
	ie_clinica, 
	cd_medico_req, 
	ie_classif_tasy, 
	ie_clinica_agenda, 
	nm_usuario_cancelamento, 
	nr_seq_area_atuacao, 
	dt_confirmacao, 
	dt_agendamento, 
	dt_cancelamento, 
	cd_pessoa_fisica, 
	cd_especialidade_agenda, 
	nr_seq_rp_mod_item, 
	ie_atrasado, 
	nr_seq_motivo_atraso, 
	cd_categoria, 
	ie_clinica_pac, 
	cd_turno, 
	nr_seq_forma_confirmacao, 
	nr_seq_motivo_trans, 
	cd_procedencia, 
	nr_seq_motivo_bloqueio) 
SELECT 
	trunc(a.dt_agenda,'dd'), 
	b.cd_estabelecimento, 
	b.cd_tipo_agenda, 
	a.cd_agenda, 
	a.ie_status_agenda, 
	to_char(dt_agenda,'hh24'), 
	a.cd_motivo_cancelamento, 
	CASE WHEN b.cd_tipo_agenda=3 THEN b.cd_pessoa_fisica WHEN b.cd_tipo_agenda=5 THEN a.cd_medico END , 
	a.cd_convenio, 
	sum(nr_minuto_duracao), 
	count(*), 
	a.cd_setor_atendimento, 
	a.nm_usuario, 
	a.IE_CLASSIF_AGENDA, 
	b.cd_setor_exclusivo, 
	a.nr_seq_sala, 
	'P', 
	a.nm_usuario_origem, 
	nr_seq_indicacao, 
	obter_minutos_espera(dt_aguardando, dt_consulta), 
	obter_minutos_espera(a.dt_consulta, a.dt_atendido), 
	a.nr_seq_proc_interno, 
	coalesce(sum(CASE WHEN coalesce(a.nr_atendimento::text, '') = '' THEN  0  ELSE 1 END ),0) qt_atend, 
	b.cd_setor_exclusivo, 
	sum(coalesce(a.qt_procedimento,0)), 
	a.ie_forma_agendamento, 
	a.nm_usuario_confirm, 
	Obter_Clinica_Atend(a.nr_atendimento,'C'), 
	a.cd_medico_req, 
	substr(obter_classif_tasy_agecons(a.ie_classif_agenda),1,15), 
	b.ie_clinica, 
	a.nm_usuario_cancelamento, 
	b.nr_seq_area_atuacao, 
	a.dt_confirmacao, 
	a.dt_agendamento, 
	a.dt_cancelamento, 
	a.cd_pessoa_fisica, 
	b.cd_especialidade, 
	a.nr_seq_rp_mod_item, 
	substr(obter_se_pac_atrasado_agecons(nr_sequencia),1,5), 
	a.nr_seq_motivo_atraso, 
	a.cd_categoria, 
	obter_clinica_pac_agenda(a.dt_agenda,a.cd_pessoa_fisica,'C') ie_clinica_pac, 
	a.cd_turno, 
	a.nr_seq_forma_confirmacao, 
	a.nr_seq_motivo_transf, 
	a.cd_procedencia, 
	NR_SEQ_MOTIVO_BLOQ 
from	Agenda b, 
	Agenda_consulta a 
where 	a.dt_agenda between dt_parametro_w and dt_parametro_fim_w 
 and	a.cd_agenda		= b.cd_agenda 
 and	(ie_status_agenda IS NOT NULL AND ie_status_agenda::text <> '') 
group by b.cd_estabelecimento, 
	b.cd_tipo_agenda, 
	a.cd_agenda, 
	a.ie_status_agenda, 
	to_char(dt_agenda,'hh24'), 
	cd_motivo_cancelamento, 
	CASE WHEN b.cd_tipo_agenda=3 THEN b.cd_pessoa_fisica WHEN b.cd_tipo_agenda=5 THEN a.cd_medico END , 
	a.cd_convenio, 
	a.cd_setor_atendimento, 
	a.nm_usuario, 
	a.IE_CLASSIF_AGENDA, 
	b.cd_setor_exclusivo, 
	a.nr_seq_sala, 
	a.dt_agenda, 
	a.nm_usuario_origem, 
	nr_seq_indicacao, 
	obter_minutos_espera(dt_aguardando, dt_consulta), 
	obter_minutos_espera(a.dt_consulta, a.dt_atendido), 
	a.nr_seq_proc_interno, 
	b.cd_setor_exclusivo, 
	a.ie_forma_agendamento, 
	a.nm_usuario_confirm, 
	Obter_Clinica_Atend(a.nr_atendimento,'C'), 
	a.cd_medico_req, 
	substr(obter_classif_tasy_agecons(a.ie_classif_agenda),1,15), 
	b.ie_clinica, 
	a.nm_usuario_cancelamento, 
	b.nr_seq_area_atuacao, 
	a.dt_confirmacao, 
	a.dt_agendamento, 
	a.dt_cancelamento, 
	a.cd_pessoa_fisica, 
	b.cd_especialidade, 
	a.nr_seq_rp_mod_item, 
	substr(obter_se_pac_atrasado_agecons(a.nr_sequencia),1,5), 
	a.nr_seq_motivo_atraso, 
	a.cd_categoria, 
	obter_clinica_pac_agenda(a.dt_agenda,a.cd_pessoa_fisica,'C'), 
	a.cd_turno, 
	a.nr_seq_forma_confirmacao, 
	a.nr_seq_motivo_transf, 
	a.cd_procedencia, 
	NR_SEQ_MOTIVO_BLOQ;
 
insert into Eis_Agenda( 
	dt_referencia, 
	cd_estabelecimento, 
	cd_tipo_agenda, 
	cd_agenda, 
	ie_status_agenda, 
	hr_inicio, 
	cd_motivo_canc, 
	cd_medico, 
	cd_convenio, 
	qt_min_duracao, 
	qt_agenda, 
	cd_setor_atendimento, 
	nm_usuario_agenda, 
	IE_CLASSIF_AGENDA, 
	CD_SETOR_EXECUCAO, 
	CD_PROC_ADIC, 
	IE_ORIGEM_PROC_ADIC, 
	nr_seq_sala, 
	ie_tipo_proc_agenda, 
	nm_usuario_original, 
	nr_seq_indicacao, 
	qt_aguardando, 
	qt_consulta, 
	nr_seq_proc_interno, 
	qt_atendimento, 
	cd_setor_exclusivo, 
	qt_procedimento, 
	ie_forma_agendamento, 
	nm_usuario_confirm, 
	ie_clinica, 
	cd_medico_req, 
	ie_classif_tasy, 
	ie_clinica_agenda, 
	nm_usuario_cancelamento, 
	nr_seq_area_atuacao, 
	dt_confirmacao, 
	dt_agendamento, 
	dt_cancelamento, 
	cd_pessoa_fisica, 
	cd_especialidade_agenda, 
	nr_seq_rp_mod_item, 
	ie_atrasado, 
	nr_seq_motivo_atraso, 
	cd_categoria, 
	ie_clinica_pac, 
	cd_turno, 
	nr_seq_forma_confirmacao, 
	nr_seq_motivo_trans, 
	cd_procedencia, 
	nr_seq_motivo_bloqueio) 
SELECT 
	trunc(a.dt_agenda,'dd'), 
	b.cd_estabelecimento, 
	b.cd_tipo_agenda, 
	a.cd_agenda, 
	a.ie_status_agenda, 
	to_char(dt_agenda,'hh24'), 
	cd_motivo_cancelamento, 
	CASE WHEN b.cd_tipo_agenda=3 THEN b.cd_pessoa_fisica WHEN b.cd_tipo_agenda=5 THEN a.cd_medico END , 
	a.cd_convenio, 
	sum(nr_minuto_duracao), 
	0, 
	a.cd_setor_atendimento, 
	a.nm_usuario, 
	a.IE_CLASSIF_AGENDA, 
	b.cd_setor_exclusivo, 
	c.CD_PROCedimento, 
	c.IE_ORIGEM_PROCed, 
	a.nr_seq_sala, 
	'A', 
	a.nm_usuario_origem, 
	nr_seq_indicacao, 
	obter_minutos_espera(dt_aguardando, dt_consulta), 
	obter_minutos_espera(a.dt_consulta, a.dt_atendido), 
	c.nr_seq_proc_interno, 
	coalesce(sum(CASE WHEN coalesce(a.nr_atendimento::text, '') = '' THEN  0  ELSE 1 END ),0) qt_atend, 
	b.cd_setor_exclusivo, 
	sum(coalesce(c.qt_procedimento,0)), 
	a.ie_forma_agendamento, 
	a.nm_usuario_confirm, 
	Obter_Clinica_Atend(a.nr_atendimento,'C'), 
	a.cd_medico_req, 
	substr(obter_classif_tasy_agecons(a.ie_classif_agenda),1,15), 
	b.ie_clinica, 
	a.nm_usuario_cancelamento, 
	b.nr_seq_area_atuacao, 
	a.dt_confirmacao, 
	a.dt_agendamento, 
	a.dt_cancelamento, 
	a.cd_pessoa_fisica, 
	b.cd_especialidade, 
	a.nr_seq_rp_mod_item, 
	substr(obter_se_pac_atrasado_agecons(a.nr_sequencia),1,5), 
	a.nr_seq_motivo_atraso, 
	a.cd_categoria, 
	obter_clinica_pac_agenda(a.dt_agenda,a.cd_pessoa_fisica,'C') ie_clinica_pac, 
	a.cd_turno, 
	a.nr_seq_forma_confirmacao, 
	a.nr_seq_motivo_transf, 
	a.cd_procedencia, 
	NR_SEQ_MOTIVO_BLOQ 
from	Agenda b, 
	agenda_consulta_proc c, 
	Agenda_consulta a 
where 	a.dt_agenda between dt_parametro_w and dt_parametro_fim_w 
 and	a.cd_agenda		= b.cd_agenda 
 and	a.nr_sequencia		= c.nr_seq_agenda 
 and	(ie_status_agenda IS NOT NULL AND ie_status_agenda::text <> '') 
group by b.cd_estabelecimento, 
	b.cd_tipo_agenda, 
	a.cd_agenda, 
	a.ie_status_agenda, 
	to_char(dt_agenda,'hh24'), 
	cd_motivo_cancelamento, 
	CASE WHEN b.cd_tipo_agenda=3 THEN b.cd_pessoa_fisica WHEN b.cd_tipo_agenda=5 THEN a.cd_medico END , 
	a.cd_convenio, 
	a.cd_setor_atendimento, 
	a.nm_usuario, 
	a.IE_CLASSIF_AGENDA, 
	a.cd_setor_atendimento, 
	c.CD_PROCedimento, 
	c.IE_ORIGEM_PROCed, 
	a.nr_seq_sala, 
	a.dt_agenda, 
	a.nm_usuario_origem, 
	nr_seq_indicacao, 
	obter_minutos_espera(dt_aguardando, dt_consulta), 
	obter_minutos_espera(a.dt_consulta, a.dt_atendido), 
	c.nr_seq_proc_interno, 
	b.cd_setor_exclusivo, 
	a.ie_forma_agendamento, 
	a.nm_usuario_confirm, 
	Obter_Clinica_Atend(a.nr_atendimento,'C'), 
	a.cd_medico_req, 
	substr(obter_classif_tasy_agecons(a.ie_classif_agenda),1,15), 
	b.ie_clinica, 
	a.nm_usuario_cancelamento, 
	b.nr_seq_area_atuacao, 
	a.dt_confirmacao, 
	a.dt_agendamento, 
	a.dt_cancelamento, 
	a.cd_pessoa_fisica, 
	b.cd_especialidade, 
	a.nr_seq_rp_mod_item, 
	substr(obter_se_pac_atrasado_agecons(a.nr_sequencia),1,5), 
	a.nr_seq_motivo_atraso, 
	a.cd_categoria, 
	obter_clinica_pac_agenda(a.dt_agenda,a.cd_pessoa_fisica,'C'), 
	a.cd_turno, 
	a.nr_seq_forma_confirmacao, 
	a.nr_seq_motivo_transf, 
	a.cd_procedencia, 
	NR_SEQ_MOTIVO_BLOQ;
 
insert into eis_agenda_consulta_prof(cd_estabelecimento, 
	qt_agenda, 
	dt_referencia, 
	ie_tipo_profissional, 
	cd_pessoa_fisica) 
SELECT	c.cd_estabelecimento, 
	count(*), 
	trunc(a.dt_agenda,'dd'), 
	b.ie_tipo_profissional, 
	b.cd_pessoa_fisica 
from	Agenda c, 
	agenda_consulta_prof b, 
	Agenda_consulta a 
where 	a.dt_agenda between dt_parametro_w and dt_parametro_fim_w 
 and	a.cd_agenda		= c.cd_agenda 
 and	a.nr_sequencia		= b.nr_seq_agenda 
 and	(hr_fim IS NOT NULL AND hr_fim::text <> '') 
 and	(hr_inicio IS NOT NULL AND hr_inicio::text <> '') 
 and	(ie_status_agenda IS NOT NULL AND ie_status_agenda::text <> '') 
group by b.ie_tipo_profissional, 
	b.cd_pessoa_fisica, 
	cd_estabelecimento, 
	trunc(a.dt_agenda,'dd');
 
CALL gerar_eis_ocupacao_agenda(dt_parametro_P, nm_usuario_p);
CALL Atualizar_Log_Indicador(clock_timestamp(), nr_sequencia_w);
 
COMMIT;
END;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE gerar_eis_agenda_cons ( dt_parametro_P timestamp, nm_usuario_p text) FROM PUBLIC;

