-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE pls_atualizar_anexo_req_imp ( nr_seq_guia_plano_imp_p pls_guia_plano_imp.nr_sequencia%type, nr_seq_requisicao_p pls_requisicao.nr_sequencia%type, nm_usuario_p text) AS $body$
DECLARE

/* +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++ 
Finalidade: Atualizar a guia gerada no anexo de importação 
------------------------------------------------------------------------------------------------------------------- 
Locais de chamada direta: 
[ ] Objetos do dicionário [ ] Tasy (Delphi/Java) [ ] Portal [ ] Relatórios [ x] Outros: 
 ------------------------------------------------------------------------------------------------------------------ 
Pontos de atenção: 
++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++ */
 
 
C01 CURSOR(nr_seq_requisicao_pc		pls_requisicao.nr_sequencia%type) FOR		 
	SELECT	nr_sequencia, 
		cd_procedimento, 
		ie_origem_proced 
	from	pls_requisicao_proc 
	where	nr_seq_requisicao = nr_seq_requisicao_pc;
	
C02 CURSOR(nr_seq_requisicao_pc		pls_requisicao.nr_sequencia%type) FOR 
	SELECT	nr_sequencia,        
		cd_material, 
		nr_seq_material		 
	from	pls_requisicao_mat 
	where	nr_seq_requisicao = nr_seq_requisicao_pc;

--Cursor criado pois é possível ter mais de um registro quando é enviado mais de um anexo no TISS. 06/2016 hxafranski 
C03 CURSOR(nr_seq_guia_plano_imp_pc		pls_guia_plano_imp.nr_sequencia%type) FOR 
	SELECT	nr_sequencia, 
		nr_seq_lote_anexo 
	from	pls_lote_anexo_guias_imp 
	where	nr_seq_guia_plano_imp = nr_seq_guia_plano_imp_pc;
	
BEGIN 
 
for C03_w in C03(nr_seq_guia_plano_imp_p) loop 
	begin 
	--Atualiza a guia no lote de anexo 
	update	pls_lote_anexo_guias_imp 
	set	nr_seq_requisicao	= nr_seq_requisicao_p 
	where	nr_sequencia 		= C03_w.nr_sequencia;
	 
	--Atualizar a sequencia do procedimento da guia na tabela do anexo 
	for C01_w in C01(nr_seq_requisicao_p) loop 
		begin	 
			update 	pls_lote_anexo_proc_imp 
			set	nr_seq_req_proc 	= c01_w.nr_sequencia 
			where	cd_procedimento 	= c01_w.cd_procedimento 
			and	ie_origem_proced 	= c01_w.ie_origem_proced 
			and	nr_seq_lote_guia_imp	= C03_w.nr_sequencia;
		end;
	end loop;	
	commit;
	 
	--Atualizar a sequencia do material da guia na tabela do anexo 
	for C02_w in C02(nr_seq_requisicao_p) loop 
		begin	 
			update 	pls_lote_anexo_mat_imp 
			set	nr_seq_req_mat 		= C02_w.nr_sequencia 
			where	cd_material 		= C02_w.nr_seq_material 
			and	nr_seq_lote_guia_imp	= C03_w.nr_sequencia;
		end;
	end loop;	
	commit;
	 
	--Rotina utilizada para atualizar os campos no anexo da guia 
	CALL pls_gerar_solic_proc_anexo(C03_w.nr_seq_lote_anexo, nr_seq_requisicao_p, null, nm_usuario_p );
	end;
end loop;
 
end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE pls_atualizar_anexo_req_imp ( nr_seq_guia_plano_imp_p pls_guia_plano_imp.nr_sequencia%type, nr_seq_requisicao_p pls_requisicao.nr_sequencia%type, nm_usuario_p text) FROM PUBLIC;

