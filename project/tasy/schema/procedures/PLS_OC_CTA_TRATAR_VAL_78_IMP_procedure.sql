-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE pls_oc_cta_tratar_val_78_imp ( nr_seq_combinada_p pls_oc_cta_combinada.nr_sequencia%type, ie_regra_excecao_p pls_oc_cta_combinada.ie_excecao%type, nr_id_transacao_p pls_oc_cta_selecao_imp.nr_id_transacao%type, cd_estabelecimento_p estabelecimento.cd_estabelecimento%type) AS $body$
DECLARE



_ora2pg_r RECORD;
/* ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
Finalidade:	Aplicar a validação das classificação do porte do item para importação de XML de contas médicas
+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++ */
tb_seq_selecao_w		pls_util_cta_pck.t_number_table;
tb_valido_w			pls_util_cta_pck.t_varchar2_table_1;
tb_observacao_w			pls_util_cta_pck.t_varchar2_table_4000;
nr_seq_grau_classif_item_w	pls_grau_classif_item.nr_sequencia%type;
cd_classificacao_w		pls_grau_classif_item.cd_classificacao%type;
cd_procedimento_porte_w		pls_util_cta_pck.t_number_table;
ie_origem_proced_porte_w	pls_util_cta_pck.t_number_table;
nr_idx_w			integer := 0;
ie_executa_w			varchar(1) := 'S';
dt_procedimento_ant_w		pls_conta_proc_imp.dt_execucao_trunc_conv%type := to_date('01/01/1899');
ie_ocorrencia_w 		pls_controle_estab.ie_ocorrencia%type := pls_obter_se_controle_estab('GO');

-- Cursor das regras
C01 CURSOR(	nr_seq_oc_cta_comb_p	pls_oc_cta_combinada.nr_sequencia%type) FOR
	SELECT	a.ie_validar_porte,
		a.ie_tipo_validacao,
		a.ie_considera_data
	from	pls_oc_cta_val_porte a
	where	a.nr_seq_oc_cta_comb	= nr_seq_oc_cta_comb_p;

--Cursosr das procedimentos das contas ordenando pela classificação do porte
C02 CURSOR(	nr_id_transacao_pc	pls_oc_cta_selecao_imp.nr_sequencia%type,
		cd_estabelecimento_pc	estabelecimento.cd_estabelecimento%type)	FOR
	SELECT	sel.nr_sequencia nr_seq_selecao,
		sel.nr_seq_conta_proc,
		proc.cd_procedimento_conv,
		proc.ie_origem_proced_conv,
		conta.dt_atendimento_conv dt_atendimento_conta,
		sel.nr_seq_segurado,
		sel.cd_guia_referencia,
		pls_obter_classific_porte(proc.cd_procedimento_conv, proc.ie_origem_proced_conv,
					  'E', conta.dt_atendimento_conv, cd_estabelecimento_pc) cd_classificacao,
		proc.dt_execucao_trunc_conv dt_procedimento_trunc
	from	pls_oc_cta_selecao_imp	sel,
		pls_conta_proc_imp	proc,
		pls_conta_imp		conta
	where	sel.nr_id_transacao	= nr_id_transacao_pc
	and	sel.ie_valido 		= 'S'
	and	proc.nr_sequencia	= sel.nr_seq_conta_proc
	and	proc.nr_seq_conta	= conta.nr_sequencia
	order by
		cd_classificacao desc,
		proc.dt_execucao_trunc_conv;

/*Cursor dos procedimentos do Porte conforme a validação retorna apenas aqueles vinculados a um porte com tipo conta = intercambio ou todo*/

/*Esse cursor foi duplicado no cursor C06, a diferença que no C06 é realizado tratamento por estabelecimento. CASO ALTERAR ESSE CURSOR ALTERAR O C06 TAMBÉM*/

