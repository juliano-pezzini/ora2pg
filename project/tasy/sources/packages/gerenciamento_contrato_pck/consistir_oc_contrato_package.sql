-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';

	
	-->>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>> Consistir ordem de compra do contrato <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<--	
	/*
	Objetivo: Consistir a liberacao da ordem de compra caso o contrato nao tenha saldo suficiente para atender essa ordem.
	Parametros: 
	nr_ordem_compra_p = Numero da ordem de compra.
	nm_usuario_p = Nome do usuario.
	*/
CREATE OR REPLACE PROCEDURE gerenciamento_contrato_pck.consistir_oc_contrato (nr_ordem_compra_p bigint, nm_usuario_p text) AS $body$
DECLARE

	
	ie_consiste_saldo_contrato_w  parametro_compras.ie_cons_saldo_contrato%type;
	vl_total_ordem_w		      double precision := 0;
	nr_item_solic_compra_des_w	  solic_compra_item.nr_item_solic_compra%type;
	nr_solic_compra_desc_w		  solic_compra.nr_solic_compra%type;
	vl_desconsiderar_solic_w	  contrato_gerenciamento.vl_comprometido%type;
	qt_material_ordem_desc_w	  ordem_compra_item.qt_material%type;
	qt_material_solic_desc_w	  solic_compra_item.qt_material%type;
	vl_comprometido_w		      contrato_gerenciamento.vl_comprometido%type;
	ie_considera_vl_compr_saldo_w varchar(1) := 'N';
	vl_saldo_contrato_w			  contrato_gerenciamento.vl_saldo%type;
	cd_moeda_contrato_w			  moeda.cd_moeda%type;
	qt_total_ordem_w			  ordem_compra_item.qt_material%type;
	qt_saldo_contrato_w			  contrato_gerenciamento.qt_itens_restante%type;
	qt_comprometido_w			  contrato_gerenciamento.qt_itens_restante%type;
	
	c01 CURSOR(nr_ordem_compra_c bigint) FOR
		SELECT nr_contrato			
		  from ordem_compra_item
		 where nr_ordem_compra = nr_ordem_compra_c
		   and (nr_contrato IS NOT NULL AND nr_contrato::text <> '')
		 group by nr_contrato;
	
	c02 CURSOR(nr_ordem_compra_c bigint, nr_seq_contrato_c bigint) FOR
		SELECT nr_item_solic_compra,
			   nr_solic_compra,
			   qt_material
	      from ordem_compra_item
		 where nr_ordem_compra = nr_ordem_compra_c
		   and nr_contrato = nr_seq_contrato_c
		   and	nr_solic_compra > 0;
	
	c03 CURSOR(nr_ordem_compra_c bigint) FOR
		SELECT nr_contrato,
			   nr_seq_regra_contrato
		  from ordem_compra_item
		 where nr_ordem_compra = nr_ordem_compra_c
		   and (nr_contrato IS NOT NULL AND nr_contrato::text <> '')
		 group by nr_contrato, nr_seq_regra_contrato;
		
	c04 CURSOR(nr_ordem_compra_c bigint, nr_seq_contrato_c bigint, nr_seq_regra_contrato_c bigint) FOR
		SELECT nr_item_solic_compra,
			   nr_solic_compra,
			   qt_material
	      from ordem_compra_item
		 where nr_ordem_compra = nr_ordem_compra_c
		   and nr_contrato = nr_seq_contrato_c
		   and coalesce(nr_seq_regra_contrato,0) = coalesce(nr_seq_regra_contrato_c,0)
		   and	nr_solic_compra > 0;
		
	
