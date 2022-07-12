-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION pls_obter_qt_oc_penden_conta ( nr_seq_analise_p bigint ) RETURNS varchar AS $body$
DECLARE


qt_retorno_w	bigint;
ds_retorno_w	varchar(1) := 'N';


BEGIN

select	count(nr_sequencia)
into STRICT	qt_retorno_w
from	pls_analise_conta_item a
where (coalesce(nr_seq_conta,0) > 0)
and	((coalesce(a.nr_seq_conta_proc::text, '') = '') and (coalesce(a.nr_seq_conta_mat::text, '') = '') and (coalesce(a.nr_seq_proc_partic::text, '') = ''))
and	a.nr_seq_analise = nr_seq_analise_p
and	ie_status = 'P';

if (qt_retorno_w > 0) then
	ds_retorno_w := 'S';
end if;

return	ds_retorno_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION pls_obter_qt_oc_penden_conta ( nr_seq_analise_p bigint ) FROM PUBLIC;

