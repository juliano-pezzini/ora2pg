-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE pls_excluir_tabela_contrato ( nr_seq_tabela_p bigint, nm_usuario_p text) AS $body$
DECLARE


nr_seq_tabela_origem_w		bigint;


BEGIN

select	coalesce(max(nr_seq_tabela_origem),0)
into STRICT	nr_seq_tabela_origem_w
from	pls_tabela_preco
where	nr_sequencia	= nr_seq_tabela_p;

if (nr_seq_tabela_origem_w > 0) then
	delete	from pls_plano_preco
	where	nr_seq_tabela	= nr_seq_tabela_p;

	delete	from pls_tabela_preco
	where	nr_sequencia	= nr_seq_tabela_p;
end if;

commit;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE pls_excluir_tabela_contrato ( nr_seq_tabela_p bigint, nm_usuario_p text) FROM PUBLIC;

