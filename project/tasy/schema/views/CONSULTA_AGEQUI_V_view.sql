-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';

CREATE OR REPLACE VIEW consulta_agequi_v (cd_agenda, ds_agenda, cd_tipo_agenda, ds_tipo_agenda, cd_estabelecimento, ds_estabelecimento, cd_medico_agenda, nm_medico_agenda, ie_situacao, nr_sequencia, dt_agenda, hr_inicio, hr_hora, hr_hora_html5, nr_minuto_duracao, ie_status_atendimento, ie_status_agenda, ds_status_agenda, ie_classif_agenda, ds_classif_agenda, cd_pessoa_fisica, nm_paciente_pf, nm_paciente, nm_cliente, cd_medico, nm_medico, cd_medico_exec, nm_medico_exec, cd_convenio, cd_categoria, cd_plano, cd_procedencia, ds_convenio, nr_atendimento, cd_procedimento, ie_origem_proced, nr_seq_proc_interno, ds_procedimento, nr_telefone, qt_min_espera_tasy, ds_observacao, cd_turno, dt_confirmacao, cd_setor_atendimento, cd_setor_agenda, ds_sala, ds_tipo_pendencia, ds_complemento, ds_curta, nr_pront_ext, ds_motivo_cancelamento, ds_dia_semana, nr_prontuario_pf, ie_encaixe, nm_responsavel, ds_observacao_final, ie_anestesia, cd_especialidade, ds_especialidade, nm_usuario_origem, dt_agendamento) AS select	a.nr_sequencia cd_agenda,
	a.ds_local ds_agenda, 
	9 cd_tipo_agenda, 
	'Quimioterapia' ds_tipo_agenda, 
	a.cd_estabelecimento, 
	substr(obter_nome_estabelecimento(a.cd_estabelecimento),1,80) ds_estabelecimento, 
	'' cd_medico_agenda, 
	'' nm_medico_agenda, 
	a.ie_situacao, 
	b.nr_sequencia, 
	trunc(b.dt_agenda,'dd') dt_agenda, 
	b.dt_agenda hr_inicio, 
	to_char(b.dt_agenda,'hh24:mi') hr_hora, 
	b.dt_agenda hr_hora_html5, 
	b.nr_minuto_duracao, 
	substr(y.ie_status_atendimento,1,1) ie_status_atendimento, 
	b.ie_status_agenda,	 
	i.ds_valor_dominio ds_status_agenda,--substr(obter_valor_dominio(3192,b.ie_status_agenda),1,60) ds_status_agenda, 
	'' ie_classif_agenda, 
	'' ds_classif_agenda, 
	b.cd_pessoa_fisica, 
	substr(c.nm_pessoa_fisica,1,60) nm_paciente_pf, 
	substr(c.nm_pessoa_fisica,1,255) nm_paciente, 
	substr(c.nm_pessoa_fisica,1,60) nm_cliente, 
	e.cd_medico_resp cd_medico, 
	substr(obter_nome_pf(e.cd_medico_resp),1,60) nm_medico, 
	'' cd_medico_exec, 
	'' nm_medico_exec, 
	f.cd_convenio, 
	f.cd_categoria, 
	f.cd_plano, 
	null cd_procedencia,	 
	k.ds_convenio ds_convenio,--substr(obter_nome_convenio(f.cd_convenio),1,40) ds_convenio, 
	d.nr_atendimento, 
	null cd_procedimento, 
	null ie_origem_proced, 
	null nr_seq_proc_interno, 
	'' ds_procedimento, 
	'' nr_telefone, 
	--substr(obter_fone_pac_agenda(b.cd_pessoa_fisica),1,255) ds_telefone_cad, 
	--substr(obter_idade(c.dt_nascimento, b.dt_agenda, 'S'),1,30) ds_idade, 
	round((coalesce(y.dt_alta, LOCALTIMESTAMP) - y.dt_entrada) * 1440) qt_min_espera_tasy, 
	'' ds_observacao, 
	'' cd_turno, 
	null dt_confirmacao, 
	null cd_setor_atendimento, 
	null cd_setor_agenda, 
	'' ds_sala,	 
	j.ds_valor_dominio ds_tipo_pendencia,--substr(obter_valor_dominio(3117, b.ie_tipo_pend_agenda),1,60) ds_tipo_pendencia, 
	--null cd_usuario_convenio, 
	null ds_complemento, 
	'' ds_curta, 
	c.nr_pront_ext, 
	'' ds_motivo_cancelamento, 
	substr(obter_valor_dominio(35,obter_cod_dia_semana(b.dt_agenda)),1,255) ds_dia_semana, 
	substr(obter_prontuario_pf(a.cd_estabelecimento,b.cd_pessoa_fisica),1,15) nr_prontuario_pf, 
	b.ie_encaixe, 
	substr(obter_nome_pf(y.cd_medico_resp),1,255) nm_responsavel, 
	'' ds_observacao_final, 
	'' ie_anestesia, 
	null cd_especialidade, 
	'' ds_especialidade, 
	b.nm_usuario_nrec nm_usuario_origem, 
	b.dt_atualizacao_nrec dt_agendamento 
