-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE pls_salvar_log_tiss_webservice ( nr_seq_log_tiss_p INOUT pls_log_transacao_tiss.nr_sequencia%type, cd_prestador_p pls_log_transacao_tiss.cd_prestador%type, nr_cpf_p pls_log_transacao_tiss.nr_cpf%type, cd_cgc_p pls_log_transacao_tiss.cd_cgc%type, nr_seq_transacao_p pls_log_transacao_tiss.cd_cgc%type, ie_tipo_transacao_p pls_log_transacao_tiss.ie_tipo_transacao%type, ie_status_p pls_log_transacao_tiss.ie_status%type, cd_estabelecimento_p bigint, nm_usuario_p text) AS $body$
DECLARE

			 
nr_seq_prestador_w		pls_log_transacao_tiss.nr_seq_prestador%type;
cd_prestador_imp_w		pls_protocolo_conta_imp.cd_prestador_conv%type;
cd_prest_upper_conv_w	 	pls_protocolo_conta_imp.cd_prest_upper_conv%type;
cd_prest_number_conv_w	 	pls_protocolo_conta_imp.cd_prest_number_conv%type;
cd_cgc_prestador_conv_w 	pls_protocolo_conta_imp.cd_cgc_prestador_conv%type;
cd_cpf_prestador_conv_w		pls_protocolo_conta_imp.cd_cpf_prestador_conv%type;


BEGIN 
 
if (coalesce(nr_seq_log_tiss_p::text, '') = '') then 
 
	SELECT * FROM pls_conv_xml_cta_pck.obter_prestador_tasy('C', cd_prestador_p, cd_cgc_p, nr_cpf_p, cd_estabelecimento_p, null) INTO STRICT cd_prestador_imp_w, cd_prest_upper_conv_w, cd_prest_number_conv_w, cd_cgc_prestador_conv_w, cd_cpf_prestador_conv_w;
 
	insert into pls_log_transacao_tiss(	nr_sequencia,dt_atualizacao,nm_usuario,dt_atualizacao_nrec,nm_usuario_nrec, 
			nr_seq_prestador,cd_prestador,nr_cpf,cd_cgc,nr_seq_transacao, 
			dt_geracao,ie_tipo_transacao,ie_status) 
	values (	nextval('pls_log_transacao_tiss_seq'),clock_timestamp(),nm_usuario_p,clock_timestamp(),nm_usuario_p, 
			nr_seq_prestador_w,cd_prestador_p,nr_cpf_p,cd_cgc_p, 
			nr_seq_transacao_p,clock_timestamp(),ie_tipo_transacao_p,ie_status_p) 
	returning nr_sequencia into nr_seq_log_tiss_p;
else 
	update	pls_log_transacao_tiss 
	set	dt_resposta	= clock_timestamp(), 
		ie_status	= ie_status_p, 
		nm_usuario	= nm_usuario_p, 
		nm_usuario_nrec	= nm_usuario_p 
	where	nr_sequencia	= nr_seq_log_tiss_p;
end if;
 
commit;
 
end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE pls_salvar_log_tiss_webservice ( nr_seq_log_tiss_p INOUT pls_log_transacao_tiss.nr_sequencia%type, cd_prestador_p pls_log_transacao_tiss.cd_prestador%type, nr_cpf_p pls_log_transacao_tiss.nr_cpf%type, cd_cgc_p pls_log_transacao_tiss.cd_cgc%type, nr_seq_transacao_p pls_log_transacao_tiss.cd_cgc%type, ie_tipo_transacao_p pls_log_transacao_tiss.ie_tipo_transacao%type, ie_status_p pls_log_transacao_tiss.ie_status%type, cd_estabelecimento_p bigint, nm_usuario_p text) FROM PUBLIC;
