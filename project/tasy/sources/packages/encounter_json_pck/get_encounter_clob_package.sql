-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';




CREATE OR REPLACE FUNCTION encounter_json_pck.get_encounter_clob ( nr_atendimento_p bigint) RETURNS text AS $body$
DECLARE

	ds_json_out_w	text;
	json_encounter_w		philips_json;
	
BEGIN
	
	json_encounter_w		:= encounter_json_pck.get_encounter(nr_atendimento_p);
	dbms_lob.createtemporary( ds_json_out_w, true);
	json_encounter_w.(ds_json_out_w);
	
	return ds_json_out_w;
	END;

$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON FUNCTION encounter_json_pck.get_encounter_clob ( nr_atendimento_p bigint) FROM PUBLIC;
