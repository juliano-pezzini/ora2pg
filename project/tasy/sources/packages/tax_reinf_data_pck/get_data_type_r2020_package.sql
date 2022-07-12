-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';




CREATE OR REPLACE FUNCTION tax_reinf_data_pck.get_data_type_r2020 (batch_code_p text, invoice_sequence_p fis_reinf_notas_r2020.nr_seq_nota%type) RETURNS SETOF R2020_TYPE_TABLE_W AS $body$
DECLARE

    r2020_type_data_w    r2020_type_record_w;

    c_r2020_type CURSOR FOR
      SELECT	type_service type_service,
              sum(main_retention) main_retention,
              sum(base_retention) base_retention,
              sum(non_retention) non_retention,
              sum(percent_15) percent_15,
              sum(percent_20) percent_20,
              sum(percent_25) percent_25,
              sum(additional) additional
      from  (
            SELECT  ie_tipo_servico type_service, 
                    (t.vl_base_calculo * 0.11) main_retention,
                    t.vl_base_calculo base_retention,
                    CASE WHEN obter_se_possui_processo(n.nr_seq_nota, fr.nr_sequencia, '2020')='S' THEN  t.vl_tributo  ELSE 0 END  non_retention,
                    tax_reinf_data_pck.get_rate_value(t.tx_tributo, t.vl_base_calculo, 6) percent_15,
                    tax_reinf_data_pck.get_rate_value(t.tx_tributo, t.vl_base_calculo, 7) percent_20,
                    tax_reinf_data_pck.get_rate_value(t.tx_tributo, t.vl_base_calculo, 8) percent_25,
                    tax_reinf_data_pck.get_rate_value(t.tx_tributo, t.vl_base_calculo, 9) additional
            from    nota_fiscal_trib t,
                    material_fiscal m,
                    nota_fiscal_item i,
                    fis_reinf_r2020 fr,
                    fis_reinf_notas_r2020 n
            where   t.nr_sequencia = i.nr_sequencia 
            and     n.nr_seq_nota = i.nr_sequencia
            and     m.cd_material = i.cd_material 
            and     fr.cd_tributo = t.cd_tributo
            and 	  fr.nr_sequencia = batch_code_p
            and 	  i.nr_sequencia = invoice_sequence_p
            and     t.vl_tributo <> 0
            group by  ie_tipo_servico,
                      fr.nr_sequencia,
                      i.nr_sequencia,
                      (t.vl_base_calculo * 0.11),
                      t.vl_base_calculo, 
                      CASE WHEN obter_se_possui_processo(n.nr_seq_nota,fr.nr_sequencia, '2020')='S' THEN  t.vl_tributo  ELSE 0 END ,
                      t.tx_tributo,
                      t.vl_base_calculo                   
            
union

            select  ie_tipo_servico type_service, 
                    (t.vl_base_calculo * 0.11) main_retention,
                    sum(t.vl_base_calculo) base_retention,
                    CASE WHEN obter_se_possui_processo(n.nr_seq_nota, fr.nr_sequencia, '2020')='S' THEN  t.vl_tributo  ELSE 0 END  non_retention,
                    tax_reinf_data_pck.get_rate_value(t.tx_tributo, t.vl_base_calculo, 6) percent_15,
                    tax_reinf_data_pck.get_rate_value(t.tx_tributo, t.vl_base_calculo, 7) percent_20,
                    tax_reinf_data_pck.get_rate_value(t.tx_tributo, t.vl_base_calculo, 8) percent_25,
                    tax_reinf_data_pck.get_rate_value(t.tx_tributo, t.vl_base_calculo, 9) additional
            from    nota_fiscal_item_trib t,
                    material_fiscal m,
                    nota_fiscal_item i,
                    fis_reinf_r2020 fr,
                    fis_reinf_notas_r2020 n
            where   m.cd_material = i.cd_material 
            and     i.nr_item_nf = t.nr_item_nf 
            and     i.nr_sequencia = t.nr_sequencia  
            and     fr.cd_tributo = t.cd_tributo 
            and     n.nr_seq_nota = i.nr_sequencia	
            and 	  fr.nr_sequencia = batch_code_p
            and 	  i.nr_sequencia = invoice_sequence_p
            and     t.vl_tributo <> 0
            group by  ie_tipo_servico,
                      fr.nr_sequencia,
                      i.nr_sequencia,
                      (t.vl_base_calculo * 0.11),
                      t.vl_base_calculo, 
                      CASE WHEN obter_se_possui_processo(n.nr_seq_nota, fr.nr_sequencia, '2020')='S' THEN  t.vl_tributo  ELSE 0 END ,
                      t.tx_tributo,
                      t.vl_base_calculo    
            
union

            select  ie_tipo_servico  type_service, 
                    (t.vl_base_calculo * 0.11) main_retention,
                    t.vl_base_calculo base_retention,
                    CASE WHEN obter_se_possui_processo(n.nr_seq_nota, fr.nr_sequencia, '2020')='S' THEN  t.vl_tributo  ELSE 0 END  non_retention,
                    tax_reinf_data_pck.get_rate_value(t.tx_tributo, t.vl_base_calculo, 6) percent_15,
                    tax_reinf_data_pck.get_rate_value(t.tx_tributo, t.vl_base_calculo, 7) percent_20,
                    tax_reinf_data_pck.get_rate_value(t.tx_tributo, t.vl_base_calculo, 8) percent_25,
                    tax_reinf_data_pck.get_rate_value(t.tx_tributo, t.vl_base_calculo, 9) additional
            from    nota_fiscal_trib t, 
                    procedimento_fiscal pf,
                    nota_fiscal_item i,
                    fis_reinf_r2020 fr,
                    fis_reinf_notas_r2020 n
            where   t.nr_sequencia = i.nr_sequencia 
            and     n.nr_seq_nota = i.nr_sequencia
            and     pf.cd_procedimento = i.cd_procedimento 
            and     fr.cd_tributo = t.cd_tributo       
            and 	  fr.nr_sequencia = batch_code_p
            and 	  i.nr_sequencia = invoice_sequence_p
            and     t.vl_tributo <> 0                  
            group by  ie_tipo_servico,
                      fr.nr_sequencia,
                      i.nr_sequencia,
                      (t.vl_base_calculo * 0.11),
                      t.vl_base_calculo, 
                      CASE WHEN obter_se_possui_processo(n.nr_seq_nota, fr.nr_sequencia, '2020')='S' THEN  t.vl_tributo  ELSE 0 END ,
                      t.tx_tributo,
                      t.vl_base_calculo
            
union

            select  ie_tipo_servico type_service, 
                    (t.vl_base_calculo * 0.11) main_retention, 
                    sum(t.vl_base_calculo) base_retention,
                    CASE WHEN obter_se_possui_processo(n.nr_seq_nota, fr.nr_sequencia, '2020')='S' THEN  t.vl_tributo  ELSE 0 END  non_retention,
                    tax_reinf_data_pck.get_rate_value(t.tx_tributo, t.vl_base_calculo, 6) percent_15,
                    tax_reinf_data_pck.get_rate_value(t.tx_tributo, t.vl_base_calculo, 7) percent_20,
                    tax_reinf_data_pck.get_rate_value(t.tx_tributo, t.vl_base_calculo, 8) percent_25,
                    tax_reinf_data_pck.get_rate_value(t.tx_tributo, t.vl_base_calculo, 9) additional
            from    nota_fiscal_item_trib t,
                    procedimento_fiscal pf,
                    nota_fiscal_item i,
                    fis_reinf_r2020 fr,
                    fis_reinf_notas_r2020 n
            where   pf.cd_procedimento = i.cd_procedimento 
            and     i.nr_item_nf = t.nr_item_nf 
            and     i.nr_sequencia = t.nr_sequencia 
            and     fr.cd_tributo = t.cd_tributo 
            and     n.nr_seq_nota = i.nr_sequencia  
            and 	  fr.nr_sequencia = batch_code_p
            and 	  i.nr_sequencia = invoice_sequence_p
            and     t.vl_tributo <> 0 
            group by  ie_tipo_servico,
                      fr.nr_sequencia,
                      i.nr_sequencia,
                      (t.vl_base_calculo * 0.11),     
                      CASE WHEN obter_se_possui_processo(n.nr_seq_nota, fr.nr_sequencia, '2020')='S' THEN  t.vl_tributo  ELSE 0 END ,
                      t.tx_tributo,
                      t.vl_base_calculo) alias41
      group by  type_service;

BEGIN
    for r2020_type_row in c_r2020_type loop
      begin      
        r2020_type_data_w.type_service    := r2020_type_row.type_service;
        r2020_type_data_w.main_retention  := r2020_type_row.main_retention;
        r2020_type_data_w.base_retention  := r2020_type_row.base_retention;
        r2020_type_data_w.non_retention   := r2020_type_row.non_retention;
        r2020_type_data_w.percent_15      := r2020_type_row.percent_15;
        r2020_type_data_w.percent_20      := r2020_type_row.percent_20;
        r2020_type_data_w.percent_25      := r2020_type_row.percent_25;
        r2020_type_data_w.additional      := r2020_type_row.additional;
        RETURN NEXT r2020_type_data_w;
      end;
    end loop;
    return;
  END;

$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON FUNCTION tax_reinf_data_pck.get_data_type_r2020 (batch_code_p text, invoice_sequence_p fis_reinf_notas_r2020.nr_seq_nota%type) FROM PUBLIC;
