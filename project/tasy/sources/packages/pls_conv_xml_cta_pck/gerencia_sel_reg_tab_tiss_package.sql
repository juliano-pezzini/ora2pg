-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';




CREATE OR REPLACE PROCEDURE pls_conv_xml_cta_pck.gerencia_sel_reg_tab_tiss ( ie_tipo_item_sel_p text, ie_tipo_item_regra_p text, cd_estabelecimento_p estabelecimento.cd_estabelecimento%type) AS $body$
DECLARE


tb_nr_seq_regra_w	pls_util_cta_pck.t_number_table;
nr_contador_w		integer;
qt_itens_protocolo_w	integer;
qt_regras_w		integer;

C01 CURSOR(cd_estabelecimento_pc	estabelecimento.cd_estabelecimento%type) FOR
	SELECT 	a.nr_sequencia nr_seq_regra,
		a.cd_material_orig_inicial,
		a.cd_material_orig_final,
		a.nr_seq_material,
		a.ie_tipo_tabela_imp,
		a.ie_tipo_despesa_tiss,
		a.nr_seq_prestador,
		a.ie_tipo_despesa_mat,
		a.nr_seq_tipo_prestador,
		a.nr_seq_grupo_prestador,
		a.cd_grupo_proc,
		a.cd_especialidade,
		a.cd_area_procedimento,
		a.cd_procedimento,
		(SELECT count(1)
		from   	pls_conta_item_imp_tmp b
		where  	b.cd_proced_number_conv between pls_util_pck.obter_somente_numero(a.cd_material_orig_inicial) 
							and pls_util_pck.obter_somente_numero(a.cd_material_orig_final)) qt_cod_material,
		(select count(1)
		from   	pls_conta_item_imp_tmp b
		where  	b.nr_seq_material_conv = a.nr_seq_material) qt_seq_material,
		(select count(1)
		from   	pls_conta_item_imp_tmp b
		where  	b.cd_tipo_tabela_conv = a.ie_tipo_tabela_imp) qt_tabela_importacao,
	        (select count(1)
		from   	pls_conta_item_imp_tmp b
		where  	b.ie_tipo_despesa_conv = a.ie_tipo_despesa_tiss) qt_tipo_despesa,
		(select	count(1)
		from	pls_conta_item_imp_tmp b
		where	b.nr_seq_prest_prot_conv = a.nr_seq_prestador) qt_prestador,
		(select	count(1)
		from	pls_conta_item_imp_tmp b,
			pls_material c
		where	c.nr_sequencia = b.nr_seq_material_conv
		and	c.ie_tipo_despesa = a.ie_tipo_despesa_mat) qt_tipo_despesa_mat,
		(select	count(1)
		from	pls_conta_item_imp_tmp b,
			pls_prestador c
		where	c.nr_sequencia = b.nr_seq_prest_prot_conv
		and	c.nr_seq_tipo_prestador = a.nr_seq_tipo_prestador) qt_tipo_prestador,
		(select	count(1)
		from	pls_conta_item_imp_tmp b,
			table(pls_grupos_pck.obter_prestadores_grupo(	a.nr_seq_grupo_prestador, 
									b.nr_seq_prest_prot_conv))
		where	CASE WHEN coalesce(b.nr_seq_prest_prot_conv::text, '') = '' THEN  -1  ELSE -2 END  = -2) qt_grupo_prestador,
		(select	count(1)
		from	pls_conta_item_imp_tmp b,
			estrutura_procedimento_v c
		where	b.cd_procedimento_conv = c.cd_procedimento
		and	c.cd_grupo_proc = a.cd_grupo_proc) qt_grupo_proc,
		(select	count(1)
		from	pls_conta_item_imp_tmp b,
			estrutura_procedimento_v c
		where	b.cd_procedimento_conv = c.cd_procedimento
		and	c.cd_especialidade = a.cd_especialidade) qt_espec_proc,
		(select	count(1)
		from	pls_conta_item_imp_tmp b,
			estrutura_procedimento_v c
		where	b.cd_procedimento_conv = c.cd_procedimento
		and	c.cd_area_procedimento = a.cd_area_procedimento) qt_area_proc,
		(select	count(1)
		from	pls_conta_item_imp_tmp b
		where	b.cd_procedimento_conv = a.cd_procedimento) qt_proc
	from   	pls_conversao_tabela_tiss a
	where  	a.ie_tipo_item = 'P'
	and    	a.ie_excecao = 'N'
	and    	a.ie_situacao = 'A'
	and	a.ie_aplicacao_regra = 'C'--Apenas considera as regras de conversao cadastradas para contas m_dicas

	and	cd_estabelecimento = cd_estabelecimento_pc;

