-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION pls_obter_se_mat_recursado ( nr_seq_conta_mat_p pls_conta_mat.nr_sequencia%type, vl_recusado_p pls_rec_glosa_mat.vl_recursado%type) RETURNS varchar AS $body$
DECLARE


qt_recurso_w		integer;
ie_retorno_w		varchar(1) := 'S';
vl_recursado_w		pls_rec_glosa_mat.vl_recursado%type;


BEGIN

select	count(1)
into STRICT	qt_recurso_w
from	pls_rec_glosa_mat
where	nr_seq_conta_mat = nr_seq_conta_mat_p;

if (qt_recurso_w = 0) then
	select	count(1)
	into STRICT	qt_recurso_w
	from	pls_rec_glosa_mat_imp
	where	nr_seq_material = nr_seq_conta_mat_p;
end if;

if (qt_recurso_w > 0) then

	ie_retorno_w := 'N';

	select	sum(vl_recusado)
	into STRICT	vl_recursado_w
	from (
		SELECT	coalesce(sum(a.vl_recursado),0) vl_recusado
		from	pls_rec_glosa_mat a
		where	a.nr_seq_conta_mat = nr_seq_conta_mat_p
		and	a.ie_status = '1'
		
union all

		SELECT	coalesce(sum(a.vl_acatado),0) vl_recusado
		from	pls_rec_glosa_mat a
		where	a.nr_seq_conta_mat = nr_seq_conta_mat_p
		and	a.ie_status in ('2','3')
		
union all

		select	coalesce(sum(a.vl_recursado),0)
		from	pls_rec_glosa_mat_imp a
		where	a.nr_seq_material = nr_seq_conta_mat_p
		and	not exists (	select	1
					from	pls_rec_glosa_mat x
					where	x.nr_seq_conta_mat_imp = a.nr_sequencia)) alias9;

	if (vl_recursado_w < vl_recusado_p) then
		ie_retorno_w := 'S';
	end if;
end if;

return ie_retorno_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION pls_obter_se_mat_recursado ( nr_seq_conta_mat_p pls_conta_mat.nr_sequencia%type, vl_recusado_p pls_rec_glosa_mat.vl_recursado%type) FROM PUBLIC;
