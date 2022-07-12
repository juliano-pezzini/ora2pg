-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION pls_obter_se_medico_nota_serv ( nr_seq_proc_p pls_conta_proc.nr_sequencia%type, nr_seq_nota_cobranca_p ptu_nota_cobranca.nr_sequencia%type) RETURNS varchar AS $body$
DECLARE


ds_retorno_w			varchar(1) := 'N';
qt_w				integer;
sg_cons_prof_prest_nota_w	ptu_nota_servico.sg_cons_prof_prest%type;
nr_cons_prof_prest_nota_w	ptu_nota_servico.nr_cons_prof_prest%type;
sg_uf_cons_prest_nota_w		ptu_nota_servico.sg_uf_cons_prest%type;


BEGIN

select	max(sg_cons_prof_prest),
	max(nr_cons_prof_prest),
	max(sg_uf_cons_prest)
into STRICT	sg_cons_prof_prest_nota_w,
	nr_cons_prof_prest_nota_w,
	sg_uf_cons_prest_nota_w
from	ptu_nota_servico	a
where	a.nr_seq_conta_proc = nr_seq_proc_p;

select	count(1)
into STRICT	qt_w
from	ptu_nota_servico	x
where	x.nr_seq_nota_cobr	= nr_seq_nota_cobranca_p
and	x.sg_cons_prof_prest	= sg_cons_prof_prest_nota_w
and	x.nr_cons_prof_prest	= nr_cons_prof_prest_nota_w
and	x.sg_uf_cons_prest	= sg_uf_cons_prest_nota_w;

if (qt_w > 0) then
	ds_retorno_w := 'S';
end if;

return	ds_retorno_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION pls_obter_se_medico_nota_serv ( nr_seq_proc_p pls_conta_proc.nr_sequencia%type, nr_seq_nota_cobranca_p ptu_nota_cobranca.nr_sequencia%type) FROM PUBLIC;
