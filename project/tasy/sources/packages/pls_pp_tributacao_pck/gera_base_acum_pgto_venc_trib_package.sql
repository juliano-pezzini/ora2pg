-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';




CREATE OR REPLACE PROCEDURE pls_pp_tributacao_pck.gera_base_acum_pgto_venc_trib ( nr_seq_lote_p pls_pp_lote.nr_sequencia%type, cd_tributo_p tributo.cd_tributo%type, cd_estabelecimento_p estabelecimento.cd_estabelecimento%type, nm_usuario_p usuario.nm_usuario%type) AS $body$
DECLARE


_ora2pg_r RECORD;
nr_cont_w		integer;
ie_acumula_base_w	boolean;

tb_nr_seq_lote_ant_w	pls_util_cta_pck.t_number_table;
tb_nr_sequencia_w	pls_util_cta_pck.t_number_table;
tb_vl_tributo_w		pls_util_cta_pck.t_number_table;
tb_vl_base_calc_w	pls_util_cta_pck.t_number_table;
tb_cd_pf_w		pls_util_cta_pck.t_varchar2_table_50;
tb_dt_comp_base_w	pls_util_cta_pck.t_date_table;
tb_nr_seq_tipo_prest_w	pls_util_cta_pck.t_number_table;
tb_nr_seq_prest_w	pls_util_cta_pck.t_number_table;
tb_ie_tipo_trib_w	pls_util_cta_pck.t_varchar2_table_50;
vl_base_acu_desc_w	pls_pag_prest_venc_trib.vl_base_calculo%type;
nr_seq_prestador_w	pls_pagamento_prestador.nr_seq_prestador%type;
tb_vl_base_adic_w	pls_util_cta_pck.t_number_table;

-- e verificado se ja existe um registro para aquele mes que estamos processando

c01 CURSOR(	cd_tributo_pc	tributo.cd_tributo%type,
		nr_seq_lote_pc	pls_pp_lote.nr_sequencia%type) FOR
	SELECT	pr.cd_pessoa_fisica,
		pr.dt_data_venc_trunc dt_base,
		lp.nr_sequencia nr_seq_lote_pgto_ant,
		pt.nr_sequencia nr_seq_venc_trib,
		pt.vl_imposto vl_tributo,
		pt.vl_base_calculo,
		pr.nr_seq_tipo_prestador,
		t.ie_tipo_tributo,
		lp.cd_estabelecimento,
		pr.dt_data_venc_trunc,
		pr.dt_comp_pag,
		t.ie_vencimento,
		pr.nr_seq_prestador,
		pt.vl_base_adic
	from	tributo t,
		pls_pag_prest_venc_trib pt,
		pls_pag_prest_vencimento pv,
		pls_pagamento_prestador pp,
		pls_pp_prestador_tmp pr,
		pls_lote_pagamento lp
	where	lp.nr_sequencia		= pp.nr_seq_lote
	and	pp.nr_sequencia		= pv.nr_seq_pag_prestador
	and	pp.nr_seq_prestador	= pr.nr_seq_prestador
	and	pv.nr_sequencia		= pt.nr_seq_vencimento
	and	pt.cd_tributo		= t.cd_tributo
	and	pr.ie_tipo_prestador	= 'PF' -- Pessoa fiscia

	and	1 = 2 -- Nao migrar
-- IR	and	t.ie_tipo_tributo	in ('IR') 

-- IR	and	trunc(pv.dt_vencimento,'month') = to_date('01/01/2019')

-- INSS	and	t.ie_tipo_tributo	in ('INSS')

-- INSS	and	pt.ie_pago_prev != 'R' -- Carta

-- INSS	and	trunc(lp.dt_mes_competencia,'month') = to_date('01/12/2018')

	and not exists (	SELECT	1
			from	pls_pp_base_acum_trib x
			where	x.nr_seq_venc_trib	= pt.nr_sequencia
			and	x.dt_competencia	= trunc(pv.dt_vencimento,'month'))
	order by nr_seq_prestador, nr_seq_lote_pgto_ant;

BEGIN
-- inicia as variaveis

