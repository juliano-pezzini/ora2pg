-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_glosa_ant_lote_guia ( nr_seq_lote_guia_p bigint) RETURNS bigint AS $body$
DECLARE


vl_retorno_w		double precision;
nr_seq_lote_w		bigint;
nr_analise_w		bigint;
nr_interno_conta_w	bigint;
cd_autorizacao_w		varchar(20);


BEGIN

select	a.nr_seq_lote_audit,
	a.nr_analise,
	b.nr_interno_conta,
	b.cd_autorizacao
into STRICT	nr_seq_lote_w,
	nr_analise_w,
	nr_interno_conta_w,
	cd_autorizacao_w
from	lote_audit_hist a,
	lote_audit_hist_guia b
where	b.nr_seq_lote_hist	= a.nr_sequencia
and	b.nr_sequencia		= nr_seq_lote_guia_p;

select	coalesce(sum(c.vl_glosa),0)
into STRICT	vl_retorno_w
from	lote_audit_hist_item c,
	lote_audit_hist_guia b,
	lote_audit_hist a
where	b.nr_sequencia		= c.nr_seq_guia
and (coalesce(b.cd_autorizacao::text, '') = '' or b.cd_autorizacao = cd_autorizacao_w)
and	b.nr_interno_conta	= nr_interno_conta_w
and	a.nr_sequencia		= b.nr_seq_lote_hist
and	a.nr_analise		< nr_analise_w
and	a.nr_seq_lote_audit	= nr_seq_lote_w;

return	vl_retorno_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_glosa_ant_lote_guia ( nr_seq_lote_guia_p bigint) FROM PUBLIC;

