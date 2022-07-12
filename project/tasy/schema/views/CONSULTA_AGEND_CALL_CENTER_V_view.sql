-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';

CREATE OR REPLACE VIEW consulta_agend_call_center_v (cd_agenda, ds_agenda, cd_tipo_agenda, ds_tipo_agenda, cd_estabelecimento, ds_estabelecimento, cd_medico_agenda, nm_medico_agenda, ie_situacao, nr_sequencia, dt_agenda, hr_inicio, hr_hora, nr_minuto_duracao, ie_status_atendimento, ie_status_agenda, ds_status_agenda, ie_classif_agenda, ds_classif_agenda, cd_pessoa_fisica, nm_paciente_pf, nm_paciente, nm_cliente, cd_medico, nm_medico, cd_medico_exec, nm_medico_exec, cd_convenio, cd_categoria, cd_plano, cd_procedencia, ds_convenio, nr_atendimento, cd_procedimento, ie_origem_proced, nr_seq_proc_interno, ds_procedimento, nr_telefone, qt_min_espera_tasy, ds_observacao, cd_turno, dt_confirmacao, cd_setor_atendimento, cd_setor_agenda, ds_sala, ds_tipo_pendencia, ds_complemento, ds_curta, nr_pront_ext, ds_motivo_cancelamento, ds_dia_semana, nr_prontuario_pf, ie_encaixe, nm_responsavel, ds_observacao_final, ie_anestesia, ie_autorizacao, ie_situacao_agenda, nm_usuario_acesso) AS select	a.cd_agenda,
	substr(obter_nome_medico_combo_agcons(a.cd_estabelecimento, a.cd_agenda, a.cd_tipo_agenda, coalesce(a.ie_ordenacao,'N')),1,255) ds_agenda, 
	a.cd_tipo_agenda, 
	substr(v.ds_valor_dominio,1,60) ds_tipo_agenda, 
	a.cd_estabelecimento, 
	substr(obter_nome_estabelecimento(a.cd_estabelecimento),1,80) ds_estabelecimento, 
	a.cd_pessoa_fisica cd_medico_agenda, 
	substr(p.nm_pessoa_fisica,1,60) nm_medico_agenda, 
	a.ie_situacao, 
	b.nr_sequencia, 
	trunc(b.dt_agenda,'dd') dt_agenda, 
	b.dt_agenda hr_inicio, 
	to_char(b.dt_agenda,'hh24:mi') hr_hora, 
	b.nr_minuto_duracao, 
	substr(y.ie_status_atendimento,1,1) ie_status_atendimento, 
	b.ie_status_agenda, 
	substr(i.ds_valor_dominio,1,60) ds_status_agenda, 
	b.ie_classif_agenda, 
	substr(f.ds_classificacao,1,80) ds_classif_agenda, 
	b.cd_pessoa_fisica, 
	substr(c.nm_pessoa_fisica,1,60) nm_paciente_pf, 
	b.nm_paciente, 
	CASE WHEN b.cd_pessoa_fisica IS NULL THEN b.nm_paciente  ELSE substr(c.nm_pessoa_fisica,1,60) END  nm_cliente, 
	b.cd_medico, 
	substr(m.nm_pessoa_fisica,1,60) nm_medico, 
	'' cd_medico_exec, 
	'' nm_medico_exec, 
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
	--substr(obter_desc_sala_agecons(b.nr_seq_sala),1,100) ds_sala, 
	q.ds_sala ds_sala, 
	'' ds_tipo_pendencia, 
	--b.cd_usuario_convenio, 
	substr(a.ds_complemento,1,60) ds_complemento, 
	a.ds_curta, 
	c.nr_pront_ext, 
	substr(Obter_motivo_canc_consulta_ag(a.cd_tipo_agenda,b.cd_motivo_cancelamento),1,255) ds_motivo_cancelamento, 
	substr(obter_valor_dominio(35,obter_cod_dia_semana(b.dt_agenda)),1,255) ds_dia_semana, 
	substr(obter_prontuario_pf(a.cd_estabelecimento,b.cd_pessoa_fisica),1,15) nr_prontuario_pf, 
	b.ie_encaixe, 
	substr(obter_nome_pf(y.cd_medico_resp),1,255) nm_responsavel, 
	substr(ageint_obter_observacao_final(b.nr_sequencia, null),1,255) ds_observacao_final, 
	'' ie_anestesia, 
	'' ie_autorizacao, 
	a.ie_situacao ie_situacao_agenda, 
	b.NM_USUARIO_ACESSO 
