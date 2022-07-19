-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE pls_liberar_execucao_negada ( nr_seq_execucao_p bigint, nm_usuario_p text, cd_estabelecimento_p bigint) AS $body$
DECLARE

 
/* +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++ 
Finalidade: 
Liberar a execução negada pela Gestão de análise > Consulta requisição/guia > Consulta execução 
------------------------------------------------------------------------------------------------------------------- 
Locais de chamada direta: 
[ ] Objetos do dicionário [ x] Tasy (Delphi/Java) [  ] Portal [ ] Relatórios [ ] Outros: 
 ------------------------------------------------------------------------------------------------------------------ 
Pontos de atenção: 
++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++ */
 
		 
nr_seq_segurado_w		pls_segurado.nr_sequencia%type;
nr_seq_prestador_w		pls_prestador.nr_sequencia%type;
nr_seq_lote_exec_w		pls_lote_execucao_req.nr_sequencia%type;


BEGIN 
 
update	pls_execucao_req_item 
set	ie_situacao		= 'P', 
	dt_atualizacao		= clock_timestamp(), 
	nm_usuario		= nm_usuario_p 
where	nr_seq_execucao		= nr_seq_execucao_p;
 
begin 
	select	b.nr_seq_segurado, 
		a.nr_seq_prestador, 
		a.nr_seq_lote_exec 
	into STRICT	nr_seq_segurado_w, 
		nr_seq_prestador_w, 
		nr_seq_lote_exec_w 
	from	pls_execucao_req_item	b, 
		pls_execucao_requisicao	a 
	where	b.nr_seq_execucao 	= a.nr_sequencia 
	and	b.nr_seq_execucao 	= nr_seq_execucao_p 
	group 	by	a.nr_seq_lote_exec, 
			b.nr_seq_segurado, 
			a.nr_seq_prestador;
exception 
when others then 
	nr_seq_segurado_w	:= null;
	nr_seq_prestador_w	:= null;
	nr_seq_lote_exec_w	:= null;
end;
 
CALL pls_gerar_guia_requisicao_lote(	nr_seq_lote_exec_w, nr_seq_segurado_w, nr_seq_prestador_w, 
				nm_usuario_p, 'L', cd_estabelecimento_p, 
				null, null, null, 
				null, null);
 
commit;
 
end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE pls_liberar_execucao_negada ( nr_seq_execucao_p bigint, nm_usuario_p text, cd_estabelecimento_p bigint) FROM PUBLIC;

