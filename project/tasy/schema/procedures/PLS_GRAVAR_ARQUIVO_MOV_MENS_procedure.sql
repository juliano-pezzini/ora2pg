-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE pls_gravar_arquivo_mov_mens ( nr_seq_mov_operadora_p pls_mov_mens_operadora.nr_sequencia%type, ds_arquivo_p pls_mov_mens_operadora.ds_arquivo%type, nm_usuario_p usuario.nm_usuario%type) AS $body$
BEGIN

if (nr_seq_mov_operadora_p IS NOT NULL AND nr_seq_mov_operadora_p::text <> '') then
	update	pls_mov_mens_operadora
	set	ds_arquivo		= ds_arquivo_p,
		dt_atualizacao		= clock_timestamp(),
		nm_usuario		= nm_usuario_p
	where	nr_sequencia		= nr_seq_mov_operadora_p;
	
	commit;
end if;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE pls_gravar_arquivo_mov_mens ( nr_seq_mov_operadora_p pls_mov_mens_operadora.nr_sequencia%type, ds_arquivo_p pls_mov_mens_operadora.ds_arquivo%type, nm_usuario_p usuario.nm_usuario%type) FROM PUBLIC;
