-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE split_normal_order_into_units ( NR_ATENDIMENTO_P bigint , NR_SEQ_ORDER_UNIT_P bigint , NM_USUARIO_P text ) AS $body$
DECLARE


dt_start_w  timestamp;
dt_end_w  timestamp;
dt_curr_w timestamp;
nr_tipo_atend_w bigint := 0;
nr_rp_count_w bigint := 0;
rp_ids_w LT_NUMBER := LT_NUMBER();
dt_horas_inicio_pct_w timestamp(6);
dt_horas_inicio_wct_w timestamp(6);
dt_horas_str_w varchar(20);
dt_cut_off_w timestamp;
ie_tipo_encounter bigint := 0;
si_type_of_prescr_root_w       cpoe_order_unit.si_type_of_prescription%type := 'INPI';
si_type_of_prescr_child_w       cpoe_order_unit.si_type_of_prescription%type := 'INPI';
nr_seq_order_unit_w cpoe_order_unit.nr_sequencia%type;

si_cpoe_type_of_item_ou_w       cpoe_order_unit.si_cpoe_type_of_item%type;
nr_seq_cpoe_tipo_pedido_ou_w    cpoe_order_unit.nr_seq_cpoe_tipo_pedido%type;
cd_pessoa_fisica_ou_w           cpoe_order_unit.cd_pessoa_fisica%type;
nr_atendimento_ou_w             cpoe_order_unit.nr_atendimento%type;
cd_setor_execucao_ou_w          cpoe_order_unit.cd_setor_execucao%type;
nr_seq_nais_insurance_ou_w      cpoe_order_unit.nr_seq_nais_insurance%type;
ie_drug_info_ou_w               cpoe_order_unit.ie_drug_info%type;
si_same_dose_ou_w               cpoe_order_unit.si_same_dose%type;
si_drug_adjustment_ou_w         cpoe_order_unit.si_drug_adjustment%type;
si_provide_info_insurance_ou_w  cpoe_order_unit.si_provide_info_insurance%type;
si_dispense_med_insurance_ou_w  cpoe_order_unit.si_dispense_med_insurance%type;
ie_tipo_receita_ou_w            cpoe_order_unit.ie_tipo_receita%type;
id_dispense_for_question_ou_w   cpoe_order_unit.id_dispense_for_question%type;
id_provide_info_medical_ou_w    cpoe_order_unit.id_provide_info_medical%type;
cd_setor_coleta_ou_w            cpoe_order_unit.cd_setor_coleta%type;

