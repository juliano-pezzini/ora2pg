-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';

	
	--QT>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>Gera o valor total gasto (sc + oc + nf + tp)  <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<--	

	/*
	Objetivo: .
	Parametros: 
	nr_seq_proj_rec_p = Numero de sequencia do projeto recurso.
	nm_usuario_p = Nome do usuario.
	cd_estabelecimento_p = Codigo do estabelecimento logado pelo usuario.
	*/



CREATE OR REPLACE PROCEDURE projeto_recurso_pck.gerar_total_gasto ( nr_seq_proj_rec_p bigint, nm_usuario_p text, cd_estabelecimento_p bigint) AS $body$
DECLARE

	--Descricoes

	ds_transacao_sc_w		varchar(150);--Solicitacao de compra
	ds_transacao_oc_w		varchar(150);--Ordem compra
	ds_transacao_nf_w		varchar(150);--Nota fiscal
	ds_transacao_tp_w		varchar(150);--Titulo a pagar
	ds_transacao_te_w		varchar(150);--Tesouraria
	ds_transacao_cb_w		varchar(150);--Controle bancario
	ds_transacao_total_w		varchar(150);--Total
	--Titulo a pagar

	qt_transacao_tp_w		bigint;	
	vl_transacao_tp_w		projeto_recurso_saldo.vl_saldo%type;
	--Total comprometido

	qt_transacao_total_c_w		bigint;	
	vl_transacao_total_c_w		projeto_recurso_saldo.vl_saldo%type;
	--Total realizado

	qt_transacao_total_r_w		bigint;	
	vl_transacao_total_r_w		projeto_recurso_saldo.vl_saldo%type;
	--Parametros de consideracao de valores

	ie_tesouraria_proj_rec_w	parametro_compras.ie_tesouraria_proj_rec%type;
	ie_contr_banc_proj_rec_w	parametro_compras.ie_contr_banc_proj_rec%type;
	

	
	
