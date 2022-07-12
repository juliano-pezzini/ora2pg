-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';




CREATE OR REPLACE FUNCTION person_json_pck.get_consession_card ( cd_pessoa_fisica_p text) RETURNS PHILIPS_JSON_LIST AS $body$
DECLARE

	
	json_card_w		philips_json;
	json_card_list_w	philips_json_list;
	
	C01 CURSOR FOR
		SELECT	a.nr_sequencia,
			a.cd_con_card_type,
			a.dt_validity_start,
			a.dt_validity_end,
			a.nr_con_card,
			b.ds_hl7_identifier,
			b.ds_hl7_authority
		from	person_concession a,
			concession_card_types b
		where	a.cd_con_card_type = b.nr_sequencia
		and	a.cd_pessoa_fisica = cd_pessoa_fisica_p
		and	fim_dia(coalesce(a.dt_validity_end,clock_timestamp())) >= clock_timestamp();
	
BEGIN
	json_card_list_w := philips_json_list();
	
	for r_c01 in c01 loop
		begin
		json_card_w :=  philips_json();
		json_card_w := person_json_pck.add_json_value(json_card_w, 'internalId', r_c01.nr_sequencia);
		json_card_w := person_json_pck.add_json_value(json_card_w, 'cardCodeInternalId', r_c01.cd_con_card_type);
		json_card_w := person_json_pck.add_json_value(json_card_w, 'cardNumber', r_c01.nr_con_card);
		json_card_w := person_json_pck.add_json_value(json_card_w, 'effectiveDate', r_c01.dt_validity_start);
		json_card_w := person_json_pck.add_json_value(json_card_w, 'expirationDate', r_c01.dt_validity_end);
		json_card_w := person_json_pck.add_json_value(json_card_w, 'hl7Identifier', r_c01.ds_hl7_identifier);
		json_card_w := person_json_pck.add_json_value(json_card_w, 'hl7Authority', r_c01.ds_hl7_authority);
		json_card_list_w.append(json_card_w.to_json_value());
		
		end;
	end loop;
	
	
	return json_card_list_w;
	
	END;

$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON FUNCTION person_json_pck.get_consession_card ( cd_pessoa_fisica_p text) FROM PUBLIC;