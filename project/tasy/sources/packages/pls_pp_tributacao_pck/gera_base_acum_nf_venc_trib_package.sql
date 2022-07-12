-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';




CREATE OR REPLACE PROCEDURE pls_pp_tributacao_pck.gera_base_acum_nf_venc_trib ( nr_seq_lote_p pls_pp_lote.nr_sequencia%type, cd_tributo_p tributo.cd_tributo%type, ie_rest_estab_p tributo.ie_restringe_estab%type, ie_vencimento_p tributo.ie_vencimento%type, cd_estabelecimento_p estabelecimento.cd_estabelecimento%type, nm_usuario_p usuario.nm_usuario%type) AS $body$
DECLARE


_ora2pg_r RECORD;
ie_vencimento_w		varchar(1);
ie_acumula_base_w	boolean;
nr_cont_w		integer;
tb_nr_sequencia_w	pls_util_cta_pck.t_number_table;
tb_cd_trib_nr_w		pls_util_cta_pck.t_number_table;
tb_dt_venc_nf_w		pls_util_cta_pck.t_date_table;
tb_vl_tributo_w		pls_util_cta_pck.t_number_table;
tb_vl_base_calc_w	pls_util_cta_pck.t_number_table;
tb_vl_item_w		pls_util_cta_pck.t_number_table;
tb_cd_pf_w		pls_util_cta_pck.t_varchar2_table_50;
tb_dt_comp_base_w	pls_util_cta_pck.t_date_table;
tb_vl_nao_retido_w	pls_util_cta_pck.t_number_table;
tb_vl_base_nao_ret_w	pls_util_cta_pck.t_number_table;
tb_vl_trib_adic_w	pls_util_cta_pck.t_number_table;
tb_vl_base_adic_w	pls_util_cta_pck.t_number_table;
tb_nr_seq_nota_fis_w	pls_util_cta_pck.t_number_table;
tb_nr_seq_tipo_prest_w	pls_util_cta_pck.t_number_table;
tb_nr_seq_prest_w	pls_util_cta_pck.t_number_table;
tb_ie_tipo_tributo_w	pls_util_cta_pck.t_varchar2_table_20;

c01 CURSOR(	cd_tributo_pc		tributo.cd_tributo%type,
		ie_vencimento_pc	text) FOR
	SELECT	b.cd_pessoa_fisica,
		a.nr_sequencia,
		a.cd_tributo,
		a.dt_vencimento,
		c.nr_seq_tipo_prestador,
		trunc(a.dt_vencimento, 'month') dt_base,
		max(a.vl_tributo) vl_tributo,
		max(a.vl_base_calculo) vl_base_calculo,
		max(b.vl_total_nota) vl_total_nota,
		max(b.cd_estabelecimento) cd_estabelecimento,
		obter_se_base_calculo(a.nr_sequencia, 'NFE') ie_base_calculo,
		max(a.vl_trib_nao_retido) vl_trib_nao_retido,
		max(a.vl_base_nao_retido) vl_base_nao_retido,
		max(a.vl_trib_adic) vl_trib_adic,
		max(a.vl_base_adic) vl_base_adic,
		max(b.nr_sequencia) nr_seq_nf,
		coalesce(max(b.ie_situacao),'1') ie_situacao,
		max(c.nr_seq_prestador) nr_seq_prestador,
		max(e.ie_tipo_tributo) ie_tipo_tributo
	from	pls_pp_prestador_tmp c,
		nota_fiscal b,
		nota_fiscal_venc_trib a,
		operacao_nota d,
		tributo e
	where	ie_vencimento_pc = 'V' -- se for por vencimento

	and	c.ie_tipo_prestador = 'PF'
	and 	b.cd_pessoa_fisica = c.cd_pessoa_fisica
	and	a.nr_sequencia = b.nr_sequencia
	and	a.dt_vencimento between c.dt_venc_ini_mes and c.dt_venc_fim_mes
	and	a.cd_tributo = cd_tributo_pc
	and	d.cd_operacao_nf = b.cd_operacao_nf
	and	d.ie_operacao_fiscal = 'E'
	and	e.cd_tributo = a.cd_tributo
	and not exists (	SELECT	1
			from	pls_pp_base_acum_trib x
			where	x.cd_tributo_nf_venc_trib = a.cd_tributo
			and	x.dt_vencimento_nf_venc_trib = a.dt_vencimento
			and	x.nr_seq_nf_venc_trib = a.nr_sequencia)
	group by b.cd_pessoa_fisica, a.nr_sequencia, a.cd_tributo,
		a.dt_vencimento, c.nr_seq_tipo_prestador
	
