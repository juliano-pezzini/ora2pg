-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE copia_param_pacote_conv (cd_convenio_orig_p bigint, cd_convenio_dest_p text, nr_seq_pacote_orig_p bigint, ie_regra_proc_p text, ie_regra_mat_p text, ie_regra_tipo_acomod_p text, ie_regra_formadores_p text, ie_regra_doc_p text, nm_usuario_p text, cd_estabelecimento_p bigint, ie_regra_tipo_acomod_proc_p text default 'N') AS $body$
DECLARE


nr_seq_mat_proc_w    bigint;
ie_inclui_exclui_w    varchar(01);
ie_excedente_w      smallint;
cd_grupo_material_w    smallint;
cd_subgrupo_material_w    smallint;
cd_classe_material_w    integer;
cd_material_w      integer;
qt_limite_w      double precision;
ie_tipo_atendimento_w    smallint;
cd_setor_atendimento_w    integer;
nr_seq_pac_acomod_w    bigint;
cd_area_proced_w    bigint;
cd_especial_proced_w    bigint;
cd_grupo_proced_w    bigint;
cd_procedimento_w    bigint;
ie_origem_proced_w    bigint;
ie_considera_honorario_w  varchar(01);
ie_calcula_honorario_w    varchar(01);
ie_calcula_custo_oper_w    varchar(01);
ie_valor_w      varchar(01);
pr_desconto_w      double precision;
pr_desconto_proc_w    double precision;
pr_desconto_mat_w    double precision;
nr_seq_pacote_w      bigint;
IE_TIPO_SETOR_w      varchar(03);
QT_IDADE_MIN_w      smallint;
QT_IDADE_MAX_w      smallint;
VL_MAXIMO_w      double precision;
VL_MINIMO_w      double precision;
vl_minimo_proc_w    double precision;
vl_minimo_mat_w      double precision;
vl_maximo_proc_w    double precision;
vl_maximo_mat_w      double precision;
IE_TIPO_VALOR_w      varchar(3);
nr_seq_pac_acomod_ww    bigint;
nr_seq_w      bigint;
nr_seq_familia_w    bigint;
cd_convenio_dest_w    integer;
ie_tipo_doc_w      varchar(1);
ds_documento_w      text;
nr_seq_doc_w      bigint;
nr_seq_proc_interno_w    bigint;
nr_seq_pacote_formador_w  bigint;
ie_objetivo_w      varchar(1);
ie_considera_generico_w    varchar(1);
pr_orcamento_w      double precision;
ie_sexo_w      varchar(1);
ie_ratear_item_w    varchar(1);
pr_desc_w      double precision;
vl_negociado_w      double precision;
ie_agendavel_w      varchar(1);
ie_lado_w      varchar(1);
ie_setor_lanc_exclusivo_w  varchar(1);
qt_procedimento_w    double precision;
cd_centro_custo_w    integer;
qt_minimo_w      bigint;
nr_seq_classif_w    bigint;
nr_seq_estrutura_w    bigint;
cd_local_estoque_w    pacote_material.cd_local_estoque%type;
ie_valida_limite_proc_w    pacote_procedimento.ie_valida_limite_proc%type;
nr_seq_estrutura_proc_w    pacote_procedimento.nr_seq_estrutura%type;

c000 CURSOR FOR
  SELECT  cd_convenio
  from  convenio
  where  obter_se_contido(cd_convenio, elimina_aspas_conv(cd_convenio_dest_p)) = 'S'
  order by cd_convenio;

c001 CURSOR FOR
  SELECT  ie_inclui_exclui,
    ie_excedente,
    cd_grupo_material,
    cd_subgrupo_material,
    cd_classe_material,
    cd_material,
    qt_limite,
    ie_tipo_atendimento,
    cd_setor_atendimento,
    nr_seq_pac_acomod,
    ie_valor,
    vl_minimo,
    vl_maximo,
    pr_desconto,
    IE_TIPO_SETOR,
    qt_idade_min,
    qt_idade_max,
    ie_objetivo,
    ie_considera_generico,
    pr_orcamento,
    nr_seq_familia,
    ie_sexo,
    cd_centro_custo,
    ie_ratear_item,
    vl_negociado,
    nr_seq_estrutura,
    cd_local_estoque
  from  pacote_material
  where   nr_seq_pacote  = nr_seq_pacote_orig_p;

c002 CURSOR FOR
  SELECT  ie_inclui_exclui,
    ie_excedente,
    cd_area_proced,
    cd_especial_proced,
    cd_grupo_proced,
    cd_procedimento,
    ie_origem_proced,
    qt_limite,
    ie_considera_honorario,
    cd_setor_atendimento,
    ie_tipo_atendimento,
    ie_calcula_honorario,
    ie_calcula_custo_oper,
    nr_seq_pac_acomod,
    pr_desconto,
    QT_IDADE_MIN,
    QT_IDADE_MAX,
    VL_MAXIMO,
    VL_MINIMO,
    IE_TIPO_VALOR,
    nr_seq_proc_interno,
    ie_ratear_item,
    pr_desc,
    vl_negociado,
    ie_agendavel,
    ie_sexo,
    cd_centro_custo,
    nr_seq_classif,
    ie_valida_limite_proc,
    nr_seq_estrutura
  from   pacote_procedimento
  where   nr_seq_pacote  = nr_seq_pacote_orig_p
  group by  ie_inclui_exclui,
      ie_excedente,
      cd_area_proced,
      cd_especial_proced,
      cd_grupo_proced,
      cd_procedimento,
      ie_origem_proced,
      qt_limite,
      ie_considera_honorario,
      cd_setor_atendimento,
      ie_tipo_atendimento,
      ie_calcula_honorario,
      ie_calcula_custo_oper,
      nr_seq_pac_acomod,
      pr_desconto,
      QT_IDADE_MIN,
      QT_IDADE_MAX,
      VL_MAXIMO,
      VL_MINIMO,
      IE_TIPO_VALOR,
      nr_seq_proc_interno,
      ie_ratear_item,
      pr_desc,
      vl_negociado,
      ie_agendavel,
      ie_sexo,
      cd_centro_custo,
      nr_seq_classif,
      ie_valida_limite_proc,
      nr_seq_estrutura;