SELECT * FROM pls_pp_tributacao_pck.alimenta_pp_base_acu_venc_trib(	nr_cont_w, tb_nr_seq_lote_ant_w, tb_nr_sequencia_w, tb_vl_tributo_w, tb_vl_base_calc_w, tb_cd_pf_w, tb_dt_comp_base_w, tb_nr_seq_tipo_prest_w, tb_nr_seq_prest_w, tb_ie_tipo_trib_w, tb_vl_base_adic_w, nr_seq_lote_p, cd_tributo_p, nm_usuario_p) INTO STRICT _ora2pg_r;
 	nr_cont_w := _ora2pg_r.nr_cont_p; tb_nr_seq_lote_ant_w := _ora2pg_r.tb_nr_seq_lote_ant_p; tb_nr_sequencia_w := _ora2pg_r.tb_nr_sequencia_p; tb_vl_tributo_w := _ora2pg_r.tb_vl_tributo_p; tb_vl_base_calc_w := _ora2pg_r.tb_vl_base_calc_p; tb_cd_pf_w := _ora2pg_r.tb_cd_pf_p; tb_dt_comp_base_w := _ora2pg_r.tb_dt_comp_base_p; tb_nr_seq_tipo_prest_w := _ora2pg_r.tb_nr_seq_tipo_prest_p; tb_nr_seq_prest_w := _ora2pg_r.tb_nr_seq_prest_p; tb_ie_tipo_trib_w := _ora2pg_r.tb_ie_tipo_trib_p; tb_vl_base_adic_w := _ora2pg_r.tb_vl_base_adic_p;

for r_c01_w in c01(cd_tributo_p, nr_seq_lote_p) loop
	if (coalesce(nr_seq_prestador_w,0) != r_c01_w.nr_seq_prestador) then
		nr_seq_prestador_w	:= null;
	end if;

	-- comeca como sendo valido

	ie_acumula_base_w := true;
	
	-- verifica se o estabelecimento e diferente

	if (r_c01_w.cd_estabelecimento IS NOT NULL AND r_c01_w.cd_estabelecimento::text <> '') and (r_c01_w.cd_estabelecimento != cd_estabelecimento_p) then
		
		ie_acumula_base_w := false;
	end if;
	
	-- se e para fazer parte da base de calculo

	if (ie_acumula_base_w) then

		tb_nr_seq_lote_ant_w(nr_cont_w) := r_c01_w.nr_seq_lote_pgto_ant;
		tb_nr_sequencia_w(nr_cont_w) := r_c01_w.nr_seq_venc_trib;
		tb_vl_tributo_w(nr_cont_w) := r_c01_w.vl_tributo;
		
		if (r_c01_w.ie_tipo_tributo = 'IR') then
			tb_vl_base_calc_w(nr_cont_w) := (r_c01_w.vl_base_calculo - r_c01_w.vl_base_adic); -- IR sempre acumula, e assim e bom ir descontando a base
			
		elsif (r_c01_w.ie_tipo_tributo = 'INSS') then
			tb_vl_base_calc_w(nr_cont_w) := r_c01_w.vl_base_calculo;
		end if;
		
		tb_cd_pf_w(nr_cont_w) := r_c01_w.cd_pessoa_fisica;
		tb_nr_seq_tipo_prest_w(nr_cont_w) := r_c01_w.nr_seq_tipo_prestador;
		tb_ie_tipo_trib_w(nr_cont_w) := r_c01_w.ie_tipo_tributo;
		nr_seq_prestador_w := r_c01_w.nr_seq_prestador;
		tb_vl_base_adic_w(nr_cont_w) := r_c01_w.vl_base_adic;

		-- busca um prestador para lancar a carta, um prestador que seja da mesma pessoa fisica e que esteja na tributacao ja

		tb_nr_seq_prest_w(nr_cont_w) := pls_pp_tributacao_pck.obter_prest_pessoa_trib( nr_seq_lote_p, r_c01_w.cd_pessoa_fisica);

		-- para buscar a carta e olhado o campo ie_tipo_data do cadastro da carta, porem para tributar verificamos

		-- o campo ie_vencimento do cadastro do tributo para definir qual sera a data de 'tributacao'

		-- por vencimento

		if (r_c01_w.ie_vencimento in ('V', 'C')) then
			tb_dt_comp_base_w(nr_cont_w) := r_c01_w.dt_data_venc_trunc;
		-- por competencia

		else
			tb_dt_comp_base_w(nr_cont_w) := r_c01_w.dt_comp_pag;
		end if;
		
		-- se atingiu a quantidade manda pro banco

		if (nr_cont_w >= pls_util_pck.qt_registro_transacao_w) then
		
			SELECT * FROM pls_pp_tributacao_pck.alimenta_pp_base_acu_venc_trib(	nr_cont_w, tb_nr_seq_lote_ant_w, tb_nr_sequencia_w, tb_vl_tributo_w, tb_vl_base_calc_w, tb_cd_pf_w, tb_dt_comp_base_w, tb_nr_seq_tipo_prest_w, tb_nr_seq_prest_w, tb_ie_tipo_trib_w, tb_vl_base_adic_w, nr_seq_lote_p, cd_tributo_p, nm_usuario_p) INTO STRICT _ora2pg_r;
 	nr_cont_w := _ora2pg_r.nr_cont_p; tb_nr_seq_lote_ant_w := _ora2pg_r.tb_nr_seq_lote_ant_p; tb_nr_sequencia_w := _ora2pg_r.tb_nr_sequencia_p; tb_vl_tributo_w := _ora2pg_r.tb_vl_tributo_p; tb_vl_base_calc_w := _ora2pg_r.tb_vl_base_calc_p; tb_cd_pf_w := _ora2pg_r.tb_cd_pf_p; tb_dt_comp_base_w := _ora2pg_r.tb_dt_comp_base_p; tb_nr_seq_tipo_prest_w := _ora2pg_r.tb_nr_seq_tipo_prest_p; tb_nr_seq_prest_w := _ora2pg_r.tb_nr_seq_prest_p; tb_ie_tipo_trib_w := _ora2pg_r.tb_ie_tipo_trib_p; tb_vl_base_adic_w := _ora2pg_r.tb_vl_base_adic_p;
			null;
		else
			nr_cont_w := nr_cont_w + 1;
		end if;
	end if;
