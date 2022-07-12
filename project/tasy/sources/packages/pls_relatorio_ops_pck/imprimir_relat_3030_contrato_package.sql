-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';




CREATE OR REPLACE FUNCTION pls_relatorio_ops_pck.imprimir_relat_3030_contrato ( dt_inicio_p text, dt_fim_p text) RETURNS SETOF T_RELATORIO_3030_CONTRA_DATA AS $body$
DECLARE


	is_diferenca_valor_w		boolean;
	vl_preco_atual_w		double precision;
	t_relatorio_3030_contratos_w	t_relatorio_3030_contratos_row;
	nr_seq_plano_preco_aux_w	pls_plano_preco.nr_sequencia%type;

	C01 CURSOR(	dt_inicio_pc	text,
			dt_fim_pc	text) FOR
		SELECT	a.nr_sequencia nr_seq_contrato,
			a.nr_contrato,
			d.nr_seq_plano,
			a.cd_cgc_estipulante,
			d.nr_seq_tabela,
			a.CD_OPERADORA_EMPRESA,
			a.dt_reajuste
		from	pls_contrato_pagador	b,
			pls_contrato		a,
			pls_contrato_plano	d
		where	b.nr_seq_contrato	= a.nr_sequencia
		and	d.nr_seq_contrato	= a.nr_sequencia
		and	d.ie_situacao		= 'A'
		and	(a.cd_cgc_estipulante IS NOT NULL AND a.cd_cgc_estipulante::text <> '')
		and	a.CD_OPERADORA_EMPRESA not between 7000 and 7999
		and	to_char(a.dt_reajuste,'mm') between CASE WHEN dt_inicio_pc='  ' THEN to_char(a.dt_reajuste,'mm')  ELSE dt_inicio_pc END  and
						CASE WHEN dt_fim_pc='  ' THEN to_char(a.dt_reajuste,'mm')  ELSE dt_fim_pc END
		and	a.ie_situacao		= '2'
		and	exists (	SELECT	1
					from	pls_contrato		x,
						pls_contrato_plano	y
					where	y.nr_seq_contrato	= x.nr_sequencia
					and	x.cd_cgc_estipulante	= a.cd_cgc_estipulante
					and	y.nr_seq_plano		= d.nr_seq_plano
					and	x.CD_OPERADORA_EMPRESA between 7000 and 7999
					and	x.ie_situacao		= '2'
					and	d.ie_situacao		= 'A')
		group by a.nr_contrato,a.nr_sequencia,d.nr_seq_plano,a.cd_cgc_estipulante,d.nr_seq_tabela,a.CD_OPERADORA_EMPRESA,a.dt_reajuste;

	C02 CURSOR(	nr_seq_plano_pc			bigint,
			cd_cgc_pc			pls_contrato.cd_cgc_estipulante%type,
			cd_contrato_principal_pc	pls_contrato.nr_sequencia%type) FOR
		SELECT	a.nr_sequencia nr_seq_contrato,
			a.nr_contrato,
			d.nr_seq_tabela,
			a.CD_OPERADORA_EMPRESA,
			a.dt_reajuste
		from	pls_contrato_pagador	b,
			pls_contrato		a,
			pls_contrato_plano	d
		where	b.nr_seq_contrato	= a.nr_sequencia
		and	d.nr_seq_contrato	= a.nr_sequencia
		and	d.ie_situacao		= 'A'
		and	a.cd_cgc_estipulante 	= cd_cgc_pc
		and	d.nr_seq_plano		= nr_seq_plano_pc
		and	a.cd_contrato_principal = cd_contrato_principal_pc
		and	a.CD_OPERADORA_EMPRESA between 7000 and 7999
		and	a.ie_situacao		= '2'
		group by a.nr_sequencia,a.nr_contrato,d.nr_seq_tabela,a.CD_OPERADORA_EMPRESA,a.dt_reajuste;

	C03 CURSOR(	nr_seq_tabela_princ_pc	pls_tabela_preco.nr_sequencia%type) FOR
		SELECT	b.vl_preco_atual,
			b.qt_idade_inicial,
			b.qt_idade_final,
			a.nr_seq_plano
		from	pls_plano_preco		b,
			pls_tabela_preco	a
		where	b.nr_seq_tabela		= a.nr_sequencia
		and	a.nr_sequencia		= nr_seq_tabela_princ_pc;

	C04 CURSOR(	nr_seq_plano_pc			bigint,
			cd_cgc_pc			pls_contrato.cd_cgc_estipulante%type,
			cd_contrato_principal_pc	pls_contrato.nr_sequencia%type) FOR
		SELECT	a.nr_sequencia nr_seq_contrato,
			a.nr_contrato,
			d.nr_seq_tabela,
			a.CD_OPERADORA_EMPRESA,
			a.dt_reajuste
		from	pls_contrato_pagador	b,
			pls_contrato		a,
			pls_contrato_plano	d
		where	b.nr_seq_contrato	= a.nr_sequencia
		and	d.nr_seq_contrato	= a.nr_sequencia
		and	d.ie_situacao		= 'A'
		and	a.cd_cgc_estipulante 	= cd_cgc_pc
		and	d.nr_seq_plano		= nr_seq_plano_pc
		and	coalesce(a.cd_contrato_principal::text, '') = ''
		and	a.CD_OPERADORA_EMPRESA between 7000 and 7999
		and	a.ie_situacao		= '2'
		group by a.nr_sequencia,a.nr_contrato,d.nr_seq_tabela,a.CD_OPERADORA_EMPRESA,a.dt_reajuste;

	
