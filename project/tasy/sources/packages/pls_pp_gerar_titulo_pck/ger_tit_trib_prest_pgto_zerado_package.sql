-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';


-- verifica em todos os prestadores que tiveram valor de pagamento zerado, se existe algum tributo que deve ser gerado um titulo para o mesmo



CREATE OR REPLACE PROCEDURE pls_pp_gerar_titulo_pck.ger_tit_trib_prest_pgto_zerado ( nr_seq_lote_p pls_pp_lote.nr_sequencia%type, cd_estabelecimento_p estabelecimento.cd_estabelecimento%type, nm_usuario_p usuario.nm_usuario%type) AS $body$
DECLARE


tb_cd_tributo_w		pls_util_cta_pck.t_number_table;
tb_dt_pgto_tributo_w	pls_util_cta_pck.t_date_table;
tb_nr_seq_trans_reg_w	pls_util_cta_pck.t_number_table;
tb_nr_seq_trans_baixa_w	pls_util_cta_pck.t_number_table;
tb_cd_beneficiario_w	pls_util_cta_pck.t_varchar2_table_20;
tb_vl_tributo_w		pls_util_cta_pck.t_number_table;
tb_cd_darf_w		pls_util_cta_pck.t_varchar2_table_10;
tb_nr_seq_classe_w	pls_util_cta_pck.t_number_table;
tb_cd_tipo_baixa_neg_w	pls_util_cta_pck.t_number_table;
tb_nr_titulo_imposto_w	pls_util_cta_pck.t_number_table;
tb_nr_seq_pp_prest_w	pls_util_cta_pck.t_number_table;
tb_nm_prestador_w	pls_util_cta_pck.t_varchar2_table_200;
tb_cd_cgc_w		pls_util_cta_pck.t_varchar2_table_20;
tb_cd_conta_finac_w	pls_util_cta_pck.t_number_table;
tb_cd_conta_credito_w	pls_util_cta_pck.t_varchar2_table_20;
tb_cd_conta_financ_w	pls_util_cta_pck.t_number_table;
tb_cd_conta_cont_trib_w	pls_util_cta_pck.t_varchar2_table_20;
cd_empresa_w		estabelecimento.cd_empresa%type;
cd_estab_financeiro_w	estabelecimento.cd_estab_financeiro%type;

c00 CURSOR(  	nr_seq_lote_pc  pls_pp_lote.nr_sequencia%type) FOR
	SELECT  g.nr_sequencia nr_seq_pp_prestador
	from  	pls_pp_prestador g,
		pls_pp_valor_trib_pessoa d
	where 	d.nr_seq_prestador = g.nr_seq_prestador
	and 	d.nr_seq_lote = g.nr_seq_lote
	and 	g.nr_seq_lote = nr_seq_lote_pc
	and 	g.vl_titulo_pagar = 0
	and 	d.vl_tributo > 0
	and 	d.ie_gerar_titulo_pagar = 'S'
	and 	(d.cd_beneficiario IS NOT NULL AND d.cd_beneficiario::text <> '')
	group by g.nr_sequencia;

c01 CURSOR(   	nr_seq_lote_pc    	pls_pp_lote.nr_sequencia%type,
		nr_seq_pp_prestador_pc  pls_pp_prestador.nr_sequencia%type ) FOR
	SELECT	d.nr_sequencia,
		max(d.cd_tributo) cd_tributo,
		max(d.dt_pgto_tributo) dt_pgto_tributo,
		max(d.nr_seq_trans_reg) nr_seq_trans_reg,
		max(d.nr_seq_trans_baixa) nr_seq_trans_baixa,
		max(d.cd_beneficiario) cd_beneficiario,
		max(d.vl_tributo) vl_tributo,
		max(d.cd_darf) cd_darf,
		max(d.nr_seq_classe) nr_seq_classe,
		max(d.cd_tipo_baixa_neg) cd_tipo_baixa_neg,
		substr(obter_nome_pf_pj(max(d.cd_pessoa_fisica), max(d.cd_cgc)), 1,80) nome_prestador,
		max(d.cd_cgc),
		max(d.cd_conta_financ),
		max(e.cd_conta_credito)
	from	pls_pp_prestador g,
		pls_pp_prest_event_prest a,
		pls_pp_it_prest_event_val b,
		pls_pp_item_lote e,
		pls_pp_base_atual_trib c,
		pls_pp_valor_trib_pessoa d
	where	g.nr_seq_lote = nr_seq_lote_pc
	and 	g.nr_sequencia = nr_seq_pp_prestador_pc
	and	g.vl_titulo_pagar = 0
	and	a.nr_seq_pp_prest = g.nr_sequencia
	and	b.nr_seq_prest_even_val = a.nr_seq_pp_prest_even_val
	and	e.nr_seq_lote = nr_seq_lote_pc
	and	e.nr_sequencia = b.nr_seq_item_lote
	and	c.nr_seq_item_lote = b.nr_seq_item_lote
	and	d.nr_sequencia = c.nr_seq_trib_pessoa
	and	d.vl_tributo > 0
	and	d.ie_gerar_titulo_pagar = 'S'
	and	(d.cd_beneficiario IS NOT NULL AND d.cd_beneficiario::text <> '')
	group by d.nr_sequencia;

BEGIN

select	max(cd_empresa),
	max(coalesce(cd_estab_financeiro, cd_estabelecimento))
into STRICT	cd_empresa_w,
	cd_estab_financeiro_w
from	estabelecimento	
where	cd_estabelecimento = cd_estabelecimento_p;

