-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';




CREATE OR REPLACE PROCEDURE pls_int_xml_cta_pck.pls_atu_situacao_lote_prot ( nr_seq_lote_protocolo_p pls_lote_protocolo_conta.nr_sequencia%type, cd_estabelecimento_p estabelecimento.cd_estabelecimento%type, nm_usuario_p usuario.nm_usuario%type) AS $body$
BEGIN

--Carrega os par_metros para realizar as devidas consist_ncias

CALL CALL CALL CALL CALL CALL pls_int_xml_cta_pck.carrega_parametros(	cd_estabelecimento_p);

--Atualiza a PLS_PROTOCOLO_CONTA_IMP para INTEGRADO

CALL pls_int_xml_cta_pck.atualiza_protocolo_conta_imp(	nr_seq_lote_protocolo_p, cd_estabelecimento_p, nm_usuario_p);

--Atualiza os dadas da PLS_PROTOCOLO_CONTA e passa o status para INTEGRADO

CALL pls_int_xml_cta_pck.atualiza_protocolo_conta(	nr_seq_lote_protocolo_p, cd_estabelecimento_p, nm_usuario_p);

--Atualiza dados lote protocolo

CALL pls_int_xml_cta_pck.atualiza_dados_lote_protocolo(	nr_seq_lote_protocolo_p, nm_usuario_p);

--Gerar o resumo da conta conforme par_metro

if (current_setting('pls_int_xml_cta_pck.ie_analise_conta_w')::pls_param_importacao_conta.ie_analise_conta%type = 'S' ) then
	CALL CALL pls_int_xml_cta_pck.gerar_resumo_conta(	nr_seq_lote_protocolo_p, cd_estabelecimento_p, nm_usuario_p);
end if;

--Atualiza Data final de gera__o da conta

CALL pls_int_xml_cta_pck.atualiza_data_final_conta(	nr_seq_lote_protocolo_p, cd_estabelecimento_p, nm_usuario_p);

--Atualiza valores do protocolo

CALL CALL pls_int_xml_cta_pck.atualiza_valores_protocolo(	nr_seq_lote_protocolo_p, nm_usuario_p);

--Gerar comunica__o interna dos protocolos

CALL pls_int_xml_cta_pck.gerar_comunicacao_interna(	nr_seq_lote_protocolo_p, cd_estabelecimento_p, nm_usuario_p);

--Gerar an_lise do lote de protocolo

CALL pls_int_xml_cta_pck.gerar_analise_lote_protocolo(	nr_seq_lote_protocolo_p, cd_estabelecimento_p, nm_usuario_p);

END;

$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE pls_int_xml_cta_pck.pls_atu_situacao_lote_prot ( nr_seq_lote_protocolo_p pls_lote_protocolo_conta.nr_sequencia%type, cd_estabelecimento_p estabelecimento.cd_estabelecimento%type, nm_usuario_p usuario.nm_usuario%type) FROM PUBLIC;
