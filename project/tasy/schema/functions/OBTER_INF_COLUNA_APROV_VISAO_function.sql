-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_inf_coluna_aprov_visao ( nr_seq_informacao_p bigint, ie_informacao_p bigint) RETURNS varchar AS $body$
DECLARE


/*
ie_informacao_p
	0 = Atributo
	1 = Descrição do campo
	2 = Titulo do campo
	3 = Tamanho do campo*/

	
/*Dominio 2409*/
	


ds_atributo_w		varchar(255);
ds_descricao_w		varchar(255);
ds_titulo_w		varchar(255);
ds_tamanho_w		varchar(255);
ds_retorno_w		varchar(255);


BEGIN

if (nr_seq_informacao_p = 1) then
	ds_atributo_w	:= 'ds_tipo';
	ds_descricao_w	:= wheb_mensagem_pck.get_texto(314316);
	ds_titulo_w	:= wheb_mensagem_pck.get_texto(314324);
	ds_tamanho_w	:= '120';
elsif (nr_seq_informacao_p = 2) then
	ds_atributo_w	:= 'vl_venda';
	ds_descricao_w	:= wheb_mensagem_pck.get_texto(335625);
	ds_titulo_w	:= wheb_mensagem_pck.get_texto(314328);
	ds_tamanho_w	:= '80';
elsif (nr_seq_informacao_p = 3) then
	ds_atributo_w	:= 'pr_margem_convertido';
	ds_descricao_w	:= wheb_mensagem_pck.get_texto(314349);
	ds_titulo_w	:= wheb_mensagem_pck.get_texto(314350);
	ds_tamanho_w	:= '80';
elsif (nr_seq_informacao_p = 4) then
	ds_atributo_w	:= 'vl_adiantamento';
	ds_descricao_w	:= wheb_mensagem_pck.get_texto(314351);
	ds_titulo_w	:= wheb_mensagem_pck.get_texto(314352);
	ds_tamanho_w	:= '90';
elsif (nr_seq_informacao_p = 5) then
	ds_atributo_w	:= 'cd_unidade_medida_compra';
	ds_descricao_w	:= wheb_mensagem_pck.get_texto(314354);
	ds_titulo_w	:= wheb_mensagem_pck.get_texto(314355);
	ds_tamanho_w	:= '38';
elsif (nr_seq_informacao_p = 6) then
	ds_atributo_w	:= 'qt_ponto_pedido';
	ds_descricao_w	:= wheb_mensagem_pck.get_texto(314356);
	ds_titulo_w	:= wheb_mensagem_pck.get_texto(314357);
	ds_tamanho_w	:= '100';
elsif (nr_seq_informacao_p = 7) then
	ds_atributo_w	:= 'qt_material';
	ds_descricao_w	:= wheb_mensagem_pck.get_texto(314358);
	ds_titulo_w	:= wheb_mensagem_pck.get_texto(314360);
	ds_tamanho_w	:= '70';
elsif (nr_seq_informacao_p = 8) then
	ds_atributo_w	:= 'ie_situacao';
	ds_descricao_w	:= wheb_mensagem_pck.get_texto(314361);
	ds_titulo_w	:= wheb_mensagem_pck.get_texto(314362);
	ds_tamanho_w	:= '40';
elsif (nr_seq_informacao_p = 9) then
	ds_atributo_w	:= 'qt_entregue';
	ds_descricao_w	:= wheb_mensagem_pck.get_texto(314364);
	ds_titulo_w	:= wheb_mensagem_pck.get_texto(314365);
	ds_tamanho_w	:= '70';
elsif (nr_seq_informacao_p = 10) then
	ds_atributo_w	:= 'pr_descontos';
	ds_descricao_w	:= wheb_mensagem_pck.get_texto(314366);
	ds_titulo_w	:= wheb_mensagem_pck.get_texto(314367);
	ds_tamanho_w	:= '50';
elsif (nr_seq_informacao_p = 11) then
	ds_atributo_w	:= 'cd_local_estoque';
	ds_descricao_w	:= wheb_mensagem_pck.get_texto(314369);
	ds_titulo_w	:= wheb_mensagem_pck.get_texto(314378);
	ds_tamanho_w	:= '40';
elsif (nr_seq_informacao_p = 12) then
	ds_atributo_w	:= 'ds_material_direto';
	ds_descricao_w	:= wheb_mensagem_pck.get_texto(314379);
	ds_titulo_w	:= wheb_mensagem_pck.get_texto(314381);
	ds_tamanho_w	:= '400';
