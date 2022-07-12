-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';

	
	-->>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>> Valor consumido pelo fornecedor em notas fiscais  <<<<<<<<<<<<<<<<<<<<<<<<<<<--	
	/*
	Objetivo: Retornar o valor consumido pelo fornecedor em notas fiscais vinculadas ao contrato.
	Parametros: 
	nr_seq_contrato_p   = Numero de sequencia do contrato.
	cd_cgc_fornecedor_p = CNPJ do fornecedor.
	*/
CREATE OR REPLACE FUNCTION gerenciamento_contrato_pck.obter_vl_notas_fornecedor (nr_seq_contrato_p bigint, cd_cgc_fornecedor_p bigint) RETURNS bigint AS $body$
DECLARE

									
		vl_nota_fiscal_w 		contrato_gerenciamento.vl_nota_fiscal%type;
		qt_nota_fiscal_item_w	contrato_gerenciamento.qt_nota_fiscal_item%type;
		ie_pagar_receber_w	    contrato.ie_pagar_receber%type;
									
		c01 CURSOR(nr_seq_contrato_c bigint, cd_cgc_fornecedor_c bigint, ie_pagar_receber_c text) FOR
			SELECT a.nr_sequencia nr_seq_nf
			  from nota_fiscal a,
				operacao_nota b
			 where a.ie_situacao = 1
			   and (a.dt_atualizacao_estoque IS NOT NULL AND a.dt_atualizacao_estoque::text <> '')
			   and a.cd_operacao_nf = b.cd_operacao_nf
			   and coalesce(a.cd_pessoa_fisica, a.cd_cgc) = cd_cgc_fornecedor_c
			   and b.ie_operacao_fiscal = CASE WHEN ie_pagar_receber_c='R' THEN  'S'  ELSE 'E' END
			   and exists (SELECT 	1 
							 from nota_fiscal_item b
							where a.nr_sequencia = b.nr_sequencia
							  and b.nr_contrato = nr_seq_contrato_c);

		
BEGIN
			select coalesce(gerenciamento_contrato_pck.obter_tipo_contrato(nr_seq_contrato_p), 'P')
			  into STRICT ie_pagar_receber_w
			;
			
			vl_nota_fiscal_w      := 0;
			qt_nota_fiscal_item_w := 0;
			
			For r01 in c01(nr_seq_contrato_p, cd_cgc_fornecedor_p, ie_pagar_receber_w) loop
				
				vl_nota_fiscal_w := vl_nota_fiscal_w + gerenciamento_contrato_pck.obter_qt_vl_item_nf(nr_seq_contrato_p, r01.nr_seq_nf, 'VL');

			end loop;
		

		return vl_nota_fiscal_w;

																
	END;

$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON FUNCTION gerenciamento_contrato_pck.obter_vl_notas_fornecedor (nr_seq_contrato_p bigint, cd_cgc_fornecedor_p bigint) FROM PUBLIC;