c003 CURSOR FOR
  SELECT  ie_tipo_acomod,
    qt_dias_pacote,
    qt_dias_hospital,
    qt_dias_uti,
    ie_excedente,
    cd_procedimento,
    ie_origem_proced,
    vl_pacote,
    vl_honorario,
    qt_ponto_pacote,
    qt_ponto_honorario,
    cd_estrutura_conta,
    ie_classificacao,
    dt_vigencia,
    ie_exige_gabarito,
    ie_regra_hora_inicio,
    ie_regra_hora_fim,
    ie_situacao,
    qt_idade_min,
    qt_idade_max,
    ie_ratear_repasse,
    dt_vigencia_final,
    ie_tipo_atendimento,
    qt_dias_inter_inicio,
    qt_dias_inter_final,
    ie_gerar_proced_negativo,
    vl_anestesista,
    ie_atend_retorno,
    ie_tipo_anestesia,
    hr_final_pacote,
    pr_faturar_pacote,
    ie_atend_acomp,
    cd_setor_atendimento,
    nr_seq_proc_interno,
    cd_medico_executor,
    --cd_plano,
    ie_clinica,
    nr_sequencia,
    vl_materiais,
    ie_consiste_cirurgia,
    ie_exige_item_conta,
    vl_auxiliares,
    ds_observacao,
    ie_sexo,
    pr_acrescimo_rn,
    ie_lado,
    ie_setor_lanc_exclusivo,
    qt_procedimento,
    ie_tipo_atend_conta,
    cd_centro_custo,
    ie_credenciado,
    qt_hora,
    ie_carater_inter_sus
  from   pacote_tipo_acomodacao
  where   nr_seq_pacote  = nr_seq_pacote_orig_p;

c004 CURSOR FOR
  SELECT  ie_inclui_exclui,
    ie_excedente,
    cd_grupo_material,
    cd_subgrupo_material,
    cd_classe_material,
    cd_material,
    qt_limite,
    ie_tipo_atendimento,
    cd_setor_atendimento,
    nr_seq_pac_acomod,
    ie_valor,
    vl_minimo,
    vl_maximo,
    pr_desconto,
    IE_TIPO_SETOR,
    qt_idade_min,
    qt_idade_max,
    ie_objetivo,
    ie_considera_generico,
    pr_orcamento,
    nr_seq_familia,
    ie_sexo,
    cd_centro_custo,
    nr_seq_estrutura,
    cd_local_estoque
  from  pacote_material
  where   nr_seq_pacote  = nr_seq_pacote_orig_p
  and   nr_seq_pac_acomod = nr_seq_w
  and   ie_regra_mat_p = 'S';

c005 CURSOR FOR
  SELECT  ie_inclui_exclui,
    ie_excedente,
    cd_grupo_material,
    cd_subgrupo_material,
    cd_classe_material,
    cd_material,
    qt_limite,
    ie_tipo_atendimento,
    cd_setor_atendimento,
    nr_seq_pac_acomod,
    ie_valor,
    vl_minimo,
    vl_maximo,
    pr_desconto,
    IE_TIPO_SETOR,
    qt_idade_min,
    qt_idade_max,
    ie_objetivo,
    ie_considera_generico,
    pr_orcamento,
    nr_seq_familia,
    ie_sexo,
    cd_centro_custo,
    nr_seq_estrutura,
    cd_local_estoque
  from  pacote_material
  where   nr_seq_pacote  = nr_seq_pacote_orig_p
  and   coalesce(nr_seq_pac_acomod::text, '') = ''
  and   ie_regra_mat_p = 'S';

