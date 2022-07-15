-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE cpoe_gerar_exame_lab_rotina ( nr_atendimento_p bigint, nr_seq_rotina_p bigint, cd_estabelecimento_p bigint, cd_perfil_p bigint, nm_usuario_p text, cd_setor_atendimento_p bigint, ie_tipo_atendimento_p bigint, cd_convenio_p bigint, ie_tipo_convenio_p bigint, cd_plano_convenio_p text, cd_categoria_convenio_p text, dt_base_proc_p timestamp, cd_paciente_p text, qt_idade_dia_p bigint, qt_idade_mes_p bigint, qt_idade_ano_p bigint, qt_peso_p bigint, cd_prescritor_p text, cd_setor_usuario_p bigint, cd_medico_p text, cd_especialidade_p bigint, nr_seq_rotina_esp_p bigint, ie_gerar_associado_p char, nr_seq_item_gerado_p INOUT bigint, nr_seq_transcricao_p bigint default null, ie_item_alta_p text default 'N', ie_prescritor_aux_p text default 'N', ie_retrogrado_p text default 'N', dt_inicio_p timestamp default null, nr_seq_pepo_p bigint default null, nr_cirurgia_p bigint default null, nr_cirurgia_patologia_p bigint default null, nr_seq_agenda_p bigint default null, ie_urgencia_p text default null, ie_oncologia_p text default 'N', nr_seq_conclusao_apae_p bigint default null, hr_prim_hor_setor_p text default null, ie_lado_p text default null, nr_seq_material_exame_p text default null, ie_futuro_p text default 'N', ie_dia_seguinte_p text default 'N', nr_seq_contraste_p bigint default null, ds_dado_clinico_p text default null, cd_microorganismo_p bigint default null, nr_seq_proc_interno_p proc_interno.nr_sequencia%type default null, nr_seq_cpoe_order_unit_p cpoe_order_unit.nr_sequencia%type default null) AS $body$
DECLARE


ds_stack_w        log_cpoe.ds_stack%type;
ds_log_cpoe_w      log_cpoe.ds_log%type;
cd_procedimento_w    procedimento.cd_procedimento%type;
ie_origem_proced_w    procedimento.ie_origem_proced%type;
ie_origem_aux_w      procedimento.ie_origem_proced%type;

cd_setor_exclusivo_w  setor_atendimento.cd_setor_atendimento%type;
cd_setor_atend_conv_w  setor_atendimento.cd_setor_atendimento%type;

cd_medico_exec_w    pessoa_fisica.cd_pessoa_fisica%type;

nr_seq_material_w    material_exame_lab.nr_sequencia%type;

nr_seq_exame_w      exame_laboratorio.nr_seq_exame%type;

nr_seq_proc_interno_w  proc_interno.nr_sequencia%type;
nr_seq_proc_int_aux_w  proc_interno.nr_sequencia%type;

ie_horario_prescr_w    exame_lab_rotina.ie_horario_prescr%type;
ds_resumo_clinico_w    exame_lab_rotina.ds_resumo_clinico%type;
ie_duracao_w      exame_lab_rotina.ds_resumo_clinico%type;

cd_intervalo_w      intervalo_prescricao.cd_intervalo%type;

ds_material_especial_w  prescr_procedimento.ds_material_especial%type;
ds_observacao_w      prescr_procedimento.ds_observacao%type;
ie_lado_w        prescr_procedimento.ie_lado%type;
qt_hora_intervalo_w    prescr_procedimento.qt_hora_intervalo%type;
qt_min_intervalo_w    prescr_procedimento.qt_min_intervalo%type;

cd_material_exame_w    material_exame_lab.cd_material_exame%type;

ie_acm_w         exame_lab_rotina.ie_acm%type;
ie_se_necessario_w    exame_lab_rotina.ie_se_necessario%type;

ie_agora_w        char(1);
ds_erro_w        varchar(4000);

nr_seq_contraste_w    procedimento_rotina.nr_seq_contraste%type;
ds_observacao_contraste_w proc_interno_contraste.ds_observacao%type;
ie_amostra_w		exame_lab_rotina.ie_amostra%type;

