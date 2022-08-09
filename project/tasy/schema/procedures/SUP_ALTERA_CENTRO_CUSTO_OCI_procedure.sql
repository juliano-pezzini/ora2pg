-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE sup_altera_centro_custo_oci ( nr_ordem_compra_p bigint, cd_centro_custo_p bigint, nm_usuario_p text) AS $body$
BEGIN
	if (nr_ordem_compra_p IS NOT NULL AND nr_ordem_compra_p::text <> '') and (cd_centro_custo_p IS NOT NULL AND cd_centro_custo_p::text <> '') then
		update	ordem_compra_item
		set	cd_centro_custo = cd_centro_custo_p
		where	nr_ordem_compra = nr_ordem_compra_p;
	end if;
end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE sup_altera_centro_custo_oci ( nr_ordem_compra_p bigint, cd_centro_custo_p bigint, nm_usuario_p text) FROM PUBLIC;
