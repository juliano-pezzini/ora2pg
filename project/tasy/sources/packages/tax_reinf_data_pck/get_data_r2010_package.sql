-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';




CREATE OR REPLACE FUNCTION tax_reinf_data_pck.get_data_r2010 (batch_code_p text) RETURNS SETOF R2010_TABLE_W AS $body$
DECLARE

    r2010_data_w    r2010_record_w;

    c_2010 CURSOR FOR
      SELECT  tax_reinf_data_pck.get_event_id(subscription, rownum) identification,
              '1' emission,	
              '1' subscription_type, 
              substr(subscription, 1, 8) subscription, 
              supplier_registration, 
              environment_type,
              rectification,
              receipt,
              to_char(competence, 'rrrr-mm') competence,
              CASE WHEN coalesce(national_works_code::text, '') = '' THEN  '1'  ELSE '4' END  estab_subscription_type,
              CASE WHEN works_indicator=0 THEN  subscription  ELSE CASE WHEN coalesce(national_works_code::text, '') = '' THEN  subscription  ELSE national_works_code END  END  establishment_subscription,
              works_indicator,
              national_works_code,
              gross_value,
              base_value_retained,
              value_retained,
              value_retained_addit,
              value_non_retained,
              obter_contribuinte_receita(supplier_registration) cprb_indicator
      from (  
        SELECT  e.cd_cgc subscription,
                f.cd_ident_ambiente environment_type,
                f.ie_ind_retif rectification,
                f.nr_recibo	receipt,
                f.dt_competencia competence,
                n.cd_ind_obra	works_indicator,
                n.cd_cnpj supplier_registration,
                n.cd_cno national_works_code,
                sum(n.vl_bruto_nf) gross_value, 
                sum(n.vl_base_trib_inss) base_value_retained, 
                sum(n.vl_retencao_inss) - sum(n.vl_ret_subcontratado) value_retained, 
                sum(vl_servicos_15) + sum(vl_servicos_20) + sum(vl_servicos_25) value_retained_addit,
                sum(n.vl_n_retencao_inss) value_non_retained
        from    estabelecimento e,
                fis_reinf_r2010 f,
                fis_reinf_notas_r2010 n
        where   e.cd_estabelecimento = f.cd_estabelecimento
        and	    n.nr_seq_superior = f.nr_sequencia
        and	    coalesce(n.dt_transmissao::text, '') = ''
        and	    coalesce(n.ie_status::text, '') = ''
        and     f.nr_sequencia = batch_code_p
        group by  f.cd_ident_ambiente, 
                  e.cd_cgc,
                  f.ie_ind_retif, 
                  f.nr_recibo, 
                  f.dt_competencia, 
                  n.cd_ind_obra, 
                  n.cd_cnpj, 
                  n.cd_cno
      ) alias16;

BEGIN
    for r2010_row in c_2010 loop
      begin
        r2010_data_w.identification                 := r2010_row.identification;
        r2010_data_w.emission                       := r2010_row.emission;
        r2010_data_w.subscription_type              := r2010_row.subscription_type;
        r2010_data_w.subscription                   := r2010_row.subscription;
        r2010_data_w.supplier_registration          := r2010_row.supplier_registration;
        r2010_data_w.environment_type               := r2010_row.environment_type;
        r2010_data_w.rectification                  := r2010_row.rectification;
        r2010_data_w.receipt                        := r2010_row.receipt;
        r2010_data_w.competence                     := r2010_row.competence;
        r2010_data_w.estab_subscription_type        := r2010_row.estab_subscription_type;
        r2010_data_w.establishment_subscription     := r2010_row.establishment_subscription;
        r2010_data_w.works_indicator                := r2010_row.works_indicator;
        r2010_data_w.national_works_code            := r2010_row.national_works_code;
        r2010_data_w.gross_value                    := r2010_row.gross_value;
        r2010_data_w.base_value_retained            := r2010_row.base_value_retained;
        r2010_data_w.value_retained                 := r2010_row.value_retained;
        r2010_data_w.value_retained_addit           := r2010_row.value_retained_addit;
        r2010_data_w.value_non_retained             := r2010_row.value_non_retained;
        r2010_data_w.cprb_indicator                 := r2010_row.cprb_indicator;
        RETURN NEXT r2010_data_w;
      end;
    end loop;
    return;
  END;

$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON FUNCTION tax_reinf_data_pck.get_data_r2010 (batch_code_p text) FROM PUBLIC;