FROM valor_dominio v, valor_dominio i, agenda_consulta b
LEFT OUTER JOIN agenda_classif f ON (b.ie_classif_agenda = f.cd_classificacao)
LEFT OUTER JOIN pessoa_fisica c ON (b.cd_pessoa_fisica = c.cd_pessoa_fisica)
LEFT OUTER JOIN pessoa_fisica m ON (b.cd_medico = m.cd_pessoa_fisica)
LEFT OUTER JOIN convenio x ON (b.cd_convenio = x.cd_convenio)
LEFT OUTER JOIN atendimento_paciente y ON (b.nr_atendimento = y.nr_atendimento)
LEFT OUTER JOIN agenda_sala_consulta q ON (b.nr_seq_sala = q.nr_sequencia)
, agenda a
LEFT OUTER JOIN pessoa_fisica p ON (a.cd_pessoa_fisica = p.cd_pessoa_fisica)
WHERE a.cd_agenda		= b.cd_agenda  and a.cd_tipo_agenda	in (3,4)      and a.cd_tipo_agenda	= v.vl_dominio and v.cd_dominio		= 34 and b.ie_status_agenda	= i.vl_dominio and i.cd_dominio		= 83  
union
 
select	a.cd_agenda, 
	a.ds_agenda, 
	a.cd_tipo_agenda, 
	substr(v.ds_valor_dominio,1,60) ds_tipo_agenda, 
	a.cd_estabelecimento, 
	substr(obter_nome_estabelecimento(a.cd_estabelecimento),1,80) ds_estabelecimento, 
	a.cd_pessoa_fisica cd_medico_agenda, 
	substr(p.nm_pessoa_fisica,1,60) nm_medico_agenda, 
	a.ie_situacao, 
	b.nr_sequencia, 
	trunc(b.dt_agenda,'dd') dt_agenda, 
	b.dt_agenda hr_inicio, 
	to_char(b.dt_agenda,'hh24:mi') hr_hora, 
	b.nr_minuto_duracao, 
	substr(y.ie_status_atendimento,1,1) ie_status_atendimento, 
	b.ie_status_agenda, 
	substr(i.ds_valor_dominio,1,60) ds_status_agenda, 
	b.ie_classif_agenda, 
	substr(f.ds_classificacao,1,80) ds_classif_agenda, 
	b.cd_pessoa_fisica, 
	substr(c.nm_pessoa_fisica,1,60) nm_paciente_pf, 
	b.nm_paciente, 
	CASE WHEN b.cd_pessoa_fisica IS NULL THEN b.nm_paciente  ELSE substr(c.nm_pessoa_fisica,1,60) END  nm_cliente, 
	b.cd_medico, 
	substr(m.nm_pessoa_fisica,1,60) nm_medico, 
	'' cd_medico_exec, 
	'' nm_medico_exec, 
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
	--substr(obter_desc_sala_agecons(b.nr_seq_sala),1,100) ds_sala, 
	q.ds_sala ds_sala, 
	'' ds_tipo_pendencia, 
	--b.cd_usuario_convenio, 
	substr(a.ds_complemento,1,60) ds_complemento, 
	a.ds_curta, 
	c.nr_pront_ext, 
	substr(Obter_motivo_canc_consulta_ag(a.cd_tipo_agenda,b.cd_motivo_cancelamento),1,255) ds_motivo_cancelamento, 
	substr(obter_valor_dominio(35,obter_cod_dia_semana(b.dt_agenda)),1,255) ds_dia_semana, 
	substr(obter_prontuario_pf(a.cd_estabelecimento,b.cd_pessoa_fisica),1,15) nr_prontuario_pf, 
	b.ie_encaixe, 
	substr(obter_nome_pf(y.cd_medico_resp),1,255) nm_responsavel, 
	substr(ageint_obter_observacao_final(b.nr_sequencia, null),1,255) ds_observacao_final, 
	'' ie_anestesia, 
	'' ie_autorizacao, 
	a.ie_situacao ie_situacao_agenda, 
	b.NM_USUARIO_ACESSO 
