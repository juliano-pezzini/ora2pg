-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION cpoe_obter_padrao_param_prescr ( nr_atendimento_p atendimento_paciente.nr_atendimento%type, cd_material_p material.cd_material%type, ie_via_aplicacao_p via_aplicacao.ie_via_aplicacao%type, ie_se_necessario_p text, ie_opcao_p text, cd_intervalo_p intervalo_prescricao.cd_intervalo%type, cd_estabelecimento_p estabelecimento.cd_estabelecimento%type, cd_perfil_p perfil.cd_perfil%type, nm_usuario_p usuario.nm_usuario%type, cd_pessoa_fisica_p pessoa_fisica.cd_pessoa_fisica%type default null) RETURNS varchar AS $body$
DECLARE


qt_peso_w          double precision;
cd_setor_atend_prescr_w    setor_atendimento.cd_setor_atendimento%type;
nr_seq_agrupamento_w    setor_atendimento.nr_seq_agrupamento%type;
qt_dose_w          material_prescr.qt_dose%type;
cd_intervalo_w        material_prescr.cd_intervalo%type;
cd_unidade_medida_w      material_prescr.cd_unidade_medida%type;
ie_via_aplic_padrao_w    material_prescr.ie_via_aplic_padrao%type;
ie_dispositivo_inf_w    material_prescr.ie_dispositivo_infusao%type;
qt_minuto_aplicacao_w    material_prescr.qt_minuto_aplicacao%type;
qt_dias_solicitado_w    material_prescr.qt_dias_solicitado%type;
ie_dose_w          material_prescr.ie_dose%type;
ds_justificativa_w      material_prescr.ds_justificativa%type;
qt_hora_aplicacao_w      material_prescr.qt_hora_aplicacao%type;
qt_solucao_w        material_prescr.qt_solucao%type;
ie_diluicao_w        material_prescr.ie_diluicao%type;
hr_prim_horario_w      material_prescr.hr_prim_horario%type;
ie_se_necessario_w      material_prescr.ie_se_necessario%type;
ie_dose_nula_w        material_prescr.ie_dose_nula%type;
ie_urgencia_w        material_prescr.ie_gerar_agora%type;
ie_obedecer_limite_w    material_prescr.ie_obedecer_limite%type;
ds_mensagem_w        material_prescr.ds_mensagem%type;
ie_obriga_just_dose_w    material_prescr.ie_obriga_just_dose%type;
qt_dose_terapeutica_w    material_prescr.qt_dose_terapeutica%type;
nr_seq_dose_terap_w      material_prescr.nr_seq_dose_terap%type;
ds_horarios_w        material_prescr.ds_horarios%type;
qt_dose_ataque_w      material_prescr.qt_dose_especial%type;
ds_obs_padrao_w        material_prescr.ds_obs_padrao%type;
ie_limpar_prim_hor_w    material_prescr.ie_limpar_prim_hor%type;
ie_tipo_dosagem_w      material_prescr.ie_tipo_dosagem%type;

cd_pessoa_fisica_w      pessoa_fisica.cd_pessoa_fisica%type;

ie_fracao_dose_w      varchar(1);
ie_justificativa_padrao_w   varchar(2);
cd_unidade_basica_w      varchar(30);
ds_retorno_w        varchar(255) := null;

qt_idade_w          double precision;
qt_idade_gestacional_w    double precision;
qt_idade_min_w        double precision;
qt_idade_max_w        double precision;

/*Medical Device*/

sql_w                       varchar(4000);
ie_diluicao_sel_w      varchar(1);

