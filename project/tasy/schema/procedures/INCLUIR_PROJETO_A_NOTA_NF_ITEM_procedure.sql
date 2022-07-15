-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE incluir_projeto_a_nota_nf_item ( nr_sequencia_p bigint, nr_seq_proj_rec_p bigint, nr_item_nf_p bigint, vl_projeto_p bigint, nm_usuario_p text) AS $body$
BEGIN
	update	nota_fiscal_item
	set	vl_projeto	= vl_projeto_p,
		nm_usuario	= nm_usuario_p,
		dt_atualizacao	= clock_timestamp(),
		nr_seq_proj_rec	= nr_seq_proj_rec_p
	where	nr_sequencia	= nr_sequencia_p
	and 	nr_item_nf	= nr_item_nf_p;

commit;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE incluir_projeto_a_nota_nf_item ( nr_sequencia_p bigint, nr_seq_proj_rec_p bigint, nr_item_nf_p bigint, vl_projeto_p bigint, nm_usuario_p text) FROM PUBLIC;

