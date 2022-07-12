-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';




CREATE OR REPLACE PROCEDURE tax_dmed_ir_pck.load_account_losses () AS $body$
DECLARE

      procedure_name_w varchar(20) := 'TaxDmed6';
      document_vector    response_reference;
      alternative_query  varchar(4000) := 'select a.nr_sequencia document_sequence,'                                                     ||
                                                  'd.cd_pessoa_fisica responsible_code,'                                                  ||
                                                  'd.cd_pessoa_fisica beneficiary_code,'                                                  ||
                                                  'sum(b.vl_baixa) total_amount,'                                                         ||
                                                  'max(0) interest_amount,'                                                               ||
                                                  'max(0) fine_amount,'                                                                   ||
                                                  'max(0) gloss_amount,'                                                                  ||
                                                  'max(0) credit_note_amount,'                                                            ||
                                                  'max(0) trading_fee_amount, '                                                           ||
                                                  'max(0) higher_amount,'                                                                 ||
                                                  'b.dt_baixa date_document,'                                                             ||
                                                  'max(0) attendance_code,'                                                               ||
                                                  'max(null) refund_provider_pf,'                                                         ||
                                                  'max(null) refund_provider_pj,'                                                         ||
                                                  'min(null) data_code,'                                                                  ||
                                                  'max(0) additional_index,'                                                              ||
						                                      'min(null) item_value'                                                                  ||
                                            ' from perda_contas_receber a,'                                                               ||
                                                  'perda_contas_receb_baixa b,'                                                           ||
                                                  'fin_tipo_baixa_perda c,'                                                               ||
                                                  'pessoa_fisica d'                                                                       ||
                                          ' where a.nr_sequencia = b.nr_seq_perda'                                                        ||
                                          ' and a.cd_pessoa_fisica = d.cd_pessoa_fisica'                                                  ||
                                          ' and b.nr_seq_tipo_baixa = c.nr_sequencia'                                                     ||
                                          ' and a.cd_estabelecimento = ' || reference_establishment                                       ||
                                          ' and c.ie_tipo_consistencia in (0, 3)'                                                         ||
                                          ' and b.vl_baixa > 0'                                                                           ||
                                          ' and b.dt_baixa between tax_dmed_ir_pck.get_initial_date() and tax_dmed_ir_pck.get_final_date()'   ||
                                          ' and tax_dmed_ir_pck.exists_low_reversal(a.nr_sequencia, b.nr_sequencia) = 0'                  ||
                                          ' group by a.nr_sequencia,'                                                                     ||
                                                    'd.cd_pessoa_fisica,'                                                                 ||
                                                    'b.dt_baixa';

BEGIN
      document_vector := tax_dmed_ir_pck.run_dynamic_sql(document_vector, alternative_query_p => alternative_query, procedure_name_p => procedure_name_w);
      CALL tax_dmed_ir_pck.add_monthly_data(document_vector, 'S', procedure_name_w);
  END;

$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE tax_dmed_ir_pck.load_account_losses () FROM PUBLIC;