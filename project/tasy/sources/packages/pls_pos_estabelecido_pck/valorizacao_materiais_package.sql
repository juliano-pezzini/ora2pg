-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';


--Etapa de valorizacao dos materiais selecionados. Ser_o chamadas funcionalidades para leitura e aplicacao de regras



CREATE OR REPLACE PROCEDURE pls_pos_estabelecido_pck.valorizacao_materiais ( nm_usuario_p usuario.nm_usuario%type, cd_estabelecimento_p estabelecimento.cd_estabelecimento%type) AS $body$
DECLARE


_ora2pg_r RECORD;
dados_regra_preco_mat_w		pls_cta_valorizacao_pck.dados_regra_preco_material;
tb_dados_mat_w			table_dados_regra_preco_mat;
tx_intercambio_w		pls_conta_proc.tx_intercambio%type;
nr_seq_pos_estab_interc_w	pls_regra_preco_proc.nr_sequencia%type;
vl_materiais_w			pls_conta_pos_estabelecido.vl_materiais%type;
vl_tx_material_w		pls_conta_pos_mat.vl_taxa_material%type;
i				integer := 0;
QT_W				integer := 0;
	
--Cursor com os itens identificados anteriormente como eleg_veis para geracao de p_s.	

C01 CURSOR FOR
	SELECT	mat.nr_sequencia,
		mat.ie_tipo_despesa,
		mat.nr_seq_cabecalho,
		mat.tx_administracao
	from	w_pls_conta_pos_mat mat
	where	mat.ie_gera_valor_pos_estab in ('S', 'SB')
	and 	mat.ie_tipo_regra_pos not in (2, 3, 7, 8)
	
union all

	SELECT	mat.nr_sequencia,
		mat.ie_tipo_despesa,
		mat.nr_seq_cabecalho,
		mat.tx_administracao
	from	w_pls_conta_pos_mat mat
	where	mat.ie_gera_valor_pos_estab in ('S', 'SB')
	and	coalesce(mat.ie_tipo_regra_pos::text, '') = '';

BEGIN
	tb_dados_mat_w := pls_pos_estabelecido_pck.atualiza_val_regra_mat_int(tb_dados_mat_w);
	for r_c01_w in C01 loop
		
		tx_intercambio_w := r_c01_w.tx_administracao;
		--Processa regras de valorizacao

		SELECT * FROM pls_pos_estabelecido_pck.pls_atualiza_valor_mat_pos(	r_c01_w.nr_sequencia, r_c01_w.nr_seq_cabecalho, 'N', nm_usuario_p, tx_intercambio_w, current_setting('pls_pos_estabelecido_pck.ie_pos_estab_faturamento_w')::pls_parametros.ie_pos_estab_faturamento%type, current_setting('pls_pos_estabelecido_pck.ie_geracao_pos_estabelecido_w')::pls_parametros.ie_geracao_pos_estabelecido%type, current_setting('pls_pos_estabelecido_pck.ie_preco_interc_congenere_w')::pls_parametros.ie_preco_interc_congenere%type, nr_seq_pos_estab_interc_w, vl_materiais_w, tx_intercambio_w, vl_tx_material_w, dados_regra_preco_mat_w ) INTO STRICT _ora2pg_r;
 nr_seq_pos_estab_interc_w := _ora2pg_r.nr_seq_regra_p; vl_materiais_w := _ora2pg_r.vl_materiais_p; tx_intercambio_w := _ora2pg_r.tx_inter_out_p; vl_tx_material_w := _ora2pg_r.vl_tx_material_p; dados_regra_preco_mat_w  := _ora2pg_r.dados_regra_preco_material_p;
		
		tb_dados_mat_w.nr_sequencia(i)		:= r_c01_w.nr_sequencia;
		tb_dados_mat_w.vl_material_tabela(i)	:= dados_regra_preco_mat_w.vl_material_tabela;
		tb_dados_mat_w.cd_moeda_calculo(i)	:= dados_regra_preco_mat_w.cd_moeda_calculo;
		tb_dados_mat_w.vl_ch_material(i)	:= dados_regra_preco_mat_w.vl_ch_material;
		tb_dados_mat_w.vl_materiais(i)		:= vl_materiais_w;
		tb_dados_mat_w.nr_seq_regra(i)		:= nr_seq_pos_estab_interc_w;
		tb_dados_mat_w.tx_intercambio(i)	:= tx_intercambio_w;
		tb_dados_mat_w.vl_taxa_material(i)	:= vl_tx_material_w;
		
		--Se atingiu quantidade m_xima de registros, atualiza no banco

		if ( i > pls_util_cta_pck.qt_registro_transacao_w) then
			
			--Realiza update dos valores retornados no processamento de regras anterior

			tb_dados_mat_w := pls_pos_estabelecido_pck.atualiza_val_regra_mat_int(tb_dados_mat_w);
			i := 0;
		else
			i := i + 1;
		end if;
	end loop;

	--Se sobraram registros nas estruturas, manda para o banco para atualizar a tabela tempor_ria de procedimentos.

	tb_dados_mat_w := pls_pos_estabelecido_pck.atualiza_val_regra_mat_int(tb_dados_mat_w);
	
END;

$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE pls_pos_estabelecido_pck.valorizacao_materiais ( nm_usuario_p usuario.nm_usuario%type, cd_estabelecimento_p estabelecimento.cd_estabelecimento%type) FROM PUBLIC;