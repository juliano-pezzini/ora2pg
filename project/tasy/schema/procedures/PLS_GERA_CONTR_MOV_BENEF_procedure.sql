-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE pls_gera_contr_mov_benef ( nr_seq_lote_p bigint, ie_opcao_p text, nm_usuario_p text, cd_estabelecimento_p bigint) AS $body$
DECLARE


/*
G	Gerar contratação
C	Consistir
D	Desfazer
*/
					

BEGIN

if (ie_opcao_p = 'G') then
	pls_mov_benef_imp_pck.gerar_contratacao(nr_seq_lote_p, nm_usuario_p, cd_estabelecimento_p);
elsif (ie_opcao_p = 'C') then
	CALL pls_mov_benef_imp_pck.consistir_lote(nr_seq_lote_p, nm_usuario_p, cd_estabelecimento_p);
elsif (ie_opcao_p = 'D') then
	CALL pls_mov_benef_imp_pck.desfazer_lote(nr_seq_lote_p, nm_usuario_p, cd_estabelecimento_p);
end if;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE pls_gera_contr_mov_benef ( nr_seq_lote_p bigint, ie_opcao_p text, nm_usuario_p text, cd_estabelecimento_p bigint) FROM PUBLIC;

