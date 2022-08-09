-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE pls_gera_canc_lote_guia_tiss ( nr_seq_lote_cancel_p pls_guia_plano_lote_cancel.nr_sequencia%type, cd_estabelecimento_p estabelecimento.cd_estabelecimento%type, nm_usuario_p text) AS $body$
DECLARE

			
			
/* +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
Finalidade: Gerar o cancelamento da guias e das contas do TISS a partir da versao 4 
++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++ */
ie_tipo_cancelamento_w pls_guia_plano_lote_cancel.ie_tipo_lote_cancelamento%type;


BEGIN

select 	max(ie_tipo_lote_cancelamento)
into STRICT	ie_tipo_cancelamento_w
from 	pls_guia_plano_lote_cancel
where 	nr_sequencia = nr_seq_lote_cancel_p;

if (ie_tipo_cancelamento_w = 'L') then
	CALL pls_gera_canc_cta_lote_imp_xml(nr_seq_lote_cancel_p, cd_estabelecimento_p, nm_usuario_p);
	
elsif (ie_tipo_cancelamento_w = 'G') then
	CALL pls_gera_canc_cta_guia_imp_xml(nr_seq_lote_cancel_p, cd_estabelecimento_p, nm_usuario_p);
end if;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE pls_gera_canc_lote_guia_tiss ( nr_seq_lote_cancel_p pls_guia_plano_lote_cancel.nr_sequencia%type, cd_estabelecimento_p estabelecimento.cd_estabelecimento%type, nm_usuario_p text) FROM PUBLIC;
