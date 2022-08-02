-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE pls_proposta_online_html5 ( ie_opcao_p text, nr_seq_prop_online_p pls_proposta_online.nr_sequencia%type, ds_observacao_p pls_proposta_hist_online.ds_historico%type, ds_email_p text, ds_reservado2_p text, ds_reservado3_p text, ds_reservado4_p text, ds_reservado5_p text, ds_reservado6_p text, ds_reservado7_p text, nm_usuario_p usuario.nm_usuario%type, cd_estabelecimento_p estabelecimento.cd_estabelecimento%type) AS $body$
DECLARE


/*
ie_opcao_p
H	Solicitar complemento ao usuario
C	Solicitar avaliação de CPT
*/
BEGIN

if (ie_opcao_p = 'H') then
	CALL hpms_proposal_request_pck.wsuite_return_user(nr_seq_prop_online_p, ds_observacao_p, ds_email_p, nm_usuario_p, cd_estabelecimento_p);		
elsif (ie_opcao_p = 'C') then
	CALL hpms_proposal_request_pck.wsuite_request_review_cpt(nr_seq_prop_online_p, ds_observacao_p, nm_usuario_p, cd_estabelecimento_p);
end if;

commit;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE pls_proposta_online_html5 ( ie_opcao_p text, nr_seq_prop_online_p pls_proposta_online.nr_sequencia%type, ds_observacao_p pls_proposta_hist_online.ds_historico%type, ds_email_p text, ds_reservado2_p text, ds_reservado3_p text, ds_reservado4_p text, ds_reservado5_p text, ds_reservado6_p text, ds_reservado7_p text, nm_usuario_p usuario.nm_usuario%type, cd_estabelecimento_p estabelecimento.cd_estabelecimento%type) FROM PUBLIC;

