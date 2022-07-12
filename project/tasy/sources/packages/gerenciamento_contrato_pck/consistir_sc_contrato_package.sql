-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';

	
	-->>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>++++++ CONSISTeNCIAS EM TRANSAcoES ++++++<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<--
		
	-->>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>> Consistir solicitacao de compra do contrato <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<--
	/*
	Objetivo: Ao liberar uma solicitacao de compra com itens vinculados ao contrato, e necessario validar se o contrato possui	
		      saldo o suficiente para atendimento.
			  Esta function ira consistir o valor total, inserindo consistencia na tabela solic_compra_consist.
	Parametros: 
	nr_solic_compra_p = Numero da solicitacao de compra.
	nm_usuario_p      = Usuario realizando a acao.
	*/
CREATE OR REPLACE PROCEDURE gerenciamento_contrato_pck.consistir_sc_contrato (nr_solic_compra_p bigint, nm_usuario_p text ) AS $body$
DECLARE

		
		ie_consiste_saldo_contrato_w parametro_compras.ie_cons_saldo_contrato%type;
		vl_solic_compra_item_w	     solic_compra_item.vl_unit_previsto%type;
		qt_solic_compra_item_w		 solic_compra_item.qt_material%type;
	
		c01 CURSOR(nr_solic_compra_c bigint) FOR
			SELECT nr_contrato
	          from solic_compra_item
	         where nr_solic_compra = nr_solic_compra_c
	           and (nr_contrato IS NOT NULL AND nr_contrato::text <> '')
	         group by nr_contrato;
		
		c02 CURSOR(nr_solic_compra_c bigint) FOR
			SELECT nr_contrato, nr_seq_regra_contrato
	          from solic_compra_item
	         where nr_solic_compra = nr_solic_compra_c
	           and (nr_contrato IS NOT NULL AND nr_contrato::text <> '')
	         group by nr_contrato, nr_seq_regra_contrato;
		
		
BEGIN

		vl_solic_compra_item_w := 0;
		
		delete
		  from solic_compra_consist
		 where nr_solic_compra = nr_solic_compra_p
		   and ie_tipo_consistencia = '3';
		
		select CASE WHEN gerenciamento_contrato_pck.obter_param_consiste_saldo()='B' THEN  'C' WHEN gerenciamento_contrato_pck.obter_param_consiste_saldo()='A' THEN  'M'  ELSE 'N' END
		  into STRICT ie_consiste_saldo_contrato_w
		;
		
		if (ie_consiste_saldo_contrato_w = 'C' or ie_consiste_saldo_contrato_w = 'M') then
		
		
			/* Consiste valor total contrato */

			For r01 in c01(nr_solic_compra_p) loop
			
				/* Obter o valor total da solicitacao sendo liberada */

				select coalesce(sum(b.qt_material * b.vl_unit_previsto),0)
				  into STRICT vl_solic_compra_item_w
				  from	solic_compra a,
					    solic_compra_item b
				 where	a.nr_solic_compra = b.nr_solic_compra
				   and	b.nr_contrato = r01.nr_contrato
				   and	a.nr_solic_compra = nr_solic_compra_p
				   and	b.vl_unit_previsto > 0
				   and coalesce(b.dt_reprovacao::text, '') = '';	
			
				if (gerenciamento_contrato_pck.obter_valor_total(r01.nr_contrato, 'S') > 0 and
                   gerenciamento_contrato_pck.obter_valor_saldo(r01.nr_contrato, 'S') < vl_solic_compra_item_w) then
					
					CALL gravar_solic_compra_consist(nr_solic_compra_p, '3',
												wheb_mensagem_pck.get_texto(1082502, 'NR_CONTRATO='|| r01.nr_contrato),
											    ie_consiste_saldo_contrato_w,
												wheb_mensagem_pck.get_texto(1082838,
												'VL_SALDO_W='|| campo_mascara_virgula_casas(gerenciamento_contrato_pck.obter_valor_saldo(r01.nr_contrato, 'S'),4) ||						
												';VL_TRANSACAO_W='|| campo_mascara_virgula_casas(vl_solic_compra_item_w,4)),
												nm_usuario_p);
		
				
				end if;
			
			end loop;
			
			/* Consistir quantidade dos itens de contrato */

			For r02 in c02(nr_solic_compra_p) loop
			
				/* Obter o valor total da solicitacao sendo liberada */

				select coalesce(sum(b.qt_material),0)
				  into STRICT qt_solic_compra_item_w
				  from	solic_compra a,
					    solic_compra_item b
				 where	a.nr_solic_compra = b.nr_solic_compra
				   and	b.nr_contrato = r02.nr_contrato
				   and	a.nr_solic_compra = nr_solic_compra_p
				   and (coalesce(b.nr_seq_regra_contrato::text, '') = '' or ((b.nr_seq_regra_contrato IS NOT NULL AND b.nr_seq_regra_contrato::text <> '') and b.nr_seq_regra_contrato = r02.nr_seq_regra_contrato))
				   and	b.vl_unit_previsto > 0
				   and coalesce(b.dt_reprovacao::text, '') = '';
				
				if (gerenciamento_contrato_pck.obter_qt_fixa_item_contrato(r02.nr_contrato, r02.nr_seq_regra_contrato) > 0 and
					gerenciamento_contrato_pck.obter_qt_restante(r02.nr_contrato, 'S', r02.nr_seq_regra_contrato) < qt_solic_compra_item_w) then
					
					/* Grava mensagem da quantidade de cada item */

					CALL gravar_solic_compra_consist(nr_solic_compra_p, '3',
												wheb_mensagem_pck.get_texto(1082502, 'NR_CONTRATO='|| r02.nr_contrato),
											    ie_consiste_saldo_contrato_w, 
												wheb_mensagem_pck.get_texto(1121703,
												'NR_SEQ_ITEM='|| r02.nr_seq_regra_contrato ||						
												';QT_SALDO_W='|| campo_mascara_virgula_casas(gerenciamento_contrato_pck.obter_qt_restante(r02.nr_contrato, 'S', r02.nr_seq_regra_contrato),4) ||						
												';QT_TRANSACAO_W='|| campo_mascara_virgula_casas(qt_solic_compra_item_w, 4)),
												nm_usuario_p);
					
				end if;
			
			end loop;
		
		end if;
			 		
	END;

$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE gerenciamento_contrato_pck.consistir_sc_contrato (nr_solic_compra_p bigint, nm_usuario_p text ) FROM PUBLIC;
