-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';




CREATE OR REPLACE PROCEDURE tax_dmed_ir_pck.load_without_advances () AS $body$
DECLARE

      procedure_name_w varchar(20) := 'TaxDmed5';
      document_vector    response_reference;
      alternative_query  varchar(4000) := 'select a.nr_adiantamento document_sequence,'                                                      ||
                                                  'c.cd_pessoa_fisica responsible_code,'                                                      ||
                                                  'c.cd_pessoa_fisica beneficiary_code,'                                                      ||
                                                  'sum(a.vl_saldo) total_amount,'                                                             ||
                                                  'max(0) interest_amount,'                                                                   ||
                                                  'max(0) fine_amount,'                                                                       ||
                                                  'max(0) gloss_amount,'                                                                      ||
                                                  'max(0) credit_note_amount,'                                                                ||
                                                  'max(0) trading_fee_amount, '                                                               ||
                                                  'max(0) higher_amount,'                                                                     ||
                                                  'a.dt_contabil date_document,'                                                              ||
                                                  'max(0) attendance_code,'                                                                   ||
                                                  'max(null) refund_provider_pf,'                                                             ||
                                                  'max(null) refund_provider_pj,'                                                             ||
                                                  'min(null) data_code,'                                                                      ||
                                                  'max(0) additional_index,'                                                                  ||
                                                  'min(null) item_value'                                                                      ||						
                                          ' from adiantamento a,'                                                                             ||
                                                  'pessoa_fisica	c'                                                                         ||
                                          ' where a.cd_pessoa_fisica = c.cd_pessoa_fisica'                                                    ||
                                          ' and nvl(a.vl_saldo, 0) > 0'                                                                       ||
                                          ' and a.cd_estabelecimento = ' || reference_establishment                                           ||
                                          ' and a.dt_contabil between tax_dmed_ir_pck.get_initial_date() and tax_dmed_ir_pck.get_final_date()'    ||
                                          q'[ and tax_dmed_ir_pck.in_array(a.cd_tipo_recebimento, 'R') = 1]'                                  ||
                                          ' group by a.nr_adiantamento,'                                                                      ||
                                                    'c.cd_pessoa_fisica,'                                                                     ||
                                                    'a.dt_contabil';

BEGIN
      
      document_vector := tax_dmed_ir_pck.run_dynamic_sql(document_vector, alternative_query_p => alternative_query, procedure_name_p => procedure_name_w);
      CALL tax_dmed_ir_pck.add_monthly_data(document_vector, 'S', procedure_name_w);
  END;

$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE tax_dmed_ir_pck.load_without_advances () FROM PUBLIC;