union all

	select	b.cd_pessoa_fisica,
		a.nr_sequencia,
		a.cd_tributo,
		a.dt_vencimento,
		c.nr_seq_tipo_prestador,
		trunc(a.dt_vencimento, 'month') dt_base,
		max(a.vl_tributo) vl_tributo,
		max(a.vl_base_calculo) vl_base_calculo,
		max(b.vl_total_nota) vl_total_nota,
		max(b.cd_estabelecimento) cd_estabelecimento,
		obter_se_base_calculo(a.nr_sequencia, 'NFE') ie_base_calculo,
		max(a.vl_trib_nao_retido) vl_trib_nao_retido,
		max(a.vl_base_nao_retido) vl_base_nao_retido,
		max(a.vl_trib_adic) vl_trib_adic,
		max(a.vl_base_adic) vl_base_adic,
		max(b.nr_sequencia) nr_seq_nf,
		coalesce(max(b.ie_situacao),'1') ie_situacao,
		max(c.nr_seq_prestador) nr_seq_prestador,
		max(e.ie_tipo_tributo) ie_tipo_tributo
	from	pls_pp_prestador_tmp c,
		nota_fiscal_venc_trib a,
		nota_fiscal b,
		operacao_nota d,
		tributo e
	where	ie_vencimento_pc = 'C' -- se for por competencia

	and	c.ie_tipo_prestador = 'PF'
	and	b.cd_pessoa_fisica = c.cd_pessoa_fisica
	and	a.nr_sequencia	= b.nr_sequencia
	and	a.cd_tributo = cd_tributo_pc
	and	a.dt_vencimento between c.dt_comp_ini_mes and c.dt_comp_fim_mes
	and	d.cd_operacao_nf = b.cd_operacao_nf
	and	d.ie_operacao_fiscal = 'E'
	and	e.cd_tributo = a.cd_tributo
	and not exists (	select	1
			from	pls_pp_base_acum_trib x
			where	x.cd_tributo_nf_venc_trib = a.cd_tributo
			and	x.dt_vencimento_nf_venc_trib = a.dt_vencimento
			and	x.nr_seq_nf_venc_trib = a.nr_sequencia)
	group by b.cd_pessoa_fisica, a.nr_sequencia, a.cd_tributo, 
		a.dt_vencimento, c.nr_seq_tipo_prestador;

BEGIN

-- se for Vencimento do titulo ou Data contabil/registro compromisso entao e a data do vencimento

if (ie_vencimento_p in ('V', 'C')) then

	ie_vencimento_w := 'V';

-- senao e a data de competencia do lote

else
	 ie_vencimento_w := 'C';
end if;

-- inicializa as variaveis

SELECT * FROM pls_pp_tributacao_pck.alimenta_pp_base_acum_nf_venc(	nr_cont_w, tb_nr_sequencia_w, tb_cd_trib_nr_w, tb_dt_venc_nf_w, tb_vl_tributo_w, tb_vl_base_calc_w, tb_vl_item_w, tb_cd_pf_w, tb_dt_comp_base_w, tb_vl_nao_retido_w, tb_vl_base_nao_ret_w, tb_vl_trib_adic_w, tb_vl_base_adic_w, tb_nr_seq_nota_fis_w, tb_nr_seq_tipo_prest_w, tb_nr_seq_prest_w, tb_ie_tipo_tributo_w, nr_seq_lote_p, cd_tributo_p, nm_usuario_p) INTO STRICT _ora2pg_r;
 	nr_cont_w := _ora2pg_r.nr_cont_p; tb_nr_sequencia_w := _ora2pg_r.tb_nr_sequencia_p; tb_cd_trib_nr_w := _ora2pg_r.tb_cd_trib_nr_p; tb_dt_venc_nf_w := _ora2pg_r.tb_dt_venc_nf_p; tb_vl_tributo_w := _ora2pg_r.tb_vl_tributo_p; tb_vl_base_calc_w := _ora2pg_r.tb_vl_base_calc_p; tb_vl_item_w := _ora2pg_r.tb_vl_item_p; tb_cd_pf_w := _ora2pg_r.tb_cd_pf_p; tb_dt_comp_base_w := _ora2pg_r.tb_dt_comp_base_p; tb_vl_nao_retido_w := _ora2pg_r.tb_vl_nao_retido_p; tb_vl_base_nao_ret_w := _ora2pg_r.tb_vl_base_nao_ret_p; tb_vl_trib_adic_w := _ora2pg_r.tb_vl_trib_adic_p; tb_vl_base_adic_w := _ora2pg_r.tb_vl_base_adic_p; tb_nr_seq_nota_fis_w := _ora2pg_r.tb_nr_seq_nota_fis_p; tb_nr_seq_tipo_prest_w := _ora2pg_r.tb_nr_seq_tipo_prest_p; tb_nr_seq_prest_w := _ora2pg_r.tb_nr_seq_prest_p; tb_ie_tipo_tributo_w := _ora2pg_r.tb_ie_tipo_tributo_p;

