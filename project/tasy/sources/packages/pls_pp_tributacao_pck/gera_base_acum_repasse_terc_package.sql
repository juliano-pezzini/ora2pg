-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';




CREATE OR REPLACE PROCEDURE pls_pp_tributacao_pck.gera_base_acum_repasse_terc ( nr_seq_lote_p pls_pp_lote.nr_sequencia%type, cd_tributo_p tributo.cd_tributo%type, ie_rest_estab_p tributo.ie_restringe_estab%type, ie_vencimento_p tributo.ie_vencimento%type, ie_repasse_titulo_p tributo.ie_repasse_titulo%type, cd_estabelecimento_p estabelecimento.cd_estabelecimento%type, nm_usuario_p usuario.nm_usuario%type) AS $body$
DECLARE


_ora2pg_r RECORD;
ie_acumula_base_w	boolean;
nr_cont_w		integer;
tb_nr_sequencia_w	pls_util_cta_pck.t_number_table;
tb_vl_tributo_w		pls_util_cta_pck.t_number_table;
tb_vl_base_calc_w	pls_util_cta_pck.t_number_table;
tb_vl_item_w		pls_util_cta_pck.t_number_table;
tb_cd_pf_w		pls_util_cta_pck.t_varchar2_table_50;
tb_dt_comp_base_w	pls_util_cta_pck.t_date_table;
tb_vl_nao_retido_w	pls_util_cta_pck.t_number_table;
tb_vl_base_nao_ret_w	pls_util_cta_pck.t_number_table;
tb_vl_trib_adic_w	pls_util_cta_pck.t_number_table;
tb_vl_base_adic_w	pls_util_cta_pck.t_number_table;
tb_nr_seq_rep_terc_w	pls_util_cta_pck.t_number_table;
tb_nr_seq_tipo_prest_w	pls_util_cta_pck.t_number_table;
tb_nr_seq_prest_w	pls_util_cta_pck.t_number_table;
tb_ie_tipo_tributo_w	pls_util_cta_pck.t_varchar2_table_20;

c01 CURSOR(	cd_tributo_pc		tributo.cd_tributo%type,
		ie_vencimento_pc	text) FOR
	SELECT	d.cd_pessoa_fisica,
		a.nr_sequencia,
		e.nr_seq_tipo_prestador,
		(SELECT	count(1)
		from 	titulo_pagar x
		where 	x.nr_repasse_terceiro = c.nr_repasse_terceiro  LIMIT 1) qt_tit_pagar,
		c.nr_repasse_terceiro,
		max(a.vl_imposto) vl_imposto,
		max(a.vl_base_calculo) vl_base_calculo,
		max(b.vl_vencimento) vl_vencimento,
		obter_se_base_calculo(c.nr_repasse_terceiro, 'RT') ie_base_calculo,
		max(c.cd_estabelecimento) cd_estabelecimento,
		trunc(max(b.dt_vencimento), 'month') dt_base,
		max(a.vl_nao_retido) vl_nao_retido,
		max(a.vl_base_nao_retido) vl_base_nao_retido,
		max(a.vl_trib_adic) vl_trib_adic,
		max(a.vl_base_adic) vl_base_adic,
		max(e.nr_seq_prestador) nr_seq_prestador,
		max(f.ie_tipo_tributo) ie_tipo_tributo
	from	pls_pp_prestador_tmp e,
		terceiro d,
		repasse_terceiro c,
		repasse_terceiro_venc b,
		repasse_terc_venc_trib a,
		tributo f
	where	ie_vencimento_pc = 'V' -- por vencimento

	and	e.ie_tipo_prestador = 'PF'
	and	d.cd_pessoa_fisica = e.cd_pessoa_fisica
	and	c.nr_seq_terceiro = d.nr_sequencia
	and	b.nr_repasse_terceiro = c.nr_repasse_terceiro
	and	b.dt_vencimento between e.dt_venc_ini_mes and e.dt_venc_fim_mes
	and	a.nr_seq_rep_venc = b.nr_sequencia
	and	a.cd_tributo = cd_tributo_pc
	and	a.ie_pago_prev = 'V'
	and	f.cd_tributo = a.cd_tributo
	and not exists (	select	1
			from	pls_pp_base_acum_trib x
			where	x.nr_seq_vl_repasse = a.nr_sequencia)
	group by d.cd_pessoa_fisica, a.nr_sequencia, e.nr_seq_tipo_prestador, 
		c.nr_repasse_terceiro
	
