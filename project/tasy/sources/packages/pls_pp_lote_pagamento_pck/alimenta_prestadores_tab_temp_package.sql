-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';




CREATE OR REPLACE PROCEDURE pls_pp_lote_pagamento_pck.alimenta_prestadores_tab_temp (dt_referencia_p timestamp) AS $body$
DECLARE


_ora2pg_r RECORD;
nr_contador_w			integer;
nr_seq_prestador_matriz_w	pls_prestador.nr_sequencia%type;

tb_seq_prestador_w		pls_util_cta_pck.t_number_table;
tb_cd_prestador_w		pls_util_cta_pck.t_varchar2_table_50;
tb_seq_prestador_matriz_w	pls_util_cta_pck.t_number_table;
tb_ie_situacao_cooperado_w	pls_util_cta_pck.t_number_table;
tb_ie_cooperado_w		pls_util_cta_pck.t_varchar2_table_5;
tb_ie_situacao_w		pls_util_cta_pck.t_varchar2_table_1;
tb_ie_tipo_prestador_w		pls_util_cta_pck.t_varchar2_table_2;
tb_cd_prestador_matriz_w	pls_util_cta_pck.t_varchar2_table_50;
tb_seq_tipo_prestador_w		pls_util_cta_pck.t_number_table;
tb_cd_pessoa_fisica_w		pls_util_cta_pck.t_varchar2_table_10;
tb_cd_cgc_w			pls_util_cta_pck.t_varchar2_table_15;
tb_nr_seq_classificacao_w	pls_util_cta_pck.t_number_table;
tb_data_vencimento_w		pls_util_cta_pck.t_date_table;
tb_ie_origem_venc_titulo_w	pls_util_cta_pck.t_varchar2_table_5;
tb_ie_origem_comp_pag_w		pls_util_cta_pck.t_varchar2_table_5;
tb_dt_comp_pagto_w		pls_util_cta_pck.t_date_table;
tb_data_venc_trunc_w		pls_util_cta_pck.t_date_table;
tb_nr_seq_regra_vcto_w		pls_util_cta_pck.t_number_table;
tb_ie_acao_pgto_neg_w		pls_util_cta_pck.t_varchar2_table_5;
tb_qt_pag_neg_max_w		pls_util_cta_pck.t_number_table;
tb_vl_min_tit_liq_w		pls_util_cta_pck.t_number_table;
tb_ie_tipo_relacao_w		pls_util_cta_pck.t_varchar2_table_5;
tb_ie_tipo_ptu_w		pls_util_cta_pck.t_varchar2_table_10;
tb_dt_comp_ini_mes_w		pls_util_cta_pck.t_date_table;
tb_dt_comp_fim_mes_w		pls_util_cta_pck.t_date_table;
tb_dt_venc_ini_mes_w		pls_util_cta_pck.t_date_table;
tb_dt_venc_fim_mes_w		pls_util_cta_pck.t_date_table;
tb_nr_seq_prest_pgto_w		pls_util_cta_pck.t_number_table;
tb_nr_seq_conta_banco_w		pls_util_cta_pck.t_number_table;

-- busca todos os prestadores da base com alguns dados complementares

c01 CURSOR FOR
	SELECT	a.nr_sequencia nr_seq_prestador,
		a.cd_prestador,
		(SELECT	max(b.nr_sequencia)
		 from	pls_prestador b
		 where	b.cd_cgc = a.cd_cgc
		 and	b.ie_prestador_matriz = 'S') nr_seq_prestador_matriz,
		a.nr_seq_prest_princ,
		a.ie_prestador_matriz,
		pls_obter_situacao_coop_prest(a.cd_pessoa_fisica, a.cd_cgc) ie_situacao_cooperado,
		pls_obter_se_cooperado(a.cd_pessoa_fisica, a.cd_cgc) ie_cooperado,
		coalesce(a.ie_situacao, 'A') ie_situacao,
		a.cd_pessoa_fisica,
		a.cd_cgc,
		a.nr_seq_tipo_prestador,
		a.dt_exclusao,
		a.nr_seq_classificacao,
		a.cd_estabelecimento,
		a.ie_tipo_relacao,
		(select	max(x.ie_tipo_ptu)
		from	pls_tipo_prestador x
		where	x.nr_sequencia = a.nr_seq_tipo_prestador) ie_tipo_ptu,
		(select	max(c.nr_seq_conta_banco)
		from	pls_regra_pgto_prest_banco c
		where	c.nr_seq_prestador = a.nr_sequencia
		and	c.ie_situacao = 'A') nr_seq_conta_banco_prest,
		(select	max(d.nr_seq_conta_banco)
		from	pls_regra_pgto_prest_banco d
		where	coalesce(d.nr_seq_prestador::text, '') = ''
		and	d.ie_situacao = 'A') nr_seq_conta_banco
	from   	pls_prestador a;

