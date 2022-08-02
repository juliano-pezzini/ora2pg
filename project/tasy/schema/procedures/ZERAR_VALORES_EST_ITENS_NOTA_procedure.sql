-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE zerar_valores_est_itens_nota ( nr_seq_nota_p bigint, nm_usuario_p text) AS $body$
BEGIN

if (nr_seq_nota_p IS NOT NULL AND nr_seq_nota_p::text <> '') then
	update	nota_fiscal_item
	set	vl_unitario_item_nf = 0,
		vl_total_item_nf = 0,
		vl_liquido = 0,
		vl_unit_estrangeiro  = NULL,
		vl_total_estrangeiro  = NULL,
		nm_usuario = nm_usuario_p
	where	nr_sequencia = nr_seq_nota_p;
end if;

commit;
end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE zerar_valores_est_itens_nota ( nr_seq_nota_p bigint, nm_usuario_p text) FROM PUBLIC;

