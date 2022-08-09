-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE pls_copiar_itens_grupo_serv ( nr_seq_grupo_orig_p pls_preco_grupo_servico.nr_sequencia%type, nr_seq_grupo_dest_p pls_preco_grupo_servico.nr_sequencia%type, nm_usuario_p text) AS $body$
DECLARE

 
qt_grupo_w			integer;
nr_insert_index_w		integer;
tb_area_procedimento_w		dbms_sql.number_table;
tb_especialidade_w		dbms_sql.number_table;
tb_grupo_proc_w			dbms_sql.number_table;
tb_procedimento_w		dbms_sql.number_table;
tb_ie_estrutura_w		dbms_sql.varchar2_table;
tb_ie_origem_proced_w		dbms_sql.number_table;
tb_nr_seq_preco_servico_w	dbms_sql.number_table;
nr_seq_preco_servio_w		pls_preco_servico.nr_sequencia%type;
	
	C01 CURSOR(nr_seq_grupo_orig_pc	pls_preco_grupo_servico.nr_sequencia%type, 
			nr_seq_grupo_dest_pc	pls_preco_grupo_servico.nr_sequencia%type) FOR 
		SELECT	cd_area_procedimento,   
			cd_especialidade,     
			cd_grupo_proc,      
			cd_procedimento,     
			ie_estrutura,      
			ie_origem_proced 
		from	pls_preco_servico 
		where	nr_seq_grupo	= 	nr_seq_grupo_orig_pc 
		EXCEPT 
		SELECT	cd_area_procedimento,   
			cd_especialidade,     
			cd_grupo_proc,      
			cd_procedimento,     
			ie_estrutura,       
			ie_origem_proced 
		from	pls_preco_servico 
		where	nr_seq_grupo	= 	nr_seq_grupo_dest_pc;
BEGIN
 
if (nr_seq_grupo_orig_p IS NOT NULL AND nr_seq_grupo_orig_p::text <> '') and (nr_seq_grupo_dest_p IS NOT NULL AND nr_seq_grupo_dest_p::text <> '') then 
	select	count(1) 
	into STRICT	qt_grupo_w 
	from	pls_preco_grupo_servico 
	where	nr_sequencia	= nr_seq_grupo_dest_p;
	 
	if (qt_grupo_w	= 0) then 
		CALL wheb_mensagem_pck.exibir_mensagem_abort(331638);
	end if;
 
	tb_area_procedimento_w.delete;
	tb_especialidade_w.delete;
	tb_grupo_proc_w.delete;
	tb_procedimento_w.delete;
	tb_procedimento_w.delete;
	tb_ie_estrutura_w.delete;
	tb_ie_origem_proced_w.delete;
	tb_nr_seq_preco_servico_w.delete;
	nr_insert_index_w := 0;		
	for r_c01_w in C01(nr_seq_grupo_orig_p,nr_seq_grupo_dest_p) loop 
		begin 
		select	nextval('pls_preco_servico_seq') 
		into STRICT	nr_seq_preco_servio_w 
		;
		 
		tb_nr_seq_preco_servico_w(nr_insert_index_w)	:= nr_seq_preco_servio_w;
		tb_area_procedimento_w(nr_insert_index_w)	:= r_c01_w.cd_area_procedimento;
		tb_especialidade_w(nr_insert_index_w)		:= r_c01_w.cd_especialidade;
		tb_grupo_proc_w(nr_insert_index_w)		:= r_c01_w.cd_grupo_proc;
		tb_procedimento_w(nr_insert_index_w)		:= r_c01_w.cd_procedimento;
		tb_ie_estrutura_w(nr_insert_index_w)		:= r_c01_w.ie_estrutura;
		tb_ie_origem_proced_w(nr_insert_index_w)	:= r_c01_w.ie_origem_proced;
 
		if (nr_insert_index_w >= pls_util_cta_pck.qt_registro_transacao_w) then 
			forall i in tb_nr_seq_preco_servico_w.first..tb_nr_seq_preco_servico_w.last 
			insert into	pls_preco_servico(nr_sequencia, cd_area_procedimento,cd_especialidade, 
							 cd_grupo_proc, cd_procedimento,dt_atualizacao, 
							 dt_atualizacao_nrec,ie_estrutura, ie_origem_proced, 
							 nm_usuario, nm_usuario_nrec, nr_seq_grupo) 
					values (tb_nr_seq_preco_servico_w(i),tb_area_procedimento_w(i), tb_especialidade_w(i), 
							tb_grupo_proc_w(i),tb_procedimento_w(i), clock_timestamp(), 
							clock_timestamp(),tb_ie_estrutura_w(i), tb_ie_origem_proced_w(i), 
							nm_usuario_p,nm_usuario_p, nr_seq_grupo_dest_p);
			 
			 
			tb_area_procedimento_w.delete;
			tb_especialidade_w.delete;
			tb_grupo_proc_w.delete;
			tb_procedimento_w.delete;
			tb_procedimento_w.delete;
			tb_ie_estrutura_w.delete;
			tb_ie_origem_proced_w.delete;
			tb_nr_seq_preco_servico_w.delete;
			nr_insert_index_w := 0;		
			commit;
		else 
			nr_insert_index_w := nr_insert_index_w +1;
		end if;
		 
		end;
	end loop;
	 
	if (tb_nr_seq_preco_servico_w.count > 0) then 
		 
		forall i in tb_nr_seq_preco_servico_w.first..tb_nr_seq_preco_servico_w.last 
			insert into	pls_preco_servico(nr_sequencia, cd_area_procedimento,cd_especialidade, 
							 cd_grupo_proc, cd_procedimento,dt_atualizacao, 
							 dt_atualizacao_nrec,ie_estrutura, ie_origem_proced, 
							 nm_usuario, nm_usuario_nrec, nr_seq_grupo) 
					values (tb_nr_seq_preco_servico_w(i),tb_area_procedimento_w(i), tb_especialidade_w(i), 
							tb_grupo_proc_w(i),tb_procedimento_w(i), clock_timestamp(), 
							clock_timestamp(),tb_ie_estrutura_w(i), tb_ie_origem_proced_w(i), 
							nm_usuario_p,nm_usuario_p, nr_seq_grupo_dest_p);
	end if;
	 
	commit;
end if;
 
end 	;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE pls_copiar_itens_grupo_serv ( nr_seq_grupo_orig_p pls_preco_grupo_servico.nr_sequencia%type, nr_seq_grupo_dest_p pls_preco_grupo_servico.nr_sequencia%type, nm_usuario_p text) FROM PUBLIC;
