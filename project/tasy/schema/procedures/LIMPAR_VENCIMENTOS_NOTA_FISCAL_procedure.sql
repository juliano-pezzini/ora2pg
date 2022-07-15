-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE limpar_vencimentos_nota_fiscal ( nr_seq_nota_fiscal_p bigint, nm_usuario_p text) AS $body$
BEGIN

if (nr_seq_nota_fiscal_p IS NOT NULL AND nr_seq_nota_fiscal_p::text <> '') then
begin

	delete
	from	nota_fiscal_venc_trib
	where	nr_sequencia	= nr_seq_nota_fiscal_p;

	delete
	from	nota_fiscal_venc
	where	nr_sequencia	= nr_seq_nota_fiscal_p;

	commit;

end;

end if;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE limpar_vencimentos_nota_fiscal ( nr_seq_nota_fiscal_p bigint, nm_usuario_p text) FROM PUBLIC;