FROM valor_dominio v, valor_dominio i, agenda_consulta b
LEFT OUTER JOIN agenda_classif f ON (b.ie_classif_agenda = f.cd_classificacao)
LEFT OUTER JOIN pessoa_fisica c ON (b.cd_pessoa_fisica = c.cd_pessoa_fisica)
LEFT OUTER JOIN pessoa_fisica m ON (b.cd_medico = m.cd_pessoa_fisica)
LEFT OUTER JOIN convenio x ON (b.cd_convenio = x.cd_convenio)
LEFT OUTER JOIN atendimento_paciente y ON (b.nr_atendimento = y.nr_atendimento)
LEFT OUTER JOIN agenda_sala_consulta q ON (b.nr_seq_sala = q.nr_sequencia)
, agenda a
LEFT OUTER JOIN pessoa_fisica p ON (a.cd_pessoa_fisica = p.cd_pessoa_fisica)
WHERE a.cd_agenda		= b.cd_agenda  and a.cd_tipo_agenda	= 5      and a.cd_tipo_agenda	= v.vl_dominio and v.cd_dominio		= 34 and b.ie_status_agenda	= i.vl_dominio and i.cd_dominio		= 83  
union
 
select	a.cd_agenda, 
	a.ds_agenda, 
	a.cd_tipo_agenda, 
	substr(v.ds_valor_dominio,1,60) ds_tipo_agenda, 
	a.cd_estabelecimento, 
	substr(obter_nome_estabelecimento(a.cd_estabelecimento),1,80) ds_estabelecimento, 
	a.cd_pessoa_fisica cd_medico_agenda, 
	substr(p.nm_pessoa_fisica,1,60) nm_medico_agenda, 
	a.ie_situacao, 
	b.nr_sequencia, 
	b.dt_agenda, 
	b.hr_inicio, 
	to_char(b.hr_inicio,'hh24:mi') hr_hora, 
	b.nr_minuto_duracao, 
	substr(y.ie_status_atendimento,1,1) ie_status_atendimento, 
	b.ie_status_agenda, 
	substr(i.ds_valor_dominio,1,60) ds_status_agenda, 
	to_char(b.nr_seq_classif_agenda) ie_classif_agenda, 
	substr(f.ds_classificacao,1,80) ds_classif_agenda, 
	b.cd_pessoa_fisica, 
	substr(c.nm_pessoa_fisica,1,60) nm_paciente_pf, 
	b.nm_paciente, 
	CASE WHEN b.cd_pessoa_fisica IS NULL THEN b.nm_paciente  ELSE substr(c.nm_pessoa_fisica,1,60) END  nm_cliente, 
	b.cd_medico, 
	substr(m.nm_pessoa_fisica,1,60) nm_medico, 
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
	c.nr_pront_ext, 
	substr(Obter_motivo_canc_consulta_ag(a.cd_tipo_agenda,b.cd_motivo_cancelamento),1,255) ds_motivo_cancelamento, 
	substr(obter_valor_dominio(35,obter_cod_dia_semana(b.dt_agenda)),1,255) ds_dia_semana, 
	substr(obter_prontuario_pf(a.cd_estabelecimento,b.cd_pessoa_fisica),1,15) nr_prontuario_pf, 
	b.ie_encaixe, 
	substr(obter_nome_pf(y.cd_medico_resp),1,255) nm_responsavel, 
	substr(ageint_obter_observacao_final(null, b.nr_sequencia),1,255) ds_observacao_final, 
	b.ie_anestesia ie_anestesia, 
	b.ie_autorizacao ie_autorizacao, 
	a.ie_situacao ie_situacao_agenda, 
	b.NM_USUARIO_ACESSO 