elsif (nr_seq_informacao_p = 13) then
	ds_atributo_w	:= 'nr_seq_aprovacao';
	ds_descricao_w	:= wheb_mensagem_pck.get_texto(314382);
	ds_titulo_w	:= wheb_mensagem_pck.get_texto(314384);
	ds_tamanho_w	:= '60';
elsif (nr_seq_informacao_p = 14) then
	ds_atributo_w	:= 'dt_aprovacao';
	ds_descricao_w	:= wheb_mensagem_pck.get_texto(314392);
	ds_titulo_w	:= wheb_mensagem_pck.get_texto(314393);
	ds_tamanho_w	:= '110';
elsif (nr_seq_informacao_p = 15) then
	ds_atributo_w	:= 'cd_estabelecimento';
	ds_descricao_w	:= wheb_mensagem_pck.get_texto(314396);
	ds_titulo_w	:= wheb_mensagem_pck.get_texto(314398);
	ds_tamanho_w	:= '80';
elsif (nr_seq_informacao_p = 16) then
	ds_atributo_w	:= 'ds_estabelecimento';
	ds_descricao_w	:= wheb_mensagem_pck.get_texto(314399);
	ds_titulo_w	:= wheb_mensagem_pck.get_texto(314401);
	ds_tamanho_w	:= '200';
elsif (nr_seq_informacao_p = 17) then
	ds_atributo_w	:= 'qt_mes_consumo';
	ds_descricao_w	:= wheb_mensagem_pck.get_texto(314402);
	ds_titulo_w	:= wheb_mensagem_pck.get_texto(314403);
	ds_tamanho_w	:= '85';	
elsif (nr_seq_informacao_p = 18) then
	ds_atributo_w	:= 'vl_total';
	ds_descricao_w	:= wheb_mensagem_pck.get_texto(314407);
	ds_titulo_w	:= wheb_mensagem_pck.get_texto(314409);
	ds_tamanho_w	:= '85';
elsif (nr_seq_informacao_p = 20) then
	ds_atributo_w	:= 'cd_conta_contabil';
	ds_descricao_w	:= wheb_mensagem_pck.get_texto(314410);
	ds_titulo_w	:= wheb_mensagem_pck.get_texto(314411);
	ds_tamanho_w	:= '80';
elsif (nr_seq_informacao_p = 21) then
	ds_atributo_w	:= 'nm_usuario';
	ds_descricao_w	:= wheb_mensagem_pck.get_texto(314412);
	ds_titulo_w	:= wheb_mensagem_pck.get_texto(314415);
	ds_tamanho_w	:= '70';
elsif (nr_seq_informacao_p = 23) then
	ds_atributo_w	:= 'ie_geracao_solic';
	ds_descricao_w	:= wheb_mensagem_pck.get_texto(314416);
	ds_titulo_w	:= wheb_mensagem_pck.get_texto(314418);
	ds_tamanho_w	:= '45';
elsif (nr_seq_informacao_p = 24) then
	ds_atributo_w	:= 'ds_observacao';
	ds_descricao_w	:= wheb_mensagem_pck.get_texto(314420);
	ds_titulo_w	:= wheb_mensagem_pck.get_texto(314422);
	ds_tamanho_w	:= '250';
elsif (nr_seq_informacao_p = 25) then
	ds_atributo_w	:= 'ie_consignado';
	ds_descricao_w	:= wheb_mensagem_pck.get_texto(314424);
	ds_titulo_w	:= wheb_mensagem_pck.get_texto(314426);
	ds_tamanho_w	:= '45';
elsif (nr_seq_informacao_p = 26) then
	ds_atributo_w	:= 'nm_solicitante';
	ds_descricao_w	:= wheb_mensagem_pck.get_texto(314428);
	ds_titulo_w	:= wheb_mensagem_pck.get_texto(314430);
	ds_tamanho_w	:= '135';
elsif (nr_seq_informacao_p = 27) then
	ds_atributo_w	:= 'dt_liberacao';
	ds_descricao_w	:= wheb_mensagem_pck.get_texto(314433);
	ds_titulo_w	:= wheb_mensagem_pck.get_texto(314434);
	ds_tamanho_w	:= '110';
elsif (nr_seq_informacao_p = 28) then
	ds_atributo_w	:= 'ds_condicao_pagamento';
	ds_descricao_w	:= wheb_mensagem_pck.get_texto(314436);
	ds_titulo_w	:= wheb_mensagem_pck.get_texto(314437);
	ds_tamanho_w	:= '100';
