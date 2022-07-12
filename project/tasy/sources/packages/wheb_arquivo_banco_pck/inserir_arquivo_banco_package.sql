-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';




CREATE OR REPLACE PROCEDURE wheb_arquivo_banco_pck.inserir_arquivo_banco ( nm_tabela_p text, nr_sequencia_p bigint, nm_arquivo_p text, nm_usuario_p text) AS $body$
DECLARE

	f_lob		bytea;
	b_lob		bytea;
	nr_sequencia_w	bigint;

	
BEGIN
	if ((trim(both nm_tabela_p) IS NOT NULL AND (trim(both nm_tabela_p))::text <> '')) then
		if (nm_tabela_p = 'PESSOA_DOCUMENTACAO') then
				select	coalesce(max(nr_sequencia),0)
				into STRICT	nr_sequencia_w
				from	arquivo_tasy
				where	nr_seq_pessoa_documentacao = nr_sequencia_p;

			if (nr_sequencia_w = 0) then
				insert into arquivo_tasy(
					nr_sequencia,
					nm_usuario,
					dt_atualizacao,
					nm_arquivo,
					ds_conteudo_arquivo,
					nr_seq_pessoa_documentacao)
				values (
					nextval('arquivo_tasy_seq'),
					nm_usuario_p,
					clock_timestamp(),
					nm_arquivo_p,
					'',
					nr_sequencia_p)
				return;
			else
				update	arquivo_tasy
				set	ds_conteudo_arquivo = '',
					nm_arquivo = nm_arquivo_p,
					nm_usuario = nm_usuario_p,
					dt_atualizacao = clock_timestamp()
				where	nr_seq_pessoa_documentacao = nr_sequencia_p
				return;
			end if;
		end if;

		f_lob := bfilename( 'ARQUIVOS_TASY', nm_arquivo_p);
		dbms_lob.fileopen(f_lob, dbms_lob.file_readonly);
		dbms_lob.loadfromfile( b_lob, f_lob, octet_length(f_lob) );
		dbms_lob.fileclose(f_lob);
		commit;
	end if;
	end;


$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE wheb_arquivo_banco_pck.inserir_arquivo_banco ( nm_tabela_p text, nr_sequencia_p bigint, nm_arquivo_p text, nm_usuario_p text) FROM PUBLIC;
