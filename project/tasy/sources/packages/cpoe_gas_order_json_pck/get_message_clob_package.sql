-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';




CREATE OR REPLACE FUNCTION cpoe_gas_order_json_pck.get_message_clob (nr_cpoe_gas_p bigint, ie_order_control_p text, nr_entity_identifier_p bigint) RETURNS text AS $body$
DECLARE

	ds_json_out_w		text;
	json_gas_w	philips_json;
	
	
BEGIN
		
	json_gas_w		:= cpoe_gas_order_json_pck.get_gas_message(nr_cpoe_gas_p, ie_order_control_p, nr_entity_identifier_p);
	
	if (coalesce(json_gas_w::text, '') = '') then
		return null;
	end if;
	
	dbms_lob.createtemporary( ds_json_out_w, true);
	json_gas_w.(ds_json_out_w);
	
	return ds_json_out_w;
	END;

$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON FUNCTION cpoe_gas_order_json_pck.get_message_clob (nr_cpoe_gas_p bigint, ie_order_control_p text, nr_entity_identifier_p bigint) FROM PUBLIC;
