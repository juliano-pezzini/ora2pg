-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION sus_obter_nivel_apur_fpo ( cd_procedimento_p bigint, ie_origem_proced_p bigint) RETURNS varchar AS $body$
DECLARE


nr_seq_grupo_w			bigint;
nr_seq_subgrupo_w		bigint;
nr_seq_forma_org_w		bigint;
cd_registro_w			smallint;
ie_nivel_apur_fpo_w		varchar(15);


BEGIN

begin
select	nr_seq_grupo,
	nr_seq_subgrupo,
	nr_seq_forma_org
into STRICT	nr_seq_grupo_w,
	nr_seq_subgrupo_w,
	nr_seq_forma_org_w
from	sus_estrutura_procedimento_v
where	cd_procedimento	= cd_procedimento_p
and	ie_origem_proced	= ie_origem_proced_p;
exception
when others then
	ie_nivel_apur_fpo_w := null;
end;

begin
select	ie_nivel_apur_fpo
into STRICT	ie_nivel_apur_fpo_w
from	sus_regra_nivel_apur_fpo
where	ie_situacao = 'A'
and	coalesce(nr_seq_grupo,nr_seq_grupo_w) 		= nr_seq_grupo_w
and	coalesce(nr_seq_subgrupo,nr_seq_subgrupo_w) 	= nr_seq_subgrupo_w
and	coalesce(nr_seq_forma_org,nr_seq_forma_org_w)	= nr_seq_forma_org_w
and	((coalesce(cd_registro::text, '') = '') or (cd_registro in (	SELECT cd_registro
			from 	sus_procedimento_registro
			where	cd_procedimento	= cd_procedimento_p
			and	ie_origem_proced	= ie_origem_proced_p)));
exception
when others then
	ie_nivel_apur_fpo_w := null;
end;

return ie_nivel_apur_fpo_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION sus_obter_nivel_apur_fpo ( cd_procedimento_p bigint, ie_origem_proced_p bigint) FROM PUBLIC;
