-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';




CREATE OR REPLACE FUNCTION prescription_json_pck.get_lis_message_clob ( nr_prescricao_p bigint, dt_horario_p timestamp default null, nr_seq_prescr_p bigint default null) RETURNS text AS $body$
DECLARE

	ds_json_out_w		text;
	json_ris_w		philips_json;
	
BEGIN
	
	json_ris_w		:= prescription_json_pck.get_lis_message(nr_prescricao_p,dt_horario_p,nr_seq_prescr_p);
	
	if (coalesce(json_ris_w::text, '') = '') then
		return null;
	end if;
	
	dbms_lob.createtemporary( ds_json_out_w, true);
	json_ris_w.(ds_json_out_w);
	
	return ds_json_out_w;
	END;

$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON FUNCTION prescription_json_pck.get_lis_message_clob ( nr_prescricao_p bigint, dt_horario_p timestamp default null, nr_seq_prescr_p bigint default null) FROM PUBLIC;