union all

	select	d.cd_pessoa_fisica,
		a.nr_sequencia,
		y.nr_seq_tipo_prestador,
		(select	count(1)
		from 	titulo_pagar x 
		where 	x.nr_repasse_terceiro = c.nr_repasse_terceiro  LIMIT 1) qt_tit_pagar,
		c.nr_repasse_terceiro,
		max(a.vl_imposto) vl_imposto,
		max(a.vl_base_calculo) vl_base_calculo,
		max(b.vl_vencimento) vl_vencimento,
		obter_se_base_calculo(c.nr_repasse_terceiro, 'RT') ie_base_calculo,
		max(c.cd_estabelecimento) cd_estabelecimento,
		trunc(coalesce(max(b.dt_vencimento), max(c.dt_mesano_referencia)), 'month') dt_base,
		max(a.vl_nao_retido) vl_nao_retido,
		max(a.vl_base_nao_retido) vl_base_nao_retido,
		max(a.vl_trib_adic) vl_trib_adic,
		max(a.vl_base_adic) vl_base_adic,
		max(y.nr_seq_prestador) nr_seq_prestador,
		max(f.ie_tipo_tributo) ie_tipo_tributo
	from	pls_pp_prestador_tmp y,
		terceiro d,
		repasse_terc_venc_trib a,
		repasse_terceiro_venc b,
		repasse_terceiro c,
		tributo f
	where	ie_vencimento_pc = 'C' -- por vencimento

	and	y.ie_tipo_prestador = 'PF'
	and	d.cd_pessoa_fisica = y.cd_pessoa_fisica
	and	c.nr_seq_terceiro = d.nr_sequencia
	and	b.nr_repasse_terceiro = c.nr_repasse_terceiro
	and	a.nr_seq_rep_venc = b.nr_sequencia
	and	a.cd_tributo = cd_tributo_pc
	and	a.ie_pago_prev = 'V'
	and	f.cd_tributo = a.cd_tributo
	and	y.nr_seq_prestador in (	select	1
					from	pls_pp_prestador_tmp e
					where	e.ie_tipo_prestador = 'PF'
					and	e.cd_pessoa_fisica = d.cd_pessoa_fisica
					and	b.dt_vencimento between e.dt_venc_ini_mes and e.dt_venc_fim_mes
					
union all

					select	1
					from	pls_pp_prestador_tmp e
					where	e.ie_tipo_prestador = 'PF'
					and	e.cd_pessoa_fisica = d.cd_pessoa_fisica
					and	c.dt_mesano_referencia between e.dt_venc_ini_mes and e.dt_venc_fim_mes)
	and not exists (	select	1
			from	pls_pp_base_acum_trib x
			where	x.nr_seq_vl_repasse = a.nr_sequencia)
	group by d.cd_pessoa_fisica, a.nr_sequencia, y.nr_seq_tipo_prestador, 
		c.nr_repasse_terceiro
	
