-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';

	
	--QT>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>Obter percentual da transacao no projeto recurso <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<--	

	/*
	Objetivo: Retornar o percentual da transacao passada por parametro em relacao ao total ja utilizado.
	Parametros: 
	nr_seq_proj_rec_p = Numero de sequencia do projeto recurso.
	nm_usuario_p = Nome do usuario.
	cd_estabelecimento_p = Codigo do estabelecimento logado pelo usuario.
	ie_transacao_p = 'SC' - Solicitacao de compra, 'OC' - Ordem de compra, 'NF' - Nota fiscal, 'TP' - Titulo a pagar
	*/
		


CREATE OR REPLACE FUNCTION projeto_recurso_pck.obter_perc_trans_proj_rec ( nr_seq_proj_rec_p bigint, nm_usuario_p text, cd_estabelecimento_p bigint, ie_transacao_p text) RETURNS bigint AS $body$
DECLARE

	/* Soma de todos os valores */


	vl_soma_w  	projeto_recurso_saldo.vl_saldo%type;
	/*Valor da soma de todas as solicitacoes de compra do projeto recurso*/


	vl_total_sc  	projeto_recurso_saldo.vl_saldo%type;	
	/*Valor da soma de todas as ordens de compra do projeto recurso*/


	vl_total_oc 	projeto_recurso_saldo.vl_saldo%type;
	/*Valor da soma de todas as notas fiscais do projeto recurso*/


	vl_total_nf 	projeto_recurso_saldo.vl_saldo%type;	
	/*Valor da soma de todos os titulos a pagar do projeto recurso*/


	vl_total_tp 	projeto_recurso_saldo.vl_saldo%type;	
	/*Valor da soma de todos os movimentos da tesouraria do projeto recurso*/


	vl_total_te 	movto_trans_financ.vl_transacao%type;
	/*Valor da soma de todos os movimentos do controle bancario do projeto recurso*/


	vl_total_cb 	movto_trans_financ.vl_transacao%type;
	/*Utilizardo para retornar o percentual da transacao solicitada*/


	qt_perc_trans_w  double precision;
	/* Parametro para verificar se o controle bancario sera considerada no saldo */


	ie_contr_banc_proj_rec_w	parametro_compras.ie_contr_banc_proj_rec%type;
	/* Parametro para verificar se a tesouraria sera considerada no saldo */


	ie_tesouraria_proj_rec_w	parametro_compras.ie_tesouraria_proj_rec%type;
	
	
BEGIN
	
	qt_perc_trans_w := 0;
	vl_total_te := 0;
	vl_total_cb := 0;
	
	select 	coalesce(max(ie_tesouraria_proj_rec),'N'),
		coalesce(max(ie_contr_banc_proj_rec),'N')
	into STRICT	ie_tesouraria_proj_rec_w,
		ie_contr_banc_proj_rec_w
	from 	parametro_compras
	where 	cd_estabelecimento = 1;
	
	vl_total_sc := projeto_recurso_pck.obter_vl_total_sc_proj_rec(nr_seq_proj_rec_p, nm_usuario_p, cd_estabelecimento_p);	
	vl_total_oc := projeto_recurso_pck.obter_vl_total_oc_proj_rec(nr_seq_proj_rec_p, nm_usuario_p, cd_estabelecimento_p);
	vl_total_nf := projeto_recurso_pck.obter_vl_total_nf_proj_rec(nr_seq_proj_rec_p, nm_usuario_p, cd_estabelecimento_p);
	if (ie_tesouraria_proj_rec_w = 'S') then
		vl_total_te := projeto_recurso_pck.obter_vl_realizado_te(nr_seq_proj_rec_p, 0, cd_estabelecimento_p);
	end if;
	if (ie_contr_banc_proj_rec_w = 'S') then
		vl_total_cb := projeto_recurso_pck.obter_vl_realizado_cb(nr_seq_proj_rec_p, 0, cd_estabelecimento_p);
	end if;
	vl_total_tp := projeto_recurso_pck.obter_vl_real_tit_pag(nr_seq_proj_rec_p);	
	
	vl_soma_w := vl_total_sc + vl_total_oc + vl_total_nf + vl_total_tp + vl_total_te + vl_total_cb;
			
	if (vl_soma_w > 0) then
		if (upper(ie_transacao_p) = 'SC') then
			
			qt_perc_trans_w :=  round((dividir((vl_total_sc * 100), vl_soma_w))::numeric,2);
			
		elsif (upper(ie_transacao_p) = 'OC') then
			
			qt_perc_trans_w := round((dividir((vl_total_oc * 100), vl_soma_w))::numeric,2);
			
		elsif (upper(ie_transacao_p) = 'NF') then
		
			qt_perc_trans_w := round((dividir((vl_total_nf * 100), vl_soma_w))::numeric,2);
		
		elsif (upper(ie_transacao_p) = 'TP') then
		
			qt_perc_trans_w := round((dividir((vl_total_tp * 100), vl_soma_w))::numeric,2);
			
		elsif (upper(ie_transacao_p) = 'TE' and ie_tesouraria_proj_rec_w = 'S') then
		
			qt_perc_trans_w := round((dividir((vl_total_te * 100), vl_soma_w))::numeric,2);
			
		elsif (upper(ie_transacao_p) = 'CB' and ie_contr_banc_proj_rec_w = 'S') then
		
			qt_perc_trans_w := round((dividir((vl_total_cb * 100), vl_soma_w))::numeric,2);
		
		end if;	
	end if;
	
	return qt_perc_trans_w;
	
	END;

$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON FUNCTION projeto_recurso_pck.obter_perc_trans_proj_rec ( nr_seq_proj_rec_p bigint, nm_usuario_p text, cd_estabelecimento_p bigint, ie_transacao_p text) FROM PUBLIC;