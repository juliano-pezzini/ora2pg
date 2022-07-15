-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE obter_entrega_laudo ( NR_PRESCRICAO_P bigint, DT_PREV_EXECUCAO_P timestamp, NR_SEQ_PROC_INTERNO_P bigint, CD_PROCEDIMENTO_P bigint, IE_ORIGEM_PROCED_P bigint, CD_SETOR_ATENDIMENTO_P bigint, NM_USUARIO_P text, DT_ENTREGA_P INOUT timestamp) AS $body$
DECLARE


ie_existe_regra_w  integer;

cd_estabelecimento_w  smallint;
ie_tipo_atendimento_w  smallint;
cd_convenio_w    integer;
dt_entrada_w    timestamp;
dt_prescricao_w    timestamp;
cd_setor_prescricao_w  integer;
cd_setor_atendimento_w  integer;
cd_procedencia_w  integer;

cd_area_proc_w    bigint;
cd_especial_proc_w  bigint;
cd_grupo_proc_w    bigint;

qt_dia_w    regra_entrega_laudo.qt_dia%type := 0;
qt_hora_w    smallint := 0;
qt_hora_adicional_w  smallint := 0;
ds_hora_fixa_w    varchar(2);
ds_hora_inicial_w  varchar(2);
ds_hora_final_w    varchar(2);
ie_feriado_w    varchar(1);
ie_sabado_w    varchar(1);
ie_domingo_w    varchar(1);
ie_carater_inter_sus_w  varchar(2);
nr_atendimento_w  bigint;

dt_entrega_w    timestamp := clock_timestamp();
dt_entrega_calc_w  timestamp;
dt_entrega_ww    timestamp;

qt_dia_aux_w    regra_entrega_laudo.qt_dia%type;
dt_entrega_aux_w  timestamp;
dt_entrega_prescr_w  timestamp;
qt_hora_prescr_w  smallint;
ds_hora_fixa_prescr_w  varchar(2);
i      integer;
ie_tipo_convenio_w  smallint;
cd_perfil_w    integer;
ie_adiciona_dia_w    varchar(1);
ie_adiciona_dia_feriado_w  varchar(1);
ie_adiciona_dia_domingo_w  varchar(1);
ie_adiciona_dia_sabado_w  varchar(1);
ie_fim_semana_ant_w    varchar(1);
ie_dia_semana_w      smallint;
nr_seq_forma_laudo_w    bigint;

nr_seq_classif_w    bigint;

nr_seq_grupo_sus_w    bigint;
nr_seq_forma_org_sus_w    bigint;
nr_seq_subgrupo_sus_w    bigint;


ie_dia_ok_w    boolean := False;

