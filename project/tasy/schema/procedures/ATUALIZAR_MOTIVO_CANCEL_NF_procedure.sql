-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE atualizar_motivo_cancel_nf ( nr_seq_nota_fiscal_p bigint, nr_seq_motivo_cancel_p bigint, ds_observacao_p text, nm_usuario_p text) AS $body$
BEGIN

if (nr_seq_nota_fiscal_p IS NOT NULL AND nr_seq_nota_fiscal_p::text <> '') then
begin

	update	nota_fiscal
	set	nr_seq_motivo_cancel =	nr_seq_motivo_cancel_p,
		ds_observacao        =	substr(ds_observacao || ds_observacao_p,1,4000)
	where	nr_sequencia         =	nr_seq_nota_fiscal_p;

	commit;

end;

end if;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE atualizar_motivo_cancel_nf ( nr_seq_nota_fiscal_p bigint, nr_seq_motivo_cancel_p bigint, ds_observacao_p text, nm_usuario_p text) FROM PUBLIC;
