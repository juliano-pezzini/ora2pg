-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_saldo_receb_conv_fluxo ( nr_sequencia_p bigint, dt_contabil_p timestamp) RETURNS bigint AS $body$
DECLARE


vl_deposito_w		double precision;
vl_vinculado_w		double precision;
vl_saldo_w		double precision;
vl_vinculado_audit_w	double precision;
vl_recebido_bordero_w	convenio_receb_titulo.vl_recebido%type;


BEGIN

select	coalesce(max(CASE WHEN vl_deposito=0 THEN vl_recebimento  ELSE vl_deposito END ),0)
into STRICT	vl_deposito_w
from	convenio_receb
where	nr_sequencia	= nr_sequencia_p
and	coalesce(dt_fluxo_caixa,dt_recebimento)	<= fim_dia(dt_contabil_p);

select	coalesce(sum(vl_vinculacao),0)
into STRICT	vl_vinculado_w
from	convenio_retorno b,
	convenio_ret_receb a
where	a.nr_seq_receb	= nr_sequencia_p
and	a.nr_seq_retorno	= b.nr_sequencia
and	b.dt_baixa_cr	<= fim_dia(dt_contabil_p);

select	coalesce(sum(vl_vinculado),0)
into STRICT	vl_vinculado_audit_w
from	lote_audit_hist_receb
where	nr_seq_receb	= nr_sequencia_p
and	DT_ATUALIZACAO	<= fim_dia(dt_contabil_p);

/*OS 2041319 - Considerar tambem os recebimentos de convenio vinculados ao titulo no bordero*/

select	coalesce(sum(a.vl_recebido),0)
into STRICT	vl_recebido_bordero_w
from	convenio_receb_titulo a
where	a.nr_seq_receb = nr_sequencia_p
and	a.dt_atualizacao	<= fim_dia(dt_contabil_p)
and	(a.nr_bordero IS NOT NULL AND a.nr_bordero::text <> ''); --Somente deduzir itens desta tabela que possuem nr_bordero informado, senao vai deduzir indevidamente os titulos que constam nesta tabela mas que foram incluidos no processo normal quando baixa o retorno convenio
vl_saldo_w	:= vl_deposito_w - vl_vinculado_w - vl_vinculado_audit_w - vl_recebido_bordero_w;

return vl_saldo_w;

END;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_saldo_receb_conv_fluxo ( nr_sequencia_p bigint, dt_contabil_p timestamp) FROM PUBLIC;
