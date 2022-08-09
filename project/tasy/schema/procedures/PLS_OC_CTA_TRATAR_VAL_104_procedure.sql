-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE pls_oc_cta_tratar_val_104 ( dados_regra_p pls_tipos_ocor_pck.dados_regra, nr_id_transacao_p pls_selecao_ocor_cta.nr_id_transacao%type, nm_usuario_p usuario.nm_usuario%type) AS $body$
DECLARE

/* +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
Finalidade:
-------------------------------------------------------------------------------------------------------------------
Locais de chamada direta:
[ ]  Objetos do dicionário [ ] Tasy (Delphi/Java) [  ] Portal [  ]  Relatórios [ ] Outros:
-------------------------------------------------------------------------------------------------------------------
Pontos de atenção:

Alterações:
-------------------------------------------------------------------------------------------------------------------
-------------------------------------------------------------------------------------------------------------------
++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++ */
qt_cnt_w		integer;
i			integer;
qt_valido_w		integer;
qt_conselho_w		integer;
tb_seq_selecao_w	dbms_sql.number_table;
tb_observacao_w		dbms_sql.varchar2_table;
tb_valido_w		dbms_sql.varchar2_table;
sg_cons_prof_ant_w	ptu_nota_servico.sg_cons_prof_prest%type;

-- Cursor da regra
C01 CURSOR(nr_seq_oc_cta_comb_pc	pls_oc_cta_combinada.nr_sequencia%type) FOR
	SELECT	a.ie_valida_conselho_serv
	from	pls_oc_cta_val_interc a
	where	a.nr_seq_oc_cta_comb = nr_seq_oc_cta_comb_pc;

--Cursor dos itens e o CRM de cada item informado na nota de serviço
-- feito union all pois como a validação é a nível de conta
-- caso não seja utilizado filtros, a tabela pls_selecao_ocor_cta
-- terá somente um registro com o nr_seq_conta_proc nulo
-- Porém, se ligar pela conta, caso seja acrescentado um filtro
-- O cursor irá multiplicar o resultado, diminuindo a performance
-- desta forma, o cursor irá trazer somente a quantidade de itens necessários
C02 CURSOR(nr_id_transacao_pc	pls_selecao_ocor_cta.nr_id_transacao%type) FOR
	SELECT	sel.nr_sequencia nr_seq_selecao,
		(SELECT	max(ptu.sg_cons_prof_prest)
		 from	ptu_nota_servico ptu
		 where	ptu.nr_seq_conta_proc = proc.nr_sequencia
		 and	(ptu.sg_cons_prof_prest IS NOT NULL AND ptu.sg_cons_prof_prest::text <> '')) sg_cons_prof
	from	pls_selecao_ocor_cta sel,
		pls_conta conta,
		pls_conta_proc proc
	where	conta.nr_sequencia	= sel.nr_seq_conta
	and	conta.nr_sequencia	= proc.nr_seq_conta
	and	coalesce(sel.nr_seq_conta_proc::text, '') = ''
	and	sel.nr_id_transacao	= nr_id_transacao_pc
	and	sel.ie_valido		= 'S'
	
union all

	select	sel.nr_sequencia nr_seq_selecao,
		(select	max(ptu.sg_cons_prof_prest)
		 from	ptu_nota_servico ptu
		 where	ptu.nr_seq_conta_proc = proc.nr_sequencia
		 and	(ptu.sg_cons_prof_prest IS NOT NULL AND ptu.sg_cons_prof_prest::text <> '')) sg_cons_prof
	from	pls_selecao_ocor_cta sel,
		pls_conta_proc proc
	where	proc.nr_sequencia	= sel.nr_seq_conta_proc
	and	sel.nr_id_transacao	= nr_id_transacao_pc
	and	sel.ie_valido		= 'S'
	order by sg_cons_prof;