C02 CURSOR(cd_estabelecimento_pc	estabelecimento.cd_estabelecimento%type) FOR
	SELECT 	a.nr_sequencia nr_seq_regra,
		a.ie_tipo_tabela_imp,
		a.cd_procedimento,
		a.nr_seq_grupo_rec,
		a.cd_area_procedimento,
		a.cd_especialidade,
		a.cd_grupo_proc,
		a.nr_seq_prestador,
		a.nr_seq_tipo_prestador,
		a.nr_seq_grupo_prestador,
		(SELECT count(1)
		from   	pls_conta_item_imp_tmp b
		where  	b.cd_tipo_tabela_conv = a.ie_tipo_tabela_imp) qt_tabela_importacao,
		(select count(1)
		from   	pls_conta_item_imp_tmp b
		where  	b.cd_procedimento_conv = a.cd_procedimento) qt_procedimento,
		(select count(1)
		from   	pls_conta_item_imp_tmp b,
			procedimento c
		where  	c.cd_procedimento = b.cd_procedimento_conv
		and	c.nr_seq_grupo_rec = a.nr_seq_grupo_rec) qt_grupo_receita,
		(select count(1)
		from   	pls_conta_item_imp_tmp b,
			estrutura_procedimento_v c
		where  	c.cd_procedimento = b.cd_procedimento_conv
		and	c.cd_area_procedimento = a.cd_area_procedimento) qt_area_proced,
		(select count(1)
		from   	pls_conta_item_imp_tmp b,
			estrutura_procedimento_v c
		where  	c.cd_procedimento = b.cd_procedimento_conv
		and	c.cd_especialidade = a.cd_especialidade) qt_espec_proced,
		(select count(1)
		from   	pls_conta_item_imp_tmp b,
			estrutura_procedimento_v c
		where  	c.cd_procedimento = b.cd_procedimento_conv
		and	c.cd_grupo_proc = a.cd_grupo_proc) qt_grupo_proced,
		(select	count(1)
		from	pls_conta_item_imp_tmp b
		where	b.nr_seq_prest_prot_conv = a.nr_seq_prestador) qt_prestador,
		(select	count(1)
		from	pls_conta_item_imp_tmp b,
			pls_prestador c
		where	c.nr_sequencia = b.nr_seq_prest_prot_conv
		and	c.nr_seq_tipo_prestador = a.nr_seq_tipo_prestador) qt_tipo_prestador,
		(select	count(1)
		from	pls_conta_item_imp_tmp b,
			table(pls_grupos_pck.obter_prestadores_grupo(	a.nr_seq_grupo_prestador,
									b.nr_seq_prest_prot_conv))
		where	CASE WHEN coalesce(b.nr_seq_prest_prot_conv::text, '') = '' THEN  -1  ELSE -2 END  = -2) qt_grupo_prestador,			
		(	select	count(1)
			from	pls_conta_item_imp_tmp b
			where	pls_se_grupo_preco_material(b.nr_seq_material_conv, a.nr_seq_grupo_material) = 'S'
		) qt_grupo_material
	from   	pls_conversao_tabela_tiss a
	where  	a.ie_tipo_item = 'M'
	and    	a.ie_excecao = 'N'
	and    	a.ie_situacao = 'A'
	and	a.ie_aplicacao_regra = 'C'--Apenas considera as regras de conversao cadastradas para contas m_dicas

	and	cd_estabelecimento = cd_estabelecimento_pc;
	
C03 CURSOR(	ie_tipo_item_pc		text,
		cd_estabelecimento_pc	estabelecimento.cd_estabelecimento%type) FOR
	SELECT	nr_sequencia nr_seq_regra
	from	pls_conversao_tabela_tiss
	where	ie_tipo_item = ie_tipo_item_pc
	and    	ie_excecao = 'N'
	and    	ie_situacao = 'A'
	and	ie_aplicacao_regra = 'C'--Apenas considera as regras de conversao cadastradas para contas m_dicas

	and	cd_estabelecimento = cd_estabelecimento_pc;

BEGIN

-- limpa os dados da tabela tempor_ria das regras

