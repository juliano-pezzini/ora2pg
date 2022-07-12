-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';




CREATE OR REPLACE FUNCTION medical_net_pck.process_edifact_unb (edifact_message_p text) RETURNS R_GET_UNB AS $body$
DECLARE


	json_response_w	philips_json;
	ds_sender_w	varchar(50);
	ds_receptor_w	varchar(50);
	r_unb_w		r_get_unb;

	
BEGIN
	$if dbms_db_version.version >= 12 $then
	SELECT	edifact.sender, edifact.receptor
	INTO STRICT	ds_sender_w, ds_receptor_w
	FROM	JSON_TABLE(edifact_message_p, '$'
	COLUMNS(
	NESTED PATH '$.EDIFACT'
		COLUMNS(
		NESTED	PATH '$.UNB'
			COLUMNS(
				sender VARCHAR2(100) PATH '$."3"',
				receptor VARCHAR2(100) PATH '$."4"'
			)
		)
	)
	) AS edifact;

	r_unb_w.sender	:=	ds_sender_w;
	r_unb_w.receiver:=	ds_receptor_w;
	$end
	return r_unb_w;
	END;

$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON FUNCTION medical_net_pck.process_edifact_unb (edifact_message_p text) FROM PUBLIC;
