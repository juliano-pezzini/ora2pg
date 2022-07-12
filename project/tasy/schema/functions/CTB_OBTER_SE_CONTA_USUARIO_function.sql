-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION ctb_obter_se_conta_usuario ( cd_empresa_p bigint, cd_conta_contabil_p text, nm_usuario_p text) RETURNS varchar AS $body$
DECLARE


cd_conta_contabil_w		varchar(20);
qt_registro_w			bigint;
qt_regra_w			bigint	:= 0;
ie_permite_w			varchar(1);
ie_atualizacao_w			varchar(1);
cd_perfil_w			integer;

c01 CURSOR FOR
SELECT	coalesce(ie_atualizacao,'N')
from	ctb_lib_orc_conta
where	cd_empresa					= cd_empresa_p
and	((nm_usuario_lib				= nm_usuario_p) or (coalesce(nm_usuario_lib::text, '') = ''))
and	((cd_perfil 		= cd_perfil_w) or (coalesce(cd_perfil::text, '') = ''))
and	((((coalesce(ie_conta_inferior,'N') = 'N') and (coalesce(cd_conta_contabil,cd_conta_contabil_w)	= cd_conta_contabil_w)) or
	((ie_conta_inferior = 'S') and (substr(ctb_obter_se_conta_classif(cd_conta_contabil_w,obter_dados_conta_contabil(cd_conta_contabil,null,'CL')),1,1) = 'S'))))
order	by 	nm_usuario_lib desc, cd_perfil	desc;


BEGIN

cd_perfil_w		:= wheb_usuario_pck.get_cd_perfil;

ie_permite_w		:= 'S';
cd_conta_contabil_w	:= coalesce(cd_conta_contabil_p,0);

select	count(*)
into STRICT	qt_regra_w
from	ctb_lib_orc_conta
where	cd_empresa = cd_empresa_p;

if (qt_regra_w > 0) then

	ie_permite_w	:= 'N';

	/* Matheus comentei este retirei o if em 25/09/2008 porque é necessario somente o cursor
	select	count(*)
	into	qt_registro_w
	from	ctb_lib_orc_conta
	where	cd_empresa				= cd_empresa_p
	and	nvl(cd_conta_contabil,cd_conta_contabil_w)	= cd_conta_contabil_w
	and	nm_usuario_lib				= nm_usuario_p;*/
	/* se tiver regra, verifica se pode ou não atualizar o orçamento de todas ou de uma conta*/

	open c01;
	loop
	fetch c01 into
		ie_atualizacao_w;
	EXIT WHEN NOT FOUND; /* apply on c01 */
		begin
		ie_permite_w	:= ie_atualizacao_w;
		end;
	end loop;
	close c01;

end if;
return ie_permite_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION ctb_obter_se_conta_usuario ( cd_empresa_p bigint, cd_conta_contabil_p text, nm_usuario_p text) FROM PUBLIC;