/*
I - Intervalo
D - Dose
DT - Dose de ataque
U - Unidade medida
J - Justificativa
A - Agora
SN - Se necessario
OL - Obedecer limite
HP   - Hora/rios padroes
LH - Limpa Primeiro Horario
*/
c01 CURSOR FOR
SELECT  qt_dose,
    substr(a.cd_intervalo,1,7),
    substr(a.cd_unidade_medida,1,30),
    a.ie_via_aplic_padrao,
    a.ie_dispositivo_infusao,
    a.qt_minuto_aplicacao,
    a.qt_dias_solicitado,
    a.ie_dose,
    a.ds_justificativa,
    a.qt_hora_aplicacao,
    a.qt_solucao,
    a.ie_diluicao,
    a.hr_prim_horario,
    a.ie_se_necessario,
    obter_dados_medic_atb_var(a.cd_material,cd_estabelecimento_p,a.ie_justificativa_padrao,'JP',null,null,null),
    coalesce(a.ie_dose_nula,'N'),
    coalesce(a.ie_gerar_agora,'N'),
    coalesce(obter_idade_param_prescr2(coalesce(a.qt_idade_min,0),coalesce(a.qt_idade_min_mes,0),coalesce(a.qt_idade_min_dia,0),coalesce(a.qt_idade_max,0),coalesce(a.qt_idade_max_mes,0),coalesce(a.qt_idade_max_dia,0),'MIN'),0) qt_idade_min,
    coalesce(obter_idade_param_prescr2(coalesce(a.qt_idade_min,0),coalesce(a.qt_idade_min_mes,0),coalesce(a.qt_idade_min_dia,0),coalesce(a.qt_idade_max,0),coalesce(a.qt_idade_max_mes,0),coalesce(a.qt_idade_max_dia,0),'MAX'),9999999) qt_idade_max,
    a.ie_obedecer_limite,
    a.ds_mensagem,
    a.ie_obriga_just_dose,
    a.qt_dose_terapeutica,
    a.nr_seq_dose_terap,
    a.ds_horarios,
    a.qt_dose_especial,
    a.ds_obs_padrao,
    coalesce(a.ie_limpar_prim_hor,'N'),
    a.ie_tipo_dosagem
from  material_prescr a
where  a.cd_material  = cd_material_p
and    a.ie_tipo   = '1'
and    coalesce(a.cd_setor_atendimento, coalesce(cd_setor_atend_prescr_w,0))  = coalesce(cd_setor_atend_prescr_w,0)
and    coalesce(a.cd_unidade_basica, coalesce(cd_unidade_basica_w,'0'))  = coalesce(cd_unidade_basica_w,'0')
and    ((coalesce(a.ie_via_aplicacao::text, '') = '') or (a.ie_via_aplicacao = ie_via_aplicacao_p))
and    coalesce(qt_peso_w,1) between coalesce(a.qt_peso_min,0) and coalesce(a.qt_peso_max,999999)
and    ((coalesce(nr_seq_agrupamento::text, '') = '') or (nr_seq_agrupamento  = nr_seq_agrupamento_w))
and    (((coalesce(qt_ig_min::text, '') = '') and (coalesce(qt_ig_max::text, '') = '')) or ((qt_idade_gestacional_w between coalesce(qt_ig_min,0) and coalesce(qt_ig_max,9999999)) and (qt_idade_gestacional_w < 41)))
and    coalesce(trunc(qt_idade_w),1) between coalesce(obter_idade_param_prescr2(coalesce(a.qt_idade_min,0),coalesce(a.qt_idade_min_mes,0),coalesce(a.qt_idade_min_dia,0),coalesce(a.qt_idade_max,0),coalesce(a.qt_idade_max_mes,0),coalesce(a.qt_idade_max_dia,0),'MIN'),0) and coalesce(obter_idade_param_prescr2(coalesce(a.qt_idade_min,0),coalesce(a.qt_idade_min_mes,0),coalesce(a.qt_idade_min_dia,0),coalesce(a.qt_idade_max,0),coalesce(a.qt_idade_max_mes,0),coalesce(a.qt_idade_max_dia,0),'MAX'),9999999)
and    not exists (SELECT  1
          from  regra_setor_mat_prescr b
          where  a.nr_sequencia  = b.nr_seq_mat_prescr
          and  b.cd_setor_excluir  = cd_setor_atend_prescr_w)
and    ((coalesce(a.ie_somente_sn,'N')  = 'N') or (ie_se_necessario_p = 'S'))
and    ((coalesce(a.cd_estabelecimento::text, '') = '') or (a.cd_estabelecimento = cd_estabelecimento_p))
and    ((coalesce(a.cd_intervalo_filtro::text, '') = '') or (a.cd_intervalo_filtro = cd_intervalo_p))
and    ((coalesce(cd_doenca_cid::text, '') = '') or ((nr_atendimento_p IS NOT NULL AND nr_atendimento_p::text <> '') and 
     obter_se_cid_atendimento(nr_atendimento_p,cd_doenca_cid) = 'S'))
