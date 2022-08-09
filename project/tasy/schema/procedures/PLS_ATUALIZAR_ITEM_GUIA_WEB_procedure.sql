-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE pls_atualizar_item_guia_web ( nr_seq_item_p bigint, qt_autorizada_p bigint, ie_status_p text, nm_usuario_p text, ie_tipo_item_p text) AS $body$
BEGIN

if (ie_tipo_item_p = 'P') then
	update	pls_guia_plano_proc
	set	ie_status		= CASE WHEN ie_status_p='A' THEN 'P' WHEN ie_status_p='N' THEN 'M' END ,
		dt_atualizacao		= clock_timestamp(),
		dt_liberacao		= clock_timestamp(),
		qt_autorizada		= qt_autorizada_p,
		nm_usuario		= nm_usuario_p
	where	nr_sequencia		= nr_seq_item_p;

elsif (ie_tipo_item_p = 'M') then
	update	pls_guia_plano_mat
	set	qt_autorizada		= qt_autorizada_p,
		ie_status 		= CASE WHEN ie_status_p='A' THEN 'P' WHEN ie_status_p='N' THEN 'M' END ,
		dt_atualizacao		= clock_timestamp(),
		dt_liberacao		= clock_timestamp(),
		nm_usuario		= nm_usuario_p
	where	nr_sequencia 		= nr_seq_item_p;
end if;

commit;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE pls_atualizar_item_guia_web ( nr_seq_item_p bigint, qt_autorizada_p bigint, ie_status_p text, nm_usuario_p text, ie_tipo_item_p text) FROM PUBLIC;
