-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION tiss_obter_regra_codigo_desp (cd_estabelecimento_p bigint, cd_convenio_p bigint, ie_tiss_tipo_despesa_p text, cd_itemp_p text, cd_material_p bigint, ie_codigo_tuss_p text, nr_seq_tiss_tabela_p bigint, ie_origem_preco_mat_p bigint default null, cd_procedimento_p bigint default null, ie_origem_proced_p bigint default null) RETURNS varchar AS $body$
DECLARE

	
ie_digitos_desp_w	varchar(10);
cd_procedimento_w	varchar(255);
cd_material_w		bigint;
cd_grupo_material_w	smallint;
cd_subgrupo_material_w	integer;
cd_classe_material_w	integer;
ds_versao_w		varchar(20);
ds_valor_adicional_w	varchar(10);
cd_area_procedimento_w	bigint;
cd_especialidade_w	bigint;
cd_grupo_proc_w		bigint;
	
c01 CURSOR FOR
SELECT	ie_digitos_desp,
	ds_valor_adicional
from	tiss_regra_codigo_desp
where	cd_estabelecimento						= cd_estabelecimento_p
and	coalesce(cd_convenio,coalesce(cd_convenio_p,0))				= coalesce(cd_convenio_p,0)
and	(((obter_se_projeto_versao(0,12,ds_versao_w,0) = 'N') and (coalesce(ie_tiss_tipo_despesa,coalesce(ie_tiss_tipo_despesa_p,'0'))	= coalesce(ie_tiss_tipo_despesa_p,'0'))) or
	 ((obter_se_projeto_versao(0,12,ds_versao_w,0) = 'S') and (coalesce(ie_tiss_tipo_desp_novo,coalesce(ie_tiss_tipo_despesa_p,'0'))	= coalesce(ie_tiss_tipo_despesa_p,'0')))
	)
and	coalesce(cd_material,coalesce(cd_material_p,0))				= coalesce(cd_material_p,0)
and	coalesce(cd_grupo_material,coalesce(cd_grupo_material_w,0))		= coalesce(cd_grupo_material_w,0)
and	coalesce(cd_subgrupo_material,coalesce(cd_subgrupo_material_w,0))		= coalesce(cd_subgrupo_material_w,0)
and	coalesce(cd_classe_material,coalesce(cd_classe_material_w,0))		= coalesce(cd_classe_material_w,0)
and	coalesce(nr_seq_tiss_tabela,coalesce(nr_seq_tiss_tabela_p,0))		= coalesce(nr_seq_tiss_tabela_p,0)
and	coalesce(ie_origem_preco_mat,coalesce(ie_origem_preco_mat_p,0))		= coalesce(ie_origem_preco_mat_p,0)
and	coalesce(cd_area_procedimento, coalesce(cd_area_procedimento_w,0))	= coalesce(cd_area_procedimento_w,0)
and	coalesce(cd_especialidade, coalesce(cd_especialidade_w,0))		= coalesce(cd_especialidade_w,0)
and	coalesce(cd_grupo_proc, coalesce(cd_grupo_proc_w,0))			= coalesce(cd_grupo_proc_w,0)
and	coalesce(cd_procedimento, coalesce(cd_procedimento_p,0))			= coalesce(cd_procedimento_p,0)
and	((ie_codigo_tuss in ('S','A') and coalesce(ie_codigo_tuss_p,'N') = 'S') or (ie_codigo_tuss in ('N','A') and coalesce(ie_codigo_tuss_p,'N') = 'N'))
order by coalesce(cd_convenio,0),
	coalesce(ie_tiss_tipo_despesa,'0'),
	coalesce(cd_material,0),
	coalesce(cd_classe_material,0),
	coalesce(cd_subgrupo_material,0),
	coalesce(cd_grupo_material,0),
	coalesce(ie_tiss_tipo_desp_novo,'0'),
	coalesce(nr_seq_tiss_tabela,0),
	ie_codigo_tuss,
	coalesce(ie_origem_preco_mat,0),
	coalesce(cd_procedimento,0),
	coalesce(cd_grupo_proc,0),
	coalesce(cd_especialidade,0),
	coalesce(cd_area_procedimento,0);
	

BEGIN

