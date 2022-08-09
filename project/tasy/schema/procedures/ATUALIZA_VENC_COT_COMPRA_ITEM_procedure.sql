-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE atualiza_venc_cot_compra_item ( nr_seq_fornecedor_p bigint, nr_seq_item_forn_p bigint, nm_usuario_p text) AS $body$
BEGIN

if (nr_seq_item_forn_p = 0) then
	begin

	update	cot_compra_item
	set	nr_seq_cot_item_forn  = NULL,
		nm_usuario = nm_usuario_p,
		dt_atualizacao = clock_timestamp()
	where	nr_seq_cot_item_forn in (SELECT	nr_sequencia
					from	cot_compra_forn_item
					where	nr_seq_cot_forn = nr_seq_fornecedor_p);

	end;
else
	begin

	update	cot_compra_item
	set	nr_seq_cot_item_forn  = NULL,
		nm_usuario = nm_usuario_p,
		dt_atualizacao = clock_timestamp()
	where	nr_seq_cot_item_forn = nr_seq_item_forn_p;

	end;
end if;

commit;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE atualiza_venc_cot_compra_item ( nr_seq_fornecedor_p bigint, nr_seq_item_forn_p bigint, nm_usuario_p text) FROM PUBLIC;
