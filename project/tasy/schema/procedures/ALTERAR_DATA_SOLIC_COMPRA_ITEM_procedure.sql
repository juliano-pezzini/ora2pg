-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE alterar_data_solic_compra_item (nr_solic_compra_p bigint, nr_item_solic_compra_p bigint, dt_solic_item_p timestamp, nm_usuario_p text) AS $body$
BEGIN

if (nr_solic_compra_p IS NOT NULL AND nr_solic_compra_p::text <> '') and (nr_item_solic_compra_p IS NOT NULL AND nr_item_solic_compra_p::text <> '') then
	update	solic_compra_item
	set	dt_solic_item = dt_solic_item_p
	where	nr_solic_compra = nr_solic_compra_p
	and	nr_item_solic_compra = nr_item_solic_compra_p;
end if;

commit;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE alterar_data_solic_compra_item (nr_solic_compra_p bigint, nr_item_solic_compra_p bigint, dt_solic_item_p timestamp, nm_usuario_p text) FROM PUBLIC;

