-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_glosa_rep_negativo (nr_seq_proc_rep_p bigint, nr_seq_mat_rep_p bigint) RETURNS bigint AS $body$
DECLARE


vl_retorno_w	double precision;


BEGIN

vl_retorno_w		:= 0;
if (coalesce(nr_seq_proc_rep_p,0) > 0) then

	select	coalesce(sum(vl_repasse),0)
	into STRICT	vl_retorno_w
	from	procedimento_repasse
	where	nr_sequencia		= nr_seq_proc_rep_p
	and	vl_repasse		< 0
	and	IE_STATUS		= 'G';

elsif (coalesce(nr_seq_mat_rep_p,0) > 0) then

	select	coalesce(sum(vl_repasse),0)
	into STRICT	vl_retorno_w
	from	material_repasse
	where	nr_sequencia		= nr_seq_mat_rep_p
	and	vl_repasse		< 0
	and	IE_STATUS		= 'G';

end if;

return	vl_retorno_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_glosa_rep_negativo (nr_seq_proc_rep_p bigint, nr_seq_mat_rep_p bigint) FROM PUBLIC;

