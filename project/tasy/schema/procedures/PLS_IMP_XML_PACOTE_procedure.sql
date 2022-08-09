-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE pls_imp_xml_pacote ( ie_opcao_p text, ie_tipo_registro_p text, ds_linha_p text, nm_usuario_p usuario.nm_usuario%type, nr_seq_lote_p INOUT pls_imp_lote_pacote.nr_sequencia%type) AS $body$
DECLARE


nr_seq_lote_w		pls_imp_lote_pacote.nr_sequencia%type;

/*	ie_opcao_p
C - Criar lote
I - Insere registros lidos do arquivo
G - Gerar pacotes
*/
BEGIN

nr_seq_lote_w := nr_seq_lote_p;

if (ie_opcao_p = 'C') then
	nr_seq_lote_w := pls_imp_xml_pacote_pck.criar_lote_importacao(nm_usuario_p, nr_seq_lote_w);

elsif (ie_opcao_p = 'I') then
	CALL pls_imp_xml_pacote_pck.incluir_linha_xml(ie_tipo_registro_p, ds_linha_p, nr_seq_lote_w);

elsif (ie_opcao_p = 'G') then
	CALL pls_imp_xml_pacote_pck.gerar_pacotes(nr_seq_lote_w, nm_usuario_p);

elsif (ie_opcao_p = 'L') then
	CALL pls_imp_xml_pacote_pck.limpar_tabela_temp(nr_seq_lote_w);

elsif (ie_opcao_p = 'E') then
	CALL pls_imp_xml_pacote_pck.exclui_lote_importacao(nr_seq_lote_w);

end if;

nr_seq_lote_p := nr_seq_lote_w;

commit;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE pls_imp_xml_pacote ( ie_opcao_p text, ie_tipo_registro_p text, ds_linha_p text, nm_usuario_p usuario.nm_usuario%type, nr_seq_lote_p INOUT pls_imp_lote_pacote.nr_sequencia%type) FROM PUBLIC;