FROM valor_dominio v, valor_dominio i, agenda_paciente b
LEFT OUTER JOIN agenda_paciente_classif f ON (b.nr_seq_classif_agenda = f.nr_sequencia)
LEFT OUTER JOIN pessoa_fisica c ON (b.cd_pessoa_fisica = c.cd_pessoa_fisica)
LEFT OUTER JOIN pessoa_fisica m ON (b.cd_medico = m.cd_pessoa_fisica)
LEFT OUTER JOIN pessoa_fisica z ON (b.cd_medico_exec = z.cd_pessoa_fisica)
LEFT OUTER JOIN convenio x ON (b.cd_convenio = x.cd_convenio)
LEFT OUTER JOIN atendimento_paciente y ON (b.nr_atendimento = y.nr_atendimento)
, agenda a
LEFT OUTER JOIN pessoa_fisica p ON (a.cd_pessoa_fisica = p.cd_pessoa_fisica)
WHERE a.cd_agenda		= b.cd_agenda  and a.cd_tipo_agenda	in (1,2)       and a.cd_tipo_agenda	= v.vl_dominio and v.cd_dominio		= 34 and b.ie_status_agenda	= i.vl_dominio and i.cd_dominio		= 83 
 
union
 
select	a.cd_agenda, 
	a.ds_agenda, 
	a.cd_tipo_agenda, 
	substr(v.ds_valor_dominio,1,60) ds_tipo_agenda, 
	a.cd_estabelecimento, 
	substr(obter_nome_estabelecimento(a.cd_estabelecimento),1,80) ds_estabelecimento, 
	a.cd_pessoa_fisica cd_medico_agenda, 
	substr(p.nm_pessoa_fisica,1,60) nm_medico_agenda, 
	a.ie_situacao, 
	b.nr_sequencia, 
	b.dt_agenda, 
	b.hr_inicio, 
	to_char(b.hr_inicio,'hh24:mi') hr_hora, 
	b.nr_minuto_duracao, 
	substr(y.ie_status_atendimento,1,1) ie_status_atendimento, 
	b.ie_status_agenda, 
	substr(i.ds_valor_dominio,1,60) ds_status_agenda, 
	to_char(b.nr_seq_classif_agenda) ie_classif_agenda, 
	substr(f.ds_classificacao,1,80) ds_classif_agenda, 
	b.cd_pessoa_fisica, 
	substr(c.nm_pessoa_fisica,1,60) nm_paciente_pf, 
	b.nm_paciente, 
	CASE WHEN b.cd_pessoa_fisica IS NULL THEN b.nm_paciente  ELSE substr(c.nm_pessoa_fisica,1,60) END  nm_cliente, 
	x.cd_profissional cd_medico, 
	substr(m.nm_pessoa_fisica,1,60) nm_medico, 
	b.cd_medico_exec, 
	substr(z.nm_pessoa_fisica,1,60) nm_medico_exec, 
	b.cd_convenio, 
	b.cd_categoria, 
	b.cd_plano, 
	b.cd_procedencia, 
	substr(k.ds_convenio,1,40) ds_convenio, 
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
	c.nr_pront_ext, 
	substr(Obter_motivo_canc_consulta_ag(a.cd_tipo_agenda,b.cd_motivo_cancelamento),1,255) ds_motivo_cancelamento, 
	substr(obter_valor_dominio(35,obter_cod_dia_semana(b.dt_agenda)),1,255) ds_dia_semana, 
	substr(obter_prontuario_pf(a.cd_estabelecimento,b.cd_pessoa_fisica),1,15) nr_prontuario_pf, 
	b.ie_encaixe, 
	substr(obter_nome_pf(y.cd_medico_resp),1,255) nm_responsavel, 
	substr(ageint_obter_observacao_final(null, b.nr_sequencia),1,255) ds_observacao_final, 
	b.ie_anestesia ie_anestesia, 
	b.ie_autorizacao ie_autorizacao, 
	a.ie_situacao ie_situacao_agenda, 
	b.NM_USUARIO_ACESSO 