c01 CURSOR FOR
SELECT  coalesce(c.cd_procedimento, a.cd_procedimento),
    coalesce(c.ie_origem_proced, a.ie_origem_proced),
    (SELECT  max(z.cd_setor_exclusivo)
     from  procedimento z
     where  z.cd_procedimento = a.cd_procedimento
     and  z.ie_origem_proced = a.ie_origem_proced ) cd_setor_exclusivo,
    a.nr_seq_exame,
    x.nr_seq_material,
    x.ds_mat_esp,
    coalesce(x.ie_agora,'N'),
    x.ie_horario_prescr,
    substr(x.ds_observacao,1,255),
    x.cd_medico_exec,
    x.cd_intervalo,
    x.nr_seq_exame_interno nr_seq_proc_interno,
    x.ie_lado,
    x.qt_hora_intervalo,
    x.qt_min_intervalo,
    coalesce(x.ie_acm, 'N'),
    coalesce(x.ie_se_necessario, 'N'),
    x.ds_resumo_clinico,
    x.ie_duracao,
    x.ie_amostra
FROM exame_lab_rotina x, exame_laboratorio a
LEFT OUTER JOIN exame_lab_convenio c ON (a.nr_seq_exame = c.nr_seq_exame AND cd_convenio_p = c.cd_convenio AND ie_origem_aux_w = c.ie_origem_proced)
WHERE x.nr_seq_exame = a.nr_seq_exame    and (x.nr_seq_exame_interno IS NOT NULL AND x.nr_seq_exame_interno::text <> '') and clock_timestamp() between coalesce(c.dt_inicio_vigencia,clock_timestamp()) and coalesce(c.dt_fim_vigencia,clock_timestamp()) and ((coalesce(c.ie_tipo_atendimento::text, '') = '') or (c.ie_tipo_atendimento = ie_tipo_atendimento_p))  and x.nr_sequencia = nr_seq_rotina_p;


BEGIN

ie_origem_aux_w := obter_origem_proced_cat(cd_estabelecimento_p, ie_tipo_atendimento_p, ie_tipo_convenio_p, cd_convenio_p, cd_categoria_convenio_p);

open c01;
loop
fetch c01 into
  cd_procedimento_w,
  ie_origem_proced_w,
  cd_setor_exclusivo_w,
  nr_seq_exame_w,
  nr_seq_material_w,
  ds_material_especial_w,
  ie_agora_w,
  ie_horario_prescr_w,
  ds_observacao_w,
  cd_medico_exec_w,
  cd_intervalo_w,
  nr_seq_proc_interno_w,
  ie_lado_w,
  qt_hora_intervalo_w,
  qt_min_intervalo_w,
  ie_acm_w,
  ie_se_necessario_w,
  ds_resumo_clinico_w,
  ie_duracao_w,
  ie_amostra_w;
