-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_medico_sus_aih ( cd_procedimento_p bigint, ie_origem_proced_p bigint, ie_tipo_servico_sus_p bigint, ie_tipo_ato_sus_p bigint, cd_medico_p text) RETURNS varchar AS $body$
DECLARE


cd_medico_w		varchar(10);
ie_exclui_medico_w	varchar(1);
cd_grupo_w		bigint	:= 0;
cd_especialidade_w	bigint	:= 0;
cd_area_w		bigint	:= 0;


BEGIN
cd_medico_w	:= cd_medico_p;

/* Obter Estrutura do procedimento */

select	coalesce(max(cd_grupo_proc),0),
	coalesce(max(cd_especialidade),0),
	coalesce(max(cd_area_procedimento),0)
into STRICT	cd_grupo_w,
	cd_especialidade_w,
	cd_area_w
from	Estrutura_Procedimento_V
where	cd_procedimento		= cd_procedimento_p
and	ie_origem_proced	= ie_origem_proced_p;

select	coalesce(max(ie_exclui_medico),'N')
into STRICT	ie_exclui_medico_w
from	sus_regra_medico_aih
where (ie_tipo_servico_sus	= ie_tipo_servico_sus_p	or coalesce(ie_tipo_servico_sus::text, '') = '')
and (ie_tipo_ato_sus 	= ie_tipo_ato_sus_p 	or coalesce(ie_tipo_ato_sus::text, '') = '')
and (cd_procedimento 	= cd_procedimento_p 	or coalesce(cd_procedimento::text, '') = '')
and (ie_origem_proced 	= ie_origem_proced_p 	or coalesce(ie_origem_proced::text, '') = '')
and (cd_grupo_proc 	= cd_grupo_w 		or coalesce(cd_grupo_proc::text, '') = '')
and (cd_especialidade 	= cd_especialidade_w 	or coalesce(cd_especialidade::text, '') = '')
and (cd_area_procedimento 	= cd_area_w 		or coalesce(cd_area_procedimento::text, '') = '');

if (ie_exclui_medico_w = 'S') then
	cd_medico_w	:= '';
end if;

RETURN	cd_medico_w;

END;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_medico_sus_aih ( cd_procedimento_p bigint, ie_origem_proced_p bigint, ie_tipo_servico_sus_p bigint, ie_tipo_ato_sus_p bigint, cd_medico_p text) FROM PUBLIC;

