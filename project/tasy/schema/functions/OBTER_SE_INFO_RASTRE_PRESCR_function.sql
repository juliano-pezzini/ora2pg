-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_se_info_rastre_prescr ( ie_tipo_processo_p text, nm_usuario_p text, cd_perfil_p bigint, cd_estabelecimento_p bigint) RETURNS varchar AS $body$
DECLARE


qt_regra_w			integer;
ie_retorno_w		varchar(1);


BEGIN

qt_regra_w	 			:= 0;
ie_retorno_w	 		:= 'N';

select	count(*)
into STRICT	qt_regra_w
from	info_rastre_prescricao
where	coalesce(cd_estabelecimento,coalesce(cd_estabelecimento_p,0)) = coalesce(cd_estabelecimento_p,0)
and		coalesce(cd_perfil,coalesce(cd_perfil_p,0)) = coalesce(cd_perfil_p,0)
and		((nm_usuario_reg = nm_usuario_p) or (coalesce(nm_usuario_reg::text, '') = ''))
and		clock_timestamp() between dt_inicio and dt_fim
and		ie_tipo_processo = ie_tipo_processo_p;

if (qt_regra_w > 0) then
	ie_retorno_w	:= 'S';
end if;

return ie_retorno_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_se_info_rastre_prescr ( ie_tipo_processo_p text, nm_usuario_p text, cd_perfil_p bigint, cd_estabelecimento_p bigint) FROM PUBLIC;
