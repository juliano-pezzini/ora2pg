-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';




CREATE OR REPLACE PROCEDURE pls_pp_gerar_titulo_pck.gerar_titulo_pagar_lote ( nr_seq_lote_p pls_pp_lote.nr_sequencia%type, cd_estabelecimento_p estabelecimento.cd_estabelecimento%type, nm_usuario_p usuario.nm_usuario%type) AS $body$
DECLARE


tb_nr_seq_pp_prest_w		pls_util_cta_pck.t_number_table;
tb_nr_seq_tit_pagar_w		pls_util_cta_pck.t_number_table;
tb_dt_venc_titulo_w		pls_util_cta_pck.t_date_table;
tb_vl_titulo_pagar_w		pls_util_cta_pck.t_number_table;
tb_cd_pessoa_fisica_w		pls_util_cta_pck.t_varchar2_table_20;
tb_cd_cgc_w			pls_util_cta_pck.t_varchar2_table_20;
tb_nr_seq_baixa_w		pls_util_cta_pck.t_number_table;
cd_estab_financeiro_w		estabelecimento.cd_estab_financeiro%type;
nr_seq_trans_fin_bx_w		pls_parametros.nr_seq_trans_fin_baixa_conta%type;
tb_nr_celular_w			pls_util_cta_pck.t_varchar2_table_50;
tb_ds_email_w			pls_util_cta_pck.t_varchar2_table_50;
tb_nr_seq_tipo_prestador_w	pls_util_cta_pck.t_number_table;

dt_contabil_w			timestamp;
nr_seq_classif_w		titulo_pagar_classif.nr_sequencia%type;

c01 CURSOR(	nr_seq_lote_pc		pls_pp_lote.nr_sequencia%type,
		cd_estabelecimento_pc	estabelecimento.cd_estabelecimento%type) FOR
	SELECT	a.nr_sequencia,
		a.dt_venc_titulo,
		a.vl_titulo_pagar,
		b.cd_pessoa_fisica,
		b.cd_cgc,
		substr(pls_obter_dados_prestador( a.nr_seq_prestador, 'CEL'), 1, 50) nr_celular,
		substr(obter_dados_pf_pj_estab( cd_estabelecimento_pc, b.cd_pessoa_fisica, b.cd_cgc, 'M'), 1, 50) ds_email,
		b.nr_seq_tipo_prestador
	from	pls_pp_prestador a,
		pls_pp_prestador_tmp b
	where	a.nr_seq_lote = nr_seq_lote_pc
	and	a.vl_titulo_pagar > 0
	and	b.nr_seq_prestador = a.nr_seq_prestador;

c02 CURSOR(	nr_seq_pp_prest_pc	pls_pp_prestador.nr_sequencia%type) FOR
	SELECT	c.cd_conta_credito,
		pls_pp_gerar_titulo_pck.pls_obter_conta_financ_regra_f(c.nr_seq_prestador, c.nr_seq_evento) nr_seq_conta_financ,
		c.nr_seq_evento,
		sum(c.vl_liquido) vl_liquido_itens
	from	pls_pp_prest_event_prest a,
		pls_pp_it_prest_event_val b,
		pls_pp_item_lote c
	where	a.nr_seq_pp_prest = nr_seq_pp_prest_pc
	and	b.nr_seq_prest_even_val = a.nr_seq_pp_prest_even_val
	and	c.nr_sequencia = b.nr_seq_item_lote
	group by c.cd_conta_credito, pls_pp_gerar_titulo_pck.pls_obter_conta_financ_regra_f(c.nr_seq_prestador, c.nr_seq_evento), c.nr_seq_evento;

-- Atualizar os protocolos de prestadores que nao possuem titulo a pagar e que tenham producao medica/recurso de glosa

