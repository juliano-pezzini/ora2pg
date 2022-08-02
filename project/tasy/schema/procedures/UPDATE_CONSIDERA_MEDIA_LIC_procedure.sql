-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE update_considera_media_lic ( nr_sequencia_p bigint, ie_considera_p text, ds_motivo_desconsiderar_p text) AS $body$
BEGIN

update	cot_compra_forn_item
set	ie_considera_media_lic = ie_considera_p,
	ds_motivo_desconsiderar = ds_motivo_desconsiderar_p
where	nr_sequencia = nr_sequencia_p;

commit;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE update_considera_media_lic ( nr_sequencia_p bigint, ie_considera_p text, ds_motivo_desconsiderar_p text) FROM PUBLIC;

