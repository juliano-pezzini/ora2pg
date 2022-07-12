-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION atepaclp_se_dupla_reval (nr_seq_reval_rule_p bigint, cd_material_p bigint) RETURNS varchar AS $body$
DECLARE


ds_retorno_w			varchar(1) := 'N';

cd_grupo_material_w		estrutura_material_v.cd_grupo_material%type;
cd_subgrupo_material_w	estrutura_material_v.cd_subgrupo_material%type;
cd_classe_material_w	estrutura_material_v.cd_classe_material%type;
ie_possui_registro varchar(1);


BEGIN

if (cd_material_p IS NOT NULL AND cd_material_p::text <> '') then
  select coalesce(max('S'), 'N')
  into STRICT ie_possui_registro
  from CPOE_REVALIDATION_DOUBLE
  where NR_SEQ_CPOE_RELAVIDATION = nr_seq_reval_rule_p;
  if (ie_possui_registro = 'S') then
    select 	max(cd_grupo_material),
        max(cd_subgrupo_material),
        max(cd_classe_material)
    into STRICT	cd_grupo_material_w,
        cd_subgrupo_material_w,
        cd_classe_material_w
    from 	estrutura_material_v
    where	cd_material = cd_material_p;

    select coalesce(max('S'), 'N')
    into STRICT	ds_retorno_w
    from	cpoe_revalidation_double
    where	nr_seq_cpoe_relavidation = nr_seq_reval_rule_p
    and		(((cd_material = cd_material_p and (cd_material IS NOT NULL AND cd_material::text <> '')) or coalesce(cd_material::text, '') = '')  and
        ((cd_grupo_material = cd_grupo_material_w and (cd_grupo_material IS NOT NULL AND cd_grupo_material::text <> '')) or coalesce(cd_grupo_material::text, '') = '')  and
        ((cd_subgrupo_material = cd_subgrupo_material_w and (cd_subgrupo_material IS NOT NULL AND cd_subgrupo_material::text <> '')) or coalesce(cd_subgrupo_material::text, '') = '')  and
        ((cd_classe_material = cd_classe_material_w and (cd_classe_material IS NOT NULL AND cd_classe_material::text <> '')) or coalesce(cd_classe_material::text, '') = ''));
  end if;
  if (ie_possui_registro = 'N') then
    ds_retorno_w := 'S';
  end if;

end if;

return ds_retorno_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION atepaclp_se_dupla_reval (nr_seq_reval_rule_p bigint, cd_material_p bigint) FROM PUBLIC;