BEGIN

	for r_c01_w in C01(dt_inicio_p,dt_fim_p) loop
		begin
		for r_c02_w in C02(r_c01_w.nr_seq_plano,r_c01_w.cd_cgc_estipulante,r_c01_w.nr_contrato) loop
			begin

			is_diferenca_valor_w	:= false;

			for r_c03_w in C03(r_c01_w.nr_seq_tabela) loop
				begin

				select	max(nr_sequencia)
				into STRICT	nr_seq_plano_preco_aux_w
				from	pls_plano_preco
				where	nr_seq_tabela		= r_c02_w.nr_seq_tabela
				and	qt_idade_inicial	= r_c03_w.qt_idade_inicial
				and	qt_idade_final		= r_c03_w.qt_idade_final;

				if (nr_seq_plano_preco_aux_w IS NOT NULL AND nr_seq_plano_preco_aux_w::text <> '') then
					select	vl_preco_atual
					into STRICT	vl_preco_atual_w
					from	pls_plano_preco
					where	nr_sequencia		= nr_seq_plano_preco_aux_w;

					if (vl_preco_atual_w <> r_c03_w.vl_preco_atual) then
						is_diferenca_valor_w := true;
						exit;
					end if;
				end if;
				end;
			end loop;

			if (is_diferenca_valor_w) then
				t_relatorio_3030_contratos_w.ds_informacao_princ 	:= '026 - ' || r_c01_w.CD_OPERADORA_EMPRESA || ' - ' || substr(obter_nome_pf_pj('',r_c01_w.cd_cgc_estipulante),1,255);
				t_relatorio_3030_contratos_w.nr_seq_tabela_prin		:= r_c01_w.nr_seq_tabela;
				t_relatorio_3030_contratos_w.dt_reajute_princ		:= pls_obter_dt_ultimo_reajuste(r_c01_w.nr_seq_contrato,'PJ','S');
				t_relatorio_3030_contratos_w.tx_reajute_princ		:= PLS_OBTER_TX_ULTIMO_REAJUSTE(r_c01_w.nr_seq_contrato,'PJ','S');
				t_relatorio_3030_contratos_w.ds_reajuste_princ		:= to_char(r_c01_w.dt_reajuste,'Month');
				t_relatorio_3030_contratos_w.ds_informacao_aux 		:= '026 - ' || r_c02_w.CD_OPERADORA_EMPRESA || ' - ' || substr(obter_nome_pf_pj('',r_c01_w.cd_cgc_estipulante),1,255);
				t_relatorio_3030_contratos_w.nr_seq_tabela_aux		:= r_c02_w.nr_seq_tabela;
				t_relatorio_3030_contratos_w.dt_reajute_aux		:= pls_obter_dt_ultimo_reajuste(r_c02_w.nr_seq_contrato,'PJ','S');
				t_relatorio_3030_contratos_w.tx_reajute_aux		:= PLS_OBTER_TX_ULTIMO_REAJUSTE(r_c02_w.nr_seq_contrato,'PJ','S');
				t_relatorio_3030_contratos_w.ds_reajuste_aux		:= to_char(r_c02_w.dt_reajuste,'Month');
				t_relatorio_3030_contratos_w.ds_pessoa_juridica		:= substr(obter_nome_pf_pj('',r_c01_w.cd_cgc_estipulante),1,255);
				RETURN NEXT t_relatorio_3030_contratos_w;
			end if;

			end;
		end loop;
		for r_c04_w in C04(r_c01_w.nr_seq_plano,r_c01_w.cd_cgc_estipulante,r_c01_w.nr_contrato) loop
			begin

			is_diferenca_valor_w	:= false;

			for r_c03_w in C03(r_c01_w.nr_seq_tabela) loop
				begin

				select	max(nr_sequencia)
				into STRICT	nr_seq_plano_preco_aux_w
				from	pls_plano_preco
				where	nr_seq_tabela		= r_c04_w.nr_seq_tabela
				and	qt_idade_inicial	= r_c03_w.qt_idade_inicial
				and	qt_idade_final		= r_c03_w.qt_idade_final;

				if (nr_seq_plano_preco_aux_w IS NOT NULL AND nr_seq_plano_preco_aux_w::text <> '') then
					select	vl_preco_atual
					into STRICT	vl_preco_atual_w
					from	pls_plano_preco
					where	nr_sequencia		= nr_seq_plano_preco_aux_w;

					if (vl_preco_atual_w <> r_c03_w.vl_preco_atual) then
						is_diferenca_valor_w := true;
						exit;
					end if;
				end if;
				end;
			end loop;

			if (is_diferenca_valor_w = true) then
				t_relatorio_3030_contratos_w.ds_informacao_princ 	:= '026 - ' || r_c01_w.CD_OPERADORA_EMPRESA || ' - ' || substr(obter_nome_pf_pj('',r_c01_w.cd_cgc_estipulante),1,255);
				t_relatorio_3030_contratos_w.nr_seq_tabela_prin		:= r_c01_w.nr_seq_tabela;
				t_relatorio_3030_contratos_w.dt_reajute_princ		:= pls_obter_dt_ultimo_reajuste(r_c01_w.nr_seq_contrato,'PJ','S');
				t_relatorio_3030_contratos_w.tx_reajute_princ		:= PLS_OBTER_TX_ULTIMO_REAJUSTE(r_c01_w.nr_seq_contrato,'PJ','S');
				t_relatorio_3030_contratos_w.ds_reajuste_princ		:= to_char(r_c01_w.dt_reajuste,'Month');
				t_relatorio_3030_contratos_w.ds_informacao_aux 		:= '026 - ' || r_c04_w.CD_OPERADORA_EMPRESA || ' - ' || substr(obter_nome_pf_pj('',r_c01_w.cd_cgc_estipulante),1,255);
				t_relatorio_3030_contratos_w.nr_seq_tabela_aux		:= r_c04_w.nr_seq_tabela;
				t_relatorio_3030_contratos_w.dt_reajute_aux		:= pls_obter_dt_ultimo_reajuste(r_c04_w.nr_seq_contrato,'PJ','S');
				t_relatorio_3030_contratos_w.tx_reajute_aux		:= PLS_OBTER_TX_ULTIMO_REAJUSTE(r_c04_w.nr_seq_contrato,'PJ','S');
				t_relatorio_3030_contratos_w.ds_reajuste_aux		:= to_char(r_c04_w.dt_reajuste,'Month');
				t_relatorio_3030_contratos_w.ds_pessoa_juridica		:= substr(obter_nome_pf_pj('',r_c01_w.cd_cgc_estipulante),1,255);
				RETURN NEXT t_relatorio_3030_contratos_w;
			end if;

			end;
		end loop;
		end;
	end loop;

	return;
	end;


$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION pls_relatorio_ops_pck.imprimir_relat_3030_contrato ( dt_inicio_p text, dt_fim_p text) FROM PUBLIC;