c006 CURSOR FOR
  SELECT  ie_inclui_exclui,
    ie_excedente,
    cd_area_proced,
    cd_especial_proced,
    cd_grupo_proced,
    cd_procedimento,
    ie_origem_proced,
    qt_limite,
    ie_considera_honorario,
    cd_setor_atendimento,
    ie_tipo_atendimento,
    ie_calcula_honorario,
    ie_calcula_custo_oper,
    nr_seq_pac_acomod,
    pr_desconto,
    QT_IDADE_MIN,
    QT_IDADE_MAX,
    VL_MAXIMO,
    VL_MINIMO,
    IE_TIPO_VALOR,
    nr_seq_proc_interno,
    ie_ratear_item,
    pr_desc,
    vl_negociado,
    ie_agendavel,
    ie_sexo,
    cd_centro_custo,
    nr_seq_classif,
    ie_valida_limite_proc,
    nr_seq_estrutura
  from   pacote_procedimento
  where   nr_seq_pacote  = nr_seq_pacote_orig_p
  and   ie_regra_proc_p = 'S'
  and   nr_seq_pac_acomod = nr_seq_w
  group by ie_inclui_exclui,
    ie_excedente,
    cd_area_proced,
    cd_especial_proced,
    cd_grupo_proced,
    cd_procedimento,
    ie_origem_proced,
    qt_limite,
    ie_considera_honorario,
    cd_setor_atendimento,
    ie_tipo_atendimento,
    ie_calcula_honorario,
    ie_calcula_custo_oper,
    nr_seq_pac_acomod,
    pr_desconto,
    QT_IDADE_MIN,
    QT_IDADE_MAX,
    VL_MAXIMO,
    VL_MINIMO,
    IE_TIPO_VALOR,
    nr_seq_proc_interno,
    ie_ratear_item,
    pr_desc,
    vl_negociado,
    ie_agendavel,
    ie_sexo,
    cd_centro_custo,
    nr_seq_classif,
    ie_valida_limite_proc,
    nr_seq_estrutura;

c007 CURSOR FOR
  SELECT  ie_inclui_exclui,
    ie_excedente,
    cd_area_proced,
    cd_especial_proced,
    cd_grupo_proced,
    cd_procedimento,
    ie_origem_proced,
    qt_limite,
    ie_considera_honorario,
    cd_setor_atendimento,
    ie_tipo_atendimento,
    ie_calcula_honorario,
    ie_calcula_custo_oper,
    nr_seq_pac_acomod,
    pr_desconto,
    QT_IDADE_MIN,
    QT_IDADE_MAX,
    VL_MAXIMO,
    VL_MINIMO,
    IE_TIPO_VALOR,
    nr_seq_proc_interno,
    ie_ratear_item,
    pr_desc,
    vl_negociado,
    ie_agendavel,
    ie_sexo,
    cd_centro_custo,
    nr_seq_classif,
    ie_valida_limite_proc,
    nr_seq_estrutura
  from   pacote_procedimento
  where   nr_seq_pacote  = nr_seq_pacote_orig_p
  and   ie_regra_proc_p = 'S'
  and   coalesce(nr_seq_pac_acomod::text, '') = ''
  group by ie_inclui_exclui,
    ie_excedente,
    cd_area_proced,
    cd_especial_proced,
    cd_grupo_proced,
    cd_procedimento,
    ie_origem_proced,
    qt_limite,
    ie_considera_honorario,
    cd_setor_atendimento,
    ie_tipo_atendimento,
    ie_calcula_honorario,
    ie_calcula_custo_oper,
    nr_seq_pac_acomod,
    pr_desconto,
    QT_IDADE_MIN,
    QT_IDADE_MAX,
    VL_MAXIMO,
    VL_MINIMO,
    IE_TIPO_VALOR,
    nr_seq_proc_interno,
    ie_ratear_item,
    pr_desc,
    vl_negociado,
    ie_agendavel,
    ie_sexo,
    cd_centro_custo,
    nr_seq_classif,
    ie_valida_limite_proc,
    nr_seq_estrutura;

c008 CURSOR FOR
  SELECT  ds_documento,
    ie_tipo_doc
  from  pacote_doc
  where  nr_seq_pacote = nr_seq_pacote_orig_p;

c009 CURSOR FOR
  SELECT  cd_procedimento,
    ie_origem_proced,
    nr_seq_proc_interno,
    qt_minimo
  from  pacote_formadores
  where  nr_seq_pacote = nr_seq_pacote_orig_p
  order by cd_procedimento;

c003_w  c003%rowtype;


BEGIN

open c000;
loop
fetch c000 into
  cd_convenio_dest_w;
EXIT WHEN NOT FOUND; /* apply on c000 */
  begin
  select  nextval('pacote_seq')
  into STRICT  nr_seq_pacote_w
;

  insert  into pacote(nr_seq_pacote,
    cd_convenio,
    cd_proced_pacote,
    cd_proced_pacote_loc,
    ie_origem_proced,
    ie_situacao,
    dt_atualizacao,
    nm_usuario,
    ds_observacao,
    cd_estabelecimento,
    dt_atualizacao_nrec,
    nm_usuario_nrec)
  (SELECT nr_seq_pacote_w,
    cd_convenio_dest_w,
    cd_proced_pacote,
    cd_proced_pacote_loc,
    ie_origem_proced,
    ie_situacao,
    clock_timestamp(),
    nm_usuario_p,
    ds_observacao,
    cd_estabelecimento,
    dt_atualizacao_nrec,
    nm_usuario_nrec
  from  pacote
  where  nr_seq_pacote  = nr_seq_pacote_orig_p);

  if (ie_regra_tipo_acomod_p = 'S') then

    open c003;
      loop
      fetch c003 into c003_w;
        EXIT WHEN NOT FOUND; /* apply on c003 */

        select nextval('pacote_tipo_acomodacao_seq')
        into STRICT nr_seq_pac_acomod_ww