nr_sequencia_w                  cpoe_rp.nr_sequencia%type;
ie_via_aplicacao_w              cpoe_rp.ie_via_aplicacao%type;
nr_sequencia_rp_w               cpoe_rp.nr_sequencia_rp%type;
cd_intervalo_w                  cpoe_rp.cd_intervalo%type;
ds_horarios_w                   cpoe_rp.ds_horarios%type;
qt_dias_padrao_w                cpoe_rp.qt_dias_padrao%type;
ie_segunda_w                    cpoe_rp.ie_segunda%type;
ie_terca_w                      cpoe_rp.ie_terca%type;
ie_quarta_w                     cpoe_rp.ie_quinta%type;
ie_quinta_w                     cpoe_rp.nr_sequencia%type;
ie_sexta_w                      cpoe_rp.ie_sexta%type;
ie_sabado_w                     cpoe_rp.ie_sabado%type;
ie_domingo_w                    cpoe_rp.ie_domingo%type;
nr_seq_start_period_w           cpoe_rp.nr_seq_start_period%type;
nr_seq_subgrupo_interval_w      cpoe_rp.nr_seq_subgrupo_interval%type;
nr_seq_grupo_interval_w         cpoe_rp.nr_seq_grupo_interval%type;
ie_enable_end_dt_w              cpoe_rp.ie_enable_end_dt%type;
si_temporary_admin_w            cpoe_rp.si_temporary_admin%type;
ie_allow_execution_w            cpoe_rp.ie_allow_execution%type;
qt_operacao_w                   cpoe_rp.qt_operacao%type;
qt_dosagem_w                    cpoe_rp.qt_dosagem%type;
qt_tempo_aplicacao_w            cpoe_rp.qt_tempo_aplicacao%type;
nr_etapas_w                     cpoe_rp.nr_etapas%type;
ie_bomba_infusao_w              cpoe_rp.ie_bomba_infusao%type;
qt_hora_fase_w                  cpoe_rp.qt_hora_fase%type;
ie_tipo_solucao_w               cpoe_rp.ie_tipo_solucao%type;
ie_tipo_dosagem_w               cpoe_rp.ie_tipo_dosagem%type;
ie_ref_calculo_w                cpoe_rp.ie_ref_calculo%type;
ie_drip_shot_w                  cpoe_rp.ie_drip_shot%type;
/*
Should we split order if no RP?
*/
cpoe_rp_def_cur CURSOR FOR
    SELECT  dt_inicio,
            dt_fim,
            nr_sequencia,
            ie_via_aplicacao,
            nr_sequencia_rp,
            cd_intervalo,
            ds_horarios,
            qt_dias_padrao,
            ie_segunda,
            ie_terca,
            ie_quarta,
            ie_quinta,
            ie_sexta,
            ie_sabado,
            ie_domingo,
            nr_seq_start_period,
            nr_seq_subgrupo_interval,
            nr_seq_grupo_interval,
            ie_enable_end_dt,
            si_temporary_admin,
            ie_allow_execution,
            qt_operacao,
            qt_dosagem,
            qt_tempo_aplicacao,
            nr_etapas,
            ie_bomba_infusao,
            qt_hora_fase,
            ie_tipo_solucao,
            ie_tipo_dosagem,
            ie_ref_calculo,
            ie_drip_shot
    from    cpoe_rp
    where   nr_seq_cpoe_order_unit = NR_SEQ_ORDER_UNIT_P
    order by nr_sequencia_rp;

BEGIN

  begin
      select DT_START,
             DT_END 
      into STRICT  dt_start_w,
            dt_end_w 
      from cpoe_order_unit
      where nr_sequencia = NR_SEQ_ORDER_UNIT_P;
   exception
     when no_data_found then
       CALL WHEB_MENSAGEM_PCK.exibir_mensagem_abort('Invalid Order unit sequence!!!');
   end;

  select obter_tipo_atendimento(NR_ATENDIMENTO_P)
  into STRICT nr_tipo_atend_w 
