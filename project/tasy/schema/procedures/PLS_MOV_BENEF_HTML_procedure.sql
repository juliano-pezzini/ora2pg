-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE pls_mov_benef_html ( nr_seq_lote_p pls_mov_benef_lote.nr_sequencia%type, ie_opcao_p text, nm_usuario_p usuario.nm_usuario%type, cd_estabelecimento_p estabelecimento.cd_estabelecimento%type) AS $body$
DECLARE


/*
ie_opcao_p
G	Gerar
D	Desfazer
*/
BEGIN

if (ie_opcao_p = 'G') then
	CALL pls_mov_benef_pck.gerar_lote_mov_benef(nr_seq_lote_p, nm_usuario_p, cd_estabelecimento_p);
elsif (ie_opcao_p = 'D') then
	CALL pls_mov_benef_pck.desfazer_lote_mov_benef(nr_seq_lote_p, nm_usuario_p, cd_estabelecimento_p);
end if;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE pls_mov_benef_html ( nr_seq_lote_p pls_mov_benef_lote.nr_sequencia%type, ie_opcao_p text, nm_usuario_p usuario.nm_usuario%type, cd_estabelecimento_p estabelecimento.cd_estabelecimento%type) FROM PUBLIC;