elsif (nr_seq_informacao_p = 29) then
	ds_atributo_w	:= 'nm_fornecedor';
	ds_descricao_w	:= wheb_mensagem_pck.get_texto(314438);
	ds_titulo_w	:= wheb_mensagem_pck.get_texto(314439);
	ds_tamanho_w	:= '220';
elsif (nr_seq_informacao_p = 30) then
	ds_atributo_w	:= 'ds_diferenca';
	ds_descricao_w	:= wheb_mensagem_pck.get_texto(314440);
	ds_titulo_w	:= wheb_mensagem_pck.get_texto(314441);
	ds_tamanho_w	:= '400';
elsif (nr_seq_informacao_p = 31) then
	ds_atributo_w	:= 'vl_ultima_compra';
	ds_descricao_w	:= wheb_mensagem_pck.get_texto(314442);
	ds_titulo_w	:= wheb_mensagem_pck.get_texto(314443);
	ds_tamanho_w	:= '80';
elsif (nr_seq_informacao_p = 32) then
	ds_atributo_w	:= 'dt_ultima_compra';
	ds_descricao_w	:= wheb_mensagem_pck.get_texto(314445);
	ds_titulo_w	:= wheb_mensagem_pck.get_texto(314446);
	ds_tamanho_w	:= '110';
elsif (nr_seq_informacao_p = 33) then
	ds_atributo_w	:= 'qt_ultima_compra';
	ds_descricao_w	:= wheb_mensagem_pck.get_texto(314447);
	ds_titulo_w	:= wheb_mensagem_pck.get_texto(314448);
	ds_tamanho_w	:= '70';
elsif (nr_seq_informacao_p = 34) then
	ds_atributo_w	:= 'cd_unidade_ultima_compra';
	ds_descricao_w	:= wheb_mensagem_pck.get_texto(314450);
	ds_titulo_w	:= wheb_mensagem_pck.get_texto(314451);
	ds_tamanho_w	:= '72';
elsif (nr_seq_informacao_p = 35) then
	ds_atributo_w	:= 'ds_fornec_ultima_compra';
	ds_descricao_w	:= wheb_mensagem_pck.get_texto(314455);
	ds_titulo_w	:= wheb_mensagem_pck.get_texto(314458);
	ds_tamanho_w	:= '160';
elsif (nr_seq_informacao_p = 36) then
	ds_atributo_w	:= 'ds_centro_custo';
	ds_descricao_w	:= wheb_mensagem_pck.get_texto(314459);
	ds_titulo_w	:= wheb_mensagem_pck.get_texto(314460);
	ds_tamanho_w	:= '180';
elsif (nr_seq_informacao_p = 37) then
	ds_atributo_w	:= 'vl_custo_medio';
	ds_descricao_w	:= wheb_mensagem_pck.get_texto(314461);
	ds_titulo_w	:= wheb_mensagem_pck.get_texto(314462);
	ds_tamanho_w	:= '70';
elsif (nr_seq_informacao_p = 38) then
	ds_atributo_w	:= 'vl_custo_total';
	ds_descricao_w	:= wheb_mensagem_pck.get_texto(314463);
	ds_titulo_w	:= wheb_mensagem_pck.get_texto(314465);
	ds_tamanho_w	:= '70';
elsif (nr_seq_informacao_p = 39) then
	ds_atributo_w	:= 'qt_fornecedor';
	ds_descricao_w	:= wheb_mensagem_pck.get_texto(314466);
	ds_titulo_w	:= wheb_mensagem_pck.get_texto(314467);
	ds_tamanho_w	:= '90';
elsif (nr_seq_informacao_p = 40) then
	ds_atributo_w	:= 'qt_fornecedor_preco';
	ds_descricao_w	:= wheb_mensagem_pck.get_texto(314468);
	ds_titulo_w	:= wheb_mensagem_pck.get_texto(314469);
	ds_tamanho_w	:= '90';
elsif (nr_seq_informacao_p = 41) then
	ds_atributo_w	:= 'ds_processo_aprov';
	ds_descricao_w	:= wheb_mensagem_pck.get_texto(314472);
	ds_titulo_w	:= wheb_mensagem_pck.get_texto(314473);
	ds_tamanho_w	:= '200';
elsif (nr_seq_informacao_p = 42) then
	ds_atributo_w	:= 'vl_total_compra';
	ds_descricao_w	:= wheb_mensagem_pck.get_texto(314475);
	ds_titulo_w	:= wheb_mensagem_pck.get_texto(802173);
	ds_tamanho_w	:= '90';
