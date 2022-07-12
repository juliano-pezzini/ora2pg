-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';


	-->>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>> Quantidade/Valor do item da nota fiscal <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<--
	/*
	Objetivo: Retornar o valor realizado da nota fiscal emitida para o contrato.
	Parametros: 
	nr_seq_contrato_p    = Numero de sequencia do contrato.
	nr_seq_nota_fiscal_p = Numero de sequencia da nota fiscal.
	ie_qt_vl_p           = Quando passado 'QT': Ira retornar a quantidade total dos itens da nota vinculados ao contrato.
	                       Quando passado 'VL': Ira retornar o valor total dos itens da nota vinculados ao contrato.
	*/
CREATE OR REPLACE FUNCTION gerenciamento_contrato_pck.obter_qt_vl_item_nf (nr_seq_contrato_p bigint, nr_seq_nota_fiscal_p bigint, ie_qt_vl_p text, nr_seq_regra_contrato_p bigint default null) RETURNS bigint AS $body$
DECLARE

	
	vl_total_nf_w			nota_fiscal_item.vl_liquido%type;
	ie_considerar_trib_saldo_w 	projeto_recurso.ie_considerar_trib_saldo%type;
	qt_total_item_nf		nota_fiscal_item.qt_item_nf%type;
	cd_moeda_contrato_w		moeda.cd_moeda%type;
	
	
BEGIN
	
	cd_moeda_contrato_w := gerenciamento_contrato_pck.obter_moeda_contrato(nr_seq_contrato_p);
	
	vl_total_nf_w := 0;
		
		select  round((coalesce(sum(gerenciamento_contrato_pck.obter_valor_moeda_convertido(nr_seq_contrato_p, cd_moeda_contrato_w, a.cd_moeda, b.vl_liquido)),0))::numeric,2) - coalesce(sum(gerenciamento_contrato_pck.obter_valor_moeda_convertido(nr_seq_contrato_p, cd_moeda_contrato_w, a.cd_moeda, gerenciamento_contrato_pck.obter_vl_total_trib_nf(nr_seq_nota_fiscal_p,b.nr_item_nf))),0),
		       sum(b.qt_item_nf)
		  into STRICT vl_total_nf_w,
			   qt_total_item_nf
		  from nota_fiscal a,
			   nota_fiscal_item b
		 where a.nr_sequencia = b.nr_sequencia
		   and a.nr_sequencia = nr_seq_nota_fiscal_p
		   and b.nr_contrato = nr_seq_contrato_p
		   and (((nr_seq_regra_contrato_p IS NOT NULL AND nr_seq_regra_contrato_p::text <> '') and nr_seq_regra_contrato_p > 0 and b.nr_seq_regra_contrato = nr_seq_regra_contrato_p) or coalesce(nr_seq_regra_contrato_p::text, '') = '')
		   and a.ie_situacao = 1
		   and (a.dt_atualizacao_estoque IS NOT NULL AND a.dt_atualizacao_estoque::text <> '');
	
	if (ie_qt_vl_p = 'QT') then
		return qt_total_item_nf;
	else
		return	vl_total_nf_w;
	end if;
	
	END;

$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON FUNCTION gerenciamento_contrato_pck.obter_qt_vl_item_nf (nr_seq_contrato_p bigint, nr_seq_nota_fiscal_p bigint, ie_qt_vl_p text, nr_seq_regra_contrato_p bigint default null) FROM PUBLIC;