-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';




CREATE OR REPLACE PROCEDURE pls_pp_tributacao_pck.rateio_vl_trib_base_atual ( nr_seq_lote_p pls_pp_lote.nr_sequencia%type, nr_seq_prestador_p pls_prestador.nr_sequencia%type, cd_tributo_p tributo.cd_tributo%type, nm_usuario_p usuario.nm_usuario%type) AS $body$
DECLARE


_ora2pg_r RECORD;
tb_nr_sequencia_w		pls_util_cta_pck.t_number_table;
tb_vl_base_calc_w		pls_util_cta_pck.t_number_table;
tb_vl_tributo_w			pls_util_cta_pck.t_number_table;
tb_vl_nao_retido_w		pls_util_cta_pck.t_number_table;
tb_vl_base_nao_ret_w		pls_util_cta_pck.t_number_table;
tb_vl_trib_adic_w		pls_util_cta_pck.t_number_table;
tb_vl_base_adic_w		pls_util_cta_pck.t_number_table;
tb_vl_base_arred_w		pls_util_cta_pck.t_number_table;
tb_vl_trib_arred_w		pls_util_cta_pck.t_number_table;
tb_vl_nao_ret_arred_w		pls_util_cta_pck.t_number_table;
tb_vl_ba_nao_ret_arred_w	pls_util_cta_pck.t_number_table;
tb_vl_trib_adic_arred_w		pls_util_cta_pck.t_number_table;
tb_vl_ba_trib_adic_arred_w	pls_util_cta_pck.t_number_table;
nr_cont_w			integer;

-- para obter o valor proporcional da base de calculo, pegamos o valor de base vezes o valor do item dividido 

-- pelo valor total da base atual que esta salvo no vl_base_atual da pls_pp_valor_trib_pessoa

-- para obter o proporcional do tributo pegamos o valor do item vezes o valor do tributo dividido pelo total da base atual

c01 CURSOR(	nr_seq_lote_pc		pls_pp_lote.nr_sequencia%type,
		nr_seq_prestador_pc	pls_prestador.nr_sequencia%type,
		cd_tributo_pc		tributo.cd_tributo%type) FOR
	SELECT	a.nr_sequencia,
		CASE WHEN b.vl_base_atual=0 THEN 0  ELSE ((a.vl_item * (b.vl_base_calculo - b.vl_base_adic))/ b.vl_base_atual) END  vl_base_calc,
		CASE WHEN b.vl_base_atual=0 THEN 0  ELSE ((a.vl_item * b.vl_tributo) / b.vl_base_atual) END  vl_tributo,
		CASE WHEN b.vl_base_atual=0 THEN 0  ELSE ((a.vl_item * b.vl_nao_retido) / b.vl_base_atual) END  vl_nao_retido,
		CASE WHEN b.vl_base_atual=0 THEN 0  ELSE ((a.vl_item * b.vl_base_nao_retido) / b.vl_base_atual) END  vl_base_nao_retido,
		CASE WHEN b.vl_base_atual=0 THEN 0  ELSE ((a.vl_item * b.vl_trib_adic) / b.vl_base_atual) END  vl_trib_adic,
		CASE WHEN b.vl_base_atual=0 THEN 0  ELSE ((a.vl_item * b.vl_base_adic) / b.vl_base_atual) END  vl_base_adic
	from	pls_pp_base_atual_trib a,
		pls_pp_valor_trib_pessoa b
	where	a.nr_seq_lote = nr_seq_lote_pc
	and	a.nr_seq_prestador = nr_seq_prestador_pc
	and	a.cd_tributo = cd_tributo_pc
	and	b.nr_sequencia = a.nr_seq_trib_pessoa
	and	b.vl_tributo > 0

