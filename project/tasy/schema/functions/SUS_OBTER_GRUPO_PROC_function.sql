-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION sus_obter_grupo_proc ( cd_procedimento_p bigint, ie_origem_proced_p bigint) RETURNS bigint AS $body$
DECLARE


CD_GRUPO_PROC_w			bigint;
nr_seq_forma_org_w		bigint := 0;
nr_seq_grupo_w			bigint := 0;
nr_seq_subgrupo_w		bigint := 0;

C01 CURSOR FOR
	SELECT	CD_GRUPO_PROC
	from	sus_regra_estrut_proc a
	where	coalesce(a.nr_seq_grupo,nr_seq_grupo_w)			= nr_seq_grupo_w
	and	coalesce(a.nr_seq_subgrupo,nr_seq_subgrupo_w)		= nr_seq_subgrupo_w
	and	coalesce(a.nr_seq_forma_org,nr_seq_forma_org_w)		= nr_seq_forma_org_w
	and	coalesce(cd_procedimento, cd_procedimento_p)			= cd_procedimento_p
	and	coalesce(ie_origem_proced, ie_origem_proced_p)		= ie_origem_proced_p
	order by 	coalesce(cd_procedimento,0),
			coalesce(a.nr_seq_forma_org,0),
			coalesce(a.nr_seq_subgrupo,0),
			coalesce(a.nr_seq_grupo,0);

BEGIN

begin
select	nr_seq_forma_org,
	nr_seq_grupo,
	nr_seq_subgrupo
into STRICT	nr_seq_forma_org_w,
	nr_seq_grupo_w,
	nr_seq_subgrupo_w
from	sus_estrutura_procedimento_v a
where	a.cd_procedimento	= cd_procedimento_p
and	a.ie_origem_proced	= ie_origem_proced_p;
exception
	when others then
	null;
end;


open C01;
loop
fetch C01 into
	CD_GRUPO_PROC_w;
EXIT WHEN NOT FOUND; /* apply on C01 */
end loop;
close C01;

return	CD_GRUPO_PROC_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION sus_obter_grupo_proc ( cd_procedimento_p bigint, ie_origem_proced_p bigint) FROM PUBLIC;

