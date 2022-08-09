-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE grava_log_exportacao_entrega ( nr_sequencia_p bigint, nr_item_nf_p bigint, nr_ordem_compra_p bigint, nm_usuario_p text) AS $body$
BEGIN

update	ordem_compra_nota_fiscal
set	ie_status_exportar	= '1'
where	ie_status_exportar	= '0'
and	nr_sequencia		= nr_sequencia_p
and	nr_item_nf		= nr_item_nf_p
and	nr_ordem_compra	= nr_ordem_compra_p;

commit;
end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE grava_log_exportacao_entrega ( nr_sequencia_p bigint, nr_item_nf_p bigint, nr_ordem_compra_p bigint, nm_usuario_p text) FROM PUBLIC;
