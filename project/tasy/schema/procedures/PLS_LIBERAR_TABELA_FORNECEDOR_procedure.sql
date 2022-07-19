-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE pls_liberar_tabela_fornecedor ( nr_seq_tabela_p bigint, ie_opcao_p text, nm_usuario_p text) AS $body$
DECLARE


/*
ie_opcao_p
D - Desfazer
L - Liberar
*/
qt_faixas_etarias_w	bigint;


BEGIN

if (ie_opcao_p	= 'L') then
	select	count(*)
	into STRICT	qt_faixas_etarias_w
	from	pls_fornecedor_fx_etaria	a,
		pls_fornecedor_preco		b
	where	b.nr_seq_faixa_etaria	= a.nr_sequencia
	and	a.nr_seq_tabela		= nr_seq_tabela_p;

	if (qt_faixas_etarias_w	> 0) then
		update	pls_fornecedor_tabela
		set	dt_liberacao		= clock_timestamp(),
			nm_usuario_liberacao	= nm_usuario_p,
			nm_usuario		= nm_usuario_p
		where	nr_sequencia		= nr_seq_tabela_p;
	else
		CALL wheb_mensagem_pck.exibir_mensagem_abort(262396);
		/* Mensagem: Tabela de preço sem informações de quantidades e valores de vida! Favor verificar. */

	end if;
elsif (ie_opcao_p	= 'D') then
	update	pls_fornecedor_tabela
	set	dt_liberacao		 = NULL,
		nm_usuario_liberacao	= '',
		nm_usuario		= nm_usuario_p
	where	nr_sequencia		= nr_seq_tabela_p;
end if;

commit;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE pls_liberar_tabela_fornecedor ( nr_seq_tabela_p bigint, ie_opcao_p text, nm_usuario_p text) FROM PUBLIC;