end loop;

-- se sobrou algo manda pro banco

SELECT * FROM pls_pp_tributacao_pck.alimenta_pp_base_acu_venc_trib(	nr_cont_w, tb_nr_seq_lote_ant_w, tb_nr_sequencia_w, tb_vl_tributo_w, tb_vl_base_calc_w, tb_cd_pf_w, tb_dt_comp_base_w, tb_nr_seq_tipo_prest_w, tb_nr_seq_prest_w, tb_ie_tipo_trib_w, tb_vl_base_adic_w, nr_seq_lote_p, cd_tributo_p, nm_usuario_p) INTO STRICT _ora2pg_r;
 	nr_cont_w := _ora2pg_r.nr_cont_p; tb_nr_seq_lote_ant_w := _ora2pg_r.tb_nr_seq_lote_ant_p; tb_nr_sequencia_w := _ora2pg_r.tb_nr_sequencia_p; tb_vl_tributo_w := _ora2pg_r.tb_vl_tributo_p; tb_vl_base_calc_w := _ora2pg_r.tb_vl_base_calc_p; tb_cd_pf_w := _ora2pg_r.tb_cd_pf_p; tb_dt_comp_base_w := _ora2pg_r.tb_dt_comp_base_p; tb_nr_seq_tipo_prest_w := _ora2pg_r.tb_nr_seq_tipo_prest_p; tb_nr_seq_prest_w := _ora2pg_r.tb_nr_seq_prest_p; tb_ie_tipo_trib_w := _ora2pg_r.tb_ie_tipo_trib_p; tb_vl_base_adic_w := _ora2pg_r.tb_vl_base_adic_p;

END;

$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE pls_pp_tributacao_pck.gera_base_acum_pgto_venc_trib ( nr_seq_lote_p pls_pp_lote.nr_sequencia%type, cd_tributo_p tributo.cd_tributo%type, cd_estabelecimento_p estabelecimento.cd_estabelecimento%type, nm_usuario_p usuario.nm_usuario%type) FROM PUBLIC;