-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_classif_custo_proc (cd_procedimento_p bigint, nr_seq_proc_interno_p bigint) RETURNS varchar AS $body$
DECLARE


cd_procedimento_w	procedimento.cd_procedimento%type;
ie_classif_custo_w	procedimento.ie_classif_custo%type;


BEGIN

cd_procedimento_w := cd_procedimento_p;

if (coalesce(cd_procedimento_p::text, '') = '') then

	select max(cd_procedimento)
	into STRICT cd_procedimento_w
	from proc_interno
	where nr_sequencia = nr_seq_proc_interno_p;

end if;

select max(ie_classif_custo)
into STRICT	ie_classif_custo_w
from	procedimento
where cd_procedimento = cd_procedimento_w
and	ie_origem_proced = 8;

return ie_classif_custo_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_classif_custo_proc (cd_procedimento_p bigint, nr_seq_proc_interno_p bigint) FROM PUBLIC;