BEGIN
-- Somente irá executar se tiver regra cadastrada
if (dados_regra_p.nr_sequencia IS NOT NULL AND dados_regra_p.nr_sequencia::text <> '') then

	-- tratamento em campo auxiliar para identificar posteriormente os registros que foram alterados
	CALL pls_tipos_ocor_pck.atualiza_campo_auxiliar('V', nr_id_transacao_p, null, dados_regra_p);

	--Grava a quantidade de registro por transação
	qt_cnt_w := pls_cta_consistir_pck.qt_registro_transacao_w;

	-- Inicializa as variáveis que serão utilizadas
	tb_seq_selecao_w	:= pls_tipos_ocor_pck.num_table_vazia;
	tb_observacao_w		:= pls_tipos_ocor_pck.vchr2_table_vazia;
	tb_valido_w		:= pls_tipos_ocor_pck.vchr2_table_vazia;
	sg_cons_prof_ant_w	:= 'X';
	i			:= 0;
	--Abre cursor de regras
	for r_C01_w in C01(dados_regra_p.nr_sequencia) loop
		-- Se o deve ser validado o conselho profissional
		if (r_C01_w.ie_valida_conselho_serv = 'S') then

			-- Abre o cursor de itens.
			-- Neste momento será verificado quais itens tem o conselho informado
			-- Para itens que não possuem conselho, não deve ser verificado
			-- Logo, setamos os itens com conselho para Sim e os itens que não tem conselho
			-- e estão na seleção, irão, automaticamente receber 'Não', tornando a verificação
			-- do conselho, posteriormente, muito mais eficiente
			for r_C02_w in C02(nr_id_transacao_p) loop

				-- Se tem conselho informado
				if (r_C02_w.sg_cons_prof IS NOT NULL AND r_C02_w.sg_cons_prof::text <> '') then

					tb_seq_selecao_w(i)	:= r_C02_w.nr_seq_selecao;
					tb_observacao_w(i) 	:= '';
					tb_valido_w(i) 		:= 'S';
					-- Se alcançou a quantidade, manda pro banco
					if (tb_seq_selecao_w.count >= qt_cnt_w) then
						CALL pls_tipos_ocor_pck.gerencia_selecao_validacao(	tb_seq_selecao_w,
												pls_tipos_ocor_pck.clob_table_vazia,
												'SEQ',
												tb_observacao_w,
												tb_valido_w,
												nm_usuario_p);

						tb_seq_selecao_w	:= pls_tipos_ocor_pck.num_table_vazia;
						tb_observacao_w		:= pls_tipos_ocor_pck.vchr2_table_vazia;
						tb_valido_w		:= pls_tipos_ocor_pck.vchr2_table_vazia;
						i			:= 0;
					else
						i := i + 1;
					end if;
				end if;
			end loop;
			-- Caso tenha sobrado algum item
			if (tb_seq_selecao_w.count > 0) then
				CALL pls_tipos_ocor_pck.gerencia_selecao_validacao(	tb_seq_selecao_w,
										pls_tipos_ocor_pck.clob_table_vazia,
										'SEQ',
										tb_observacao_w,
										tb_valido_w,
										nm_usuario_p);

				tb_seq_selecao_w	:= pls_tipos_ocor_pck.num_table_vazia;
				tb_observacao_w		:= pls_tipos_ocor_pck.vchr2_table_vazia;
				tb_valido_w		:= pls_tipos_ocor_pck.vchr2_table_vazia;
				i			:= 0;
			end if;
		end if;
	end loop;

	-- seta os registros que serão válidos ou inválidos após o processamento
	CALL pls_tipos_ocor_pck.atualiza_campo_valido('V', nr_id_transacao_p, null, dados_regra_p);

	-- tratamento em campo auxiliar para identificar posteriormente os registros que foram alterados
	CALL pls_tipos_ocor_pck.atualiza_campo_auxiliar('V', nr_id_transacao_p, null, dados_regra_p);

	select	count(1)
	into STRICT	qt_valido_w
	from	pls_selecao_ocor_cta
	where	nr_id_transacao = nr_id_transacao_p
	and	ie_valido = 'S';

	-- Verifica se sobrou itens a serem validados
	if (qt_valido_w > 0) then
		-- Abre o cursor da regra
		for r_C01_w in C01(dados_regra_p.nr_sequencia) loop
			-- Se o deve ser validado o conselho profissional
			if (r_C01_w.ie_valida_conselho_serv = 'S') then
				-- Abre o crusor de itens
				for r_C02_w in C02(nr_id_transacao_p) loop
					-- Realizado essa verificação pois se não mudou o conselho profissional
					-- não precisa verificar novamente, ja que a validação é a nível de conta
					if (r_C02_w.sg_cons_prof <> sg_cons_prof_ant_w) then

						sg_cons_prof_ant_w := r_C02_w.sg_cons_prof;
						-- Verifica se o conselho está cadastrado pela sigla
						select	count(1)
						into STRICT	qt_conselho_w
						from	conselho_profissional
						where	sg_conselho = r_C02_w.sg_cons_prof
						and	ie_situacao = 'A';
						-- Se não encontrar, verifica pelo código TISS
						if (qt_conselho_w = 0) then
							select	count(1)
							into STRICT	qt_conselho_w
							from	conselho_profissional
							where	ie_conselho_prof_tiss = r_C02_w.sg_cons_prof
							and	ie_situacao = 'A';
						end if;
					end if;
					-- Caso não possua conselho cadastrado na base, gera a ocorrência
					if (qt_conselho_w = 0) then

						tb_seq_selecao_w(i)	:= r_C02_w.nr_seq_selecao;
						tb_observacao_w(i)	:= 	'Conselho profissional informado na nota de serviço não cadastrado na base.' || pls_util_pck.enter_w ||
										'Conselho profissional informado: ' || r_C02_w.sg_cons_prof;
						tb_valido_w(i)		:= 'S';

						--Se alcançou a quantidade, manda pro banco
						if (tb_seq_selecao_w.count > qt_cnt_w) then
							CALL pls_tipos_ocor_pck.gerencia_selecao_validacao(	tb_seq_selecao_w,
													pls_tipos_ocor_pck.clob_table_vazia,
													'SEQ',
													tb_observacao_w,
													tb_valido_w,
													nm_usuario_p);

							tb_seq_selecao_w	:= pls_tipos_ocor_pck.num_table_vazia;
							tb_observacao_w		:= pls_tipos_ocor_pck.vchr2_table_vazia;
							tb_valido_w		:= pls_tipos_ocor_pck.vchr2_table_vazia;
							i			:= 0;
						else
							i := i + 1;
						end if;
					end if;
				end loop;
				-- Caso tenha sobrado algum item nas tabelas
				if (tb_seq_selecao_w.count > 0) then
					CALL pls_tipos_ocor_pck.gerencia_selecao_validacao(	tb_seq_selecao_w,
											pls_tipos_ocor_pck.clob_table_vazia,
											'SEQ',
											tb_observacao_w,
											tb_valido_w,
											nm_usuario_p);
				end if;
			end if;
		end loop;
	end if;

	-- seta os registros que serão válidos ou inválidos após o processamento
	CALL pls_tipos_ocor_pck.atualiza_campo_valido('V', nr_id_transacao_p, null, dados_regra_p);

end if;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE pls_oc_cta_tratar_val_104 ( dados_regra_p pls_tipos_ocor_pck.dados_regra, nr_id_transacao_p pls_selecao_ocor_cta.nr_id_transacao%type, nm_usuario_p usuario.nm_usuario%type) FROM PUBLIC;
