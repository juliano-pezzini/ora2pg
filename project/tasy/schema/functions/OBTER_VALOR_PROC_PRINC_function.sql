-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_valor_proc_princ (nr_interno_conta_p bigint, nr_seq_proc_princ_p bigint) RETURNS bigint AS $body$
DECLARE


retorno_w		double precision;


BEGIN
select	coalesce(sum(vl_procedimento),0) vl_procedimento
into STRICT	retorno_w
from	procedimento_paciente p
where	p.nr_seq_proc_princ	= nr_seq_proc_princ_p
and	p.nr_interno_conta = nr_interno_conta_p;

return	retorno_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_valor_proc_princ (nr_interno_conta_p bigint, nr_seq_proc_princ_p bigint) FROM PUBLIC;
