-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';




CREATE OR REPLACE FUNCTION tax_reinf_data_pck.get_data_type_r2010 (batch_code_p text, invoice_sequence_p fis_reinf_notas_r2010.nr_seq_nota%type) RETURNS SETOF R2010_TYPE_TABLE_W AS $body$
DECLARE

    r2010_type_data_w    r2010_type_record_w;

    c_r2010_type CURSOR FOR
      SELECT	type_service,
              max(main_retention) main_retention,
              sum(base_retention) base_retention,
              sum(non_retention) non_retention,
              sum(percent_15) percent_15,
              sum(percent_20) percent_20,
              sum(percent_25) percent_25,
              sum(additional) additional,
              sum(subcontract) subcontract
      from (
        SELECT  distinct ie_tipo_servico type_service,
                n.vl_retencao_inss main_retention,
                t.vl_base_calculo base_retention,
                CASE WHEN obter_se_possui_processo(n.nr_seq_nota, fr.nr_sequencia, '2010')='S' THEN  t.vl_tributo  ELSE 0 END  non_retention,
                tax_reinf_data_pck.get_rate_value(t.tx_tributo, t.vl_base_calculo, 6) percent_15,
                tax_reinf_data_pck.get_rate_value(t.tx_tributo, t.vl_base_calculo, 7) percent_20,
                tax_reinf_data_pck.get_rate_value(t.tx_tributo, t.vl_base_calculo, 8) percent_25,
                tax_reinf_data_pck.get_rate_value(t.tx_tributo, t.vl_base_calculo, 9) additional,
                n.vl_ret_subcontratado subcontract
        from	  nota_fiscal_item i,
                nota_fiscal_trib t,
                material_fiscal m,
                fis_reinf_r2010 fr,
                fis_reinf_notas_r2010 n 
        where   t.nr_sequencia = i.nr_sequencia 
        and 	  m.cd_material = i.cd_material 
        and 	  fr.cd_tributo = t.cd_tributo 
        and 	  t.vl_tributo <> 0 
        and		  fr.nr_sequencia = n.nr_seq_superior
        and 	  fr.nr_sequencia = batch_code_p
        and 	  i.nr_sequencia = invoice_sequence_p
        and 	  n.nr_seq_nota = i.nr_sequencia
        group by  ie_tipo_servico,
                  n.vl_retencao_inss,
                  t.vl_base_calculo, t.tx_tributo,
                  CASE WHEN obter_se_possui_processo(n.nr_seq_nota, fr.nr_sequencia, '2010')='S' THEN  t.vl_tributo  ELSE 0 END ,
                  t.tx_tributo, t.vl_base_calculo,
                  n.vl_ret_subcontratado
        
union

        select  distinct ie_tipo_servico type_service,
                n.vl_retencao_inss main_retention,
                sum(t.vl_base_calculo) base_retention,
                CASE WHEN obter_se_possui_processo(n.nr_seq_nota, fr.nr_sequencia, '2010')='S' THEN  t.vl_tributo  ELSE 0 END  non_retention,
                tax_reinf_data_pck.get_rate_value(t.tx_tributo, t.vl_base_calculo, 6) percent_15,
                tax_reinf_data_pck.get_rate_value(t.tx_tributo, t.vl_base_calculo, 7) percent_20,
                tax_reinf_data_pck.get_rate_value(t.tx_tributo, t.vl_base_calculo, 8) percent_25,
                tax_reinf_data_pck.get_rate_value(t.tx_tributo, t.vl_base_calculo, 9) additional,
                n.vl_ret_subcontratado subcontract
        from	  nota_fiscal_item i,
                nota_fiscal_item_trib t,
                material_fiscal m,
                fis_reinf_r2010 fr,
                fis_reinf_notas_r2010 n	 
        where 	m.cd_material = i.cd_material 
        and 	  i.nr_item_nf = t.nr_item_nf 
        and 	  i.nr_sequencia = t.nr_sequencia
        and 	  t.vl_tributo <> 0
        and		  fr.nr_sequencia = n.nr_seq_superior
        and 	  fr.cd_tributo = t.cd_tributo
        and 	  fr.nr_sequencia = batch_code_p
        and 	  i.nr_sequencia = invoice_sequence_p
        and 	  n.nr_seq_nota = i.nr_sequencia
        group by  ie_tipo_servico,
                  n.vl_retencao_inss,
                  t.tx_tributo,
                  n.vl_ret_subcontratado,
                  CASE WHEN obter_se_possui_processo(n.nr_seq_nota, fr.nr_sequencia, '2010')='S' THEN  t.vl_tributo  ELSE 0 END ,
                  t.tx_tributo, 
                  t.vl_base_calculo) alias21
      group by  type_service;

BEGIN
    for r2010_type_row in c_r2010_type loop
      begin
        r2010_type_data_w.main_retention  := r2010_type_row.main_retention;
        r2010_type_data_w.base_retention  := r2010_type_row.base_retention;
        r2010_type_data_w.non_retention   := r2010_type_row.non_retention;
        r2010_type_data_w.percent_15      := r2010_type_row.percent_15;
        r2010_type_data_w.percent_20      := r2010_type_row.percent_20;
        r2010_type_data_w.percent_25      := r2010_type_row.percent_25;
        r2010_type_data_w.additional      := r2010_type_row.additional;
        r2010_type_data_w.subcontract     := r2010_type_row.subcontract;
        RETURN NEXT r2010_type_data_w;
      end;
    end loop;
    return;
  END;

$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON FUNCTION tax_reinf_data_pck.get_data_type_r2010 (batch_code_p text, invoice_sequence_p fis_reinf_notas_r2010.nr_seq_nota%type) FROM PUBLIC;
