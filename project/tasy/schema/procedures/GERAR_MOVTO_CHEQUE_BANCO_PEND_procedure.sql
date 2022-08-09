-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE gerar_movto_cheque_banco_pend (cd_estabelecimento_p bigint, nr_seq_movto_pend_baixa_p bigint, nr_seq_trans_financ_p bigint, nm_usuario_p text, ie_acao_p text) AS $body$
DECLARE

 
/* 
ie_acao_p 
B - Baixa 
E - Estorno 
*/
					 
					 
nr_sequencia_w			bigint;
nr_seq_cheque_w			bigint;
nr_seq_baixa_estorno_w		bigint;
nr_seq_movto_trans_fin_w	bigint;


BEGIN 
 
if (coalesce(ie_acao_p,'B') = 'B') then 
 
	select	nextval('movto_trans_financ_seq') 
	into STRICT	nr_sequencia_w 
	;
 
	insert	into movto_trans_financ(dt_atualizacao, 
		dt_transacao, 
		ie_conciliacao, 
		nm_usuario, 
		nr_lote_contabil, 
		nr_seq_banco, 
		nr_seq_trans_financ, 
		nr_sequencia, 
		vl_transacao, 
		nr_seq_cheque, 
		vl_transacao_estrang, 
		vl_complemento, 
		vl_cotacao, 
		cd_moeda) 
	SELECT	clock_timestamp(), 
		b.dt_baixa, 
		'N', 
		nm_usuario_p, 
		0, 
		a.nr_seq_conta_banco, 
		nr_seq_trans_financ_p, 
		nr_sequencia_w, 
		b.vl_baixa, 
		b.nr_seq_cheque, 
		CASE WHEN coalesce(b.vl_baixa_estrang::text, '') = '' THEN null  ELSE b.vl_baixa_estrang END , -- Projeto Multimoeda - insere os valores quando moeda estrangeira 
		CASE WHEN coalesce(b.vl_baixa_estrang::text, '') = '' THEN null  ELSE (b.vl_baixa - b.vl_baixa_estrang) END , 
		CASE WHEN coalesce(b.vl_baixa_estrang::text, '') = '' THEN null  ELSE b.vl_cotacao END , 
		CASE WHEN coalesce(b.vl_baixa_estrang::text, '') = '' THEN null  ELSE b.cd_moeda END  
	from	movto_banco_pend a, 
		movto_banco_pend_baixa b 
	where	a.nr_sequencia	= b.nr_seq_movto_pend 
	and	b.nr_sequencia	= nr_seq_movto_pend_baixa_p;
 
	CALL Atualizar_Transacao_Financeira(cd_estabelecimento_p,nr_sequencia_w,nm_usuario_p,'I');
 
	select	max(nr_seq_cheque) 
	into STRICT	nr_seq_cheque_w 
	from	movto_trans_financ 
	where	nr_sequencia		= nr_sequencia_w;
 
	update	cheque_cr 
	set	dt_devolucao		 = NULL 
	where	nr_seq_cheque		= nr_seq_cheque_w;
 
elsif (coalesce(ie_acao_p,'B') = 'E') then 
 
	select	max(b.nr_sequencia) 
	into STRICT	nr_seq_movto_trans_fin_w 
	from	movto_banco_pend_baixa a, 
		movto_trans_financ b, 
		movto_banco_pend d, 
		transacao_financeira c 
	where	a.nr_seq_cheque			= b.nr_seq_cheque 
	and	d.nr_sequencia			= a.nr_seq_movto_pend 
	and	d.nr_seq_conta_banco		= b.nr_seq_banco 
	and	trunc(a.dt_baixa)		= trunc(b.dt_transacao) 
	and	b.nr_seq_trans_financ		= c.nr_sequencia 
	and	a.nr_sequencia			= nr_seq_movto_pend_baixa_p 
	and	c.ie_acao 			= 30;
	 
	if (nr_seq_movto_trans_fin_w IS NOT NULL AND nr_seq_movto_trans_fin_w::text <> '') then 
	 
		CALL estornar_movto_banco(cd_estabelecimento_p,nr_seq_movto_trans_fin_w,clock_timestamp(),nm_usuario_p,'S');
	 
	end if;
	 
end if;
 
commit;
 
end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE gerar_movto_cheque_banco_pend (cd_estabelecimento_p bigint, nr_seq_movto_pend_baixa_p bigint, nr_seq_trans_financ_p bigint, nm_usuario_p text, ie_acao_p text) FROM PUBLIC;
