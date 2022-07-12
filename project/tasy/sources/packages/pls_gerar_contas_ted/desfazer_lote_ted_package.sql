-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';




CREATE OR REPLACE PROCEDURE pls_gerar_contas_ted.desfazer_lote_ted ( nr_seq_lote_p pls_ted_conta_lote.nr_sequencia%type, nm_usuario_p usuario.nm_usuario%type, cd_estabelecimento_p estabelecimento.cd_estabelecimento%type ) AS $body$
BEGIN

 delete
   from pls_ted_conta_dados 
  where nr_seq_lote_ted_benef in (
            SELECT b.nr_sequencia 
              from pls_ted_conta_benef b 
             where nr_seq_lote_ted_cta = nr_seq_lote_p
			   and cd_estabelecimento = cd_estabelecimento_p
             )
	and cd_estabelecimento = cd_estabelecimento_p;

 delete
   from pls_ted_conta_benef
  where nr_seq_lote_ted_cta = nr_seq_lote_p
	and cd_estabelecimento = cd_estabelecimento_p;
	
 update pls_ted_conta_lote set
		vl_total_conta  = NULL,
		vl_total_reemb  = NULL,
		vl_total_geral  = NULL,
		ds_valor_extenso  = NULL
  where nr_sequencia = nr_seq_lote_p
	and cd_estabelecimento = cd_estabelecimento_p;

commit;	

END;							

$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE pls_gerar_contas_ted.desfazer_lote_ted ( nr_seq_lote_p pls_ted_conta_lote.nr_sequencia%type, nm_usuario_p usuario.nm_usuario%type, cd_estabelecimento_p estabelecimento.cd_estabelecimento%type ) FROM PUBLIC;