EXECUTE 'truncate table pls_regra_conv_tab_tmp';

nr_contador_w := 0;
tb_nr_seq_regra_w.delete;
qt_itens_protocolo_w := 0;
qt_regras_w := 0;

-- verifica quantos itens precisam ser processados

-- s_ vai ter material ou procedimento aqui, por isso n_o filtramos o tipo do item

select 	count(1)
into STRICT	qt_itens_protocolo_w
from	pls_conta_item_imp_tmp;

-- verifica quantas regras h_ para processar os itens

select 	count(1)
into STRICT	qt_regras_w
from 	pls_conversao_tabela_tiss
where	ie_tipo_item = ie_tipo_item_regra_p
and	ie_excecao = 'N'
and	ie_situacao = 'A'
and	cd_estabelecimento = cd_estabelecimento_p;

-- caso exista mais itens que regras processamos todas as regras dependendo do tipo de regra

-- que estamos analisando se convers_o para procedimento ou para material

if (qt_itens_protocolo_w > qt_regras_w) then

	open C03(ie_tipo_item_regra_p, cd_estabelecimento_p);
	loop
		fetch C03 bulk collect into tb_nr_seq_regra_w
		limit pls_util_pck.qt_registro_transacao_w;
		exit when tb_nr_seq_regra_w.count = 0;

		tb_nr_seq_regra_w := pls_conv_xml_cta_pck.alimenta_regra_tab_tiss(tb_nr_seq_regra_w);
		
	end loop;
	close C03;