C03 CURSOR( 	ie_tipo_validacao_pc	pls_oc_cta_val_porte.ie_tipo_validacao%type,
		dt_atendimento_conta_pc	timestamp,
		cd_classificacao_pc	pls_grau_classif_item.cd_classificacao%type) FOR
	SELECT	b.cd_procedimento,
		b.ie_origem_proced
	from	pls_grau_classif_item	b,
		pls_oc_classif_porte	c
	where	ie_tipo_validacao_pc	= '1'
	and 	b.cd_classificacao 	< cd_classificacao_pc
	and	b.nr_sequencia	 	= c.nr_seq_classif_porte
	and	coalesce(c.ie_tipo_conta,'T') in ('O','T')
	and	dt_atendimento_conta_pc between b.dt_inicio_vigencia and coalesce(b.dt_fim_vigencia,dt_atendimento_conta_pc)
	and	dt_atendimento_conta_pc between c.dt_inicio_vigencia and coalesce(c.dt_fim_vigencia,dt_atendimento_conta_pc)
	
union all

	SELECT	b.cd_procedimento,
		b.ie_origem_proced
	from	pls_grau_classif_item	b,
		pls_oc_classif_porte	c
	where	ie_tipo_validacao_pc 	= '2'
	and 	b.cd_classificacao 	> cd_classificacao_pc
	and	b.nr_sequencia	 	= c.nr_seq_classif_porte
	and	coalesce(c.ie_tipo_conta,'T') in ('O','T')
	and	dt_atendimento_conta_pc between b.dt_inicio_vigencia and coalesce(b.dt_fim_vigencia,dt_atendimento_conta_pc)
	and	dt_atendimento_conta_pc between c.dt_inicio_vigencia and coalesce(c.dt_fim_vigencia,dt_atendimento_conta_pc)
	
union all

	select	b.cd_procedimento,
		b.ie_origem_proced
	from	pls_grau_classif_item	b,
		pls_oc_classif_porte	c
	where	ie_tipo_validacao_pc	= '3'
	and	b.cd_classificacao 	<> cd_classificacao_pc
	and	b.nr_sequencia	 	= c.nr_seq_classif_porte
	and	coalesce(c.ie_tipo_conta,'T') in ('O','T')
	and	dt_atendimento_conta_pc between b.dt_inicio_vigencia and coalesce(b.dt_fim_vigencia,dt_atendimento_conta_pc)
	and	dt_atendimento_conta_pc between c.dt_inicio_vigencia and coalesce(c.dt_fim_vigencia,dt_atendimento_conta_pc);

/*Busca as contas do procedimento que está na classificação*/

c04 CURSOR(	nr_id_transacao_pc		pls_oc_cta_selecao_imp.nr_sequencia%type,
		nr_seq_conta_proc_pc		pls_oc_cta_selecao_imp.nr_seq_conta_proc%type,
		nr_seq_segurado_pc		pls_oc_cta_selecao_imp.nr_seq_segurado%type,
		cd_guia_referencia_pc		pls_oc_cta_selecao_imp.cd_guia_referencia%type,
		cd_procedimento_pc		pls_grau_classif_item.cd_procedimento%type,
		ie_origem_proced_pc		pls_grau_classif_item.ie_origem_proced%type,
		dt_procedimento_pc		pls_conta_proc_imp.dt_execucao_trunc_conv%type,
		ie_considera_data_pc		pls_oc_cta_val_porte.ie_considera_data%type) FOR
	SELECT	sel.nr_sequencia nr_seq_selecao
	from	pls_oc_cta_selecao_imp	sel,
		pls_conta_proc_imp		proc
	where	sel.nr_id_transacao		= nr_id_transacao_pc
	and	sel.ie_valido 			= 'S'
	and	proc.nr_sequencia		= sel.nr_seq_conta_proc
	and	sel.nr_seq_conta_proc		<> nr_seq_conta_proc_pc
	and	sel.nr_seq_segurado		= nr_seq_segurado_pc
	and	sel.cd_guia_referencia		= cd_guia_referencia_pc
	and	proc.cd_procedimento_conv	= cd_procedimento_pc
	and	proc.ie_origem_proced_conv	= ie_origem_proced_pc
	and	ie_considera_data_pc		= 'N'
	
