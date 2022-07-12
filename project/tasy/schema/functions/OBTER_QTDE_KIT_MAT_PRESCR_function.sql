-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_qtde_kit_mat_prescr ( cd_material_p bigint, cd_estabelecimento_p bigint, ie_tipo_atendimento_p bigint, cd_setor_atendimento_p bigint) RETURNS bigint AS $body$
DECLARE


qt_kit_w	bigint:=0;


BEGIN

select	count(*)
into STRICT	qt_kit_w
from	kit_mat_prescricao
where	cd_material		= cd_material_p
and	cd_estabelecimento	= cd_estabelecimento_p
and	coalesce(ie_tipo_atendimento,ie_tipo_atendimento_p)	= ie_tipo_atendimento_p
and	coalesce(cd_setor_atendimento,cd_setor_atendimento_p)= cd_setor_atendimento_p
order by 	coalesce(ie_tipo_atendimento,0),
		coalesce(cd_setor_atendimento,0);

return	qt_kit_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_qtde_kit_mat_prescr ( cd_material_p bigint, cd_estabelecimento_p bigint, ie_tipo_atendimento_p bigint, cd_setor_atendimento_p bigint) FROM PUBLIC;