union all

	SELECT	a.nr_sequencia,
		CASE WHEN b.vl_base_atual=0 THEN 0  ELSE ((a.vl_item * (b.vl_base_calculo - b.vl_base_adic))/ b.vl_base_atual) END  vl_base_calc,
		CASE WHEN b.vl_base_atual=0 THEN 0  ELSE ((a.vl_item * b.vl_tributo) / b.vl_base_atual) END  vl_tributo,
		CASE WHEN b.vl_base_atual=0 THEN 0  ELSE ((a.vl_item * b.vl_nao_retido) / b.vl_base_atual) END  vl_nao_retido,
		CASE WHEN b.vl_base_atual=0 THEN 0  ELSE ((a.vl_item * b.vl_base_nao_retido) / b.vl_base_atual) END  vl_base_nao_retido,
		CASE WHEN b.vl_base_atual=0 THEN 0  ELSE ((a.vl_item * b.vl_trib_adic) / b.vl_base_atual) END  vl_trib_adic,
		CASE WHEN b.vl_base_atual=0 THEN 0  ELSE ((a.vl_item * b.vl_base_adic) / b.vl_base_atual) END  vl_base_adic
	from	pls_pp_base_atual_trib a,
		pls_pp_valor_trib_pessoa b
	where	coalesce(nr_seq_prestador_pc::text, '') = ''
	and	a.nr_seq_lote = nr_seq_lote_pc
	and	a.cd_tributo = cd_tributo_pc
	and	b.nr_sequencia = a.nr_seq_trib_pessoa
	and	b.vl_tributo > 0;

c02 CURSOR(	nr_seq_lote_pc		pls_pp_lote.nr_sequencia%type,
		nr_seq_prestador_pc	pls_prestador.nr_sequencia%type,
		cd_tributo_pc		tributo.cd_tributo%type) FOR
	SELECT	pls_util_pck.obter_valor_diferenca(sum(a.vl_base), pls_pp_tributacao_pck.obter_vl_base_trib( b.ie_tipo_tributo, b.vl_base_calculo, b.vl_base_acumulada), 'N') vl_diferenca_base,
		pls_util_pck.obter_valor_diferenca(sum(a.vl_tributo), b.vl_tributo, 'N') vl_diferenca_trib,
		pls_util_pck.obter_valor_diferenca(sum(a.vl_nao_retido), b.vl_nao_retido, 'N') vl_diferenca_nao_retido,
		pls_util_pck.obter_valor_diferenca(sum(a.vl_base_nao_retido), b.vl_base_nao_retido, 'N') vl_dife_base_nao_retido,
		pls_util_pck.obter_valor_diferenca(sum(a.vl_trib_adic), b.vl_trib_adic, 'N') vl_diferenca_trib_adic,
		pls_util_pck.obter_valor_diferenca(sum(a.vl_base_adic), b.vl_base_adic, 'N') vl_diferenca_base_adic,
		max(a.nr_sequencia) nr_seq_base_atual
	from	pls_pp_base_atual_trib a,
		pls_pp_valor_trib_pessoa b
	where	a.nr_seq_lote = nr_seq_lote_pc
	and	a.nr_seq_prestador = nr_seq_prestador_pc
	and	a.cd_tributo = cd_tributo_pc
	and	b.nr_sequencia = a.nr_seq_trib_pessoa
	group by b.nr_sequencia, b.vl_base_calculo, b.vl_tributo,
		b.vl_nao_retido, b.vl_base_nao_retido, b.vl_trib_adic,
		b.vl_base_adic, b.vl_base_acumulada, b.ie_tipo_tributo
	
