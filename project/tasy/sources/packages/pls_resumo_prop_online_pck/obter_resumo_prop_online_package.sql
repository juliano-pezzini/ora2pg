-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';




CREATE OR REPLACE FUNCTION pls_resumo_prop_online_pck.obter_resumo_prop_online ( nr_seq_proposta_online_p pls_proposta_online.nr_sequencia%type, nr_seq_proposta_benef_p pls_proposta_benef_online.nr_sequencia%type, ie_html_p text) RETURNS SETOF T_ITEM AS $body$
DECLARE


	line_w				t_item_row;

	vl_produto_w			double precision;
	nr_seq_plano_w			pls_plano.nr_sequencia%type;
	nr_seq_tabela_w			pls_tabela_preco.nr_sequencia%type;
	ie_preco_vidas_contrato_w	pls_tabela_preco.ie_preco_vidas_contrato%type;
	ie_calculo_vidas_w		pls_tabela_preco.ie_calculo_vidas%type;
	qt_vidas_w			bigint;
	dt_vigencia_prev_w		pls_proposta_online.dt_vigencia_prev%type;
	ie_estagio_w			pls_proposta_online.ie_estagio%type;
	
	C01 CURSOR(	nr_seq_proposta_online_p	pls_proposta_online.nr_sequencia%type,
			nr_seq_proposta_benef_p		pls_proposta_benef_online.nr_sequencia%type) FOR
		SELECT	nr_sequencia,
			nr_seq_parentesco,
			ie_tipo_benef,
			obter_idade(dt_nascimento, coalesce(dt_vigencia_prev_w, clock_timestamp()), 'A') qt_idade,
			nm_pessoa_fisica
		from	pls_proposta_benef_online
		where	nr_seq_prop_online = nr_seq_proposta_online_p
		and	coalesce(nr_seq_proposta_benef_p::text, '') = ''
		and	ie_tipo_benef <> 'R'
		
union

		SELECT	nr_sequencia,
			nr_seq_parentesco,
			ie_tipo_benef,
			obter_idade(dt_nascimento, coalesce(dt_vigencia_prev_w, clock_timestamp()), 'A') qt_idade,
			nm_pessoa_fisica
		from	pls_proposta_benef_online
		where	nr_sequencia = nr_seq_proposta_benef_p
		and	ie_tipo_benef <> 'R';

	C02 CURSOR(	nr_seq_proposta_online_pc	pls_proposta_online.nr_sequencia%type) FOR
		SELECT	ds_item,
			nr_seq_benef_proposta,
			vl_item,
			ie_total,
			ie_tipo_item
		from	pls_proposta_online_resumo
		where	nr_seq_proposta = nr_seq_proposta_online_pc;
		
	
