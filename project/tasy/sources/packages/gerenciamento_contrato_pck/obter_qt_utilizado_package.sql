-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';

	
	-->>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>> Obter quantidade total de itens utilizados do contrato <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<--
	/*
	Objetivo: Retornar a quantidade de itens utilizados do contrato passado por parametro.
			  Este se trata do valor total de itens em solicitacoes, ordens de compra e notas fiscais.
	Parametros: 
	nr_seq_contrato_p = Numero de sequencia do contrato.
	ie_atual_p        = Quando 'S': Ira verificar a quantidade atual utilizada de itens do contrato.
					    Quando 'N': Ira retornar o valor de acordo com o ultimo gerenciamento de saldo do contrato existente na tabela "contrato_gerenciamento".
	*/
CREATE OR REPLACE FUNCTION gerenciamento_contrato_pck.obter_qt_utilizado (nr_seq_contrato_p bigint, ie_atual_p text, nr_seq_regra_contrato_p bigint default null) RETURNS bigint AS $body$
DECLARE

				
		qt_utilizado_w 	contrato_gerenciamento.qt_itens_utilizado%type;
		
		
BEGIN
		
		qt_utilizado_w := 0;
		
		if (ie_atual_p = 'N') then
			begin
				select a.qt_itens_utilizado
				  into STRICT qt_utilizado_w
				  from contrato_gerenciamento a
				 where a.nr_seq_contrato = nr_seq_contrato_p
				   and a.dt_atualizacao = (SELECT max(b.dt_atualizacao)
											 from contrato_gerenciamento b
											where b.nr_seq_contrato = a.nr_seq_contrato);
			end;
		else
			begin
				/* Quantidade de itens utilizados em solicitacoes de compra */

				qt_utilizado_w := qt_utilizado_w + gerenciamento_contrato_pck.obter_qt_vl_item_solic(nr_seq_contrato_p, 'QT', 'S', nr_seq_regra_contrato_p);
						
				/* Quantidade de itens utilizados em ordens de compra */
	
				qt_utilizado_w := qt_utilizado_w + gerenciamento_contrato_pck.obter_qt_vl_item_ordens(nr_seq_contrato_p, 'QT', 'S', nr_seq_regra_contrato_p);
				
				/* Quantidade de itens utilizados em notas fiscais */

				qt_utilizado_w := qt_utilizado_w + gerenciamento_contrato_pck.obter_qt_vl_item_notas(nr_seq_contrato_p, 'QT', 'S', nr_seq_regra_contrato_p);
				
			end;
		end if;
		
		return qt_utilizado_w;
					
		END;

$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON FUNCTION gerenciamento_contrato_pck.obter_qt_utilizado (nr_seq_contrato_p bigint, ie_atual_p text, nr_seq_regra_contrato_p bigint default null) FROM PUBLIC;