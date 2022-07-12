-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';

CREATE OR REPLACE VIEW ageint_agendamento_pac_v (cd_agenda, ds_tipo_agenda, ds_agenda, nr_sequencia, dt_agenda, hr_inicio, nm_paciente, nm_medico_req, ds_convenio, ds_status_agenda, nr_atendimento, ds_classif_agenda, ds_dia_semana, ds_estabelecimento, nm_medico, nm_medico_exec, ds_procedimento, ds_setor, ie_pac_lista_espera, nr_reserva, dt_agendamento, ds_observacao, ds_cor_fonte, ds_cor_fundo, cd_pessoa_fisica, nr_minuto_duracao, qt_idade, qt_peso, qt_altura_cm, nr_telefone, ds_protocolo_cancl, ie_anestesia, ds_exame_adic, ds_setor_atendimento, dt_previsto, ds_sexo, nm_usuario_original) AS ( select	a.cd_agenda,
 Obter_Valor_Dominio(2772,CASE WHEN a.CD_TIPO_AGENDA=2 THEN 'E'  ELSE CASE WHEN a.cd_tipo_agenda=3 THEN 'C'  ELSE 'S' END  END ) ds_tipo_agenda, 
	a.ds_agenda, 
	b.nr_sequencia, 
 b.DT_AGENDA, 
	b.hr_inicio,  
	coalesce(substr(obter_nome_pf(b.cd_pessoa_fisica),1,60), substr(b.nm_paciente,1,60)) nm_paciente, 
 SUBSTR(obter_nome_pf(b.cd_medico_req),1,60) nm_medico_req, 
	substr(obter_nome_convenio(b.cd_convenio),1,40) ds_convenio,  
 substr(obter_valor_dominio(83,b.ie_status_agenda),1,30) ds_status_agenda, 
 b.NR_ATENDIMENTO,  
 null ds_classif_agenda, 
 SUBSTR(obter_dia_semana(b.dt_agenda),1,50) ds_dia_semana, 
 SUBSTR(obter_nome_estabelecimento(a.cd_estabelecimento),1,80) ds_estabelecimento,  
	substr(obter_nome_pf(b.cd_medico),1,60) nm_medico, 
	substr(obter_nome_pf(b.cd_medico_exec),1,60) nm_medico_exec, 
	substr(obter_exame_agenda(b.cd_procedimento, b.ie_origem_proced, b.nr_seq_proc_interno),1,240) ds_procedimento, 
 SUBSTR(obter_nome_setor(a.cd_setor_exclusivo),1,40) ds_setor, 
	substr(Obter_se_pac_espera_agenda_pf(b.cd_pessoa_fisica,a.cd_agenda),1,1) ie_pac_lista_espera, 
	b.nr_reserva, 
 b.dt_agendamento, 
 substr(b.ds_observacao,1,255) ds_observacao, 
 null ds_cor_fonte, 
	null ds_cor_fundo, 
	b.cd_pessoa_fisica, 
	b.nr_minuto_duracao,  
	coalesce(b.qt_idade_paciente, obter_dados_pf(b.cd_pessoa_fisica,'I')) qt_idade, 
	b.qt_peso qt_peso, 
	coalesce(b.qt_altura_cm, obter_dados_pf(b.cd_pessoa_fisica, 'AL')) qt_altura_cm, 
	b.nr_telefone, 
 substr(OBTER_PROTOCOLO_CANC_AGE('E',b.nr_sequencia),1,35) DS_PROTOCOLO_CANCL, 
	coalesce(b.ie_anestesia,'N') ie_anestesia,	 
	substr(obter_exame_adic_agenda(b.nr_sequencia),1,240) ds_exame_adic, 
	substr(obter_nome_setor(b.cd_setor_atendimento),1,240) ds_setor_atendimento, 
 null dt_previsto,	 
	substr(Obter_Sexo_PF(b.cd_pessoa_fisica,'D'),1,20) DS_SEXO, 
	null nm_usuario_original 
FROM	agenda a, 
	agenda_paciente b 
where	a.cd_agenda = b.cd_agenda 
and	a.cd_tipo_agenda = 2 
group by 
 a.CD_TIPO_AGENDA, 
	a.cd_agenda, 
	a.ds_agenda, 
 b.DT_AGENDA, 
	b.nr_sequencia, 
	b.hr_inicio, 
 b.dt_agendamento, 
	b.cd_pessoa_fisica, 
	b.nm_paciente, 
 b.cd_medico_req, 
	b.cd_convenio, 
	b.cd_medico, 
	b.cd_medico_exec, 
	b.ie_status_agenda, 
	b.nr_atendimento, 
	b.cd_procedimento, 
	b.ie_origem_proced, 
	b.nr_seq_proc_interno, 
	b.nr_reserva, 
 a.cd_setor_exclusivo, 
	b.cd_pessoa_fisica, 
	b.nr_minuto_duracao, 
 a.cd_estabelecimento, 
	coalesce(b.qt_idade_paciente, obter_dados_pf(b.cd_pessoa_fisica,'I')), 
	b.qt_peso, 
	coalesce(b.qt_altura_cm, obter_dados_pf(b.cd_pessoa_fisica, 'AL')), 
	b.nr_telefone, 
	coalesce(b.ie_anestesia,'N'), 
	substr(b.ds_observacao,1,255), 
	substr(obter_exame_adic_agenda(b.nr_sequencia),1,240), 
	substr(obter_nome_setor(b.cd_setor_atendimento),1,240), 
	substr(OBTER_PROTOCOLO_CANC_AGE('E',b.nr_sequencia),1,35)  
 
union all
  
 SELECT	a.cd_agenda,  
 Obter_Valor_Dominio(2772,CASE WHEN a.CD_TIPO_AGENDA=2 THEN 'E'  ELSE CASE WHEN a.cd_tipo_agenda=3 THEN 'C'  ELSE 'S' END  END ) ds_tipo_agenda, 
	SUBSTR(obter_nome_medico_combo_agcons(a.cd_estabelecimento, a.cd_agenda, a.cd_tipo_agenda, a.ie_ordenacao),1,240) ds_agenda, 
	b.nr_sequencia, 
	b.dt_agenda, 
 null hr_inicio, 
	coalesce(SUBSTR(obter_nome_pf(b.cd_pessoa_fisica),1,60), SUBSTR(b.nm_paciente,1,60)) nm_paciente, 
 SUBSTR(obter_nome_pf(b.cd_medico_req),1,60) nm_medico_req, 
	SUBSTR(obter_nome_convenio(b.cd_convenio),1,40) ds_convenio, 
	SUBSTR(obter_valor_dominio(83,b.ie_status_agenda),1,30) ds_status_agenda, 
	b.nr_atendimento,	 
	SUBSTR(Obter_classif_agenda_consulta(b.ie_classif_agenda),1,40) ds_classif_agenda, 
	SUBSTR(obter_dia_semana(b.dt_agenda),1,50) ds_dia_semana, 
	SUBSTR(obter_nome_estabelecimento(a.cd_estabelecimento),1,80) ds_estabelecimento,	 
 substr(obter_nome_pf(b.cd_medico),1,60) nm_medico, 
 '' nm_medico_exec, 
 substr(obter_exame_agenda(b.cd_procedimento, b.IE_ORIGEM_PROCED, b.NR_SEQ_PROC_INTERNO),1,240) ds_procedimento, 
	SUBSTR(obter_nome_setor(a.cd_setor_exclusivo),1,40) ds_setor, 
 substr(Obter_se_pac_espera_agenda_pf(b.cd_pessoa_fisica,a.cd_agenda),1,1) ie_pac_lista_espera, 
 b.nr_reserva, 
	b.dt_agendamento, 
	SUBSTR(b.ds_observacao,1,255) ds_observacao, 
	(SELECT ds_cor_fonte FROM agenda_classif WHERE cd_classificacao = b.ie_classif_agenda) ds_cor_fonte, 
	(SELECT ds_cor_fundo FROM agenda_classif WHERE cd_classificacao = b.ie_classif_agenda) ds_cor_fundo, 
	b.cd_pessoa_fisica, 
	b.nr_minuto_duracao, 
	coalesce(b.qt_idade_pac, obter_dados_pf(b.cd_pessoa_fisica,'I')) qt_idade, 
	b.qt_peso, 
	coalesce(b.qt_altura_cm, obter_dados_pf(b.cd_pessoa_fisica, 'AL')) qt_altura_cm, 
	b.nr_telefone,	 
	substr(OBTER_PROTOCOLO_CANC_AGE('C',b.nr_sequencia),1,35) DS_PROTOCOLO_CANCL, 
 null ie_anestesia, 
substr(obter_exame_adic_agenda(b.nr_sequencia),1,240) ds_exame_adic, 
	substr(obter_nome_setor(b.cd_setor_atendimento),1,240) ds_setor_atendimento, 
 null dt_previsto,	 
	substr(Obter_Sexo_PF(b.cd_pessoa_fisica,'D'),1,20) DS_SEXO, 
	null nm_usuario_original 
FROM	agenda a, 
	agenda_consulta b 
WHERE	a.cd_agenda = b.cd_agenda 
AND	a.cd_tipo_agenda in (3, 5) 
GROUP BY 
 a.CD_TIPO_AGENDA, 
	a.cd_agenda, 
	a.cd_estabelecimento, 
	--a.cd_tipo_agenda, 
	b.nr_sequencia, 
	b.dt_agenda, 
	b.cd_pessoa_fisica, 
	b.nm_paciente, 
	b.cd_convenio, 
 b.nr_reserva, 
	b.cd_medico_req, 
 b.cd_medico, 
	b.ie_status_agenda, 
	b.nr_atendimento, 
	b.ie_classif_agenda, 
	a.ie_ordenacao, 
 b.cd_setor_atendimento, 
	a.cd_setor_exclusivo, 
	b.dt_agendamento, 
	b.ds_observacao, 
	b.cd_pessoa_fisica, 
	b.nr_minuto_duracao, 
 b.cd_procedimento, 
 b.IE_ORIGEM_PROCED, 
 b.NR_SEQ_PROC_INTERNO, 
	coalesce(b.qt_idade_pac, obter_dados_pf(b.cd_pessoa_fisica,'I')), 
	b.qt_peso,	 
	coalesce(b.qt_altura_cm, obter_dados_pf(b.cd_pessoa_fisica, 'AL')), 
	b.nr_telefone, 
	OBTER_PROTOCOLO_CANC_AGE('C',b.nr_sequencia) 

union all
 
select 	null cd_agenda, 
	Obter_Valor_Dominio(2772,'CH'),	 
	null ds_agenda, 
	a.nr_sequencia, 
	null dt_agenda, 
	null hr_inicio, 
	substr(obter_nome_pf(a.CD_PESSOA_FISICA),1,60) NM_PACIENTE ,	 
	null cd_medico_req, 
	substr(obter_nome_convenio(a.cd_convenio),1,40) ds_convenio,		 
	null ds_status_agenda, 
	a.nr_atendimento,	 
	null ds_classif_agenda, 
	null ds_dia_semana, 
	SUBSTR(obter_nome_estabelecimento(a.cd_estabelecimento),1,80) ds_estabelecimento,	 
	null nm_medico,	 
	null nm_medico_exec, 
	null ds_procedimento, 
	null ds_setor, 
	null ie_pac_lista_espera, 
	null nr_reserva, 
	a.dt_agendamento, 
	substr(a.ds_observacao,1,255) ds_observacao, 
	null ds_cor_fonte, 
	null ds_cor_fundo, 
	a.cd_pessoa_fisica, 
	null nr_minuto_duracao,	 
 null qt_idade, 
	(obter_dados_pf(a.cd_pessoa_fisica,'KG'))::numeric  qt_peso, 
	(obter_dados_pf(a.cd_pessoa_fisica, 'AL'))::numeric  qt_altura_cm, 
	coalesce(a.nr_telefone, SUBSTR(obter_dados_pf(a.cd_pessoa_fisica, 'TC'),1,40)) NR_TELEFONE, 
	null DS_PROTOCOLO_CANCL, 
	null ie_anestesia, 
	null ds_exame_adic, 
	substr(obter_nome_setor(a.CD_SETOR_ATENDIMENTO),1,60) DS_SETOR_ATENDIMENTO,	 
	a.dt_previsto dt_previsto,	 
	substr(Obter_Sexo_PF(a.cd_pessoa_fisica,'D'),1,20) DS_SEXO, 
	a.nm_usuario_original nm_usuario_original 
from 	CHECKUP a );

