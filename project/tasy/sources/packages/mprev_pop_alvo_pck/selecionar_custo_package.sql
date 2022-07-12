-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';


	-->>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>INSERIR CUSTO<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<--



CREATE OR REPLACE PROCEDURE mprev_pop_alvo_pck.selecionar_custo ( nr_seq_regra_cubo_p bigint, nr_seq_populacao_p bigint, nm_usuario_p text) AS $body$
DECLARE


	c_regra_custo CURSOR(nr_seq_regra_cubo_pc	bigint) FOR
		SELECT	a.nr_sequencia,
		        a.vl_custo_medio_minimo,
		        a.vl_custo_medio_maximo,
		        a.vl_sinistralidade_minima,
		        a.vl_sinistralidade_maxima,
		        a.ie_incluir
		from	mprev_regra_cubo_custo a
		where	a.nr_seq_regra_cubo	= nr_seq_regra_cubo_pc;

	regra_custo_w	regra_custo;
	nr_seq_benef_w	bigint;
	cursor_w	sql_pck.t_cursor;

	-- Tabela para inserir a sequencia do beneficiario que retorna do select dinamico "ds_select_w".

	tb_pop_alvo_sel_custo_w	pls_util_cta_pck.t_number_table;

	
BEGIN

	update	mprev_populacao_alvo
	set	dt_inicio_filtro_custo	= clock_timestamp()
	where	nr_sequencia	= nr_seq_populacao_p;

	/* Monta select dinamico */


	PERFORM set_config('mprev_pop_alvo_pck.ds_select_w', ' select	benef.nr_sequencia ' || current_setting('mprev_pop_alvo_pck.enter_w')::pls_util_pck.enter_w%type ||
				' from		mprev_benef_cubo_ops benef ' || current_setting('mprev_pop_alvo_pck.enter_w')::pls_util_pck.enter_w%type ||
				' where 	1 = 1 ', false);

	if (nr_seq_regra_cubo_p IS NOT NULL AND nr_seq_regra_cubo_p::text <> '')then
		for r_c_regra_custo in c_regra_custo(nr_seq_regra_cubo_p) loop
			regra_custo_w.vl_custo_medio_minimo	:= r_c_regra_custo.vl_custo_medio_minimo;
			regra_custo_w.vl_custo_medio_maximo     := r_c_regra_custo.vl_custo_medio_maximo;
			regra_custo_w.vl_sinistralidade_minima  := r_c_regra_custo.vl_sinistralidade_minima;
			regra_custo_w.vl_sinistralidade_maxima  := r_c_regra_custo.vl_sinistralidade_maxima;
			regra_custo_w.ie_incluir		:= r_c_regra_custo.ie_incluir;

			PERFORM set_config('mprev_pop_alvo_pck.ds_restricao_w', mprev_pop_alvo_pck.obter_restricao_custo(regra_custo_w), false);

			PERFORM set_config('mprev_pop_alvo_pck.ds_select_comp_w', current_setting('mprev_pop_alvo_pck.ds_select_w')::varchar(2000) || current_setting('mprev_pop_alvo_pck.ds_restricao_w')::varchar(4000), false);

			current_setting('mprev_pop_alvo_pck.bind_sql_w')::sql_pck.t_dado_bind := sql_pck.executa_sql_cursor(current_setting('mprev_pop_alvo_pck.ds_select_comp_w')::varchar(4000), current_setting('mprev_pop_alvo_pck.bind_sql_w')::sql_pck.t_dado_bind);

			loop

				tb_pop_alvo_sel_custo_w.delete;

				fetch	cursor_w bulk collect
				into	tb_pop_alvo_sel_custo_w
				limit	current_setting('mprev_pop_alvo_pck.qt_reg_commit_w')::integer;

				exit when tb_pop_alvo_sel_custo_w.count = 0;

				-- Incluir as pessoas na selecao

				forall i in tb_pop_alvo_sel_custo_w.first .. tb_pop_alvo_sel_custo_w.last
					insert into mprev_pop_alvo_selecao(nr_sequencia, nm_usuario, dt_atualizacao,
						nr_seq_populacao_alvo, nr_seq_benef_cubo, ie_selecionar,
						nm_tabela_regra_cubo, nr_seq_tabela_regra_cubo)
					values (nextval('mprev_pop_alvo_selecao_seq'), nm_usuario_p, clock_timestamp(),
						nr_seq_populacao_p, tb_pop_alvo_sel_custo_w(i),
						regra_custo_w.ie_incluir, 'MPREV_REGRA_CUBO_CUSTO', 4);
				commit;
			end loop;
			close cursor_w;
		end loop;
		commit;
	end if;

	update	mprev_populacao_alvo
	set	dt_fim_filtro_custo	= clock_timestamp()
	where	nr_sequencia	= nr_seq_populacao_p;

	END;

$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE mprev_pop_alvo_pck.selecionar_custo ( nr_seq_regra_cubo_p bigint, nr_seq_populacao_p bigint, nm_usuario_p text) FROM PUBLIC;