union all

	SELECT	pls_util_pck.obter_valor_diferenca(sum(a.vl_base), pls_pp_tributacao_pck.obter_vl_base_trib( b.ie_tipo_tributo, b.vl_base_calculo, b.vl_base_acumulada), 'N') vl_diferenca_base,
		pls_util_pck.obter_valor_diferenca(sum(a.vl_tributo), b.vl_tributo, 'N') vl_diferenca_trib,
		pls_util_pck.obter_valor_diferenca(sum(a.vl_nao_retido), b.vl_nao_retido, 'N') vl_diferenca_nao_retido,
		pls_util_pck.obter_valor_diferenca(sum(a.vl_base_nao_retido), b.vl_base_nao_retido, 'N') vl_dife_base_nao_retido,
		pls_util_pck.obter_valor_diferenca(sum(a.vl_trib_adic), b.vl_trib_adic, 'N') vl_diferenca_trib_adic,
		pls_util_pck.obter_valor_diferenca(sum(a.vl_base_adic), b.vl_base_adic, 'N') vl_diferenca_base_adic,
		max(a.nr_sequencia) nr_seq_base_atual
	from	pls_pp_base_atual_trib a,
		pls_pp_valor_trib_pessoa b
	where	coalesce(nr_seq_prestador_pc::text, '') = ''
	and	a.nr_seq_lote = nr_seq_lote_pc
	and	a.cd_tributo = cd_tributo_pc
	and	b.nr_sequencia = a.nr_seq_trib_pessoa
	group by b.nr_sequencia, b.vl_base_calculo, b.vl_tributo,
		b.vl_nao_retido, b.vl_base_nao_retido, b.vl_trib_adic,
		b.vl_base_adic, b.vl_base_acumulada, b.ie_tipo_tributo;

BEGIN

open c01(nr_seq_lote_p, nr_seq_prestador_p, cd_tributo_p);
loop
	fetch c01 bulk collect into 	tb_nr_sequencia_w, tb_vl_base_calc_w, tb_vl_tributo_w,
					tb_vl_nao_retido_w, tb_vl_base_nao_ret_w, tb_vl_trib_adic_w,
					tb_vl_base_adic_w
	limit pls_util_pck.qt_registro_transacao_w;
	exit when tb_nr_sequencia_w.count = 0;

	forall i in tb_nr_sequencia_w.first..tb_nr_sequencia_w.last
		update	pls_pp_base_atual_trib
		set	vl_tributo = tb_vl_tributo_w(i),
			vl_base = tb_vl_base_calc_w(i),
			vl_nao_retido = tb_vl_nao_retido_w(i),
			vl_base_nao_retido = tb_vl_base_nao_ret_w(i),
			vl_trib_adic = tb_vl_trib_adic_w(i),
			vl_base_adic = tb_vl_base_adic_w(i),
			nm_usuario = nm_usuario_p
		where	nr_sequencia = tb_nr_sequencia_w(i);
	commit;
end loop;
close c01;

-- inicia as variaveis

SELECT * FROM pls_pp_tributacao_pck.atualiza_registro_arred(tb_nr_sequencia_w, tb_vl_base_arred_w, tb_vl_trib_arred_w, tb_vl_nao_ret_arred_w, tb_vl_ba_nao_ret_arred_w, tb_vl_trib_adic_arred_w, tb_vl_ba_trib_adic_arred_w, nr_cont_w) INTO STRICT _ora2pg_r;
 tb_nr_sequencia_w := _ora2pg_r.tb_nr_sequencia_p; tb_vl_base_arred_w := _ora2pg_r.tb_vl_base_arred_p; tb_vl_trib_arred_w := _ora2pg_r.tb_vl_trib_arred_p; tb_vl_nao_ret_arred_w := _ora2pg_r.tb_vl_nao_ret_arred_p; tb_vl_ba_nao_ret_arred_w := _ora2pg_r.tb_vl_ba_nao_ret_arred_p; tb_vl_trib_adic_arred_w := _ora2pg_r.tb_vl_trib_adic_arred_p; tb_vl_ba_trib_adic_arred_w := _ora2pg_r.tb_vl_ba_trib_adic_arred_p; nr_cont_w := _ora2pg_r.nr_cont_p;