and     cpoe_obter_se_exibe_interv(nr_atendimento_p,cd_estabelecimento_p,a.cd_intervalo,cd_perfil_p,nm_usuario_p) = 'S'
order by
    coalesce(a.cd_setor_atendimento,99999) desc,
    a.qt_idade_min,
    a.qt_idade_max,
    coalesce(a.ie_via_aplicacao, 'zzzzzzzz') desc, 
    coalesce(a.qt_peso_min, 99999999) desc,
    a.nr_sequencia;


BEGIN


 if (nr_atendimento_p IS NOT NULL AND nr_atendimento_p::text <> '') then
  cd_pessoa_fisica_w    := coalesce(cd_pessoa_fisica_p, obter_pessoa_atendimento(nr_atendimento_p,'C'));

  cd_unidade_basica_w    := obter_unidade_atendimento(nr_atendimento_p,'A','UB');
  qt_peso_w        := round((obter_sinal_vital(nr_atendimento_p,'Peso'))::numeric, 3);
  cd_setor_atend_prescr_w  := cpoe_obter_setor_atend_prescr(nr_atendimento_p,cd_estabelecimento_p,cd_perfil_p,nm_usuario_p);

  select  max(nr_seq_agrupamento)
  into STRICT  nr_seq_agrupamento_w
  from  setor_atendimento
  where  cd_setor_atendimento  = cd_setor_atend_prescr_w;
else
  cd_pessoa_fisica_w    := cd_pessoa_fisica_p;

  cd_unidade_basica_w    := null;
  qt_peso_w        := obter_peso_pf(cd_pessoa_fisica_w);
  cd_setor_atend_prescr_w  := null;

  nr_seq_agrupamento_w  := null;
end if;

select  max(obter_idade(b.dt_nascimento,coalesce(b.dt_obito,clock_timestamp()),'DIA')),
    coalesce(max(Obter_semana_Idade_IGC(clock_timestamp(), b.dt_nascimento, b.dt_nascimento_ig, b.qt_dias_ig, b.qt_semanas_ig)),0)
into STRICT  qt_idade_w,
    qt_idade_gestacional_w
from  pessoa_fisica b
where  b.cd_pessoa_fisica  = cd_pessoa_fisica_w;

open c01;
loop
fetch c01 into
  qt_dose_w,
  cd_intervalo_w,
  cd_unidade_medida_w,
  ie_via_aplic_padrao_w,
  ie_dispositivo_inf_w,
  qt_minuto_aplicacao_w,
  qt_dias_solicitado_w,
  ie_dose_w,
  ds_justificativa_w,
  qt_hora_aplicacao_w,
  qt_solucao_w,
  ie_diluicao_w,
  hr_prim_horario_w,
  ie_se_necessario_w,
  ie_justificativa_padrao_w,
  ie_dose_nula_w,
  ie_urgencia_w,
  qt_idade_min_w,
  qt_idade_max_w,
  ie_obedecer_limite_w,
  ds_mensagem_w,
  ie_obriga_just_dose_w,
  qt_dose_terapeutica_w,
  nr_seq_dose_terap_w,
  ds_horarios_w,
  qt_dose_ataque_w,
  ds_obs_padrao_w,
  ie_limpar_prim_hor_w,
  ie_tipo_dosagem_w;
