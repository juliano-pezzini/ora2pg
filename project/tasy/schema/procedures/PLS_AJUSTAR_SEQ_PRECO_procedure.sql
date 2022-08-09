-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE pls_ajustar_seq_preco () AS $body$
DECLARE


nr_seq_segurado_preco_w		bigint;
qt_idade_w			bigint;
nr_seq_tabela_w			bigint;
nr_seq_preco_w			bigint;

C01 CURSOR FOR
	SELECT	b.nr_sequencia,
		b.qt_idade,
		a.nr_seq_tabela
	from	pls_segurado a,
		pls_segurado_preco b
	where	a.nr_sequencia	= b.nr_seq_segurado
	and	coalesce(b.nr_seq_preco::text, '') = '';


BEGIN

open C01;
loop
fetch C01 into
	nr_seq_segurado_preco_w,
	qt_idade_w,
	nr_seq_tabela_w;
EXIT WHEN NOT FOUND; /* apply on C01 */
	begin
	select	max(nr_sequencia)
	into STRICT	nr_seq_preco_w
	from	pls_plano_preco
	where	nr_seq_tabela	= nr_seq_tabela_w
	and	qt_idade_w between qt_idade_inicial and qt_idade_final;

	if (coalesce(nr_seq_preco_w,0) <> 0) then
		update	pls_segurado_preco
		set	nr_seq_preco	= nr_seq_preco_w,
			nm_usuario	= 'Tasy'
		where	nr_sequencia	= nr_seq_segurado_preco_w;
	end if;

	end;
end loop;
close C01;

commit;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE pls_ajustar_seq_preco () FROM PUBLIC;