;

        insert into pacote_tipo_acomodacao(nr_seq_pacote,
          ie_tipo_acomod,
          dt_atualizacao,
          nm_usuario,
          qt_dias_pacote,
          qt_dias_hospital,
          qt_dias_uti,
          ie_excedente,
          cd_procedimento,
          ie_origem_proced,
          vl_pacote,
          vl_honorario,
          qt_ponto_pacote,
          qt_ponto_honorario,
          cd_estrutura_conta,
          ie_classificacao,
          nr_sequencia,
          dt_vigencia,
          ie_exige_gabarito,
          ie_regra_hora_inicio,
          ie_regra_hora_fim,
          ie_situacao,
          qt_idade_min,
          qt_idade_max,
          ie_ratear_repasse,
          dt_vigencia_final,
          ie_tipo_atendimento,
          qt_dias_inter_inicio,
          qt_dias_inter_final,
          ie_gerar_proced_negativo,
          vl_anestesista,
          ie_atend_retorno,
          ie_tipo_anestesia,
          hr_final_pacote,
          pr_faturar_pacote,
          ie_atend_acomp,
          cd_setor_atendimento,
          nr_seq_proc_interno,
          cd_medico_executor,
          --cd_plano,
          ie_clinica,
          vl_materiais,
          ie_consiste_cirurgia,
          ie_exige_item_conta,
          vl_auxiliares,
          ds_observacao,
          ie_sexo,
          pr_acrescimo_rn,
          ie_lado,
          ie_setor_lanc_exclusivo,
          qt_procedimento,
          ie_tipo_atend_conta,
          cd_centro_custo,
          ie_credenciado,
          qt_hora,
          ie_carater_inter_sus)
        values (nr_seq_pacote_w,
          c003_w.ie_tipo_acomod,
          clock_timestamp(),
          nm_usuario_p,
          c003_w.qt_dias_pacote,
          c003_w.qt_dias_hospital,
          c003_w.qt_dias_uti,
          c003_w.ie_excedente,
          c003_w.cd_procedimento,
          c003_w.ie_origem_proced,
          c003_w.vl_pacote,
          c003_w.vl_honorario,
          c003_w.qt_ponto_pacote,
          c003_w.qt_ponto_honorario,
          c003_w.cd_estrutura_conta,
          c003_w.ie_classificacao,
          nr_seq_pac_acomod_ww,
          c003_w.dt_vigencia,
          c003_w.ie_exige_gabarito,
          c003_w.ie_regra_hora_inicio,
          c003_w.ie_regra_hora_fim,
          c003_w.ie_situacao,
          c003_w.qt_idade_min,
          c003_w.qt_idade_max,
          c003_w.ie_ratear_repasse,
          c003_w.dt_vigencia_final,
          c003_w.ie_tipo_atendimento,
          c003_w.qt_dias_inter_inicio,
          c003_w.qt_dias_inter_final,
          c003_w.ie_gerar_proced_negativo,
          c003_w.vl_anestesista,
          c003_w.ie_atend_retorno,
          c003_w.ie_tipo_anestesia,
          c003_w.hr_final_pacote,
          c003_w.pr_faturar_pacote,
          c003_w.ie_atend_acomp,
          c003_w.cd_setor_atendimento,
          c003_w.nr_seq_proc_interno,
          c003_w.cd_medico_executor,
          --c003_w.cd_plano,
          c003_w.ie_clinica,
          c003_w.vl_materiais,
          c003_w.ie_consiste_cirurgia,
          c003_w.ie_exige_item_conta,
          c003_w.vl_auxiliares,
          c003_w.ds_observacao,
          c003_w.ie_sexo,
          c003_w.pr_acrescimo_rn,
          c003_w.ie_lado,
          c003_w.ie_setor_lanc_exclusivo,
          c003_w.qt_procedimento,
          c003_w.ie_tipo_atend_conta,
          c003_w.cd_centro_custo,
          c003_w.ie_credenciado,
          c003_w.qt_hora,
          c003_w.ie_carater_inter_sus);

        nr_seq_w:= c003_w.nr_sequencia;

        if (ie_regra_tipo_acomod_proc_p = 'S') then
          insert  into pacote_tipo_acomod_proc(nr_sequencia,
            dt_atualizacao,
            nm_usuario,
            nr_seq_pac_acomod,
            cd_procedimento,
            cd_procedimento_loc,
            ie_origem_proced,
            dt_atualizacao_nrec,
            nm_usuario_nrec)
           (   SELECT  nextval('pacote_tipo_acomod_proc_seq'),
                clock_timestamp(),
                nm_usuario_p,
                nr_seq_pac_acomod_ww,
                cd_procedimento,
                cd_procedimento_loc,
                ie_origem_proced,
                clock_timestamp(),
                nm_usuario_p
            from  pacote_tipo_acomod_proc
            where    nr_seq_pac_acomod = nr_seq_w
          );
        end if;

        open c004;
        loop
          fetch  c004 into
            ie_inclui_exclui_w,
            ie_excedente_w,
            cd_grupo_material_w,
            cd_subgrupo_material_w,
            cd_classe_material_w,
            cd_material_w,
            qt_limite_w,
            ie_tipo_atendimento_w,
            cd_setor_atendimento_w,
            nr_seq_pac_acomod_w,
            ie_valor_w,
            vl_minimo_mat_w,
            vl_maximo_mat_w,
            pr_desconto_mat_w,
            IE_TIPO_SETOR_w,
            qt_idade_min_w,
            qt_idade_max_w,
            ie_objetivo_w,
            ie_considera_generico_w,
            pr_orcamento_w,
            nr_seq_familia_w,
            ie_sexo_w,
            cd_centro_custo_w,
            nr_seq_estrutura_w,
            cd_local_estoque_w;
          EXIT WHEN NOT FOUND; /* apply on c004 */
          begin

          select  nextval('pacote_material_seq')
          into STRICT  nr_seq_mat_proc_w