;
  
  select count(*)
  into STRICT nr_rp_count_w
  from cpoe_rp
  where NR_SEQ_CPOE_ORDER_UNIT = NR_SEQ_ORDER_UNIT_P;

  begin
    select  P.DT_HORAS_INICIO,
          P.SI_TYPE_OF_PRESCRIPTION
    into STRICT    dt_horas_inicio_pct_w, 
            si_type_of_prescr_root_w
    from CPOE_PRAZO_INICIO_PRESCR P
    where (P.CD_ESTABELECIMENTO = wheb_usuario_pck.get_cd_estabelecimento or P.CD_ESTABELECIMENTO = 1)
    and (P.CD_SETOR_ATENDIMENTO = wheb_usuario_pck.get_cd_setor_atendimento or coalesce(P.CD_SETOR_ATENDIMENTO::text, '') = '')
    and (P.CD_PERFIL = wheb_usuario_pck.get_cd_perfil or coalesce(P.CD_PERFIL::text, '') = '')
    and (P.IE_TIPO_ATENDIMENTO = obter_tipo_atendimento(nr_atendimento_p) or
      coalesce(P.IE_TIPO_ATENDIMENTO::text, '') = '')
    and P.IE_DECISION_POINT = 'PCT'
    and  'I' = (SELECT NR_SEQ_SUB_GRP 
                from CPOE_TIPO_PEDIDO
                where NR_SEQUENCIA = P.NR_SEQ_CPOE_TIPO_PEDIDO -- 138
  LIMIT 1);
  exception
     when no_data_found then
       NULL;
       --WHEB_MENSAGEM_PCK.exibir_mensagem_abort('Passed cut off rule not defined!!!');
   end;

  begin            
    select P.SI_TYPE_OF_PRESCRIPTION
    into STRICT   si_type_of_prescr_child_w
    from CPOE_PRAZO_INICIO_PRESCR P
    where (P.CD_ESTABELECIMENTO = wheb_usuario_pck.get_cd_estabelecimento or P.CD_ESTABELECIMENTO = 1)
    and (P.CD_SETOR_ATENDIMENTO = wheb_usuario_pck.get_cd_setor_atendimento or coalesce(P.CD_SETOR_ATENDIMENTO::text, '') = '')
    and (P.CD_PERFIL = wheb_usuario_pck.get_cd_perfil or coalesce(P.CD_PERFIL::text, '') = '')
    and (P.IE_TIPO_ATENDIMENTO = obter_tipo_atendimento(nr_atendimento_p) or
      coalesce(P.IE_TIPO_ATENDIMENTO::text, '') = '')
    and P.IE_DECISION_POINT = 'WCT'
    and  'I' = (SELECT NR_SEQ_SUB_GRP 
                from CPOE_TIPO_PEDIDO
                where NR_SEQUENCIA = P.NR_SEQ_CPOE_TIPO_PEDIDO  LIMIT 1);
  exception
     when no_data_found then
     NULL;
      -- WHEB_MENSAGEM_PCK.exibir_mensagem_abort('Within cut off rule not defined!!!');
   end;

  select PKG_DATE_UTILS.extract_field('HOUR', dt_horas_inicio_pct_w) 
    || ':' || PKG_DATE_UTILS.extract_field('MINUTE', dt_horas_inicio_pct_w) 
  into STRICT dt_horas_str_w
;

  select PKG_DATE_UTILS.get_Time(clock_timestamp(), dt_horas_str_w) 
  into STRICT dt_cut_off_w 