FROM valor_dominio v, valor_dominio i, profissional_agenda x
LEFT OUTER JOIN pessoa_fisica m ON (x.cd_profissional = m.cd_pessoa_fisica)
, agenda_paciente b
LEFT OUTER JOIN agenda_paciente_classif f ON (b.nr_seq_classif_agenda = f.nr_sequencia)
LEFT OUTER JOIN pessoa_fisica c ON (b.cd_pessoa_fisica = c.cd_pessoa_fisica)
LEFT OUTER JOIN pessoa_fisica z ON (b.cd_medico_exec = z.cd_pessoa_fisica)
LEFT OUTER JOIN atendimento_paciente y ON (b.nr_atendimento = y.nr_atendimento)
LEFT OUTER JOIN convenio k ON (b.cd_convenio = k.cd_convenio)
, agenda a
LEFT OUTER JOIN pessoa_fisica p ON (a.cd_pessoa_fisica = p.cd_pessoa_fisica)
WHERE a.cd_agenda		= b.cd_agenda and x.nr_seq_agenda		= b.nr_sequencia  and a.cd_tipo_agenda	in (1,2)       and a.cd_tipo_agenda	= v.vl_dominio and v.cd_dominio		= 34 and b.ie_status_agenda	= i.vl_dominio and i.cd_dominio		= 83 
 
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
	b.nr_minuto_duracao, 
	substr(y.ie_status_atendimento,1,1) ie_status_atendimento, 
	b.ie_status_agenda, 
	--substr(obter_valor_dominio(3192,b.ie_status_agenda),1,60) ds_status_agenda, 
	i.ds_valor_dominio ds_status_agenda, 
	'' ie_classif_agenda, 
	'' ds_classif_agenda, 
	b.cd_pessoa_fisica, 
	substr(c.nm_pessoa_fisica,1,60) nm_paciente_pf, 
	substr(c.nm_pessoa_fisica,1,255) nm_paciente, 
	substr(c.nm_pessoa_fisica,1,60) nm_cliente, 
	e.cd_medico_resp, 
	substr(obter_nome_pf(e.cd_medico_resp),1,60) nm_medico, 
	'' cd_medico_exec, 
	'' nm_medico_exec, 
	f.cd_convenio, 
	f.cd_categoria, 
	f.cd_plano, 
	null cd_procedencia, 
	--substr(obter_nome_convenio(f.cd_convenio),1,40) ds_convenio, 
	k.ds_convenio ds_convenio, 
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
	--substr(obter_valor_dominio(3117, b.ie_tipo_pend_agenda),1,60) ds_tipo_pendencia, 
	j.ds_valor_dominio ds_tipo_pendencia, 
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
	'' ie_autorizacao, 
	'' ie_situacao_agenda, 
	'' NM_USUARIO_ACESSO 
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
 