elsif (nr_seq_informacao_p = 43) then
	ds_atributo_w	:= 'vl_tot_qt_ult_compra';
	ds_descricao_w	:= wheb_mensagem_pck.get_texto(314478);
	ds_titulo_w	:= wheb_mensagem_pck.get_texto(314479);
	ds_tamanho_w	:= '150';
elsif (nr_seq_informacao_p = 44) then
	ds_atributo_w	:= 'qt_estoque';
	ds_descricao_w	:= wheb_mensagem_pck.get_texto(314481);
	ds_titulo_w	:= wheb_mensagem_pck.get_texto(314482);
	ds_tamanho_w	:= '80';
elsif (nr_seq_informacao_p = 45) then
	ds_atributo_w	:= 'ds_conta_contabil';
	ds_descricao_w	:= wheb_mensagem_pck.get_texto(314484);
	ds_titulo_w	:= wheb_mensagem_pck.get_texto(314486);
	ds_tamanho_w	:= '200';
elsif (nr_seq_informacao_p = 46) then
	ds_atributo_w	:= 'qt_consumo_mensal';
	ds_descricao_w	:= wheb_mensagem_pck.get_texto(314488);
	ds_titulo_w	:= wheb_mensagem_pck.get_texto(314490);
	ds_tamanho_w	:= '85';
elsif (nr_seq_informacao_p = 47) then
	ds_atributo_w	:= 'vl_venda_convertido';
	ds_descricao_w	:= wheb_mensagem_pck.get_texto(314493);
	ds_titulo_w	:= wheb_mensagem_pck.get_texto(314494);
	ds_tamanho_w	:= '110';
elsif (nr_seq_informacao_p = 48) then
	ds_atributo_w	:= 'pr_margem_convertido';
	ds_descricao_w	:= wheb_mensagem_pck.get_texto(314496);
	ds_titulo_w	:= wheb_mensagem_pck.get_texto(314497);
	ds_tamanho_w	:= '110';
elsif (nr_seq_informacao_p = 49) then
	ds_atributo_w	:= 'ds_marca';
	ds_descricao_w	:= wheb_mensagem_pck.get_texto(314498);
	ds_titulo_w	:= wheb_mensagem_pck.get_texto(314499);
	ds_tamanho_w	:= '150';
elsif (nr_seq_informacao_p = 50) then
	ds_atributo_w	:= 'ds_endereco';
	ds_descricao_w	:= wheb_mensagem_pck.get_texto(314501);
	ds_titulo_w	:= wheb_mensagem_pck.get_texto(314502);
	ds_tamanho_w	:= '450';
elsif (nr_seq_informacao_p = 51) then
	ds_atributo_w	:= 'nr_ultima_oc';
	ds_descricao_w	:= wheb_mensagem_pck.get_texto(314503);
	ds_titulo_w	:= wheb_mensagem_pck.get_texto(314505);
	ds_tamanho_w	:= '100';
elsif (nr_seq_informacao_p = 52) then
	ds_atributo_w	:= 'ds_moeda';
	ds_descricao_w	:= wheb_mensagem_pck.get_texto(314506);
	ds_titulo_w	:= wheb_mensagem_pck.get_texto(314507);
	ds_tamanho_w	:= '170';
elsif (nr_seq_informacao_p = 53) then
	ds_atributo_w	:= 'vl_estimado';
	ds_descricao_w	:= wheb_mensagem_pck.get_texto(314508);
	ds_titulo_w	:= wheb_mensagem_pck.get_texto(314509);
	ds_tamanho_w	:= '110';
elsif (nr_seq_informacao_p = 54) then
	ds_atributo_w	:= 'cd_unid_consumo';
	ds_descricao_w	:= wheb_mensagem_pck.get_texto(314511);
	ds_titulo_w	:= wheb_mensagem_pck.get_texto(314512);
	ds_tamanho_w	:= '80';
elsif (nr_seq_informacao_p = 55) then
	ds_atributo_w	:= 'ds_observacao_doc';
	ds_descricao_w	:= wheb_mensagem_pck.get_texto(314513);
	ds_titulo_w	:= wheb_mensagem_pck.get_texto(314515);
	ds_tamanho_w	:= '500';
elsif (nr_seq_informacao_p = 56) then
	ds_atributo_w	:= 'ds_projeto_recurso';
	ds_descricao_w	:= wheb_mensagem_pck.get_texto(314518);
	ds_titulo_w	:= wheb_mensagem_pck.get_texto(314519);
	ds_tamanho_w	:= '250';
elsif (nr_seq_informacao_p = 57) then
	ds_atributo_w	:= 'ds_conta_bancaria';
	ds_descricao_w	:= wheb_mensagem_pck.get_texto(314526);
	ds_titulo_w	:= wheb_mensagem_pck.get_texto(314528);
	ds_tamanho_w	:= '400';