c03 CURSOR(	nr_seq_lote_pc		pls_pp_lote.nr_sequencia%type) FOR
	SELECT	a.nr_seq_prestador,
		a.nr_seq_lote
	from	pls_pp_prest_evento_valor	v,
		pls_evento			e,
		pls_pp_prestador 		a
	where	e.nr_sequencia		= v.nr_seq_evento
	and	v.nr_seq_prestador	= a.nr_seq_prestador
	and	v.nr_seq_lote		= a.nr_seq_lote
	and	a.nr_seq_lote 		= nr_seq_lote_pc
	and	e.ie_tipo_evento	in ('P','G')
	and	coalesce(a.nr_titulo_pagar::text, '') = ''
	group by a.nr_seq_prestador, a.nr_seq_lote;

BEGIN
-- alimenta as variaveis que serao utilizadas no insert

dt_contabil_w := pls_pp_lote_pagamento_pck.dt_mes_comp_lote_w;
nr_seq_trans_fin_bx_w := coalesce(current_setting('pls_pp_gerar_titulo_pck.nr_seq_trans_fin_baixa_conta_w')::pls_parametros.nr_seq_trans_fin_baixa_conta%type,current_setting('pls_pp_gerar_titulo_pck.nr_seq_trans_fin_baixa_w')::pls_parametro_pagamento.nr_seq_trans_fin_baixa%type);

select	max(coalesce(cd_estab_financeiro, cd_estabelecimento))
into STRICT	cd_estab_financeiro_w
from	estabelecimento
where	cd_estabelecimento	= cd_estabelecimento_p;

-- abre o cursor com todos os prestadores que possuem valores a receber para que seja gerado os titulos a pagar

