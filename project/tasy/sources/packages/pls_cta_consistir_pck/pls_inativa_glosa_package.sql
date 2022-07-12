-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';




CREATE OR REPLACE PROCEDURE pls_cta_consistir_pck.pls_inativa_glosa (nr_seq_conta_p pls_conta.nr_sequencia%type) AS $body$
DECLARE


qt_ocorrencia_w	integer;

/* Glosas */


C01 CURSOR(	nr_seq_conta_pc		pls_conta.nr_sequencia%type) FOR
	SELECT	a.nr_sequencia
	from	pls_conta_glosa	a
	where	a.nr_seq_conta	= nr_seq_conta_pc
	and	a.ie_situacao	= 'A'
	and	coalesce(nr_seq_ocorrencia_benef::text, '') = ''
	and	coalesce(a.nr_seq_conta_proc::text, '') = ''
	and	coalesce(a.nr_seq_conta_mat::text, '') = ''
	and	coalesce(a.nr_seq_proc_partic::text, '') = ''
	and (ie_lib_manual 	= 'N' 	or coalesce(ie_lib_manual::text, '') = '')
	
union all

	SELECT	a.nr_sequencia
	from	pls_conta_glosa	a,
		pls_conta_proc	b
	where	a.ie_situacao		= 'A'
	and	a.nr_seq_conta_proc	= b.nr_sequencia
	and	coalesce(nr_seq_ocorrencia_benef::text, '') = ''
	and	b.nr_seq_conta		= nr_seq_conta_pc
	and (ie_lib_manual = 'N' 	or coalesce(ie_lib_manual::text, '') = '')
	
union all

	select	a.nr_sequencia
	from	pls_conta_glosa	a,
		pls_conta_mat	b
	where	a.ie_situacao		= 'A'
	and	a.nr_seq_conta_mat	= b.nr_sequencia
	and	coalesce(nr_seq_ocorrencia_benef::text, '') = ''
	and	b.nr_seq_conta		= nr_seq_conta_pc
	and (ie_lib_manual = 'N' 	or coalesce(ie_lib_manual::text, '') = '')
	
union all

	select	a.nr_sequencia
	from	pls_conta_proc		c,
		pls_proc_participante	b,
		pls_conta_glosa		a
	where	a.ie_situacao		= 'A'
	and	a.nr_seq_proc_partic	= b.nr_sequencia
	and	coalesce(a.nr_seq_ocorrencia_benef::text, '') = ''
	and (a.ie_lib_manual 	= 'N' 	or coalesce(a.ie_lib_manual::text, '') = '')
	and	c.nr_sequencia		= b.nr_seq_conta_proc
	and	c.nr_seq_conta		= nr_seq_conta_pc;

BEGIN

for r_c01_w in C01(	nr_seq_conta_p) loop
	begin
	select	count(1)
	into STRICT	qt_ocorrencia_w
	from	pls_ocorrencia_benef x
	where	x.nr_seq_glosa = r_c01_w.nr_sequencia
	and	exists (	SELECT 	1 	
				from	pls_ocorrencia	y
				where	y.nr_sequencia	= x.nr_seq_ocorrencia
				and	y.ie_glosa	= 'S');
	
	if (qt_ocorrencia_w > 0) then
		update	pls_conta_glosa
		set	ie_situacao		= 'I',
			ie_forma_inativacao	= CASE WHEN ie_forma_inativacao='U' THEN 'US' WHEN ie_forma_inativacao='US' THEN 'US'  ELSE 'S' END
		where	nr_sequencia		= r_c01_w.nr_sequencia;
		
		update	pls_ocorrencia_benef
		set	ie_situacao		= 'I',
			ie_forma_inativacao	= CASE WHEN ie_forma_inativacao='U' THEN 'US' WHEN ie_forma_inativacao='US' THEN 'US'  ELSE 'S' END
		where	nr_seq_glosa		= r_c01_w.nr_sequencia;
	end if;
	end;
end loop;
commit;
end;
-- verifica todas as glosas que est_o habilitadas para o cliente


$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE pls_cta_consistir_pck.pls_inativa_glosa (nr_seq_conta_p pls_conta.nr_sequencia%type) FROM PUBLIC;