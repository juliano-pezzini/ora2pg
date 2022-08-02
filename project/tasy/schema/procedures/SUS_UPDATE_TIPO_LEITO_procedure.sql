-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE sus_update_tipo_leito (ds_tipo_leito_p text, cd_tipo_leito_p bigint, nm_usuario_p text) AS $body$
BEGIN

update	sus_tipo_leito_unif
set	ds_tipo_leito        	= ds_tipo_leito_p,
	dt_atualizacao 		= clock_timestamp(),
	nm_usuario     		= nm_usuario_p
where	cd_tipo_leito        	= cd_tipo_leito_p;

commit;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE sus_update_tipo_leito (ds_tipo_leito_p text, cd_tipo_leito_p bigint, nm_usuario_p text) FROM PUBLIC;

