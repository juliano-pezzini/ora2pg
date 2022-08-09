-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE pls_oc_cta_tratar_val_9_imp ( nr_seq_combinada_p pls_oc_cta_combinada.nr_sequencia%type, ie_regra_excecao_p pls_oc_cta_combinada.ie_excecao%type, nr_id_transacao_p pls_oc_cta_selecao_imp.nr_id_transacao%type) AS $body$
DECLARE


_ora2pg_r RECORD;
i				integer;
ie_gera_ocorrencia_w		varchar(1);
tb_seq_selecao_w		pls_util_cta_pck.t_number_table;
tb_valido_w			pls_util_cta_pck.t_varchar2_table_1;
tb_observacao_w			pls_util_cta_pck.t_varchar2_table_4000;
ie_prestador_referencia_w	varchar(50);
ds_sql_w			varchar(4000);
dt_exclusao_w			pls_prestador.dt_exclusao%type;
dt_cadastro_w			pls_prestador.dt_cadastro%type;
ie_situacao_w			pls_prestador.ie_situacao%type;
dt_atendimento_w		pls_conta.dt_atendimento_referencia%type;
nr_seq_conta_w			pls_conta.nr_sequencia%type;
valor_bind_w			sql_pck.t_dado_bind;
cursor_w			sql_pck.t_cursor;

-- Informações da validação de situação inativa do prestador
C01 CURSOR(	nr_seq_oc_cta_comb_p	pls_oc_cta_combinada.nr_sequencia%type) FOR
	SELECT	a.ie_tipo_prestador,
		coalesce(a.ie_forma_inativacao, 'D') ie_forma_inativacao
	from	pls_oc_cta_val_sit_prest a
	where	a.nr_seq_oc_cta_comb	= nr_seq_oc_cta_comb_p;

C03 CURSOR(	nr_id_transacao_pc pls_oc_cta_selecao_imp.nr_id_transacao%type) FOR
	SELECT (SELECT	x.dt_exclusao
		from	pls_prestador x
		where	x.nr_sequencia = a.nr_seq_prestador_conv) dt_exc_prest,
		(select	x.dt_cadastro
		from	pls_prestador x
		where	x.nr_sequencia = a.nr_seq_prestador_conv) dt_cad_prest,
		(select	x.ie_situacao
		from	pls_prestador x
		where	x.nr_sequencia = a.nr_seq_prestador_conv) ie_situacao_prest,
		c.dt_atendimento_conv dt_atendimento,
		c.nr_sequencia nr_seq_conta
	from	pls_conta_item_equipe_imp a,
		pls_conta_item_imp b,
		pls_conta_imp c
	where	c.nr_sequencia = b.nr_seq_conta
	and	b.nr_sequencia = a.nr_seq_conta_item
	and	exists (	select	1
			from	pls_oc_cta_selecao_imp sel
			where	sel.nr_id_transacao = nr_id_transacao_pc
			and	sel.ie_valido = 'S'
			and	sel.nr_seq_conta = c.nr_sequencia);
BEGIN


