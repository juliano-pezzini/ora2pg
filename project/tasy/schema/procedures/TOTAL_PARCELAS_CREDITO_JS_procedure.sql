-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE total_parcelas_credito_js ( nr_resumo_p bigint, nr_seq_grupo_p bigint, vl_conciliar_p INOUT text, vl_saldo_p INOUT text, vl_total_p INOUT text) AS $body$
DECLARE


vl_nao_conciliado_w	double precision;
vl_conciliado_w		double precision;
vl_conciliar_w		double precision;
vl_saldo_w		double precision;
vl_total_w		double precision;


BEGIN
select 	coalesce(sum(CASE WHEN coalesce(a.nr_seq_extrato_parcela::text, '') = '' THEN a.vl_parcela  ELSE 0 END ),0) vl_nao_conciliado,
	coalesce(sum(CASE WHEN coalesce(a.nr_seq_extrato_parcela::text, '') = '' THEN 0  ELSE a.vl_parcela END ),0) vl_conciliado,
	coalesce(sum(a.vl_saldo_concil_cred),0) vl_saldo,
	coalesce(sum(a.vl_aconciliar),0) vl_conciliar
into STRICT	vl_nao_conciliado_w,
	vl_conciliado_w,
	vl_saldo_w,
	vl_conciliar_w
from 	extrato_cartao_cr_movto a
where 	nr_resumo = nr_resumo_p
and 	exists (SELECT 1
	from 	extrato_cartao_cr_arq x,
		extrato_cartao_cr y
	where 	x.nr_sequencia  = a.nr_seq_extrato_arq
	and 	y.nr_sequencia    = x.nr_seq_extrato
	and 	y.nr_seq_grupo    = nr_seq_grupo_p
	and 	x.ie_tipo_arquivo = 'C'
	and 	(x.dt_conciliacao IS NOT NULL AND x.dt_conciliacao::text <> ''));
vl_total_w		:=	vl_nao_conciliado_w + vl_conciliado_w;
vl_conciliar_p		:=	campo_mascara_virgula(vl_conciliar_w);
vl_saldo_p		:=	campo_mascara_virgula(vl_saldo_w);
vl_total_p			:=	campo_mascara_virgula(vl_total_w);
end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE total_parcelas_credito_js ( nr_resumo_p bigint, nr_seq_grupo_p bigint, vl_conciliar_p INOUT text, vl_saldo_p INOUT text, vl_total_p INOUT text) FROM PUBLIC;