BEGIN	
	
	delete 
	  from ordem_compra_consist
	 where nr_ordem_compra = nr_ordem_compra_p
	   and ie_tipo_consistencia = 20;
	
	select CASE WHEN gerenciamento_contrato_pck.obter_param_consiste_saldo()='B' THEN  'C' WHEN gerenciamento_contrato_pck.obter_param_consiste_saldo()='A' THEN  'M'  ELSE 'N' END
		  into STRICT ie_consiste_saldo_contrato_w
		;
	
	if (ie_consiste_saldo_contrato_w = 'C' or ie_consiste_saldo_contrato_w = 'M') then
		
		begin
		
		/* Consistir valor total do contrato */
		
		For r01 in c01(nr_ordem_compra_p) loop
			
			cd_moeda_contrato_w := gerenciamento_contrato_pck.obter_moeda_contrato(r01.nr_contrato);
			
			vl_saldo_contrato_w := gerenciamento_contrato_pck.obter_valor_saldo(r01.nr_contrato, 'S');
			
			/* Obter o valor total da ordem de compra sendo liberada */

			select coalesce(sum(gerenciamento_contrato_pck.obter_valor_moeda_convertido(r01.nr_contrato, cd_moeda_contrato_w, a.cd_moeda, gerenciamento_contrato_pck.obter_qt_vl_ordem_contrato(a.nr_ordem_compra, r01.nr_contrato, 'VL'))),0)
			  into STRICT vl_total_ordem_w
			  from ordem_compra a
			 where coalesce(a.nr_seq_motivo_cancel::text, '') = ''
			   and a.nr_ordem_compra = nr_ordem_compra_p
			   and exists (SELECT 1
					        from ordem_compra_item b
					       where a.nr_ordem_compra = b.nr_ordem_compra
					         and b.nr_contrato = r01.nr_contrato);
			
			vl_comprometido_w := 0;
			
			For r02 in c02(nr_ordem_compra_p, r01.nr_contrato) loop
			
				begin
					select b.vl_unit_previsto,
						   b.qt_material
					  into STRICT vl_desconsiderar_solic_w,
						   qt_material_solic_desc_w
					  from solic_compra a,
						   solic_compra_item b
					 where a.nr_solic_compra = b.nr_solic_compra
					   and a.nr_solic_compra = r02.nr_solic_compra
					   and b.nr_item_solic_compra = r02.nr_item_solic_compra
					   and b.nr_contrato = r01.nr_contrato;
				exception when others then
					vl_desconsiderar_solic_w := 0;
					qt_material_solic_desc_w := 0;
				end;
				
				if (r02.qt_material < qt_material_solic_desc_w) then
					vl_comprometido_w   :=  vl_comprometido_w + (vl_desconsiderar_solic_w * (qt_material_solic_desc_w - r02.qt_material));
				else
					vl_comprometido_w :=  vl_comprometido_w + (vl_desconsiderar_solic_w * qt_material_solic_desc_w);
				end if;
			
			end loop;
			
			if (gerenciamento_contrato_pck.obter_valor_total(r01.nr_contrato, 'S') > 0 and ((vl_saldo_contrato_w + vl_comprometido_w) < vl_total_ordem_w)) then
				
				CALL gravar_ordem_compra_consist(nr_ordem_compra_p,
											'20',
											wheb_mensagem_pck.get_texto(1082502, 'NR_CONTRATO='|| r01.nr_contrato) || CHR(10) ||
											wheb_mensagem_pck.get_texto(1082838,
											'VL_SALDO_W='|| campo_mascara_virgula_casas(vl_saldo_contrato_w + vl_comprometido_w,4) ||						
											';VL_TRANSACAO_W='|| campo_mascara_virgula_casas(vl_total_ordem_w,4)),
											ie_consiste_saldo_contrato_w,
											'',
											nm_usuario_p);

			end if;
		end loop;
		
		/* Consistir quantidade dos itens do contrato */

		For r03 in c03(nr_ordem_compra_p) loop
		
			qt_comprometido_w := 0;
			
			select coalesce(sum(qt_material),0)
			  into STRICT qt_total_ordem_w
			  from ordem_compra_item
			 where nr_ordem_compra = nr_ordem_compra_p
			   and coalesce(dt_reprovacao::text, '') = ''
			   and nr_contrato = r03.nr_contrato
			   and (coalesce(nr_seq_regra_contrato::text, '') = '' or ((nr_seq_regra_contrato IS NOT NULL AND nr_seq_regra_contrato::text <> '') and nr_seq_regra_contrato = r03.nr_seq_regra_contrato));
			
			For r04 in c04(nr_ordem_compra_p, r03.nr_contrato, r03.nr_seq_regra_contrato) loop
				
				Begin
					select b.qt_material
					  into STRICT qt_material_solic_desc_w
					  from solic_compra a,
						   solic_compra_item b
					 where a.nr_solic_compra = b.nr_solic_compra
					   and a.nr_solic_compra = r04.nr_solic_compra
					   and b.nr_item_solic_compra = r04.nr_item_solic_compra
					   and b.nr_contrato = r03.nr_contrato;
				exception when others then
					qt_material_solic_desc_w := 0;
				end;

				if (r04.qt_material < qt_material_solic_desc_w) then
					qt_comprometido_w   :=  qt_comprometido_w + r04.qt_material;
				else
					qt_comprometido_w   :=  qt_comprometido_w + qt_material_solic_desc_w;
				end if;

			end loop;
			
			qt_saldo_contrato_w := gerenciamento_contrato_pck.obter_qt_restante(r03.nr_contrato, 'S', r03.nr_seq_regra_contrato);
			
			if (gerenciamento_contrato_pck.obter_qt_fixa_item_contrato(r03.nr_contrato, r03.nr_seq_regra_contrato) > 0 and
				 ((qt_saldo_contrato_w + qt_comprometido_w) < qt_total_ordem_w)) then

				/* Grava consistencia dos itens de contrato */

				CALL gravar_ordem_compra_consist(nr_ordem_compra_p,
											'20',
											wheb_mensagem_pck.get_texto(1082502, 'NR_CONTRATO='|| r03.nr_contrato) || CHR(10) ||
											wheb_mensagem_pck.get_texto(1121703,
											'NR_SEQ_ITEM='|| r03.nr_seq_regra_contrato ||						
											';QT_SALDO_W='|| campo_mascara_virgula_casas(qt_saldo_contrato_w + qt_comprometido_w,4) ||						
											';QT_TRANSACAO_W='|| campo_mascara_virgula_casas(qt_total_ordem_w,4)),
											ie_consiste_saldo_contrato_w,
											'',
											nm_usuario_p);

			end if;
			
		end loop;
		
		end;
					
	end if;
						
	END;

$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE gerenciamento_contrato_pck.consistir_oc_contrato (nr_ordem_compra_p bigint, nm_usuario_p text) FROM PUBLIC;