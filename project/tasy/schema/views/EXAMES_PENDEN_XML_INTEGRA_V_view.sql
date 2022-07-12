-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';

CREATE OR REPLACE VIEW exames_penden_xml_integra_v (nr_atendimento, nr_prescricao, nr_sequencia, nr_seq_interno, nr_acess_number, cd_proced_tasy, cd_proced_integracao, cd_proced_tasy_lado, ds_procedimento, ie_lado, ie_urgencia, dt_prev_execucao, cd_setor_paciente, cd_estabelecimento, nm_pessoa_fisica, dt_prescricao, dt_liberacao, cd_software_integracao, cd_estab_terceiro, cd_setor_execucao, cd_paciente, cd_prescritor, ie_sexo, ds_local, nm_paciente, nr_prontuario, dt_nascimento, qt_idade_pac, cd_modadalidade_proc, cd_integracao_proc_interno, qt_altura_cm, qt_peso, nr_crm_prescritor, uf_crm_prescritor, nr_cpf_paciente, qt_prescrito, nr_identidade_paciente, nr_prontuario_paciente, ds_endereco_paciente, ds_endereco, nr_endereco_paciente, nr_endereco, ds_bairro_paciente, ds_bairro, ds_municipio_paciente, ds_municipio, uf_paciente, sg_estado, cd_cep_paciente, cd_cep, nr_telefone_paciente, cd_convenio, ds_categoria_convenio, ds_convenio, cd_cgc, cd_agenda, ds_agenda, dt_resultado, ie_suspenso, cd_procedimento, cd_tipo_procedimento, cd_pessoa_fisica, cd_estab_atend, cd_estab_prescr, dt_entrada, cd_setor_atendimento, qt_procedimento, cd_medico, ds_tipo_atendimento, ds_observacao, ie_origem_proced, cd_material_exame, ie_tipo_atendimento, na_accessionnumber, ds_modalidade, cd_procedencia, cd_plano_convenio, cd_plano, cd_categoria, cd_usuario_convenio, cd_compl_conv, dt_validade_carteira, ds_procedencia, nr_seq_motivo_atend, dt_atualizacao, nm_usuario, dt_liberacao_medico, ds_material_especial, ie_amostra_entregue, ie_recem_nato, nr_seq_exame, ie_executar_leito, nr_seq_proc_interno, cd_unidade, ds_complemento, nr_telefone, nm_medico, nr_cpf_medico, nr_cpf, ds_setor_paciente, ds_motivo_atend, ds_motivo_suspensao, ds_horarios, ds_dado_clinico, nr_crm, uf_medico, ds_senha, ds_observacao_pf, ds_unidade_atend, ds_plano, dt_admissao_hosp, ds_email, nm_sobrenome_pai, nm_sobrenome_mae, nm_primeiro_nome, cd_medico_previ, nm_medico_previ, cd_sistema_anterior) AS select  b.nr_atendimento,
        a.nr_prescricao,
        a.nr_sequencia,
        a.nr_seq_interno,
        a.nr_acesso_dicom nr_acess_number,
        a.cd_procedimento cd_proced_tasy,
        e.cd_integracao cd_proced_integracao,
        (a.cd_procedimento||a.ie_lado) cd_proced_tasy_lado,
        elimina_caractere_especial(p.ds_procedimento) ds_procedimento,
        a.ie_lado,
        coalesce(a.ie_urgencia,'N') ie_urgencia,
        a.dt_prev_execucao,
        b.cd_setor_atendimento cd_setor_paciente,
        b.cd_estabelecimento,
        elimina_caractere_especial(c.nm_pessoa_fisica) nm_pessoa_fisica,
        b.dt_prescricao,
        coalesce(b.dt_liberacao_medico, b.dt_liberacao) dt_liberacao,
        f.nr_sequencia cd_software_integracao,
        obter_estab_integracao(b.cd_estabelecimento, f.nr_seq_empresa) cd_estab_terceiro,
        a.cd_setor_atendimento  cd_setor_execucao,
        b.cd_pessoa_fisica cd_paciente,
        b.cd_prescritor,
        c.ie_sexo,
       elimina_caractere_especial(CASE WHEN obter_classif_setor(a.cd_setor_atendimento)=1 THEN  substr(obter_nome_setor(a.cd_setor_atendimento) || ' ' || obter_desc_abrev_local_pa(t.nr_seq_local_pa),1,80) WHEN obter_classif_setor(a.cd_setor_atendimento)=5 THEN  CASE WHEN t.nr_seq_local_pa IS NULL THEN  substr(obter_unidade_atendimento(b.nr_atendimento, 'IAA', 'SU'),1,80)  ELSE substr(obter_nome_setor(a.cd_setor_atendimento) || ' ' || obter_desc_abrev_local_pa(t.nr_seq_local_pa),1,80) END   ELSE substr(obter_unidade_atendimento(b.nr_atendimento, 'IAA', 'SU'),1,80) END) ds_local,
  elimina_caractere_especial(c.nm_pessoa_fisica) nm_paciente,
  c.nr_prontuario,
        c.dt_nascimento,
        obter_idade(c.dt_nascimento, coalesce(c.dt_obito,LOCALTIMESTAMP),'A') qt_idade_pac,
        pacs_obter_modalidade_proc(p.cd_tipo_procedimento, f.nr_sequencia) cd_modadalidade_proc,
        p.nr_proc_interno cd_integracao_proc_interno,
        b.qt_altura_cm,
        b.qt_peso,
        m.nr_crm nr_crm_prescritor,
        m.uf_crm uf_crm_prescritor,
        c.nr_cpf nr_cpf_paciente,
        a.qt_procedimento qt_prescrito,
  c.nr_identidade nr_identidade_paciente,
  obter_prontuario_pf(b.cd_estabelecimento, b.cd_pessoa_fisica) nr_prontuario_paciente,
  elimina_caractere_especial(g.ds_endereco) ds_endereco_paciente,
  elimina_caractere_especial(g.ds_endereco) ds_endereco,
  coalesce(to_char(g.nr_endereco), g.ds_compl_end) nr_endereco_paciente,
  coalesce(to_char(g.nr_endereco), g.ds_compl_end) nr_endereco,
  g.ds_bairro ds_bairro_paciente,
  elimina_caractere_especial(g.ds_bairro) ds_bairro,
  g.ds_municipio ds_municipio_paciente,
  elimina_caractere_especial(g.ds_municipio) ds_municipio,
  g.sg_estado uf_paciente,
  g.sg_estado,
  g.cd_cep cd_cep_paciente,
  g.cd_cep,
  CASE WHEN g.nr_ddd_telefone IS NULL THEN g.nr_telefone  ELSE g.nr_ddd_telefone||' '||g.nr_telefone END  nr_telefone_paciente,
  h.cd_convenio,
  elimina_caractere_especial(substr(obter_categoria_convenio(h.cd_convenio,h.cd_categoria),1,100)) ds_categoria_convenio,
  elimina_caractere_especial(i.ds_convenio) ds_convenio,
  i.cd_cgc,
  (   select  x.cd_agenda
    FROM   agenda_paciente x
    where   x.nr_sequencia = a.nr_seq_agenda ) cd_agenda,
  (  select  elimina_caractere_especial(x.ds_agenda)
    from   agenda x,
      agenda_paciente y
    where   x.cd_agenda = y.cd_agenda
    and  y.nr_sequencia = a.nr_seq_agenda) ds_agenda,
  a.dt_resultado,
  a.ie_suspenso,
  a.cd_procedimento,
  p.cd_tipo_procedimento,
  b.cd_pessoa_fisica,
  t.cd_estabelecimento cd_estab_atend,
  b.cd_estabelecimento cd_estab_prescr,
  t.dt_entrada,
  a.cd_setor_atendimento,
  a.qt_procedimento,
  b.cd_medico,
  elimina_caractere_especial(substr(obter_valor_dominio(12,t.ie_tipo_atendimento),1,255)) ds_tipo_atendimento,
  a.ds_observacao,
  a.ie_origem_proced,
  a.cd_material_exame,
  t.ie_tipo_atendimento,
  a.nr_acesso_dicom na_accessionnumber,
  elimina_caractere_especial(CASE WHEN coalesce(obter_se_modalidade_propria(b.cd_estabelecimento), 'N')='N' THEN  obter_modalidade_wtt(p.cd_tipo_procedimento)  ELSE obter_modalidade_propria(p.cd_tipo_procedimento) END ) ds_modalidade,
  coalesce(n.cd_procedencia_externo, n.cd_procedencia) cd_procedencia,
  h.cd_plano_convenio,
  h.cd_plano_convenio cd_plano,
  h.cd_categoria,
  h.cd_usuario_convenio,
  h.cd_complemento cd_compl_conv,
  h.dt_validade_carteira,
  elimina_caractere_especial(n.ds_procedencia) ds_procedencia,
  t.nr_seq_queixa nr_seq_motivo_atend,
  a.dt_atualizacao,
  a.nm_usuario,
  b.dt_liberacao_medico,
  elimina_caractere_especial(a.ds_material_especial) ds_material_especial,
  coalesce(a.ie_amostra,'N') ie_amostra_entregue,
  b.ie_recem_nato,
  a.nr_seq_exame,
  a.ie_executar_leito,
  a.nr_seq_proc_interno,
  j.cd_unidade_basica || ' ' || j.cd_unidade_compl cd_unidade,
  elimina_caractere_especial(g.ds_complemento) ds_complemento,
  g.nr_telefone,
  elimina_caractere_especial(mp.nm_pessoa_fisica) nm_medico,
  mp.nr_cpf nr_cpf_medico,
  c.nr_cpf,
  elimina_caractere_especial(s.ds_setor_atendimento) ds_setor_paciente,
  elimina_caractere_especial(substr(q.ds_queixa,1,80)) ds_motivo_atend,
  elimina_caractere_especial(substr(r.ds_motivo,1,255)) ds_motivo_suspensao,
  a.ds_horarios,
  elimina_caractere_especial(a.ds_dado_clinico) ds_dado_clinico,
  obter_crm_medico(b.cd_medico) nr_crm,
  (
  select  max(uf_crm)
  from  medico
  where  cd_pessoa_fisica = b.cd_medico
  ) uf_medico,
  t.ds_senha,
  c.ds_observacao ds_observacao_pf,
  (select elimina_caractere_especial(max(z.ds_unidade_atend)) from unidade_atendimento z where z.nr_atendimento =  b.nr_atendimento) ds_unidade_atend,
  elimina_caractere_especial(substr(obter_desc_plano_conv(h.cd_convenio, h.cd_plano_convenio),1,255)) ds_plano,
  c.dt_admissao_hosp,
               g.ds_email,
    elimina_caractere_especial(mp.nm_sobrenome_pai) nm_sobrenome_pai,
    elimina_caractere_especial(mp.nm_sobrenome_mae) nm_sobrenome_mae,
    elimina_caractere_especial(mp.nm_primeiro_nome) nm_primeiro_nome,
    a.cd_medico_exec as cd_medico_previ,
    elimina_caractere_especial(obter_nome_pf(a.cd_medico_exec)) as nm_medico_previ,
    lpad(c.cd_sistema_ant, 10, '0') as cd_sistema_anterior
