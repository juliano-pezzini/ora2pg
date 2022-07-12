-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';

CREATE OR REPLACE VIEW waiting_list_sched_v (nr_seq_lista, nm_pessoa_lista, ds_convenio_lista, dt_desejada_lista, ds_grupo, ds_exame_espec_lista, ds_label, ie_urgente, nr_proc_interno, cd_pessoa_fisica, cd_medico, cd_medico_exec, cd_convenio, cd_categoria, cd_especialidade, cd_procedimento, ie_origem_proced, nr_seq_classif_agenda, dt_agendamento, nr_minuto_duracao, cd_agenda, cd_tipo_agenda, ds_sexo_paciente, cd_sexo_paciente, ie_isolado, ds_isolado, ie_special_approval, ie_allergic, ds_allergic, dt_nascimento, ds_motivo_bloqueio, nr_atendimento, ds_classificacao, ds_convenio, ie_planned, nr_episodio, ds_procedimento, ds_status_agenda, ds_tipo_episodio, ds_indicacao, ds_observacao, nm_medico_req, ds_setor_atendimento, ds_tipo_remocao, cd_doenca, ds_setor_desejado, hr_inicio, hr_fim, cd_paciente, nr_application_code, nr_inss_wjtf, cd_setor_atendimento, cd_departamento_medico, cd_setor, dt_desejada, cd_tipo_agenda_lista_espera, ie_status_espera) AS SELECT		a.nr_sequencia nr_seq_lista,
		coalesce(s.nm_pessoa_fisica, a.nm_pessoa_lista) nm_pessoa_lista,
		obter_desc_tipo_convenio(a.cd_convenio) ds_convenio_lista,
		date_as_varchar2(a.dt_desejada, (SELECT CASE l.ds_locale WHEN 'de_AT' THEN 'short' ELSE 'shortDate' END FROM user_locale l where nm_user = WHEB_USUARIO_PCK.GET_NM_USUARIO)) dt_desejada_lista,
		CASE WHEN obter_exame_lista_agenda(a.nr_sequencia) IS NULL THEN 'SERVICE'  ELSE 'EXAM' END  ds_grupo,
		CASE WHEN obter_exame_lista_agenda(a.nr_sequencia) IS NULL THEN CASE WHEN obter_desc_espec_medica(a.cd_especialidade) IS NULL THEN obter_desc_expressao(327119)  ELSE obter_desc_espec_medica(a.cd_especialidade) END   ELSE obter_exame_lista_agenda(a.nr_sequencia) END  ds_exame_espec_lista,
		CASE WHEN obter_exame_lista_agenda(a.nr_sequencia) IS NULL THEN obter_desc_expressao(314890)  ELSE obter_desc_expressao(10652383) END  ds_label,
		coalesce(a.ie_urgente, 'N') ie_urgente,TO_CHAR(a.nr_seq_proc_interno) nr_proc_interno,
		a.cd_pessoa_fisica,a.cd_medico,a.cd_medico_exec,
		a.cd_convenio,a.cd_categoria,a.cd_especialidade,
		a.cd_procedimento,a.ie_origem_proced,a.nr_seq_classif_agenda,
		a.dt_agendamento,a.nr_minuto_duracao,a.cd_agenda,
		obter_tipo_agenda(a.cd_agenda) cd_tipo_agenda,
		obter_sexo_pf(a.cd_pessoa_fisica, 'D') ds_sexo_paciente,
		obter_sexo_pf(a.cd_pessoa_fisica, 'C') cd_sexo_paciente,
		(select max(i.ie_paciente_isolado) from atendimento_paciente i where i.nr_atendimento = a.nr_atendimento) ie_isolado,
		obter_desc_expressao(295168) ds_isolado,
		GET_CPOE_PROC_APPROVED(a.nr_sequencia) ie_special_approval,
		Obter_Se_Pac_Alerta_Alergia(a.cd_pessoa_fisica) ie_allergic,
		obter_desc_expressao(350887) ds_allergic,
		to_char(OBTER_DATA_NASCTO_PF(a.cd_pessoa_fisica), pkg_date_formaters.localize_mask('shortDate',pkg_date_formaters.getUserLanguageTag(WHEB_USUARIO_PCK.get_cd_estabelecimento ,WHEB_USUARIO_PCK.GET_NM_USUARIO))) dt_nascimento,
		CASE WHEN ageint_obter_mot_bloq(a.cd_agenda, ap.dt_agenda, obter_cod_dia_semana(ap.dt_agenda)) IS NULL THEN  obter_desc_motivo_agenda(ap.nr_seq_motivo_bloq)  ELSE ageint_obter_mot_bloq(a.cd_agenda, ap.dt_agenda, obter_cod_dia_semana(ap.dt_agenda)) END  ds_motivo_bloqueio,
		a.nr_atendimento,
		obter_dados_item_ageint(null, ap.nr_sequencia, null, 'C') ds_classificacao,
		COALESCE(Obter_desc_convenio(Obter_Convenio_Atendimento(a.nr_atendimento)),Obter_Nome_Convenio(a.cd_convenio)) ds_convenio,
		CASE WHEN(coalesce(a.nr_atendimento, 0) > 0 and (obter_se_atendimento_futuro(a.nr_atendimento) = 'S')) THEN 'P' ELSE null END ie_planned,
		CASE WHEN OBTER_EPISODIO_ATENDIMENTO(a.nr_atendimento)=0 THEN  null  ELSE obter_episodio_atend_tela(a.nr_atendimento) END  nr_episodio,
		SUBSTR(obter_exame_agenda(a.cd_procedimento, a.ie_origem_proced, a.nr_seq_proc_interno),1,240) ds_procedimento,
		CASE WHEN ap.dt_confirmacao IS NULL THEN  substr(obter_valor_dominio(83, ap.ie_status_agenda),1,200)  ELSE substr(obter_valor_dominio(83, 'CN'),1,200) END  ds_status_agenda,
		obter_nome_tipo_episodio((SELECT nr_seq_tipo_episodio FROM EPISODIO_PACIENTE WHERE NR_SEQUENCIA = OBTER_EPISODIO_ATENDIMENTO(a.nr_atendimento))) ds_tipo_episodio,
		obter_desc_indicacao_ageint(ap.nr_sequencia,'P') ds_indicacao,
		a.ds_observacao,
		obter_nome_pf_pj(ap.cd_medico_req, null) nm_medico_req,
		COALESCE(obter_desc_setor_atend(a.cd_setor_atendimento), obter_desc_setor_atend(ap.cd_setor_atendimento)) ds_setor_atendimento,
		(SELECT max(tr.ds_tipo_remocao) FROM TRANS_TIPO_REMOCAO tr, cpoe_procedimento cp WHERE tr.nr_sequencia = cp.nr_seq_tipo_remocao AND cp.nr_atendimento = a.nr_atendimento) ds_tipo_remocao,
		(SELECT max(cd_doenca) FROM diagnostico_doenca diag WHERE diag.ie_classificacao_doenca = 'P' AND diag.ie_tipo_diagnostico IN (2, 3) AND diag.nr_atendimento = a.nr_atendimento) cd_doenca,
		(SELECT max(sa.ds_descricao) FROM setor_atendimento sa, atendimento_paciente ate WHERE sa.cd_setor_atendimento = ate.cd_setor_desejado AND ate.nr_atendimento = ap.nr_atendimento) ds_setor_desejado,
		TO_CHAR(ap.hr_inicio,'hh24:mi') hr_inicio,
		TO_CHAR(ap.hr_inicio+(ap.nr_minuto_duracao/1440),'hh24:mi') hr_fim, 
		a.cd_pessoa_fisica CD_PACIENTE,
		ap.nr_application_code nr_application_code,
		(select nr_inss from pessoa_fisica pf where pf.cd_pessoa_fisica = a.cd_pessoa_fisica) NR_INSS_WJTF,
		a.cd_setor_atendimento,
		a.cd_departamento_medico,
		obter_ultimo_setor_atendimento(a.nr_atendimento) cd_setor,
		a.DT_DESEJADA,
		a.cd_tipo_agenda cd_tipo_agenda_lista_espera,
		a.ie_status_espera
FROM	agenda_lista_espera a
	left join TABLE(search_names_dev(NULL,a.cd_pessoa_fisica,NULL,'list',NULL)) s 
	ON (a.cd_pessoa_fisica = s.cd_pessoa_fisica)
	left outer join agenda_paciente ap on ap.nr_sequencia = a.nr_seq_agenda
	left outer join agenda_consulta ac on ac.cd_agenda = ap.cd_agenda;