BEGIN

-- limpa a tabela temporaria sempre antes de alimentar novos registros

EXECUTE 'truncate table pls_pp_prestador_tmp';

-- chama para inicializar as variaveis

SELECT * FROM pls_pp_lote_pagamento_pck.alimenta_prestador(	nr_contador_w, tb_seq_prestador_w, tb_cd_prestador_w, tb_seq_prestador_matriz_w, tb_ie_situacao_cooperado_w, tb_ie_cooperado_w, tb_ie_situacao_w, tb_ie_tipo_prestador_w, tb_cd_prestador_matriz_w, tb_seq_tipo_prestador_w, tb_cd_pessoa_fisica_w, tb_cd_cgc_w, tb_nr_seq_classificacao_w, tb_data_vencimento_w, tb_ie_origem_venc_titulo_w, tb_ie_origem_comp_pag_w, tb_dt_comp_pagto_w, tb_nr_seq_regra_vcto_w, tb_ie_acao_pgto_neg_w, tb_qt_pag_neg_max_w, tb_vl_min_tit_liq_w, tb_ie_tipo_relacao_w, tb_ie_tipo_ptu_w, tb_data_venc_trunc_w, tb_dt_comp_ini_mes_w, tb_dt_comp_fim_mes_w, tb_dt_venc_ini_mes_w, tb_dt_venc_fim_mes_w, tb_nr_seq_prest_pgto_w, tb_nr_seq_conta_banco_w) INTO STRICT _ora2pg_r;
 	nr_contador_w := _ora2pg_r.nr_contador_p; tb_seq_prestador_w := _ora2pg_r.tb_seq_prestador_p; tb_cd_prestador_w := _ora2pg_r.tb_cd_prestador_p; tb_seq_prestador_matriz_w := _ora2pg_r.tb_seq_prestador_matriz_p; tb_ie_situacao_cooperado_w := _ora2pg_r.tb_ie_situacao_cooperado_p; tb_ie_cooperado_w := _ora2pg_r.tb_ie_cooperado_p; tb_ie_situacao_w := _ora2pg_r.tb_ie_situacao_p; tb_ie_tipo_prestador_w := _ora2pg_r.tb_ie_tipo_prestador_p; tb_cd_prestador_matriz_w := _ora2pg_r.tb_cd_prestador_matriz_p; tb_seq_tipo_prestador_w := _ora2pg_r.tb_seq_tipo_prestador_p; tb_cd_pessoa_fisica_w := _ora2pg_r.tb_cd_pessoa_fisica_p; tb_cd_cgc_w := _ora2pg_r.tb_cd_cgc_p; tb_nr_seq_classificacao_w := _ora2pg_r.tb_nr_seq_classificacao_p; tb_data_vencimento_w := _ora2pg_r.tb_data_vencimento_p; tb_ie_origem_venc_titulo_w := _ora2pg_r.tb_ie_origem_venc_titulo_p; tb_ie_origem_comp_pag_w := _ora2pg_r.tb_ie_origem_comp_pag_p; tb_dt_comp_pagto_w := _ora2pg_r.tb_dt_comp_pagto_p; tb_nr_seq_regra_vcto_w := _ora2pg_r.tb_nr_seq_regra_vcto_p; tb_ie_acao_pgto_neg_w := _ora2pg_r.tb_ie_acao_pgto_neg_p; tb_qt_pag_neg_max_w := _ora2pg_r.tb_qt_pag_neg_max_p; tb_vl_min_tit_liq_w := _ora2pg_r.tb_vl_min_tit_liq_p; tb_ie_tipo_relacao_w := _ora2pg_r.tb_ie_tipo_relacao_p; tb_ie_tipo_ptu_w := _ora2pg_r.tb_ie_tipo_ptu_p; tb_data_venc_trunc_w := _ora2pg_r.tb_data_venc_trunc_p; tb_dt_comp_ini_mes_w := _ora2pg_r.tb_dt_comp_ini_mes_p; tb_dt_comp_fim_mes_w := _ora2pg_r.tb_dt_comp_fim_mes_p; tb_dt_venc_ini_mes_w := _ora2pg_r.tb_dt_venc_ini_mes_p; tb_dt_venc_fim_mes_w := _ora2pg_r.tb_dt_venc_fim_mes_p; tb_nr_seq_prest_pgto_w := _ora2pg_r.tb_nr_seq_prest_pgto_p; tb_nr_seq_conta_banco_w := _ora2pg_r.tb_nr_seq_conta_banco_p;