EXIT WHEN NOT FOUND; /* apply on c01 */
  begin
  select  coalesce(max(ie_fracao_dose),'N')
  into STRICT  ie_fracao_dose_w
  from  unidade_medida
  where  cd_unidade_medida = cd_unidade_medida_w;

    /*INICIO MD*/

    select max(ie_diluicao)
      into STRICT ie_diluicao_sel_w
      from mat_via_aplic
     where cd_material = cd_material_p
       and ie_via_aplicacao = ie_via_aplicacao_p
       and ((cd_setor_atendimento = cd_setor_atend_prescr_w) or (coalesce(cd_setor_atendimento::text, '') = ''))
       and ((cd_setor_excluir <> cd_setor_atend_prescr_w) or (coalesce(cd_setor_excluir::text, '') = ''))
       and coalesce(cd_estabelecimento,cd_estabelecimento_p) = cd_estabelecimento_p;
    begin
      sql_w := 'begin cpoe_obter_padrao_prm_presc_md(:1, :2, :3, :4, :5, :6, :7, :8, :9, :10,
                                                     :11, :12, :13, :14, :15, :16, :17, :18, :19, :20,
                                                     :21, :22, :23, :24, :25, :26, :27, :28, :29, :30,
                                                     :31, :32); end;';
      EXECUTE sql_w using in ie_opcao_p,
                                    in cd_intervalo_w,
                                    in ie_dose_w,
                                    in qt_dose_w,
                                    in ie_fracao_dose_w,
                                    in qt_peso_w,
                                    in qt_dose_ataque_w,
                                    in cd_unidade_medida_w,
                                    in ie_via_aplic_padrao_w,
                                    in ie_dispositivo_inf_w,
                                    in qt_minuto_aplicacao_w,
                                    in qt_hora_aplicacao_w,
                                    in qt_solucao_w,
                                    in ds_justificativa_w,
                                    in out ie_diluicao_w,
                                    in ie_diluicao_sel_w,
                                    in qt_dias_solicitado_w,
                                    in hr_prim_horario_w,
                                    in ie_justificativa_padrao_w,
                                    in ie_se_necessario_w,
                                    in ie_dose_nula_w,
                                    in ie_urgencia_w,
                                    in ds_mensagem_w,
                                    in ie_obriga_just_dose_w,
                                    in qt_dose_terapeutica_w,
                                    in nr_seq_dose_terap_w,
                                    in ie_obedecer_limite_w,
                                    in ds_horarios_w,  
                                    in ds_obs_padrao_w,
                                    in ie_limpar_prim_hor_w,
                                    in ie_tipo_dosagem_w,
                                    out ds_retorno_w;

      if (ie_opcao_p = 'L') then	
        if (coalesce(ie_diluicao_w::text, '') = '') then
          ie_diluicao_w := ie_diluicao_sel_w;
        else
          exit;
        end if;
      end if;
    exception
      when others then
        ie_diluicao_w := null;
        ds_retorno_w := null;
    end;
    /*FIM MD*/

  end;
end loop;
close c01;

if (ie_opcao_p = 'L') then
  if (coalesce(ie_diluicao_w::text, '') = '') then
    select  max(ie_diluicao)
    into STRICT    ie_diluicao_w
    from    mat_via_aplic
    where  cd_material    = cd_material_p
    and    ie_via_aplicacao  = ie_via_aplicacao_p
    and     ((cd_setor_atendimento = cd_setor_atend_prescr_w) or (coalesce(cd_setor_atendimento::text, '') = ''))
    and    ((cd_setor_excluir <> cd_setor_atend_prescr_w) or (coalesce(cd_setor_excluir::text, '') = ''))
    and    coalesce(cd_estabelecimento,cd_estabelecimento_p) = cd_estabelecimento_p;
  end if;
  if (coalesce(ie_diluicao_w::text, '') = '') then
    select  max(ie_diluicao)
    into STRICT  ie_diluicao_w
    from  material
    where  cd_material    = cd_material_p;
  end if;
  ds_retorno_w  := ie_diluicao_w;
end if;

return ds_retorno_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION cpoe_obter_padrao_param_prescr ( nr_atendimento_p atendimento_paciente.nr_atendimento%type, cd_material_p material.cd_material%type, ie_via_aplicacao_p via_aplicacao.ie_via_aplicacao%type, ie_se_necessario_p text, ie_opcao_p text, cd_intervalo_p intervalo_prescricao.cd_intervalo%type, cd_estabelecimento_p estabelecimento.cd_estabelecimento%type, cd_perfil_p perfil.cd_perfil%type, nm_usuario_p usuario.nm_usuario%type, cd_pessoa_fisica_p pessoa_fisica.cd_pessoa_fisica%type default null) FROM PUBLIC;