for r_c02_w in c02(nr_seq_lote_p, nr_seq_prestador_p, cd_tributo_p) loop

	-- se ao menos um dos valores possuir diferenca, atualizamos todos

	-- os que nao tiverem diferenca ou a diferenca for superior a 0.03 retornara zero e nao havera modificacao no valor

	if (r_c02_w.vl_diferenca_base <> 0) or (r_c02_w.vl_diferenca_trib <> 0) or (r_c02_w.vl_diferenca_nao_retido <> 0) or (r_c02_w.vl_dife_base_nao_retido <> 0) or (r_c02_w.vl_diferenca_trib_adic <> 0) or (r_c02_w.vl_diferenca_base_adic <> 0) then
		
		-- sem pre jogamos a diferenca na maior sequencia gerada para este calculo

		tb_nr_sequencia_w(nr_cont_w) := r_c02_w.nr_seq_base_atual;
		tb_vl_base_arred_w(nr_cont_w) := r_c02_w.vl_diferenca_base;
		tb_vl_trib_arred_w(nr_cont_w) := r_c02_w.vl_diferenca_trib;
		tb_vl_nao_ret_arred_w(nr_cont_w) := r_c02_w.vl_diferenca_nao_retido;
		tb_vl_ba_nao_ret_arred_w(nr_cont_w) := r_c02_w.vl_dife_base_nao_retido;
		tb_vl_trib_adic_arred_w(nr_cont_w) := r_c02_w.vl_diferenca_trib_adic;
		tb_vl_ba_trib_adic_arred_w(nr_cont_w) := r_c02_w.vl_diferenca_base_adic;

		-- verifica se atingiu a quantidade para mandar pro banco

		if (nr_cont_w >= pls_util_cta_pck.qt_registro_transacao_w) then

			SELECT * FROM pls_pp_tributacao_pck.atualiza_registro_arred(tb_nr_sequencia_w, tb_vl_base_arred_w, tb_vl_trib_arred_w, tb_vl_nao_ret_arred_w, tb_vl_ba_nao_ret_arred_w, tb_vl_trib_adic_arred_w, tb_vl_ba_trib_adic_arred_w, nr_cont_w) INTO STRICT _ora2pg_r;
 tb_nr_sequencia_w := _ora2pg_r.tb_nr_sequencia_p; tb_vl_base_arred_w := _ora2pg_r.tb_vl_base_arred_p; tb_vl_trib_arred_w := _ora2pg_r.tb_vl_trib_arred_p; tb_vl_nao_ret_arred_w := _ora2pg_r.tb_vl_nao_ret_arred_p; tb_vl_ba_nao_ret_arred_w := _ora2pg_r.tb_vl_ba_nao_ret_arred_p; tb_vl_trib_adic_arred_w := _ora2pg_r.tb_vl_trib_adic_arred_p; tb_vl_ba_trib_adic_arred_w := _ora2pg_r.tb_vl_ba_trib_adic_arred_p; nr_cont_w := _ora2pg_r.nr_cont_p;
		else
			nr_cont_w := nr_cont_w + 1;
		end if;
	end if;
end loop;

-- se sobrou algo manda pro banco

SELECT * FROM pls_pp_tributacao_pck.atualiza_registro_arred(tb_nr_sequencia_w, tb_vl_base_arred_w, tb_vl_trib_arred_w, tb_vl_nao_ret_arred_w, tb_vl_ba_nao_ret_arred_w, tb_vl_trib_adic_arred_w, tb_vl_ba_trib_adic_arred_w, nr_cont_w) INTO STRICT _ora2pg_r;
 tb_nr_sequencia_w := _ora2pg_r.tb_nr_sequencia_p; tb_vl_base_arred_w := _ora2pg_r.tb_vl_base_arred_p; tb_vl_trib_arred_w := _ora2pg_r.tb_vl_trib_arred_p; tb_vl_nao_ret_arred_w := _ora2pg_r.tb_vl_nao_ret_arred_p; tb_vl_ba_nao_ret_arred_w := _ora2pg_r.tb_vl_ba_nao_ret_arred_p; tb_vl_trib_adic_arred_w := _ora2pg_r.tb_vl_trib_adic_arred_p; tb_vl_ba_trib_adic_arred_w := _ora2pg_r.tb_vl_ba_trib_adic_arred_p; nr_cont_w := _ora2pg_r.nr_cont_p;

END;

$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE pls_pp_tributacao_pck.rateio_vl_trib_base_atual ( nr_seq_lote_p pls_pp_lote.nr_sequencia%type, nr_seq_prestador_p pls_prestador.nr_sequencia%type, cd_tributo_p tributo.cd_tributo%type, nm_usuario_p usuario.nm_usuario%type) FROM PUBLIC;
