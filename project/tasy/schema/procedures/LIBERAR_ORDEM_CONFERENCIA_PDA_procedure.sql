-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE liberar_ordem_conferencia_pda ( nr_ordem_compra_p bigint, nm_usuario_p text) AS $body$
BEGIN

update	ordem_compra_item_conf
set	dt_liberacao = clock_timestamp(),
	nm_usuario_liberacao = nm_usuario_p
where	nr_ordem_compra = nr_ordem_compra_p
and	coalesce(dt_liberacao::text, '') = ''
and	coalesce(dt_estorno::text, '') = ''
and 	(dt_selecao IS NOT NULL AND dt_selecao::text <> '');

commit;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE liberar_ordem_conferencia_pda ( nr_ordem_compra_p bigint, nm_usuario_p text) FROM PUBLIC;