FROM setor_atendimento s, procedimento p, procedencia n, atend_paciente_unidade j, convenio i, sistema_integracao f, proc_interno_integracao e, atendimento_paciente t
LEFT OUTER JOIN queixa_paciente q ON (t.nr_seq_queixa = q.nr_sequencia)
, pessoa_fisica c
LEFT OUTER JOIN compl_pessoa_fisica g ON (c.cd_pessoa_fisica = g.cd_pessoa_fisica AND 1 = g.ie_tipo_complemento)
, prescr_medica b
LEFT OUTER JOIN pessoa_fisica mp ON (b.cd_medico = mp.cd_pessoa_fisica)
LEFT OUTER JOIN atend_categoria_convenio h ON (b.nr_atendimento = h.nr_atendimento)
LEFT OUTER JOIN medico m ON (b.cd_prescritor = m.cd_pessoa_fisica)
, prescr_procedimento a
LEFT OUTER JOIN motivo_suspensao_prescr r ON (a.cd_motivo_suspensao = r.nr_sequencia)
WHERE a.nr_prescricao         = b.nr_prescricao and b.cd_pessoa_fisica      = c.cd_pessoa_fisica and p.cd_procedimento       = a.cd_procedimento and p.ie_origem_proced      = a.ie_origem_proced and e.cd_procedimento       = a.cd_procedimento and e.ie_origem_proced      = a.ie_origem_proced and h.cd_convenio    = i.cd_convenio and b.nr_atendimento  = t.nr_atendimento  and a.nr_seq_proc_interno is null and j.cd_setor_atendimento  = s.cd_setor_atendimento and t.cd_procedencia  = n.cd_procedencia  and j.nr_seq_interno  = obter_atepacu_paciente(b.nr_atendimento,'A') and h.dt_inicio_vigencia  = (select max(w.dt_inicio_vigencia)
        from atend_categoria_convenio w
        where w.nr_atendimento  = b.nr_atendimento)    and a.cd_motivo_baixa       = 0 and f.nr_sequencia          = e.nr_seq_sistema_integ   and ( b.dt_liberacao_medico is not null or  b.dt_liberacao is not null) and ((e.cd_estabelecimento  is null) or (e.cd_estabelecimento = b.cd_estabelecimento)) and a.dt_integracao         is null and a.dt_suspensao          is null and (b.dt_liberacao_medico > LOCALTIMESTAMP - interval '1 days'
or b.dt_liberacao > LOCALTIMESTAMP - interval '1 days')

