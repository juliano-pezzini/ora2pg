-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';

CREATE OR REPLACE VIEW consulta_ageexam_v (cd_agenda, ds_agenda, cd_tipo_agenda, ds_tipo_agenda, ie_agendamento_coletivo, cd_estabelecimento, ds_estabelecimento, cd_medico_agenda, nm_medico_agenda, ie_situacao, nr_sequencia, dt_agenda, hr_inicio, hr_hora, hr_hora_html5, nr_minuto_duracao, ie_status_atendimento, ie_status_agenda, ds_status_agenda, ie_classif_agenda, ds_classif_agenda, cd_pessoa_fisica, nm_paciente_pf, nm_paciente, nm_cliente, cd_medico, nm_medico, cd_medico_exec, nm_medico_exec, cd_convenio, cd_categoria, cd_plano, cd_procedencia, ds_convenio, nr_atendimento, cd_procedimento, ie_origem_proced, nr_seq_proc_interno, ds_procedimento, nr_telefone, qt_min_espera_tasy, ds_observacao, cd_turno, dt_confirmacao, cd_setor_atendimento, cd_setor_agenda, ds_sala, ds_tipo_pendencia, ds_complemento, ds_curta, nr_pront_ext, ds_motivo_cancelamento, ds_dia_semana, nr_prontuario_pf, ie_encaixe, nm_responsavel, ds_observacao_final, ie_anestesia, cd_especialidade, ds_especialidade, nm_usuario_origem, dt_agendamento) AS select	a.cd_agenda,
	a.ds_agenda,
	a.cd_tipo_agenda,
	substr(obter_valor_dominio(34, a.cd_tipo_agenda),1,255) ds_tipo_agenda,
	(select max(I.ie_agend_coletivo) FROM agenda_integrada I, agenda_integrada_item C, agenda_consulta t
    	where I.nr_sequencia = C.nr_seq_agenda_int
    	and C.NR_SEQ_AGENDA_CONS = t.nr_sequencia
    	and t.NR_SEQ_AGEPACI = b.NR_SEQUENCIA) as ie_agendamento_coletivo,
	a.cd_estabelecimento,
	substr(obter_nome_estabelecimento(a.cd_estabelecimento),1,80) ds_estabelecimento,
	a.cd_pessoa_fisica cd_medico_agenda,
	substr(p.nm_pessoa_fisica,1,60) nm_medico_agenda,
	a.ie_situacao,
	b.nr_sequencia,
	b.dt_agenda,
	b.hr_inicio,
	to_char(b.hr_inicio,'hh24:mi') hr_hora,
	b.hr_inicio hr_hora_html5,
	b.nr_minuto_duracao,
	substr(y.ie_status_atendimento,1,1) ie_status_atendimento,
	b.ie_status_agenda,
	substr(obter_valor_dominio(83, b.ie_status_agenda),1,255) ds_status_agenda,
	to_char(b.nr_seq_classif_agenda) ie_classif_agenda,
	substr(f.ds_classificacao,1,80) ds_classif_agenda,
	b.cd_pessoa_fisica,
	substr(C.nm_pessoa_fisica,1,60) nm_paciente_pf,
	b.nm_paciente,
	CASE WHEN b.cd_pessoa_fisica IS NULL THEN b.nm_paciente  ELSE substr(C.nm_pessoa_fisica,1,60) END  nm_cliente,
	coalesce(b.cd_medico, (select obter_medico_consulta_agepac(b.nr_sequencia, 'C') )) cd_medico,	
	substr(coalesce(m.nm_pessoa_fisica, (select obter_medico_consulta_agepac(b.nr_sequencia, 'N') )),1,60) nm_medico,
	b.cd_medico_exec,
	substr(z.nm_pessoa_fisica,1,60) nm_medico_exec,
	b.cd_convenio,
	b.cd_categoria,
	b.cd_plano,
	b.cd_procedencia,
	substr(x.ds_convenio,1,40) ds_convenio,
	b.nr_atendimento,
	b.cd_procedimento,
	b.ie_origem_proced,
	b.nr_seq_proc_interno,
	substr(obter_exame_agenda(b.cd_procedimento,b.ie_origem_proced,b.nr_seq_proc_interno),1,240) ds_procedimento,
	b.nr_telefone,
	--substr(obter_fone_pac_agenda(b.cd_pessoa_fisica),1,255) ds_telefone_cad,

	--substr(obter_idade(nvl(b.dt_nascimento_pac, c.dt_nascimento), b.dt_agenda, 'S'),1,30) ds_idade,

	round((coalesce(y.dt_alta, LOCALTIMESTAMP) - y.dt_entrada) * 1440) qt_min_espera_tasy,
	substr(b.ds_observacao,1,255) ds_observacao,
	b.cd_turno,
	b.dt_confirmacao,
	b.cd_setor_atendimento,
	a.cd_setor_agenda,
	'' ds_sala,
	'' ds_tipo_pendencia,
	--b.cd_usuario_convenio,

	substr(a.ds_complemento,1,60) ds_complemento,
	a.ds_curta,
	C.nr_pront_ext,
	substr(Obter_motivo_canc_consulta_ag(a.cd_tipo_agenda,b.cd_motivo_cancelamento),1,255) ds_motivo_cancelamento,
	substr(obter_valor_dominio(35,obter_cod_dia_semana(b.dt_agenda)),1,255) ds_dia_semana,
	substr(obter_prontuario_pf(a.cd_estabelecimento,b.cd_pessoa_fisica),1,15) nr_prontuario_pf,
	b.ie_encaixe,
	substr(obter_nome_pf(y.cd_medico_resp),1,255) nm_responsavel,
	substr(ageint_obter_observacao_final(null, b.nr_sequencia),1,255) ds_observacao_final,
	b.ie_anestesia ie_anestesia,
	a.cd_especialidade cd_especialidade,
	substr(obter_desc_espec_medica(a.cd_especialidade),1,240) ds_especialidade,
	b.nm_usuario_orig nm_usuario_origem,
	b.dt_agendamento dt_agendamento
FROM agenda_paciente b
LEFT OUTER JOIN agenda_paciente_classif f ON (b.nr_seq_classif_agenda = f.nr_sequencia)
LEFT OUTER JOIN pessoa_fisica c ON (b.cd_pessoa_fisica = C.cd_pessoa_fisica)
LEFT OUTER JOIN pessoa_fisica m ON (b.cd_medico = m.cd_pessoa_fisica)
LEFT OUTER JOIN pessoa_fisica z ON (b.cd_medico_exec = z.cd_pessoa_fisica)
LEFT OUTER JOIN convenio x ON (b.cd_convenio = x.cd_convenio)
LEFT OUTER JOIN atendimento_paciente y ON (b.nr_atendimento = y.nr_atendimento)
, agenda a
LEFT OUTER JOIN pessoa_fisica p ON (a.cd_pessoa_fisica = p.cd_pessoa_fisica)
WHERE a.cd_agenda		= b.cd_agenda  and a.cd_tipo_agenda	= 2;