-- abre o cursor com os registros que precisam ser verificados

for r_c01_w in c01(cd_tributo_p, ie_vencimento_w) loop

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

		if (r_c01_w.ie_situacao != '1') then

			ie_acumula_base_w := false;
		end if;
		
		-- se e para fazer parte da base de calculo

		if (ie_acumula_base_w) then

			tb_nr_sequencia_w(nr_cont_w) := r_c01_w.nr_sequencia;
			tb_cd_trib_nr_w(nr_cont_w) := r_c01_w.cd_tributo;
			tb_dt_venc_nf_w(nr_cont_w) := r_c01_w.dt_vencimento;
			tb_vl_tributo_w(nr_cont_w) := r_c01_w.vl_tributo;
			tb_vl_base_calc_w(nr_cont_w) := r_c01_w.vl_base_calculo;
			tb_vl_item_w(nr_cont_w) := r_c01_w.vl_total_nota;
			tb_cd_pf_w(nr_cont_w) := r_c01_w.cd_pessoa_fisica;
			tb_dt_comp_base_w(nr_cont_w) := r_c01_w.dt_base;
			tb_vl_nao_retido_w(nr_cont_w) := r_c01_w.vl_trib_nao_retido;
			tb_vl_base_nao_ret_w(nr_cont_w) := r_c01_w.vl_base_nao_retido;
			tb_vl_trib_adic_w(nr_cont_w) := r_c01_w.vl_trib_adic;
			tb_vl_base_adic_w(nr_cont_w) := r_c01_w.vl_base_adic;
			tb_nr_seq_nota_fis_w(nr_cont_w) := r_c01_w.nr_seq_nf;
			tb_nr_seq_tipo_prest_w(nr_cont_w) := r_c01_w.nr_seq_tipo_prestador;
			tb_nr_seq_prest_w(nr_cont_w) := r_c01_w.nr_seq_prestador;
			tb_ie_tipo_tributo_w(nr_cont_w) := r_c01_w.ie_tipo_tributo;

			-- se atingiu a quantidade manda pro banco

			if (nr_cont_w >= pls_util_pck.qt_registro_transacao_w) then

				SELECT * FROM pls_pp_tributacao_pck.alimenta_pp_base_acum_nf_venc(	nr_cont_w, tb_nr_sequencia_w, tb_cd_trib_nr_w, tb_dt_venc_nf_w, tb_vl_tributo_w, tb_vl_base_calc_w, tb_vl_item_w, tb_cd_pf_w, tb_dt_comp_base_w, tb_vl_nao_retido_w, tb_vl_base_nao_ret_w, tb_vl_trib_adic_w, tb_vl_base_adic_w, tb_nr_seq_nota_fis_w, tb_nr_seq_tipo_prest_w, tb_nr_seq_prest_w, tb_ie_tipo_tributo_w, nr_seq_lote_p, cd_tributo_p, nm_usuario_p) INTO STRICT _ora2pg_r;
 	nr_cont_w := _ora2pg_r.nr_cont_p; tb_nr_sequencia_w := _ora2pg_r.tb_nr_sequencia_p; tb_cd_trib_nr_w := _ora2pg_r.tb_cd_trib_nr_p; tb_dt_venc_nf_w := _ora2pg_r.tb_dt_venc_nf_p; tb_vl_tributo_w := _ora2pg_r.tb_vl_tributo_p; tb_vl_base_calc_w := _ora2pg_r.tb_vl_base_calc_p; tb_vl_item_w := _ora2pg_r.tb_vl_item_p; tb_cd_pf_w := _ora2pg_r.tb_cd_pf_p; tb_dt_comp_base_w := _ora2pg_r.tb_dt_comp_base_p; tb_vl_nao_retido_w := _ora2pg_r.tb_vl_nao_retido_p; tb_vl_base_nao_ret_w := _ora2pg_r.tb_vl_base_nao_ret_p; tb_vl_trib_adic_w := _ora2pg_r.tb_vl_trib_adic_p; tb_vl_base_adic_w := _ora2pg_r.tb_vl_base_adic_p; tb_nr_seq_nota_fis_w := _ora2pg_r.tb_nr_seq_nota_fis_p; tb_nr_seq_tipo_prest_w := _ora2pg_r.tb_nr_seq_tipo_prest_p; tb_nr_seq_prest_w := _ora2pg_r.tb_nr_seq_prest_p; tb_ie_tipo_tributo_w := _ora2pg_r.tb_ie_tipo_tributo_p;
			else
				nr_cont_w := nr_cont_w + 1;
			end if;
		end if;
	end if;
