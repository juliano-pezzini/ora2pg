-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE pls_oc_cta_tratar_val_3_imp ( nr_seq_combinada_p pls_oc_cta_combinada.nr_sequencia%type, ie_regra_excecao_p pls_oc_cta_combinada.ie_excecao%type, nr_id_transacao_p pls_oc_cta_selecao_imp.nr_id_transacao%type, nm_usuario_p usuario.nm_usuario%type) AS $body$
DECLARE


_ora2pg_r RECORD;
-- Regra de validacao do sexo exclusivo do procedimento.
C01 CURSOR(nr_seq_oc_cta_combinada_pc	pls_oc_cta_combinada.nr_sequencia%type) FOR
	SELECT	a.nr_sequencia
	from	pls_oc_cta_val_sexo_proc a
	where	a.nr_seq_oc_cta_comb	= nr_seq_oc_cta_combinada_pc
	and	a.ie_valida_sexo_proc	= 'S';

-- Procedimentos que entraram nos filtros e nas validações até então.
C02 CURSOR(	nr_id_transacao_pc	pls_oc_cta_selecao_imp.nr_id_transacao%type) FOR
	SELECT	proc.nr_sequencia nr_seq_conta_proc,
		proc.nr_seq_conta,
		proc.cd_procedimento_conv,
		proc.ie_origem_proced_conv,
		conta.nr_seq_segurado_conv,
		coalesce((SELECT	max(ie_sexo_sus)
			from	procedimento
			where	ie_origem_proced	= proc.ie_origem_proced_conv
			and	cd_procedimento		= proc.cd_procedimento_conv),'I') ie_sexo_sus,
		sel.nr_sequencia
	from	pls_oc_cta_selecao_imp sel,
		pls_conta_proc_imp proc,
		pls_conta_imp conta
	where	sel.nr_id_transacao	= nr_id_transacao_pc
	and	sel.ie_valido		= 'S'
	and	sel.ie_tipo_registro	= 'P'
	and	proc.nr_sequencia	= sel.nr_seq_conta_proc
	and	conta.nr_sequencia	= proc.nr_seq_conta;

i			integer;
tb_seq_selecao_w	pls_util_cta_pck.t_number_table;
tb_valido_w		pls_util_cta_pck.t_varchar2_table_1;
tb_observacao_w		pls_util_cta_pck.t_varchar2_table_4000;
ie_sexo_w		pessoa_fisica.ie_sexo%type;
ie_gera_ocorrencia_w	pls_oc_cta_selecao_ocor_v.ie_valido%type;
BEGIN

