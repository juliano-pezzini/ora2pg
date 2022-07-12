-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION pls_obter_qt_rec_glosa_imp ( nr_seq_motivo_glosa_p bigint, nr_seq_conta_imp_p bigint, ie_tipo_p text) RETURNS bigint AS $body$
DECLARE


qt_registros_w		integer := 0;


BEGIN

if (ie_tipo_p = 'M') then
	select	count(1)
	into STRICT	qt_registros_w
	from	pls_rec_glosa_mat_imp x,
		pls_rec_retorno_glosa y
	where	x.nr_seq_conta_imp	= y.nr_seq_conta_imp
	and	y.nr_seq_mat_imp 	= x.nr_sequencia
	and	y.nr_seq_motivo_glosa  = nr_seq_motivo_glosa_p
	and 	y.nr_seq_conta_imp 	= nr_seq_conta_imp_p;
elsif (ie_tipo_p = 'P') then
	select	count(1)
	into STRICT	qt_registros_w
	from	pls_rec_glosa_proc_imp x,
		pls_rec_retorno_glosa y
	where	x.nr_seq_conta_imp	= y.nr_seq_conta_imp
	and	y.nr_seq_proc_imp 	= x.nr_sequencia
	and	y.nr_seq_motivo_glosa  = nr_seq_motivo_glosa_p
	and 	y.nr_seq_conta_imp 	= nr_seq_conta_imp_p;
end if;

return	qt_registros_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION pls_obter_qt_rec_glosa_imp ( nr_seq_motivo_glosa_p bigint, nr_seq_conta_imp_p bigint, ie_tipo_p text) FROM PUBLIC;

