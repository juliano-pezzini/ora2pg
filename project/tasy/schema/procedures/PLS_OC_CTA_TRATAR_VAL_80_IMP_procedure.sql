-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE pls_oc_cta_tratar_val_80_imp ( nr_seq_combinada_p pls_oc_cta_combinada.nr_sequencia%type, ie_regra_excecao_p pls_oc_cta_combinada.ie_excecao%type, nr_id_transacao_p pls_oc_cta_selecao_imp.nr_id_transacao%type) AS $body$
DECLARE


_ora2pg_r RECORD;
/* +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
Finalidade:	Aplicar a validação de suspensão de atendimento da cooperativa
		para evento de importação de XML
-------------------------------------------------------------------------------------------------------------------
Locais de chamada direta:
[X]  Objetos do dicionário [ ] Tasy (Delphi/Java) [  ] Portal [  ]  Relatórios [ ] Outros:
------------------------------------------------------------------------------------------------------------------
++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++ */
ie_gera_ocorrencia_w	varchar(1);
qt_registro_w			smallint;
tb_seq_selecao_w		pls_util_cta_pck.t_number_table;
tb_valido_w				pls_util_cta_pck.t_varchar2_table_1;
tb_observacao_w			pls_util_cta_pck.t_varchar2_table_4000;
nr_idx_w				integer := 0;

-- Cursor das regras
C01 CURSOR(	nr_seq_oc_cta_comb_p	pls_oc_cta_combinada.nr_sequencia%type) FOR
	SELECT		a.ie_valida
	from		pls_oc_cta_val_sus_cop a
	where		a.nr_seq_oc_cta_comb	= nr_seq_oc_cta_comb_p;

-- Cursor das contas, busca também data de inicio e fim da suspensão para ser validado depois se a conta está ou não no período de suspensão
C02 CURSOR(	nr_id_transacao_pc	pls_oc_cta_selecao_ocor_v.nr_sequencia%type)	FOR
	SELECT 	sel.nr_sequencia 			nr_seq_selecao,
			conta.dt_atendimento_conv	dt_atendimento,
			seg.nr_seq_congenere 		nr_seq_congenere_seg,
			conta.nr_sequencia 			nr_seq_conta
	from	pls_oc_cta_selecao_imp	sel,
			pls_segurado			seg,
			pls_conta_imp_v			conta
	where	sel.nr_id_transacao = nr_id_transacao_pc
	and		sel.nr_seq_segurado	= seg.nr_sequencia
	and 	conta.nr_sequencia	= sel.nr_seq_conta
	and		sel.ie_valido = 'S';
BEGIN



if (nr_seq_combinada_p IS NOT NULL AND nr_seq_combinada_p::text <> '')  then

	-- tratamento em campo auxiliar para identificar posteriormente os registros que foram alterados
	CALL pls_ocor_imp_pck.atualiza_campo_auxiliar('V', 'N', nr_id_transacao_p, null, 'N');

	-- Incializar as listas para cada regra.
	SELECT * FROM pls_ocor_imp_pck.limpar_nested_tables(	tb_seq_selecao_w, tb_valido_w, tb_observacao_w) INTO STRICT _ora2pg_r;
 	tb_seq_selecao_w := _ora2pg_r.tb_nr_seq_selecao_p; tb_valido_w := _ora2pg_r.tb_ie_valido_p; tb_observacao_w := _ora2pg_r.tb_ds_observacao_p;
	nr_idx_w:=	0;

	for r_C01_w in C01(nr_seq_combinada_p) loop

		if (r_C01_w.ie_valida = 'S')	then

			for r_C02_w in C02(nr_id_transacao_p) loop

				ie_gera_ocorrencia_w := 'N';

				select 	max(qt_registro)
				into STRICT	qt_registro_w
				from (SELECT 1 qt_registro
					from   pls_segurado_suspensao
					where  nr_seq_congenere = r_C02_w.nr_seq_congenere_seg
					and    r_C02_w.dt_atendimento between dt_inicio_suspensao and dt_fim_suspensao
					
union all

					SELECT 1 qt_registro
					from   pls_segurado_suspensao
					where  nr_seq_congenere = r_C02_w.nr_seq_congenere_seg
					and    dt_inicio_suspensao <= r_C02_w.dt_atendimento
					and    coalesce(dt_fim_suspensao::text, '') = '') alias2;

				if ( qt_registro_w > 0) then
					ie_gera_ocorrencia_w := 'S';
				end if;

				if ( ie_gera_ocorrencia_w = 'S') then

					tb_seq_selecao_w(nr_idx_w)	:= r_C02_w.nr_seq_selecao;
					tb_valido_w(nr_idx_w)		:= 'S';
					tb_observacao_w(nr_idx_w)	:= ' Operadora está em período de suspensão de atendimento. ';

					if (nr_idx_w = pls_util_cta_pck.qt_registro_transacao_w) then

						--Grava as informações na tabela de seleção
						CALL pls_ocor_imp_pck.gerencia_selecao_validacao(	tb_seq_selecao_w,
												tb_valido_w,
												tb_observacao_w,
												nr_id_transacao_p,
												'SEQ');
						--limpa as variáveis
						SELECT * FROM pls_ocor_imp_pck.limpar_nested_tables(	tb_seq_selecao_w, tb_valido_w, tb_observacao_w) INTO STRICT _ora2pg_r;
 	tb_seq_selecao_w := _ora2pg_r.tb_nr_seq_selecao_p; tb_valido_w := _ora2pg_r.tb_ie_valido_p; tb_observacao_w := _ora2pg_r.tb_ds_observacao_p;

						nr_idx_w := 0;
					else
						nr_idx_w := nr_idx_w + 1;
					end if;
				end if;
			end loop; --C02
		end if;

			--Grava as informações na tabela de seleção
		CALL pls_ocor_imp_pck.gerencia_selecao_validacao(	tb_seq_selecao_w, tb_valido_w,
								tb_observacao_w, nr_id_transacao_p, 'SEQ');

		-- seta os registros que serão válidos ou inválidos após o processamento
		CALL pls_ocor_imp_pck.atualiza_campo_valido('V', 'N', ie_regra_excecao_p,
							null, nr_id_transacao_p, null);

	end loop; --C01
end if;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE pls_oc_cta_tratar_val_80_imp ( nr_seq_combinada_p pls_oc_cta_combinada.nr_sequencia%type, ie_regra_excecao_p pls_oc_cta_combinada.ie_excecao%type, nr_id_transacao_p pls_oc_cta_selecao_imp.nr_id_transacao%type) FROM PUBLIC;
