-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE lic_gerar_analise_recurso ( nr_sequencia_p bigint, dt_aceito_p timestamp, nm_usuario_p text) AS $body$
BEGIN

update	reg_lic_item_recurso
set	dt_aceito		= dt_aceito_p,
	nm_usuario_analise	= nm_usuario_p
where	nr_sequencia	= nr_sequencia_p;

commit;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE lic_gerar_analise_recurso ( nr_sequencia_p bigint, dt_aceito_p timestamp, nm_usuario_p text) FROM PUBLIC;