elsif (nr_seq_informacao_p = 58) then
	ds_atributo_w	:= 'nr_controle_interno';
	ds_descricao_w	:= wheb_mensagem_pck.get_texto(314529);
	ds_titulo_w	:= wheb_mensagem_pck.get_texto(314531);
	ds_tamanho_w	:= '150';
elsif (nr_seq_informacao_p = 59) then
	ds_atributo_w	:= 'ds_mod_compra';
	ds_descricao_w	:= wheb_mensagem_pck.get_texto(314532);
	ds_titulo_w	:= wheb_mensagem_pck.get_texto(314534);
	ds_tamanho_w	:= '250';
elsif (nr_seq_informacao_p = 60) then
	ds_atributo_w	:= 'ds_fornec_sugestivo';
	ds_descricao_w	:= wheb_mensagem_pck.get_texto(314535);
	ds_titulo_w	:= wheb_mensagem_pck.get_texto(314536);
	ds_tamanho_w	:= '250';
elsif (nr_seq_informacao_p = 61) then
	ds_atributo_w	:= 'ds_fornec_exclusivo';
	ds_descricao_w	:= wheb_mensagem_pck.get_texto(314538);
	ds_titulo_w	:= wheb_mensagem_pck.get_texto(314539);
	ds_tamanho_w	:= '250';
elsif (nr_seq_informacao_p = 62) then
	ds_atributo_w	:= 'qt_dia_estoque';
	ds_descricao_w	:= wheb_mensagem_pck.get_texto(314541);
	ds_titulo_w	:= wheb_mensagem_pck.get_texto(314543);
	ds_tamanho_w	:= '110';
elsif (nr_seq_informacao_p = 63) then
	ds_atributo_w	:= 'vl_venda_conta_pac';
	ds_descricao_w	:= wheb_mensagem_pck.get_texto(314544);
	ds_titulo_w	:= wheb_mensagem_pck.get_texto(314545);
	ds_tamanho_w	:= '130';
elsif (nr_seq_informacao_p = 64) then
	ds_atributo_w	:= 'ds_solic_sc';
	ds_descricao_w	:= wheb_mensagem_pck.get_texto(314549);
	ds_titulo_w	:= wheb_mensagem_pck.get_texto(314550);
	ds_tamanho_w	:= '250';
elsif (nr_seq_informacao_p = 65) then
	ds_atributo_w	:= 'qt_original';
	ds_descricao_w	:= wheb_mensagem_pck.get_texto(314551);
	ds_titulo_w	:= wheb_mensagem_pck.get_texto(314552);
	ds_tamanho_w	:= '110';
elsif (nr_seq_informacao_p = 66) then
	ds_atributo_w	:= 'vl_unit_mat_original';
	ds_descricao_w	:= wheb_mensagem_pck.get_texto(314553);
	ds_titulo_w	:= wheb_mensagem_pck.get_texto(314555);
	ds_tamanho_w	:= '110';
elsif (nr_seq_informacao_p = 67) then
	ds_atributo_w	:= 'nm_usuario_lib';
	ds_descricao_w	:= wheb_mensagem_pck.get_texto(314556);
	ds_titulo_w	:= wheb_mensagem_pck.get_texto(314557);
	ds_tamanho_w	:= '110';
elsif (nr_seq_informacao_p = 68) then
	ds_atributo_w	:= 'nm_usuario_nrec';
	ds_descricao_w	:= wheb_mensagem_pck.get_texto(314558);
	ds_titulo_w	:= wheb_mensagem_pck.get_texto(314559);
	ds_tamanho_w	:= '110';
elsif (nr_seq_informacao_p = 69) then
	ds_atributo_w	:= 'ie_mat_padronizado';
	ds_descricao_w	:= wheb_mensagem_pck.get_texto(314560);
	ds_titulo_w	:= wheb_mensagem_pck.get_texto(314561);
	ds_tamanho_w	:= '50';
elsif (nr_seq_informacao_p = 70) then
	ds_atributo_w	:= 'ds_tipo_frete';
	ds_descricao_w	:= wheb_mensagem_pck.get_texto(314562);
	ds_titulo_w	:= wheb_mensagem_pck.get_texto(314563);
	ds_tamanho_w	:= '200';
elsif (nr_seq_informacao_p = 71) then
	ds_atributo_w	:= 'qt_dias_entrega';
	ds_descricao_w	:= wheb_mensagem_pck.get_texto(314564);
	ds_titulo_w	:= wheb_mensagem_pck.get_texto(314565);
	ds_tamanho_w	:= '90';
