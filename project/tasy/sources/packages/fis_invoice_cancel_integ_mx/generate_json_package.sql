-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';




CREATE OR REPLACE PROCEDURE fis_invoice_cancel_integ_mx.generate_json ( nr_seq_nota_p nota_fiscal.nr_sequencia%type, nm_usuario_p usuario.nm_usuario%type, cd_estabelecimento_p estabelecimento.cd_estabelecimento%type, nr_seq_transmissao_p nfe_transmissao.nr_sequencia%type, nr_seq_log_integracao_p text, json_p INOUT text) AS $body$
DECLARE

		
		json_w text;

	
BEGIN
	
		json_w := '{ "event" : 168, "nrSeqInvoice" : '|| nr_seq_nota_p ||', "nrSeqIntegrationLog" : '
		|| nr_seq_log_integracao_p||', "nrSeqTransmission" : '|| nr_seq_transmissao_p
		||', "cdEstablishment" : '|| cd_estabelecimento_p ||', "nmUser" : "'|| nm_usuario_p 
		||'", "nrSeqInvoiceLot" : 0, "cdProfile" : '|| obter_setor_usuario(nm_usuario_p) || ' }';
		
		json_p := json_w;
	end;
	
	

$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE fis_invoice_cancel_integ_mx.generate_json ( nr_seq_nota_p nota_fiscal.nr_sequencia%type, nm_usuario_p usuario.nm_usuario%type, cd_estabelecimento_p estabelecimento.cd_estabelecimento%type, nr_seq_transmissao_p nfe_transmissao.nr_sequencia%type, nr_seq_log_integracao_p text, json_p INOUT text) FROM PUBLIC;