open c01(nr_seq_lote_p, cd_estabelecimento_p);
loop
	fetch c01 bulk collect into	tb_nr_seq_pp_prest_w, tb_dt_venc_titulo_w, tb_vl_titulo_pagar_w,
					tb_cd_pessoa_fisica_w, tb_cd_cgc_w, tb_nr_celular_w, tb_ds_email_w,
					tb_nr_seq_tipo_prestador_w
	limit pls_util_pck.qt_registro_transacao_w;
	exit when tb_nr_seq_pp_prest_w.count = 0;

	-- insere todos os titulos a pagar retornando em uma table tados os titulos inseridos

	forall i in tb_nr_seq_pp_prest_w.first..tb_nr_seq_pp_prest_w.last
		insert into titulo_pagar(
			nr_titulo, cd_estabelecimento, nm_usuario,
			dt_atualizacao, dt_emissao, dt_contabil,
			dt_vencimento_original, dt_vencimento_atual, vl_titulo,
			vl_saldo_titulo, vl_saldo_juros, vl_saldo_multa,
			nr_lote_contabil, cd_moeda, tx_juros,
			tx_multa, cd_tipo_taxa_juro, cd_tipo_taxa_multa,
			ie_situacao, ie_origem_titulo, ie_tipo_titulo,
			cd_cgc, cd_pessoa_fisica, ie_pls,
			vl_ir, vl_imposto_munic, nr_seq_nota_fiscal,
			nr_seq_classe, cd_estab_financeiro, nr_seq_trans_fin_baixa
		) values (
			nextval('titulo_pagar_seq'), cd_estabelecimento_p, nm_usuario_p,
			clock_timestamp(), trunc(clock_timestamp(),'dd'), dt_contabil_w,
			tb_dt_venc_titulo_w(i), tb_dt_venc_titulo_w(i), tb_vl_titulo_pagar_w(i),
			tb_vl_titulo_pagar_w(i), 0, 0,
			0, current_setting('pls_pp_gerar_titulo_pck.cd_moeda_padrao_pagar_w')::parametros_contas_pagar.cd_moeda_padrao%type, 0,
			0, 1, 1,
			'A', '25', '1',
			tb_cd_cgc_w(i), tb_cd_pessoa_fisica_w(i), 'S',
			null, null, null,
			current_setting('pls_pp_gerar_titulo_pck.nr_seq_classe_tp_w')::pls_parametro_pagamento.nr_seq_classe_tp%type, cd_estab_financeiro_w, nr_seq_trans_fin_bx_w
		) returning nr_titulo bulk collect into tb_nr_seq_tit_pagar_w;
	commit;

	-- faz o vinculo dos titulos gerados com o registro que o originou

	forall i in tb_nr_seq_pp_prest_w.first..tb_nr_seq_pp_prest_w.last
		update	pls_pp_prestador
		set	nr_titulo_pagar = tb_nr_seq_tit_pagar_w(i)
		where	nr_sequencia = tb_nr_seq_pp_prest_w(i);
	commit;

	-- #jls chamar a rotina que busca a conta financeira da regra pls_obter_conta_financ_regra e salva na pls_pp_item_lote


	-- percorre todos os titulos inseridos e faz o que e necessario

	for i in tb_nr_seq_tit_pagar_w.first..tb_nr_seq_tit_pagar_w.last loop

		-- gera o titulo a pagar para o responsavel pelo pagamento

		CALL gerar_titulo_pagar_resp_pagto(tb_nr_seq_tit_pagar_w(i), nm_usuario_p);

		-- faz alguns tratamentos no titulo que foi gerado tais como gerar os tributos caso esteja configurado

		-- insere os usuario responsaveis pela liberacao do titulo etc..

		CALL atualizar_inclusao_tit_pagar(tb_nr_seq_tit_pagar_w(i), nm_usuario_p);

		-- faz o rateio dos valores por classificacao contabil e financeira

		for r_c02_w in c02(tb_nr_seq_pp_prest_w(i)) loop

			select	coalesce(max(nr_sequencia),0) + 1
			into STRICT	nr_seq_classif_w
			from	titulo_pagar_classif
			where	nr_titulo = tb_nr_seq_tit_pagar_w(i);

			insert into titulo_pagar_classif(
				dt_atualizacao, nm_usuario, nr_seq_conta_financ,
				nr_sequencia, nr_titulo, vl_acrescimo,
				vl_desconto, vl_original, vl_titulo,
				cd_conta_contabil
			) values (
				clock_timestamp(), nm_usuario_p, r_c02_w.nr_seq_conta_financ,
				nr_seq_classif_w, tb_nr_seq_tit_pagar_w(i), 0,
				0, r_c02_w.vl_liquido_itens, r_c02_w.vl_liquido_itens,
				r_c02_w.cd_conta_credito
			);
		end loop;
		commit;

		-- manda os tributos gerados no lote de pagamento para o titulo e verifica se e necessario gerar titulos para os mesmos

		CALL pls_pp_gerar_titulo_pck.gerar_tributo_titulo_pagar(	nr_seq_lote_p, tb_nr_seq_pp_prest_w(i), tb_nr_seq_tit_pagar_w(i),
						nm_usuario_p);

		-- se for recurso proprio o titulo ja e dado a baixa

		if (pls_pp_lote_pagamento_pck.ie_recurso_proprio_w = 'S') or (current_setting('pls_pp_gerar_titulo_pck.nr_seq_tipo_prest_rec_prop_w')::pls_parametro_pagamento.nr_seq_tipo_prest_rec_prop%type = tb_nr_seq_tipo_prestador_w(i)) then

			-- baixa titulo a pagar

			if (current_setting('pls_pp_gerar_titulo_pck.ie_processo_tit_rec_prop_w')::pls_parametro_pagamento.ie_processo_tit_rec_prop%type = 'L') then
				-- faz o lancamento da baixa com valor negativo (estorno)

				CALL baixa_titulo_pagar(	cd_estabelecimento_p, pls_pp_lote_pagamento_pck.cd_tipo_baixa_pgto_w,
							tb_nr_seq_tit_pagar_w(i), tb_vl_titulo_pagar_w(i),
							nm_usuario_p, pls_pp_lote_pagamento_pck.nr_seq_trans_fin_pag_pgto_w, 
							null, null,
							clock_timestamp(), null,
							null);

				-- busca a sequencia da baixa que foi inserida

				select	coalesce(max(nr_sequencia),0)
				into STRICT	tb_nr_seq_baixa_w(i)
				from	titulo_pagar_baixa
				where	nr_titulo = tb_nr_seq_tit_pagar_w(i);
				
				update 	titulo_pagar
				set 	ds_observacao_titulo	= wheb_mensagem_pck.get_texto(1110208),
					nr_seq_trans_fin_baixa	= coalesce(current_setting('pls_pp_gerar_titulo_pck.nr_seq_trans_fin_baixa_rp_w')::pls_parametro_pagamento.nr_seq_trans_fin_baixa_rec_pro%type,nr_seq_trans_fin_baixa)
				where 	nr_titulo		= tb_nr_seq_tit_pagar_w(i);
				
			-- cancela titulo a pagar

			elsif (current_setting('pls_pp_gerar_titulo_pck.ie_processo_tit_rec_prop_w')::pls_parametro_pagamento.ie_processo_tit_rec_prop%type = 'C') then
				CALL cancelar_titulo_pagar(	tb_nr_seq_tit_pagar_w(i), nm_usuario_p, clock_timestamp());
				
				update 	titulo_pagar
				set 	ds_observacao_titulo	= wheb_mensagem_pck.get_texto(1110209),
					nr_seq_trans_fin_baixa	= coalesce(current_setting('pls_pp_gerar_titulo_pck.nr_seq_trans_fin_baixa_rp_w')::pls_parametro_pagamento.nr_seq_trans_fin_baixa_rec_pro%type,nr_seq_trans_fin_baixa)
				where 	nr_titulo		= tb_nr_seq_tit_pagar_w(i);
			end if;			
		end if;

		-- atualiza o saldo do titulo (rotina e chamada sempre ao gerar um titulo)

		CALL atualizar_saldo_tit_pagar(	tb_nr_seq_tit_pagar_w(i), nm_usuario_p);
	end loop;

	forall i in tb_nr_seq_baixa_w.first..tb_nr_seq_baixa_w.last
		-- coloca uma observacao no titulo para identificar o motivo do estorno da baixa

		update	titulo_pagar_baixa	
		set	ds_observacao = wheb_mensagem_pck.get_texto(1110210, 'NR_SEQ_LOTE=' || nr_seq_lote_p) || pls_util_pck.enter_w || ' ' ||		
					wheb_mensagem_pck.get_texto(817948) || wheb_mensagem_pck.get_texto(1110211) || '.'
		where	nr_sequencia = tb_nr_seq_baixa_w(i)
		and	nr_titulo = tb_nr_seq_tit_pagar_w(i);
	commit;

	for i in tb_nr_seq_pp_prest_w.first..tb_nr_seq_pp_prest_w.last loop
		CALL pls_gerar_alerta_pag_prod_med(	4, tb_nr_celular_w(i), tb_ds_email_w(i), nr_seq_lote_p, null, tb_nr_seq_pp_prest_w(i), nm_usuario_p);
		commit;
	end loop;
end loop;
close c01;

for r_c03_w in c03( nr_seq_lote_p ) loop
	CALL pls_pp_gerar_titulo_pck.atualiza_status_prot_pag_prest( null, r_c03_w.nr_seq_prestador, r_c03_w.nr_seq_lote, null, nm_usuario_p);
end loop;

END;

$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE pls_pp_gerar_titulo_pck.gerar_titulo_pagar_lote ( nr_seq_lote_p pls_pp_lote.nr_sequencia%type, cd_estabelecimento_p estabelecimento.cd_estabelecimento%type, nm_usuario_p usuario.nm_usuario%type) FROM PUBLIC;