elsif (nr_seq_informacao_p = 72) then
	ds_atributo_w	:= 'ds_local_estoque';
	ds_descricao_w	:= wheb_mensagem_pck.get_texto(314566);
	ds_titulo_w	:= wheb_mensagem_pck.get_texto(314567);
	ds_tamanho_w	:= '200';
elsif (nr_seq_informacao_p = 73) then
	ds_atributo_w	:= 'pr_desc_financeiro';
	ds_descricao_w	:= wheb_mensagem_pck.get_texto(314568);
	ds_titulo_w	:= wheb_mensagem_pck.get_texto(314569);
	ds_tamanho_w	:= '110';
elsif (nr_seq_informacao_p = 74) then
	ds_atributo_w	:= 'nr_seq_ordem_serv';
	ds_descricao_w	:= wheb_mensagem_pck.get_texto(314570);
	ds_titulo_w	:= wheb_mensagem_pck.get_texto(314571);
	ds_tamanho_w	:= '110';
elsif (nr_seq_informacao_p = 75) then
	ds_atributo_w	:= 'cd_cnpj_fornec_solic';
	ds_descricao_w	:= wheb_mensagem_pck.get_texto(314573);
	ds_titulo_w	:= wheb_mensagem_pck.get_texto(314575);
	ds_tamanho_w	:= '150';
elsif (nr_seq_informacao_p = 76) then
	ds_atributo_w	:= 'ds_fornec_solic';
	ds_descricao_w	:= wheb_mensagem_pck.get_texto(314576);
	ds_titulo_w	:= wheb_mensagem_pck.get_texto(314577);
	ds_tamanho_w	:= '350';
elsif (nr_seq_informacao_p = 77) then
	ds_atributo_w	:= 'ds_tipo_compra';
	ds_descricao_w	:= wheb_mensagem_pck.get_texto(314578);
	ds_titulo_w	:= wheb_mensagem_pck.get_texto(314579);
	ds_tamanho_w	:= '220';
elsif (nr_seq_informacao_p = 78) then
	ds_atributo_w	:= 'vl_custo_prev_total';
	ds_descricao_w	:= wheb_mensagem_pck.get_texto(314581);
	ds_titulo_w	:= wheb_mensagem_pck.get_texto(314583);
	ds_tamanho_w	:= '110';
elsif (nr_seq_informacao_p = 79) then
	ds_atributo_w	:= 'vl_estoque_total';
	ds_descricao_w	:= wheb_mensagem_pck.get_texto(314585);
	ds_titulo_w	:= wheb_mensagem_pck.get_texto(314586);
	ds_tamanho_w	:= '110';
elsif (nr_seq_informacao_p = 80) then
	ds_atributo_w	:= 'nr_atendimento';
	ds_descricao_w	:= wheb_mensagem_pck.get_texto(314587);
	ds_titulo_w	:= wheb_mensagem_pck.get_texto(314589);
	ds_tamanho_w	:= '110';	
elsif (nr_seq_informacao_p = 81) then
	ds_atributo_w	:= 'ds_forma_compra';
	ds_descricao_w	:= wheb_mensagem_pck.get_texto(314591);
	ds_titulo_w	:= wheb_mensagem_pck.get_texto(314594);
	ds_tamanho_w	:= '170';
elsif (nr_seq_informacao_p = 82) then
	ds_atributo_w	:= 'ds_grupo';
	ds_descricao_w	:= wheb_mensagem_pck.get_texto(314596);
	ds_titulo_w	:= wheb_mensagem_pck.get_texto(314598);
	ds_tamanho_w	:= '170';
elsif (nr_seq_informacao_p = 83) then
	ds_atributo_w	:= 'ds_fornec_ult_comp_fant';
	ds_descricao_w	:= wheb_mensagem_pck.get_texto(314600);
	ds_titulo_w	:= wheb_mensagem_pck.get_texto(314602);
	ds_tamanho_w	:= '170';
elsif (nr_seq_informacao_p = 84) then
	ds_atributo_w	:= 'ie_curva_abc';
	ds_descricao_w	:= wheb_mensagem_pck.get_texto(314605);
	ds_titulo_w	:= wheb_mensagem_pck.get_texto(314607);
	ds_tamanho_w	:= '70';
elsif (nr_seq_informacao_p = 85) then
	ds_atributo_w	:= 'vl_ultima_comp_conv';
	ds_descricao_w	:= wheb_mensagem_pck.get_texto(314609);
	ds_titulo_w	:= wheb_mensagem_pck.get_texto(314611);
	ds_tamanho_w	:= '100';