;

          insert   into pacote_material(nr_seq_pacote,
            nr_sequencia,
            ie_inclui_exclui,
            dt_atualizacao,
            nm_usuario,
            ie_excedente,
            cd_grupo_material,
            cd_subgrupo_material,
            cd_classe_material,
            cd_material,
            qt_limite,
            ie_tipo_atendimento,
            cd_setor_atendimento,
            nr_seq_pac_acomod,
            ie_valor,
            vl_minimo,
            vl_maximo,
            pr_desconto,
            IE_TIPO_SETOR,
            qt_idade_min,
            qt_idade_max,
            ie_objetivo,
            ie_considera_generico,
            pr_orcamento,
            nr_seq_familia,
            ie_sexo,
            cd_centro_custo,
            nr_seq_estrutura,
            cd_local_estoque)
          values (  nr_seq_pacote_w,
            nr_seq_mat_proc_w,
            ie_inclui_exclui_w,
            clock_timestamp(),
            nm_usuario_p,
            ie_excedente_w,
            cd_grupo_material_w,
            cd_subgrupo_material_w,
            cd_classe_material_w,
            cd_material_w,
            qt_limite_w,
            ie_tipo_atendimento_w,
            cd_setor_atendimento_w,
            nr_seq_pac_acomod_ww,
            ie_valor_w,
            vl_minimo_mat_w,
            vl_maximo_mat_w,
            pr_desconto_mat_w,
            IE_TIPO_SETOR_w,
            qt_idade_min_w,
            qt_idade_max_w,
            ie_objetivo_w,
            ie_considera_generico_w,
            pr_orcamento_w,
            nr_seq_familia_w,
            ie_sexo_w,
            cd_centro_custo_w,
            nr_seq_estrutura_w,
            cd_local_estoque_w);
          end;
        end loop;
        close c004;

        open c006;
        loop
          fetch  c006 into
            ie_inclui_exclui_w,
            ie_excedente_w,
            cd_area_proced_w,
            cd_especial_proced_w,
            cd_grupo_proced_w,
            cd_procedimento_w,
            ie_origem_proced_w,
            qt_limite_w,
            ie_considera_honorario_w,
            cd_setor_atendimento_w,
            ie_tipo_atendimento_w,
            ie_calcula_honorario_w,
            ie_calcula_custo_oper_w,
            nr_seq_pac_acomod_w,
            pr_desconto_proc_w,
            QT_IDADE_MIN_w,
            QT_IDADE_MAX_w,
            vl_maximo_proc_w,
            vl_minimo_proc_w,
            IE_TIPO_VALOR_w,
            nr_seq_proc_interno_w,
            ie_ratear_item_w,
            pr_desc_w,
            vl_negociado_w,
            ie_agendavel_w,
            ie_sexo_w,
            cd_centro_custo_w,
            nr_seq_classif_w,
            ie_valida_limite_proc_w,
            nr_seq_estrutura_proc_w;
          EXIT WHEN NOT FOUND; /* apply on c006 */
          begin

          select  nextval('pacote_procedimento_seq')
          into STRICT  nr_seq_mat_proc_w
;

          insert   into pacote_procedimento(nr_seq_pacote,
            nr_sequencia,
            ie_inclui_exclui,
            dt_atualizacao,
            nm_usuario,
            ie_excedente,
            cd_area_proced,
            cd_especial_proced,
            cd_grupo_proced,
            cd_procedimento,
            ie_origem_proced,
            qt_limite,
            ie_considera_honorario,
            cd_setor_atendimento,
            ie_tipo_atendimento,
            ie_calcula_honorario,
            ie_calcula_custo_oper,
            nr_seq_pac_acomod,
            pr_desconto,
            QT_IDADE_MIN,
            QT_IDADE_MAX,
            VL_MAXIMO,
            VL_MINIMO,
            IE_TIPO_VALOR,
            nr_seq_proc_interno,
            ie_ratear_item,
            pr_desc,
            vl_negociado,
            ie_agendavel,
            ie_sexo,
            cd_centro_custo,
            nr_seq_classif,
            ie_valida_limite_proc,
            nr_seq_estrutura)
          values (  nr_seq_pacote_w,
            nr_seq_mat_proc_w,
            ie_inclui_exclui_w,
            clock_timestamp(),
            nm_usuario_p,
            ie_excedente_w,
            cd_area_proced_w,
            cd_especial_proced_w,
            cd_grupo_proced_w,
            cd_procedimento_w,
            ie_origem_proced_w,
            qt_limite_w,
            ie_considera_honorario_w,
            cd_setor_atendimento_w,
            ie_tipo_atendimento_w,
            ie_calcula_honorario_w,
            ie_calcula_custo_oper_w,
            nr_seq_pac_acomod_ww,
            pr_desconto_proc_w,
            QT_IDADE_MIN_w,
            QT_IDADE_MAX_w,
            vl_maximo_proc_w,
            vl_minimo_proc_w,
            IE_TIPO_VALOR_w,
            nr_seq_proc_interno_w,
            ie_ratear_item_w,
            pr_desc_w,
            vl_negociado_w,
            ie_agendavel_w,
            ie_sexo_w,
            cd_centro_custo_w,
            nr_seq_classif_w,
            ie_valida_limite_proc_w,
            nr_seq_estrutura_proc_w);
          end;
          end loop;
        close c006;

      end loop;
    close c003;

    --Regras de mat e proc que nao tinham o campo Tipo acomodacao Preenchidos
    open c005;
    loop
      fetch  c005 into
        ie_inclui_exclui_w,
        ie_excedente_w,
        cd_grupo_material_w,
        cd_subgrupo_material_w,
        cd_classe_material_w,
        cd_material_w,
        qt_limite_w,
        ie_tipo_atendimento_w,
        cd_setor_atendimento_w,
        nr_seq_pac_acomod_w,
        ie_valor_w,
        vl_minimo_mat_w,
        vl_maximo_mat_w,
        pr_desconto_mat_w,
        IE_TIPO_SETOR_w,
        qt_idade_min_w,
        qt_idade_max_w,
        ie_objetivo_w,
        ie_considera_generico_w,
        pr_orcamento_w,
        nr_seq_familia_w,
        ie_sexo_w,
        cd_centro_custo_w,
        nr_seq_estrutura_w,
        cd_local_estoque_w;
      EXIT WHEN NOT FOUND; /* apply on c005 */
        begin

        select  nextval('pacote_material_seq')
        into STRICT  nr_seq_mat_proc_w