else
	-- se tem menos itens que regras _ feita uma pr_ selecao das regras que ser_o processadas


	-- se _ para processar as regras de procedimento utilizamos o cursor 01

	-- OPS - Manutencao de Convers_es de Itens > Procedimentos > Recebimento > Convers_o tabelas

	-- existe esta separacao pois os campos utilizados nas regras s_o diferentes

	if (ie_tipo_item_regra_p = 'P') then
		
		-- verifica pela quantidade de itens com a informacao que est_ na regra para decidir se

		-- _ uma regra v_lida ou n_o, se encontrar 1 item que tenha informado o campo que est_ 

		-- na regra ent_o _ uma regra que precisa ser processada

		for r_c01_w in C01(cd_estabelecimento_p) loop
			
			if (r_c01_w.qt_cod_material > 0) or (r_c01_w.qt_seq_material > 0) or (r_c01_w.qt_tabela_importacao > 0) or (r_c01_w.qt_tipo_despesa > 0) or (r_c01_w.qt_prestador > 0) or (r_c01_w.qt_tipo_despesa_mat > 0) or (r_c01_w.qt_tipo_prestador > 0) or (r_c01_w.qt_grupo_prestador > 0) or (r_c01_w.qt_grupo_proc > 0) or (r_c01_w.qt_espec_proc > 0) or (r_c01_w.qt_area_proc > 0) or (r_c01_w.qt_proc > 0)then
				
				tb_nr_seq_regra_w(nr_contador_w) := r_c01_w.nr_seq_regra;
				
				-- se atingiu a quantidade manda para o banco

				if (nr_contador_w >= pls_util_pck.qt_registro_transacao_w) then
					tb_nr_seq_regra_w := pls_conv_xml_cta_pck.alimenta_regra_tab_tiss(tb_nr_seq_regra_w);
					nr_contador_w := 0;
				else
					nr_contador_w := nr_contador_w + 1;
				end if;
			-- incluido este else caso todos os campos sejam nulos (regra em branco) a regra _ v_lida

			elsif (coalesce(r_c01_w.cd_material_orig_inicial::text, '') = '') and (coalesce(r_c01_w.cd_material_orig_final::text, '') = '') and (coalesce(r_c01_w.nr_seq_material::text, '') = '') and (coalesce(r_c01_w.ie_tipo_tabela_imp::text, '') = '') and (coalesce(r_c01_w.ie_tipo_despesa_tiss::text, '') = '') and (coalesce(r_c01_w.nr_seq_prestador::text, '') = '') and (coalesce(r_c01_w.ie_tipo_despesa_mat::text, '') = '') and (coalesce(r_c01_w.nr_seq_tipo_prestador::text, '') = '') and (coalesce(r_c01_w.nr_seq_grupo_prestador::text, '') = '') and (coalesce(r_c01_w.cd_grupo_proc::text, '') = '') and (coalesce(r_c01_w.cd_especialidade::text, '') = '') and (coalesce(r_c01_w.cd_area_procedimento::text, '') = '') and (coalesce(r_c01_w.cd_procedimento::text, '') = '') then
				
				tb_nr_seq_regra_w(nr_contador_w) := r_c01_w.nr_seq_regra;
				
				-- se atingiu a quantidade manda para o banco

				if (nr_contador_w >= pls_util_pck.qt_registro_transacao_w) then
					tb_nr_seq_regra_w := pls_conv_xml_cta_pck.alimenta_regra_tab_tiss(tb_nr_seq_regra_w);
					nr_contador_w := 0;
				else
					nr_contador_w := nr_contador_w + 1;
				end if;
			end if;
		end loop;
		-- se possui algum registro manda pra tabela tempor_ria para ser processada

		tb_nr_seq_regra_w := pls_conv_xml_cta_pck.alimenta_regra_tab_tiss(tb_nr_seq_regra_w);
		
	-- se _ para processar as regras de materiais utilizamos o cursor 02

	-- OPS - Manutencao de Convers_es de Itens > Materiais > Recebimento > Convers_o tabelas

	else
		-- verifica pela quantidade de itens com a informacao que est_ na regra para decidir se

		-- _ uma regra v_lida ou n_o, se encontrar 1 item que tenha informado o campo que est_ 

		-- na regra ent_o _ uma regra que precisa ser processada

		for r_c02_w in C02(cd_estabelecimento_p) loop
			
			if (r_c02_w.qt_tabela_importacao > 0) or (r_c02_w.qt_procedimento > 0) or (r_c02_w.qt_grupo_receita > 0) or (r_c02_w.qt_area_proced > 0) or (r_c02_w.qt_espec_proced > 0) or (r_c02_w.qt_grupo_proced > 0) or (r_c02_w.qt_prestador > 0) or (r_c02_w.qt_tipo_prestador > 0) or (r_c02_w.qt_grupo_prestador > 0) or (r_c02_w.qt_grupo_material > 0 ) then
				
				tb_nr_seq_regra_w(nr_contador_w) := r_c02_w.nr_seq_regra;
				
				-- se atingiu a quantidade manda para o banco

				if (nr_contador_w >= pls_util_pck.qt_registro_transacao_w) then
					tb_nr_seq_regra_w := pls_conv_xml_cta_pck.alimenta_regra_tab_tiss(tb_nr_seq_regra_w);
					nr_contador_w := 0;
				else
					nr_contador_w := nr_contador_w + 1;
				end if;
			-- incluido este else caso todos os campos sejam nulos (regra em branco) a regra _ v_lida	

			elsif (coalesce(r_c02_w.ie_tipo_tabela_imp::text, '') = '') and (coalesce(r_c02_w.cd_procedimento::text, '') = '') and (coalesce(r_c02_w.nr_seq_grupo_rec::text, '') = '') and (coalesce(r_c02_w.cd_area_procedimento::text, '') = '') and (coalesce(r_c02_w.cd_especialidade::text, '') = '') and (coalesce(r_c02_w.cd_grupo_proc::text, '') = '') and (coalesce(r_c02_w.nr_seq_prestador::text, '') = '') and (coalesce(r_c02_w.nr_seq_tipo_prestador::text, '') = '') and (coalesce(r_c02_w.nr_seq_grupo_prestador::text, '') = '') then
				
				tb_nr_seq_regra_w(nr_contador_w) := r_c02_w.nr_seq_regra;
				
				-- se atingiu a quantidade manda para o banco

				if (nr_contador_w >= pls_util_pck.qt_registro_transacao_w) then
					tb_nr_seq_regra_w := pls_conv_xml_cta_pck.alimenta_regra_tab_tiss(tb_nr_seq_regra_w);
					nr_contador_w := 0;
				else
					nr_contador_w := nr_contador_w + 1;
				end if;
			end if;			
		end loop;
		-- se possui algum registro manda pra tabela tempor_ria para ser processada

		tb_nr_seq_regra_w := pls_conv_xml_cta_pck.alimenta_regra_tab_tiss(tb_nr_seq_regra_w);
	end if;
end if;	

END;

$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE pls_conv_xml_cta_pck.gerencia_sel_reg_tab_tiss ( ie_tipo_item_sel_p text, ie_tipo_item_regra_p text, cd_estabelecimento_p estabelecimento.cd_estabelecimento%type) FROM PUBLIC;
