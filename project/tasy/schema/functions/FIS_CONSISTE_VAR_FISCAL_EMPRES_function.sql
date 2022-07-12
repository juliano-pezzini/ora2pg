-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION fis_consiste_var_fiscal_empres ( cd_material_p bigint, nr_emprestimo_p bigint, cd_operacao_nf_p bigint) RETURNS bigint AS $body$
DECLARE

cd_grupo_material_w		bigint;
cd_subgrupo_material_w		bigint;
cd_classe_material_w		bigint;
ie_tipo_material_w			varchar(10);
cd_pessoa_fisica_w		varchar(10);
cd_cgc_w			varchar(15);
sg_estado_w			compl_pessoa_fisica.sg_estado%type;
qt_registro_w			bigint;
			
 

BEGIN 
 
select	v.cd_grupo_material, 
	v.cd_subgrupo_material, 
	v.cd_classe_material, 
	coalesce(fis_obter_tipo_mat_fiscal(m.ie_tipo_material),'M') 
into STRICT	cd_grupo_material_w, 
	cd_subgrupo_material_w, 
	cd_classe_material_w, 
	ie_tipo_material_w 
from	material m, 
	estrutura_material_v v 
where	m.cd_material = v.cd_material 
and	m.cd_material = cd_material_p;
 
 
select	cd_pessoa_fisica, 
	cd_pessoa_juridica, 
	obter_dados_pf_pj(cd_pessoa_fisica,cd_pessoa_juridica,'UF') 
into STRICT	cd_pessoa_fisica_w, 
	cd_cgc_w, 
	sg_estado_w 
from	emprestimo 
where	nr_emprestimo = nr_emprestimo_p;
 
 
select 	count(*) 
into STRICT	qt_registro_w 
from	fis_variacao_fiscal 
where	dt_inicio_vigencia <= clock_timestamp() 
and	dt_fim_vigencia >= clock_timestamp() 
and	( 
	(cd_pessoa_fisica 	= cd_pessoa_fisica_w) or (coalesce(cd_pessoa_fisica::text, '') = '')) 
and	((cd_cnpj 		= cd_cgc_w) or (coalesce(cd_cnpj::text, '') = '')) 
and	((cd_material 		= cd_material_p) or (coalesce(cd_material::text, '') = '')) 
and	((cd_grupo_material 	= cd_grupo_material_w) or (coalesce(cd_grupo_material::text, '') = '')) 
and	((cd_subgrupo_material 	= cd_subgrupo_material_w) or (coalesce(cd_subgrupo_material::text, '') = '')) 
and	((cd_classe_material 	= cd_classe_material_w) or (coalesce(cd_classe_material::text, '') = '')) 
and	((cd_tipo_material 	= ie_tipo_material_w) or (coalesce(cd_tipo_material::text, '') = '')) 
and	((cd_operacao_nf 	= cd_operacao_nf_p) or (coalesce(cd_operacao_nf::text, '') = '')) 
and	((sg_estado 		= sg_estado_w) or (coalesce(sg_estado::text, '') = '')) 
and	ie_situacao = 'A' 
order by cd_pessoa_fisica,cd_cnpj,cd_material,sg_estado;
 
return	qt_registro_w;
 
end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION fis_consiste_var_fiscal_empres ( cd_material_p bigint, nr_emprestimo_p bigint, cd_operacao_nf_p bigint) FROM PUBLIC;