select	coalesce(max(tiss_obter_versao(cd_convenio_p,cd_estabelecimento_p)),'2.02.03')
into STRICT	ds_versao_w
;

if (cd_material_p IS NOT NULL AND cd_material_p::text <> '') then

	select	max(cd_grupo_material),
		max(cd_subgrupo_material),
		max(cd_classe_material)
	into STRICT	cd_grupo_material_w,
		cd_subgrupo_material_w,
		cd_classe_material_w
	from	estrutura_material_v
	where	cd_material	= cd_material_p;
	
elsif (cd_procedimento_p IS NOT NULL AND cd_procedimento_p::text <> '') and (ie_origem_proced_p IS NOT NULL AND ie_origem_proced_p::text <> '') then
	
	select	max(cd_area_procedimento),
		max(cd_especialidade),
		max(cd_grupo_proc)
	into STRICT	cd_area_procedimento_w,
		cd_especialidade_w,
		cd_grupo_proc_w
	from	estrutura_procedimento_v
	where	cd_procedimento		= cd_procedimento_p
	and	ie_origem_proced 	= ie_origem_proced_p;

end if;


open C01;
loop
fetch C01 into	
	ie_digitos_desp_w,
	ds_valor_adicional_w;
EXIT WHEN NOT FOUND; /* apply on C01 */
end loop;
close C01;

cd_procedimento_w	:= cd_itemp_p;

if (ie_digitos_desp_w = '1') then
	if (length(trim(both cd_itemp_p)) < 8) then
		cd_procedimento_w	:= lpad(trim(both cd_itemp_p), 8, '0');
	end if;
elsif (ie_digitos_desp_w = '2') then
	if (length(trim(both cd_itemp_p)) < 10) then
		cd_procedimento_w	:= lpad(trim(both cd_itemp_p), 10, '0');
	end if;
elsif (ie_digitos_desp_w = '3') then	
	cd_procedimento_w	:= cd_itemp_p;
elsif (ie_digitos_desp_w = '4') then
	if (length(trim(both cd_itemp_p)) < 8) then
		cd_procedimento_w	:= substr(lpad(trim(both cd_itemp_p), 8, '0'),1,8);
	elsif (length(trim(both cd_itemp_p)) = 9) then
		cd_procedimento_w	:= substr(trim(both cd_itemp_p),2,8);
	elsif (length(trim(both cd_itemp_p)) > 9) then
		cd_procedimento_w	:= substr(trim(both cd_itemp_p),3,8);
	end if;
elsif (ie_digitos_desp_w = '5') then
	if (length(trim(both cd_itemp_p)) < 8) then
		cd_procedimento_w	:= lpad(trim(both cd_itemp_p), 8, ' ');
	end if;
elsif (ie_digitos_desp_w = '6') then
	if (length(trim(both cd_itemp_p)) < 6) then
		cd_procedimento_w	:= substr(lpad(trim(both cd_itemp_p), 6, '0'),1,8);
	elsif (length(trim(both cd_itemp_p)) = 7) then
		cd_procedimento_w	:= substr(trim(both cd_itemp_p),2,7);
	elsif (length(trim(both cd_itemp_p)) > 7) then
		cd_procedimento_w	:= substr(trim(both cd_itemp_p),length(trim(both cd_itemp_p)) - 5,length(trim(both cd_itemp_p)));
	end if;
end if;

if (ds_valor_adicional_w IS NOT NULL AND ds_valor_adicional_w::text <> '') then
	cd_procedimento_w	:= substr( ds_valor_adicional_w || cd_procedimento_w ,1,20);
end if;

if (coalesce(cd_procedimento_w::text, '') = '') then
	cd_procedimento_w := substr(to_char(cd_material_p),1,20);
end if;

return 	cd_procedimento_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION tiss_obter_regra_codigo_desp (cd_estabelecimento_p bigint, cd_convenio_p bigint, ie_tiss_tipo_despesa_p text, cd_itemp_p text, cd_material_p bigint, ie_codigo_tuss_p text, nr_seq_tiss_tabela_p bigint, ie_origem_preco_mat_p bigint default null, cd_procedimento_p bigint default null, ie_origem_proced_p bigint default null) FROM PUBLIC;

