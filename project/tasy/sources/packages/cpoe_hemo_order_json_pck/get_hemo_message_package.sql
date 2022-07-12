-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';




CREATE OR REPLACE FUNCTION cpoe_hemo_order_json_pck.get_hemo_message (nr_cpoe_hemo_p bigint, ie_order_control_p text, nr_entity_identifier_p bigint) RETURNS PHILIPS_JSON AS $body$
DECLARE

	json_return_w		philips_json;
	json_item_list_w   	philips_json_list;
	ie_hl7_msg_type_w	varchar(3);
  ie_tipo_hemoterap_w   cpoe_hemoterapia.ie_tipo_hemoterap%type;
	
BEGIN
	
  select ie_tipo_hemoterap
  into STRICT ie_tipo_hemoterap_w
  from cpoe_hemoterapia
  where nr_sequencia = nr_cpoe_hemo_p;

  if (ie_tipo_hemoterap_w = 0) then
    ie_hl7_msg_type_w := 'OMP';
  elsif (ie_tipo_hemoterap_w = 1) then
    ie_hl7_msg_type_w := 'ORM';
  end if;

  json_item_list_w	:= cpoe_hemo_order_json_pck.get_hemo_data(nr_cpoe_hemo_p);
	
	if (json_item_list_w.count > 0) then
		json_return_w	:= philips_json();
		json_return_w		:= cpoe_hemo_order_json_pck.get_default_message(nr_cpoe_hemo_p);
		json_return_w := cpoe_hemo_order_json_pck.add_json_value(json_return_w, 'orderControl', ie_order_control_p);
		json_return_w := cpoe_hemo_order_json_pck.add_json_value(json_return_w, 'entityidentifier', nr_entity_identifier_p);
		json_return_w := cpoe_hemo_order_json_pck.add_json_value(json_return_w, 'hl7MsgType', ie_hl7_msg_type_w);
		
		json_return_w.put('hemoList', json_item_list_w.to_json_value());
	end if;
	
	return json_return_w;
	
	END;

$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON FUNCTION cpoe_hemo_order_json_pck.get_hemo_message (nr_cpoe_hemo_p bigint, ie_order_control_p text, nr_entity_identifier_p bigint) FROM PUBLIC;
