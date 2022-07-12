-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';




CREATE OR REPLACE FUNCTION cpoe_diet_json_pck.get_diet_message (nr_cpoe_diet_p bigint, ie_order_control_p text, nr_entity_identifier_p bigint) RETURNS PHILIPS_JSON AS $body$
DECLARE

	json_return_w		philips_json;
	json_item_list_w   	philips_json_list;
	ie_tipo_dieta_w	cpoe_dieta.ie_tipo_dieta%type;
	ie_hl7_msg_type_w	varchar(3);
	
BEGIN
	
	select ie_tipo_dieta
	into STRICT ie_tipo_dieta_w
	from cpoe_dieta
	where nr_sequencia = nr_cpoe_diet_p;
	
	if (ie_tipo_dieta_w = 'J') then
		json_item_list_w	:= cpoe_diet_json_pck.get_fasting_times(nr_cpoe_diet_p);
		ie_hl7_msg_type_w := 'ORM';
	elsif (ie_tipo_dieta_w = 'O') then
		json_item_list_w	:= cpoe_diet_json_pck.get_oral_diet_times(nr_cpoe_diet_p);
		ie_hl7_msg_type_w := 'ORM';
	elsif (ie_tipo_dieta_w = 'E') then
		json_item_list_w	:= cpoe_diet_json_pck.get_enteral_diet_times(nr_cpoe_diet_p);
		ie_hl7_msg_type_w := 'OMP';
	elsif (ie_tipo_dieta_w = 'S') then
		json_item_list_w	:= cpoe_diet_json_pck.get_supplement_diet_times(nr_cpoe_diet_p);
		ie_hl7_msg_type_w := 'OMP';
	elsif (ie_tipo_dieta_w = 'L') then
		json_item_list_w	:= cpoe_diet_json_pck.get_milk_diet_times(nr_cpoe_diet_p);
		ie_hl7_msg_type_w := 'OMP';
	elsif (ie_tipo_dieta_w = 'P') then
		json_item_list_w	:= cpoe_diet_json_pck.get_npt_adult_diet_times(nr_cpoe_diet_p);
		ie_hl7_msg_type_w := 'OMP';
	end if;
	
	if (json_item_list_w.count > 0) then
		json_return_w	:= philips_json();
		json_return_w		:= cpoe_diet_json_pck.get_default_message(nr_cpoe_diet_p);
		json_return_w := cpoe_diet_json_pck.add_json_value(json_return_w, 'orderControl', ie_order_control_p);
		json_return_w := cpoe_diet_json_pck.add_json_value(json_return_w, 'entityidentifier', nr_entity_identifier_p);
		json_return_w := cpoe_diet_json_pck.add_json_value(json_return_w, 'hl7MsgType', ie_hl7_msg_type_w);
		
		json_return_w.put('dietList', json_item_list_w.to_json_value());
	end if;
	
	return json_return_w;
	
	END;

$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON FUNCTION cpoe_diet_json_pck.get_diet_message (nr_cpoe_diet_p bigint, ie_order_control_p text, nr_entity_identifier_p bigint) FROM PUBLIC;