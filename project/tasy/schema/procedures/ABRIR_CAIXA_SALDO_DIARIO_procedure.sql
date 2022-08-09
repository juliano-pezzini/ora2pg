-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE abrir_caixa_saldo_diario (nr_seq_caixa_p bigint, dt_saldo_p timestamp, nm_usuario_p text, nr_seq_saldo_p INOUT bigint) AS $body$
DECLARE


nr_seq_caixa_saldo_w	bigint;
vl_saldo_w		double precision;
vl_cheque_pre_w		double precision;
vl_cartao_cr_w		double precision;
vl_cheque_vista_w	double precision;
vl_especie_w		double precision;
vl_saldo_vista_w	double precision;
vl_saldo_sem_desp_w	double precision;
ie_caixa_estrang_w	varchar(1);


BEGIN

nr_seq_saldo_p := 0;

/* Projeto Multimoeda - Verifica se o caixa permite moeda estrangeira, caso positivo valida a cotação antes de abrir o saldo. */

ie_caixa_estrang_w := substr(obter_se_caixa_estrang(nr_seq_caixa_p),0,1);
if (ie_caixa_estrang_w = 'S') then
	if (substr(verifica_cotacao_moeda_caixa(nr_seq_caixa_p,dt_saldo_p),0,1) = 'N') then
		--Não existe cotação cadastrada nesta data para as moedas liberadas para este caixa.
		CALL wheb_mensagem_pck.exibir_mensagem_abort(443457);
	end if;
end if;

begin
	select	coalesce(sum(vl_saldo),0) vl_saldo,
		coalesce(sum(vl_cheque_pre_atual),0) vl_cheque_pre_atual,
		coalesce(sum(vl_cartao_cr_atual),0) vl_cartao_cr_atual,
		coalesce(sum(vl_cheque_vista_atual),0) vl_cheque_vista_atual,
		coalesce(sum(vl_especie_atual),0) vl_especie_atual,
		coalesce(sum(vl_saldo_avista),0) vl_saldo_avista,
		coalesce(sum(vl_saldo_sem_desp_cartao),0) vl_saldo_sem_desp_cartao
	into STRICT	vl_saldo_w,
		vl_cheque_pre_w,
		vl_cartao_cr_w,
		vl_cheque_vista_w,
		vl_especie_w,
		vl_saldo_vista_w,
		vl_saldo_sem_desp_w
	from	caixa_saldo_diario
	where	nr_seq_caixa	= nr_seq_caixa_p
	and	dt_saldo	= (	SELECT max(x.dt_saldo)
				from caixa_saldo_diario x
				where x.nr_seq_caixa = nr_seq_caixa_p);
exception when others then
	vl_saldo_w := 0;
	vl_cheque_pre_w := 0;
	vl_cartao_cr_w := 0;
	vl_cheque_vista_w := 0;
	vl_especie_w := 0;
	vl_saldo_vista_w := 0;
	vl_saldo_sem_desp_w := 0;
end;

select	nextval('caixa_saldo_diario_seq')
into STRICT	nr_seq_caixa_saldo_w
;

begin
	insert into caixa_saldo_diario(nr_sequencia,
		nr_seq_caixa,
		dt_atualizacao,
		nm_usuario,
		nr_lote_contabil,
		dt_saldo,
		vl_saldo,
		vl_saldo_inicial,
		vl_cheque_pre_inicial,
		vl_cheque_pre_atual,
		vl_cartao_cr_inicial,
		vl_cartao_cr_atual,
		vl_saldo_avista,
		vl_cheque_vista_inicial,
		vl_cheque_vista_atual,
		vl_especie_inicial,
		vl_especie_atual,
		vl_saldo_sem_desp_cartao)
	values (nr_seq_caixa_saldo_w,
		nr_seq_caixa_p,
		clock_timestamp(),
		nm_usuario_p,
		0,
		dt_saldo_p,
		coalesce(vl_saldo_w,0),
		coalesce(vl_saldo_w,0),
		coalesce(vl_cheque_pre_w,0),
		coalesce(vl_cheque_pre_w,0),
		coalesce(vl_cartao_cr_w,0),
		coalesce(vl_cartao_cr_w,0),
		coalesce(vl_saldo_vista_w,0),
		coalesce(vl_cheque_vista_w,0),
		coalesce(vl_cheque_vista_w,0),
		coalesce(vl_especie_w,0),
		coalesce(vl_especie_w,0),
		coalesce(vl_saldo_sem_desp_w,0));

	commit;

	if (ie_caixa_estrang_w = 'S') then
		abrir_caixa_saldo_estrang(nr_seq_caixa_p,
					nr_seq_caixa_saldo_w,
					dt_saldo_p,
					nm_usuario_p);
	end if;

	nr_seq_saldo_p := coalesce(nr_seq_caixa_saldo_w,0);
exception when others then
	nr_seq_saldo_p := 0;
end;



end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE abrir_caixa_saldo_diario (nr_seq_caixa_p bigint, dt_saldo_p timestamp, nm_usuario_p text, nr_seq_saldo_p INOUT bigint) FROM PUBLIC;