union

select
      b.nr_atendimento,
        a.nr_prescricao,
        a.nr_sequencia,
        a.nr_seq_interno,
        a.nr_acesso_dicom nr_acess_number,
        a.nr_seq_proc_interno cd_proced_tasy,
        e.cd_integracao cd_proced_integracao,
        (a.nr_seq_proc_interno||a.ie_lado) cd_proced_tasy_lado,
        elimina_caractere_especial(d.ds_proc_exame) ds_procedimento,
        a.ie_lado,
        coalesce(a.ie_urgencia,'N') ie_urgencia,
        a.dt_prev_execucao,
        b.cd_setor_atendimento cd_setor_paciente,
        b.cd_estabelecimento,
        elimina_caractere_especial(c.nm_pessoa_fisica) nm_pessoa_fisica,
        b.dt_prescricao,
        coalesce(b.dt_liberacao_medico, b.dt_liberacao) dt_liberacao,
        f.nr_sequencia cd_software_integracao,
        obter_estab_integracao(b.cd_estabelecimento, f.nr_seq_empresa) cd_estab_terceiro,
        a.cd_setor_atendimento  cd_setor_execucao,
        b.cd_pessoa_fisica cd_paciente,
        b.cd_prescritor,
        c.ie_sexo,
       elimina_caractere_especial(CASE WHEN obter_classif_setor(a.cd_setor_atendimento)=1 THEN  substr(obter_nome_setor(a.cd_setor_atendimento) || ' ' || obter_desc_abrev_local_pa(t.nr_seq_local_pa),1,80) WHEN obter_classif_setor(a.cd_setor_atendimento)=5 THEN  CASE WHEN t.nr_seq_local_pa IS NULL THEN  substr(obter_unidade_atendimento(b.nr_atendimento, 'IAA', 'SU'),1,80)  ELSE substr(obter_nome_setor(a.cd_setor_atendimento) || ' ' || obter_desc_abrev_local_pa(t.nr_seq_local_pa),1,80) END   ELSE substr(obter_unidade_atendimento(b.nr_atendimento, 'IAA', 'SU'),1,80) END) ds_local,
  elimina_caractere_especial(c.nm_pessoa_fisica) nm_paciente,
  c.nr_prontuario,
        c.dt_nascimento,
        obter_idade(c.dt_nascimento, coalesce(c.dt_obito,LOCALTIMESTAMP),'A') qt_idade_pac,
        pacs_obter_modalidade_proc(p.cd_tipo_procedimento, f.nr_sequencia) cd_modadalidade_proc,
        d.cd_integracao cd_integracao_proc_interno,
        b.qt_altura_cm,
        b.qt_peso,
        m.nr_crm nr_crm_prescritor,
        m.uf_crm uf_crm_prescritor,
        c.nr_cpf nr_cpf_paciente,
        a.qt_procedimento qt_prescrito,
  c.nr_identidade nr_identidade_paciente,
  obter_prontuario_pf(b.cd_estabelecimento, b.cd_pessoa_fisica) nr_prontuario_paciente,
  elimina_caractere_especial(g.ds_endereco) ds_endereco_paciente,
  elimina_caractere_especial(g.ds_endereco) ds_endereco,
  coalesce(to_char(g.nr_endereco), g.ds_compl_end) nr_endereco_paciente,
  coalesce(to_char(g.nr_endereco), g.ds_compl_end) nr_endereco,
  g.ds_bairro ds_bairro_paciente,
  elimina_caractere_especial(g.ds_bairro) ds_bairro,
  elimina_caractere_especial(g.ds_municipio) ds_municipio_paciente,
  elimina_caractere_especial(g.ds_municipio) ds_municipio,
  g.sg_estado uf_paciente,
  g.sg_estado,
  g.cd_cep cd_cep_paciente,
  g.cd_cep,
  CASE WHEN g.nr_ddd_telefone IS NULL THEN g.nr_telefone  ELSE g.nr_ddd_telefone||' '||g.nr_telefone END  nr_telefone_paciente,
  h.cd_convenio,
  elimina_caractere_especial(substr(obter_categoria_convenio(h.cd_convenio,h.cd_categoria),1,100)) ds_categoria_convenio,
  elimina_caractere_especial(i.ds_convenio) ds_convenio,
  i.cd_cgc,
  (   select  x.cd_agenda
    from   agenda_paciente x
    where   x.nr_sequencia = a.nr_seq_agenda ) cd_agenda,
  (  select  elimina_caractere_especial(x.ds_agenda)
    from   agenda x,
      agenda_paciente y
    where   x.cd_agenda = y.cd_agenda
    and  y.nr_sequencia = a.nr_seq_agenda) ds_agenda,
  a.dt_resultado,
  a.ie_suspenso,
  a.cd_procedimento,
  p.cd_tipo_procedimento,
  b.cd_pessoa_fisica,
  t.cd_estabelecimento cd_estab_atend,
  b.cd_estabelecimento cd_estab_prescr,
  t.dt_entrada,
  a.cd_setor_atendimento,
  a.qt_procedimento,
  b.cd_medico,
  elimina_caractere_especial(substr(obter_valor_dominio(12,t.ie_tipo_atendimento),1,255)) ds_tipo_atendimento,
  a.ds_observacao,
  a.ie_origem_proced,
  a.cd_material_exame,
  t.ie_tipo_atendimento,
  a.nr_acesso_dicom na_accessionnumber,
  elimina_caractere_especial(CASE WHEN coalesce(obter_se_modalidade_propria(b.cd_estabelecimento), 'N')='N' THEN  obter_modalidade_wtt(p.cd_tipo_procedimento)  ELSE obter_modalidade_propria(p.cd_tipo_procedimento) END ) ds_modalidade,
  coalesce(n.cd_procedencia_externo, n.cd_procedencia) cd_procedencia,
  h.cd_plano_convenio,
  h.cd_plano_convenio cd_plano,
  h.cd_categoria,
  h.cd_usuario_convenio,
  h.cd_complemento cd_compl_conv,
  h.dt_validade_carteira,
  elimina_caractere_especial(n.ds_procedencia) ds_procedencia,
  t.nr_seq_queixa nr_seq_motivo_atend,
  a.dt_atualizacao,
  a.nm_usuario,
  b.dt_liberacao_medico,
  elimina_caractere_especial(a.ds_material_especial) ds_material_especial,
  coalesce(a.ie_amostra,'N') ie_amostra_entregue,
  b.ie_recem_nato,
  a.nr_seq_exame,
  a.ie_executar_leito,
  a.nr_seq_proc_interno,
  j.cd_unidade_basica || ' ' || j.cd_unidade_compl cd_unidade,
  elimina_caractere_especial(g.ds_complemento) ds_complemento,
  g.nr_telefone,
  elimina_caractere_especial(mp.nm_pessoa_fisica) nm_medico,
  mp.nr_cpf nr_cpf_medico,
  c.nr_cpf,
  elimina_caractere_especial(s.ds_setor_atendimento) ds_setor_paciente,
  elimina_caractere_especial(substr(q.ds_queixa,1,80)) ds_motivo_atend,
  elimina_caractere_especial(substr(r.ds_motivo,1,255)) ds_motivo_suspensao,
  a.ds_horarios,
  elimina_caractere_especial(a.ds_dado_clinico) ds_dado_clinico,
  obter_crm_medico(b.cd_medico) nr_crm,
                   (
  select  max(uf_crm)
  from  medico
  where  cd_pessoa_fisica = b.cd_medico
  ) uf_medico,
  t.ds_senha,
  c.ds_observacao ds_observacao_pf,
  (select elimina_caractere_especial(max(z.ds_unidade_atend)) from unidade_atendimento z where z.nr_atendimento =  b.nr_atendimento) ds_unidade_atend,
  elimina_caractere_especial(substr(obter_desc_plano_conv(h.cd_convenio, h.cd_plano_convenio),1,255)) ds_plano,
  c.dt_admissao_hosp,
                g.ds_email,
    elimina_caractere_especial(c.nm_sobrenome_pai) nm_sobrenome_pai,
    elimina_caractere_especial(c.nm_sobrenome_mae) nm_sobrenome_mae,
    elimina_caractere_especial(c.nm_primeiro_nome) nm_primeiro_nome,
    a.cd_medico_exec as cd_medico_previ,
    elimina_caractere_especial(obter_nome_pf(a.cd_medico_exec)) as nm_medico_previ,
    lpad(c.cd_sistema_ant, 10, '0') as cd_sistema_anterior
