-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE pls_desapropiar_gerar_tit_pgto (nr_seq_pag_prest_p pls_pagamento_prestador.nr_sequencia%type, nr_seq_vencimento_p pls_pag_prest_vencimento.nr_sequencia%type, nm_usuario_p text) AS $body$
DECLARE

 
/* +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++ 
Finalidade: Desapropriar o vencimento do próximo pgto e gerar o título a receber para o mesmo. 
------------------------------------------------------------------------------------------------------------------- 
Locais de chamada direta: 
[ ] Objetos do dicionário [X] Tasy (Delphi/Java) [ ] Portal [ ] Relatórios [ ] Outros: 
 ------------------------------------------------------------------------------------------------------------------ 
Pontos de atenção: 
++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++ */
 	 
 

BEGIN 
if (nr_seq_pag_prest_p IS NOT NULL AND nr_seq_pag_prest_p::text <> '') and (nr_seq_vencimento_p IS NOT NULL AND nr_seq_vencimento_p::text <> '') then 
	CALL pls_desapropriar_proximo_pag(nr_seq_vencimento_p, nm_usuario_p, 'N');
	 
	CALL pls_gerar_titulo_venc_lote_pag(nr_seq_pag_prest_p, nm_usuario_p);
	 
	commit;
end if;
 
end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE pls_desapropiar_gerar_tit_pgto (nr_seq_pag_prest_p pls_pagamento_prestador.nr_sequencia%type, nr_seq_vencimento_p pls_pag_prest_vencimento.nr_sequencia%type, nm_usuario_p text) FROM PUBLIC;
