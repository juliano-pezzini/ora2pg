-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE gerar_titulo_rec_liq_agrup (nr_seq_retorno_p bigint, nm_usuario_p text) AS $body$
DECLARE


/*
Edgar 25/06/2009, não dar commit nesta procedure
*/
BEGIN

insert into TITULO_RECEBER_LIQ_AGRUP(nr_sequencia,
	dt_atualizacao,
	nm_usuario,
	dt_atualizacao_nrec,
	nm_usuario_nrec,
	nr_titulo,
	dt_recebimento,
	cd_tipo_recebimento,
	nr_seq_trans_fin,
	nr_seq_retorno,
	nr_seq_conta_banco,
	cd_centro_custo_desc,
	nr_seq_motivo_desc,
	cd_moeda,
	vl_recebido,
	vl_descontos,
	vl_juros,
	vl_multa,
	vl_rec_maior,
	vl_glosa,
	vl_despesa_bancaria,
	vl_adequado,
	vl_perdas,
	vl_outros_acrescimos,
	vl_nota_credito)
SELECT	nextval('titulo_receber_liq_agrup_seq'),
	clock_timestamp(),
	nm_usuario_p,
	clock_timestamp(),
	nm_usuario_p,
	nr_titulo,
	dt_recebimento,
	cd_tipo_recebimento,
	nr_seq_trans_fin,
	nr_seq_retorno,
	nr_seq_conta_banco,
	cd_centro_custo_desc,
	nr_seq_motivo_desc,
	cd_moeda,
	vl_recebido,
	vl_descontos,
	vl_juros,
	vl_multa,
	vl_rec_maior,
	vl_glosa,
	vl_despesa_bancaria,
	vl_adequado,
	vl_perdas,
	vl_outros_acrescimos,
	vl_nota_credito
from (select	a.nr_titulo,
	trunc(a.dt_recebimento, 'dd') dt_recebimento,
	a.cd_tipo_recebimento,
	a.nr_seq_trans_fin,
	a.nr_seq_retorno,
	a.nr_seq_conta_banco,
	a.cd_centro_custo_desc,
	a.nr_seq_motivo_desc,
	a.cd_moeda,
	sum(coalesce(a.vl_recebido,0)) vl_recebido,
	sum(coalesce(a.vl_descontos,0)) vl_descontos,
	sum(coalesce(a.vl_juros,0)) vl_juros,
	sum(coalesce(a.vl_multa,0)) vl_multa,
	sum(coalesce(a.vl_rec_maior,0)) vl_rec_maior,
	sum(coalesce(a.vl_glosa,0)) vl_glosa,
	sum(coalesce(a.vl_despesa_bancaria,0)) vl_despesa_bancaria,
	sum(coalesce(a.vl_adequado,0)) vl_adequado,
	sum(coalesce(a.vl_perdas,0)) vl_perdas,
	sum(coalesce(a.vl_outros_acrescimos,0)) vl_outros_acrescimos,
	sum(coalesce(a.vl_nota_credito,0)) vl_nota_credito
from	titulo_receber_liq a
where	a.nr_seq_retorno		= nr_seq_retorno_p
and	not exists (	select	1
			from	titulo_receber_liq_desc x
			where	x.nr_titulo	= a.nr_titulo
			and	x.nr_seq_liq	= a.nr_sequencia)
group 	by nr_titulo,
	trunc(a.dt_recebimento, 'dd'),
	a.cd_tipo_recebimento,
	a.nr_seq_trans_fin,
	a.nr_seq_retorno,
	a.nr_seq_conta_banco,
	a.cd_centro_custo_desc,
	a.nr_seq_motivo_desc,
	a.cd_moeda) alias29;

insert into TITULO_RECEBER_LIQ_AGRUP(nr_sequencia,
	dt_atualizacao,
	nm_usuario,
	dt_atualizacao_nrec,
	nm_usuario_nrec,
	nr_titulo,
	dt_recebimento,
	cd_tipo_recebimento,
	nr_seq_trans_fin,
	nr_seq_retorno,
	nr_seq_conta_banco,
	cd_centro_custo_desc,
	nr_seq_motivo_desc,
	cd_moeda,
	vl_recebido,
	vl_descontos,
	vl_juros,
	vl_multa,
	vl_rec_maior,
	vl_glosa,
	vl_despesa_bancaria,
	vl_adequado,
	vl_perdas,
	vl_outros_acrescimos,
	nr_seq_liq,
	vl_nota_credito)
SELECT	nextval('titulo_receber_liq_agrup_seq'),
	clock_timestamp(),
	nm_usuario_p,
	clock_timestamp(),
	nm_usuario_p,
	a.nr_titulo,
	trunc(a.dt_recebimento, 'dd') dt_recebimento,
	a.cd_tipo_recebimento,
	a.nr_seq_trans_fin,
	a.nr_seq_retorno,
	a.nr_seq_conta_banco,
	a.cd_centro_custo_desc,
	a.nr_seq_motivo_desc,
	a.cd_moeda,
	coalesce(a.vl_recebido,0),
	coalesce(a.vl_descontos,0),
	coalesce(a.vl_juros,0),
	coalesce(a.vl_multa,0),
	coalesce(a.vl_rec_maior,0),
	coalesce(a.vl_glosa,0),
	coalesce(a.vl_despesa_bancaria,0),
	coalesce(a.vl_adequado,0),
	coalesce(a.vl_perdas,0),
	coalesce(a.vl_outros_acrescimos,0),
	a.nr_sequencia,
	coalesce(a.vl_nota_credito,0)
from	titulo_receber_liq a
where	a.nr_seq_retorno		= nr_seq_retorno_p
and	exists (	select	1
			from	titulo_receber_liq_desc x
			where	x.nr_titulo	= a.nr_titulo
			and	x.nr_seq_liq	= a.nr_sequencia);



end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE gerar_titulo_rec_liq_agrup (nr_seq_retorno_p bigint, nm_usuario_p text) FROM PUBLIC;

