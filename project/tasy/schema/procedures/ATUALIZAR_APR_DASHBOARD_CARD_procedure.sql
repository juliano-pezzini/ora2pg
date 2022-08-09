-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE atualizar_apr_dashboard_card ( nr_seq_card_p bigint, ie_view_mode_p text, nm_usuario_p text ) AS $body$
BEGIN

	update	dashboard_cards
	set	nm_usuario = nm_usuario_p,
		dt_atualizacao = clock_timestamp(),
		ie_view_mode = ie_view_mode_p
	where	nr_sequencia = nr_seq_card_p;

commit;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE atualizar_apr_dashboard_card ( nr_seq_card_p bigint, ie_view_mode_p text, nm_usuario_p text ) FROM PUBLIC;