union all

	select	d.cd_pessoa_fisica,
		a.nr_sequencia,
		e.nr_seq_tipo_prestador,
		(select	count(1)
		from 	titulo_pagar x 
		where 	x.nr_repasse_terceiro = c.nr_repasse_terceiro  LIMIT 1) qt_tit_pagar,
		c.nr_repasse_terceiro,
		max(a.vl_imposto) vl_imposto,
		max(a.vl_base_calculo) vl_base_calculo,
		max(b.vl_vencimento) vl_vencimento,
		obter_se_base_calculo(c.nr_repasse_terceiro, 'RT') ie_base_calculo,
		max(c.cd_estabelecimento) cd_estabelecimento,
		trunc(max(c.dt_mesano_referencia), 'month') dt_base,
		max(a.vl_nao_retido) vl_nao_retido,
		max(a.vl_base_nao_retido) vl_base_nao_retido,
		max(a.vl_trib_adic) vl_trib_adic,
		max(a.vl_base_adic) vl_base_adic,
		max(e.nr_seq_prestador) nr_seq_prestador,
		max(f.ie_tipo_tributo) ie_tipo_tributo
	from	pls_pp_prestador_tmp e,
		repasse_terc_venc_trib a,
		repasse_terceiro_venc b,
		repasse_terceiro c,
		terceiro d,
		tributo f
	where	ie_vencimento_pc in ('R', 'B', 'S') -- por competencia
	and	e.ie_tipo_prestador = 'PF'
	and	d.cd_pessoa_fisica = e.cd_pessoa_fisica
	and	c.nr_seq_terceiro = d.nr_sequencia
	and	c.dt_mesano_referencia between e.dt_comp_ini_mes and e.dt_comp_fim_mes
	and	b.nr_repasse_terceiro = c.nr_repasse_terceiro
	and	a.nr_seq_rep_venc = b.nr_sequencia
	and	a.cd_tributo = cd_tributo_pc
	and	a.ie_pago_prev = 'V'
	and	f.cd_tributo = a.cd_tributo
	and not exists (	select	1
			from	pls_pp_base_acum_trib x
			where	x.nr_seq_vl_repasse = a.nr_sequencia)
	group by d.cd_pessoa_fisica, a.nr_sequencia, e.nr_seq_tipo_prestador, 
		c.nr_repasse_terceiro;

BEGIN

-- inicializa as variaveis

SELECT * FROM pls_pp_tributacao_pck.alimenta_pp_base_acum_repasse(	nr_cont_w, tb_nr_sequencia_w, tb_vl_tributo_w, tb_vl_base_calc_w, tb_vl_item_w, tb_cd_pf_w, tb_dt_comp_base_w, tb_vl_nao_retido_w, tb_vl_base_nao_ret_w, tb_vl_trib_adic_w, tb_vl_base_adic_w, tb_nr_seq_rep_terc_w, tb_nr_seq_tipo_prest_w, tb_nr_seq_prest_w, tb_ie_tipo_tributo_w, nr_seq_lote_p, cd_tributo_p, nm_usuario_p) INTO STRICT _ora2pg_r;
 	nr_cont_w := _ora2pg_r.nr_cont_p; tb_nr_sequencia_w := _ora2pg_r.tb_nr_sequencia_p; tb_vl_tributo_w := _ora2pg_r.tb_vl_tributo_p; tb_vl_base_calc_w := _ora2pg_r.tb_vl_base_calc_p; tb_vl_item_w := _ora2pg_r.tb_vl_item_p; tb_cd_pf_w := _ora2pg_r.tb_cd_pf_p; tb_dt_comp_base_w := _ora2pg_r.tb_dt_comp_base_p; tb_vl_nao_retido_w := _ora2pg_r.tb_vl_nao_retido_p; tb_vl_base_nao_ret_w := _ora2pg_r.tb_vl_base_nao_ret_p; tb_vl_trib_adic_w := _ora2pg_r.tb_vl_trib_adic_p; tb_vl_base_adic_w := _ora2pg_r.tb_vl_base_adic_p; tb_nr_seq_rep_terc_w := _ora2pg_r.tb_nr_seq_rep_terc_p; tb_nr_seq_tipo_prest_w := _ora2pg_r.tb_nr_seq_tipo_prest_p; tb_nr_seq_prest_w := _ora2pg_r.tb_nr_seq_prest_p; tb_ie_tipo_tributo_w := _ora2pg_r.tb_ie_tipo_tributo_p;

