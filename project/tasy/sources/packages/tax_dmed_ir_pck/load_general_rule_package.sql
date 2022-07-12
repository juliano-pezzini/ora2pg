-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';




CREATE OR REPLACE PROCEDURE tax_dmed_ir_pck.load_general_rule () AS $body$
DECLARE

    temp_item_vector      generic_type;
    parent_establishment  tax_dmed_lote.cd_estabelecimento%type;

BEGIN 
    select  nr_seq_lote,
            trunc(dt_referencia)
    into STRICT    current_setting('tax_dmed_ir_pck.batch_sequence')::tax_dmed_lote.nr_sequencia%type,
            current_setting('tax_dmed_ir_pck.reference_date')::tax_dmed_lote_mensal.dt_referencia%type
    from    tax_dmed_lote_mensal
    where   nr_sequencia = current_setting('tax_dmed_ir_pck.batch_monthly_sequence')::tax_dmed_lote_mensal.nr_sequencia%type;

    select  cd_estabelecimento
    into STRICT    parent_establishment
    from    tax_dmed_lote
    where   nr_sequencia = current_setting('tax_dmed_ir_pck.batch_sequence')::tax_dmed_lote.nr_sequencia%type;

    select  e.*
    bulk collect into STRICT current_setting('tax_dmed_ir_pck.establishment_vector')::establishment_type
    from    estabelecimento e
    where   coalesce(e.ie_gerar_dmed, 'N') <> 'S' 
    and     obter_empresa_estab(parent_establishment) = e.cd_empresa;

    select  coalesce(max(ie_juros_multa),'N'), coalesce(max(ie_considerar_ca_pj),'N'), coalesce(max(ie_entrada_unica), 'N') bulk collect
    into STRICT    current_setting('tax_dmed_ir_pck.general_rule_vector')::general_rule_reference 
    from    tax_dmed_regras_gerais
    where   nr_seq_lote = current_setting('tax_dmed_ir_pck.batch_sequence')::tax_dmed_lote.nr_sequencia%type;

    select  coalesce(max(ie_a_maior),'N'), coalesce(max(ie_glosa),'N'), coalesce(max(ie_nota_credito),'N'), coalesce(max(ie_taxa_negociacao),'N') bulk collect
    into STRICT    current_setting('tax_dmed_ir_pck.low_value_type_rule_vector')::low_value_type_rule_reference 
    from    tax_dmed_rg_tp_baixa_tit
    where   nr_seq_lote = current_setting('tax_dmed_ir_pck.batch_sequence')::tax_dmed_lote.nr_sequencia%type;

    current_setting('tax_dmed_ir_pck.origin_protocol_rule_vector')::generic_type := tax_dmed_ir_pck.bulk_collect('tax_dmed_reg_origem_prot', 'ie_origem_protocolo', current_setting('tax_dmed_ir_pck.batch_sequence')::tax_dmed_lote.nr_sequencia%type, current_setting('tax_dmed_ir_pck.origin_protocol_rule_vector')::generic_type);
    current_setting('tax_dmed_ir_pck.billing_form_rule_vector')::generic_type := tax_dmed_ir_pck.bulk_collect('tax_dmed_rg_forma_cobranca', 'nr_seq_forma_cobranca', current_setting('tax_dmed_ir_pck.batch_sequence')::tax_dmed_lote.nr_sequencia%type, current_setting('tax_dmed_ir_pck.billing_form_rule_vector')::generic_type);
    current_setting('tax_dmed_ir_pck.refund_reason_rule_vector')::generic_type := tax_dmed_ir_pck.bulk_collect('tax_dmed_reg_mot_reembolso', 'nr_seq_mot_reembolso', current_setting('tax_dmed_ir_pck.batch_sequence')::tax_dmed_lote.nr_sequencia%type, current_setting('tax_dmed_ir_pck.refund_reason_rule_vector')::generic_type);
    current_setting('tax_dmed_ir_pck.receipt_type_rule_vector')::generic_type := tax_dmed_ir_pck.bulk_collect('tax_dmed_regra_tipo_rec', 'cd_tipo_recebimento', current_setting('tax_dmed_ir_pck.batch_sequence')::tax_dmed_lote.nr_sequencia%type, current_setting('tax_dmed_ir_pck.receipt_type_rule_vector')::generic_type);
    current_setting('tax_dmed_ir_pck.type_payable_rule_vector')::generic_type := tax_dmed_ir_pck.bulk_collect('tax_dmed_regra_tipo_pag', 'cd_tipo_pagamento', current_setting('tax_dmed_ir_pck.batch_sequence')::tax_dmed_lote.nr_sequencia%type, current_setting('tax_dmed_ir_pck.type_payable_rule_vector')::generic_type);
    current_setting('tax_dmed_ir_pck.origin_rule_vector')::generic_type := tax_dmed_ir_pck.bulk_collect('tax_dmed_regra_origem_tit', 'cd_origem_titulo', current_setting('tax_dmed_ir_pck.batch_sequence')::tax_dmed_lote.nr_sequencia%type, current_setting('tax_dmed_ir_pck.origin_rule_vector')::generic_type);
    current_setting('tax_dmed_ir_pck.class_rule_vector')::generic_type := tax_dmed_ir_pck.bulk_collect('tax_dmed_regra_classe_tit', 'nr_seq_classe', current_setting('tax_dmed_ir_pck.batch_sequence')::tax_dmed_lote.nr_sequencia%type, current_setting('tax_dmed_ir_pck.class_rule_vector')::generic_type);
    current_setting('tax_dmed_ir_pck.attend_sector_rule_vector')::generic_type := tax_dmed_ir_pck.bulk_collect('tax_dmed_regra_setor_aten', 'cd_setor_atendimento', current_setting('tax_dmed_ir_pck.batch_sequence')::tax_dmed_lote.nr_sequencia%type, current_setting('tax_dmed_ir_pck.attend_sector_rule_vector')::generic_type);
    current_setting('tax_dmed_ir_pck.item_type_rule_vector')::generic_type := tax_dmed_ir_pck.bulk_collect('tax_dmed_regra_tipo_item', 'nr_tipo_item', current_setting('tax_dmed_ir_pck.batch_sequence')::tax_dmed_lote.nr_sequencia%type, current_setting('tax_dmed_ir_pck.item_type_rule_vector')::generic_type);
    current_setting('tax_dmed_ir_pck.benef_type_rule_vector')::generic_type := tax_dmed_ir_pck.bulk_collect('tax_dmed_regra_tipo_benef', 'ie_tipo_beneficiario', current_setting('tax_dmed_ir_pck.batch_sequence')::tax_dmed_lote.nr_sequencia%type, current_setting('tax_dmed_ir_pck.benef_type_rule_vector')::generic_type);
    current_setting('tax_dmed_ir_pck.cont_type_rule_vector')::generic_type := tax_dmed_ir_pck.bulk_collect('tax_dmed_regra_tp_contrat', 'ie_tipo_contrato', current_setting('tax_dmed_ir_pck.batch_sequence')::tax_dmed_lote.nr_sequencia%type, current_setting('tax_dmed_ir_pck.cont_type_rule_vector')::generic_type);

	  if (tax_dmed_ir_pck.is_empty('I') <> 1) then
      for i in current_setting('tax_dmed_ir_pck.item_type_rule_vector')::generic_type.first .. current_setting('tax_dmed_ir_pck.item_type_rule_vector')::generic_type.last loop	
          temp_item_vector := tax_dmed_ir_pck.bulk_collect('tax_dmed_reg_tp_item_adic', 'nr_tipo_lanc_adic', tax_dmed_ir_pck.get_sequence_monthly_payment(current_setting('tax_dmed_ir_pck.item_type_rule_vector')::generic_type(i)), temp_item_vector, cloister_name_p => 'nr_seq_dmed_item');
          current_setting('tax_dmed_ir_pck.additional_rule_vector')::additional_rule_reference[i].item_sequence := current_setting('tax_dmed_ir_pck.item_type_rule_vector')::generic_type(i);
          current_setting('tax_dmed_ir_pck.additional_rule_vector')::additional_rule_reference[i].additional_items := temp_item_vector;
          temp_item_vector.delete();
      end loop;

      for j in current_setting('tax_dmed_ir_pck.item_type_rule_vector')::generic_type.first .. current_setting('tax_dmed_ir_pck.item_type_rule_vector')::generic_type.last loop	
          temp_item_vector := tax_dmed_ir_pck.bulk_collect('tax_dmed_reg_tp_cent_aprop', 'nr_seq_centro_apropriacao', tax_dmed_ir_pck.get_sequence_monthly_payment(current_setting('tax_dmed_ir_pck.item_type_rule_vector')::generic_type(j)), temp_item_vector, cloister_name_p => 'nr_seq_dmed_item');
          current_setting('tax_dmed_ir_pck.approp_center_rule_vector')::approp_center_rule_reference[j].item_sequence := current_setting('tax_dmed_ir_pck.item_type_rule_vector')::generic_type(j);
          current_setting('tax_dmed_ir_pck.approp_center_rule_vector')::approp_center_rule_reference[j].additional_items := temp_item_vector;
          temp_item_vector.delete();
      end loop;
    end if;

    CALL tax_dmed_ir_pck.load_standard_model();

  END;

$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE tax_dmed_ir_pck.load_general_rule () FROM PUBLIC;