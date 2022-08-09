-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE liberar_ordem_me ( nr_ordem_compra_p bigint, ie_liberar_ordem_p text, nm_usuario_p text) AS $body$
BEGIN
 
if (ie_liberar_ordem_p = 'S') then 
	CALL Gerar_Aprov_Ordem_Compra(nr_ordem_compra_p, null, 'S', nm_usuario_p);
elsif (ie_liberar_ordem_p = 'A') then 
	update	ordem_compra_item 
	set	dt_aprovacao		= clock_timestamp(), 
		dt_aprovacao_orig		= clock_timestamp() 
	where	nr_ordem_compra		= nr_ordem_compra_p 
	and	coalesce(dt_aprovacao::text, '') = '';
 
	update	ordem_compra 
	set	dt_aprovacao		= clock_timestamp(), 
		dt_liberacao		= clock_timestamp(), 
		nm_usuario_lib		= nm_usuario_p 
	where	nr_ordem_compra		= nr_ordem_compra_p 
	and	coalesce(dt_aprovacao::text, '') = '';
end if;
 
end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE liberar_ordem_me ( nr_ordem_compra_p bigint, ie_liberar_ordem_p text, nm_usuario_p text) FROM PUBLIC;