union all

	SELECT	sel.nr_sequencia nr_seq_selecao
	from	pls_oc_cta_selecao_imp	sel,
		pls_conta_proc_imp		proc
	where	sel.nr_id_transacao		= nr_id_transacao_pc
	and	sel.ie_valido 			= 'S'
	and	proc.nr_sequencia		= sel.nr_seq_conta_proc
	and	sel.nr_seq_conta_proc		<> nr_seq_conta_proc_pc
	and	sel.nr_seq_segurado		= nr_seq_segurado_pc
	and	sel.cd_guia_referencia		= cd_guia_referencia_pc
	and	proc.cd_procedimento_conv	= cd_procedimento_pc
	and	proc.ie_origem_proced_conv	= ie_origem_proced_pc
	and	ie_considera_data_pc		= 'S'
	and	proc.dt_execucao_trunc_conv	= dt_procedimento_pc;

--Cursosr das procedimentos das contas ordenando pela data
C05 CURSOR(	nr_id_transacao_pc	pls_oc_cta_selecao_imp.nr_sequencia%type,
		cd_estabelecimento_pc	estabelecimento.cd_estabelecimento%type)	FOR
	SELECT	sel.nr_sequencia nr_seq_selecao,
		sel.nr_seq_conta_proc,
		proc.cd_procedimento_conv cd_procedimento,
		proc.ie_origem_proced_conv ie_origem_proced,
		conta.dt_atendimento_conv dt_atendimento_conta,
		sel.nr_seq_segurado,
		sel.cd_guia_referencia,
		pls_obter_classific_porte(proc.cd_procedimento_conv, proc.ie_origem_proced_conv,
					  'E', conta.dt_atendimento_conv, cd_estabelecimento_pc) cd_classificacao,
		proc.dt_execucao_trunc_conv dt_procedimento_trunc
	from	pls_oc_cta_selecao_imp	sel,
		pls_conta_proc_imp	proc,
		pls_conta_imp		conta
	where	sel.nr_id_transacao	= nr_id_transacao_pc
	and	sel.ie_valido 		= 'S'
	and	proc.nr_sequencia	= sel.nr_seq_conta_proc
	and	proc.nr_seq_conta	= conta.nr_sequencia
	order by
		proc.dt_execucao_trunc_conv,
		cd_classificacao desc;

/*Cursor dos procedimentos do Porte conforme a validação retorna apenas aqueles vinculados a um porte com tipo conta = intercambio ou todo*/

/*Esse cursor foi duplicado do cursor C03, a diferença que no C03 não é realizado tratamento por estabelecimento. CASO ALTERAR ESSE CURSOR ALTERAR O C03 TAMBÉM*/

C06 CURSOR( 	ie_tipo_validacao_pc	pls_oc_cta_val_porte.ie_tipo_validacao%type,
		dt_atendimento_conta_pc	timestamp,
		cd_classificacao_pc	pls_grau_classif_item.cd_classificacao%type,
		cd_estabelecimento_pc	estabelecimento.cd_estabelecimento%type) FOR
	SELECT	b.cd_procedimento,
		b.ie_origem_proced
	from	pls_grau_classif_item	b,
		pls_oc_classif_porte	c
	where	ie_tipo_validacao_pc	= '1'
	and 	b.cd_classificacao 	< cd_classificacao_pc
	and	b.nr_sequencia	 	= c.nr_seq_classif_porte
	and	coalesce(c.ie_tipo_conta,'T') in ('O','T')
	and	dt_atendimento_conta_pc between b.dt_inicio_vigencia and coalesce(b.dt_fim_vigencia,dt_atendimento_conta_pc)
	and	dt_atendimento_conta_pc between c.dt_inicio_vigencia and coalesce(c.dt_fim_vigencia,dt_atendimento_conta_pc)
	and	b.cd_estabelecimento	= cd_estabelecimento_pc
	
