-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE pls_oc_cta_tratar_val_101_imp ( nr_seq_combinada_p pls_oc_cta_combinada.nr_sequencia%type, ie_regra_excecao_p pls_oc_cta_combinada.ie_excecao%type, nr_id_transacao_p pls_oc_cta_selecao_imp.nr_id_transacao%type) AS $body$
DECLARE

_ora2pg_r RECORD;
/* ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
Finalidade: 	Verificar quais são os tipos de tabela aceitos para o material
+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++*/
i			integer;
ie_valido_w		pls_oc_cta_selecao_imp.ie_valido%type;
tb_seq_selecao_w	pls_util_cta_pck.t_number_table;
tb_valido_w		pls_util_cta_pck.t_varchar2_table_1;
tb_observacao_w		pls_util_cta_pck.t_varchar2_table_4000;

C01 CURSOR(nr_seq_oc_cta_comb_pc	pls_oc_cta_combinada.nr_sequencia%type) FOR
	SELECT	a.ie_tipo_tabela_pode,
		a.ie_valida_tab_tiss
	from	pls_oc_cta_val_tab_mat 	a
	where	a.nr_seq_oc_cta_comb 	= nr_seq_oc_cta_comb_pc;

C02 CURSOR(	nr_id_transacao_pc	pls_oc_cta_selecao_imp.nr_id_transacao%type) FOR
	SELECT	sel.nr_sequencia 	nr_seq_selecao,
		mat.cd_simpro,
		mat.cd_tiss_brasindice,
		c_item.cd_tipo_tabela_conv
	from	pls_oc_cta_selecao_imp 	sel,
		pls_material mat,
		pls_conta_mat_imp c_mat,
		pls_conta_item_imp c_item
	where	sel.nr_id_transacao 	= nr_id_transacao_pc
	and	sel.ie_valido 		= 'S'
	and	mat.nr_sequencia 	= sel.nr_seq_material
	and 	sel.nr_seq_conta_mat	= c_mat.nr_sequencia
	and	c_mat.nr_seq_item_conta	= c_item.nr_sequencia;
BEGIN

if (nr_seq_combinada_p IS NOT NULL AND nr_seq_combinada_p::text <> '') then

	-- tratamento em campo auxiliar para identificar posteriormente os registros que foram alterados
	CALL pls_ocor_imp_pck.atualiza_campo_auxiliar('V', ie_regra_excecao_p, nr_id_transacao_p, null);

	-- Incializar as listas para cada regra.
	SELECT * FROM pls_ocor_imp_pck.limpar_nested_tables(tb_seq_selecao_w, tb_valido_w, tb_observacao_w) INTO STRICT _ora2pg_r;
 tb_seq_selecao_w := _ora2pg_r.tb_nr_seq_selecao_p; tb_valido_w := _ora2pg_r.tb_ie_valido_p; tb_observacao_w := _ora2pg_r.tb_ds_observacao_p;
	i			:= 0;

	-- Abre o cursor da regra
	for r_C01_w in C01(nr_seq_combinada_p) loop

		-- abre o cursor com os itens
		for r_C02_w in C02(nr_id_transacao_p) loop

			-- por padrão sempre gera ocorrência
			ie_valido_w := 'S';

			-- se for Simpro ou Brasíndice
			if (r_C01_w.ie_tipo_tabela_pode = '1') then
				if ((r_C02_w.cd_simpro IS NOT NULL AND r_C02_w.cd_simpro::text <> '') or (r_C02_w.cd_tiss_brasindice IS NOT NULL AND r_C02_w.cd_tiss_brasindice::text <> '')) then
					ie_valido_w := 'N';
				end if;
			-- se for Simpro e Brasíndice
			elsif (r_C01_w.ie_tipo_tabela_pode = '2') then
				if (r_C02_w.cd_simpro IS NOT NULL AND r_C02_w.cd_simpro::text <> '' AND r_C02_w.cd_tiss_brasindice IS NOT NULL AND r_C02_w.cd_tiss_brasindice::text <> '') then
					ie_valido_w := 'N';
				end if;
			end if;

			if (r_C02_w.cd_tipo_tabela_conv in (0, 18, 19, 20) or r_C01_w.ie_valida_tab_tiss = 'N') then
				begin
				ie_valido_w := 'N';
				end;
			end if;

			-- se for para gerar
			if (ie_valido_w = 'S') then

				tb_seq_selecao_w(i) := r_C02_w.nr_seq_selecao;
				tb_observacao_w(i) := null;
				tb_valido_w(i) := ie_valido_w;

				-- se atingiu a quantidade manda para o banco, senão só incrementa o contador i
				if (i >= pls_util_pck.qt_registro_transacao_w) then
					CALL pls_ocor_imp_pck.gerencia_selecao_validacao(	tb_seq_selecao_w, tb_valido_w, tb_observacao_w,
											nr_id_transacao_p, 'SEQ');

					-- Incializar as listas para cada regra.
					SELECT * FROM pls_ocor_imp_pck.limpar_nested_tables(tb_seq_selecao_w, tb_valido_w, tb_observacao_w) INTO STRICT _ora2pg_r;
 tb_seq_selecao_w := _ora2pg_r.tb_nr_seq_selecao_p; tb_valido_w := _ora2pg_r.tb_ie_valido_p; tb_observacao_w := _ora2pg_r.tb_ds_observacao_p;
					i:= 0;
				else
					-- Caso não, alimenta o contador
					i := i + 1;
				end if;
			end if;
		end loop;

		-- se sobrou alguma coisa manda para o banco
		CALL pls_ocor_imp_pck.gerencia_selecao_validacao(	tb_seq_selecao_w, tb_valido_w, tb_observacao_w, nr_id_transacao_p, 'SEQ');

		-- seta os registros que serão válidos ou inválidos após o processamento
		CALL pls_ocor_imp_pck.atualiza_campo_valido('V', 'N', ie_regra_excecao_p, null, nr_id_transacao_p, null);
	end loop;
end if;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE pls_oc_cta_tratar_val_101_imp ( nr_seq_combinada_p pls_oc_cta_combinada.nr_sequencia%type, ie_regra_excecao_p pls_oc_cta_combinada.ie_excecao%type, nr_id_transacao_p pls_oc_cta_selecao_imp.nr_id_transacao%type) FROM PUBLIC;