for r_c01_w in c01 loop
	tb_seq_prestador_w(nr_contador_w) := r_c01_w.nr_seq_prestador;
	tb_cd_prestador_w(nr_contador_w) := r_c01_w.cd_prestador;

	-- conta banco do prestador, se nao tiver uma regra para este prestador busca a maior regra generica

	tb_nr_seq_conta_banco_w(nr_contador_w) := coalesce(r_c01_w.nr_seq_conta_banco_prest, r_c01_w.nr_seq_conta_banco);
	
	-- tratamento para prestador matriz

	nr_seq_prestador_matriz_w := null;
	
	-- se tiver o campo ie_prestador_matriz marcado para S e encontrou o prestador

	if (r_c01_w.nr_seq_prestador_matriz IS NOT NULL AND r_c01_w.nr_seq_prestador_matriz::text <> '') then
		nr_seq_prestador_matriz_w := r_c01_w.nr_seq_prestador_matriz;

	-- se o campo prestador matriz estiver informado

	elsif (r_c01_w.nr_seq_prest_princ IS NOT NULL AND r_c01_w.nr_seq_prest_princ::text <> '') then
		nr_seq_prestador_matriz_w := r_c01_w.nr_seq_prest_princ;

	-- se nenhuma condicao acima for verdadeira e estiver marcado o prestador matriz

	-- significa que ele mesmo e o prestador matriz (feito apenas por seguranca, e praticamente impossivel entrar aqui)

	elsif (r_c01_w.ie_prestador_matriz = 'S') then
		nr_seq_prestador_matriz_w := r_c01_w.nr_seq_prestador;
	end if;
	
	-- alimenta o cd_prestador do prestador matriz

	if (nr_seq_prestador_matriz_w IS NOT NULL AND nr_seq_prestador_matriz_w::text <> '') then

		select	max(cd_prestador)
		into STRICT	tb_cd_prestador_matriz_w(nr_contador_w)
		from	pls_prestador
		where	nr_sequencia = nr_seq_prestador_matriz_w;
	else
		tb_cd_prestador_matriz_w(nr_contador_w) := null;
	end if;
	
	tb_seq_prestador_matriz_w(nr_contador_w) := nr_seq_prestador_matriz_w;
	tb_ie_situacao_cooperado_w(nr_contador_w) := r_c01_w.ie_situacao_cooperado;
	tb_ie_cooperado_w(nr_contador_w) := r_c01_w.ie_cooperado;
	tb_ie_situacao_w(nr_contador_w) := r_c01_w.ie_situacao;
	tb_seq_tipo_prestador_w(nr_contador_w) := r_c01_w.nr_seq_tipo_prestador;
	tb_cd_pessoa_fisica_w(nr_contador_w) := r_c01_w.cd_pessoa_fisica;
	tb_cd_cgc_w(nr_contador_w) := r_c01_w.cd_cgc;
	tb_nr_seq_classificacao_w(nr_contador_w) := r_c01_w.nr_seq_classificacao;
	tb_ie_tipo_relacao_w(nr_contador_w) := r_c01_w.ie_tipo_relacao;
	tb_ie_tipo_ptu_w(nr_contador_w) := r_c01_w.ie_tipo_ptu;
		
	-- condicao para determinar se prestador e pessoa fisica ou juridica

	if (r_c01_w.cd_cgc IS NOT NULL AND r_c01_w.cd_cgc::text <> '') then
		tb_ie_tipo_prestador_w(nr_contador_w) := 'PJ';
	else
		tb_ie_tipo_prestador_w(nr_contador_w) := 'PF';
	end if;
	
	-- verifica qual a data de vencimento do prestador e de competencia do pagamento, para cada prestador

	SELECT * FROM pls_pp_lote_pagamento_pck.obter_data_vencimento_prest(	r_c01_w.nr_seq_prestador, r_c01_w.cd_estabelecimento) INTO STRICT tb_ie_origem_venc_titulo_w(nr_contador_w), tb_nr_seq_regra_vcto_w(nr_contador_w), tb_dt_comp_pagto_w(nr_contador_w), tb_ie_origem_comp_pag_w(nr_contador_w);

	-- estes campos abaixosao utilizados futuramente em selects para evitar a utilizacao de funcoes do tipo trunc ou fim_dia

	tb_data_venc_trunc_w(nr_contador_w) := trunc(tb_data_vencimento_w(nr_contador_w), 'month');
	tb_dt_comp_ini_mes_w(nr_contador_w) := pls_util_pck.inicio_mes(tb_dt_comp_pagto_w(nr_contador_w));
	tb_dt_comp_fim_mes_w(nr_contador_w) := pls_util_pck.fim_mes(tb_dt_comp_pagto_w(nr_contador_w));
	tb_dt_venc_ini_mes_w(nr_contador_w) := pls_util_pck.inicio_mes(tb_data_vencimento_w(nr_contador_w));
	tb_dt_venc_fim_mes_w(nr_contador_w) := pls_util_pck.fim_mes(tb_data_vencimento_w(nr_contador_w));
	
	-- Obtem os dados da regra de forma de pagamento do prestador

	SELECT * FROM pls_pp_lote_pagamento_pck.obter_dados_forma_pgto_prest(	r_c01_w.nr_seq_prestador, tb_ie_acao_pgto_neg_w(nr_contador_w), tb_qt_pag_neg_max_w(nr_contador_w), tb_vl_min_tit_liq_w(nr_contador_w)) INTO STRICT tb_ie_acao_pgto_neg_w(nr_contador_w), tb_qt_pag_neg_max_w(nr_contador_w), tb_vl_min_tit_liq_w(nr_contador_w);

	-- verifica se existe alguma regra para prestador de recebimento, caso existir entao retorna este prestador como o prestador do pagamento

	-- se nao existir nenhuma regra em vigencia retorna o proprio prestador passado de parametro

	tb_nr_seq_prest_pgto_w(nr_contador_w) := pls_pp_lote_pagamento_pck.obter_prestador_pagamento(	r_c01_w.nr_seq_prestador, tb_data_vencimento_w(nr_contador_w));

	-- se atingiu a quantidade manda para o banco

	if (nr_contador_w >= pls_util_pck.qt_registro_transacao_w) then

		SELECT * FROM pls_pp_lote_pagamento_pck.alimenta_prestador(	nr_contador_w, tb_seq_prestador_w, tb_cd_prestador_w, tb_seq_prestador_matriz_w, tb_ie_situacao_cooperado_w, tb_ie_cooperado_w, tb_ie_situacao_w, tb_ie_tipo_prestador_w, tb_cd_prestador_matriz_w, tb_seq_tipo_prestador_w, tb_cd_pessoa_fisica_w, tb_cd_cgc_w, tb_nr_seq_classificacao_w, tb_data_vencimento_w, tb_ie_origem_venc_titulo_w, tb_ie_origem_comp_pag_w, tb_dt_comp_pagto_w, tb_nr_seq_regra_vcto_w, tb_ie_acao_pgto_neg_w, tb_qt_pag_neg_max_w, tb_vl_min_tit_liq_w, tb_ie_tipo_relacao_w, tb_ie_tipo_ptu_w, tb_data_venc_trunc_w, tb_dt_comp_ini_mes_w, tb_dt_comp_fim_mes_w, tb_dt_venc_ini_mes_w, tb_dt_venc_fim_mes_w, tb_nr_seq_prest_pgto_w, tb_nr_seq_conta_banco_w) INTO STRICT _ora2pg_r;
 	nr_contador_w := _ora2pg_r.nr_contador_p; tb_seq_prestador_w := _ora2pg_r.tb_seq_prestador_p; tb_cd_prestador_w := _ora2pg_r.tb_cd_prestador_p; tb_seq_prestador_matriz_w := _ora2pg_r.tb_seq_prestador_matriz_p; tb_ie_situacao_cooperado_w := _ora2pg_r.tb_ie_situacao_cooperado_p; tb_ie_cooperado_w := _ora2pg_r.tb_ie_cooperado_p; tb_ie_situacao_w := _ora2pg_r.tb_ie_situacao_p; tb_ie_tipo_prestador_w := _ora2pg_r.tb_ie_tipo_prestador_p; tb_cd_prestador_matriz_w := _ora2pg_r.tb_cd_prestador_matriz_p; tb_seq_tipo_prestador_w := _ora2pg_r.tb_seq_tipo_prestador_p; tb_cd_pessoa_fisica_w := _ora2pg_r.tb_cd_pessoa_fisica_p; tb_cd_cgc_w := _ora2pg_r.tb_cd_cgc_p; tb_nr_seq_classificacao_w := _ora2pg_r.tb_nr_seq_classificacao_p; tb_data_vencimento_w := _ora2pg_r.tb_data_vencimento_p; tb_ie_origem_venc_titulo_w := _ora2pg_r.tb_ie_origem_venc_titulo_p; tb_ie_origem_comp_pag_w := _ora2pg_r.tb_ie_origem_comp_pag_p; tb_dt_comp_pagto_w := _ora2pg_r.tb_dt_comp_pagto_p; tb_nr_seq_regra_vcto_w := _ora2pg_r.tb_nr_seq_regra_vcto_p; tb_ie_acao_pgto_neg_w := _ora2pg_r.tb_ie_acao_pgto_neg_p; tb_qt_pag_neg_max_w := _ora2pg_r.tb_qt_pag_neg_max_p; tb_vl_min_tit_liq_w := _ora2pg_r.tb_vl_min_tit_liq_p; tb_ie_tipo_relacao_w := _ora2pg_r.tb_ie_tipo_relacao_p; tb_ie_tipo_ptu_w := _ora2pg_r.tb_ie_tipo_ptu_p; tb_data_venc_trunc_w := _ora2pg_r.tb_data_venc_trunc_p; tb_dt_comp_ini_mes_w := _ora2pg_r.tb_dt_comp_ini_mes_p; tb_dt_comp_fim_mes_w := _ora2pg_r.tb_dt_comp_fim_mes_p; tb_dt_venc_ini_mes_w := _ora2pg_r.tb_dt_venc_ini_mes_p; tb_dt_venc_fim_mes_w := _ora2pg_r.tb_dt_venc_fim_mes_p; tb_nr_seq_prest_pgto_w := _ora2pg_r.tb_nr_seq_prest_pgto_p; tb_nr_seq_conta_banco_w := _ora2pg_r.tb_nr_seq_conta_banco_p;
	else
		nr_contador_w := nr_contador_w + 1;
	end if;
