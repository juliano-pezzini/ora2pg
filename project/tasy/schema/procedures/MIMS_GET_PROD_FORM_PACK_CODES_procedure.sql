-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE mims_get_prod_form_pack_codes (CD_SISTEMA_ANT_P text, PRODCODE_P INOUT bigint, FORMCODE_P INOUT bigint, PACKCODE_P INOUT bigint) AS $body$
DECLARE

	
	cd_temp_w material.cd_sistema_ant%type;


BEGIN

	cd_temp_w := substr(CD_SISTEMA_ANT_P, position('.' in CD_SISTEMA_ANT_P) + 1);
	PRODCODE_P := substr(CD_SISTEMA_ANT_P, 0, position('.' in CD_SISTEMA_ANT_P) - 1);
	FORMCODE_P := substr(cd_temp_w, 0, position('.' in cd_temp_w) - 1);
	PACKCODE_P := substr(cd_temp_w, position('.' in cd_temp_w) + 1);

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE mims_get_prod_form_pack_codes (CD_SISTEMA_ANT_P text, PRODCODE_P INOUT bigint, FORMCODE_P INOUT bigint, PACKCODE_P INOUT bigint) FROM PUBLIC;