-- Deve existir a informação da regra e da transação para que seja possível executar a validação
if (nr_seq_combinada_p IS NOT NULL AND nr_seq_combinada_p::text <> '') and (nr_id_transacao_p IS NOT NULL AND nr_id_transacao_p::text <> '') then

	-- Dados da regra de validacção do sexo do procedimento, só irá retornar algo se for para validar o sexo do procedimento( ie_valida_sexo_proc = 'S')
	for	r_C01_w in C01(nr_seq_combinada_p) loop

		-- tratamento em campo auxiliar para identificar posteriormente os registros que foram alterados
		CALL pls_ocor_imp_pck.atualiza_campo_auxiliar('V', 'N', nr_id_transacao_p, null);

		-- Incializar as listas para cada regra.
		SELECT * FROM pls_ocor_imp_pck.limpar_nested_tables(	tb_seq_selecao_w, tb_valido_w, tb_observacao_w) INTO STRICT _ora2pg_r;
 	tb_seq_selecao_w := _ora2pg_r.tb_nr_seq_selecao_p; tb_valido_w := _ora2pg_r.tb_ie_valido_p; tb_observacao_w := _ora2pg_r.tb_ds_observacao_p;

		-- Iniciar o índice para preenchimento da tabela.
		i := 0;
		-- Procedimentos que entraram nos filtros da regra. Só entraram procedimentos que tiverem registro
		-- na tabela pls_oc_cta_selecao_imp e o mesmo for válido (ie_valido = 'S').
		for	r_C02_w in C02(nr_id_transacao_p) loop

			ie_gera_ocorrencia_w := 'S';
			-- Inicializar os valores que serão atualizados na tabela de seleção.
			tb_observacao_w(i)  := null;
			tb_seq_selecao_w(i) := r_C02_w.nr_sequencia;

			-- Só é possível executar a validação se obtiver a informação do segurado e do procedimento;
			if (r_C02_w.nr_seq_segurado_conv IS NOT NULL AND r_C02_w.nr_seq_segurado_conv::text <> '') and (r_C02_w.nr_seq_conta_proc IS NOT NULL AND r_C02_w.nr_seq_conta_proc::text <> '') then

				-- Se o procedimento tiver sexo exclusivo informado então deve ser verificado o  sexo do beneficiário.
				if (r_C02_w.ie_sexo_sus <> 'I') then

					-- Obter o sexo do beneficiário.
					select	max(b.ie_sexo)
					into STRICT	ie_sexo_w
					from	pls_segurado a,
						pessoa_fisica b
					where	a.nr_sequencia		= r_C02_w.nr_seq_segurado_conv
					and	b.cd_pessoa_fisica	= a.cd_pessoa_fisica;

					-- Se o procedimento é exclusivo para um dos sexos e o sexo do beneficiário for o mesmo então ele é exceção e não
					-- será gerado a ocorrência. Se o beneficiário não tiver sexo informado deve ser gerada a ocorrência para que seja verificado o cadastro
					-- do mesmo.
					if (ie_sexo_w = r_C02_w.ie_sexo_sus) or (ie_sexo_w = 'I') then
						ie_gera_ocorrencia_w := 'N';
					end if;
				else
					-- Se o procedimento não exigir sexo exclusivo então a ocorrência não pode ser gerada para este item.
					ie_gera_ocorrencia_w := 'N';
				end if;

			end if;

			-- Verificar se o registro atual é válido ou não conforme as parametrizações de regras e regras de exceção.
			tb_valido_w(i) := ie_gera_ocorrencia_w;

			-- na próxima carga.
			if (i = pls_cta_consistir_pck.qt_registro_transacao_w) then

				-- Será passado uma lista com todas a sequencias da seleção para a conta e para seus itens, estas sequências serão atualizadas com os mesmos dados da conta,
				-- conforme passado por parâmetro,
				CALL pls_ocor_imp_pck.gerencia_selecao_validacao(	tb_seq_selecao_w, tb_valido_w,
										tb_observacao_w, nr_id_transacao_p,
										'SEQ');

				--limpa as variáveis
				SELECT * FROM pls_ocor_imp_pck.limpar_nested_tables(	tb_seq_selecao_w, tb_valido_w, tb_observacao_w) INTO STRICT _ora2pg_r;
 	tb_seq_selecao_w := _ora2pg_r.tb_nr_seq_selecao_p; tb_valido_w := _ora2pg_r.tb_ie_valido_p; tb_observacao_w := _ora2pg_r.tb_ds_observacao_p;
				-- Zerar o índice
				i := 0;


			else
				-- Enquanto os registros não tiverem atingido a carga para gravar na seleção incrementa o índice para armazenar os próximos registros.
				i := i + 1;
			end if;

		end loop; -- C02
		--grava os dados restantes se existirem na tabela
		CALL pls_ocor_imp_pck.gerencia_selecao_validacao(	tb_seq_selecao_w, tb_valido_w,
								tb_observacao_w, nr_id_transacao_p,
								'SEQ');

		-- seta os registros que serão válidos ou inválidos após o processamento
		CALL pls_ocor_imp_pck.atualiza_campo_valido('V', 'N',
							ie_regra_excecao_p, null,
							nr_id_transacao_p, null);

	end loop;-- C01
end if;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE pls_oc_cta_tratar_val_3_imp ( nr_seq_combinada_p pls_oc_cta_combinada.nr_sequencia%type, ie_regra_excecao_p pls_oc_cta_combinada.ie_excecao%type, nr_id_transacao_p pls_oc_cta_selecao_imp.nr_id_transacao%type, nm_usuario_p usuario.nm_usuario%type) FROM PUBLIC;