BEGIN
	CALL CALL pls_resumo_prop_online_pck.limpar_vetor_item();

	select	nr_seq_plano,
		nr_seq_tabela,
		dt_vigencia_prev,
		ie_estagio
	into STRICT	nr_seq_plano_w,
		nr_seq_tabela_w,
		dt_vigencia_prev_w,
		ie_estagio_w
	from	pls_proposta_online
	where	nr_sequencia = nr_seq_proposta_online_p;

	if (ie_estagio_w not in ('PS')) then
		for r_c02_w in c02(nr_seq_proposta_online_p) loop
			begin
			line_w.ds_item			:= r_c02_w.ds_item;
			line_w.vl_item			:= r_c02_w.vl_item;
			line_w.ie_total			:= r_c02_w.ie_total;
			line_w.nr_seq_benef_proposta	:= r_c02_w.nr_seq_benef_proposta;
			line_w.ie_tipo_item		:= r_c02_w.ie_tipo_item;
			RETURN NEXT line_w;
			end;
		end loop;
	else
		begin
		select	coalesce(ie_preco_vidas_contrato,'N'),
			coalesce(ie_calculo_vidas,'A')
		into STRICT	ie_preco_vidas_contrato_w,
			ie_calculo_vidas_w
		from	pls_tabela_preco
		where	nr_sequencia = nr_seq_tabela_w;
		exception
		when others then
			ie_preco_vidas_contrato_w	:= 'N';
			ie_calculo_vidas_w		:= 'A';
		end;

		if (ie_preco_vidas_contrato_w = 'S') then
			qt_vidas_w	:= pls_resumo_prop_online_pck.obter_qt_vidas_proposta(nr_seq_proposta_online_p, ie_calculo_vidas_w);
		else
			qt_vidas_w	:= 0;
		end if;

		for r_c01_w in c01(nr_seq_proposta_online_p, nr_seq_proposta_benef_p) loop
			begin
			select	max(vl_preco_atual)
			into STRICT	vl_produto_w
			from	pls_plano_preco
			where	nr_seq_tabela = nr_seq_tabela_w
			and	r_c01_w.qt_idade between qt_idade_inicial and qt_idade_final
			and	((substr(ie_grau_titularidade,1,1) = r_c01_w.ie_tipo_benef) or (coalesce(ie_grau_titularidade::text, '') = ''))
			and	((ie_preco_vidas_contrato_w = 'S' and
				  qt_vidas_w between coalesce(qt_vidas_inicial, qt_vidas_w) and coalesce(qt_vidas_final, qt_vidas_w)) or (ie_preco_vidas_contrato_w = 'N'));
				
			CALL CALL pls_resumo_prop_online_pck.add_item('Preço pré-estabelecido', vl_produto_w, r_c01_w.nr_sequencia, '1');

			CALL CALL pls_resumo_prop_online_pck.add_taxa_inscricao(r_c01_w.nr_sequencia, nr_seq_plano_w, r_c01_w.ie_tipo_benef, vl_produto_w);

			CALL CALL pls_resumo_prop_online_pck.add_bonificacao(nr_seq_proposta_online_p, r_c01_w.nr_sequencia, r_c01_w.qt_idade,
					r_c01_w.ie_tipo_benef, r_c01_w.nr_seq_parentesco, vl_produto_w);
					
			CALL CALL pls_resumo_prop_online_pck.add_sca(nr_seq_proposta_online_p, r_c01_w.nr_sequencia, r_c01_w.qt_idade,
					r_c01_w.ie_tipo_benef);

			line_w.ds_item			:= r_c01_w.nm_pessoa_fisica;
			line_w.vl_item			:= current_setting('pls_resumo_prop_online_pck.vl_item_w')::double;
			line_w.ie_total			:= 'S';
			line_w.nr_seq_benef_proposta	:= r_c01_w.nr_sequencia;
			line_w.ie_tipo_item		:= null;
			RETURN NEXT line_w;

			if (current_setting('pls_resumo_prop_online_pck.tb_ds_item_w')::pls_util_cta_pck.t_varchar2_table_255.count > 0) then
				for i in current_setting('pls_resumo_prop_online_pck.tb_ds_item_w')::pls_util_cta_pck.t_varchar2_table_255.first..tb_ds_item_w.last loop
					begin
					line_w.ds_item			:= current_setting('pls_resumo_prop_online_pck.tb_ds_item_w')::pls_util_cta_pck.t_varchar2_table_255(i);
					line_w.vl_item			:= current_setting('pls_resumo_prop_online_pck.tb_vl_item_w')::pls_util_cta_pck.t_number_table(i);
					line_w.ie_total			:= 'N';
					line_w.nr_seq_benef_proposta	:= current_setting('pls_resumo_prop_online_pck.tb_nr_seq_benef_w')::pls_util_cta_pck.t_number_table(i);
					line_w.ie_tipo_item		:= current_setting('pls_resumo_prop_online_pck.tb_ie_tipo_item_w')::pls_util_cta_pck.t_number_table(i);
					RETURN NEXT line_w;
					end;
				end loop;
			end if;
			CALL CALL pls_resumo_prop_online_pck.limpar_vetor_item();

			end;
		end loop;
	end if;

	return;

	END;

$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON FUNCTION pls_resumo_prop_online_pck.obter_resumo_prop_online ( nr_seq_proposta_online_p pls_proposta_online.nr_sequencia%type, nr_seq_proposta_benef_p pls_proposta_benef_online.nr_sequencia%type, ie_html_p text) FROM PUBLIC;