-- abre o cursor com os registros que precisam ser verificados

for r_c01_w in c01(cd_tributo_p, ie_vencimento_p) loop

	-- a funcao obter_se_base_calculo verifica se deve fazer parte da base de calculo,

	-- nela e verificada se esse valor nao e proveniente de outra origem, por exemplo:

	-- um valor de pagamento que esta no titulo a pagar

	if (r_c01_w.ie_base_calculo = 'S') then
	
		-- comeca como sendo valido

		ie_acumula_base_w := true;

		-- se for necessario restringir estabelecimento

		if (ie_rest_estab_p = 'S') then

			-- verifica se o estabelecimento e diferente

			if (r_c01_w.cd_estabelecimento != cd_estabelecimento_p) then

				ie_acumula_base_w := false;
			end if;
		end if;

		-- ie_repasse_titulo_p = Somente considerar repasses com titulo gerado

		if (ie_repasse_titulo_p = 'S') and (r_c01_w.qt_tit_pagar = 0) then
		
			ie_acumula_base_w := false;
		end if;
		
		-- se e para fazer parte da base de calculo

		if (ie_acumula_base_w) then

			tb_nr_sequencia_w(nr_cont_w) := r_c01_w.nr_sequencia;
			tb_vl_tributo_w(nr_cont_w) := r_c01_w.vl_imposto;
			tb_vl_base_calc_w(nr_cont_w) := r_c01_w.vl_base_calculo;
			tb_vl_item_w(nr_cont_w) := r_c01_w.vl_vencimento;
			tb_cd_pf_w(nr_cont_w) := r_c01_w.cd_pessoa_fisica;
			tb_dt_comp_base_w(nr_cont_w) := r_c01_w.dt_base;
			tb_vl_nao_retido_w(nr_cont_w) := r_c01_w.vl_nao_retido;
			tb_vl_base_nao_ret_w(nr_cont_w) := r_c01_w.vl_base_nao_retido;
			tb_vl_trib_adic_w(nr_cont_w) := r_c01_w.vl_trib_adic;
			tb_vl_base_adic_w(nr_cont_w) := r_c01_w.vl_base_adic;
			tb_nr_seq_rep_terc_w(nr_cont_w) := r_c01_w.nr_repasse_terceiro;
			tb_nr_seq_tipo_prest_w(nr_cont_w) := r_c01_w.nr_seq_tipo_prestador;
			tb_nr_seq_prest_w(nr_cont_w) := r_c01_w.nr_seq_prestador;
			tb_ie_tipo_tributo_w(nr_cont_w) := r_c01_w.ie_tipo_tributo;

			-- se atingiu a quantidade manda pro banco

			if (nr_cont_w >= pls_util_pck.qt_registro_transacao_w) then

				SELECT * FROM pls_pp_tributacao_pck.alimenta_pp_base_acum_repasse(	nr_cont_w, tb_nr_sequencia_w, tb_vl_tributo_w, tb_vl_base_calc_w, tb_vl_item_w, tb_cd_pf_w, tb_dt_comp_base_w, tb_vl_nao_retido_w, tb_vl_base_nao_ret_w, tb_vl_trib_adic_w, tb_vl_base_adic_w, tb_nr_seq_rep_terc_w, tb_nr_seq_tipo_prest_w, tb_nr_seq_prest_w, tb_ie_tipo_tributo_w, nr_seq_lote_p, cd_tributo_p, nm_usuario_p) INTO STRICT _ora2pg_r;
 	nr_cont_w := _ora2pg_r.nr_cont_p; tb_nr_sequencia_w := _ora2pg_r.tb_nr_sequencia_p; tb_vl_tributo_w := _ora2pg_r.tb_vl_tributo_p; tb_vl_base_calc_w := _ora2pg_r.tb_vl_base_calc_p; tb_vl_item_w := _ora2pg_r.tb_vl_item_p; tb_cd_pf_w := _ora2pg_r.tb_cd_pf_p; tb_dt_comp_base_w := _ora2pg_r.tb_dt_comp_base_p; tb_vl_nao_retido_w := _ora2pg_r.tb_vl_nao_retido_p; tb_vl_base_nao_ret_w := _ora2pg_r.tb_vl_base_nao_ret_p; tb_vl_trib_adic_w := _ora2pg_r.tb_vl_trib_adic_p; tb_vl_base_adic_w := _ora2pg_r.tb_vl_base_adic_p; tb_nr_seq_rep_terc_w := _ora2pg_r.tb_nr_seq_rep_terc_p; tb_nr_seq_tipo_prest_w := _ora2pg_r.tb_nr_seq_tipo_prest_p; tb_nr_seq_prest_w := _ora2pg_r.tb_nr_seq_prest_p; tb_ie_tipo_tributo_w := _ora2pg_r.tb_ie_tipo_tributo_p;
			else
				nr_cont_w := nr_cont_w + 1;
			end if;
		end if;
	end if;