union all

	SELECT	b.cd_procedimento,
		b.ie_origem_proced
	from	pls_grau_classif_item	b,
		pls_oc_classif_porte	c
	where	ie_tipo_validacao_pc 	= '2'
	and 	b.cd_classificacao 	> cd_classificacao_pc
	and	b.nr_sequencia	 	= c.nr_seq_classif_porte
	and	coalesce(c.ie_tipo_conta,'T') in ('O','T')
	and	dt_atendimento_conta_pc between b.dt_inicio_vigencia and coalesce(b.dt_fim_vigencia,dt_atendimento_conta_pc)
	and	dt_atendimento_conta_pc between c.dt_inicio_vigencia and coalesce(c.dt_fim_vigencia,dt_atendimento_conta_pc)
	and	b.cd_estabelecimento	= cd_estabelecimento_pc
	
union all

	select	b.cd_procedimento,
		b.ie_origem_proced
	from	pls_grau_classif_item	b,
		pls_oc_classif_porte	c
	where	ie_tipo_validacao_pc	= '3'
	and	b.cd_classificacao 	<> cd_classificacao_pc
	and	b.nr_sequencia	 	= c.nr_seq_classif_porte
	and	coalesce(c.ie_tipo_conta,'T') in ('O','T')
	and	dt_atendimento_conta_pc between b.dt_inicio_vigencia and coalesce(b.dt_fim_vigencia,dt_atendimento_conta_pc)
	and	dt_atendimento_conta_pc between c.dt_inicio_vigencia and coalesce(c.dt_fim_vigencia,dt_atendimento_conta_pc)
	and	b.cd_estabelecimento	= cd_estabelecimento_pc;
BEGIN