;

        insert   into pacote_material(nr_seq_pacote,
          nr_sequencia,
          ie_inclui_exclui,
          dt_atualizacao,
          nm_usuario,
          ie_excedente,
          cd_grupo_material,
          cd_subgrupo_material,
          cd_classe_material,
          cd_material,
          qt_limite,
          ie_tipo_atendimento,
          cd_setor_atendimento,
          nr_seq_pac_acomod,
          ie_valor,
          vl_minimo,
          vl_maximo,
          pr_desconto,
          IE_TIPO_SETOR,
          qt_idade_min,
          qt_idade_max,
          ie_objetivo,
          ie_considera_generico,
          pr_orcamento,
          nr_seq_familia,
          ie_sexo,
          cd_centro_custo,
          nr_seq_estrutura,
          cd_local_estoque)
        values (  nr_seq_pacote_w,
          nr_seq_mat_proc_w,
          ie_inclui_exclui_w,
          clock_timestamp(),
          nm_usuario_p,
          ie_excedente_w,
          cd_grupo_material_w,
          cd_subgrupo_material_w,
          cd_classe_material_w,
          cd_material_w,
          qt_limite_w,
          ie_tipo_atendimento_w,
          cd_setor_atendimento_w,
          null,
          ie_valor_w,
          vl_minimo_mat_w,
          vl_maximo_mat_w,
          pr_desconto_mat_w,
          IE_TIPO_SETOR_w,
          qt_idade_min_w,
          qt_idade_max_w,
          ie_objetivo_w,
          ie_considera_generico_w,
          pr_orcamento_w,
          nr_seq_familia_w,
          ie_sexo_w,
          cd_centro_custo_w,
          nr_seq_estrutura_w,
          cd_local_estoque_w);
        end;
      end loop;
    close c005;

    open c007;
    loop
      fetch  c007 into
        ie_inclui_exclui_w,
        ie_excedente_w,
        cd_area_proced_w,
        cd_especial_proced_w,
        cd_grupo_proced_w,
        cd_procedimento_w,
        ie_origem_proced_w,
        qt_limite_w,
        ie_considera_honorario_w,
        cd_setor_atendimento_w,
        ie_tipo_atendimento_w,
        ie_calcula_honorario_w,
        ie_calcula_custo_oper_w,
        nr_seq_pac_acomod_w,
        pr_desconto_proc_w,
        QT_IDADE_MIN_w,
        QT_IDADE_MAX_w,
        vl_maximo_proc_w,
        vl_minimo_proc_w,
        IE_TIPO_VALOR_w,
        nr_seq_proc_interno_w,
        ie_ratear_item_w,
        pr_desc_w,
        vl_negociado_w,
        ie_agendavel_w,
        ie_sexo_w,
        cd_centro_custo_w,
        nr_seq_classif_w,
        ie_valida_limite_proc_w,
        nr_seq_estrutura_proc_w;
      EXIT WHEN NOT FOUND; /* apply on c007 */
        begin

        select  nextval('pacote_procedimento_seq')
        into STRICT  nr_seq_mat_proc_w
