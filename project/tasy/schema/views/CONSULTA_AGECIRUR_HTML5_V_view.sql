-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';

CREATE OR REPLACE VIEW consulta_agecirur_html5_v (cd_agenda, ds_agenda, cd_tipo_agenda, cd_estabelecimento, ie_situacao, nr_sequencia, dt_agenda, hr_inicio, nr_minuto_duracao, ie_status_agenda, ie_classif_agenda, ds_valor_dominio, ds_classificacao, cd_pessoa_fisica, nm_paciente, cd_medico, nm_medico, nm_medico_exec, cd_convenio, cd_categoria, cd_plano, cd_procedencia, ds_convenio, nr_atendimento, cd_procedimento, ie_origem_proced, nr_seq_proc_interno, ds_observacao, ds_complemento, ds_curta, nr_pront_ext, cd_motivo_cancelamento, ie_encaixe, cd_medico_resp, ie_anestesia, cd_especialidade, nm_usuario_origem, dt_agendamento, nm_medico_agendamento, ie_reference_letter, ie_emergency_response_required, ds_procedencia, nr_seq_status_pac) AS select	a.cd_agenda,
	a.ds_agenda,
	a.cd_tipo_agenda,	
	a.cd_estabelecimento,
	a.ie_situacao,
	b.nr_sequencia,
	b.dt_agenda,
	b.hr_inicio,	
	b.nr_minuto_duracao,	
	b.ie_status_agenda,
	to_char(b.nr_seq_classif_agenda) ie_classif_agenda,	
	substr(obter_valor_dominio(83,b.ie_status_agenda),1,255) ds_valor_dominio,	
	f.ds_classificacao,
	b.cd_pessoa_fisica,	
	b.nm_paciente,
	coalesce(b.cd_medico, (select obter_medico_consulta_agepac(b.nr_sequencia, 'C') )) cd_medico,	
	substr(coalesce(m.nm_pessoa_fisica, (select obter_medico_consulta_agepac(b.nr_sequencia, 'N') )),1,60) nm_medico,
	z.nm_pessoa_fisica nm_medico_exec,	
	b.cd_convenio,
	b.cd_categoria,
	b.cd_plano,
	b.cd_procedencia,
	x.ds_convenio,
	b.nr_atendimento,
	b.cd_procedimento,
	b.ie_origem_proced,
	b.nr_seq_proc_interno,	
	b.ds_observacao,	
	a.ds_complemento,
	a.ds_curta,
	c.nr_pront_ext,
	b.cd_motivo_cancelamento,	
	b.ie_encaixe,
	y.cd_medico_resp,	
	b.ie_anestesia ie_anestesia,
	a.cd_especialidade,	
	b.nm_usuario_orig nm_usuario_origem,
	b.dt_agendamento,
	'' nm_medico_agendamento,
	auxi.ie_reference_letter ,
	auxi.ie_emergency_response_required,
	coalesce(obter_desc_procedencia(b.cd_procedencia), auxi.ds_procedencia_var) ds_procedencia,
  null nr_seq_status_pac
FROM agenda_paciente b
LEFT OUTER JOIN agenda_paciente_classif f ON (b.nr_seq_classif_agenda = f.nr_sequencia)
LEFT OUTER JOIN pessoa_fisica c ON (b.cd_pessoa_fisica = c.cd_pessoa_fisica)
LEFT OUTER JOIN pessoa_fisica m ON (b.cd_medico = m.cd_pessoa_fisica)
LEFT OUTER JOIN pessoa_fisica z ON (b.cd_medico_exec = z.cd_pessoa_fisica)
LEFT OUTER JOIN convenio x ON (b.cd_convenio = x.cd_convenio)
LEFT OUTER JOIN atendimento_paciente y ON (b.nr_atendimento = y.nr_atendimento)
LEFT OUTER JOIN agenda_paciente_auxiliar auxi ON (b.nr_sequencia = auxi.nr_seq_agenda)
, agenda a
LEFT OUTER JOIN pessoa_fisica p ON (a.cd_pessoa_fisica = p.cd_pessoa_fisica)
WHERE a.cd_agenda		= b.cd_agenda  and a.cd_tipo_agenda	= 1;

