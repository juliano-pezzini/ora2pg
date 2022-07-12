-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';




CREATE OR REPLACE FUNCTION tax_dmed_ir_pck.get_additional_items (item_sequence_p bigint) RETURNS GENERIC_TYPE AS $body$
DECLARE

      additional_items_vector generic_type;

BEGIN
      for i in current_setting('tax_dmed_ir_pck.additional_rule_vector')::additional_rule_reference.first..additional_rule_vector.last loop
          if current_setting('tax_dmed_ir_pck.additional_rule_vector')::additional_rule_reference[i].item_sequence = item_sequence_p then
              additional_items_vector := current_setting('tax_dmed_ir_pck.additional_rule_vector')::additional_rule_reference[i].additional_items;
              exit;
          end if;
      end loop;

      return additional_items_vector;
  END;

$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON FUNCTION tax_dmed_ir_pck.get_additional_items (item_sequence_p bigint) FROM PUBLIC;
