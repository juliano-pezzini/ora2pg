-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE pls_oc_cta_tratar_val_16_imp ( nr_seq_combinada_p pls_oc_cta_combinada.nr_sequencia%type, ie_regra_excecao_p pls_oc_cta_combinada.ie_excecao%type, nr_id_transacao_p pls_oc_cta_selecao_imp.nr_id_transacao%type) AS $body$
DECLARE


_ora2pg_r RECORD;
i					integer;
ie_gera_ocorrencia_w			varchar(1);
tb_seq_selecao_w			pls_util_cta_pck.t_number_table;
tb_valido_w				pls_util_cta_pck.t_varchar2_table_1;
tb_observacao_w				pls_util_cta_pck.t_varchar2_table_4000;

-- Informações da validação de quantidade fracionada
C01 CURSOR(	nr_seq_oc_cta_comb_pc	pls_oc_cta_combinada.nr_sequencia%type) FOR
	SELECT	ie_qtd_fracionada
	from	pls_oc_cta_val_fracion
	where	nr_seq_oc_cta_comb	= nr_seq_oc_cta_comb_pc;

--Cursor das contas selecionadas
C02 CURSOR(	nr_id_transacao_pc	pls_oc_cta_selecao_imp.nr_id_transacao%type) FOR
	SELECT	proc.qt_executado 	qt_item,
		sel.nr_sequencia
	from	pls_oc_cta_selecao_imp 	sel,
		pls_conta_proc_imp 	proc
	where	sel.nr_id_transacao	= nr_id_transacao_pc
	and	sel.ie_valido 		= 'S'
	and	proc.nr_sequencia	= sel.nr_seq_conta_proc
	
union all

	SELECT	mat.qt_executado 	qt_item,
		sel.nr_sequencia
	from	pls_oc_cta_selecao_imp	sel,
		pls_conta_mat_imp	mat
	where	sel.nr_id_transacao 	= nr_id_transacao_pc
	and	sel.ie_valido 		= 'S'
	and	mat.nr_sequencia	= sel.nr_seq_conta_mat;
BEGIN

-- Deve existir a informação da regra e transação para aplicar a validação
if (nr_seq_combinada_p IS NOT NULL AND nr_seq_combinada_p::text <> '') and (nr_id_transacao_p IS NOT NULL AND nr_id_transacao_p::text <> '')  then

	-- Varrer a parametrização da validação. Para esta validação só pode haver um registro na tabela PLS_OC_CTA_VAL_FRACION.
	for	r_C01_w in C01(nr_seq_combinada_p) loop

		-- Só aplicar a validação quando for definido que a mesma é para ser aplicada
		if (r_C01_w.ie_qtd_fracionada = 'S') then

			-- tratamento em campo auxiliar para identificar posteriormente os registros que foram alterados
			CALL pls_ocor_imp_pck.atualiza_campo_auxiliar('V', 'N', nr_id_transacao_p, null);
			--limpa as variáveis
			SELECT * FROM pls_ocor_imp_pck.limpar_nested_tables(	tb_seq_selecao_w, tb_valido_w, tb_observacao_w) INTO STRICT _ora2pg_r;
 	tb_seq_selecao_w := _ora2pg_r.tb_nr_seq_selecao_p; tb_valido_w := _ora2pg_r.tb_ie_valido_p; tb_observacao_w := _ora2pg_r.tb_ds_observacao_p;
			i := 0;

			for 	r_C02_w in C02(nr_id_transacao_p) loop

				ie_gera_ocorrencia_w := 'N';

				if (mod(r_C02_w.qt_item,1) <> 0) then
					ie_gera_ocorrencia_w := 'S';
				end if;

				if (ie_gera_ocorrencia_w = 'S') then
					tb_seq_selecao_w(i) := r_C02_w.nr_sequencia;
					tb_observacao_w(i)  := null;
					tb_valido_w(i) 	    := 'S';

					--Caso tenha guardado o número de registros pré estabelecido na variável grava na tabela senão incrementa o contador
					if ( i >= pls_util_pck.qt_registro_transacao_w) then

						--Grava as informações na tabela de seleção
						CALL pls_ocor_imp_pck.gerencia_selecao_validacao(	tb_seq_selecao_w, tb_valido_w,
												tb_observacao_w, nr_id_transacao_p,
												'SEQ');
						--limpa as variáveis
						SELECT * FROM pls_ocor_imp_pck.limpar_nested_tables(	tb_seq_selecao_w, tb_valido_w, tb_observacao_w) INTO STRICT _ora2pg_r;
 	tb_seq_selecao_w := _ora2pg_r.tb_nr_seq_selecao_p; tb_valido_w := _ora2pg_r.tb_ie_valido_p; tb_observacao_w := _ora2pg_r.tb_ds_observacao_p;

						i := 0;
					else
						i := i + 1;
					end if;
				end if;
			end loop; --C02
		end if;
	end loop; -- C01
	--Grava o que restar nas variáveis na tabela
	CALL pls_ocor_imp_pck.gerencia_selecao_validacao(	tb_seq_selecao_w, tb_valido_w,
							tb_observacao_w, nr_id_transacao_p,
							'SEQ');
	-- seta os registros que serão válidos ou inválidos após o processamento
	CALL pls_ocor_imp_pck.atualiza_campo_valido(	'V', 'N',
							ie_regra_excecao_p, null,
							nr_id_transacao_p, null);
end if;
end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE pls_oc_cta_tratar_val_16_imp ( nr_seq_combinada_p pls_oc_cta_combinada.nr_sequencia%type, ie_regra_excecao_p pls_oc_cta_combinada.ie_excecao%type, nr_id_transacao_p pls_oc_cta_selecao_imp.nr_id_transacao%type) FROM PUBLIC;