EXIT WHEN NOT FOUND; /* apply on c01 */
  begin

  if (coalesce(ie_urgencia_p,'N') = 'S') then
    ie_agora_w := 'S';
  end if;

  select  max(a.cd_procedimento),
      max(a.ie_origem_proced)
  into STRICT  cd_procedimento_w,
      ie_origem_proced_w
  from   exame_laboratorio a,
      exame_lab_rotina x
  where  x.nr_seq_exame    = a.nr_seq_exame
  and    x.nr_sequencia    = nr_seq_rotina_p;

  if (nr_seq_exame_w IS NOT NULL AND nr_seq_exame_w::text <> '') then
    if (nr_seq_material_w IS NOT NULL AND nr_seq_material_w::text <> '') then
      select  max(cd_material_exame)
      into STRICT  cd_material_exame_w
      from  material_exame_lab
      where  nr_sequencia = nr_seq_material_w;
    end if;

    SELECT * FROM obter_exame_lab_convenio(  nr_seq_exame_w, cd_convenio_p, cd_categoria_convenio_p, ie_tipo_atendimento_p, cd_estabelecimento_p, ie_tipo_convenio_p, null, cd_material_exame_w, cd_plano_convenio_p, cd_setor_atend_conv_w, cd_procedimento_w, ie_origem_proced_w, ds_erro_w, nr_seq_proc_int_aux_w) INTO STRICT cd_setor_atend_conv_w, cd_procedimento_w, ie_origem_proced_w, ds_erro_w, nr_seq_proc_int_aux_w;

    select  max(b.cd_setor_exclusivo)
    into STRICT  cd_setor_exclusivo_w
    from  procedimento b
    where  b.cd_procedimento  = cd_procedimento_w
    and    b.ie_origem_proced  = ie_origem_proced_w;
  end if;

  if (nr_seq_material_w IS NOT NULL AND nr_seq_material_w::text <> '') then
    select  max(cd_material_exame)
    into STRICT  cd_material_exame_w
    from  material_exame_lab
    where  nr_sequencia = nr_seq_material_w;
  else
    select  max(cd_material_exame)
    into STRICT  cd_material_exame_w
    from  material_exame_lab b,
        exame_lab_material a
    where  a.nr_seq_material = b.nr_sequencia
    and    a.nr_seq_exame = nr_seq_exame_w
    and    a.ie_situacao = 'A'
    and    a.ie_prioridade  = (  SELECT  min(ie_prioridade)
                  from  exame_lab_material x
                  where  nr_seq_exame = nr_seq_exame_w
                  and    x.ie_situacao = 'A' );
  end if;


  if ((ie_lado_p IS NOT NULL AND ie_lado_p::text <> '') or ie_lado_p <> '') then
    ie_lado_w := ie_lado_p;
  end if;

  if ((nr_seq_contraste_p IS NOT NULL AND nr_seq_contraste_p::text <> '') or nr_seq_contraste_p <> '') then
    nr_seq_contraste_w := nr_seq_contraste_p;
  end if;

  nr_seq_item_gerado_p := CPOE_inserir_exame_proc_rotina(  nr_atendimento_p, nr_seq_rotina_p, cd_estabelecimento_p, cd_perfil_p, nm_usuario_p, cd_setor_atendimento_p, ie_tipo_atendimento_p, cd_convenio_p, ie_tipo_convenio_p, dt_base_proc_p, cd_paciente_p, qt_idade_dia_p, qt_idade_mes_p, qt_idade_ano_p, qt_peso_p, cd_prescritor_p, cd_setor_usuario_p, cd_medico_p, cd_medico_exec_w, cd_especialidade_p, nr_seq_rotina_esp_p, nr_seq_proc_interno_w, cd_procedimento_w, ie_origem_proced_w, nr_seq_exame_w, cd_setor_exclusivo_w, cd_material_exame_w, ds_material_especial_w, cd_intervalo_w, ds_observacao_w, null, null, ie_agora_w, ie_acm_w, ie_se_necessario_w, ie_lado_w, qt_hora_intervalo_w, qt_min_intervalo_w, ie_gerar_associado_p, ie_horario_prescr_w, nr_seq_item_gerado_p, nr_seq_transcricao_p, ie_item_alta_p, ie_prescritor_aux_p, ie_retrogrado_p, dt_inicio_p, nr_seq_pepo_p, nr_cirurgia_p, nr_cirurgia_patologia_p, nr_seq_agenda_p, ie_oncologia_p, nr_seq_conclusao_apae_p, hr_prim_hor_setor_p, coalesce(ds_dado_clinico_p, ds_resumo_clinico_w), null, ie_duracao_w, nr_seq_contraste_w, nr_seq_material_exame_p, ie_futuro_p, ie_dia_seguinte_p, ie_amostra_w, null, null, cd_microorganismo_p, nr_seq_cpoe_order_unit_p);

  commit;
  exit;

  end;
end loop;
close c01;

