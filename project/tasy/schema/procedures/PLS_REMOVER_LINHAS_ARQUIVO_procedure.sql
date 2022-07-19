-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE pls_remover_linhas_arquivo (cd_funcao_p pls_linhas_arquivo.cd_funcao%type, nm_arquivo_p pls_linhas_arquivo.nm_arquivo%type, nm_usuario_p pls_linhas_arquivo.nm_usuario%type) AS $body$
BEGIN
	delete from 	pls_linhas_arquivo
	where 			cd_funcao = cd_funcao_p
					and nm_arquivo = nm_arquivo_p
					and  nm_usuario = nm_usuario_p;
commit;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE pls_remover_linhas_arquivo (cd_funcao_p pls_linhas_arquivo.cd_funcao%type, nm_arquivo_p pls_linhas_arquivo.nm_arquivo%type, nm_usuario_p pls_linhas_arquivo.nm_usuario%type) FROM PUBLIC;

