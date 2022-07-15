-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE atualiza_cc_ordem_compra_item ( cd_centro_custo_p bigint, nr_ordem_compra_p bigint, nm_usuario_p text) AS $body$
BEGIN
	if (cd_centro_custo_p IS NOT NULL AND cd_centro_custo_p::text <> '') and (nr_ordem_compra_p IS NOT NULL AND nr_ordem_compra_p::text <> '')then
		update ordem_compra_item
		set    cd_centro_custo = cd_centro_custo_p
		where  nr_ordem_compra = nr_ordem_compra_p;
	end if;
commit;
end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE atualiza_cc_ordem_compra_item ( cd_centro_custo_p bigint, nr_ordem_compra_p bigint, nm_usuario_p text) FROM PUBLIC;