elsif (nr_seq_informacao_p = 86) then
	ds_atributo_w	:= 'vl_tot_qt_ult_comp_conv';
	ds_descricao_w	:= wheb_mensagem_pck.get_texto(314615);
	ds_titulo_w	:= wheb_mensagem_pck.get_texto(314617);
	ds_tamanho_w	:= '160';
elsif (nr_seq_informacao_p = 87) then
	ds_atributo_w	:= 'vl_ult_compra_estoque';
	ds_descricao_w	:= wheb_mensagem_pck.get_texto(314618);
	ds_titulo_w	:= wheb_mensagem_pck.get_texto(314619);
	ds_tamanho_w	:= '140';
elsif (nr_seq_informacao_p = 88) then
	ds_atributo_w	:= 'pr_margem_convert_est';
	ds_descricao_w	:= wheb_mensagem_pck.get_texto(314620);
	ds_titulo_w	:= wheb_mensagem_pck.get_texto(314621);
	ds_tamanho_w	:= '140';
elsif (nr_seq_informacao_p = 89) then
	ds_atributo_w	:= 'vl_ult_compra_dec';
	ds_descricao_w	:= wheb_mensagem_pck.get_texto(314623);
	ds_titulo_w	:= wheb_mensagem_pck.get_texto(314626);
	ds_tamanho_w	:= '80';
elsif (nr_seq_informacao_p = 90) then
	ds_atributo_w	:= 'dt_validade_oc';
	ds_descricao_w	:= wheb_mensagem_pck.get_texto(314627);
	ds_titulo_w	:= wheb_mensagem_pck.get_texto(314629);
	ds_tamanho_w	:= '90';	
elsif (nr_seq_informacao_p = 91) then
	ds_atributo_w	:= 'ds_fonte';
	ds_descricao_w	:= wheb_mensagem_pck.get_texto(314632);
	ds_titulo_w	:= wheb_mensagem_pck.get_texto(314634);
	ds_tamanho_w	:= '170';	
elsif (nr_seq_informacao_p = 92) then
	ds_atributo_w	:= 'ds_orcamento';
	ds_descricao_w	:= wheb_mensagem_pck.get_texto(314635);
	ds_titulo_w	:= wheb_mensagem_pck.get_texto(314636);
	ds_tamanho_w	:= '170';	
elsif (nr_seq_informacao_p = 93) then
	ds_atributo_w	:= 'ds_unidade_orc';
	ds_descricao_w	:= wheb_mensagem_pck.get_texto(314638);
	ds_titulo_w	:= wheb_mensagem_pck.get_texto(314639);
	ds_tamanho_w	:= '170';
elsif (nr_seq_informacao_p = 94) then
	ds_atributo_w	:= 'vl_frete';
	ds_descricao_w	:= wheb_mensagem_pck.get_texto(314640);
	ds_titulo_w	:= wheb_mensagem_pck.get_texto(314642);
	ds_tamanho_w	:= '110';
elsif (nr_seq_informacao_p = 95) then
	ds_atributo_w	:= 'vl_ordem_compra';
	ds_descricao_w	:= wheb_mensagem_pck.get_texto(314643);
	ds_titulo_w	:= wheb_mensagem_pck.get_texto(314645);
	ds_tamanho_w	:= '110';
elsif (nr_seq_informacao_p = 96) then
	ds_atributo_w	:= 'ds_titulo_cotacao';
	ds_descricao_w	:= wheb_mensagem_pck.get_texto(314649);
	ds_titulo_w	:= wheb_mensagem_pck.get_texto(314650);
	ds_tamanho_w	:= '255';
elsif (nr_seq_informacao_p = 97) then
	ds_atributo_w	:= 'vl_desconto';
	ds_descricao_w	:= wheb_mensagem_pck.get_texto(314654);
	ds_titulo_w	:= wheb_mensagem_pck.get_texto(314655);
	ds_tamanho_w	:= '110';
elsif (nr_seq_informacao_p = 98) then
	ds_atributo_w	:= 'vl_liquido';
	ds_descricao_w	:= wheb_mensagem_pck.get_texto(314657);
	ds_titulo_w	:= wheb_mensagem_pck.get_texto(314659);
	ds_tamanho_w	:= '110';
elsif (nr_seq_informacao_p = 99) then
	ds_atributo_w	:= 'ds_marca_fornec';
	ds_descricao_w	:= wheb_mensagem_pck.get_texto(314661);
	ds_titulo_w	:= wheb_mensagem_pck.get_texto(314665);
	ds_tamanho_w	:= '200';	
