-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION cih_importar_procedimento ( cd_procedimento_p bigint, ie_origem_proced_p bigint) RETURNS varchar AS $body$
DECLARE


cd_area_procedimento_w 	bigint;
cd_especialidade_w	bigint;
cd_grupo_proc_w		bigint;
ie_permite_w		varchar(1);
ie_possui_regra_w		varchar(1);


BEGIN

if (cd_procedimento_p > 0 AND ie_origem_proced_p > 0) then
	select	cd_area_procedimento,
		cd_especialidade,
		cd_grupo_proc
	into STRICT	cd_area_procedimento_w,
		cd_especialidade_w,
		cd_grupo_proc_w
	from	estrutura_procedimento_v
	where	cd_procedimento = cd_procedimento_p
	and	ie_origem_proced = ie_origem_proced_p;
end if;

select	coalesce(max('S'),'N')
into STRICT	ie_possui_regra_w
from	cih_regra_importacao_cir;

if (ie_possui_regra_w = 'S') then
	select	coalesce(max('S'),'N')
	into STRICT	ie_permite_w
	from	cih_regra_importacao_cir
	where ((cd_procedimento IS NOT NULL AND cd_procedimento::text <> '')
	and	coalesce(cd_procedimento,coalesce(cd_procedimento_p,0))			=	coalesce(cd_procedimento_p,0)
	and	coalesce(ie_origem_proced,coalesce(ie_origem_proced_p,0))			=	coalesce(ie_origem_proced_p,0))
	or (coalesce(cd_procedimento::text, '') = ''
	and	coalesce(cd_area_procedimento,coalesce(cd_area_procedimento_w,0))	=	coalesce(cd_area_procedimento_w,0)
	and	coalesce(cd_especialidade,coalesce(cd_especialidade_w,0))			=	coalesce(cd_especialidade_w,0)
	and	coalesce(cd_grupo_proc,coalesce(cd_grupo_proc_w,0))			=	coalesce(cd_grupo_proc_w,0));
else
	ie_permite_w := 'S';
end if;

return ie_permite_w;

end	;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION cih_importar_procedimento ( cd_procedimento_p bigint, ie_origem_proced_p bigint) FROM PUBLIC;

