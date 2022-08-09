-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE pls_vincular_benef_html ( nr_seq_mov_benef_p pls_mov_mens_benef.nr_sequencia%type, nr_seq_segurado_p pls_segurado.nr_sequencia%type, nm_usuario_p usuario.nm_usuario%type, cd_estabelecimento_p estabelecimento.cd_estabelecimento%type, ie_opcao_p text) AS $body$
DECLARE


/*	ie_opcao_p
	'T'	= Gerar Mensalidade
*/
BEGIN

if (ie_opcao_p = 'T') then
	CALL pls_mov_mens_receb_pck.vincular_beneficiario(nr_seq_mov_benef_p, nr_seq_segurado_p, nm_usuario_p, cd_estabelecimento_p);
end if;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE pls_vincular_benef_html ( nr_seq_mov_benef_p pls_mov_mens_benef.nr_sequencia%type, nr_seq_segurado_p pls_segurado.nr_sequencia%type, nm_usuario_p usuario.nm_usuario%type, cd_estabelecimento_p estabelecimento.cd_estabelecimento%type, ie_opcao_p text) FROM PUBLIC;