elsif (nr_seq_informacao_p = 100) then
	ds_atributo_w	:= 'qt_estoque_conv_compra';
	ds_descricao_w	:= wheb_mensagem_pck.get_texto(319708);
	ds_titulo_w	:= wheb_mensagem_pck.get_texto(319705);
	ds_tamanho_w	:= '150';
elsif (nr_seq_informacao_p = 102) then
	ds_atributo_w	:= 'qt_consumo_mes';
	ds_descricao_w	:= wheb_mensagem_pck.get_texto(441645);
	ds_titulo_w		:= wheb_mensagem_pck.get_texto(441646);
	ds_tamanho_w	:= '150';
elsif (nr_seq_informacao_p = 103) then
	ds_atributo_w	:= 'qt_media_consumo_meses';
	ds_descricao_w	:= wheb_mensagem_pck.get_texto(441647);
	ds_titulo_w		:= wheb_mensagem_pck.get_texto(441652);
	ds_tamanho_w	:= '160';
elsif (nr_seq_informacao_p = 104) then
	ds_atributo_w	:= 'ds_motivo_urgencia';
	ds_descricao_w	:= wheb_mensagem_pck.get_texto(451649);
	ds_titulo_w	:= wheb_mensagem_pck.get_texto(451651);
	ds_tamanho_w	:= '255';	
elsif (nr_seq_informacao_p = 105) then
	ds_atributo_w	:= 'ds_justif_escolha_fornec';
	ds_descricao_w	:= wheb_mensagem_pck.get_texto(786034);
	ds_titulo_w	:= wheb_mensagem_pck.get_texto(786034);
	ds_tamanho_w	:= '255';	
elsif (nr_seq_informacao_p = 106) then
	ds_atributo_w	:= 'qt_estoque_minimo';
	ds_descricao_w	:= wheb_mensagem_pck.get_texto(809928);
	ds_titulo_w	:= wheb_mensagem_pck.get_texto(809928);
	ds_tamanho_w	:= '110';
elsif (nr_seq_informacao_p = 107) then
	ds_atributo_w	:= 'qt_estoque_maximo';
	ds_descricao_w	:= wheb_mensagem_pck.get_texto(809929);
	ds_titulo_w	:= wheb_mensagem_pck.get_texto(809929);
	ds_tamanho_w	:= '110';
elsif (nr_seq_informacao_p = 108) then
	ds_atributo_w	:= 'qt_dia_ressup_forn';
	ds_descricao_w	:= wheb_mensagem_pck.get_texto(809931);
	ds_titulo_w	:= wheb_mensagem_pck.get_texto(809931);
	ds_tamanho_w	:= '110';
elsif (nr_seq_informacao_p = 109) then
	ds_atributo_w	:= 'qt_dia_prazo_fornec';
	ds_descricao_w	:= wheb_mensagem_pck.get_texto(854750);
	ds_titulo_w	:= wheb_mensagem_pck.get_texto(854750);
	ds_tamanho_w	:= '110';
elsif (nr_seq_informacao_p = 110) then
	ds_atributo_w	:= 'nr_contrato';
	ds_descricao_w	:= wheb_mensagem_pck.get_texto(1050894);
	ds_titulo_w	:= wheb_mensagem_pck.get_texto(1050894);
	ds_tamanho_w	:= '80';
elsif (nr_seq_informacao_p = 111) then
	ds_atributo_w	:= 'qt_total_ent_solicitada';
	ds_descricao_w	:= wheb_mensagem_pck.get_texto(1050950);
	ds_titulo_w	:= wheb_mensagem_pck.get_texto(1050949);
	ds_tamanho_w	:= '80';
elsif (nr_seq_informacao_p = 112) then
	ds_atributo_w	:= 'vl_tributos';
	ds_descricao_w	:= wheb_mensagem_pck.get_texto(1095044);
	ds_titulo_w	:= wheb_mensagem_pck.get_texto(1095044);
	ds_tamanho_w	:= '80';	
end if;

ds_retorno_w	:= ds_atributo_w;
if (ie_informacao_p = 1) then
	ds_retorno_w	:= ds_descricao_w;
elsif (ie_informacao_p = 2) then
	ds_retorno_w	:= ds_titulo_w;
elsif (ie_informacao_p = 3) then
	ds_retorno_w	:= ds_tamanho_w;
end if;

return ds_retorno_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_inf_coluna_aprov_visao ( nr_seq_informacao_p bigint, ie_informacao_p bigint) FROM PUBLIC;

