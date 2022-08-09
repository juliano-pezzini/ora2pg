-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE load_pilc_catalogue_temp ( cd_code_p text , ds_oec_desc_p text ) AS $body$
BEGIN
	
	insert into w_pilcload_proc( cd_code,
	ds_oec_description
	)
	values (
	cd_code_p,
	ds_oec_desc_p
	);
end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE load_pilc_catalogue_temp ( cd_code_p text , ds_oec_desc_p text ) FROM PUBLIC;