end loop;

-- se sobrou algo manda pro banco

SELECT * FROM pls_pp_tributacao_pck.alimenta_pp_base_acum_repasse(	nr_cont_w, tb_nr_sequencia_w, tb_vl_tributo_w, tb_vl_base_calc_w, tb_vl_item_w, tb_cd_pf_w, tb_dt_comp_base_w, tb_vl_nao_retido_w, tb_vl_base_nao_ret_w, tb_vl_trib_adic_w, tb_vl_base_adic_w, tb_nr_seq_rep_terc_w, tb_nr_seq_tipo_prest_w, tb_nr_seq_prest_w, tb_ie_tipo_tributo_w, nr_seq_lote_p, cd_tributo_p, nm_usuario_p) INTO STRICT _ora2pg_r;
 	nr_cont_w := _ora2pg_r.nr_cont_p; tb_nr_sequencia_w := _ora2pg_r.tb_nr_sequencia_p; tb_vl_tributo_w := _ora2pg_r.tb_vl_tributo_p; tb_vl_base_calc_w := _ora2pg_r.tb_vl_base_calc_p; tb_vl_item_w := _ora2pg_r.tb_vl_item_p; tb_cd_pf_w := _ora2pg_r.tb_cd_pf_p; tb_dt_comp_base_w := _ora2pg_r.tb_dt_comp_base_p; tb_vl_nao_retido_w := _ora2pg_r.tb_vl_nao_retido_p; tb_vl_base_nao_ret_w := _ora2pg_r.tb_vl_base_nao_ret_p; tb_vl_trib_adic_w := _ora2pg_r.tb_vl_trib_adic_p; tb_vl_base_adic_w := _ora2pg_r.tb_vl_base_adic_p; tb_nr_seq_rep_terc_w := _ora2pg_r.tb_nr_seq_rep_terc_p; tb_nr_seq_tipo_prest_w := _ora2pg_r.tb_nr_seq_tipo_prest_p; tb_nr_seq_prest_w := _ora2pg_r.tb_nr_seq_prest_p; tb_ie_tipo_tributo_w := _ora2pg_r.tb_ie_tipo_tributo_p;

END;

$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE pls_pp_tributacao_pck.gera_base_acum_repasse_terc ( nr_seq_lote_p pls_pp_lote.nr_sequencia%type, cd_tributo_p tributo.cd_tributo%type, ie_rest_estab_p tributo.ie_restringe_estab%type, ie_vencimento_p tributo.ie_vencimento%type, ie_repasse_titulo_p tributo.ie_repasse_titulo%type, cd_estabelecimento_p estabelecimento.cd_estabelecimento%type, nm_usuario_p usuario.nm_usuario%type) FROM PUBLIC;