C01 CURSOR FOR
  SELECT  coalesce(qt_dia,0),
    coalesce(qt_hora,0),
    coalesce(qt_hora_adicional,0),
    ds_hora_fixa,
    ds_hora_inicial,
    ds_hora_final,
    ie_feriado,
    ie_sabado,
    ie_domingo,
    coalesce(ie_adiciona_dia,'S'),
    coalesce(qt_hora_prescr,0),
    ds_hora_fixa_prescr,
    coalesce(ie_adiciona_dia_feriado,'N'),
    coalesce(ie_adiciona_dia_domingo,'N'),
    coalesce(ie_adiciona_dia_sabado,'N')
  from  regra_entrega_laudo
  where  coalesce(cd_area_procedimento, cd_area_proc_w)     = cd_area_proc_w
  and  coalesce(cd_especialidade, cd_especial_proc_w)     = cd_especial_proc_w
  and  coalesce(cd_grupo_proc, cd_grupo_proc_w)       = cd_grupo_proc_w
  and  coalesce(cd_procedimento, coalesce(cd_procedimento_p,0))     = coalesce(cd_procedimento_p,0)
  and  coalesce(ie_origem_proced, coalesce(ie_origem_proced_p,0))   = coalesce(ie_origem_proced_p,0)
  and  coalesce(nr_seq_proc_interno,coalesce(nr_seq_proc_interno_p,0))   = coalesce(nr_seq_proc_interno_p,0)
  and  coalesce(cd_setor_atendimento, cd_setor_atendimento_p)   = cd_setor_atendimento_p
  and  coalesce(ie_tipo_atendimento, ie_tipo_atendimento_w)     = ie_tipo_atendimento_w
  and  coalesce(nr_seq_classif, coalesce(nr_seq_classif_w,0))     =  coalesce(nr_seq_classif_w,0)
  and  coalesce(ie_tipo_convenio, ie_tipo_convenio_w)     = ie_tipo_convenio_w
  and  coalesce(cd_estabelecimento, cd_estabelecimento_w)     = cd_estabelecimento_w
  and  coalesce(cd_procedencia, coalesce(cd_procedencia_w,0))     = coalesce(cd_procedencia_w,0)
  and  coalesce(cd_convenio, coalesce(cd_convenio_w,0))       = coalesce(cd_convenio_w,0)
  and  coalesce(cd_perfil, coalesce(cd_perfil_w,0))       = coalesce(cd_perfil_w,0)
  and  coalesce(ie_carater_inter_sus, coalesce(ie_carater_inter_sus_w,0)) = coalesce(ie_carater_inter_sus_w,0)
  and  coalesce(nr_seq_forma_laudo, coalesce(nr_seq_forma_laudo_w,0))   = coalesce(nr_seq_forma_laudo_w,0)
  and  coalesce(nr_seq_grupo_sus, coalesce(nr_seq_grupo_sus_w, 0))    = coalesce(nr_seq_grupo_sus_w, 0)
  and  coalesce(nr_seq_sub_grupo_sus, coalesce(nr_seq_subgrupo_sus_w , 0)) = coalesce(nr_seq_subgrupo_sus_w,0)
  and  coalesce(nr_seq_forma_org_sus, coalesce(nr_seq_forma_org_sus_w, 0)) = coalesce(nr_seq_forma_org_sus_w,0)
  and  trunc(clock_timestamp()) between coalesce(dt_inicio_vigencia,trunc(clock_timestamp() - interval '1 days')) and coalesce(dt_fim_vigencia,trunc(clock_timestamp() + interval '1 days'))
  and   ((to_char(dt_prescricao_w,'hh24:mi:ss') between to_char(hr_inicial,'hh24:mi:ss') and to_char(hr_final,'hh24:mi:ss')) or (coalesce(hr_inicial::text, '') = '' and coalesce(hr_final::text, '') = ''))
  and  coalesce(ie_tipo_regra, 'P')           in ('P', 'AM')
  and  ((coalesce(ie_segunda,'S')  = 'S') or (ie_dia_semana_w <> 2))
  and  ((coalesce(ie_terca,'S')  = 'S') or (ie_dia_semana_w <> 3))
  and  ((coalesce(ie_quarta,'S')  = 'S') or (ie_dia_semana_w <> 4))
  and  ((coalesce(ie_quinta,'S')  = 'S') or (ie_dia_semana_w <> 5))
  and  ((coalesce(ie_sexta,'S')  = 'S') or (ie_dia_semana_w <> 6))
  order by  coalesce(nr_seq_proc_interno,0),      
      coalesce(cd_procedimento,0),
      coalesce(cd_grupo_proc,0),
      coalesce(cd_especialidade,0),
      coalesce(cd_area_procedimento,0),
      coalesce(ie_tipo_atendimento,0),
      coalesce(cd_convenio,0),
      coalesce(ie_tipo_convenio, 0),
      coalesce(nr_seq_forma_laudo,0),      
      coalesce(ie_segunda,'S') DESC,
      coalesce(ie_terca,'S') DESC,
      coalesce(ie_quarta,'S') DESC,
      coalesce(ie_quinta,'S') DESC,
      coalesce(ie_sexta,'S') DESC,
      coalesce(dt_inicio_vigencia,clock_timestamp()) desc,
      coalesce(dt_fim_vigencia,clock_timestamp()),
      coalesce(cd_procedencia,0);

BEGIN

/* Verifica se existe regras cadastradas, se nao existir sai da procedure */

select  count(*)
into STRICT  ie_existe_regra_w
from  regra_entrega_laudo
where  coalesce(ie_tipo_regra, 'P')  in ('P', 'AM');

select  obter_perfil_ativo
into STRICT  cd_perfil_w
;

select  coalesce(max(nr_atendimento),0),
  max(cd_estabelecimento),
  max(nr_seq_forma_laudo)
into STRICT  nr_atendimento_w,
  cd_estabelecimento_w,
  nr_seq_forma_laudo_w
from  prescr_medica a
where   a.nr_prescricao  = nr_prescricao_p;

if (ie_existe_regra_w <> 0) and (nr_atendimento_w > 0) then

  /* Seleciona o convenio do atendimento */

  select  obter_convenio_atendimento(nr_atendimento_w)
  into STRICT  cd_convenio_w
