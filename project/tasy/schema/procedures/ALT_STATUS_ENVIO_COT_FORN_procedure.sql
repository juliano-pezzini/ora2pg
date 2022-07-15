-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE alt_status_envio_cot_forn ( nr_cot_compra_p bigint, nm_usuario_p text) AS $body$
BEGIN

update	cot_compra_forn
set	ie_status_envio_email_lib = 'S',
	nm_usuario = nm_usuario_p
where	nr_cot_compra = nr_cot_compra_p;


commit;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE alt_status_envio_cot_forn ( nr_cot_compra_p bigint, nm_usuario_p text) FROM PUBLIC;