end loop;

-- se sobrou algo manda para o banco e zera as variaveis

SELECT * FROM pls_pp_lote_pagamento_pck.alimenta_prestador(	nr_contador_w, tb_seq_prestador_w, tb_cd_prestador_w, tb_seq_prestador_matriz_w, tb_ie_situacao_cooperado_w, tb_ie_cooperado_w, tb_ie_situacao_w, tb_ie_tipo_prestador_w, tb_cd_prestador_matriz_w, tb_seq_tipo_prestador_w, tb_cd_pessoa_fisica_w, tb_cd_cgc_w, tb_nr_seq_classificacao_w, tb_data_vencimento_w, tb_ie_origem_venc_titulo_w, tb_ie_origem_comp_pag_w, tb_dt_comp_pagto_w, tb_nr_seq_regra_vcto_w, tb_ie_acao_pgto_neg_w, tb_qt_pag_neg_max_w, tb_vl_min_tit_liq_w, tb_ie_tipo_relacao_w, tb_ie_tipo_ptu_w, tb_data_venc_trunc_w, tb_dt_comp_ini_mes_w, tb_dt_comp_fim_mes_w, tb_dt_venc_ini_mes_w, tb_dt_venc_fim_mes_w, tb_nr_seq_prest_pgto_w, tb_nr_seq_conta_banco_w) INTO STRICT _ora2pg_r;
 	nr_contador_w := _ora2pg_r.nr_contador_p; tb_seq_prestador_w := _ora2pg_r.tb_seq_prestador_p; tb_cd_prestador_w := _ora2pg_r.tb_cd_prestador_p; tb_seq_prestador_matriz_w := _ora2pg_r.tb_seq_prestador_matriz_p; tb_ie_situacao_cooperado_w := _ora2pg_r.tb_ie_situacao_cooperado_p; tb_ie_cooperado_w := _ora2pg_r.tb_ie_cooperado_p; tb_ie_situacao_w := _ora2pg_r.tb_ie_situacao_p; tb_ie_tipo_prestador_w := _ora2pg_r.tb_ie_tipo_prestador_p; tb_cd_prestador_matriz_w := _ora2pg_r.tb_cd_prestador_matriz_p; tb_seq_tipo_prestador_w := _ora2pg_r.tb_seq_tipo_prestador_p; tb_cd_pessoa_fisica_w := _ora2pg_r.tb_cd_pessoa_fisica_p; tb_cd_cgc_w := _ora2pg_r.tb_cd_cgc_p; tb_nr_seq_classificacao_w := _ora2pg_r.tb_nr_seq_classificacao_p; tb_data_vencimento_w := _ora2pg_r.tb_data_vencimento_p; tb_ie_origem_venc_titulo_w := _ora2pg_r.tb_ie_origem_venc_titulo_p; tb_ie_origem_comp_pag_w := _ora2pg_r.tb_ie_origem_comp_pag_p; tb_dt_comp_pagto_w := _ora2pg_r.tb_dt_comp_pagto_p; tb_nr_seq_regra_vcto_w := _ora2pg_r.tb_nr_seq_regra_vcto_p; tb_ie_acao_pgto_neg_w := _ora2pg_r.tb_ie_acao_pgto_neg_p; tb_qt_pag_neg_max_w := _ora2pg_r.tb_qt_pag_neg_max_p; tb_vl_min_tit_liq_w := _ora2pg_r.tb_vl_min_tit_liq_p; tb_ie_tipo_relacao_w := _ora2pg_r.tb_ie_tipo_relacao_p; tb_ie_tipo_ptu_w := _ora2pg_r.tb_ie_tipo_ptu_p; tb_data_venc_trunc_w := _ora2pg_r.tb_data_venc_trunc_p; tb_dt_comp_ini_mes_w := _ora2pg_r.tb_dt_comp_ini_mes_p; tb_dt_comp_fim_mes_w := _ora2pg_r.tb_dt_comp_fim_mes_p; tb_dt_venc_ini_mes_w := _ora2pg_r.tb_dt_venc_ini_mes_p; tb_dt_venc_fim_mes_w := _ora2pg_r.tb_dt_venc_fim_mes_p; tb_nr_seq_prest_pgto_w := _ora2pg_r.tb_nr_seq_prest_pgto_p; tb_nr_seq_conta_banco_w := _ora2pg_r.tb_nr_seq_conta_banco_p;

END;

$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE pls_pp_lote_pagamento_pck.alimenta_prestadores_tab_temp (dt_referencia_p timestamp) FROM PUBLIC;