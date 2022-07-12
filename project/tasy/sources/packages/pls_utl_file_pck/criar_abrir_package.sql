-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';


-- Criar e abrir o arquivo
CREATE OR REPLACE PROCEDURE pls_utl_file_pck.criar_abrir ( ds_local_p text, nm_arquivo_p text, ie_acao_p text, qt_tamanho_max_linha_p bigint) AS $body$
BEGIN

begin
-- Criar e abrir o arquivo texto por UTL_FILE dentro do diret? reconhecido pelo ORACLE
ds_arquivo_w := utl_file.fopen( ds_local_p, nm_arquivo_p, ie_acao_p, qt_tamanho_max_linha_p);
exception
when others then
	-- Retornar o erro gerado
	nr_seq_erro_w := pls_utl_file_pck.obter_erro_utl(SQLSTATE);
end;

-- Caso tenha erro na cria? ou na abertura do arquivo por UTL_FILE, barrar o processo
CALL pls_utl_file_pck.tratar_erro( null, nr_seq_erro_w);

END;

$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE pls_utl_file_pck.criar_abrir ( ds_local_p text, nm_arquivo_p text, ie_acao_p text, qt_tamanho_max_linha_p bigint) FROM PUBLIC;