FROM setor_atendimento s, procedimento p, procedencia n, atend_paciente_unidade j, convenio i, sistema_integracao f, proc_interno_integracao e, proc_interno d, atendimento_paciente t
LEFT OUTER JOIN queixa_paciente q ON (t.nr_seq_queixa = q.nr_sequencia)
, pessoa_fisica c
LEFT OUTER JOIN compl_pessoa_fisica g ON (c.cd_pessoa_fisica = g.cd_pessoa_fisica AND 1 = g.ie_tipo_complemento)
, prescr_medica b
LEFT OUTER JOIN atend_categoria_convenio h ON (b.nr_atendimento = h.nr_atendimento)
LEFT OUTER JOIN medico m ON (b.cd_prescritor = m.cd_pessoa_fisica)
LEFT OUTER JOIN pessoa_fisica mp ON (b.cd_medico = mp.cd_pessoa_fisica)
, prescr_procedimento a
LEFT OUTER JOIN motivo_suspensao_prescr r ON (a.cd_motivo_suspensao = r.nr_sequencia)
WHERE a.nr_prescricao         = b.nr_prescricao and b.cd_pessoa_fisica      = c.cd_pessoa_fisica and d.nr_sequencia          = a.nr_seq_proc_interno and e.nr_seq_proc_interno   = a.nr_seq_proc_interno and e.nr_seq_proc_interno   = d.nr_sequencia and p.cd_procedimento       = a.cd_procedimento and p.ie_origem_proced      = a.ie_origem_proced and h.cd_convenio    = i.cd_convenio and j.nr_seq_interno  = obter_atepacu_paciente(b.nr_atendimento,'A') and b.nr_atendimento  = t.nr_atendimento  and t.cd_procedencia  = n.cd_procedencia and j.cd_setor_atendimento  = s.cd_setor_atendimento and h.dt_inicio_vigencia  = (select max(w.dt_inicio_vigencia)
        from atend_categoria_convenio w
        where w.nr_atendimento  = b.nr_atendimento)     and a.cd_motivo_baixa       = 0 and f.nr_sequencia          = e.nr_seq_sistema_integ   and ( b.dt_liberacao_medico is not null or  b.dt_liberacao is not null) and ((e.cd_estabelecimento  is null) or (e.cd_estabelecimento = b.cd_estabelecimento)) and a.dt_integracao         is null and a.dt_suspensao          is null and (b.dt_liberacao_medico > LOCALTIMESTAMP - interval '1 days' 
       or b.dt_liberacao > LOCALTIMESTAMP - interval '1 days');