for r_C00_w in C00( nr_seq_lote_p ) loop

	-- retorna todos os registros de tributos de prestador que nao tenham valor a receber e que no cadastro do

	-- tributo esteja para gerar o titulo do mesmo

	open  c01(nr_seq_lote_p, r_C00_w.nr_seq_pp_prestador);
	loop
		fetch c01 bulk collect into	tb_nr_seq_pp_prest_w, tb_cd_tributo_w, tb_dt_pgto_tributo_w,
						tb_nr_seq_trans_reg_w, tb_nr_seq_trans_baixa_w, tb_cd_beneficiario_w,
						tb_vl_tributo_w, tb_cd_darf_w, tb_nr_seq_classe_w,
						tb_cd_tipo_baixa_neg_w, tb_nm_prestador_w, tb_cd_cgc_w,
						tb_cd_conta_finac_w, tb_cd_conta_credito_w
		limit pls_util_pck.qt_registro_transacao_w;
		exit when tb_nr_seq_pp_prest_w.count = 0;

		forall i in tb_nr_seq_pp_prest_w.first..tb_nr_seq_pp_prest_w.last
			insert into titulo_pagar(
				nr_titulo, cd_estabelecimento, dt_atualizacao,
				nm_usuario, dt_emissao, dt_contabil,
				dt_vencimento_original, dt_vencimento_atual, vl_titulo, 	
				vl_saldo_titulo, vl_saldo_juros, vl_saldo_multa,
				cd_moeda, tx_juros, tx_multa,
				cd_tipo_taxa_juro, cd_tipo_taxa_multa, tx_desc_antecipacao,
				ie_situacao, ie_origem_titulo, ie_tipo_titulo,
				cd_cgc, ie_desconto_dia, nr_lote_contabil,
				nr_seq_trans_fin_contab, nr_seq_trans_fin_baixa, ie_status_tributo,
				nr_lote_transf_trib, nr_seq_classe, cd_tipo_baixa_neg,
				ie_status, cd_tributo, ds_observacao_titulo, 
				cd_darf, cd_estab_financeiro
			) values (
				nextval('titulo_pagar_seq'), cd_estabelecimento_p, clock_timestamp(),
				nm_usuario_p, trunc(clock_timestamp(),'dd'), pls_pp_lote_pagamento_pck.dt_mes_comp_lote_w,
				tb_dt_pgto_tributo_w(i), tb_dt_pgto_tributo_w(i), tb_vl_tributo_w(i),
				tb_vl_tributo_w(i), 0, 0,
				current_setting('pls_pp_gerar_titulo_pck.cd_moeda_padrao_pagar_w')::parametros_contas_pagar.cd_moeda_padrao%type, 0, 0,
				1, 1, 0,
				'A', 4, 4,
				tb_cd_beneficiario_w(i), 'N', 0,
				tb_nr_seq_trans_reg_w(i), tb_nr_seq_trans_baixa_w(i), 'NT',
				0, tb_nr_seq_classe_w(i), tb_cd_tipo_baixa_neg_w(i),
				'D', tb_cd_tributo_w(i), tb_nm_prestador_w(i),
				tb_cd_darf_w(i), cd_estab_financeiro_w
			) returning nr_titulo bulk collect into tb_nr_titulo_imposto_w;
		commit;

		forall i in tb_nr_seq_pp_prest_w.first..tb_nr_seq_pp_prest_w.last
			update	pls_pp_valor_trib_pessoa
			set	nr_titulo_pagar = tb_nr_titulo_imposto_w(i)
			where	nr_sequencia = tb_nr_seq_pp_prest_w(i);
		commit;

		-- percorre os titulos inseridos

		for i in tb_nr_titulo_imposto_w.first..tb_nr_titulo_imposto_w.last loop

			CALL atualizar_inclusao_tit_pagar(tb_nr_titulo_imposto_w(i), nm_usuario_p);
			
			if (current_setting('pls_pp_gerar_titulo_pck.ie_conta_financ_tit_trib_w')::parametros_contas_pagar.ie_conta_financ_tit_trib%type = 'R') then
			
				tb_cd_conta_financ_w(i) := tb_cd_conta_finac_w(i);
			else
				tb_cd_conta_financ_w(i) := null;
			end if;
			
			if (current_setting('pls_pp_gerar_titulo_pck.ie_conta_contab_tit_trib_w')::parametros_contas_pagar.ie_conta_contab_tit_trib%type = 'R') then

				tb_cd_conta_cont_trib_w(i) := substr(obter_conta_contabil_trib(cd_empresa_w, tb_cd_tributo_w(i), tb_cd_cgc_w(i), clock_timestamp()),1,20);
			else
				tb_cd_conta_cont_trib_w(i) := null;
			end if;

			if (coalesce(tb_cd_conta_cont_trib_w(i)::text, '') = '') then

				tb_cd_conta_cont_trib_w(i) := tb_cd_conta_credito_w(i);
			end if;
		end loop;

		forall i in tb_nr_titulo_imposto_w.first..tb_nr_titulo_imposto_w.last
			insert into titulo_pagar_classif(
				nr_titulo, nr_sequencia, vl_titulo,
				dt_atualizacao, nm_usuario, cd_conta_contabil,
				nr_seq_conta_financ
			) values (
				tb_nr_titulo_imposto_w(i), 1, tb_vl_tributo_w(i),
				clock_timestamp(), nm_usuario_p, tb_cd_conta_cont_trib_w(i), 
				tb_cd_conta_financ_w(i)
			);
		commit;
	end loop;
	close c01;
end loop;

END;

$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE pls_pp_gerar_titulo_pck.ger_tit_trib_prest_pgto_zerado ( nr_seq_lote_p pls_pp_lote.nr_sequencia%type, cd_estabelecimento_p estabelecimento.cd_estabelecimento%type, nm_usuario_p usuario.nm_usuario%type) FROM PUBLIC;