end loop;

-- se sobrou algo manda pro banco

SELECT * FROM pls_pp_tributacao_pck.alimenta_pp_base_acum_nf_venc(	nr_cont_w, tb_nr_sequencia_w, tb_cd_trib_nr_w, tb_dt_venc_nf_w, tb_vl_tributo_w, tb_vl_base_calc_w, tb_vl_item_w, tb_cd_pf_w, tb_dt_comp_base_w, tb_vl_nao_retido_w, tb_vl_base_nao_ret_w, tb_vl_trib_adic_w, tb_vl_base_adic_w, tb_nr_seq_nota_fis_w, tb_nr_seq_tipo_prest_w, tb_nr_seq_prest_w, tb_ie_tipo_tributo_w, nr_seq_lote_p, cd_tributo_p, nm_usuario_p) INTO STRICT _ora2pg_r;
 	nr_cont_w := _ora2pg_r.nr_cont_p; tb_nr_sequencia_w := _ora2pg_r.tb_nr_sequencia_p; tb_cd_trib_nr_w := _ora2pg_r.tb_cd_trib_nr_p; tb_dt_venc_nf_w := _ora2pg_r.tb_dt_venc_nf_p; tb_vl_tributo_w := _ora2pg_r.tb_vl_tributo_p; tb_vl_base_calc_w := _ora2pg_r.tb_vl_base_calc_p; tb_vl_item_w := _ora2pg_r.tb_vl_item_p; tb_cd_pf_w := _ora2pg_r.tb_cd_pf_p; tb_dt_comp_base_w := _ora2pg_r.tb_dt_comp_base_p; tb_vl_nao_retido_w := _ora2pg_r.tb_vl_nao_retido_p; tb_vl_base_nao_ret_w := _ora2pg_r.tb_vl_base_nao_ret_p; tb_vl_trib_adic_w := _ora2pg_r.tb_vl_trib_adic_p; tb_vl_base_adic_w := _ora2pg_r.tb_vl_base_adic_p; tb_nr_seq_nota_fis_w := _ora2pg_r.tb_nr_seq_nota_fis_p; tb_nr_seq_tipo_prest_w := _ora2pg_r.tb_nr_seq_tipo_prest_p; tb_nr_seq_prest_w := _ora2pg_r.tb_nr_seq_prest_p; tb_ie_tipo_tributo_w := _ora2pg_r.tb_ie_tipo_tributo_p;

END;

$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE pls_pp_tributacao_pck.gera_base_acum_nf_venc_trib ( nr_seq_lote_p pls_pp_lote.nr_sequencia%type, cd_tributo_p tributo.cd_tributo%type, ie_rest_estab_p tributo.ie_restringe_estab%type, ie_vencimento_p tributo.ie_vencimento%type, cd_estabelecimento_p estabelecimento.cd_estabelecimento%type, nm_usuario_p usuario.nm_usuario%type) FROM PUBLIC;
