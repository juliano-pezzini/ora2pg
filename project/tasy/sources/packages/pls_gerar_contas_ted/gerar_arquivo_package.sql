-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';




CREATE OR REPLACE PROCEDURE pls_gerar_contas_ted.gerar_arquivo (nr_seq_lote_p pls_ted_conta_lote.nr_sequencia%type, ie_tipo_lote_p pls_ted_conta_lote.ie_tipo_lote%type, nm_usuario_p usuario.nm_usuario%type, cd_estabelecimento_p estabelecimento.cd_estabelecimento%type) AS $body$
BEGIN
	   if (ie_tipo_lote_p = '1') then
		CALL pls_gerar_contas_ted.dep_quimico_arquivo(nr_seq_lote_p, nm_usuario_p, cd_estabelecimento_p);
	elsif (ie_tipo_lote_p = '2') then
		CALL pls_gerar_contas_ted.acidente_trab_arquivo(nr_seq_lote_p, nm_usuario_p, cd_estabelecimento_p);
	elsif (ie_tipo_lote_p = '3') then
		CALL pls_gerar_contas_ted.med_ocupacional_arquivo(nr_seq_lote_p, nm_usuario_p, cd_estabelecimento_p);
	elsif (ie_tipo_lote_p = '4') then
		CALL pls_gerar_contas_ted.exchep_arquivo(nr_seq_lote_p, nm_usuario_p, cd_estabelecimento_p);
	end if;	
end;


$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE pls_gerar_contas_ted.gerar_arquivo (nr_seq_lote_p pls_ted_conta_lote.nr_sequencia%type, ie_tipo_lote_p pls_ted_conta_lote.ie_tipo_lote%type, nm_usuario_p usuario.nm_usuario%type, cd_estabelecimento_p estabelecimento.cd_estabelecimento%type) FROM PUBLIC;