exception
   when others then
  rollback;

  ds_stack_w  := substr('Backtrace: '|| dbms_utility.format_error_backtrace ||
			' CallStack: '|| dbms_utility.format_call_stack,1,2000);

  ds_log_cpoe_w := substr('CPOE_GERAR_EXAME_LAB_ROTINA '
    || chr(13) || ' - nr_atendimento_p: ' || nr_atendimento_p
    || chr(13) || ' - nr_seq_rotina_p: ' || nr_seq_rotina_p
    || chr(13) || ' - cd_estabelecimento_p: ' || cd_estabelecimento_p
    || chr(13) || ' - cd_perfil_p: ' || cd_perfil_p
    || chr(13) || ' - nm_usuario_p: ' || nm_usuario_p
    || chr(13) || ' - cd_setor_atendimento_p: ' || cd_setor_atendimento_p
    || chr(13) || ' - ie_tipo_atendimento_p: ' || ie_tipo_atendimento_p
    || chr(13) || ' - cd_convenio_p: ' || cd_convenio_p
    || chr(13) || ' - ie_tipo_convenio_p: ' || ie_tipo_convenio_p
    || chr(13) || ' - cd_plano_convenio_p: ' || cd_plano_convenio_p
    || chr(13) || ' - cd_categoria_convenio_p: ' || cd_categoria_convenio_p
    || chr(13) || ' - dt_base_proc_p: ' || to_char(dt_base_proc_p, 'dd/mm/yyyy hh24:mi:ss')
    || chr(13) || ' - cd_paciente_p: ' || cd_paciente_p
    || chr(13) || ' - qt_idade_dia_p: ' || qt_idade_dia_p
    || chr(13) || ' - qt_idade_mes_p: ' || qt_idade_mes_p
    || chr(13) || ' - qt_idade_ano_p: ' || qt_idade_ano_p
    || chr(13) || ' - qt_peso_p: ' || qt_peso_p
    || chr(13) || ' - cd_prescritor_p: ' || cd_prescritor_p
    || chr(13) || ' - cd_setor_usuario_p: ' || cd_setor_usuario_p
    || chr(13) || ' - cd_medico_p: ' || cd_medico_p
    || chr(13) || ' - cd_especialidade_p: ' || cd_especialidade_p
    || chr(13) || ' - nr_seq_rotina_esp_p: ' || nr_seq_rotina_esp_p
    || chr(13) || ' - ie_gerar_associado_p: ' || ie_gerar_associado_p
    || chr(13) || ' - nr_seq_item_gerado_p: ' || nr_seq_item_gerado_p
    || chr(13) || ' - nr_seq_transcricao_p: ' || nr_seq_transcricao_p
    || chr(13) || ' - ie_item_alta_p: ' || ie_item_alta_p
    || chr(13) || ' - ie_prescritor_aux_p: ' || ie_prescritor_aux_p
    || chr(13) || ' - ie_retrogrado_p: ' || ie_retrogrado_p
    || chr(13) || ' - ie_futuro_p: ' || ie_futuro_p
    || chr(13) || ' - dt_inicio_p: ' || to_char(dt_inicio_p, 'dd/mm/yyyy hh24:mi:ss')
    || chr(13) || ' - nr_seq_pepo_p: ' || nr_seq_pepo_p
    || chr(13) || ' - nr_cirurgia_p: ' || nr_cirurgia_p
    || chr(13) || ' - nr_cirurgia_patologia_p: ' || nr_cirurgia_patologia_p
    || chr(13) || ' - nr_seq_agenda_p: ' || nr_seq_agenda_p
    || chr(13) || ' - ie_urgencia_p: ' || ie_urgencia_p
    || chr(13) || ' - ie_oncologia_p: ' || ie_oncologia_p
    || chr(13) || ' - nr_seq_conclusao_apae_p: ' || nr_seq_conclusao_apae_p
    || chr(13) || ' - hr_prim_hor_setor_p: ' || hr_prim_hor_setor_p
    || chr(13) || ' - ie_lado_p: ' || ie_lado_p
    || chr(13) || ' - nr_seq_material_exame_p: ' || nr_seq_material_exame_p
    || chr(13) || ' - ERRO: ' || sqlerrm
    || chr(13) || ' - FUNCAO('||to_char(obter_funcao_ativa)||'); PERFIL('||to_char(obter_perfil_ativo)||')',1,2000);

  insert into log_cpoe(
    nr_sequencia,
    nr_atendimento,
    dt_atualizacao,
    nm_usuario,
    ds_log,
    ds_stack)
  values (
    nextval('log_cpoe_seq'),
    nr_atendimento_p,
    clock_timestamp(),
    nm_usuario_p,
    ds_log_cpoe_w,
    ds_stack_w);

  commit;

  CALL wheb_mensagem_pck.exibir_mensagem_abort(sqlerrm);

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE cpoe_gerar_exame_lab_rotina ( nr_atendimento_p bigint, nr_seq_rotina_p bigint, cd_estabelecimento_p bigint, cd_perfil_p bigint, nm_usuario_p text, cd_setor_atendimento_p bigint, ie_tipo_atendimento_p bigint, cd_convenio_p bigint, ie_tipo_convenio_p bigint, cd_plano_convenio_p text, cd_categoria_convenio_p text, dt_base_proc_p timestamp, cd_paciente_p text, qt_idade_dia_p bigint, qt_idade_mes_p bigint, qt_idade_ano_p bigint, qt_peso_p bigint, cd_prescritor_p text, cd_setor_usuario_p bigint, cd_medico_p text, cd_especialidade_p bigint, nr_seq_rotina_esp_p bigint, ie_gerar_associado_p char, nr_seq_item_gerado_p INOUT bigint, nr_seq_transcricao_p bigint default null, ie_item_alta_p text default 'N', ie_prescritor_aux_p text default 'N', ie_retrogrado_p text default 'N', dt_inicio_p timestamp default null, nr_seq_pepo_p bigint default null, nr_cirurgia_p bigint default null, nr_cirurgia_patologia_p bigint default null, nr_seq_agenda_p bigint default null, ie_urgencia_p text default null, ie_oncologia_p text default 'N', nr_seq_conclusao_apae_p bigint default null, hr_prim_hor_setor_p text default null, ie_lado_p text default null, nr_seq_material_exame_p text default null, ie_futuro_p text default 'N', ie_dia_seguinte_p text default 'N', nr_seq_contraste_p bigint default null, ds_dado_clinico_p text default null, cd_microorganismo_p bigint default null, nr_seq_proc_interno_p proc_interno.nr_sequencia%type default null, nr_seq_cpoe_order_unit_p cpoe_order_unit.nr_sequencia%type default null) FROM PUBLIC;