if (nr_seq_combinada_p IS NOT NULL AND nr_seq_combinada_p::text <> '')  then

	for r_C01_w in C01(nr_seq_combinada_p) loop

		/*Verifica se é para validar a ocorrência*/

		if (r_C01_w.ie_validar_porte = 'S')	then

			CALL pls_ocor_imp_pck.atualiza_campo_auxiliar('V', ie_regra_excecao_p, nr_id_transacao_p, null);
			SELECT * FROM pls_ocor_imp_pck.limpar_nested_tables(tb_seq_selecao_w, tb_valido_w, tb_observacao_w) INTO STRICT _ora2pg_r;
 tb_seq_selecao_w := _ora2pg_r.tb_nr_seq_selecao_p; tb_valido_w := _ora2pg_r.tb_ie_valido_p; tb_observacao_w := _ora2pg_r.tb_ds_observacao_p;

			-- Caso não considera a data
			if (r_C01_w.ie_considera_data = 'N') then

				for r_C02_w in C02(nr_id_transacao_p, cd_estabelecimento_p) loop
					-- Somente deve ser verificado itens que possuem porte cadastrado
					-- Como não considera data somente deve considerar o procedimento com o maior porte,
					-- por isso, somente deve percorrer uma vez, pois o primeiro é o maior porte
					if (r_C02_w.cd_classificacao IS NOT NULL AND r_C02_w.cd_classificacao::text <> '') and (ie_executa_w = 'S') then

						ie_executa_w := 'N';

						cd_procedimento_porte_w.delete;
						ie_origem_proced_porte_w.delete;

						if (ie_ocorrencia_w = 'S') then
							/*Coloca num table o procedimento e sua origem das classificações, conforme a regra de ordenação da ocorrência*/

							for r_C06_w in C06(r_c01_w.ie_tipo_validacao, r_c02_w.dt_atendimento_conta, r_C02_w.cd_classificacao, cd_estabelecimento_p) loop
									cd_procedimento_porte_w(C06%rowCount)	:= r_C06_w.cd_procedimento;
									ie_origem_proced_porte_w(C06%rowCount)	:= r_C06_w.ie_origem_proced;
							end loop;
						else
							/*Coloca num table o procedimento e sua origem das classificações, conforme a regra de ordenação da ocorrência*/

							for r_C03_w in C03(r_c01_w.ie_tipo_validacao, r_c02_w.dt_atendimento_conta, r_C02_w.cd_classificacao) loop
									cd_procedimento_porte_w(C03%rowCount)	:= r_C03_w.cd_procedimento;
									ie_origem_proced_porte_w(C03%rowCount)	:= r_C03_w.ie_origem_proced;
							end loop;
						end if;


						if (cd_procedimento_porte_w.count > 0) then
							for i in cd_procedimento_porte_w.first .. cd_procedimento_porte_w.count loop

								/*Armazena todos os procedimentos que está na tabela de seleção se existir na classificação do table*/

								for r_C04_w in C04(nr_id_transacao_p,r_C02_w.nr_seq_conta_proc,r_C02_w.nr_seq_segurado,
										r_C02_w.cd_guia_referencia,cd_procedimento_porte_w(i),ie_origem_proced_porte_w(i),
										r_C02_w.dt_procedimento_trunc, r_C01_w.ie_considera_data) loop
									tb_valido_w(nr_idx_w)		:= 'S';
									tb_seq_selecao_w(nr_idx_w)	:= r_C04_w.nr_seq_selecao;
									tb_observacao_w(nr_idx_w)	:= '';

									if (nr_idx_w = pls_util_cta_pck.qt_registro_transacao_w) then
										CALL pls_ocor_imp_pck.gerencia_selecao_validacao(	tb_seq_selecao_w, tb_valido_w, tb_observacao_w, nr_id_transacao_p,'SEQ');

										nr_idx_w := 0;
										SELECT * FROM pls_ocor_imp_pck.limpar_nested_tables(tb_seq_selecao_w, tb_valido_w, tb_observacao_w) INTO STRICT _ora2pg_r;
 tb_seq_selecao_w := _ora2pg_r.tb_nr_seq_selecao_p; tb_valido_w := _ora2pg_r.tb_ie_valido_p; tb_observacao_w := _ora2pg_r.tb_ds_observacao_p;
									else
										nr_idx_w := nr_idx_w + 1;
									end if;

								end loop;
							end loop;
						end if;
					end if;
				end loop;
			else
				for r_C05_w in C05(nr_id_transacao_p, cd_estabelecimento_p) loop
					-- Caso verifica data somente pode passar pelo maior porte por data
					-- ou seja, se a data mudar, esse item é o maior porte da data dele
					if (r_C05_w.cd_classificacao IS NOT NULL AND r_C05_w.cd_classificacao::text <> '') and (r_C05_w.dt_procedimento_trunc <> dt_procedimento_ant_w) then

						--Alimenta a variável de controle da data
						dt_procedimento_ant_w := r_C05_w.dt_procedimento_trunc;

						cd_procedimento_porte_w.delete;
						ie_origem_proced_porte_w.delete;

						if (ie_ocorrencia_w = 'S') then
							/*Coloca num table o procedimento e sua origem das classificações, conforme a regra de ordenação da ocorrência*/

							for r_C06_w in C06(r_c01_w.ie_tipo_validacao, r_C05_w.dt_atendimento_conta, r_C05_w.cd_classificacao, cd_estabelecimento_p) loop
								cd_procedimento_porte_w(C06%rowCount)	:= r_C06_w.cd_procedimento;
								ie_origem_proced_porte_w(C06%rowCount)	:= r_C06_w.ie_origem_proced;
							end loop;
						else
							/*Coloca num table o procedimento e sua origem das classificações, conforme a regra de ordenação da ocorrência*/

							for r_C03_w in C03(r_c01_w.ie_tipo_validacao, r_C05_w.dt_atendimento_conta, r_C05_w.cd_classificacao) loop
								cd_procedimento_porte_w(C03%rowCount)	:= r_C03_w.cd_procedimento;
								ie_origem_proced_porte_w(C03%rowCount)	:= r_C03_w.ie_origem_proced;
							end loop;
						end if;

						if (ie_ocorrencia_w = 'S') then
							/*Coloca num table o procedimento e sua origem das classificações, conforme a regra de ordenação da ocorrência*/

							for r_C06_w in C06(r_c01_w.ie_tipo_validacao, r_C05_w.dt_atendimento_conta, r_C05_w.cd_classificacao, cd_estabelecimento_p) loop
								cd_procedimento_porte_w(C06%rowCount)	:= r_C06_w.cd_procedimento;
								ie_origem_proced_porte_w(C06%rowCount)	:= r_C06_w.ie_origem_proced;
							end loop;
						else
							/*Coloca num table o procedimento e sua origem das classificações, conforme a regra de ordenação da ocorrência*/

							for r_C03_w in C03(r_c01_w.ie_tipo_validacao, r_C05_w.dt_atendimento_conta, r_C05_w.cd_classificacao) loop
								cd_procedimento_porte_w(C03%rowCount)	:= r_C03_w.cd_procedimento;
								ie_origem_proced_porte_w(C03%rowCount)	:= r_C03_w.ie_origem_proced;
							end loop;
						end if;

						if (cd_procedimento_porte_w.count > 0) then
							for i in cd_procedimento_porte_w.first .. cd_procedimento_porte_w.count loop

								/*Armazena todos os procedimentos que está na tabela de seleção se existir na classificação do table*/

								for r_C04_w in C04(nr_id_transacao_p,r_C05_w.nr_seq_conta_proc,r_C05_w.nr_seq_segurado,
										r_C05_w.cd_guia_referencia,cd_procedimento_porte_w(i),ie_origem_proced_porte_w(i),
										r_C05_w.dt_procedimento_trunc, r_C01_w.ie_considera_data) loop
									tb_valido_w(nr_idx_w)		:= 'S';
									tb_seq_selecao_w(nr_idx_w)	:= r_C04_w.nr_seq_selecao;
									tb_observacao_w(nr_idx_w)	:= '';

									if (nr_idx_w = pls_util_cta_pck.qt_registro_transacao_w) then

										CALL pls_ocor_imp_pck.gerencia_selecao_validacao(	tb_seq_selecao_w, tb_valido_w, tb_observacao_w, nr_id_transacao_p,'SEQ');

										nr_idx_w := 0;
										SELECT * FROM pls_ocor_imp_pck.limpar_nested_tables(tb_seq_selecao_w, tb_valido_w, tb_observacao_w) INTO STRICT _ora2pg_r;
 tb_seq_selecao_w := _ora2pg_r.tb_nr_seq_selecao_p; tb_valido_w := _ora2pg_r.tb_ie_valido_p; tb_observacao_w := _ora2pg_r.tb_ds_observacao_p;
									else
										nr_idx_w := nr_idx_w + 1;
									end if;

								end loop;
							end loop;
						end if;
					end if;
				end loop;
			end if;

			/*Lança as glosas caso existir registros que não foram gerados*/

			if (nr_idx_w > 0)	then
				CALL pls_ocor_imp_pck.gerencia_selecao_validacao(	tb_seq_selecao_w, tb_valido_w, tb_observacao_w, nr_id_transacao_p,'SEQ');

			end if;

			CALL pls_ocor_imp_pck.atualiza_campo_valido('V', 'N', ie_regra_excecao_p, null, nr_id_transacao_p, null);
		end if;
	end loop;
end if;

cd_procedimento_porte_w.delete;
ie_origem_proced_porte_w.delete;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE pls_oc_cta_tratar_val_78_imp ( nr_seq_combinada_p pls_oc_cta_combinada.nr_sequencia%type, ie_regra_excecao_p pls_oc_cta_combinada.ie_excecao%type, nr_id_transacao_p pls_oc_cta_selecao_imp.nr_id_transacao%type, cd_estabelecimento_p estabelecimento.cd_estabelecimento%type) FROM PUBLIC;

