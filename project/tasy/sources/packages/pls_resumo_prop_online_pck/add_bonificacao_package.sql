-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';




CREATE OR REPLACE PROCEDURE pls_resumo_prop_online_pck.add_bonificacao ( nr_seq_proposta_online_p pls_proposta_online.nr_sequencia%type, nr_seq_benef_p pls_proposta_benef_online.nr_sequencia%type, qt_idade_p bigint, ie_tipo_benef_p text, nr_seq_parentesco_p bigint, vl_produto_p bigint) AS $body$
DECLARE


	vl_bonificacao_w	double precision;
	qt_vidas_w		bigint;
			
	C01 CURSOR(	nr_seq_proposta_online_pc	pls_proposta_online.nr_sequencia%type) FOR
		SELECT	b.nr_sequencia nr_seq_bonificacao,
			b.nm_bonificacao
		from	pls_bonificacao_vinculo a,
			pls_bonificacao b
		where	b.nr_sequencia			= a.nr_seq_bonificacao
		and	a.nr_seq_proposta_online	= nr_seq_proposta_online_pc;

	C02 CURSOR(	nr_seq_bonificacao_pc	pls_bonificacao.nr_sequencia%type,
			qt_idade_pc		bigint,
			ie_tipo_benef_pc	text,
			nr_seq_parentesco_pc	bigint) FOR
		SELECT	coalesce(a.tx_bonificacao,0) tx_bonificacao,
			coalesce(a.vl_bonificacao,0) vl_bonificacao
		from	pls_bonificacao_regra	a
		where	a.nr_seq_bonificacao	= nr_seq_bonificacao_pc
		and	pls_obter_item_mens('1', a.ie_tipo_item) = 'S'
		and	qt_idade_pc between coalesce(a.qt_idade_inicial, 0) and coalesce(a.qt_idade_final, qt_idade_pc)
		and	((a.ie_titularidade = 'A') or (a.ie_titularidade = ie_tipo_benef_pc))
		and	((a.nr_seq_parentesco = nr_seq_parentesco_pc) or (coalesce(a.nr_seq_parentesco::text, '') = ''));

	--Valor bonificação por regra de desconto
	C03 CURSOR(	nr_seq_bonificacao_pc	pls_bonificacao.nr_sequencia%type ) FOR
		SELECT	a.nr_seq_desconto,
			a.ie_tipo_segurado
		from	pls_bonificacao_regra	a,
			pls_bonificacao		b
		where	a.nr_seq_bonificacao	= b.nr_sequencia
		and	b.nr_sequencia		= nr_seq_bonificacao_pc
		and	a.ie_tipo_regra		= 'D'
		and	(a.nr_seq_desconto IS NOT NULL AND a.nr_seq_desconto::text <> '')
		and	pls_obter_item_mens(1,a.ie_tipo_item) = 'S';

	C04 CURSOR(	nr_seq_desconto_pc	bigint,
			qt_vidas_pc		bigint) FOR
		SELECT	coalesce(tx_desconto,0) tx_desconto,
			coalesce(vl_desconto,0) vl_desconto
		from	pls_preco_regra
		where	nr_seq_regra	= nr_seq_desconto_pc
		and	qt_vidas_pc between coalesce(qt_min_vidas,qt_vidas_pc) and coalesce(qt_max_vidas,qt_vidas_pc);

	
BEGIN

	for r_c01_w in C01(nr_seq_proposta_online_p) loop
		begin

		vl_bonificacao_w	:= 0;

		for r_c02_w in c02(	r_c01_w.nr_seq_bonificacao,
					qt_idade_p,
					ie_tipo_benef_p,
					nr_seq_parentesco_p) loop
			begin

			vl_bonificacao_w := vl_bonificacao_w + ((coalesce(r_c02_w.tx_bonificacao,0)/100) * coalesce(vl_produto_p,0)) + coalesce(r_c02_w.vl_bonificacao,0);	

			end;
		end loop;
		
		--Obter bonificação pela regra de desconto
		for r_c03_w in c03(	r_c01_w.nr_seq_bonificacao ) loop
			begin

			qt_vidas_w	:= 0;

			if (r_c03_w.ie_tipo_segurado = 'T') then --Todos
				qt_vidas_w	:= pls_resumo_prop_online_pck.obter_qt_vidas_proposta( nr_seq_proposta_online_p, 'A');
			elsif (r_c03_w.ie_tipo_segurado = 'E') then --Titular mais dependentes legais
				qt_vidas_w	:= pls_resumo_prop_online_pck.obter_qt_vidas_proposta( nr_seq_proposta_online_p, 'TD');
			end if;

			for r_c04_w in C04( r_c03_w.nr_seq_desconto, qt_vidas_w ) loop
				begin
				vl_bonificacao_w	:= vl_bonificacao_w + (((coalesce(r_c04_w.tx_desconto,0) /100) * coalesce( vl_produto_p,0)) + coalesce(r_c04_w.vl_desconto,0));
				end;
			end loop;
			end;
		end loop;
		
		
		if (vl_bonificacao_w <> 0) then
			CALL CALL pls_resumo_prop_online_pck.add_item(r_c01_w.nm_bonificacao, vl_bonificacao_w * -1, nr_seq_benef_p, '14');
		end if;

		end;
	end loop;
	end;


$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE pls_resumo_prop_online_pck.add_bonificacao ( nr_seq_proposta_online_p pls_proposta_online.nr_sequencia%type, nr_seq_benef_p pls_proposta_benef_online.nr_sequencia%type, qt_idade_p bigint, ie_tipo_benef_p text, nr_seq_parentesco_p bigint, vl_produto_p bigint) FROM PUBLIC;
