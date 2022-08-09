-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE pls_vinc_prot_agrup_reemb ( nr_seq_protocolo_p bigint, nr_seq_lote_agrup_p bigint, ie_opcao_p text, nm_usuario_p text) AS $body$
BEGIN
if (coalesce(nr_seq_protocolo_p::text, '') = '') then
	--Não foi possível vincular o protocolo ao lote de agrupamento de pagamento. Não foi informado o número do protocolo.
	CALL wheb_mensagem_pck.exibir_mensagem_abort(306600);
elsif (coalesce(nr_seq_lote_agrup_p::text, '') = '' and ie_opcao_p = 'V') then
	--Não foi possível vincular o protocolo ao lote de agrupamento de pagamento. Não foi informado o número do lote.
	CALL wheb_mensagem_pck.exibir_mensagem_abort(306602);
elsif (ie_opcao_p = 'V') then

	update	pls_protocolo_conta
	set	nr_seq_lote_reemb_cred	= nr_seq_lote_agrup_p,
		nm_usuario		= nm_usuario_p,
		dt_atualizacao		= clock_timestamp()
	where	coalesce(nr_seq_lote_reemb_cred::text, '') = ''
	and	nr_sequencia		= nr_seq_protocolo_p;

elsif (ie_opcao_p = 'D') then

	update	pls_protocolo_conta
	set	nr_seq_lote_reemb_cred	 = NULL,
		nm_usuario		= nm_usuario_p,
		dt_atualizacao		= clock_timestamp()
	where	nr_sequencia		= nr_seq_protocolo_p;

else
	--Não foi possível vincular o protocolo ao lote de agrupamento de pagamento. Opção inválida: #@IE_OPCAO#@
	CALL wheb_mensagem_pck.exibir_mensagem_abort(306606,'IE_OPCAO='||ie_opcao_p||';');
end if;
end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE pls_vinc_prot_agrup_reemb ( nr_seq_protocolo_p bigint, nr_seq_lote_agrup_p bigint, ie_opcao_p text, nm_usuario_p text) FROM PUBLIC;
