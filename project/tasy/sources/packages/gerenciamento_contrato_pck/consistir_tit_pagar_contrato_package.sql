-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';

	
	-->>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>> Consistir titulo a pagar vinculado ao contrato <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<--		
	/*
	Objetivo: Consistir a criacao de um titulo a pagar caso o contrato nao tenha saldo suficiente para atender esse titulo.
	Parametros: 
	nr_seq_contrato_p = Numero de sequencia do contrato.
	vl_saldo_titulo_p = Valor de saldo do titulo a pagar.
	nm_usuario_p = Nome do usuario.
	*/
CREATE OR REPLACE PROCEDURE gerenciamento_contrato_pck.consistir_tit_pagar_contrato (nr_seq_contrato_p bigint, nr_titulo_p bigint default 0, vl_saldo_titulo_p bigint DEFAULT NULL, nm_usuario_p text DEFAULT NULL, ie_atualizacao_saldo_p text default null) AS $body$
DECLARE

	
	ie_consiste_saldo_contrato_w 	      parametro_compras.ie_cons_saldo_contrato%type;
	
	vl_saldo_titulo_anterior_w	titulo_pagar.vl_titulo%type;
	vl_titulo_w	titulo_pagar.vl_titulo%type;
	vl_considerar_titulo_w titulo_pagar.vl_titulo%type;
	vl_saldo_contrato_w contrato_gerenciamento.vl_saldo%type;
	cd_moeda_contrato_w	moeda.cd_moeda%type;
	cd_moeda_titulo_w	moeda.cd_moeda%type;
		
	
BEGIN
	
		select CASE WHEN gerenciamento_contrato_pck.obter_param_consiste_saldo()='B' THEN  'C' WHEN gerenciamento_contrato_pck.obter_param_consiste_saldo()='A' THEN  'M'  ELSE 'N' END
		  into STRICT ie_consiste_saldo_contrato_w
	;
		
		select	coalesce(max(vl_titulo),0),
				max(cd_moeda)
	      into STRICT	vl_saldo_titulo_anterior_w,
				cd_moeda_titulo_w
	      from	titulo_pagar
	     where	nr_titulo = nr_titulo_p;
	
		if (ie_consiste_saldo_contrato_w in ('C', 'M')) then
		
			if (nr_seq_contrato_p > 0) then
			
				cd_moeda_contrato_w := gerenciamento_contrato_pck.obter_moeda_contrato(nr_seq_contrato_p);
				
				vl_saldo_titulo_anterior_w := gerenciamento_contrato_pck.obter_valor_moeda_convertido(nr_seq_contrato_p, cd_moeda_contrato_w, coalesce(cd_moeda_titulo_w,cd_moeda_contrato_w), vl_saldo_titulo_anterior_w);
			
				if (ie_atualizacao_saldo_p = 'S') then
					vl_saldo_contrato_w := vl_saldo_titulo_anterior_w + gerenciamento_contrato_pck.obter_valor_saldo(nr_seq_contrato_p, 'S');
				else
					vl_saldo_contrato_w := gerenciamento_contrato_pck.obter_valor_saldo(nr_seq_contrato_p, 'S');
				end if;
				
				vl_titulo_w := gerenciamento_contrato_pck.obter_valor_moeda_convertido(nr_seq_contrato_p, cd_moeda_contrato_w, coalesce(cd_moeda_titulo_w,cd_moeda_contrato_w), vl_saldo_titulo_p);
				
				if ((vl_saldo_contrato_w - vl_titulo_w) < 0) then
					if (ie_consiste_saldo_contrato_w = 'C') then
						CALL wheb_mensagem_pck.exibir_mensagem_abort(wheb_mensagem_pck.get_texto(1082502) || CHR(10) ||
																wheb_mensagem_pck.get_texto(1082838,
																'VL_SALDO_W='|| campo_mascara_virgula_casas(vl_saldo_contrato_w + vl_saldo_titulo_anterior_w,4) ||						
																';QT_SALDO_W=' || campo_mascara_virgula_casas(gerenciamento_contrato_pck.obter_qt_restante(nr_seq_contrato_p, 'S'),4) ||					
																';VL_TRANSACAO_W='|| campo_mascara_virgula_casas(vl_saldo_titulo_p,4) ||
																';QT_TRANSACAO_W=0'));
					end if;			
				end if;		
			end if;
		
		end if;
				
	END;

$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE gerenciamento_contrato_pck.consistir_tit_pagar_contrato (nr_seq_contrato_p bigint, nr_titulo_p bigint default 0, vl_saldo_titulo_p bigint DEFAULT NULL, nm_usuario_p text DEFAULT NULL, ie_atualizacao_saldo_p text default null) FROM PUBLIC;