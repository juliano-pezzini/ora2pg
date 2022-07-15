-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE env_integr_solic_compra ( nr_solic_compra_p bigint, nm_usuario_p text) AS $body$
BEGIN
 
update	solic_compra 
set	ie_forma_exportar = '0', 
	nm_usuario = nm_usuario_p 
where	nr_solic_compra = nr_solic_compra_p;
 
commit;
 
end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE env_integr_solic_compra ( nr_solic_compra_p bigint, nm_usuario_p text) FROM PUBLIC;

