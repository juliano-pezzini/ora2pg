-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION pls_obter_vl_rec_aca ( nr_seq_ref_p pls_rec_glosa_protocolo.nr_sequencia%type, ie_opcao_p text) RETURNS bigint AS $body$
DECLARE

/* +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
Finalidade: Obter o valor recusado e acatado dos protocolos do recurso de glosa
-------------------------------------------------------------------------------------------------------------------
Locais de chamada direta:
[x]  Objetos do dicionário [ ] Tasy (Delphi/Java) [  ] Portal [  ]  Relatórios [ ] Outros:
 ------------------------------------------------------------------------------------------------------------------
Pontos de atenção:

'VLR' - Valor Recusado
'VLA' - Valor Acatado
'VLD' - Valor Diferença
'QTIP' - Quantidade de itens protocolo
'QTIC' - Quantidade de itens conta
++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++ */
vl_recusado_w	pls_rec_glosa_conta.vl_total_recursado%type;
vl_acatado_w	pls_rec_glosa_conta.vl_total_acatado%type;
qt_itens_w	bigint;
ds_retorno_w	double precision;

BEGIN

select	sum(vl_total_recursado)
into STRICT	vl_recusado_w
from	pls_rec_glosa_conta
where	nr_seq_protocolo = nr_seq_ref_p;

select	sum(vl_total_acatado)
into STRICT	vl_acatado_w
from	pls_rec_glosa_conta
where	nr_seq_protocolo = nr_seq_ref_p;

if (ie_opcao_p = 'VLR') then
	ds_retorno_w := coalesce(vl_recusado_w,0);

elsif (ie_opcao_p = 'VLA') then
	ds_retorno_w := coalesce(vl_acatado_w,0);

elsif (ie_opcao_p = 'VLD') then
	ds_retorno_w := coalesce((vl_recusado_w - vl_acatado_w),0);

elsif (ie_opcao_p = 'QTIP') then
	select	coalesce(sum(qt_w),0)
	into STRICT	ds_retorno_w
	from (	SELECT	count(1) qt_w
		from	pls_rec_glosa_proc	a,
			pls_rec_glosa_conta	b
		where	b.nr_sequencia		= a.nr_seq_conta_rec
		and	b.nr_seq_protocolo	= nr_seq_ref_p
		
union all

		SELECT	count(1) qt_w
		from	pls_rec_glosa_mat	a,
			pls_rec_glosa_conta	b
		where	b.nr_sequencia		= a.nr_seq_conta_rec
		and	b.nr_seq_protocolo	= nr_seq_ref_p) alias5;

elsif (ie_opcao_p = 'QTIC') then
	select	coalesce(sum(qt_w),0)
	into STRICT	ds_retorno_w
	from (	SELECT	count(1) qt_w
		from	pls_rec_glosa_proc
		where	nr_seq_conta_rec = nr_seq_ref_p
		
union all

		SELECT	count(1) qt_w
		from	pls_rec_glosa_mat
		where	nr_seq_conta_rec = nr_seq_ref_p) alias5;

elsif (ie_opcao_p = 'VGO') then
	select	sum(vl_glosa)
	into STRICT	ds_retorno_w
	from (SELECT	sum(cp.vl_glosa) vl_glosa
		from	pls_conta_proc		cp,
			pls_rec_glosa_proc	rp,
			pls_rec_glosa_conta	rc
		where	cp.nr_sequencia		= rp.nr_seq_conta_proc
		and	rc.nr_sequencia		= rp.nr_seq_conta_rec
		and	rc.nr_seq_protocolo	= nr_seq_ref_p
		
union all

		SELECT	sum(cm.vl_glosa) vl_glosa
		from	pls_conta_mat		cm,
			pls_rec_glosa_mat	rm,
			pls_rec_glosa_conta	rc
		where	cm.nr_sequencia		= rm.nr_seq_conta_mat
		and	rc.nr_sequencia		= rm.nr_seq_conta_rec
		and	rc.nr_seq_protocolo	= nr_seq_ref_p) alias4;

elsif (ie_opcao_p = 'VLS') then
	select	sum(vl_glosa)
	into STRICT	ds_retorno_w
	from (SELECT	sum(pls_obter_saldo_rec_glosa_proc(rp.nr_seq_conta_proc, null)) vl_glosa
		from	pls_rec_glosa_proc	rp,
			pls_rec_glosa_conta	rc
		where	rc.nr_sequencia		= rp.nr_seq_conta_rec
		and	rc.nr_seq_protocolo	= nr_seq_ref_p
		
union all

		SELECT	sum(pls_obter_saldo_rec_glosa_mat(rm.nr_seq_conta_mat, null)) vl_glosa
		from	pls_rec_glosa_mat	rm,
			pls_rec_glosa_conta	rc
		where	rc.nr_sequencia		= rm.nr_seq_conta_rec
		and	rc.nr_seq_protocolo	= nr_seq_ref_p) alias6;

elsif (ie_opcao_p = 'VLP') then
	select	coalesce(sum(coalesce(ri.vl_liberado,0)),0)
	into STRICT	ds_retorno_w
	from	pls_conta_rec_resumo_item ri,
		pls_rec_glosa_conta gc
	where	gc.nr_sequencia		= ri.nr_seq_conta_rec
	and	gc.nr_seq_protocolo	= nr_seq_ref_p;

elsif (ie_opcao_p = 'VGP') then
	select	coalesce(sum(coalesce(ri.vl_glosa,0)),0)
	into STRICT	ds_retorno_w
	from	pls_conta_rec_resumo_item ri,
		pls_rec_glosa_conta gc
	where	gc.nr_sequencia		= ri.nr_seq_conta_rec
	and	gc.nr_seq_protocolo	= nr_seq_ref_p;
end if;


return	ds_retorno_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION pls_obter_vl_rec_aca ( nr_seq_ref_p pls_rec_glosa_protocolo.nr_sequencia%type, ie_opcao_p text) FROM PUBLIC;
