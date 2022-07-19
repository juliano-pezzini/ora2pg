-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE pls_fechar_lote_reaj_quota (nr_seq_lote_reaj_quota_p pls_lote_reaj_quota.nr_sequencia%type, nm_usuario_p usuario.nm_usuario%type) AS $body$
DECLARE

									 
nr_titulo_w			titulo_receber.nr_titulo%type;
vl_saldo_titulo_w		titulo_receber.vl_saldo_titulo%type;
nr_seq_trans_fin_reaj_w		pls_parametro_escrit_quota.nr_seq_trans_fin_reaj%type;
cd_moeda_w			alteracao_valor.cd_moeda%type;
nr_seq_alt_valor_w		alteracao_valor.nr_sequencia%type;
cd_estabelecimento_w		estabelecimento.cd_estabelecimento%type;

C01 CURSOR(nr_seq_lote_reaj_quota_cp	pls_reaj_quota_parc.nr_seq_lote%type) FOR 
SELECT	nr_sequencia, 
	vl_parcela_reajuste, 
	nr_seq_quota_parc 
from	pls_reaj_quota_parc 
where	nr_seq_lote = nr_seq_lote_reaj_quota_cp;
	
BEGIN 
 
select	max(cd_estabelecimento) 
into STRICT	cd_estabelecimento_w 
from	pls_lote_reaj_quota 
where	nr_sequencia	= nr_seq_lote_reaj_quota_p;
 
for	r_c01_w in c01(nr_seq_lote_reaj_quota_p) loop 
 
	select	max(nr_titulo) 
	into STRICT	nr_titulo_w 
	from	pls_escrit_quota_parcela 
	where	nr_sequencia	= r_c01_w.nr_seq_quota_parc;
 
	select	vl_saldo_titulo 
	into STRICT	vl_saldo_titulo_w 
	from	titulo_receber 
	where	nr_titulo	= nr_titulo_w;
 
	select	max(nr_seq_trans_fin_reaj) 
	into STRICT	nr_seq_trans_fin_reaj_w 
	from	pls_parametro_escrit_quota 
	where	cd_estabelecimento	= cd_estabelecimento_w;
 
	cd_moeda_w	:= Obter_Moeda_Padrao(cd_estabelecimento_w,'R');
	 
	select	coalesce(max(nr_sequencia),0) + 1 
	into STRICT	nr_seq_alt_valor_w 
	from	alteracao_valor 
	where	nr_titulo	= nr_titulo_w;
 
	insert into alteracao_valor(nr_titulo, 
		ds_observacao, 
		nr_sequencia, 
		dt_alteracao, 
		dt_atualizacao, 
		vl_anterior, 
		vl_alteracao, 
		cd_motivo, 
		cd_moeda, 
		ie_aumenta_diminui, 
		nm_usuario, 
		nr_seq_trans_fin) 
	values (nr_titulo_w, 
		'Reajuste de escrituração de quotas', 
		nr_seq_alt_valor_w, 
		clock_timestamp(), 
		clock_timestamp(), 
		vl_saldo_titulo_w, 
		r_c01_w.vl_parcela_reajuste, 
		2, 
		cd_moeda_w, 
		'A', 
		nm_usuario_p, 
		nr_seq_trans_fin_reaj_w);
 
	CALL Atualizar_Saldo_Tit_Rec(nr_titulo_w,nm_usuario_p);
	 
end loop;
		 
update pls_lote_reaj_quota 
set  dt_fechamento = clock_timestamp() 
where nr_sequencia = nr_seq_lote_reaj_quota_p;
 
commit;
 
end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE pls_fechar_lote_reaj_quota (nr_seq_lote_reaj_quota_p pls_lote_reaj_quota.nr_sequencia%type, nm_usuario_p usuario.nm_usuario%type) FROM PUBLIC;

