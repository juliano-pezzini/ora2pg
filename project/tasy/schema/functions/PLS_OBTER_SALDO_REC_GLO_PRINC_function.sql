-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION pls_obter_saldo_rec_glo_princ ( nr_seq_conta_proc_p pls_conta_proc.nr_sequencia%type, nr_seq_rec_glosa_proc_p pls_rec_glosa_proc.nr_sequencia%type) RETURNS bigint AS $body$
DECLARE


/*
A ideia dessa function teve base sobre a ideia da function PLS_OBTER_SALDO_REC_GLOSA_PROC
porém devido a quantidade de lugares onde a function em questão é utilizada, principalmente em campos
functions, foi criado essa function que será chamada na verificação de saldo do item na importação de XML
Foi feito os union all pois caso o item não possua nr_seq_proc_princ e nenhum item secundário irá retornar
o valor na primeira parte do union all, caso seja um item que não possua nr_seq_proc_princ e possua itens
secundários então irá retornar valor tanto na primeira quanto an segunda parte
*/
vl_saldo_w		double precision;
vl_glosa_w		pls_conta_proc.vl_glosa%type;
vl_acatado_w		pls_rec_glosa_proc.vl_acatado%type;


BEGIN
select	sum(vl_glosa)
into STRICT	vl_glosa_w
from (
	SELECT	coalesce(sum(vl_glosa), 0) vl_glosa
	from	pls_conta_proc
	where	nr_sequencia		= nr_seq_conta_proc_p
	
union all

	SELECT	coalesce(sum(vl_glosa), 0) vl_glosa
	from	pls_conta_proc
	where	nr_seq_proc_princ	= nr_seq_conta_proc_p) alias5;

select	sum(vl_acatado)
into STRICT	vl_acatado_w
from (
	SELECT	coalesce(sum(a.vl_acatado),0) vl_acatado
	from	pls_rec_glosa_proc a,
		pls_conta_proc b
	where	a.nr_seq_conta_proc = b.nr_sequencia
	and	b.nr_sequencia = nr_seq_conta_proc_p
	and	a.nr_sequencia <> coalesce(nr_seq_rec_glosa_proc_p, -1)
	
union all

	SELECT	coalesce(sum(a.vl_acatado),0) vl_acatado
	from	pls_rec_glosa_proc a,
		pls_conta_proc b
	where	a.nr_seq_conta_proc = b.nr_sequencia
	and	b.nr_seq_proc_princ = nr_seq_conta_proc_p
	and	a.nr_sequencia <> coalesce(nr_seq_rec_glosa_proc_p, -1)) alias7;

vl_saldo_w	:= vl_glosa_w - vl_acatado_w;

return	vl_saldo_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION pls_obter_saldo_rec_glo_princ ( nr_seq_conta_proc_p pls_conta_proc.nr_sequencia%type, nr_seq_rec_glosa_proc_p pls_rec_glosa_proc.nr_sequencia%type) FROM PUBLIC;

