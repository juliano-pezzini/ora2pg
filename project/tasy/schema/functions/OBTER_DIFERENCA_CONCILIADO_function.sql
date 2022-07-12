-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_diferenca_conciliado ( nr_seq_conciliacao_p bigint) RETURNS bigint AS $body$
DECLARE


vl_banco_w		double precision;
vl_empresa_w		double precision;
vl_diferenca_w		double precision;


BEGIN

select	coalesce(sum(a.vl_transacao),0)
into STRICT	vl_banco_w
from	transacao_financeira b,
	movto_trans_financ a,
	CONCIL_BANC_PEND_TASY e
where	b.ie_banco		in ('C','D')
and	a.nr_seq_trans_financ	= b.nr_sequencia
and	e.NR_SEQ_MOVTO_TRANS	= a.nr_sequencia
and	coalesce(a.nr_seq_concil::text, '') = ''
and	coalesce(a.ie_conciliacao,'N')	= 'N'
and	e.nr_seq_conciliacao	= nr_seq_conciliacao_p;

select	coalesce(sum(a.vl_lancamento),0)
into STRICT	vl_empresa_w
from	Banco_extrato_lanc a,
	CONCIL_BANC_PEND_BCO b
where	a.ie_deb_cred		in ('C','D')
and	coalesce(a.nr_seq_concil::text, '') = ''
and	b.NR_SEQ_LANC_EXTRATO	= a.nr_sequencia
and	coalesce(a.ie_conciliacao,'N')	= 'N'
and	b.nr_seq_conciliacao	= nr_seq_conciliacao_p;

vl_diferenca_w	:= coalesce(vl_banco_w,0) - coalesce(vl_empresa_w,0);

RETURN vl_diferenca_w;

END;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_diferenca_conciliado ( nr_seq_conciliacao_p bigint) FROM PUBLIC;
