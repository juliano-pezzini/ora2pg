-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE pls_finalizar_requisicao_web (nr_seq_requisicao_p pls_requisicao.nr_sequencia%Type, nm_usuario_p text) AS $body$
DECLARE

 
/* +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++ 
Finalidade: 	Setar o campo ie_req_web_finalizada para "S" quando a guia for finalizada no portal 
------------------------------------------------------------------------------------------------------------------- 
Locais de chamada direta: 
[ ] Objetos do dicionário [ ] Tasy (Delphi/Java) [ X ] Portal [ ] Relatórios [ ] Outros: 
 ------------------------------------------------------------------------------------------------------------------ 
++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++ */
 

BEGIN 
	update pls_requisicao 
	set ie_req_web_finalizada = 'S' 
	where nr_sequencia = nr_seq_requisicao_p;
 
	commit;
 
	CALL pls_gerar_alerta_evento(8, 
				null, 
				nr_seq_requisicao_p, 
				null, 
				nm_usuario_p);
 
end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE pls_finalizar_requisicao_web (nr_seq_requisicao_p pls_requisicao.nr_sequencia%Type, nm_usuario_p text) FROM PUBLIC;