;

  if (dt_cut_off_w >= clock_timestamp()) then
    si_type_of_prescr_root_w := si_type_of_prescr_child_w;
  end if;

  
  select  si_cpoe_type_of_item,
            nr_seq_cpoe_tipo_pedido,
            cd_pessoa_fisica,
            nr_atendimento,
            cd_setor_execucao,
            nr_seq_nais_insurance,
            ie_drug_info,
            si_same_dose,
            si_drug_adjustment,
            si_provide_info_insurance,
            si_dispense_med_insurance,
            ie_tipo_receita,
            id_dispense_for_question,
            id_provide_info_medical,
            cd_setor_coleta
    into STRICT    si_cpoe_type_of_item_ou_w,
            nr_seq_cpoe_tipo_pedido_ou_w,
            cd_pessoa_fisica_ou_w,
            nr_atendimento_ou_w,
            cd_setor_execucao_ou_w,
            nr_seq_nais_insurance_ou_w,
            ie_drug_info_ou_w,
            si_same_dose_ou_w,
            si_drug_adjustment_ou_w,
            si_provide_info_insurance_ou_w,
            si_dispense_med_insurance_ou_w,
            ie_tipo_receita_ou_w,
            id_dispense_for_question_ou_w,
            id_provide_info_medical_ou_w,
            cd_setor_coleta_ou_w
    from    cpoe_order_unit
    where   nr_sequencia = NR_SEQ_ORDER_UNIT_P;

  if (dt_start_w IS NOT NULL AND dt_start_w::text <> '' AND dt_end_w IS NOT NULL AND dt_end_w::text <> '') then
    if (nr_rp_count_w > 0) then
      select nr_sequencia BULK COLLECT INTO STRICT rp_ids_w from CPOE_RP where nr_seq_cpoe_order_unit = NR_SEQ_ORDER_UNIT_P;
      dt_curr_w := dt_start_w + 1;
        while(trunc(dt_curr_w) <= trunc(dt_end_w)) loop
          select	nextval('cpoe_order_unit_seq') into STRICT 	nr_seq_order_unit_w;
          insert into cpoe_order_unit(
              nr_sequencia,
              dt_atualizacao,
              nm_usuario,
              dt_atualizacao_nrec,
              nm_usuario_nrec,
              nr_order_unit,
              si_type_of_prescription,
              si_cpoe_type_of_item,
              nr_seq_cpoe_tipo_pedido,
              cd_pessoa_fisica,
              nr_atendimento,
              ie_situacao,
              cd_setor_execucao,
              nr_seq_nais_insurance,
              ie_drug_info,
              si_same_dose,
              si_drug_adjustment,
              si_provide_info_insurance,
              si_dispense_med_insurance,
              ie_tipo_receita,
              id_dispense_for_question,
              id_provide_info_medical,
              cd_setor_coleta,
              nr_seq_prev_order_unit,
              dt_start,
              dt_end
            ) values (
              nr_seq_order_unit_w,
              clock_timestamp(),
              NM_USUARIO_P,
              clock_timestamp(),
              NM_USUARIO_P,
              NR_SEQ_ORDER_UNIT_P,
              si_type_of_prescr_child_w,
              si_cpoe_type_of_item_ou_w,
              nr_seq_cpoe_tipo_pedido_ou_w,
              cd_pessoa_fisica_ou_w,
              NR_ATENDIMENTO_P,
              'A',
              cd_setor_execucao_ou_w,
              nr_seq_nais_insurance_ou_w,
              ie_drug_info_ou_w,
              si_same_dose_ou_w,
              si_drug_adjustment_ou_w,
              si_provide_info_insurance_ou_w,
              si_dispense_med_insurance_ou_w,
              ie_tipo_receita_ou_w,
              id_dispense_for_question_ou_w,
              id_provide_info_medical_ou_w,
              cd_setor_coleta_ou_w,
              NR_SEQ_ORDER_UNIT_P,
              dt_curr_w,
              dt_curr_w
            );
           
            FOR rp_index IN rp_ids_w.first..rp_ids_w.last LOOP              
               select     nr_sequencia,
                          ie_via_aplicacao,
                          nr_sequencia_rp,
                          cd_intervalo,
                          ds_horarios,
                          qt_dias_padrao,
                          ie_segunda,
                          ie_terca,
                          ie_quarta,
                          ie_quinta,
                          ie_sexta,
                          ie_sabado,
                          ie_domingo,
                          nr_seq_start_period,
                          nr_seq_subgrupo_interval,
                          nr_seq_grupo_interval,
                          ie_enable_end_dt,
                          si_temporary_admin,
                          ie_allow_execution,
                          qt_operacao,
                          qt_dosagem,
                          qt_tempo_aplicacao,
                          nr_etapas,
                          ie_bomba_infusao,
                          qt_hora_fase,
                          ie_tipo_solucao,
                          ie_tipo_dosagem,
                          ie_ref_calculo,
                          ie_drip_shot
                  into STRICT    nr_sequencia_w,
                          ie_via_aplicacao_w,
                          nr_sequencia_rp_w,
                          cd_intervalo_w,
                          ds_horarios_w,
                          qt_dias_padrao_w,
                          ie_segunda_w,
                          ie_terca_w,
                          ie_quarta_w,
                          ie_quinta_w,
                          ie_sexta_w,
                          ie_sabado_w,
                          ie_domingo_w,
                          nr_seq_start_period_w,
                          nr_seq_subgrupo_interval_w,
                          nr_seq_grupo_interval_w,
                          ie_enable_end_dt_w,
                          si_temporary_admin_w,
                          ie_allow_execution_w,
                          qt_operacao_w,
                          qt_dosagem_w,
                          qt_tempo_aplicacao_w,
                          nr_etapas_w,
                          ie_bomba_infusao_w,
                          qt_hora_fase_w,
                          ie_tipo_solucao_w,
                          ie_tipo_dosagem_w,
                          ie_ref_calculo_w,
                          ie_drip_shot_w
                  from    cpoe_rp
                  where   nr_sequencia = rp_ids_w(rp_index);

              
                insert into cpoe_rp(
                  nr_sequencia,
                  nr_sequencia_rp,
                  ie_via_aplicacao,
                  dt_atualizacao,
                  nm_usuario,
                  dt_atualizacao_nrec,
                  nm_usuario_nrec,
                  cd_intervalo,
                  ds_horarios,
                  dt_inicio,
                  dt_fim,
                  nr_seq_cpoe_order_unit,
                  qt_dias_padrao,
                  ie_segunda,
                  ie_terca,
                  ie_quarta,
                  ie_quinta,
                  ie_sexta,
                  ie_sabado,
                  ie_domingo,
                  nr_seq_start_period,
                  nr_seq_subgrupo_interval,
                  nr_seq_grupo_interval,
                  ie_enable_end_dt,
                  si_temporary_admin,
                  ie_allow_execution,
                  qt_operacao,
                  qt_dosagem,
                  qt_tempo_aplicacao,
                  nr_etapas,
                  ie_bomba_infusao,
                  qt_hora_fase,
                  ie_tipo_solucao,
                  ie_tipo_dosagem,
                  ie_ref_calculo,
                  ie_drip_shot,
                  nr_seq_prev_rp
              ) values (
                nextval('cpoe_rp_seq'),
                nr_sequencia_rp_w,
                ie_via_aplicacao_w,
                clock_timestamp(),
                nm_usuario_p,
                clock_timestamp(),
                nm_usuario_p,
                cd_intervalo_w,
                ds_horarios_w,
                dt_curr_w,                
                dt_curr_w,
                nr_seq_order_unit_w,
                qt_dias_padrao_w,
                ie_segunda_w,
                ie_terca_w,
                ie_quarta_w,
                ie_quinta_w,
                ie_sexta_w,
                ie_sabado_w,
                ie_domingo_w,
                nr_seq_start_period_w,
                nr_seq_subgrupo_interval_w,
                nr_seq_grupo_interval_w,
                ie_enable_end_dt_w,
                si_temporary_admin_w,
                ie_allow_execution_w,
                qt_operacao_w,
                qt_dosagem_w,
                qt_tempo_aplicacao_w,
                nr_etapas_w,
                ie_bomba_infusao_w,
                qt_hora_fase_w,
                ie_tipo_solucao_w,
                ie_tipo_dosagem_w,
                ie_ref_calculo_w,
                ie_drip_shot_w,
                nr_sequencia_w
              );
            end loop;
          dt_curr_w := dt_curr_w + 1;
        end loop;
        -- Correcting the date ranges of the origin order unit and rp records
        update cpoe_order_unit set si_type_of_prescription = si_type_of_prescr_root_w,
        dt_end = dt_start_w where nr_sequencia = NR_SEQ_ORDER_UNIT_P;
        FOR rp_index IN rp_ids_w.first..rp_ids_w.last LOOP
          update cpoe_rp set dt_inicio = dt_start_w, dt_fim = dt_start_w where nr_sequencia = rp_ids_w(rp_index);
        end loop;
    end if;
  end if;

  commit;

END; /* GOLDENGATE_DDL_REPLICATION */
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE split_normal_order_into_units ( NR_ATENDIMENTO_P bigint , NR_SEQ_ORDER_UNIT_P bigint , NM_USUARIO_P text ) FROM PUBLIC;