-- Deve se ter a informação da regra para que a validação seja aplicada.
if (nr_seq_combinada_p IS NOT NULL AND nr_seq_combinada_p::text <> '') and (nr_id_transacao_p IS NOT NULL AND nr_id_transacao_p::text <> '')  then

	-- tratamento em campo auxiliar para identificar posteriormente os registros que foram alterados
	CALL pls_ocor_imp_pck.atualiza_campo_auxiliar('V', 'N', nr_id_transacao_p, null);

	--limpa as variáveis
	SELECT * FROM pls_ocor_imp_pck.limpar_nested_tables(	tb_seq_selecao_w, tb_valido_w, tb_observacao_w) INTO STRICT _ora2pg_r;
 	tb_seq_selecao_w := _ora2pg_r.tb_nr_seq_selecao_p; tb_valido_w := _ora2pg_r.tb_ie_valido_p; tb_observacao_w := _ora2pg_r.tb_ds_observacao_p;

	i := 0;
	-- Buscar os dados da regra de validação conforme montado pelo usuário.
	for	r_C01_w in C01(nr_seq_combinada_p) loop

		if (r_C01_w.ie_tipo_prestador <> 'P') then
			-- Busca o campo do prestador referencia
			if (r_C01_w.ie_tipo_prestador = 'E') then
				ie_prestador_referencia_w := 'conta.nr_seq_prest_exec_conv';
			elsif (r_C01_w.ie_tipo_prestador = 'S') then
				ie_prestador_referencia_w := 'conta.nr_seq_prest_solic_conv';
			elsif (r_C01_w.ie_tipo_prestador = 'L') then
				ie_prestador_referencia_w := 'prot.nr_seq_prestador_conv';
			end if;

			ds_sql_w := 	'	select	x.dt_exclusao,							' || pls_util_pck.enter_w ||
					'		x.dt_cadastro,							' || pls_util_pck.enter_w ||
					'		x.ie_situacao,							' || pls_util_pck.enter_w ||
					'		conta.dt_atendimento_conv,					' || pls_util_pck.enter_w ||
					'		conta.nr_sequencia						' || pls_util_pck.enter_w ||
					'	from	pls_conta_imp conta,						' || pls_util_pck.enter_w ||
					'		pls_protocolo_conta_imp prot,					' || pls_util_pck.enter_w ||
					'		pls_prestador x							' || pls_util_pck.enter_w ||
					'	where	prot.nr_sequencia = conta.nr_seq_protocolo			' || pls_util_pck.enter_w ||
					'	and	x.nr_sequencia = ' || ie_prestador_referencia_w || pls_util_pck.enter_w ||
					'	and	exists(	select	1						' || pls_util_pck.enter_w ||
					'			from	pls_oc_cta_selecao_imp sel			' || pls_util_pck.enter_w ||
					'			where	sel.nr_id_transacao = :nr_id_transacao	 	' || pls_util_pck.enter_w ||
					'			and	sel.ie_valido = ''S''				' || pls_util_pck.enter_w ||
					'			and	sel.nr_seq_conta = conta.nr_sequencia)		';

			-- Alimenta a bind
			valor_bind_w := sql_pck.bind_variable(':nr_id_transacao', nr_id_transacao_p, valor_bind_w);
			-- Monta o cursor
			valor_bind_w := sql_pck.executa_sql_cursor(ds_sql_w, valor_bind_w);


			loop

				fetch 	cursor_w
				into	dt_exclusao_w,
					dt_cadastro_w,
					ie_situacao_w,
					dt_atendimento_w,
					nr_seq_conta_w;
				EXIT WHEN NOT FOUND; /* apply on cursor_w */

				ie_gera_ocorrencia_w := 'N';
				-- Nesse IF é verificado as três possibilidades do campo ie_forma_inativacao sendo
				-- D - Datas
				-- S - Situação
				-- DS - Data e situação
				if	((r_C01_w.ie_forma_inativacao = 'D') and
					((dt_atendimento_w < dt_cadastro_w) or (dt_atendimento_w > dt_exclusao_w)))
					or (r_C01_w.ie_forma_inativacao = 'S' and ie_situacao_w = 'I')
					or
					((r_C01_w.ie_forma_inativacao = 'DS') and
					((dt_atendimento_w < dt_cadastro_w) or (dt_atendimento_w > dt_exclusao_w) or (ie_situacao_w = 'I'))) then
					ie_gera_ocorrencia_w := 'S';
				end if;

				if (ie_gera_ocorrencia_w = 'S') then
					--Passa nr_sequencia da pls_conta_imp
					tb_seq_selecao_w(i) := nr_seq_conta_w;
					tb_valido_w(i)	    := 'S';
					tb_observacao_w(i)  := null;

					if ( i >= pls_util_pck.qt_registro_transacao_w) then

						--Grava as informações na tabela de seleção
						CALL pls_ocor_imp_pck.gerencia_selecao_validacao(	tb_seq_selecao_w, tb_valido_w,
												tb_observacao_w, nr_id_transacao_p,
												'SEQ_CONTA');

						--limpa as variáveis
						SELECT * FROM pls_ocor_imp_pck.limpar_nested_tables(	tb_seq_selecao_w, tb_valido_w, tb_observacao_w) INTO STRICT _ora2pg_r;
 	tb_seq_selecao_w := _ora2pg_r.tb_nr_seq_selecao_p; tb_valido_w := _ora2pg_r.tb_ie_valido_p; tb_observacao_w := _ora2pg_r.tb_ds_observacao_p;

						i := 0;
					else
						i := i + 1;
					end if;
				end if;
			end loop;
			close cursor_w;
		else
			for r_C03_w in C03(nr_id_transacao_p) loop

				ie_gera_ocorrencia_w := 'N';
				-- Nesse IF é verificado as três possibilidades do campo ie_forma_inativacao sendo
				-- D - Datas
				-- S - Situação
				-- DS - Data e situação
				if	((r_C01_w.ie_forma_inativacao = 'D') and
					((r_C03_w.dt_atendimento < r_C03_w.dt_cad_prest) or (r_C03_w.dt_atendimento > r_C03_w.dt_exc_prest)))
					or (r_C01_w.ie_forma_inativacao = 'S' and r_C03_w.ie_situacao_prest = 'I')
					or
					((r_C01_w.ie_forma_inativacao = 'DS') and
					((r_C03_w.dt_atendimento < r_C03_w.dt_cad_prest) or (r_C03_w.dt_atendimento > r_C03_w.dt_exc_prest) or (r_C03_w.ie_situacao_prest = 'I'))) then
					ie_gera_ocorrencia_w := 'S';
				end if;

				if (ie_gera_ocorrencia_w = 'S') then
					--Passa nr_sequencia da pls_conta_imp
					tb_seq_selecao_w(i) := r_C03_w.nr_seq_conta;
					tb_valido_w(i)	    := 'S';
					tb_observacao_w(i)  := null;

					if ( i >= pls_util_pck.qt_registro_transacao_w) then

						--Grava as informações na tabela de seleção
						CALL pls_ocor_imp_pck.gerencia_selecao_validacao(	tb_seq_selecao_w, tb_valido_w,
												tb_observacao_w, nr_id_transacao_p,
												'SEQ_CONTA');

						--limpa as variáveis
						SELECT * FROM pls_ocor_imp_pck.limpar_nested_tables(	tb_seq_selecao_w, tb_valido_w, tb_observacao_w) INTO STRICT _ora2pg_r;
 	tb_seq_selecao_w := _ora2pg_r.tb_nr_seq_selecao_p; tb_valido_w := _ora2pg_r.tb_ie_valido_p; tb_observacao_w := _ora2pg_r.tb_ds_observacao_p;

						i := 0;
					else
						i := i + 1;
					end if;
				end if;
			end loop;
		end if;
	end loop; -- C01
	--Grava as informações na tabela de seleção
	CALL pls_ocor_imp_pck.gerencia_selecao_validacao(	tb_seq_selecao_w, tb_valido_w,
							tb_observacao_w, nr_id_transacao_p,
							'SEQ_CONTA');

	-- seta os registros que serão válidos ou inválidos após o processamento
	CALL pls_ocor_imp_pck.atualiza_campo_valido('V', 'N',
						ie_regra_excecao_p, null,
						nr_id_transacao_p, null);
end if;
end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE pls_oc_cta_tratar_val_9_imp ( nr_seq_combinada_p pls_oc_cta_combinada.nr_sequencia%type, ie_regra_excecao_p pls_oc_cta_combinada.ie_excecao%type, nr_id_transacao_p pls_oc_cta_selecao_imp.nr_id_transacao%type) FROM PUBLIC;