select	null cd_agenda, 
	substr(rxt_obter_desc_equipamento(b.nr_seq_equipamento),1,250) ds_agenda, 
	10 cd_tipo_agenda, 
	'Radioterapia' ds_tipo_agenda, 
	d.cd_estabelecimento, 
	substr(obter_nome_estabelecimento(d.cd_estabelecimento),1,80) ds_estabelecimento, 
	'' cd_medico_agenda, 
	'' nm_medico_agenda, 
	'', 
	b.nr_sequencia, 
	trunc(b.dt_agenda,'dd') dt_agenda, 
	b.dt_agenda hr_inicio, 
	to_char(b.dt_agenda,'hh24:mi') hr_hora, 
	b.nr_minuto_duracao, 
	substr(d.ie_status_atendimento,1,1) ie_status_atendimento, 
	b.ie_status_agenda, 
	--substr(obter_valor_dominio(2217,b.ie_status_agenda),1,60) ds_status_agenda, 
	i.ds_valor_dominio ds_status_agenda, 
	to_char(b.nr_seq_classif) ie_classif_agenda, 
	substr(rxt_obter_desc_classif_agenda(b.nr_seq_classif),1,80) ds_classif_agenda, 
	b.cd_pessoa_fisica, 
	substr(c.nm_pessoa_fisica,1,60) nm_paciente_pf, 
	'' nm_paciente, 
	substr(c.nm_pessoa_fisica,1,60) nm_cliente, 
	d.cd_medico_resp cd_medico, 
	substr(m.nm_pessoa_fisica,1,60) nm_medico, 
	'' cd_medico_exec, 
	'' nm_medico_exec, 
	null cd_convenio, 
	'' cd_categoria, 
	'' cd_plano, 
	null cd_procedencia, 
	'' ds_convenio, 
	b.nr_atendimento, 
	null cd_procedimento, 
	null ie_origem_proced, 
	null nr_seq_proc_interno, 
	'' ds_procedimento, 
	null nr_telefone, 
	--substr(obter_fone_pac_agenda(b.cd_pessoa_fisica),1,255) ds_telefone_cad, 
	--substr(obter_idade(c.dt_nascimento, b.dt_agenda, 'S'),1,30) ds_idade, 
	round((coalesce(d.dt_alta, LOCALTIMESTAMP) - d.dt_entrada) * 1440) qt_min_espera_tasy, 
	'' ds_observacao, 
	'' cd_turno, 
	b.dt_confirmacao, 
	null cd_setor_atendimento, 
	null cd_setor_agenda, 
	'' ds_sala, 
	'' ds_tipo_pendencia, 
	--substr(obter_dados_categ_conv(d.nr_atendimento,'U'),1,50) cd_usuario_convenio, 
	null ds_complemento, 
	'' ds_curta, 
	c.nr_pront_ext, 
	'' ds_motivo_cancelamento, 
	substr(obter_valor_dominio(35,obter_cod_dia_semana(b.dt_agenda)),1,255) ds_dia_semana, 
	substr(obter_prontuario_pf(d.cd_estabelecimento,d.cd_pessoa_fisica),1,15) nr_prontuario_pf, 
	'' ie_encaixe, 
	substr(obter_nome_pf(d.cd_medico_resp),1,255) nm_responsavel, 
	'' ds_observacao_final, 
	'' ie_anestesia, 
	'' ie_autorizacao, 
	'' ie_situacao_agenda, 
	b.NM_USUARIO_ACESSO 
FROM pessoa_fisica m, rxt_agenda b
LEFT OUTER JOIN pessoa_fisica c ON (b.cd_pessoa_fisica = c.cd_pessoa_fisica)
LEFT OUTER JOIN valor_dominio i ON (b.ie_status_agenda = i.vl_dominio)
LEFT OUTER JOIN atendimento_paciente d ON (b.nr_atendimento = d.nr_atendimento)
WHERE i.cd_dominio		= 2217   and d.cd_medico_resp	= m.cd_pessoa_fisica 
 
union
 
