-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE registrar_inspecao_receb_conf ( nr_ordem_compra_p bigint, nr_item_oci_p bigint, nr_seq_conf_p bigint, qt_inspecao_p bigint, dt_inicio_conferencia_p timestamp, nm_usuario_p text) AS $body$
BEGIN

update	ordem_compra_item_conf
set	qt_conferencia = qt_inspecao_p,
	dt_inicio_conferencia = dt_inicio_conferencia_p,
	dt_fim_conferencia = clock_timestamp(),
	nm_usuario_conferencia = nm_usuario_p
where	nr_ordem_compra = nr_ordem_compra_p
and	nr_item_oci = nr_item_oci_p
and	nr_sequencia = nr_seq_conf_p;

commit;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE registrar_inspecao_receb_conf ( nr_ordem_compra_p bigint, nr_item_oci_p bigint, nr_seq_conf_p bigint, qt_inspecao_p bigint, dt_inicio_conferencia_p timestamp, nm_usuario_p text) FROM PUBLIC;

