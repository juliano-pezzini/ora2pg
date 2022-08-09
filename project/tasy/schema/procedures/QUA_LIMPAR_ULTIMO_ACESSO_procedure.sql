-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE qua_limpar_ultimo_acesso ( nr_sequencia_p bigint, ie_opcao_p text, nm_usuario_p text) AS $body$
DECLARE


/* ie_opcao_p
DQ: Documento qualidade
NC: Não conformidade
*/
nr_seq_doc_log_w	bigint;
nr_seq_nc_leitura_w	bigint;


BEGIN

/* Limpar acesso do usuário no documento da qualidade */

if (ie_opcao_p = 'DQ') then
	begin
	select	max(a.nr_sequencia)
	into STRICT	nr_seq_doc_log_w
	from	qua_doc_log_acesso a
	where	a.nr_seq_doc	= nr_sequencia_p
	and	a.nm_usuario	= nm_usuario_p;

	update	qua_doc_log_acesso
	set	dt_leitura		 = NULL,
		dt_atualizacao	= clock_timestamp(),
		nm_usuario		= nm_usuario_p
	where	nr_sequencia		= nr_seq_doc_log_w;
	end;
elsif (ie_opcao_p = 'NC') then
	begin
	select	max(a.nr_sequencia)
	into STRICT	nr_seq_nc_leitura_w
	from	qua_nao_conform_leitura a
	where	a.nr_seq_nao_conform	= nr_sequencia_p
	and	a.nm_usuario_acesso	= nm_usuario_p;

	update	qua_nao_conform_leitura
	set	dt_acesso	   = NULL,
		dt_atualizacao  = clock_timestamp()
	where	nr_sequencia	  = nr_seq_nc_leitura_w;
	end;
end if;

END;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE qua_limpar_ultimo_acesso ( nr_sequencia_p bigint, ie_opcao_p text, nm_usuario_p text) FROM PUBLIC;
