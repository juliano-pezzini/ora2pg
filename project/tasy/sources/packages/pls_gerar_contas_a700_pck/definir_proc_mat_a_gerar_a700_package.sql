-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';


/*------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------*/




CREATE OR REPLACE PROCEDURE pls_gerar_contas_a700_pck.definir_proc_mat_a_gerar_a700 ( nm_usuario_p usuario.nm_usuario%type, cd_estabelecimento_p estabelecimento.cd_estabelecimento%type ) AS $body$
DECLARE
	
/* ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
Finalidade: Rotina responsavel por:
		* Gerar procedimentos e materiais;
		* Atualizar dados das contas e notas de cobranca.
+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++ */
 	

-- Variaveis table

nr_seq_conta_w		dbms_sql.number_table;
nr_seq_nota_cobranca_w	dbms_sql.number_table;
vl_proc_imp_table_w	dbms_sql.number_table;
vl_mat_imp_table_w	dbms_sql.number_table;
ie_tipo_guia_table_w	dbms_sql.varchar2_table;
			
-- Outras variaveis			

ie_tipo_guia_tiss_w	pls_conta.ie_tipo_guia%type;
vl_procedimento_imp_w	pls_conta_proc.vl_procedimento_imp%type;
vl_material_imp_w	pls_conta_mat.vl_material_imp%type;
i			integer;		
			
C01 CURSOR FOR
	SELECT	nr_seq_conta,
		nr_seq_nota_cobranca
	from	pls_aux_contas_cobr;

BEGIN

i := 1;
	
for r_C01_w in C01 loop	
	CALL pls_gerar_contas_a700_pck.gerar_proc_mat_a700(r_C01_w.nr_seq_conta, r_C01_w.nr_seq_nota_cobranca, nm_usuario_p, cd_estabelecimento_p);
	
	-- Obtem o tipo de guia que sera a conta gerada

	pls_obter_guia_tiss(r_C01_w.nr_seq_conta, ie_tipo_guia_tiss_w);
	
	-- Atualiza valores da conta

	CALL pls_atualiza_valor_conta(r_C01_w.nr_seq_conta, nm_usuario_p);
	
	-- Armazena o valor de todos os procedimentos importados gerados para a conta 

	select	sum(vl_procedimento_imp)
	into STRICT	vl_procedimento_imp_w
	from	pls_conta_proc
	where	nr_seq_conta = r_C01_w.nr_seq_conta;
	
	-- Armazena o valor de todos os materiais importados gerados para a conta 

	select	sum(vl_material_imp)
	into STRICT	vl_material_imp_w
	from	pls_conta_mat
	where	nr_seq_conta = r_C01_w.nr_seq_conta;
	
	nr_seq_conta_w(i)		:= r_C01_w.nr_seq_conta;
	nr_seq_nota_cobranca_w(i)	:= r_C01_w.nr_seq_nota_cobranca;
	vl_proc_imp_table_w(i)		:= vl_procedimento_imp_w;
	vl_mat_imp_table_w(i)		:= vl_material_imp_w;
	ie_tipo_guia_table_w(i)		:= ie_tipo_guia_tiss_w;		
	
	if (i >= current_setting('pls_gerar_contas_a700_pck.qt_registro_transacao_w')::integer) then
		-- Atualiza dados das contas e notas de cobranca

		CALL pls_gerar_contas_a700_pck.atualizar_conta_nota_cobr_a700(nr_seq_conta_w, nr_seq_nota_cobranca_w, vl_proc_imp_table_w, vl_mat_imp_table_w, ie_tipo_guia_table_w);
				
		-- Limpa as variaveis table

		nr_seq_conta_w.delete;
		nr_seq_nota_cobranca_w.delete;
		vl_proc_imp_table_w.delete;
		vl_mat_imp_table_w.delete;
		ie_tipo_guia_table_w.delete;
		
		i := 1;
	else
		i := i + 1;
	end if;		
end loop;

-- Caso sobre algum item dentro das variaveis table, estes tambem precisam ser atualizadas

CALL pls_gerar_contas_a700_pck.atualizar_conta_nota_cobr_a700(nr_seq_conta_w, nr_seq_nota_cobranca_w, vl_proc_imp_table_w, vl_mat_imp_table_w, ie_tipo_guia_table_w);

-- Limpa as variaveis table

nr_seq_conta_w.delete;
nr_seq_nota_cobranca_w.delete;
vl_proc_imp_table_w.delete;
vl_mat_imp_table_w.delete;
ie_tipo_guia_table_w.delete;

commit;

END;

$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE pls_gerar_contas_a700_pck.definir_proc_mat_a_gerar_a700 ( nm_usuario_p usuario.nm_usuario%type, cd_estabelecimento_p estabelecimento.cd_estabelecimento%type ) FROM PUBLIC;