;

        insert   into pacote_procedimento(nr_seq_pacote,
          nr_sequencia,
          ie_inclui_exclui,
          dt_atualizacao,
          nm_usuario,
          ie_excedente,
          cd_area_proced,
          cd_especial_proced,
          cd_grupo_proced,
          cd_procedimento,
          ie_origem_proced,
          qt_limite,
          ie_considera_honorario,
          cd_setor_atendimento,
          ie_tipo_atendimento,
          ie_calcula_honorario,
          ie_calcula_custo_oper,
          nr_seq_pac_acomod,
          pr_desconto,
          QT_IDADE_MIN,
          QT_IDADE_MAX,
          VL_MAXIMO,
          VL_MINIMO,
          IE_TIPO_VALOR,
          nr_seq_proc_interno,
          ie_ratear_item,
          pr_desc,
          vl_negociado,
          ie_agendavel,
          ie_sexo,
          cd_centro_custo,
          nr_seq_classif,
          ie_valida_limite_proc,
          nr_seq_estrutura)
        values (  nr_seq_pacote_w,
          nr_seq_mat_proc_w,
          ie_inclui_exclui_w,
          clock_timestamp(),
          nm_usuario_p,
          ie_excedente_w,
          cd_area_proced_w,
          cd_especial_proced_w,
          cd_grupo_proced_w,
          cd_procedimento_w,
          ie_origem_proced_w,
          qt_limite_w,
          ie_considera_honorario_w,
          cd_setor_atendimento_w,
          ie_tipo_atendimento_w,
          ie_calcula_honorario_w,
          ie_calcula_custo_oper_w,
          null,
          pr_desconto_proc_w,
          QT_IDADE_MIN_w,
          QT_IDADE_MAX_w,
          vl_maximo_proc_w,
          vl_minimo_proc_w,
          IE_TIPO_VALOR_w,
          nr_seq_proc_interno_w,
          ie_ratear_item_w,
          pr_desc_w,
          vl_negociado_w,
          ie_agendavel_w,
          ie_sexo_w,
          cd_centro_custo_w,
          nr_seq_classif_w,
          ie_valida_limite_proc_w,
          nr_seq_estrutura_proc_w);
        end;
      end loop;
    close c007;

  end if;



  if (ie_regra_mat_p = 'S') and (ie_regra_tipo_acomod_p = 'N') then

    open c001;
      loop
        fetch  c001 into
          ie_inclui_exclui_w,
          ie_excedente_w,
          cd_grupo_material_w,
          cd_subgrupo_material_w,
          cd_classe_material_w,
          cd_material_w,
          qt_limite_w,
          ie_tipo_atendimento_w,
          cd_setor_atendimento_w,
          nr_seq_pac_acomod_w,
          ie_valor_w,
          vl_minimo_mat_w,
          vl_maximo_mat_w,
          pr_desconto_mat_w,
          IE_TIPO_SETOR_w,
          qt_idade_min_w,
          qt_idade_max_w,
          ie_objetivo_w,
          ie_considera_generico_w,
          pr_orcamento_w,
          nr_seq_familia_w,
          ie_sexo_w,
          cd_centro_custo_w,
          ie_ratear_item_w,
          vl_negociado_w,
          nr_seq_estrutura_w,
          cd_local_estoque_w;
        EXIT WHEN NOT FOUND; /* apply on c001 */
        begin
        select  nextval('pacote_material_seq')
        into STRICT  nr_seq_mat_proc_w
;

        insert   into pacote_material(nr_seq_pacote,
          nr_sequencia,
          ie_inclui_exclui,
          dt_atualizacao,
          nm_usuario,
          ie_excedente,
          cd_grupo_material,
          cd_subgrupo_material,
          cd_classe_material,
          cd_material,
          qt_limite,
          ie_tipo_atendimento,
          cd_setor_atendimento,
          nr_seq_pac_acomod,
          ie_valor,
          vl_minimo,
          vl_maximo,
          pr_desconto,
          IE_TIPO_SETOR,
          qt_idade_min,
          qt_idade_max,
          ie_objetivo,
          ie_considera_generico,
          pr_orcamento,
          nr_seq_familia,
          ie_sexo,
          cd_centro_custo,
          ie_ratear_item,
          vl_negociado,
          nr_seq_estrutura,
          cd_local_estoque)
        values (  nr_seq_pacote_w,
          nr_seq_mat_proc_w,
          ie_inclui_exclui_w,
          clock_timestamp(),
          nm_usuario_p,
          ie_excedente_w,
          cd_grupo_material_w,
          cd_subgrupo_material_w,
          cd_classe_material_w,
          cd_material_w,
          qt_limite_w,
          ie_tipo_atendimento_w,
          cd_setor_atendimento_w,
          nr_seq_pac_acomod_w,
          ie_valor_w,
          vl_minimo_mat_w,
          vl_maximo_mat_w,
          pr_desconto_mat_w,
          IE_TIPO_SETOR_w,
          qt_idade_min_w,
          qt_idade_max_w,
          ie_objetivo_w,
          ie_considera_generico_w,
          pr_orcamento_w,
          nr_seq_familia_w,
          ie_sexo_w,
          cd_centro_custo_w,
          ie_ratear_item_w,
          vl_negociado_w,
          nr_seq_estrutura_w,
          cd_local_estoque_w);
        end;
      end loop;
    close c001;
  end if;

  if (ie_regra_proc_p = 'S') and (ie_regra_tipo_acomod_p = 'N') then

    open c002;
      loop
        fetch  c002 into
          ie_inclui_exclui_w,
          ie_excedente_w,
          cd_area_proced_w,
          cd_especial_proced_w,
          cd_grupo_proced_w,
          cd_procedimento_w,
          ie_origem_proced_w,
          qt_limite_w,
          ie_considera_honorario_w,
          cd_setor_atendimento_w,
          ie_tipo_atendimento_w,
          ie_calcula_honorario_w,
          ie_calcula_custo_oper_w,
          nr_seq_pac_acomod_w,
          pr_desconto_proc_w,
          QT_IDADE_MIN_w,
          QT_IDADE_MAX_w,
          vl_maximo_proc_w,
          vl_minimo_proc_w,
          IE_TIPO_VALOR_w,
          nr_seq_proc_interno_w,
          ie_ratear_item_w,
          pr_desc_w,
          vl_negociado_w,
          ie_agendavel_w,
          ie_sexo_w,
          cd_centro_custo_w,
          nr_seq_classif_w,
          ie_valida_limite_proc_w,
          nr_seq_estrutura_proc_w;
        EXIT WHEN NOT FOUND; /* apply on c002 */
        begin

        select  nextval('pacote_procedimento_seq')
        into STRICT  nr_seq_mat_proc_w
