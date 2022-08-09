-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE pls_recalcular_copartic ( nr_seq_lote_recalc_p pls_recalc_copartic_lote.nr_sequencia%type, cd_estabelecimento_p estabelecimento.cd_estabelecimento%type, nm_usuario_p usuario.nm_usuario%type) AS $body$
DECLARE

 
/* +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++ 
Finalidade: Gerar o lote de recálculo de coparticipação. 
------------------------------------------------------------------------------------------------------------------- 
Locais de chamada direta: 
[ ] Objetos do dicionário [X] Tasy (Delphi/Java) [ ] Portal [ ] Relatórios [ ] Outros: 
 ------------------------------------------------------------------------------------------------------------------ 
Pontos de atenção: 
++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++ */
 	 
 

BEGIN 
 
 
CALL pls_recalcular_copartic_pck.pls_recalcular_copartic(	nr_seq_lote_recalc_p, 
							cd_estabelecimento_p, 
							nm_usuario_p);
							 
update	pls_recalc_copartic_lote 
set	dt_geracao 		= clock_timestamp(), 
	nm_usuario_geracao 	= nm_usuario_p 
where	nr_sequencia 		= nr_seq_lote_recalc_p;	
 
commit;
 
end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE pls_recalcular_copartic ( nr_seq_lote_recalc_p pls_recalc_copartic_lote.nr_sequencia%type, cd_estabelecimento_p estabelecimento.cd_estabelecimento%type, nm_usuario_p usuario.nm_usuario%type) FROM PUBLIC;