;

  select  coalesce(cd_estabelecimento_w,b.cd_estabelecimento),
    b.ie_tipo_atendimento,
    b.dt_entrada,
    coalesce(DT_PREV_EXECUCAO_P,a.dt_prescricao),
    a.dt_entrega,
    a.cd_setor_atendimento,
    obter_tipo_convenio(obter_convenio_atendimento(b.nr_atendimento)),
    cd_procedencia,
    ie_carater_inter_sus
  into STRICT  cd_estabelecimento_w,
    ie_tipo_atendimento_w,
    dt_entrada_w,
    dt_prescricao_w,
    dt_entrega_prescr_w,
    cd_setor_prescricao_w,
    ie_tipo_convenio_w,
    cd_procedencia_w,
    ie_carater_inter_sus_w
  from  atendimento_paciente b,
    prescr_medica a
  where  a.nr_atendimento  = b.nr_atendimento
    and  a.nr_prescricao    = nr_prescricao_p;

  ie_dia_semana_w    := Obter_Cod_Dia_Semana(dt_prescricao_w);

  cd_setor_atendimento_w := coalesce(cd_setor_atendimento_p, cd_setor_prescricao_w);

  if (cd_procedimento_p > 0) then
    begin
    select  cd_area_procedimento,
      cd_especialidade,
      cd_grupo_proc
    into STRICT  cd_area_proc_w,
      cd_especial_proc_w,
      cd_grupo_proc_w
    from  estrutura_procedimento_v
    where  cd_procedimento  = cd_procedimento_p
    and  ie_origem_proced  = ie_origem_proced_p;
    exception
      when no_data_found then
        --' Nao foi encontrada estrutura para este procedimento '||cd_procedimento_p||'! #@#@' || ie_origem_proced_p);
        CALL WHEB_MENSAGEM_PCK.Exibir_Mensagem_Abort(192951, 'CD_PROCEDIMENTO_P=' || cd_procedimento_p ||
                    ';IE_ORIGEM_PROCED_P=' || ie_origem_proced_p);
    end;

    select  max(nr_seq_grupo),
      max(nr_seq_forma_org),
      max(nr_seq_subgrupo)
    into STRICT  nr_seq_grupo_sus_w,
            nr_seq_forma_org_sus_w,
            nr_seq_subgrupo_sus_w      
    from  sus_estrutura_procedimento_v
    where  cd_procedimento = cd_procedimento_p
    and  ie_origem_proced = ie_origem_proced_p;

  end if;

  if (nr_seq_proc_interno_p > 0) then
    begin
    
    select  coalesce(max(nr_seq_classif),0)
    into STRICT  nr_seq_classif_w
    from  proc_interno
    where  nr_sequencia = nr_seq_proc_interno_p;

    end;
  end if;


  open C01;
  loop
    fetch C01 into
      qt_dia_w,
      qt_hora_w,
      qt_hora_adicional_w,
      ds_hora_fixa_w,
      ds_hora_inicial_w,
      ds_hora_final_w,
      ie_feriado_w,
      ie_sabado_w,
      ie_domingo_w,
      ie_adiciona_dia_w,
      qt_hora_prescr_w,
      ds_hora_fixa_prescr_w,    
      ie_adiciona_dia_feriado_w,
      ie_adiciona_dia_domingo_w,      
      ie_adiciona_dia_sabado_w;
    EXIT WHEN NOT FOUND; /* apply on C01 */

  end loop;
  close C01;
  dt_prescricao_w  := dt_prescricao_w + (qt_hora_adicional_w/24);
  dt_entrega_w  := dt_prescricao_w;

  if (coalesce(qt_dia_w::text, '') = '') then
    qt_dia_w  := 0;
  end if;
  qt_dia_aux_w  := qt_dia_w;


  if (qt_dia_w > 0) and (dt_entrega_w = dt_prescricao_w) then

    if (pkg_date_utils.get_WeekDay(dt_entrega_w) = '7') and (ie_adiciona_dia_sabado_w = 'S') then
      qt_dia_aux_w  := qt_dia_aux_w + 1;
    end if;
    if (pkg_date_utils.get_WeekDay(dt_entrega_w) = '1') and (ie_adiciona_dia_domingo_w = 'S') then
      qt_dia_aux_w  := qt_dia_aux_w + 1;
    end if;
    if (obter_se_feriado(cd_estabelecimento_w, dt_entrega_w) = 1) and (ie_adiciona_dia_feriado_w = 'S') then
      qt_dia_aux_w  := qt_dia_aux_w + 1;
    end if;

  end if;

  dt_entrega_calc_w  := dt_entrega_w;

    i := 1;
  while(qt_dia_w > 0) loop
    
    if (pkg_date_utils.get_WeekDay(dt_entrega_w+i) = '7') and (ie_sabado_w = 'N') then
      ie_fim_semana_ant_w  := 'S';
      qt_dia_aux_w  := qt_dia_aux_w + 1;
    elsif (pkg_date_utils.get_WeekDay(dt_entrega_w+i) = '1') and (ie_domingo_w = 'N') then
      ie_fim_semana_ant_w  := 'S';
      qt_dia_aux_w  := qt_dia_aux_w + 1;
    elsif (obter_se_feriado(cd_estabelecimento_w, dt_entrega_w + i) = 1) and (ie_feriado_w = 'N') then
      qt_dia_aux_w  := qt_dia_aux_w + 1;
    else
      qt_dia_w := qt_dia_w - 1;
    end if;
    
    i := i + 1;

  end loop;

  dt_entrega_w  := dt_prescricao_w + qt_dia_aux_w + (qt_hora_w/24);

  if  ((dt_entrega_w < trunc(dt_entrega_w) + ((ds_hora_inicial_w)::numeric  / 24)) or  /*  Oraci em 09/08/2008 OS97854 */
    (ie_adiciona_dia_w = 'N')) then
    dt_entrega_w := trunc(dt_entrega_w) + ((ds_hora_inicial_w)::numeric  / 24);
  end if;
  if  (dt_entrega_w > trunc(dt_entrega_w) + ((ds_hora_final_w)::numeric  / 24)) and (ie_adiciona_dia_w = 'S') then
    dt_entrega_w := trunc(dt_entrega_w) + 1 + ((ds_hora_inicial_w)::numeric  / 24);
  end if;

  if (ds_hora_fixa_w IS NOT NULL AND ds_hora_fixa_w::text <> '') then
    dt_entrega_w := trunc(dt_entrega_w) + ((ds_hora_fixa_w)::numeric  / 24);
  end if;

  while not ie_dia_ok_w loop
  
    ie_dia_ok_w := True;

    if (ie_sabado_w = 'N') and (pkg_date_utils.get_WeekDay(dt_entrega_w) = '7') then
      dt_entrega_w := dt_entrega_w + 1;
      ie_dia_ok_w := False;
    end if;

    if (ie_domingo_w = 'N') and (pkg_date_utils.get_WeekDay(dt_entrega_w) = '1') then
      dt_entrega_w := dt_entrega_w + 1;
      ie_dia_ok_w := False;
    end if;
    if (ie_feriado_w = 'N') and (obter_se_feriado(cd_estabelecimento_w, dt_entrega_w) = 1) then
      dt_entrega_w := dt_entrega_w + 1;
      ie_dia_ok_w := False;
    end if;
  end loop;

  ie_dia_ok_w := False;

  if (dt_entrega_w  > dt_entrega_prescr_w) then
    begin
    /* Ivan em 07/09/2007 OS63845 */

    if (coalesce(ds_hora_fixa_prescr_w::text, '') = '') then
      
      /*  Ivan em 26/03/2008 OS85003 - Inicio */

      ie_dia_ok_w  := False;
      dt_entrega_ww  := dt_entrega_w + ((qt_hora_prescr_w)::numeric  / 24);

      while not ie_dia_ok_w loop
        ie_dia_ok_w := True;
        if (ie_sabado_w = 'N') and (pkg_date_utils.get_WeekDay(dt_entrega_ww) = '7') then
          dt_entrega_ww := dt_entrega_ww + 1;
          ie_dia_ok_w := False;
        end if;
        if (ie_domingo_w = 'N') and (pkg_date_utils.get_WeekDay(dt_entrega_ww) = '1') then
          dt_entrega_ww := dt_entrega_ww + 1;
          ie_dia_ok_w := False;
        end if;
        if (ie_feriado_w = 'N') and (obter_se_feriado(cd_estabelecimento_w, dt_entrega_ww) = 1) then
          dt_entrega_ww := dt_entrega_ww + 1;
          ie_dia_ok_w := False;
        end if;
      end loop;

      update  prescr_medica
      set  dt_entrega  = dt_entrega_ww
      where  nr_prescricao  = nr_prescricao_p;
      /*  Ivan em 26/03/2008 OS85003 - Final */

    else
      update  prescr_medica
      set  dt_entrega  = trunc(dt_entrega_w) + ((ds_hora_fixa_prescr_w)::numeric  / 24)
      where  nr_prescricao  = nr_prescricao_p;
    end if;
    end;
  end if;

  DT_ENTREGA_P := dt_entrega_w;
end if;

END;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE obter_entrega_laudo ( NR_PRESCRICAO_P bigint, DT_PREV_EXECUCAO_P timestamp, NR_SEQ_PROC_INTERNO_P bigint, CD_PROCEDIMENTO_P bigint, IE_ORIGEM_PROCED_P bigint, CD_SETOR_ATENDIMENTO_P bigint, NM_USUARIO_P text, DT_ENTREGA_P INOUT timestamp) FROM PUBLIC;

