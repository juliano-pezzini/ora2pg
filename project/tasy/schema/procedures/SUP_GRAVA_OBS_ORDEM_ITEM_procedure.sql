-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE sup_grava_obs_ordem_item ( nr_ordem_compra_p bigint, nr_item_oci_p bigint, ds_observacao_p text) AS $body$
BEGIN

update	ordem_compra_item
set	ds_observacao = ds_observacao_p
where	nr_ordem_compra = nr_ordem_compra_p
and	nr_item_oci = nr_item_oci_p;

commit;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE sup_grava_obs_ordem_item ( nr_ordem_compra_p bigint, nr_item_oci_p bigint, ds_observacao_p text) FROM PUBLIC;