FROM paciente_setor e, qt_local a, paciente_setor_convenio f
LEFT OUTER JOIN convenio k ON (f.cd_convenio = k.cd_convenio)
, agenda_quimio b
LEFT OUTER JOIN valor_dominio j ON (b.ie_tipo_pend_agenda = j.vl_dominio)
LEFT OUTER JOIN valor_dominio i ON (b.ie_status_agenda = i.vl_dominio)
LEFT OUTER JOIN paciente_atendimento d ON (b.nr_seq_atendimento = d.nr_seq_atendimento)
LEFT OUTER JOIN pessoa_fisica c ON (b.cd_pessoa_fisica = c.cd_pessoa_fisica)
LEFT OUTER JOIN paciente_setor_convenio f ON (d.nr_seq_paciente = f.nr_seq_paciente)
LEFT OUTER JOIN atendimento_paciente y ON (d.nr_atendimento = y.nr_atendimento)
WHERE a.nr_sequencia		= b.nr_seq_local  and i.cd_dominio		= 3192 and j.cd_dominio		= 3117     and e.nr_seq_paciente	= d.nr_seq_paciente   and b.nr_seq_atendimento is not null 
 
union
 
select	a.nr_sequencia cd_agenda, 
	a.ds_local ds_agenda, 
	9 cd_tipo_agenda, 
	'Quimioterapia' ds_tipo_agenda, 
	a.cd_estabelecimento, 
	substr(obter_nome_estabelecimento(a.cd_estabelecimento),1,80) ds_estabelecimento, 
	'' cd_medico_agenda, 
	'' nm_medico_agenda, 
	a.ie_situacao, 
	b.nr_sequencia, 
	trunc(b.dt_agenda,'dd') dt_agenda, 
	b.dt_agenda hr_inicio, 
	to_char(b.dt_agenda,'hh24:mi') hr_hora, 
	b.dt_agenda hr_hora_html5, 
	b.nr_minuto_duracao, 
				'' ie_status_atendimento, 
	b.ie_status_agenda,	 
	i.ds_valor_dominio ds_status_agenda, 
	'' ie_classif_agenda, 
	'' ds_classif_agenda, 
	b.cd_pessoa_fisica, 
	substr(c.nm_pessoa_fisica,1,60) nm_paciente_pf, 
	'' nm_paciente, 
	substr(c.nm_pessoa_fisica,1,60) nm_cliente, 
				'' cd_medico_resp, 
				'' mn_medico , 
	'' cd_medico_exec, 
	'' nm_medico_exec, 
					d.cd_convenio, 
					d.cd_categoria, 
					d.cd_plano, 
	null cd_procedencia,	 
	k.ds_convenio ds_convenio, 
				null nr_atendimento, 
	null cd_procedimento, 
	null ie_origem_proced, 
	null nr_seq_proc_interno, 
	'' ds_procedimento, 
	'' nr_telefone, 
				null qt_min_espera_tasy, 
	'' ds_observacao, 
	'' cd_turno, 
	null dt_confirmacao, 
	null cd_setor_atendimento, 
	null cd_setor_agenda, 
	'' ds_sala,	 
	j.ds_valor_dominio ds_tipo_pendencia,	 
	null ds_complemento, 
	'' ds_curta, 
	c.nr_pront_ext, 
	'' ds_motivo_cancelamento, 
	substr(obter_valor_dominio(35,obter_cod_dia_semana(b.dt_agenda)),1,255) ds_dia_semana, 
	substr(obter_prontuario_pf(a.cd_estabelecimento,b.cd_pessoa_fisica),1,15) nr_prontuario_pf, 
	b.ie_encaixe, 
	'' nm_responsavel, 
	'' ds_observacao_final, 
	'' ie_anestesia, 
	null cd_especialidade, 
	'' ds_especialidade, 
	b.nm_usuario_nrec, 
	b.dt_atualizacao_nrec dt_agendamento 
FROM convenio k, agenda_integrada_item e, agenda_integrada d, qt_local a, agenda_quimio b
LEFT OUTER JOIN valor_dominio j ON (b.ie_tipo_pend_agenda = j.vl_dominio)
LEFT OUTER JOIN valor_dominio i ON (b.ie_status_agenda = i.vl_dominio)
LEFT OUTER JOIN pessoa_fisica c ON (b.cd_pessoa_fisica = c.cd_pessoa_fisica)
WHERE a.nr_sequencia		= b.nr_seq_local and i.cd_dominio		= 3192 and j.cd_dominio		= 3117 and e.nr_seq_agequi	= b.nr_Sequencia and d.nr_sequencia = e.nr_seq_agenda_int    and d.cd_convenio	= k.cd_convenio and b.nr_seq_atendimento is null;