BEGIN
	
	--limpar variavel packege

	CALL projeto_recurso_pck.limpa_variaveis();
	
	ds_transacao_sc_w 	:= wheb_mensagem_pck.get_texto(489229);
	ds_transacao_oc_w 	:= wheb_mensagem_pck.get_texto(489231);	
	ds_transacao_total_w	:= wheb_mensagem_pck.get_texto(489533);
	ds_transacao_nf_w	:= wheb_mensagem_pck.get_texto(489547);	
	ds_transacao_tp_w	:= wheb_mensagem_pck.get_texto(489548);	
	ds_transacao_te_w	:= wheb_mensagem_pck.get_texto(790792);	
	ds_transacao_cb_w	:= wheb_mensagem_pck.get_texto(790791);	
	
	CALL projeto_recurso_pck.set_vl_qt_solic_compra(nr_seq_proj_rec_p, nm_usuario_p, cd_estabelecimento_p);
	CALL projeto_recurso_pck.set_vl_qt_ordem_compra(nr_seq_proj_rec_p, nm_usuario_p, cd_estabelecimento_p);
	CALL projeto_recurso_pck.set_vl_qt_nota_fiscal(nr_seq_proj_rec_p, nm_usuario_p, cd_estabelecimento_p);
	
	select 	coalesce(max(ie_tesouraria_proj_rec),'N'),
		coalesce(max(ie_contr_banc_proj_rec),'N')
	into STRICT	ie_tesouraria_proj_rec_w,
		ie_contr_banc_proj_rec_w
	from   	parametro_compras
	where  	cd_estabelecimento = cd_estabelecimento_p;

	if (ie_tesouraria_proj_rec_w = 'S') then
		CALL projeto_recurso_pck.set_vl_qt_tesouraria(nr_seq_proj_rec_p, nm_usuario_p, cd_estabelecimento_p);
	end if;
	
	if (ie_contr_banc_proj_rec_w = 'S') then
		CALL projeto_recurso_pck.set_vl_qt_controle_bancario(nr_seq_proj_rec_p, nm_usuario_p, cd_estabelecimento_p);
	end if;
		
	qt_transacao_tp_w	:= projeto_recurso_pck.obter_qt_total_tp_proj_rec(nr_seq_proj_rec_p, nm_usuario_p, cd_estabelecimento_p);
	vl_transacao_tp_w	:= projeto_recurso_pck.obter_vl_real_tit_pag(nr_seq_proj_rec_p);	
	
	qt_transacao_total_c_w	:= current_setting('projeto_recurso_pck.solic_compra_wr')::solic_compra_ty.qt_transacao + current_setting('projeto_recurso_pck.ordem_compra_wr')::ordem_compra_ty.qt_transacao;
	vl_transacao_total_c_w	:= current_setting('projeto_recurso_pck.solic_compra_wr')::solic_compra_ty.vl_transacao + current_setting('projeto_recurso_pck.ordem_compra_wr')::ordem_compra_ty.vl_transacao;
	
	qt_transacao_total_r_w	:= current_setting('projeto_recurso_pck.nota_fiscal_wr')::nota_fiscal_ty.qt_transacao + qt_transacao_tp_w + current_setting('projeto_recurso_pck.tesouraria_wr')::tesouraria_ty.qt_transacao + current_setting('projeto_recurso_pck.controle_bancario_wr')::controle_bancario_ty.qt_transacao;
	vl_transacao_total_r_w	:= current_setting('projeto_recurso_pck.nota_fiscal_wr')::nota_fiscal_ty.vl_transacao + vl_transacao_tp_w + current_setting('projeto_recurso_pck.tesouraria_wr')::tesouraria_ty.vl_transacao + current_setting('projeto_recurso_pck.controle_bancario_wr')::controle_bancario_ty.vl_transacao;
	
	
	delete 	
	from 	w_tot_gasto_proj_rec
	where 	nr_seq_proj_rec = nr_seq_proj_rec_p;
	
	commit;
	
	--SOLICITAcaO DE COMPRA

	insert into w_tot_gasto_proj_rec(nm_usuario, 		
		ie_transacao, 		
		vl_transacao, 		
		cd_estabelecimento, 	
		nr_seq_proj_rec,
		ds_transacao,
		qt_transacao)
	values (nm_usuario_p,
		'SC',
		current_setting('projeto_recurso_pck.solic_compra_wr')::solic_compra_ty.vl_transacao,
		cd_estabelecimento_p,
		nr_seq_proj_rec_p,
		ds_transacao_sc_w,
		current_setting('projeto_recurso_pck.solic_compra_wr')::solic_compra_ty.qt_transacao);
	
	--ORDEM DE COMPRA

	insert into w_tot_gasto_proj_rec(nm_usuario, 		
		ie_transacao, 		
		vl_transacao, 		
		cd_estabelecimento, 	
		nr_seq_proj_rec,
		ds_transacao,
		qt_transacao)
	values (nm_usuario_p,
		'OC',
		current_setting('projeto_recurso_pck.ordem_compra_wr')::ordem_compra_ty.vl_transacao,
		cd_estabelecimento_p,
		nr_seq_proj_rec_p,
		ds_transacao_oc_w,
		current_setting('projeto_recurso_pck.ordem_compra_wr')::ordem_compra_ty.qt_transacao);
	
	--TOTAL COMPROMETIDO

	insert into w_tot_gasto_proj_rec(nm_usuario, 		
		ie_transacao, 		
		vl_transacao, 		
		cd_estabelecimento, 	
		nr_seq_proj_rec,
		ds_transacao,
		qt_transacao)
	values (nm_usuario_p,
		'TC',
		vl_transacao_total_c_w,
		cd_estabelecimento_p,
		nr_seq_proj_rec_p,
		ds_transacao_total_w,
		qt_transacao_total_c_w);
	
	--NOTA FISCAL

	insert into w_tot_gasto_proj_rec(nm_usuario, 		
		ie_transacao, 		
		vl_transacao, 		
		cd_estabelecimento, 	
		nr_seq_proj_rec,
		ds_transacao,
		qt_transacao)
	values (nm_usuario_p,
		'NF',
		current_setting('projeto_recurso_pck.nota_fiscal_wr')::nota_fiscal_ty.vl_transacao,
		cd_estabelecimento_p,
		nr_seq_proj_rec_p,
		ds_transacao_nf_w,
		current_setting('projeto_recurso_pck.nota_fiscal_wr')::nota_fiscal_ty.qt_transacao);
	
	--TiTULO A PAGAR

	insert into w_tot_gasto_proj_rec(nm_usuario, 		
		ie_transacao, 		
		vl_transacao, 		
		cd_estabelecimento, 	
		nr_seq_proj_rec,
		ds_transacao,
		qt_transacao)
	values (nm_usuario_p,
		'TP',
		vl_transacao_tp_w,
		cd_estabelecimento_p,
		nr_seq_proj_rec_p,
		ds_transacao_tp_w,
		qt_transacao_tp_w);
		
	--TESOURARIA

	insert into w_tot_gasto_proj_rec(nm_usuario, 		
		ie_transacao, 		
		vl_transacao, 		
		cd_estabelecimento, 	
		nr_seq_proj_rec,
		ds_transacao,
		qt_transacao)
	values (nm_usuario_p,
		'TE',
		current_setting('projeto_recurso_pck.tesouraria_wr')::tesouraria_ty.vl_transacao,
		cd_estabelecimento_p,
		nr_seq_proj_rec_p,
		ds_transacao_te_w,
		current_setting('projeto_recurso_pck.tesouraria_wr')::tesouraria_ty.qt_transacao);
		
	--CONTROLE BANCaRIO

	insert into w_tot_gasto_proj_rec(nm_usuario, 		
		ie_transacao, 		
		vl_transacao, 		
		cd_estabelecimento, 	
		nr_seq_proj_rec,
		ds_transacao,
		qt_transacao)
	values (nm_usuario_p,
		'CB',
		current_setting('projeto_recurso_pck.controle_bancario_wr')::controle_bancario_ty.vl_transacao,
		cd_estabelecimento_p,
		nr_seq_proj_rec_p,
		ds_transacao_cb_w,
		current_setting('projeto_recurso_pck.controle_bancario_wr')::controle_bancario_ty.qt_transacao);
	
	--TOTAL REALIZADO

	insert into w_tot_gasto_proj_rec(nm_usuario, 		
		ie_transacao, 		
		vl_transacao, 		
		cd_estabelecimento, 	
		nr_seq_proj_rec,
		ds_transacao,
		qt_transacao)
	values (nm_usuario_p,
		'TR',
		vl_transacao_total_r_w,
		cd_estabelecimento_p,
		nr_seq_proj_rec_p,
		ds_transacao_total_w,
		qt_transacao_total_r_w);
	
	commit;

	END;

$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE projeto_recurso_pck.gerar_total_gasto ( nr_seq_proj_rec_p bigint, nm_usuario_p text, cd_estabelecimento_p bigint) FROM PUBLIC;