;

        insert   into pacote_procedimento(nr_seq_pacote,
          nr_sequencia,
          ie_inclui_exclui,
          dt_atualizacao,
          nm_usuario,
          ie_excedente,
          cd_area_proced,
          cd_especial_proced,
          cd_grupo_proced,
          cd_procedimento,
          ie_origem_proced,
          qt_limite,
          ie_considera_honorario,
          cd_setor_atendimento,
          ie_tipo_atendimento,
          ie_calcula_honorario,
          ie_calcula_custo_oper,
          nr_seq_pac_acomod,
          pr_desconto,
          QT_IDADE_MIN,
          QT_IDADE_MAX,
          VL_MAXIMO,
          VL_MINIMO,
          IE_TIPO_VALOR,
          nr_seq_proc_interno,
          ie_ratear_item,
          pr_desc,
          vl_negociado,
          ie_agendavel,
          ie_sexo,
          cd_centro_custo,
          nr_seq_classif,
          ie_valida_limite_proc,
          nr_seq_estrutura)
        values (  nr_seq_pacote_w,
          nr_seq_mat_proc_w,
          ie_inclui_exclui_w,
          clock_timestamp(),
          nm_usuario_p,
          ie_excedente_w,
          cd_area_proced_w,
          cd_especial_proced_w,
          cd_grupo_proced_w,
          cd_procedimento_w,
          ie_origem_proced_w,
          qt_limite_w,
          ie_considera_honorario_w,
          cd_setor_atendimento_w,
          ie_tipo_atendimento_w,
          ie_calcula_honorario_w,
          ie_calcula_custo_oper_w,
          nr_seq_pac_acomod_w,
          pr_desconto_proc_w,
          QT_IDADE_MIN_w,
          QT_IDADE_MAX_w,
          vl_maximo_proc_w,
          vl_minimo_proc_w,
          IE_TIPO_VALOR_w,
          nr_seq_proc_interno_w,
          ie_ratear_item_w,
          pr_desc_w,
          vl_negociado_w,
          ie_agendavel_w,
          ie_sexo_w,
          cd_centro_custo_w,
          nr_seq_classif_w,
          ie_valida_limite_proc_w,
          nr_seq_estrutura_proc_w);
        end;
      end loop;
    close c002;
  end if;

  if (ie_regra_doc_p = 'S') then
    open c008;
    loop
    fetch c008 into
      ds_documento_w,
      ie_tipo_doc_w;
    EXIT WHEN NOT FOUND; /* apply on c008 */
      begin
      select  nextval('pacote_doc_seq')
      into STRICT  nr_seq_doc_w
;

      insert   into pacote_doc(nr_seq_pacote,
        nr_sequencia,
        dt_atualizacao,
        nm_usuario,
        ds_documento,
        ie_tipo_doc,
        dt_atualizacao_nrec,
        nm_usuario_nrec)
      values (  nr_seq_pacote_w,
        nr_seq_doc_w,
        clock_timestamp(),
        nm_usuario_p,
        ds_documento_w,
        ie_tipo_doc_w,
        clock_timestamp(),
        nm_usuario_p);
      end;
    end loop;
    close c008;
  end if;

  if (ie_regra_formadores_p = 'S') then
    open c009;
    loop
    fetch c009 into
      cd_procedimento_w,
      ie_origem_proced_w,
      nr_seq_proc_interno_w,
      qt_minimo_w;
    EXIT WHEN NOT FOUND; /* apply on c009 */
      begin
      select  nextval('pacote_formadores_seq')
      into STRICT  nr_seq_pacote_formador_w
;

      insert   into pacote_formadores(nr_seq_pacote,
        nr_sequencia,
        dt_atualizacao,
        nm_usuario,
        cd_procedimento,
        ie_origem_proced,
        nr_seq_proc_interno,
        dt_atualizacao_nrec,
        nm_usuario_nrec,
        qt_minimo)
      values (  nr_seq_pacote_w,
        nr_seq_pacote_formador_w,
        clock_timestamp(),
        nm_usuario_p,
        cd_procedimento_w,
        ie_origem_proced_w,
        nr_seq_proc_interno_w,
        clock_timestamp(),
        nm_usuario_p,
        qt_minimo_w);
      end;
    end loop;
    close c009;
  end if;

  end;
end loop;
close c000;

commit;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE copia_param_pacote_conv (cd_convenio_orig_p bigint, cd_convenio_dest_p text, nr_seq_pacote_orig_p bigint, ie_regra_proc_p text, ie_regra_mat_p text, ie_regra_tipo_acomod_p text, ie_regra_formadores_p text, ie_regra_doc_p text, nm_usuario_p text, cd_estabelecimento_p bigint, ie_regra_tipo_acomod_proc_p text default 'N') FROM PUBLIC;