select	null cd_agenda, 
	null ds_agenda, 
	11 cd_tipo_agenda, 
	'Check-up' ds_tipo_agenda, 
	a.cd_estabelecimento, 
	substr(obter_nome_estabelecimento(a.cd_estabelecimento),1,80) ds_estabelecimento, 
	'' cd_medico_agenda, 
	'' nm_medico_agenda, 
	'', 
	a.nr_sequencia, 
	trunc(a.dt_previsto,'dd') dt_agenda, 
	a.dt_previsto hr_inicio, 
	to_char(a.dt_previsto,'hh24:mi') hr_hora, 
	null nr_minuto_duracao, 
	substr(y.ie_status_atendimento,1,1) ie_status_atendimento, 
	CASE WHEN a.dt_cancelamento IS NULL THEN  'Y'  ELSE 'C' END  ie_status_agenda, 
	null ds_status_agenda, 
	null ie_classif_agenda, 
	null ds_classif_agenda, 
	b.cd_pessoa_fisica, 
	substr(b.nm_pessoa_fisica,1,60) nm_paciente_pf, 
	substr(b.nm_pessoa_fisica,1,60) nm_paciente, 
	substr(b.nm_pessoa_fisica,1,60) nm_cliente, 
	null cd_medico, 
	null nm_medico, 
	'' cd_medico_exec, 
	'' nm_medico_exec, 
	null cd_convenio, 
	'' cd_categoria, 
	'' cd_plano, 
	null cd_procedencia, 
	'' ds_convenio, 
	a.nr_atendimento, 
	null cd_procedimento, 
	null ie_origem_proced, 
	null nr_seq_proc_interno, 
	'' ds_procedimento, 
	null nr_telefone, 
	--substr(obter_fone_pac_agenda(b.cd_pessoa_fisica),1,255) ds_telefone_cad, 
	--substr(obter_idade(b.dt_nascimento, a.dt_previsto, 'S'),1,30) ds_idade, 
	round((coalesce(y.dt_alta, LOCALTIMESTAMP) - y.dt_entrada) * 1440) qt_min_espera_tasy, 
	'' ds_observacao, 
	'' cd_turno, 
	null dt_confirmacao, 
	null cd_setor_atendimento, 
	a.cd_setor_Atendimento cd_setor_agenda, 
	'' ds_sala, 
	'' ds_tipo_pendencia, 
	--substr(obter_dados_categ_conv(a.nr_atendimento,'U'),1,50) cd_usuario_convenio, 
	null ds_complemento, 
	'' ds_curta, 
	b.nr_pront_ext, 
	'' ds_motivo_cancelamento, 
	substr(obter_valor_dominio(35,obter_cod_dia_semana(a.dt_previsto)),1,255) ds_dia_semana, 
	'' nr_prontuario_pf, 
	'' ie_encaixe, 
	substr(obter_nome_pf(y.cd_medico_resp),1,255) nm_responsavel, 
	'' ds_observacao_final, 
	'' ie_anestesia, 
	'' ie_autorizacao, 
	'' ie_situacao_agenda, 
	'' NM_USUARIO_ACESSO 
FROM pessoa_fisica b, checkup a
LEFT OUTER JOIN atendimento_paciente y ON (a.nr_atendimento = y.nr_atendimento)
WHERE a.cd_pessoa_fisica	= b.cd_pessoa_fisica  
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
	'' ie_autorizacao, 
	'' ie_situacao_agenda, 
	'' NM_USUARIO_ACESSO 
FROM convenio k, agenda_integrada_item e, agenda_integrada d, qt_local a, agenda_quimio b
LEFT OUTER JOIN valor_dominio j ON (b.ie_tipo_pend_agenda = j.vl_dominio)
LEFT OUTER JOIN valor_dominio i ON (b.ie_status_agenda = i.vl_dominio)
LEFT OUTER JOIN pessoa_fisica c ON (b.cd_pessoa_fisica = c.cd_pessoa_fisica)
WHERE a.nr_sequencia		= b.nr_seq_local and i.cd_dominio		= 3192 and j.cd_dominio		= 3117 and e.nr_seq_agequi	= b.nr_Sequencia and d.nr_sequencia = e.nr_seq_agenda_int    and d.cd_convenio	= k.cd_convenio and b.nr_seq_atendimento is null;

