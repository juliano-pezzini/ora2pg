-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE pls_gerar_titulo_autorizacao ( cd_estabelecimento_p bigint, nr_seq_segurado_p bigint, nr_seq_guia_p bigint, vl_autorizacao_p bigint, nr_titulo_p INOUT bigint, nm_usuario_p text) AS $body$
DECLARE

 
cd_moeda_padrao_w		bigint;
cd_pessoa_fisica_w		varchar(10);
nr_titulo_w			bigint;
cd_portador_w			bigint;
cd_tipo_portador_w		bigint;
cd_estab_financeiro_w		bigint;

cd_tipo_taxa_juros_w		bigint	:= null;
tx_juros_w			double precision	:= null;
cd_tipo_taxa_multa_w		bigint	:= null;
tx_multa_w			double precision	:= null;
ie_origem_titulo_w		varchar(10)	:= null;
nr_seq_conta_banco_w		bigint	:= null;

nr_seq_trans_fin_baixa_w	bigint;
nr_seq_carteira_cobr_w		bigint;
			

BEGIN 
 
select	cd_moeda_padrao, 
	nr_seq_trans_fin_baixa, 
	cd_tipo_portador, 
	cd_portador 
into STRICT	cd_moeda_padrao_w, 
	nr_seq_trans_fin_baixa_w, 
	cd_tipo_portador_w, 
	cd_portador_w 
from	parametro_contas_receber 
where	cd_estabelecimento = cd_estabelecimento_p;
 
select	max(cd_pessoa_fisica) 
into STRICT	cd_pessoa_fisica_w 
from	pls_segurado 
where	nr_sequencia = nr_seq_segurado_p;
 
select	coalesce(cd_estab_financeiro, cd_estabelecimento) 
into STRICT	cd_estab_financeiro_w 
from	estabelecimento 
where	cd_estabelecimento	= cd_estabelecimento_p;
 
begin 
select	cd_tipo_taxa_juro, 
	pr_juro_padrao, 
	cd_tipo_taxa_multa, 
	pr_multa_padrao, 
	coalesce(ie_origem_titulo,3), 
	coalesce(nr_seq_conta_banco_w,nr_seq_conta_banco), 
	coalesce(cd_tipo_portador_w,cd_tipo_portador), 
	coalesce(cd_portador_w,cd_portador) 
into STRICT	cd_tipo_taxa_juros_w, 
	tx_juros_w, 
	cd_tipo_taxa_multa_w, 
	tx_multa_w, 
	ie_origem_titulo_w, 
	nr_seq_conta_banco_w, 
	cd_tipo_portador_w, 
	cd_portador_w 
from	pls_parametros 
where	cd_estabelecimento = cd_estabelecimento_p;
exception 
	when no_data_found then 
	CALL wheb_mensagem_pck.exibir_mensagem_abort(265260,'');
	--Cadastro de juros e multa não informados nos parâmetros do Plano de Saúde! 
end;
 
select	nextval('titulo_seq') 
into STRICT	nr_titulo_w
;
 
insert into titulo_receber( 
	nr_titulo, 
	cd_estabelecimento, 
	dt_atualizacao, 
	nm_usuario, 
	dt_emissao, 
	dt_vencimento, 
	dt_pagamento_previsto, 
	vl_titulo, 
	vl_saldo_titulo, 
	cd_moeda, 
	cd_portador, 
	cd_tipo_portador, 
	ie_situacao, 
	ie_tipo_emissao_titulo, 
	ie_origem_titulo, 
	ie_tipo_titulo, 
	ie_tipo_inclusao, 
	cd_pessoa_fisica, 
	cd_cgc, 
	tx_juros, 
	cd_tipo_taxa_juro, 
	tx_multa, 
	cd_tipo_taxa_multa, 
	nr_seq_conta_banco, 
	cd_estab_financeiro, 
	ds_observacao_titulo, 
	nr_seq_guia, 
	ie_pls,	 
	nr_seq_trans_fin_contab, 
	nr_seq_trans_fin_baixa, 
	nm_usuario_orig, 
	dt_inclusao, 
	vl_saldo_juros, 
	vl_saldo_multa, 
	tx_desc_antecipacao, 
	nr_seq_carteira_cobr) 
values (nr_titulo_w, 
	cd_estabelecimento_p, 
	clock_timestamp(), 
	nm_usuario_p, 
	clock_timestamp(), 
	add_months(trunc(clock_timestamp(),'dd'),1), 
	add_months(trunc(clock_timestamp(),'dd'),1), 
	vl_autorizacao_p, 
	vl_autorizacao_p, 
	cd_moeda_padrao_w, 
	cd_portador_w, 
	cd_tipo_portador_w, 
	1, 
	1, 
	9, 
	1, 
	'2', 
	cd_pessoa_fisica_w, 
	null, 
	coalesce(tx_juros_w,0), 
	coalesce(cd_tipo_taxa_juros_w,0), 
	coalesce(tx_multa_w,0), 
	coalesce(cd_tipo_taxa_multa_w,0), 
	null, 
	cd_estab_financeiro_w, 
	null, 
	nr_seq_guia_p, 
	'S', 
	nr_seq_trans_fin_baixa_w, 
	nr_seq_trans_fin_baixa_w, 
	nm_usuario_p, 
	clock_timestamp(), 
	0, 
	0, 
	0, 
	nr_seq_carteira_cobr_w);
 
commit;
 
nr_titulo_p := nr_titulo_w;
 
end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE pls_gerar_titulo_autorizacao ( cd_estabelecimento_p bigint, nr_seq_segurado_p bigint, nr_seq_guia_p bigint, vl_autorizacao_p bigint, nr_titulo_p INOUT bigint, nm_usuario_p text) FROM PUBLIC;
